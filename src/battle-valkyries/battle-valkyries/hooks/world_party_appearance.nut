::$bvvar{namespace}.WorldPartyLeaderValkyrieIDFlag <- "BattleValkyries.WorldLeaderValkyrieID";
::$bvvar{namespace}.WorldPartyLeaderSkinIDFlag <- "BattleValkyries.WorldLeaderSkinID";

::$bvvar{namespace}.getWorldPartyLeaderValkyrieID <- function()
{
	if (::World == null || ::World.Flags == null || !::World.Flags.has(::$bvvar{namespace}.WorldPartyLeaderValkyrieIDFlag))
	{
		return "";
	}

	local value = ::World.Flags.get(::$bvvar{namespace}.WorldPartyLeaderValkyrieIDFlag);
	return value == null || value == false ? "" : value;
};

::$bvvar{namespace}.getWorldPartyLeaderSkinID <- function()
{
	local valkyrieID = ::$bvvar{namespace}.getWorldPartyLeaderValkyrieID();
	local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
	if (template == null)
	{
		return "";
	}

	local stored = "";
	if (::World != null && ::World.Flags != null && ::World.Flags.has(::$bvvar{namespace}.WorldPartyLeaderSkinIDFlag))
	{
		local value = ::World.Flags.get(::$bvvar{namespace}.WorldPartyLeaderSkinIDFlag);
		stored = value == null || value == false ? "" : value;
	}

	return ::$bvvar{namespace}.resolveValkyrieSkinID(template, stored);
};

::$bvvar{namespace}.getWorldPartyBrush <- function()
{
	local valkyrieID = ::$bvvar{namespace}.getWorldPartyLeaderValkyrieID();
	local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);

	if (template == null)
	{
		return null;
	}

	local skinID = ::$bvvar{namespace}.getWorldPartyLeaderSkinID();
	return ::$bvvar{namespace}.getValkyrieWorldLeaderBrush(template, skinID);
};

::$bvvar{namespace}.setWorldPartyLeaderValkyrie <- function( _valkyrieID, _skinID = null )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.leader.error.invalid}", "invalid");
	}

	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _skinID);
	if (!::$bvvar{namespace}.isValkyrieSkinUnlocked(template, skinID)) return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{chapter.skin.locked}", "locked_skin");
	if (skinID == null || (_skinID != null && _skinID != "" && skinID != _skinID))
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.leader.error.invalid}", "invalid_skin");
	}

	local worldLeaderBrush = ::$bvvar{namespace}.getValkyrieWorldLeaderBrush(template, skinID);

	if (worldLeaderBrush == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.leader.error.invalid}", "invalid");
	}

	if (::World == null || ::World.Flags == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.leader.error.invalid}", "world_unavailable");
	}

	::World.Flags.set(::$bvvar{namespace}.WorldPartyLeaderValkyrieIDFlag, template.ID);
	::World.Flags.set(::$bvvar{namespace}.WorldPartyLeaderSkinIDFlag, skinID);
	::$bvvar{namespace}.applyWorldPartyAppearance(null, "setWorldPartyLeaderValkyrie");
	local leaderName = template.Name;
	if (skinID != ::$bvvar{namespace}.getValkyrieDefaultSkinID(template))
	{
		leaderName += " - " + ::$bvvar{namespace}.getValkyrieSkinTabName(template, skinID);
	}
	return ::$bvvar{namespace}.createValkyrieResult(true, "$bv{ui.hub.leader.success_prefix}" + leaderName + "$bv{ui.hub.leader.success_suffix}", "success");
};

::$bvvar{namespace}.applyWorldPartyAppearance <- function( _party = null, _label = "" )
{
	local player = _party;

	if (player == null)
	{
		try
		{
			player = ::World.State.getPlayer();
		}
		catch (e)
		{
			player = null;
		}
	}

	if (player == null)
	{
		return false;
	}

	try
	{
		if (::World.Assets.isCamping())
		{
			return false;
		}
	}
	catch (e)
	{
	}

	try
	{
		local targetBrush = ::$bvvar{namespace}.getWorldPartyBrush();
		if (targetBrush == null)
		{
			return false;
		}

		local body = player.getSprite("body");
		local currentBrush = "";

		try
		{
			if (body.HasBrush)
			{
				currentBrush = body.getBrush().Name;
			}
		}
		catch (e)
		{
			currentBrush = "";
		}

		if (currentBrush != targetBrush)
		{
			body.setBrush(targetBrush);
		}

		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[WorldParty] failed to apply world party brush" + (_label == "" ? "" : " at " + _label) + ": " + e);
	}

	return false;
}

::$bvvar{namespace}.MH.hook("scripts/entity/world/player_party", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		::$bvvar{namespace}.applyWorldPartyAppearance(this, "player_party.onInit");
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::$bvvar{namespace}.applyWorldPartyAppearance(this, "player_party.onDeserialize");
	}

	q.onUpdate = @(__original) function()
	{
		__original();
		::$bvvar{namespace}.applyWorldPartyAppearance(this, "player_party.onUpdate");
	}

	q.setCamping = @(__original) function( _c )
	{
		__original(_c);

		if (!_c)
		{
			::$bvvar{namespace}.applyWorldPartyAppearance(this, "player_party.setCamping");
		}
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world/asset_manager", function(q) {
	q.updateLook = @(__original) function( _updateTo = -1 )
	{
		__original(_updateTo);
		::$bvvar{namespace}.applyWorldPartyAppearance(null, "asset_manager.updateLook");
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::$bvvar{namespace}.applyWorldPartyAppearance(null, "world_state.onDeserialize");
	}

	q.onShow = @(__original) function()
	{
		__original();
		::$bvvar{namespace}.applyWorldPartyAppearance(null, "world_state.onShow");
	}
});
