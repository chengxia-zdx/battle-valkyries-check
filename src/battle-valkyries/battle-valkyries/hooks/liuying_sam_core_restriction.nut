::$bvvar{namespace}.LiuyingSamCoreItemID <- "$bvvar{modId}.accessory.liuying_sam_core";

::$bvvar{namespace}.isLiuyingSamCore <- function( _item )
{
	return _item != null && _item.getID() == ::$bvvar{namespace}.LiuyingSamCoreItemID;
};

::$bvvar{namespace}.canEquipLiuyingSamCore <- function( _actor )
{
	return _actor != null && ::$bvvar{namespace}.getActorValkyrieID(_actor) == "liuying";
};

::$bvvar{namespace}.hasLiuyingSamCoreEquipped <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	local items = null;

	try
	{
		items = _actor.getItems();
	}
	catch (e)
	{
		items = null;
	}

	if (items == null)
	{
		return false;
	}

	local accessory = items.getItemAtSlot(::Const.ItemSlot.Accessory);
	return ::$bvvar{namespace}.isLiuyingSamCore(accessory);
};

::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function( _item )
	{
		if (::$bvvar{namespace}.isLiuyingSamCore(_item)
			&& _item.getSlotType() != this.Const.ItemSlot.Bag
			&& !::$bvvar{namespace}.canEquipLiuyingSamCore(this.getActor()))
		{
			return false;
		}

		return __original(_item);
	}
});
