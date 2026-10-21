this.memory_melee_defense_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("melee_defense_keepsake", "$bv{item.memory_melee_defense.name}", "$bv{item.memory_melee_defense.description}", "$bv{item.memory_melee_defense.effect}", "stat", "MeleeDefense", 2, "$bvvar{iconPrefix}/memory_melee_defense_keepsake.png");
	}
});
