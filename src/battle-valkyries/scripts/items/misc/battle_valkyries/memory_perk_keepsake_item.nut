this.memory_perk_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("perk_keepsake", "$bv{item.memory_perk.name}", "$bv{item.memory_perk.description}", "$bv{item.memory_perk.effect}", "perk", null, 1, null);
	}
});
