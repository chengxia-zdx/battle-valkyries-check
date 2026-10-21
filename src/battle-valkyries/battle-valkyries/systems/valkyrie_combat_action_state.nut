// Pure Squirrel combat-action reducer.  Keep this file independent from the
// game root table so it can be executed directly by the repository fixture.

local deepCopy = null;
deepCopy = function( _value )
{
	local valueType = typeof _value;
	if (valueType == "table")
	{
		local ret = {};
		foreach (key, value in _value)
		{
			ret[key] <- deepCopy(value);
		}
		return ret;
	}

	if (valueType == "array")
	{
		local ret = [];
		foreach (value in _value)
		{
			ret.push(deepCopy(value));
		}
		return ret;
	}

	return _value;
};

local getValue = function( _table, _key, _fallback )
{
	return _table != null && _key in _table ? _table[_key] : _fallback;
};

local createState = function( _seed = null )
{
	return {
		Epoch = getValue(_seed, "Epoch", 0),
		Generation = getValue(_seed, "Generation", 0),
		ActionToken = getValue(_seed, "ActionToken", null),
		Source = getValue(_seed, "Source", "unknown/direct"),
		IsFree = getValue(_seed, "IsFree", false),
		IsImplicit = getValue(_seed, "IsImplicit", false),
		ParentActionToken = getValue(_seed, "ParentActionToken", null),
		RootReturned = false,
		DispatchDepth = 0,
		PendingAttempts = 0,
		PendingContinuations = 0,
		Busy = false,
		Committed = false,
		Cancelled = false,
		CancelReason = null,
		Finalized = false,
		FinalizeCount = 0,
		UseResult = false,
		Attempts = {},
		AttemptOrder = [],
		Continuations = {},
		ContinuationOrder = [],
		TargetResults = []
	};
};

local isAttemptOpen = function( _state, _attemptID )
{
	return _state != null
		&& typeof _attemptID == "string"
		&& _attemptID in _state.Attempts
		&& _state.Attempts[_attemptID].Status == "pending";
};

local canFinalize = function( _state, _epoch, _generation, _busy = false )
{
	return _state != null
		&& _state.Epoch == _epoch
		&& _state.Generation == _generation
		&& _state.RootReturned
		&& _state.DispatchDepth == 0
		&& _state.PendingAttempts == 0
		&& _state.PendingContinuations == 0
		&& !_state.Busy
		&& !_busy
		&& _state.Committed
		&& !_state.Cancelled
		&& !_state.Finalized;
};

local touch = function( _state )
{
	_state.Generation++;
	return _state;
};

local cancelPendingWork = function( _state, _reason )
{
	foreach (attemptID in _state.AttemptOrder)
	{
		local attempt = _state.Attempts[attemptID];
		if (attempt.Status == "pending")
		{
			attempt.Status = "cancelled";
			attempt.CancelReason = _reason;
		}
	}
	_state.PendingAttempts = 0;
	foreach (continuationID in _state.ContinuationOrder)
	{
		local continuation = _state.Continuations[continuationID];
		if (continuation.Status == "pending")
		{
			continuation.Status = "cancelled";
			continuation.CancelReason = _reason;
		}
	}
	_state.PendingContinuations = 0;
};

