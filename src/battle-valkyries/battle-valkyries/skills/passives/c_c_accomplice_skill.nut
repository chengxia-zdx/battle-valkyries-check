this.c_c_accomplice_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function onCombatStarted() { ::$bvvar{namespace}.startCCCombat(this.getContainer().getActor()); }
	function onValkyrieCombatEvent(e) { ::$bvvar{namespace}.onCCCombatEvent(this.getContainer().getActor(),e); }
	function onCombatFinished() { ::$bvvar{namespace}.stopCCCombat(this.getContainer().getActor()); this.skill.onCombatFinished(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.getCCStateText(this.getContainer().getActor())}]; }
});
