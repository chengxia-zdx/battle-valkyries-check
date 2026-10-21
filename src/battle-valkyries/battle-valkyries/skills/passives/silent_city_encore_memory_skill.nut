this.silent_city_encore_memory_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function getTooltip()
	{
		return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }];
	}
});
