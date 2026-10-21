this.texas_omertosa_unrelenting_downpour_skill <- this.inherit("$bvvar{privateFolder}/skills/core/texas_omertosa_execution_skill", {
	function create()
	{
		this.texas_omertosa_execution_skill.create();
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.texas_omertosa_unrelenting_downpour.tooltip.cut_in}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.texas_omertosa_unrelenting_downpour.tooltip.entry}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.texas_omertosa_unrelenting_downpour.tooltip.erosion}" },
			{ id = 7, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.texas_omertosa_unrelenting_downpour.tooltip.followup}" }
		];
		local tradition = this.getTradition();
		if (tradition != null && !tradition.isCutInReady()) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.texas_omertosa_shared.tooltip.cooldown}" });
		return ret;
	}

	function addRainErosion( _user, _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target) || _target.getSkills() == null) return null;
		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.texas_omertosa_rain_erosion");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/texas_omertosa_rain_erosion_effect");
			effect.setupOwner(_user);
			_target.getSkills().add(effect);
		}
		else
		{
			effect.setupOwner(_user);
			effect.onRefresh();
		}
		return effect;
	}

	function executeEntry( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user)) return false;
		local targets = this.getAdjacentEnemies(_user);
		foreach (target in targets)
		{
			if (!this.canResolveCutIn(_user)) break;
			if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, target, 1, true)) continue;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "texas_downpour_slash");
			::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
				WeaponDamageMult = 1.20, ArmorDamageMult = 1.50, DirectDamageAdd = 0.30,
				HitChance = 25, IgnoreDistance = true, Source = "texas_downpour_entry"
			});
			if (this.canResolveCutIn(_user)) this.addRainErosion(_user, target);
		}
		return targets.len() > 0;
	}

	function replayEntry( _user )
	{
		return this.executeEntry(_user);
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		return this.performCutIn(_user, target, "downpour");
	}
});