local reduceState = function( _state, _event )
{
	if (_state == null || typeof _state != "table")
	{
		throw "valkyrie combat action reducer requires a state table";
	}
	if (_event == null || typeof _event != "table" || !("Type" in _event))
	{
		throw "valkyrie combat action reducer requires an event type";
	}

	local next = deepCopy(_state);
	local eventType = _event.Type;
	// Cancelled/finalized states are terminal.  Runtime cleanup may still
	// deliver balanced leave/reset callbacks after an exception or teardown;
	// those callbacks must not resurrect or advance the old generation.
	if (next.Cancelled || next.Finalized)
	{
		return next;
	}

	if (eventType == "COMMITTED")
	{
		if (next.Cancelled || next.Finalized || next.Committed)
		{
			return next;
		}
		next.Committed = true;
		return touch(next);
	}

	if (eventType == "ROOT_RETURNED")
	{
		if (next.RootReturned || next.Finalized || next.Cancelled)
		{
			return next;
		}

		next.RootReturned = true;
		next.UseResult = getValue(_event, "Result", false);
		local valid = getValue(_event, "Valid", next.UseResult || next.Committed || next.AttemptOrder.len() != 0);
		if (!valid)
		{
			next.Cancelled = true;
			next.CancelReason = "invalid_use";
			cancelPendingWork(next, next.CancelReason);
		}
		else if (!next.Committed)
		{
			next.Committed = true;
		}
		return touch(next);
	}

	if (eventType == "DISPATCH_ENTERED")
	{
		if (next.Cancelled || next.Finalized)
		{
			return next;
		}
		next.DispatchDepth++;
		return touch(next);
	}

	if (eventType == "DISPATCH_LEFT")
	{
		if (next.DispatchDepth <= 0)
		{
			throw "valkyrie combat action dispatch depth underflow";
		}
		next.DispatchDepth--;
		return touch(next);
	}

	if (eventType == "BUSY_CHANGED")
	{
		local busy = getValue(_event, "Busy", false);
		if (next.Cancelled || next.Finalized || next.Busy == busy)
		{
			return next;
		}
		next.Busy = busy;
		return touch(next);
	}

	if (eventType == "TOUCHED")
	{
		return next.Cancelled || next.Finalized ? next : touch(next);
	}

	if (eventType == "ATTEMPT_OPENED")
	{
		local attemptID = getValue(_event, "AttemptID", null);
		if (next.Cancelled || next.Finalized || typeof attemptID != "string" || attemptID.len() == 0 || attemptID in next.Attempts)
		{
			return next;
		}

		next.Attempts[attemptID] <- {
			AttemptID = attemptID,
			TargetID = getValue(_event, "TargetID", null),
			Status = "pending",
			Hit = false,
			BodyPart = null,
			HitpointDamage = 0,
			ArmorDamage = 0,
			CancelReason = null
		};
		next.AttemptOrder.push(attemptID);
		next.PendingAttempts++;
		next.Committed = true;
		return touch(next);
	}

	if (eventType == "ATTEMPT_RESOLVED")
	{
		local attemptID = getValue(_event, "AttemptID", null);
		if (!isAttemptOpen(next, attemptID))
		{
			return next;
		}

		local attempt = next.Attempts[attemptID];
		local hit = getValue(_event, "Hit", false);
		attempt.Status = hit ? "hit" : "miss";
		attempt.Hit = hit;
		attempt.BodyPart = getValue(_event, "BodyPart", null);
		attempt.HitpointDamage = getValue(_event, "HitpointDamage", 0);
		attempt.ArmorDamage = getValue(_event, "ArmorDamage", 0);
		next.PendingAttempts--;
		next.TargetResults.push(deepCopy(attempt));
		return touch(next);
	}

	if (eventType == "ATTEMPT_RETARGETED")
	{
		local attemptID = getValue(_event, "AttemptID", null);
		local targetID = getValue(_event, "TargetID", null);
		if (!isAttemptOpen(next, attemptID) || targetID == null || next.Attempts[attemptID].TargetID == targetID)
		{
			return next;
		}
		next.Attempts[attemptID].TargetID = targetID;
		return touch(next);
	}

	if (eventType == "ATTEMPT_CANCELLED")
	{
		local attemptID = getValue(_event, "AttemptID", null);
		if (!isAttemptOpen(next, attemptID))
		{
			return next;
		}

		local attempt = next.Attempts[attemptID];
		attempt.Status = "cancelled";
		attempt.CancelReason = getValue(_event, "Reason", "cancelled");
		next.PendingAttempts--;
		return touch(next);
	}

	if (eventType == "CONTINUATION_RESERVED")
	{
		local continuationID = getValue(_event, "ContinuationID", null);
		if (typeof continuationID != "string" || continuationID.len() == 0 || continuationID in next.Continuations)
		{
			return next;
		}
		next.Continuations[continuationID] <- {
			ContinuationID = continuationID,
			Status = "pending",
			Reason = getValue(_event, "Reason", null),
			CancelReason = null
		};
		next.ContinuationOrder.push(continuationID);
		next.PendingContinuations++;
		next.Committed = true;
		return touch(next);
	}

	if (eventType == "CONTINUATION_RELEASED")
	{
		local continuationID = getValue(_event, "ContinuationID", null);
		if (typeof continuationID != "string" || !(continuationID in next.Continuations) || next.Continuations[continuationID].Status != "pending")
		{
			return next;
		}
		next.Continuations[continuationID].Status = "released";
		next.PendingContinuations--;
		return touch(next);
	}

	if (eventType == "CANCELLED")
	{
		if (next.Cancelled || next.Finalized)
		{
			return next;
		}
		next.Cancelled = true;
		next.CancelReason = getValue(_event, "Reason", "cancelled");
		cancelPendingWork(next, next.CancelReason);
		return touch(next);
	}

	if (eventType == "EPOCH_RESET")
	{
		local nextEpoch = getValue(_event, "Epoch", next.Epoch + 1);
		if (typeof nextEpoch != "integer" || nextEpoch <= next.Epoch)
		{
			return next;
		}
		cancelPendingWork(next, getValue(_event, "Reason", "epoch_reset"));
		next.Epoch = nextEpoch;
		next.Busy = false;
		next.DispatchDepth = 0;
		next.Cancelled = true;
		next.CancelReason = getValue(_event, "Reason", "epoch_reset");
		return touch(next);
	}

	if (eventType == "FINALIZED")
	{
		local epoch = getValue(_event, "Epoch", next.Epoch);
		local generation = getValue(_event, "Generation", next.Generation);
		local busy = getValue(_event, "Busy", next.Busy);
		if (!canFinalize(next, epoch, generation, busy))
		{
			return next;
		}
		next.Finalized = true;
		next.FinalizeCount++;
		return touch(next);
	}

	throw "unknown valkyrie combat action event: " + eventType;
};

local classifySource = function( _explicitSource, _isFree, _hasRootUse, _isFollowup )
{
	if (!_hasRootUse)
	{
		return "unknown/direct";
	}
	if (_explicitSource == "aoo" || _explicitSource == "riposte" || _explicitSource == "followup" || _explicitSource == "managed_active")
	{
		return _explicitSource;
	}
	if (_isFollowup)
	{
		return "followup";
	}
	return _isFree ? "free" : "direct";
};

local module = {
	createValkyrieCombatActionState = createState,
	reduceValkyrieCombatActionState = reduceState,
	isValkyrieCombatAttemptOpen = isAttemptOpen,
	canFinalizeValkyrieCombatAction = canFinalize,
	classifyValkyrieCombatActionSource = classifySource,
	isValkyrieFollowupActionSource = function( _source ) { return _source == "followup"; },
	isValkyrieCounterOrAOOActionSource = function( _source ) { return _source == "aoo" || _source == "riposte"; }
};

// ::include does not expose a script return value on every supported BB
// runtime.  Publish one package-neutral immutable-function table, then return
// it as well for the standalone sq.exe fixture.
::BattleValkyriesCombatActionStateReducer <- module;
return module;
