this.memory_ranged_defense_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("ranged_defense_keepsake", "$bv{item.memory_ranged_defense.name}", "$bv{item.memory_ranged_defense.description}", "$bv{item.memory_ranged_defense.effect}", "stat", "RangedDefense", 2, "$bvvar{iconPrefix}/memory_ranged_defense_keepsake.png");
	}
});
