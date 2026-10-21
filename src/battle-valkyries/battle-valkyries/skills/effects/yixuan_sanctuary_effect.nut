this.yixuan_sanctuary_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Remaining = 40 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.yixuan_sanctuary";
		this.m.Name = "$bv{skill.yixuan_sanctuary.name}"; this.m.Description = "$bv{effect.yixuan_sanctuary.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/yixuan_sanctuary.png"; this.m.IconMini <- "status_effect_56_mini"; this.m.IsStacking = false;
	}
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/hitpoints.png", text = "$bv{effect.yixuan_sanctuary.remaining}" + this.m.Remaining }]; }
	function onCombatFinished() { this.removeSelf(); }
});
