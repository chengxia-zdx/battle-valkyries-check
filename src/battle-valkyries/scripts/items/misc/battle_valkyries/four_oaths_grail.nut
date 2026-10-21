this.four_oaths_grail <- this.inherit("scripts/items/item", {
	m = {}, // Legends visits this class's member table before the native parent.
	function create() {
		this.item.create(); this.m.ID = "$bvvar{modId}.item.four_oaths_grail";
		this.m.Name = "$bv{chapter.grail.item.name}"; this.m.Description = "$bv{chapter.grail.item.desc}";
		this.m.Icon = "$bvvar{iconPrefix}/four_oaths_grail.png";
		this.m.SlotType = this.Const.ItemSlot.None; this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsUsable = true; this.m.IsAllowedInBag = false; this.m.IsSellable = false;
		this.m.IsIndestructible = true; this.m.IsDroppedAsLoot = false; this.m.Value = 0;
	},
	function getTooltip() { return [{ id=1, type="title", text=this.getName() }, { id=2, type="description", text=this.getDescription() }]; },
	function onUse(actor, item = null) {
		if (::$bvvar{namespace}.Grail.safeWorld()) {
			if (::World.State.isInCharacterScreen()) ::World.State.character_screen_onClosePressed();
			::World.State.m.WorldScreen.getTopbarOptionsModule().showBattleValkyrieGrail();
		}
		return false; // Opening or cancelling never consumes the item.
	}
});
