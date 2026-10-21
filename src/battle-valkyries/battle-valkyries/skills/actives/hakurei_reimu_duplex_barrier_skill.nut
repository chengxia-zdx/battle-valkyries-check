this.hakurei_reimu_duplex_barrier_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { UsedThisTurn = false, DefenseBonus = 20, HitpointReduction = 25 },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 4;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
		this.m.UsedThisTurn = false;
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition == null || !("Spec" in _definition)) return;
		local spec = _definition.Spec;
		if ("ActionPointCost" in spec) this.m.ActionPointCost = spec.ActionPointCost;
		if ("FatigueCost" in spec) this.m.FatigueCost = spec.FatigueCost;
		if ("MaxRange" in spec) this.m.MaxRange = spec.MaxRange;
		if ("DefenseBonus" in spec) this.m.DefenseBonus = spec.DefenseBonus;
		if ("HitpointReduction" in spec) this.m.HitpointReduction = spec.HitpointReduction;
	}

	function getPassive()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "hakurei_reimu_inborn_intuition");
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.UsedThisTurn && this.getPassive() != null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		if (owner == null || target == null || ::$bvvar{namespace}.isActorDeadOrDying(target)) return false;
		try
		{
			return owner.isAlliedWith(target) && target.isAttackable()
				&& owner.getTile().getDistanceTo(target.getTile()) <= this.m.MaxRange;
		}
		catch (e) { return false; }
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		local passive = this.getPassive();
		if (passive == null) return false;
		local c = target.getSkills();
		local old = c.getSkillByID("$bvvar{modId}.effects.hakurei_reimu_duplex_barrier");
		if (old != null) c.remove(old);
		local effect = ::new("$bvvar{privateFolder}/skills/effects/hakurei_reimu_duplex_barrier_effect");
		effect.configure(_user, this.m.DefenseBonus, this.m.HitpointReduction);
		c.add(effect);
		passive.trackBarrier(effect);
		this.m.UsedThisTurn = true;
		if (target.isPlacedOnMap()) effect.spawnIcon("status_effect_88", target.getTile());
		return true;
	}

	function onTurnStart() { this.m.UsedThisTurn = false; }
	function onCombatStarted() { this.m.UsedThisTurn = false; }
	function onCombatFinished() { this.m.UsedThisTurn = false; this.skill.onCombatFinished(); }

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/melee_defense.png", text = "$bv{skill.hakurei_reimu_duplex_barrier.tooltip.outer}" },
			{ id = 5, type = "text", icon = "ui/icons/health.png", text = "$bv{skill.hakurei_reimu_duplex_barrier.tooltip.inner}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.hakurei_reimu_duplex_barrier.tooltip.layers}" }
		];
		if (this.m.UsedThisTurn) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.hakurei_reimu_duplex_barrier.tooltip.used}" });
		return ret;
	}
});
