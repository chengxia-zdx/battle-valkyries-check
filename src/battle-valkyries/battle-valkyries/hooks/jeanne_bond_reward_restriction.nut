::$bvvar{namespace}.JeanneEternalStandardItemID <- "$bvvar{modId}.weapon.jeanne_eternal_standard";
::$bvvar{namespace}.JeanneEternalStandardSkillOwnerToken <- "$bvvar{modId}.owner.item.jeanne_eternal_standard";

::$bvvar{namespace}.isJeanneEternalStandardItem <- function( _item )
{
	if (_item == null) return false;
	try { return _item.getID() == ::$bvvar{namespace}.JeanneEternalStandardItemID; }
	catch (e) { return false; }
};

::$bvvar{namespace}.canEquipJeanneEternalStandard <- function( _actor )
{
	return _actor != null && ::$bvvar{namespace}.getActorValkyrieID(_actor) == "jeanne";
};

::$bvvar{namespace}.hasJeanneEternalStandardEquipped <- function( _actor )
{
	if (_actor == null || _actor.getItems() == null) return false;
	local item = null;
	try { item = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand); }
	catch (e) { item = null; }
	return ::$bvvar{namespace}.isJeanneEternalStandardItem(item);
};

::$bvvar{namespace}.syncJeanneEternalStandardSkill <- function( _actor, _skillKey, _shouldAttach, _reason )
{
	if (_actor == null) return true;
	local runtimeSkill = ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, _skillKey);
	if (_shouldAttach)
	{
		local attachResult = ::$bvvar{namespace}.attachTransientSkill(_actor, _skillKey, ::$bvvar{namespace}.JeanneEternalStandardSkillOwnerToken);
		if (!attachResult.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _skillKey, attachResult.Code, "jeanne_eternal_standard.attach." + _reason);
			return false;
		}
		return true;
	}
	if (runtimeSkill == null || !runtimeSkill.hasTransientOwner(::$bvvar{namespace}.JeanneEternalStandardSkillOwnerToken)) return true;
	local detachResult = ::$bvvar{namespace}.detachTransientSkill(_actor, _skillKey, ::$bvvar{namespace}.JeanneEternalStandardSkillOwnerToken);
	if (!detachResult.Success && detachResult.Code != "owner_not_found")
	{
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _skillKey, detachResult.Code, "jeanne_eternal_standard.detach." + _reason);
		return false;
	}
	return true;
};

::$bvvar{namespace}.syncJeanneEternalStandardSkills <- function( _actor, _reason = "unknown" )
{
	if (_actor == null) return true;
	local shouldAttach = ::$bvvar{namespace}.canEquipJeanneEternalStandard(_actor)
		&& ::$bvvar{namespace}.hasJeanneEternalStandardEquipped(_actor);
	local thrust = ::$bvvar{namespace}.syncJeanneEternalStandardSkill(_actor, "jeanne_holy_banner_thrust", shouldAttach, _reason);
	local sweep = ::$bvvar{namespace}.syncJeanneEternalStandardSkill(_actor, "jeanne_holy_banner_sweep", shouldAttach, _reason);
	return thrust && sweep;
};

local originalSyncActorSkillsForJeanneEternalStandard = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function( _actor, _reason = "unknown" )
{
	local result = originalSyncActorSkillsForJeanneEternalStandard(_actor, _reason);
	if (result != null && result.Success) ::$bvvar{namespace}.syncJeanneEternalStandardSkills(_actor, _reason);
	return result;
};

::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function( _item )
	{
		if (::$bvvar{namespace}.isJeanneEternalStandardItem(_item)
			&& _item.getSlotType() != this.Const.ItemSlot.Bag
			&& !::$bvvar{namespace}.canEquipJeanneEternalStandard(this.getActor()))
		{
			return false;
		}
		local ret = __original(_item);
		if (ret) ::$bvvar{namespace}.syncJeanneEternalStandardSkills(this.getActor(), "item_container.equip");
		return ret;
	}
});
