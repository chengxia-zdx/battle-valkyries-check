::$bvvar{namespace}.HimekoAstralLanceItemID <- "$bvvar{modId}.weapon.himeko_astral_lance";
::$bvvar{namespace}.HimekoNavigatorCircletItemID <- "$bvvar{modId}.helmet.himeko_navigator_circlet";
::$bvvar{namespace}.HimekoNavigatorArmorItemID <- "$bvvar{modId}.armor.himeko_navigator_armor";
::$bvvar{namespace}.HimekoTrailblazerSummonerItemID <- "$bvvar{modId}.accessory.himeko_trailblazer_summoner";
::$bvvar{namespace}.HimekoAstralLanceSkillOwnerToken <- "$bvvar{modId}.owner.item.himeko_astral_lance";
::$bvvar{namespace}.HimekoTrailblazerSkillOwnerToken <- "$bvvar{modId}.owner.item.himeko_trailblazer_summoner";

::$bvvar{namespace}.isHimekoBondRewardItem <- function( _item )
{
	if (_item == null)
	{
		return false;
	}

	local id = _item.getID();
	return id == ::$bvvar{namespace}.HimekoAstralLanceItemID
		|| id == ::$bvvar{namespace}.HimekoNavigatorCircletItemID
		|| id == ::$bvvar{namespace}.HimekoNavigatorArmorItemID
		|| id == ::$bvvar{namespace}.HimekoTrailblazerSummonerItemID;
};

::$bvvar{namespace}.canEquipHimekoBondReward <- function( _actor )
{
	return _actor != null && ::$bvvar{namespace}.getActorValkyrieID(_actor) == "himeko";
};

::$bvvar{namespace}.hasHimekoAstralLanceEquipped <- function( _actor )
{
	if (_actor == null || _actor.getItems() == null)
	{
		return false;
	}

	local item = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	return item != null && item.getID() == ::$bvvar{namespace}.HimekoAstralLanceItemID;
};

::$bvvar{namespace}.hasHimekoTrailblazerSummonerEquipped <- function( _actor )
{
	if (_actor == null || _actor.getItems() == null)
	{
		return false;
	}

	local item = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
	return item != null && item.getID() == ::$bvvar{namespace}.HimekoTrailblazerSummonerItemID;
};

::$bvvar{namespace}.getHimekoTrailblazerSummonerEquipped <- function( _actor )
{
	if (!::$bvvar{namespace}.hasHimekoTrailblazerSummonerEquipped(_actor))
	{
		return null;
	}

	return _actor.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
};

::$bvvar{namespace}.syncHimekoBondEquipmentSkill <- function( _actor, _skillKey, _ownerToken, _shouldAttach, _reason )
{
	if (_actor == null || ::$bvvar{namespace}.getActorValkyrieID(_actor) != "himeko")
	{
		return true;
	}

	local runtimeSkill = ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, _skillKey);

	if (_shouldAttach)
	{
		local attachResult = ::$bvvar{namespace}.attachTransientSkill(_actor, _skillKey, _ownerToken);

		if (!attachResult.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _skillKey, attachResult.Code, "himeko_equipment.attach." + _reason);
			return false;
		}

		return true;
	}

	if (runtimeSkill == null || !runtimeSkill.hasTransientOwner(_ownerToken))
	{
		return true;
	}

	local detachResult = ::$bvvar{namespace}.detachTransientSkill(_actor, _skillKey, _ownerToken);

	if (!detachResult.Success && detachResult.Code != "owner_not_found")
	{
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _skillKey, detachResult.Code, "himeko_equipment.detach." + _reason);
		return false;
	}

	return true;
};

::$bvvar{namespace}.syncHimekoBondEquipmentSkills <- function( _actor, _reason = "unknown" )
{
	if (_actor == null || ::$bvvar{namespace}.getActorValkyrieID(_actor) != "himeko")
	{
		return true;
	}

	local lanceEquipped = ::$bvvar{namespace}.hasHimekoAstralLanceEquipped(_actor);
	local summonerEquipped = ::$bvvar{namespace}.hasHimekoTrailblazerSummonerEquipped(_actor);
	local lanceSynced = ::$bvvar{namespace}.syncHimekoBondEquipmentSkill(
		_actor,
		"himeko_astral_lance_strike",
		::$bvvar{namespace}.HimekoAstralLanceSkillOwnerToken,
		lanceEquipped,
		_reason
	);
	local summonerSynced = ::$bvvar{namespace}.syncHimekoBondEquipmentSkill(
		_actor,
		"himeko_trailblazer_deploy",
		::$bvvar{namespace}.HimekoTrailblazerSkillOwnerToken,
		summonerEquipped,
		_reason
	);
	return lanceSynced && summonerSynced;
};

local originalSyncActorSkillsForHimekoBondEquipment = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function( _actor, _reason = "unknown" )
{
	local result = originalSyncActorSkillsForHimekoBondEquipment(_actor, _reason);

	if (result != null && result.Success)
	{
		::$bvvar{namespace}.syncHimekoBondEquipmentSkills(_actor, _reason);
	}

	return result;
};

::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function( _item )
	{
		if (::$bvvar{namespace}.isHimekoBondRewardItem(_item)
			&& _item.getSlotType() != this.Const.ItemSlot.Bag
			&& !::$bvvar{namespace}.canEquipHimekoBondReward(this.getActor()))
		{
			return false;
		}

		local ret = __original(_item);

		if (ret)
		{
			::$bvvar{namespace}.syncHimekoBondEquipmentSkills(this.getActor(), "item_container.equip");
		}

		return ret;
	}
});
