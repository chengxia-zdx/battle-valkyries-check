this.memory_crystal_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_resource_item", {
	m = {},
	function create()
	{
		this.memory_resource_item.create();
		this.m.ID = "$bvvar{modId}.misc.memory_crystal";
		this.m.Name = "$bv{memory.resource.crystal}";
		this.m.MemoryResource = "Crystal";
		this.m.Icon = "loot/inventory_loot_05.png";
	}
});
