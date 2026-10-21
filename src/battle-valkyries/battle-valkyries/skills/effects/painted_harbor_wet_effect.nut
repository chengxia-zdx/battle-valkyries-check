this.painted_harbor_wet_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.painted_harbor_wet";
		this.m.Name = "$bv{enemy.painted_harbor.wet.name}"; this.m.Description = "$bv{enemy.painted_harbor.wet.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/painted_harbor_human_stroke.png"; this.m.IconMini = "status_effect_54_mini";
	},
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
});
