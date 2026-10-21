this.yuno_destined_hunt_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.yuno_destined_hunt.tooltip.hit}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.yuno_destined_hunt.tooltip.damage}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.yuno_destined_hunt.tooltip.duration}" }
		];
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
	}
});
