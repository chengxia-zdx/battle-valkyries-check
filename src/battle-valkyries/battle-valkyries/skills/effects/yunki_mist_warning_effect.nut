this.yunki_mist_warning_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.yunki_mist_warning";
		this.m.Name = "$bv{effect.yunki_mist_warning.name}"; this.m.Description = "$bv{effect.yunki_mist_warning.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/yunki_nightmare.png"; this.m.IconMini <- "status_effect_54_mini";
	}
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
	function onCombatFinished() { this.removeSelf(); }
});
