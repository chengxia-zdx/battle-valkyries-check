// Package-neutral, non-serialized tactical control adapter.  It intentionally
// defaults to retaining the original AI; opt-in direct input uses a player agent. Current
// resources, equipment, skill state and turn flags stay owned by the actor.

::$bvvar{namespace}.ValkyrieTemporaryControlRuntime <- {
	Handles = []
};

::$bvvar{namespace}.logKafkaTemporaryControlFailure <- function( _stage, _target, _reason )
{
	try
	{
		local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
		::logInfo("[Battle Valkyries] [KafkaControl] stage=" + _stage + " target=" + targetID + " reason=" + _reason);
	}
	catch (e) {}
};

::$bvvar{namespace}.isValkyrieTemporaryControlDeniedEntityType <- function( _type )
{
	switch (_type)
	{
	case ::Const.EntityType.Player:
	case ::Const.EntityType.Lindwurm:
	case ::Const.EntityType.Kraken:
	case ::Const.EntityType.KrakenTentacle:
	case ::Const.EntityType.SpiderEggs:
	case ::Const.EntityType.GreenskinCatapult:
	case ::Const.EntityType.Mortar:
	case ::Const.EntityType.SkeletonBoss:
	case ::Const.EntityType.ZombieBoss:
	case ::Const.EntityType.TricksterGod:
	case ::Const.EntityType.SkeletonLich:
	case ::Const.EntityType.SkeletonLichMirrorImage:
	case ::Const.EntityType.SkeletonPhylactery:
	case ::Const.EntityType.FaultFinder:
	case ::Const.EntityType.GrandDiviner:
	case ::Const.EntityType.FleshCradle:
		return true;
	default:
		return false;
	}
};

::$bvvar{namespace}.getValkyrieTemporaryControlDenialReason <- function( _target, _controller = null, _directInput = false )
{
	if (_target == null)
	{
		return "missing_target";
	}
	if (::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(_target) != null)
	{
		return "temporary_control_pending";
	}
	if (_controller != null)
	{
		local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
		local controllerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_controller);
		if (_target == _controller || (targetID != null && targetID == controllerID))
		{
			return "self";
		}
		try
		{
			if (_target.isAlliedWith(_controller)) return "ally";
		}
		catch (e)
		{
			return "alliance_unavailable";
		}
	}

	try { if (!_target.isAlive()) return "dead"; }
	catch (e) { return "life_state_unavailable"; }
	local isDying = false;
	try { isDying = _target.isDying(); }
	catch (e) { try { isDying = _target.m.IsDying; } catch (ignored) {} }
	if (isDying) return "dead";
	try { if (!_target.isPlacedOnMap()) return "not_placed"; }
	catch (e) { return "placement_unavailable"; }
	try { if (!_target.isAttackable()) return "not_attackable"; }
	catch (e) { return "attackability_unavailable"; }
	try { if (_target.isNonCombatant()) return "noncombatant"; }
	catch (e) { return "combatant_state_unavailable"; }

	local actorState = null;
	try { actorState = _target.m; }
	catch (e) { return "actor_state_unavailable"; }
	if (actorState == null) return "actor_state_unavailable";
	try { if (!actorState.IsActingEachTurn) return "no_normal_turn"; }
	catch (e) { return "no_normal_turn"; }
	try { if (!_directInput && actorState.IsMiniboss) return "miniboss"; }
	catch (e) {}

	local type = null;
	try { type = _target.getType(); } catch (e) { return "entity_type_unavailable"; }
	if (::$bvvar{namespace}.isValkyrieTemporaryControlDeniedEntityType(type)) return "special_entity_type";

	try { if (_target.getAIAgent() == null) return "no_ai_agent"; }
	catch (e) { return "ai_agent_unavailable"; }
	try { if (_target.getSkills() == null) return "no_skill_container"; }
	catch (e) { return "skill_container_unavailable"; }
	try { if (_target.getTile() == null) return "no_tactical_tile"; }
	catch (e) { return "tile_unavailable"; }

	return null;
};

::$bvvar{namespace}.canAcquireValkyrieTemporaryPlayerControl <- function( _target, _controller = null )
{
	return ::$bvvar{namespace}.getValkyrieTemporaryControlDenialReason(_target, _controller) == null;
};

