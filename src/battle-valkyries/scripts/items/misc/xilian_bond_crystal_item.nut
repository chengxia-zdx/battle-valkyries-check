this.xilian_bond_crystal_item <- this.inherit("scripts/items/item", {
	m = {},

	function create()
	{
		this.item.create();
		this.m.ID = "$bvvar{modId}.misc.xilian_bond_crystal";
		this.m.Name = "$bv{item.xilian_bond_crystal.name}";
		this.m.Description = "$bv{item.xilian_bond_crystal.description}";
		this.m.Categories = "$bv{item.xilian_bond_crystal.category}";
		this.m.Icon = "$bvvar{iconPrefix}/xilian_bond_crystal.png";
		this.m.IconLarge = this.m.Icon;
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = false;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 500;
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
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{item.xilian_bond_crystal.tooltip.effect}"
		});
		result.push({
			id = 65,
			type = "text",
			text = "$bv{item.xilian_bond_crystal.tooltip.use}"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		if (_actor == null || _actor.getSkills() == null)
		{
			return false;
		}

		local trait = null, added = 0;
		if ("OlgaCorruption" in ::$bvvar{namespace} && ::$bvvar{namespace}.Olga.supported(_actor))
		{
			added = ::$bvvar{namespace}.OlgaCorruption.addFromBondItem(_actor, 20);
		}
		else if ("BlackBeastCorruption" in ::$bvvar{namespace} && ::$bvvar{namespace}.BlackBeast.supported(_actor))
		{
			added = ::$bvvar{namespace}.BlackBeastCorruption.addFromBondItem(_actor, 20);
		}
		else
		{
			trait = ::$bvvar{namespace}.findValkyrieBondTraitForActor(_actor);
			if (trait == null || trait.getBond() >= 100) return false;
			added = trait.addBond(20);
		}

		if (added <= 0)
		{
			return false;
		}

		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		if (trait != null) ::$bvvar{namespace}.requestValkyrieBondEventCheckForTrait(trait);
		return true;
	}
});
