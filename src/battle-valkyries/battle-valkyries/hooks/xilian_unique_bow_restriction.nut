::$bvvar{namespace}.XilianInfiniteOathBowID <- "$bvvar{modId}.weapon.xilian_infinite_oath_bow";

::$bvvar{namespace}.isXilianInfiniteOathBow <- function( _item )
{
	return _item != null && _item.getID() == ::$bvvar{namespace}.XilianInfiniteOathBowID;
};

::$bvvar{namespace}.canEquipXilianInfiniteOathBow <- function( _actor )
{
	return _actor != null && ::$bvvar{namespace}.getActorValkyrieID(_actor) == "xilian";
};

::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function( _item )
	{
		if (::$bvvar{namespace}.isXilianInfiniteOathBow(_item)
			&& _item.getSlotType() != this.Const.ItemSlot.Bag
			&& !::$bvvar{namespace}.canEquipXilianInfiniteOathBow(this.getActor()))
		{
			return false;
		}

		return __original(_item);
	}
});
