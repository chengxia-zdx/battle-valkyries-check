// The tactical UI queries a unit again while it is entering the first turn-bar
// slot. If that unit dies during the animation (for example to Spearwall), the
// query returns null and vanilla UI can leave the turn sequence locked. Keep
// this recovery limited to entries that are already invalid; normal death and
// turn-order handling remains entirely vanilla.
::$bvvar{namespace}.isInvalidTurnSequenceEntity <- function( _entity )
{
	if (_entity == null)
	{
		return true;
	}

	try
	{
		if (typeof _entity == "instance" && _entity.isNull())
		{
			return true;
		}
	}
	catch (e)
	{
	}

	try
	{
		if (!_entity.isAlive() || _entity.isDying() || !_entity.isPlacedOnMap())
		{
			return true;
		}
	}
	catch (e)
	{
		return true;
	}

	return false;
};

::$bvvar{namespace}.MH.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	// Called only by the paired late JS wrapper after the original first-slot
	// query returned null. Returning Handled=false preserves the original UI
	// behavior for any unexpected non-death query failure.
	q.BV_removeInvalidTurnSequenceEntity <- function( _entityID )
	{
		local response = {
			Handled = false,
			RequiresClientRemoval = false
		};

		if (_entityID == null)
		{
			return response;
		}

		local current = null;

		try
		{
			current = this.findEntityByID(this.m.CurrentEntities, _entityID);
		}
		catch (e)
		{
			return response;
		}

		if (current != null)
		{
			if (!::$bvvar{namespace}.isInvalidTurnSequenceEntity(current.entity))
			{
				return response;
			}

			try
			{
				this.m.IsLocked = false;
				this.removeEntity(current.entity);
				::$bvvar{namespace}.log("[TurnSequenceGuard] Removed invalid turn-bar entity=" + _entityID + " from CurrentEntities.");
				response.Handled = true;
				return response;
			}
			catch (e)
			{
				this.m.IsLocked = false;
				response.Handled = true;
				response.RequiresClientRemoval = true;
				::$bvvar{namespace}.log("[TurnSequenceGuard] Falling back to client removal for entity=" + _entityID + ": " + e);
				return response;
			}
		}

		local all = null;

		try
		{
			all = this.findEntityByID(this.m.AllEntities, _entityID);
		}
		catch (e)
		{
			return response;
		}

		if (all != null && !::$bvvar{namespace}.isInvalidTurnSequenceEntity(all.entity))
		{
			return response;
		}

		// The UI still has a stale DOM entry while the backend no longer has a
		// matching turn entry. Unlock the sequence and let the JS wrapper remove
		// only that orphaned visual element.
		this.m.IsLocked = false;
		response.Handled = true;
		response.RequiresClientRemoval = true;
		::$bvvar{namespace}.log("[TurnSequenceGuard] Released stale turn-bar entity=" + _entityID + " missing from CurrentEntities.");
		return response;
	}
});
