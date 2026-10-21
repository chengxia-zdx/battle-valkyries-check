::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function( _item )
	{
		local actor=this.getActor();
		if(actor!=null&&::$bvvar{namespace}.getActorValkyrieID(actor)=="lily"&&_item!=null)
		{
			local slot=_item.getSlotType();
			if(slot==this.Const.ItemSlot.Mainhand||slot==this.Const.ItemSlot.Offhand)return false;
		}
		return __original(_item);
	}
});
