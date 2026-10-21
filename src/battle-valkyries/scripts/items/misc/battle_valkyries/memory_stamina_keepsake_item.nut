this.memory_stamina_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("stamina_keepsake", "$bv{item.memory_stamina.name}", "$bv{item.memory_stamina.description}", "$bv{item.memory_stamina.effect}", "stat", "Stamina", 5, "$bvvar{iconPrefix}/memory_stamina_keepsake.png");
	}
});
