this.m4a1_inheritor_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="skills/$bvvar{iconPrefix}/m4a1_cannon_charge.png",text=::$bvvar{namespace}.getM4A1AmmoText(::$bvvar{namespace}.getM4A1State(this.getContainer().getActor()))}];
	}
});
