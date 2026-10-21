this.c_c_immortal_witch_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function onUpdate(p) { p.Hitpoints += 30; }
	function onBeforeDamageReceived(a,s,h,p)
	{
		local state=::$bvvar{namespace}.getCCState(this.getContainer().getActor());
		if (state != null && state.Active && state.Protected && ::$bvvar{namespace}.isDirectAttack(s)) p.DamageReceivedTotalMult *= 0.5;
	}
	function onCombatStarted() { ::$bvvar{namespace}.startCCCombat(this.getContainer().getActor()); }
	function onCombatFinished() { ::$bvvar{namespace}.stopCCCombat(this.getContainer().getActor()); this.skill.onCombatFinished(); }
	function onDeath(t) { ::$bvvar{namespace}.stopCCCombat(this.getContainer().getActor()); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.getCCStateText(this.getContainer().getActor())}]; }
});
