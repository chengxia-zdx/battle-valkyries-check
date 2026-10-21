this.memory_bond_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("bond_keepsake", "$bv{item.memory_bond.name}", "$bv{item.memory_bond.description}", "$bv{item.memory_bond.effect}", "bond", null, 15, "$bvvar{iconPrefix}/memory_bond_keepsake.png");
	}
});
