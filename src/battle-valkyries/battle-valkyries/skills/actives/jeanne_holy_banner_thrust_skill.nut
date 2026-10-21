this.jeanne_holy_banner_thrust_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsRanged = false;
		this.m.IsUsingHitchance = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 99;
	}

	function getActor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }

	function isUsable()
	{
		local actor = this.getActor();
		return this.skill.isUsable()
			&& actor != null
			&& ::$bvvar{namespace}.getActorValkyrieID(actor) == "jeanne"
			&& ::$bvvar{namespace}.hasJeanneEternalStandardEquipped(actor)
			&& !::$bvvar{namespace}.isValkyrieSkillUseBlocked(this);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.getActor(), _targetTile.getEntity(), this.m.MaxRange, true);
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "jeanne_holy_banner_thrust_cast");
		::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, _targetTile.getEntity(), {
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.0,
			DirectDamageAdd = 0.0,
			HitChance = 10,
			IgnoreDistance = true,
			IgnoreShield = false,
			Source = "jeanne_holy_banner_thrust"
		});
		return true;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/ranged_skill.png", text = "$bv{skill.jeanne_holy_banner_thrust.tooltip.range}" },
			{ id = 5, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.jeanne_holy_banner_thrust.tooltip.hit}" },
			{ id = 6, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.jeanne_holy_banner_thrust.tooltip.damage}" }
		];
		if (!::$bvvar{namespace}.hasJeanneEternalStandardEquipped(this.getActor()))
		{
			ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.jeanne_eternal_standard.tooltip.required}" });
		}
		return ret;
	}
});