::$bvvar{namespace}.refreshValkyrieTemporaryControlEntity <- function( _target )
{
	if (_target == null) return;
	try { _target.setDirty(true); } catch (e) {}
	try { ::Tactical.TurnSequenceBar.updateEntity(_target.getID()); } catch (e) {}
};

::$bvvar{namespace}.removeValkyrieTemporaryControlHandle <- function( _handle )
{
	local handles = ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles;
	for (local i = handles.len() - 1; i >= 0; i--)
	{
		if (handles[i] == _handle)
		{
			handles.remove(i);
			return true;
		}
	}
	return false;
};

::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle <- function( _target )
{
	if (_target == null) return null;
	local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
	foreach (handle in ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles)
	{
		if (handle == null || !handle.Active || handle.Restored) continue;
		local current = ::$bvvar{namespace}.readValkyrieCombatWeakRef(handle.TargetRef);
		if (current == _target || (targetID != null && handle.TargetID == targetID)) return handle;
	}
	return null;
};

::$bvvar{namespace}.isValkyrieTemporaryPlayerControlActiveFor <- function( _target )
{
	return ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(_target) != null;
};

::$bvvar{namespace}.hasValkyrieTemporaryPlayerControls <- function()
{
	foreach (handle in ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles)
	{
		if (handle != null && ("Active" in handle) && handle.Active && (!("Restored" in handle) || !handle.Restored)) return true;
	}
	return false;
};

// Return only live temporary-control handles that belong to one director.  This
// is deliberately controller-scoped: Kafka's one-slot rule must not block a
// different source of temporary control, but a failed Kafka transaction must
// keep blocking Kafka until its registered repair handle is restored.
::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandlesForController <- function( _controller )
{
	local result = [];
	if (_controller == null) return result;
	local controllerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_controller);
	foreach (handle in ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles)
	{
		if (handle == null || !("Active" in handle) || !handle.Active || (("Restored" in handle) && handle.Restored)) continue;
		local current = ::$bvvar{namespace}.readValkyrieCombatWeakRef(handle.ControllerRef);
		if (current == _controller || (controllerID != null && handle.ControllerID == controllerID)) result.push(handle);
	}
	return result;
};

