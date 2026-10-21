this.enterprise_grey_ghost_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.IsStacking = false;
		this.m.ID = "$bvvar{modId}.effects.enterprise_grey_ghost";
		this.m.Name = "$bv{effect.enterprise_grey_ghost.name}"; this.m.Description = "$bv{effect.enterprise_grey_ghost.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/enterprise_grey_ghost.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/enterprise_grey_ghost_sw.png";
		this.m.IconMini = "status_effect_34_mini";
	}
	function isHidden()
	{
		local s = ::$bvvar{namespace}.getEnterpriseState(this.getContainer().getActor());
		return s == null || !s.Active || !s.Ghost;
	}
	function getValkyrieAttackNullificationPolicy(_skill, _attacker)
	{
		local owner = this.getContainer().getActor();
		if (this.isHidden() || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap()
			|| _attacker == null || owner.isAlliedWith(_attacker) || !::$bvvar{namespace}.isDirectAttack(_skill)) return null;
		return {NullifyDirectAttack=true, ConsumeToken="enterprise_grey_ghost"};
	}
	function consumeValkyrieAttackNullificationPolicy(_token, _context)
	{
		if (_token != "enterprise_grey_ghost" || this.isHidden()) return;
		local owner = this.getContainer().getActor();
		::$bvvar{namespace}.getEnterpriseState(owner).Ghost = false;
		::$bvvar{namespace}.playValkyrieVisual(this, owner, "enterprise_ghost_guard");
		::$bvvar{namespace}.playValkyrieSkillAudio(owner, "enterprise_grey_ghost_evade");
	}
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
