this.memory_resource_item <- this.inherit("scripts/items/item", {
	m = { MemoryResource = "" },
	function create()
	{
		this.item.create();
		this.m.Description = "$bv{item.memory_resource.description}";
		this.m.Categories = "$bv{item.memory_resource.category}";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IsSellable = false;
		this.m.IsIndestructible = true;
		this.m.Value = 0;
		// Native item flags persist the quantity without extending its save layout.
		this.getFlags().set("BVMemoryResourceAmount", 1);
	},
	function setAmount( _amount )
	{
		if (typeof _amount != "integer" || _amount <= 0) return false;
		this.getFlags().set("BVMemoryResourceAmount", _amount);
		return true;
	},
	function getAmount()
	{
		local amount = this.getFlags().get("BVMemoryResourceAmount");
		return typeof amount == "integer" && amount > 0 ? amount : 0;
	},
	function isAmountShown() { return true; },
	function getAmountString() { return this.getAmount().tostring(); },
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "image", image = this.getIcon() },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = ::format("$bv{item.memory_resource.effect}", this.getName(), this.getAmount()) },
			{ id = 65, type = "text", text = "$bv{item.memory_resource.use}" }
		];
	},
	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	},
	function onUse( _actor, _item = null )
	{
		if (::Tactical.isActive() || ::World == null || ::World.Flags == null || ::World.Assets == null) return false;
		if (::World.Assets.getStash().getItems().find(this) == null) return false;
		if (this.m.MemoryResource != "Fragment" && this.m.MemoryResource != "Crystal") return false;
		local amount = this.getAmount();
		if (amount <= 0) return false;
		local ns = ::$bvvar{namespace};
		local key = "balance." + this.m.MemoryResource;
		local balance = ns.getMemoryWorldInt(key, 0);
		if (balance < 0 || amount > 2147483647 - balance) return false;
		if (!ns.setMemoryWorldValue(key, balance + amount)) return false;
		// The native stash-use handler removes the item on true. Zeroing the
		// persisted quantity also prevents a stale callback from redeeming twice.
		this.getFlags().set("BVMemoryResourceAmount", 0);
		return true;
	}
});
