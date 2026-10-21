this.enterprise_white_eagle_airwing_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function owner() { return this.getContainer().getActor(); }
	function ensureDisplay()
	{
		local state = ::$bvvar{namespace}.getEnterpriseState(this.owner());
		if (state == null || !state.Active) return;
		if (!this.getContainer().hasSkill("$bvvar{modId}.effects.enterprise_sortie_points"))
			this.getContainer().add(::new("$bvvar{privateFolder}/skills/effects/enterprise_sortie_points_effect"));
	}
	function onAdded() { this.ensureDisplay(); }
	function onCombatStarted() { ::$bvvar{namespace}.startEnterpriseCombat(this.owner()); this.ensureDisplay(); }
	function onTurnStart() { ::$bvvar{namespace}.advanceEnterpriseTurn(this.owner()); this.ensureDisplay(); }
	function onDeath(_fatalityType) { ::$bvvar{namespace}.stopEnterpriseCombat(this.owner()); }
	function onCombatFinished() { ::$bvvar{namespace}.stopEnterpriseCombat(this.owner()); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="skills/$bvvar{iconPrefix}/enterprise_sortie_points.png",text=::$bvvar{namespace}.getEnterpriseStateText(this.owner())}];
	}
});
