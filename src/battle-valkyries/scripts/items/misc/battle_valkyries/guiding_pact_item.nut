this.guiding_pact_item <- this.inherit("scripts/items/item", {
	m = {},
	function create() {
		this.item.create(); this.m.ID = "$bvvar{modId}.item.guiding_pact";
		this.m.Name = "$bv{origin.foreign_banner.pact.name}";
		this.m.Description = "$bv{origin.foreign_banner.pact.description}";
		this.m.Icon = "$bvvar{iconPrefix}/guiding_pact.png";
		this.m.SlotType = this.Const.ItemSlot.None; this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsUsable = true; this.m.IsAllowedInBag = false; this.m.IsSellable = false;
		this.m.IsIndestructible = true; this.m.IsDroppedAsLoot = false; this.m.Value = 0;
	},
	function getTooltip() {
		return [{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{origin.foreign_banner.pact.tooltip}" }];
	},
	function onUse(actor, item = null) {
		if (::$bvvar{namespace}.ForeignBanner.activate()) {
			if (::World.State.isInCharacterScreen()) ::World.State.character_screen_onClosePressed();
			::World.State.m.WorldScreen.getTopbarOptionsModule().showBattleValkyrieSummon();
		}
		return false; // The successful summon consumes this exact inventory entitlement.
	}
});
