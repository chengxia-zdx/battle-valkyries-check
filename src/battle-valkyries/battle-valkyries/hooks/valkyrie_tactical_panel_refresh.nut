::$bvvar{namespace}.refreshActiveValkyrieTacticalPanel <- function( _entityID )
{
	try
	{
		if (!("Tactical" in getroottable()) || ::Tactical.TurnSequenceBar == null) return false;
		local actor = ::Tactical.TurnSequenceBar.getActiveEntity();
		if (actor == null || actor.getID() != _entityID
			|| ::$bvvar{namespace}.getActorValkyrieID(actor) == null)
		{
			return false;
		}

		actor.setDirty(true);
		::Tactical.TurnSequenceBar.updateEntity(_entityID);
		return true;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.scheduleActiveValkyrieTacticalPanelRefresh <- function( _entityID )
{
	try
	{
		::Time.scheduleEvent(::TimeUnit.Real, 10, function( _tag )
		{
			::$bvvar{namespace}.refreshActiveValkyrieTacticalPanel(_tag.EntityID);
		}, { EntityID = _entityID });
	}
	catch (e)
	{
		::$bvvar{namespace}.refreshActiveValkyrieTacticalPanel(_entityID);
	}
};

::$bvvar{namespace}.MH.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.onEntityEnteredFirstSlotFully = @(__original) function( _entityID )
	{
		local ret = __original(_entityID);
		::$bvvar{namespace}.scheduleActiveValkyrieTacticalPanelRefresh(_entityID);
		return ret;
	}
});
