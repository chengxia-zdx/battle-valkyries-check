this.memory_initiative_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("initiative_keepsake", "$bv{item.memory_initiative.name}", "$bv{item.memory_initiative.description}", "$bv{item.memory_initiative.effect}", "stat", "Initiative", 5, "$bvvar{iconPrefix}/memory_initiative_keepsake.png");
	}
});
