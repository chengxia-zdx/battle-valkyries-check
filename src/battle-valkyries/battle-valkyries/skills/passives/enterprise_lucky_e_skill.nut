this.enterprise_lucky_e_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function rollForSortie()
	{
		local owner = this.getContainer().getActor(), state = ::$bvvar{namespace}.getEnterpriseState(owner);
		if (state == null || !state.Active || ::$bvvar{namespace}.isActorDeadOrDying(owner) || ::Math.rand(1, 100) > 70) return false;
		state.Ghost = true;
		if (!owner.getSkills().hasSkill("$bvvar{modId}.effects.enterprise_grey_ghost"))
			owner.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/enterprise_grey_ghost_effect"));
		::$bvvar{namespace}.playValkyrieVisual(this, owner, "enterprise_lucky_flash");
		::$bvvar{namespace}.playValkyrieSkillAudio(owner, "enterprise_lucky_e_apply");
		return true;
	}
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
