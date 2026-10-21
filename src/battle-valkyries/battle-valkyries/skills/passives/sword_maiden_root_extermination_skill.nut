this.sword_maiden_root_extermination_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { TriggersThisTurn = 0, CondemnationResetThisTurn = false },
	function create() { this.valkyrie_passive_skill.create(); }
	function resetTurn() { this.m.TriggersThisTurn = 0; this.m.CondemnationResetThisTurn = false; }
	function onTurnStart() { this.resetTurn(); }
	function onCombatStarted() { this.resetTurn(); }
	function onCombatFinished() { this.resetTurn(); this.skill.onCombatFinished(); }

	function onTargetKilled( _target, _skill )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || _target == null || _target.isAlliedWith(actor) || _skill == null || !_skill.isAttack()) return;
		local goblin = ::$bvvar{namespace}.isSwordMaidenGoblin(_target);
		if (this.m.TriggersThisTurn > 0 && (!goblin || this.m.TriggersThisTurn >= 2)) return;
		this.m.TriggersThisTurn++;
		actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 4));
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - 12));
		if (!this.m.CondemnationResetThisTurn)
		{
			local active = ::$bvvar{namespace}.getRuntimeSkillByKey(actor, "sword_maiden_balance_condemnation");
			if (active != null && "resetByRootExtermination" in active) active.resetByRootExtermination();
			this.m.CondemnationResetThisTurn = true;
		}
		actor.setDirty(true);
	}

	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/action_points.png", text="$bv{skill.sword_maiden_root_extermination.tooltip.refund}" },
			{ id=4, type="text", icon="ui/icons/special.png", text="$bv{skill.sword_maiden_root_extermination.tooltip.goblin}" }
		];
	}
});
