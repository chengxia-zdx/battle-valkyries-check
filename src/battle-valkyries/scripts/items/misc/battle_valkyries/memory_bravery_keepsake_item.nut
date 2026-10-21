this.memory_bravery_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("bravery_keepsake", "$bv{item.memory_bravery.name}", "$bv{item.memory_bravery.description}", "$bv{item.memory_bravery.effect}", "stat", "Bravery", 5, "$bvvar{iconPrefix}/memory_bravery_keepsake.png");
	}
});
