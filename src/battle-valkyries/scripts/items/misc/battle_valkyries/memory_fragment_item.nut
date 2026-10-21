this.memory_fragment_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_resource_item", {
	m = {},
	function create()
	{
		this.memory_resource_item.create();
		this.m.ID = "$bvvar{modId}.misc.memory_fragment";
		this.m.Name = "$bv{memory.resource.fragment}";
		this.m.MemoryResource = "Fragment";
		this.m.Icon = "trade/inventory_trade_06.png";
	}
});
