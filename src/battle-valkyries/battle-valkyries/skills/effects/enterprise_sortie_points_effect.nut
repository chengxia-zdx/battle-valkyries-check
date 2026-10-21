this.enterprise_sortie_points_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.IsStacking = false;
		this.m.ID = "$bvvar{modId}.effects.enterprise_sortie_points";
		this.m.Name = "$bv{effect.enterprise_sortie_points.name}"; this.m.Description = "$bv{effect.enterprise_sortie_points.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/enterprise_sortie_points.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/enterprise_sortie_points_sw.png";
		this.m.IconMini = "status_effect_34_mini";
	}
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.getEnterpriseStateText(this.getContainer().getActor())}];
	}
});
