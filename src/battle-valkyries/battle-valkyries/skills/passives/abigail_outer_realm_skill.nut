this.abigail_outer_realm_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function owner() { return this.getContainer().getActor(); }
	function getName() { return this.m.Name+" ("+::$bvvar{namespace}.getAbigailStateText(this.owner())+")"; }
	function onCombatStarted() { ::$bvvar{namespace}.startAbigailCombat(this.owner()); }
	function onDeath(fatality) { ::$bvvar{namespace}.stopAbigailCombat(this.owner()); }
	function onCombatFinished() { ::$bvvar{namespace}.stopAbigailCombat(this.owner());this.skill.onCombatFinished(); }
	function ignoresShieldFor(skill) { return ::$bvvar{namespace}.isAbigailSpell(skill); }
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.getAbigailStateText(this.owner())}];
	}
});
