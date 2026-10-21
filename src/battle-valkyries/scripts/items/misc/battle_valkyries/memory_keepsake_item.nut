this.memory_keepsake_item <- this.inherit("scripts/items/item", {
	m = {
		MemoryKind = "stat",
		MemoryAttribute = null,
		MemoryAmount = 0,
		MemoryEffectText = ""
	},

	function create()
	{
		this.item.create();
		this.m.ID = "$bvvar{modId}.misc.memory_keepsake";
		this.m.Name = "$bv{item.memory_keepsake.name}";
		this.m.Description = "$bv{item.memory_keepsake.description}";
		this.m.Categories = "$bv{item.memory_keepsake.category}";
		this.m.Icon = "consumables/vial_blue_01.png";
		this.m.IconLarge = this.m.Icon;
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = false;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IsSellable = false;
		this.m.Value = 1000;
	}

	function configureMemoryKeepsake( _id, _name, _description, _effectText, _kind, _attribute = null, _amount = 0, _icon = null )
	{
		this.m.ID = "$bvvar{modId}.misc.memory_" + _id;
		this.m.Name = _name;
		this.m.Description = _description;
		this.m.rawset("MemoryEffectText", _effectText);
		this.m.rawset("MemoryKind", _kind);
		this.m.rawset("MemoryAttribute", _attribute);
		this.m.rawset("MemoryAmount", _amount);
		if (_icon != null)
		{
			this.m.Icon = _icon;
			this.m.IconLarge = _icon;
		}
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 66,
				type = "text",
				text = this.getValueString()
			},
			{
				id = 3,
				type = "image",
				image = this.getIconLarge() != null ? this.getIconLarge() : this.getIcon(),
				isLarge = this.getIconLarge() != null
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = this.m.MemoryEffectText
			},
			{
				id = 65,
				type = "text",
				text = this.m.MemoryKind == "bond" ? "$bv{item.memory_keepsake.tooltip.use_bond}" : "$bv{item.memory_keepsake.tooltip.use_character}"
			}
		];
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function isValidMemoryKeepsakeTarget( _actor )
	{
		if (_actor == null) return false;
		try { if (_actor.getSkills() == null) return false; } catch (e) { return false; }
		try { if (!_actor.isAlive()) return false; } catch (e) { return false; }
		try { if (_actor.isDying()) return false; } catch (e) { try { if (_actor.m.IsDying) return false; } catch (ignored) {} }
		try { if (_actor.getHitpoints() <= 0) return false; } catch (e) { return false; }
		try { if (_actor.getBackground() == null) return false; } catch (e) { return false; }
		return true;
	}

	function useStatKeepsake( _actor )
	{
		if (!this.isValidMemoryKeepsakeTarget(_actor) || this.m.MemoryAttribute == null || this.m.MemoryAmount <= 0) return false;
		local properties = null;
		try { properties = _actor.getBaseProperties(); } catch (e) {}
		if (properties == null || !(this.m.MemoryAttribute in properties)) return false;

		local oldHitpoints = 0;
		try { oldHitpoints = _actor.getHitpoints(); } catch (e) {}
		properties[this.m.MemoryAttribute] += this.m.MemoryAmount;
		_actor.getSkills().update();
		if (this.m.MemoryAttribute == "Hitpoints")
		{
			try { _actor.setHitpoints(::Math.min(_actor.getHitpointsMax(), oldHitpoints + this.m.MemoryAmount)); } catch (e) {}
		}
		try { _actor.setDirty(true); } catch (e) {}
		return true;
	}

	function useLevelKeepsake( _actor )
	{
		if (!this.isValidMemoryKeepsakeTarget(_actor)) return false;
		local oldLevel = 0;
		try { oldLevel = _actor.getLevel(); } catch (e) { return false; }
		if (oldLevel >= this.Const.LevelXP.len()) return false;

		local threshold = this.Const.LevelXP[oldLevel];
		if (_actor.m.XP < threshold) _actor.m.XP = threshold;
		_actor.updateLevel();
		if (_actor.getLevel() != oldLevel + 1) return false;
		try { _actor.setDirty(true); } catch (e) {}
		return true;
	}

	function useBondKeepsake( _actor )
	{
		if (_actor == null || _actor.getSkills() == null) return false;
		if ("OlgaCorruption" in ::$bvvar{namespace} && ::$bvvar{namespace}.Olga.supported(_actor))
			return ::$bvvar{namespace}.OlgaCorruption.addFromBondItem(_actor, this.m.MemoryAmount) > 0;
		if ("BlackBeastCorruption" in ::$bvvar{namespace} && ::$bvvar{namespace}.BlackBeast.supported(_actor))
			return ::$bvvar{namespace}.BlackBeastCorruption.addFromBondItem(_actor, this.m.MemoryAmount) > 0;
		local trait = ::$bvvar{namespace}.findValkyrieBondTraitForActor(_actor);
		if (trait == null || trait.getBond() >= 100) return false;
		local added = trait.addBond(this.m.MemoryAmount);
		if (added <= 0) return false;
		::$bvvar{namespace}.requestValkyrieBondEventCheckForTrait(trait);
		return true;
	}

	function usePerkKeepsake( _actor )
	{
		if (!this.isValidMemoryKeepsakeTarget(_actor) || this.m.MemoryAmount <= 0) return false;
		if (!("PerkPoints" in _actor.m)) return false;
		_actor.m.PerkPoints += this.m.MemoryAmount;
		try { _actor.setDirty(true); } catch (e) {}
		return true;
	}

	function onUse( _actor, _item = null )
	{
		local success = false;
		if (this.m.MemoryKind == "stat") success = this.useStatKeepsake(_actor);
		else if (this.m.MemoryKind == "level") success = this.useLevelKeepsake(_actor);
		else if (this.m.MemoryKind == "bond") success = this.useBondKeepsake(_actor);
		else if (this.m.MemoryKind == "perk") success = this.usePerkKeepsake(_actor);
		if (!success) return false;
		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		return true;
	}
});
