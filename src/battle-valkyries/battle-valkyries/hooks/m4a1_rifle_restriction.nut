::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(_item)
	{
		if (_item != null && _item.getID() == "$bvvar{modId}.weapon.m4a1_homecoming_rifle"
			&& _item.getSlotType() != this.Const.ItemSlot.Bag
			&& ::$bvvar{namespace}.getActorValkyrieID(this.getActor()) != "m4a1") return false;
		return __original(_item);
	}
});
