::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(_item)
	{
		if (::$bvvar{namespace}.isEnterpriseSignatureBow(_item) && _item.getSlotType() != this.Const.ItemSlot.Bag
			&& (::$bvvar{namespace}.getActorValkyrieID(this.getActor()) != "enterprise" || !this.getActor().isPlayerControlled())) return false;
		return __original(_item);
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function(_in)
	{
		local ret = __original(_in);
		::$bvvar{namespace}.grantMissingEnterpriseSignatureBow();
		return ret;
	}
	q.onShow = @(__original) function()
	{
		local ret = __original();
		::$bvvar{namespace}.grantMissingEnterpriseSignatureBow();
		return ret;
	}
});
