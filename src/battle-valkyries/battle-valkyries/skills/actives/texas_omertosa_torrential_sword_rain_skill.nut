this.texas_omertosa_torrential_sword_rain_skill <- this.inherit("$bvvar{privateFolder}/skills/core/texas_omertosa_execution_skill", {
	function create()
	{
		this.texas_omertosa_execution_skill.create();
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.texas_omertosa_torrential_sword_rain.tooltip.cut_in}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.texas_omertosa_torrential_sword_rain.tooltip.entry}" },
			{ id = 6, type = "text", icon = "ui/icons/stunned.png", text = "$bv{skill.texas_omertosa_torrential_sword_rain.tooltip.control}" },
			{ id = 7, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.texas_omertosa_torrential_sword_rain.tooltip.rain}" }
		];
		local tradition = this.getTradition();
		if (tradition != null && !tradition.isCutInReady()) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.texas_omertosa_shared.tooltip.cooldown}" });
		return ret;
	}

	function applyControl( _user, _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return false;
		local immune = false;
		try { immune = _target.getCurrentProperties().IsImmuneToStun; } catch (e) {}
		local effect = null;
		if (!immune)
		{
			effect = _target.getSkills().getSkillByID("effects.stunned");
			if (effect == null) { effect = this.new("scripts/skills/effects/stunned_effect"); _target.getSkills().add(effect); }
			effect.setTurns(1);
		}
		else
		{
			effect = _target.getSkills().getSkillByID("effects.dazed");
			if (effect == null) _target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
			else if ("onRefresh" in effect) effect.onRefresh();
		}
		return true;
	}

	function executeEntry( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user)) return false;
		local targets = this.getAdjacentEnemies(_user);
		foreach (target in targets)
		{
			if (!this.canResolveCutIn(_user)) break;
			if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, target, 1, true)) continue;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "texas_sword_rain");
			local hit = false;
			for (local i = 0; i < 2; i++)
			{
				if (!this.canResolveCutIn(_user) || !::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, target, 1, true)) break;
				local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
					WeaponDamageMult = 0.70, ArmorDamageMult = 1.0, DirectDamageAdd = 0.20,
					HitChance = 30, IgnoreDistance = true, Source = "texas_sword_rain_entry"
				});
				if (result != null && "Hit" in result && result.Hit) hit = true;
			}
			if (hit && this.canResolveCutIn(_user)) this.applyControl(_user, target);
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
		return this.performCutIn(_user, target, "sword_rain");
	}
});
