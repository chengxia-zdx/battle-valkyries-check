this.memory_hitpoints_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("hitpoints_keepsake", "$bv{item.memory_hitpoints.name}", "$bv{item.memory_hitpoints.description}", "$bv{item.memory_hitpoints.effect}", "stat", "Hitpoints", 5, "$bvvar{iconPrefix}/memory_hitpoints_keepsake.png");
	}
});
