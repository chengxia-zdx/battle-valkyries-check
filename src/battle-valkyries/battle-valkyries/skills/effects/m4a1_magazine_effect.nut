this.m4a1_magazine_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.IsStacking = false;
		this.m.ID = "$bvvar{modId}.effects.m4a1_magazine";
		this.m.Name = "$bv{effect.m4a1_magazine.name}"; this.m.Description = "$bv{effect.m4a1_magazine.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/m4a1_magazine.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/m4a1_magazine_sw.png";
	}
	function getTooltip()
	{
		local state = ::$bvvar{namespace}.getM4A1State(this.getContainer().getActor());
		local ret = [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="skills/$bvvar{iconPrefix}/m4a1_standard_ammo.png",text=::$bvvar{namespace}.getM4A1AmmoText(state)}];
		if (state != null && state.Active && state.Turn <= state.FocusUntil)
			ret.push({id=4,type="text",icon="skills/$bvvar{iconPrefix}/m4a1_firepower_focus.png",text="$bv{m4a1.state.focus}"});
		return ret;
	}
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }
});
