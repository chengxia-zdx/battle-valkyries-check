this.sword_maiden_light_in_darkness_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { HasKilledThisTurn = false, NextAttackReady = false, GoblinAPRestored = false },
	function create() { this.valkyrie_passive_skill.create(); }
	function resetTurn() { this.m.HasKilledThisTurn=false; this.m.NextAttackReady=false; this.m.GoblinAPRestored=false; }
	function onTurnStart() { this.resetTurn(); }
	function onCombatStarted() { this.resetTurn(); }
	function onCombatFinished() { this.resetTurn(); this.skill.onCombatFinished(); }

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (!this.m.NextAttackReady || _properties == null || !::$bvvar{namespace}.isActiveWeaponAttack(_skill)) return;
		this.m.NextAttackReady = false;
		_properties.MeleeSkill += 25;
		_properties.RangedSkill += 25;
		_properties.DamageTotalMult *= 1.25;
	}

	function onTargetKilled( _target, _skill )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || _target == null || _target.isAlliedWith(actor) || _skill == null || !_skill.isAttack()) return;
		if (!this.m.HasKilledThisTurn)
		{
			this.m.HasKilledThisTurn = true;
			this.m.NextAttackReady = true;
		}
		if (!this.m.GoblinAPRestored && ::$bvvar{namespace}.isSwordMaidenGoblin(_target))
		{
			this.m.GoblinAPRestored = true;
			actor.setActionPoints(actor.getActionPointsMax());
			actor.setDirty(true);
		}
	}

	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/action_points.png", text="$bv{skill.sword_maiden_light_in_darkness.tooltip.free}" },
			{ id=4, type="text", icon="ui/icons/hitchance.png", text="$bv{skill.sword_maiden_light_in_darkness.tooltip.followup}" },
			{ id=5, type="text", icon="ui/icons/special.png", text="$bv{skill.sword_maiden_light_in_darkness.tooltip.goblin}" }
		];
	}
});
