::$bvvar{namespace}.logSaveLoadDebug <- function( _message )
{
	if (_message == null)
	{
		return;
	}

	try
	{
		::logInfo("[Battle Valkyries] [SaveLoadDebug] " + _message);
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.SaveLoadDebugIsReadingCampaign <- false;

::$bvvar{namespace}.getSaveLoadDebugItemText <- function( _item )
{
	if (_item == null) return "item=null";
	local id = "unknown";
	local name = "unknown";
	try { id = _item.getID(); } catch (e) {}
	try { name = _item.getName(); } catch (e) {}
	return "item=" + id + " name=" + name;
};

::$bvvar{namespace}.getSaveLoadDebugContainerActorText <- function( _container )
{
	if (_container == null) return "actor=null";
	local actor = null;
	try { actor = _container.getActor(); } catch (e) {}
	if (actor == null) return "actor=null";
	local name = "unknown";
	local id = "unknown";
	try { name = actor.getName(); } catch (e) {}
	try { id = actor.getID(); } catch (e) {}
	return "actor=" + id + " name=" + name;
};

::$bvvar{namespace}.getSaveLoadDebugMetaText <- function( _in )
{
	try
	{
		local meta = _in.getMetaData();
		return "version=" + meta.getVersion();
	}
	catch (e)
	{
		return "version=unknown error=" + e;
	}
};

::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase <- function( _script, _label )
{
	local script = _script;
	local label = _label;

	::$bvvar{namespace}.MH.hook(script, function(q) {
		q.onDeserialize = @(__original) function( _in )
		{
			::$bvvar{namespace}.logSaveLoadDebug(label + ".begin " + ::$bvvar{namespace}.getSaveLoadDebugMetaText(_in));

			local ret = null;

			try
			{
				ret = __original(_in);
			}
			catch (e)
			{
				::$bvvar{namespace}.logSaveLoadDebug(label + ".exception error=" + e);
				throw e;
			}

			::$bvvar{namespace}.logSaveLoadDebug(label + ".end");
			return ret;
		}
	});
};

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.loadCampaign = @(__original) function( _campaignFileName )
	{
		::$bvvar{namespace}.SaveLoadDebugIsReadingCampaign = true;
		::$bvvar{namespace}.logSaveLoadDebug("loadCampaign.begin file=" + _campaignFileName);

		local ret = null;

		try
		{
			ret = __original(_campaignFileName);
		}
		catch (e)
		{
			::$bvvar{namespace}.logSaveLoadDebug("loadCampaign.exception file=" + _campaignFileName + " error=" + e);
			throw e;
		}

		::$bvvar{namespace}.logSaveLoadDebug("loadCampaign.end file=" + _campaignFileName);
		::$bvvar{namespace}.SaveLoadDebugIsReadingCampaign = false;
		return ret;
	}

	q.onBeforeDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.logSaveLoadDebug("world_state.onBeforeDeserialize.begin " + ::$bvvar{namespace}.getSaveLoadDebugMetaText(_in));

		local ret = null;

		try
		{
			ret = __original(_in);
		}
		catch (e)
		{
			::$bvvar{namespace}.logSaveLoadDebug("world_state.onBeforeDeserialize.exception error=" + e);
			throw e;
		}

		::$bvvar{namespace}.logSaveLoadDebug("world_state.onBeforeDeserialize.end");
		return ret;
	}

	q.onDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.logSaveLoadDebug("world_state.onDeserialize.begin " + ::$bvvar{namespace}.getSaveLoadDebugMetaText(_in));

		local ret = null;

		try
		{
			ret = __original(_in);
		}
		catch (e)
		{
			::$bvvar{namespace}.logSaveLoadDebug("world_state.onDeserialize.exception error=" + e);
			throw e;
		}

		::$bvvar{namespace}.logSaveLoadDebug("world_state.onDeserialize.end");
		return ret;
	}
});

::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function( _item )
	{
		if (::$bvvar{namespace}.SaveLoadDebugIsReadingCampaign)
		{
			::$bvvar{namespace}.logSaveLoadDebug("item_container.equip.begin " + ::$bvvar{namespace}.getSaveLoadDebugContainerActorText(this) + " " + ::$bvvar{namespace}.getSaveLoadDebugItemText(_item));
		}
		local ret = __original(_item);
		if (::$bvvar{namespace}.SaveLoadDebugIsReadingCampaign)
		{
			::$bvvar{namespace}.logSaveLoadDebug("item_container.equip.end ret=" + ret);
		}
		return ret;
	}
});

::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/factions/faction_manager", "World.FactionManager");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/entity/world/entity_manager", "World.EntityManager");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/states/world/asset_manager", "World.Assets");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/entity/world/combat_manager", "World.Combat");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/contracts/contract_manager", "World.Contracts");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/events/event_manager", "World.Events");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/ambitions/ambition_manager", "World.Ambitions");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/crafting/crafting_manager", "World.Crafting");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/retinue/retinue_manager", "World.Retinue");
::$bvvar{namespace}.hookSaveLoadDebugDeserializePhase("scripts/statistics/statistics_manager", "World.Statistics");
