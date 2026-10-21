this.valkyrie_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_runtime_skill", {
	function create()
	{
		this.valkyrie_runtime_skill.create();
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder();
		this.m.IsActive = true;
	}
});
