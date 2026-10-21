this.jeanne_holy_banner_sweep_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
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
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 24;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.getActor(), _targetTile.getEntity(), 1, true);
	}

	function getSweepTiles( _user, _targetTile )
	{
		local ret = [];
		if (_user == null || _targetTile == null) return ret;
		local originTile = _user.getTile();
		local direction = originTile.getDirectionTo(_targetTile);
		foreach( offset in [-1, 0, 1] )
		{
			local nextDirection = (direction + offset + 6) % 6;
			if (originTile.hasNextTile(nextDirection)) ret.push(originTile.getNextTile(nextDirection));
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local targets = ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, this.getSweepTiles(_user, _targetTile));
		if (targets.len() > 0 && "playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "jeanne_holy_banner_sweep_cast");
		foreach( target in targets )
		{
			::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
				WeaponDamageMult = 0.80,
				ArmorDamageMult = 1.0,
				DirectDamageAdd = 0.0,
				HitChance = -5,
				IgnoreDistance = true,
				IgnoreShield = false,
				Source = "jeanne_holy_banner_sweep"
			});
		}
		return true;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.jeanne_holy_banner_sweep.tooltip.area}" },
			{ id = 5, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.jeanne_holy_banner_sweep.tooltip.hit}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.jeanne_holy_banner_sweep.tooltip.rules}" }
		];
		if (!::$bvvar{namespace}.hasJeanneEternalStandardEquipped(this.getActor()))
		{
			ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.jeanne_eternal_standard.tooltip.required}" });
		}
		return ret;
	}
});
