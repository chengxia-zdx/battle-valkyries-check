this.grey_falcon_command_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { LastRound = -1, Mark = null },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.grey_falcon_command";
		this.m.Name = "$bv{enemy.grey_falcon.focus.name}"; this.m.Description = "$bv{enemy.grey_falcon.focus.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/m4a1_focus_target.png";
	},
	function clearOrder()
	{
		if (this.m.Mark != null) this.m.Mark.removeSelf();
		this.m.Mark = null;
	},
	function onTurnStart()
	{
		local owner = this.getContainer().getActor();
		if (::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap()) { this.clearOrder(); return; }
		if (this.m.LastRound == ::Time.getRound()) return;
		this.m.LastRound = ::Time.getRound(); this.clearOrder();
		if (!owner.getCurrentProperties().IsAbleToUseSkills || owner.getMoraleState() == ::Const.MoraleState.Fleeing) return;
		local chosen = null, distance = 999;
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner, ::$bvvar{namespace}.getValkyrieRadiusTiles(owner.getTile(), 7, true)))
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(target) || !target.isPlacedOnMap() || target.isAlliedWith(owner)
				|| target.isHiddenToPlayer() || !owner.getTile().hasLineOfSightTo(target.getTile(), 7)) continue;
			local d = owner.getTile().getDistanceTo(target.getTile());
			if (d > 7) continue;
			if (chosen == null || d < distance || (d == distance && target.getID() < chosen.getID())) { chosen = target; distance = d; }
		}
		if (chosen == null) return;
		local mark = this.new("$bvvar{privateFolder}/skills/effects/grey_falcon_focus_effect");
		mark.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(owner); mark.m.Round = ::Time.getRound();
		chosen.getSkills().add(mark); this.m.Mark = mark;
		mark.spawnIcon("status_effect_74", chosen.getTile());
	},
	function onDeath(fatality) { this.clearOrder(); },
	function onCombatFinished() { this.clearOrder(); },
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
