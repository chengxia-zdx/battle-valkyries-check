::$bvvar{namespace}.MH.hook(::$bvvar{namespace}.ValkyrieSkinItemCarrierScript, function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::$bvvar{namespace}.refreshValkyrieSkinItemDisplay(this);
	}

	q.getTooltip = @(__original) function()
	{
		if (::$bvvar{namespace}.isValkyrieSkinItem(this))
		{
			return ::$bvvar{namespace}.getValkyrieSkinItemTooltip(this);
		}

		return __original();
	}

	q.isChangeableInBattle = @(__original) function()
	{
		if (::$bvvar{namespace}.isValkyrieSkinItem(this))
		{
			return false;
		}

		return __original();
	}

	q.onUse = @(__original) function( _actor, _item = null )
	{
		if (!::$bvvar{namespace}.isValkyrieSkinItem(this))
		{
			return __original(_actor, _item);
		}

		local data = ::$bvvar{namespace}.getValkyrieSkinItemData(this);

		if (data == null || data.ValkyrieID == null || data.ValkyrieID == "")
		{
			return false;
		}

		if (!::$bvvar{namespace}.grantActorValkyrieSkinTrait(_actor, data.ValkyrieID, this, data.SkinID))
		{
			return false;
		}

		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
		return true;
	}

	q.playInventorySound = @(__original) function( _eventType )
	{
		if (::$bvvar{namespace}.isValkyrieSkinItem(this))
		{
			this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
			return;
		}

		__original(_eventType);
	}
});
