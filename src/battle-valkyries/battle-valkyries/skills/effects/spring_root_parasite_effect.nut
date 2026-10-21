this.spring_root_parasite_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Source = null, Remaining = 3, LastRound = -1 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.spring_root_parasite";
		this.m.Name = "$bv{effect.spring.parasite.name}"; this.m.Description = "$bv{effect.spring.parasite.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/root_parasite.png"; this.m.IconMini = "status_effect_34_mini";
		this.m.IsStacking = false;
	}
	function getSource() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Source); }
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
	function onTurnStart()
	{
		local target = this.getContainer().getActor(), source = this.getSource(), bv = ::$bvvar{namespace};
		if (source == null || bv.isActorDeadOrDying(source) || !source.isPlacedOnMap() || source.isAlliedWith(target)) { this.removeSelf(); return; }
		if (bv.isActorDeadOrDying(target) || bv.springExtraTurn(target) || this.m.LastRound == ::Time.getRound()) return;
		this.m.LastRound = ::Time.getRound();
		local before = target.getHitpoints();
		bv.applyValkyrieFixedHitpointDamage(source, this, target, 8);
		local lost = ::Math.max(0, before - ::Math.max(0, target.getHitpoints()));
		if (!bv.isActorDeadOrDying(source) && lost > 0) { source.setHitpoints(::Math.min(source.getHitpointsMax(), source.getHitpoints() + lost)); source.setDirty(true); }
		if (--this.m.Remaining <= 0) this.removeSelf();
	}
	function onCombatFinished() { this.removeSelf(); }
});