::$bvvar{namespace}.isValkyrieTemporaryControlStateExact <- function( _target, _faction, _agent, _controlled )
{
	if (_target == null) return false;
	try
	{
		return _target.getFaction() == _faction && _target.getAIAgent() == _agent && _target.m.IsControlledByPlayer == _controlled;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl <- function( _handle, _reason = "restore" )
{
	if (_handle == null || typeof _handle != "table") return false;
	if (("Restored" in _handle) && _handle.Restored) return true;

	local target = "TargetRef" in _handle ? ::$bvvar{namespace}.readValkyrieCombatWeakRef(_handle.TargetRef) : null;
	if (target == null)
	{
		_handle.Restored <- true;
		_handle.Active <- false;
		::$bvvar{namespace}.removeValkyrieTemporaryControlHandle(_handle);
		return true;
	}

	try { target.m.IsControlledByPlayer = _handle.OriginalControlled; } catch (e) {}
	try
	{
		target.setAIAgent(_handle.OriginalAgent);
		if (_handle.OriginalAgent != null) _handle.OriginalAgent.setActor(target);
	}
	catch (e) {}
	try { target.setFaction(_handle.OriginalFaction); } catch (e) {}
	local success = ::$bvvar{namespace}.isValkyrieTemporaryControlStateExact(target, _handle.OriginalFaction, _handle.OriginalAgent, _handle.OriginalControlled);
	if (!success)
	{
		// Restoration is transactional. If any original state component could
		// not be restored, return to the coherent AI-allied state and retain the
		// live handle so combat reset can retry later.
		try { target.setFaction(::Const.Faction.Player); } catch (ignored) {}
		try { target.setAIAgent(_handle.ControlledAgent); if (_handle.ControlledAgent != null) _handle.ControlledAgent.setActor(target); } catch (ignored) {}
		try { target.m.IsControlledByPlayer = false; } catch (ignored) {}
		_handle.Active <- true;
		_handle.Restored <- false;
	}
	::$bvvar{namespace}.refreshValkyrieTemporaryControlEntity(target);

	if (success)
	{
		_handle.Restored <- true;
		_handle.Active <- false;
		::$bvvar{namespace}.removeValkyrieTemporaryControlHandle(_handle);
	}
	return success;
};

::$bvvar{namespace}.acquireValkyrieTemporaryPlayerControl <- function( _target, _controller = null, _directInput = false )
{
	local denial = ::$bvvar{namespace}.getValkyrieTemporaryControlDenialReason(_target, _controller, _directInput);
	if (denial != null)
	{
		::$bvvar{namespace}.logKafkaTemporaryControlFailure("preflight", _target, denial);
		return null;
	}

	local handle = null;
	local stage = "snapshot";
	try
	{
		local originalAgent = _target.getAIAgent();
		handle = {
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target),
			ControllerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_controller),
			ControllerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_controller),
			OriginalFaction = _target.getFaction(),
			OriginalAgent = originalAgent,
			OriginalControlled = _target.m.IsControlledByPlayer,
			ControlledAgent = originalAgent,
			Active = true,
			Restored = false,
			Reason = null
		};
		// Register before the first actor mutation.  A setter may mutate and then
		// throw; in that case the handle must remain discoverable for reset/retry.
		::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles.push(handle);
		stage = "set_faction";
		_target.setFaction(::Const.Faction.Player);
		// Like allied warhounds, the default converted enemy remains AI-driven. Keeping
		// the exact already-bound original agent avoids exposing enemy actives to
		// player input. Do not rebind it: some AI agents reject a second setActor.
		if (_directInput)
		{
			stage = "bind_player_agent";
			handle.ControlledAgent = ::new("scripts/ai/tactical/player_agent");
			handle.ControlledAgent.setActor(_target);
			_target.setAIAgent(handle.ControlledAgent);
		}
		stage = "set_direct_input";
		_target.m.IsControlledByPlayer = _directInput;
		stage = "verify";
		if (!::$bvvar{namespace}.isValkyrieTemporaryControlStateExact(_target, ::Const.Faction.Player, handle.ControlledAgent, _directInput)) throw "temporary control state was not committed";
		::$bvvar{namespace}.refreshValkyrieTemporaryControlEntity(_target);
		return handle;
	}
	catch (e)
	{
		::$bvvar{namespace}.logKafkaTemporaryControlFailure(stage, _target, e);
		if (handle != null)
		{
			::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl(handle, "acquire_failed");
		}
		return null;
	}
};

::$bvvar{namespace}.getValkyrieTemporaryControlActors <- function()
{
	try { return ::Tactical.Entities.getAllInstancesAsArray(); }
	catch (e) { return []; }
};

::$bvvar{namespace}.isValkyrieTemporaryControlLastHostile <- function( _handle )
{
	if (_handle == null || typeof _handle != "table" || !("Active" in _handle) || !_handle.Active || ("Restored" in _handle && _handle.Restored)) return false;
	local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_handle.TargetRef);
	if (target == null) return false;
	try { if (!target.isAlive()) return false; } catch (e) { return false; }

	foreach (actor in ::$bvvar{namespace}.getValkyrieTemporaryControlActors())
	{
		if (actor == null || actor == target) continue;
		try
		{
			if (!actor.isAlive() || !actor.isPlacedOnMap() || actor.isNonCombatant()) continue;
			if (!actor.isAlliedWith(::Const.Faction.Player)) return false;
		}
		catch (e) {}
	}
	return true;
};

::$bvvar{namespace}.releaseValkyrieTemporaryControlsIfLastHostile <- function( _reason = "last_hostile_precheck" )
{
	local handles = clone ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles;
	local success = true;
	foreach (handle in handles)
	{
		if (::$bvvar{namespace}.isValkyrieTemporaryControlLastHostile(handle)
			&& !::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl(handle, _reason)) success = false;
	}
	return success;
};

::$bvvar{namespace}.resetValkyrieTemporaryPlayerControls <- function( _reason = "reset" )
{
	local handles = clone ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles;
	for (local i = handles.len() - 1; i >= 0; i--)
	{
		::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl(handles[i], _reason);
	}
	return ::$bvvar{namespace}.ValkyrieTemporaryControlRuntime.Handles.len() == 0;
};
