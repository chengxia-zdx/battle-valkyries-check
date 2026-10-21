this.himeko_astral_lance_strike_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.himeko_astral_lance_strike.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 12;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getEquippedLance()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getItems() == null) return null;
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (weapon == null) return null;
		try
		{
			return weapon.getID() == ::$bvvar{namespace}.HimekoAstralLanceItemID ? weapon : null;
		}
		catch (e)
		{
			return null;
		}
	}

	function bindEquippedLance()
	{
		local weapon = this.getEquippedLance();
		if (weapon == null)
		{
			this.setItem(null);
			return null;
		}

		// The skill is granted through the transient skill service instead of
		// weapon.addSkill(), so bind the real item explicitly for vanilla and
		// Legends weapon-skill hooks.
		this.setItem(weapon);
		this.m.DirectDamageMult = weapon.m.DirectDamageMult;
		return weapon;
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable()
			&& actor != null
			&& ::$bvvar{namespace}.getActorValkyrieID(actor) == "himeko"
			&& this.bindEquippedLance() != null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile)
			&& _targetTile != null
			&& _targetTile.IsOccupiedByActor
			&& !this.getContainer().getActor().isAlliedWith(_targetTile.getEntity());
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/ranged_skill.png", text = "$bv{skill.himeko_astral_lance_strike.tooltip.range}" },
			{ id = 5, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.himeko_astral_lance_strike.tooltip.damage}" }
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this || _properties == null) return;
		local weapon = this.bindEquippedLance();
		if (weapon == null) return;
		_properties.MeleeSkill += weapon.getAdditionalAccuracy();
	}

	function onUse( _user, _targetTile )
	{
		if (this.bindEquippedLance() == null) return false;
		return this.attackEntity(_user, _targetTile.getEntity());
	}
});
