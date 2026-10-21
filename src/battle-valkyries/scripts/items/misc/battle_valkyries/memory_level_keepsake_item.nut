this.memory_level_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("level_keepsake", "$bv{item.memory_level.name}", "$bv{item.memory_level.description}", "$bv{item.memory_level.effect}", "level", null, 1, "$bvvar{iconPrefix}/memory_level_keepsake.png");
	}
});
