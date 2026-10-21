// Shared combat-action event routing for built-in and character-pack Valkyries.
// Persistent runtime state may only retain weak actor, skill and target handles.

::$bvvar{namespace}.ValkyrieCombatEvents <- {
	Epoch = 0,
	NextActionOrdinal = 1,
	NextAttemptOrdinal = 1,
	NextContinuationOrdinal = 1,
	NextSourceOrdinal = 1,
	NextFixedDamageOrdinal = 1,
	NextWeaponAttackPolicyOrdinal = 1,
	NextNeutralWeaponAttackOrdinal = 1,
	OpenContexts = [],
	DispatchStack = [],
	AttemptStack = [],
	SourceStack = [],
	FixedDamageFrames = [],
	WeaponAttackPolicies = [],
	FixedDamageMarkerToken = {},
	DispatchEventDepth = 0,
	MaxDispatchEventDepth = 16,
	ActiveSubscriberFrames = []
};

::$bvvar{namespace}.makeValkyrieCombatWeakRef <- function( _value )
{
	if (_value == null)
	{
		return null;
	}

	try
	{
		return ::WeakTableRef(_value);
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.readValkyrieCombatWeakRef <- function( _value )
{
	if (_value == null)
	{
		return null;
	}

	try
	{
		if (typeof _value == "instance" && (_value instanceof ::WeakTableRef))
		{
			if (_value.isNull())
			{
				return null;
			}
			return _value.get();
		}
	}
	catch (e)
	{
		return null;
	}

	return _value;
};

::$bvvar{namespace}.getValkyrieCombatObjectID <- function( _value )
{
	if (_value == null)
	{
		return null;
	}

	try
	{
		return _value.getID();
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.sameValkyrieCombatObject <- function( _weakValue, _value, _id = null )
{
	local current = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_weakValue);
	if (current != null && current == _value)
	{
		return true;
	}

	local valueID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_value);
	local expectedID = _id == null ? valueID : _id;
	return expectedID != null && valueID == expectedID && ::$bvvar{namespace}.getValkyrieCombatObjectID(current) == expectedID;
};

::$bvvar{namespace}.getValkyrieActors <- function()
{
	local ret = [];
	local roster = null;
	try
	{
		roster = ::World.getPlayerRoster().getAll();
	}
	catch (e)
	{
		return ret;
	}

	foreach (actor in roster)
	{
		actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(actor);
		if (actor == null)
		{
			continue;
		}
		local valkyrieID = null;
		try
		{
			valkyrieID = ::$bvvar{namespace}.getActorFlagString(actor, ::$bvvar{namespace}.ValkyrieIDFlag);
		}
		catch (e)
		{
			valkyrieID = null;
		}

		if (valkyrieID != null && valkyrieID != "" && ::$bvvar{namespace}.getValkyrieByID(valkyrieID) != null)
		{
			ret.push(actor);
		}
	}

	return ret;
};

::$bvvar{namespace}.isRosterValkyrie <- function( _actor )
{
	local actorValue = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_actor);
	if (actorValue == null)
	{
		return false;
	}

	local actorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(actorValue);
	foreach (rosterActor in ::$bvvar{namespace}.getValkyrieActors())
	{
		if (rosterActor == actorValue || (actorID != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(rosterActor) == actorID))
		{
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.isEligibleRosterAlly <- function( _owner, _actor )
{
	local ownerValue = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_owner);
	local actorValue = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_actor);
	if (ownerValue == null || actorValue == null)
	{
		return false;
	}
	local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(ownerValue);
	local actorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(actorValue);
	if (ownerValue == actorValue || (ownerID != null && ownerID == actorID))
	{
		return false;
	}

	local isRosterMember = false;
	try
	{
		foreach (rosterActor in ::World.getPlayerRoster().getAll())
		{
			rosterActor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(rosterActor);
			if (rosterActor == actorValue || (actorID != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(rosterActor) == actorID))
			{
				isRosterMember = true;
				break;
			}
		}
	}
	catch (e)
	{
		return false;
	}
	if (!isRosterMember)
	{
		return false;
	}
	try
	{
		return ownerValue.isAlliedWith(actorValue);
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isDirectAttack <- function( _skill )
{
	try
	{
		return _skill != null && _skill.isActive() && _skill.isAttack();
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isActiveWeaponAttack <- function( _skill )
{
	if (!::$bvvar{namespace}.isDirectAttack(_skill))
	{
		return false;
	}

	try
	{
		// Both the skill.m table and IsWeaponSkill itself may come from a
		// delegate in vanilla or compatibility-hooked skills. Direct access is
		// delegate-aware; the `in` operator is not reliable for this purpose.
		// In the live game (notably with Legends), m may be an instance rather
		// than a plain table. Direct slot access works for both forms.
		return _skill.m.IsWeaponSkill;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isCounterOrAOO <- function( _value )
{
	local source = typeof _value == "table" && "Source" in _value ? _value.Source : _value;
	if (typeof source == "table")
	{
		local actor = null;
		try { actor = source.getContainer().getActor(); } catch (e) { actor = null; }
		local frame = actor == null ? null : ::$bvvar{namespace}.getCurrentValkyrieCombatSource(actor, source);
		source = frame == null ? null : frame.Source;
	}
	return ::BattleValkyriesCombatActionStateReducer.isValkyrieCounterOrAOOActionSource(source);
};

::$bvvar{namespace}.isValkyrieFollowup <- function( _value )
{
	local source = typeof _value == "table" && "Source" in _value ? _value.Source : _value;
	if (typeof source == "table")
	{
		local actor = null;
		try { actor = source.getContainer().getActor(); } catch (e) { actor = null; }
		local frame = actor == null ? null : ::$bvvar{namespace}.getCurrentValkyrieCombatSource(actor, source);
		source = frame == null ? null : frame.Source;
	}
	return ::BattleValkyriesCombatActionStateReducer.isValkyrieFollowupActionSource(source);
};

::$bvvar{namespace}.pushValkyrieCombatSource <- function( _source, _actor, _metadata = null )
{
	if (typeof _source != "string" || _source.len() == 0 || _actor == null)
	{
		return null;
	}
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local token = "bv-source-" + runtime.Epoch + "-" + runtime.NextSourceOrdinal;
	runtime.NextSourceOrdinal++;
	local sourceSkill = _metadata != null && typeof _metadata == "table" && "Skill" in _metadata ? _metadata.Skill : null;
	local safeMetadata = {};
	if (_metadata != null && typeof _metadata == "table")
	{
		foreach (key, value in _metadata)
		{
			local valueType = typeof value;
			if (key != "Skill" && (valueType == "string" || valueType == "integer" || valueType == "float" || valueType == "bool" || valueType == "null"))
			{
				safeMetadata[key] <- value;
			}
		}
	}
	runtime.SourceStack.push({
		Token = token,
		Source = _source,
		ActorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor),
		ActorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor),
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(sourceSkill),
		SkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(sourceSkill),
		Metadata = safeMetadata
	});
	return token;
};

::$bvvar{namespace}.pushValkyrieActionSource <- ::$bvvar{namespace}.pushValkyrieCombatSource;

::$bvvar{namespace}.popValkyrieCombatSource <- function( _token )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.SourceStack;
	if (stack.len() == 0 || typeof _token != "string" || stack[stack.len() - 1].Token != _token)
	{
		return false;
	}
	stack.remove(stack.len() - 1);
	return true;
};

::$bvvar{namespace}.popValkyrieActionSource <- ::$bvvar{namespace}.popValkyrieCombatSource;

::$bvvar{namespace}.getCurrentValkyrieCombatSource <- function( _actor, _skill = null )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.SourceStack;
	for (local i = stack.len() - 1; i >= 0; i = i - 1)
	{
		local frame = stack[i];
		if (!::$bvvar{namespace}.sameValkyrieCombatObject(frame.ActorRef, _actor, frame.ActorID))
		{
			continue;
		}
		if (frame.SkillRef != null && _skill != null && !::$bvvar{namespace}.sameValkyrieCombatObject(frame.SkillRef, _skill, frame.SkillID))
		{
			continue;
		}
		return frame;
	}
	return null;
};

::$bvvar{namespace}.isValkyrieSubscriberFrameActive <- function( _skill, _event )
{
	local eventType = _event != null && "Type" in _event ? _event.Type : null;
	local actionToken = _event != null && "ActionToken" in _event ? _event.ActionToken : null;
	local attemptToken = _event != null && "AttemptToken" in _event ? _event.AttemptToken : null;
	foreach (frame in ::$bvvar{namespace}.ValkyrieCombatEvents.ActiveSubscriberFrames)
	{
		if (frame.EventType == eventType && frame.ActionToken == actionToken && frame.AttemptToken == attemptToken
			&& ::$bvvar{namespace}.sameValkyrieCombatObject(frame.SkillRef, _skill, frame.SkillID))
		{
			return true;
		}
	}
	return false;
};

::$bvvar{namespace}.getCurrentValkyrieSubscriberActionToken <- function( _skill )
{
	local frames = ::$bvvar{namespace}.ValkyrieCombatEvents.ActiveSubscriberFrames;
	for (local i = frames.len() - 1; i >= 0; i = i - 1)
	{
		local frame = frames[i];
		if (::$bvvar{namespace}.sameValkyrieCombatObject(frame.SkillRef, _skill, frame.SkillID))
		{
			return frame.ActionToken;
		}
	}
	return null;
};

::$bvvar{namespace}.popValkyrieSubscriberFrame <- function( _frame )
{
	local frames = ::$bvvar{namespace}.ValkyrieCombatEvents.ActiveSubscriberFrames;
	if (frames.len() != 0 && frames[frames.len() - 1] == _frame)
	{
		frames.remove(frames.len() - 1);
	}
};

::$bvvar{namespace}.dispatchValkyrieCombatEvent <- function( _event )
{
	if (_event != null && "onValkyrieVoiceCombatEvent" in this)
	{
		try { this.onValkyrieVoiceCombatEvent(_event); }
		catch (e) { ::logWarning("[Battle Valkyries] Voice action feedback failed: " + e); }
	}
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	if (_event == null || runtime.DispatchEventDepth >= runtime.MaxDispatchEventDepth)
	{
		return false;
	}
	local entryEpoch = runtime.Epoch;
	runtime.DispatchEventDepth++;
	local actors = null;
	try
	{
		actors = ::$bvvar{namespace}.getValkyrieActors();
	}
	catch (e)
	{
		if (runtime.Epoch == entryEpoch && runtime.DispatchEventDepth > 0) runtime.DispatchEventDepth--;
		return false;
	}
	foreach (actor in actors)
	{
		local container = null;
		local snapshot = [];
		try
		{
			container = actor.getSkills();
			if (container == null || !("m" in container) || !("Skills" in container.m))
			{
				continue;
			}
			foreach (skill in container.m.Skills)
			{
				snapshot.push(skill);
			}
		}
		catch (e)
		{
			continue;
		}

		foreach (skill in snapshot)
		{
			if (!::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(skill))
			{
				continue;
			}

			if (::$bvvar{namespace}.isValkyrieSubscriberFrameActive(skill, _event))
			{
				continue;
			}

			local key = null;
			local definition = null;
			try
			{
				key = skill.getBattleValkyriesSkillKey();
				definition = ::$bvvar{namespace}.getSkillDefinition(key);
			}
			catch (e)
			{
				try { ::$bvvar{namespace}.logValkyrieSkillFailure(actor, key, e, "combat_event.definition"); } catch (ignored) {}
				continue;
			}
			if (definition == null || !("Kind" in definition) || (definition.Kind != "active" && definition.Kind != "passive"))
			{
				continue;
			}
			local frame = {
				SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(skill),
				SkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(skill),
				EventType = "Type" in _event ? _event.Type : null,
				ActionToken = "ActionToken" in _event ? _event.ActionToken : null,
				AttemptToken = "AttemptToken" in _event ? _event.AttemptToken : null
			};
			runtime.ActiveSubscriberFrames.push(frame);
			try
			{
				skill.onValkyrieCombatEvent(_event);
			}
			catch (e)
			{
				try { ::$bvvar{namespace}.logValkyrieSkillFailure(actor, key, e, "combat_event.dispatch"); } catch (ignored) {}
			}
			::$bvvar{namespace}.popValkyrieSubscriberFrame(frame);
			if (runtime.Epoch != entryEpoch)
			{
				return false;
			}
		}
	}
	if (runtime.Epoch == entryEpoch && runtime.DispatchEventDepth > 0) runtime.DispatchEventDepth--;
	return true;
};

::$bvvar{namespace}.isOpenValkyrieActionContext <- function( _context )
{
	if (_context == null)
	{
		return false;
	}

	foreach (context in ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts)
	{
		if (context == _context)
		{
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.removeOpenValkyrieActionContext <- function( _context )
{
	local contexts = ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts;
	for (local i = contexts.len() - 1; i >= 0; i = i - 1)
	{
		if (contexts[i] == _context)
		{
			if (_context != null && "ActionToken" in _context
				&& "releaseValkyrieAttackNullificationAdapterForAction" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.releaseValkyrieAttackNullificationAdapterForAction(_context.ActionToken);
			}
			contexts.remove(i);
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.getValkyrieCombatTargetFromTile <- function( _targetTile )
{
	if (_targetTile == null)
	{
		return null;
	}

	try
	{
		return _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getValkyrieActionContainerBusy <- function( _context )
{
	local user = _context == null ? null : ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.UserRef);
	if (user == null)
	{
		return false;
	}

	try
	{
		return user.getSkills().isBusy();
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.commitValkyrieAction <- function( _context )
{
	if (_context == null || _context.State.Committed || _context.State.Cancelled || _context.State.Finalized)
	{
		return false;
	}

	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, { Type = "COMMITTED" });
	local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.UserRef);
	local skill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.SkillRef);
	local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.TargetRef);
	::$bvvar{namespace}.dispatchValkyrieCombatEvent({
		Type = "ActionStarted",
		ActionToken = _context.ActionToken,
		ParentActionToken = _context.ParentActionToken,
		Actor = actor,
		Skill = skill,
		SkillID = _context.SkillID,
		Target = target,
		Source = _context.Source,
		IsFree = _context.IsFree,
		IsImplicit = _context.IsImplicit,
		IsDirectAttack = _context.IsDirectAttack,
		IsActiveWeaponAttack = _context.IsActiveWeaponAttack,
		IsCounterOrAOO = ::$bvvar{namespace}.isCounterOrAOO(_context),
		IsFollowup = ::$bvvar{namespace}.isValkyrieFollowup(_context)
	});
	return true;
};

::$bvvar{namespace}.beginValkyrieAction <- function( _user, _skill, _targetTile = null, _isFree = false )
{
	if (_user == null || _skill == null)
	{
		return null;
	}

	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local sourceFrame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_user, _skill);
	local explicitSource = sourceFrame == null ? null : sourceFrame.Source;
	if (explicitSource == null && ::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(_skill))
	{
		explicitSource = "managed_active";
	}
	local source = ::BattleValkyriesCombatActionStateReducer.classifyValkyrieCombatActionSource(explicitSource, _isFree, true, explicitSource == "followup");
	local actionToken = "bv-action-" + runtime.Epoch + "-" + runtime.NextActionOrdinal;
	runtime.NextActionOrdinal++;
	local target = ::$bvvar{namespace}.getValkyrieCombatTargetFromTile(_targetTile);
	local skillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill);
	local isDirectAttack = ::$bvvar{namespace}.isDirectAttack(_skill);
	local isActiveWeaponAttack = ::$bvvar{namespace}.isActiveWeaponAttack(_skill);
	local parentContext = runtime.DispatchStack.len() == 0 ? null : runtime.DispatchStack[runtime.DispatchStack.len() - 1];
	local metadataParentActionToken = sourceFrame != null && "ParentActionToken" in sourceFrame.Metadata ? sourceFrame.Metadata.ParentActionToken : null;
	local parentActionToken = explicitSource != "followup" ? null
		: (metadataParentActionToken != null ? metadataParentActionToken : (parentContext == null ? null : parentContext.ActionToken));
	local state = ::BattleValkyriesCombatActionStateReducer.createValkyrieCombatActionState({
		Epoch = runtime.Epoch,
		Generation = 0,
		ActionToken = actionToken,
		Source = source,
		IsFree = _isFree,
		IsImplicit = false,
		ParentActionToken = parentActionToken
	});
	local context = {
		ActionToken = actionToken,
		ParentActionToken = parentActionToken,
		Source = source,
		IsFree = _isFree,
		IsImplicit = false,
		UserRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_user),
		UserID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_user),
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill),
		SkillID = skillID,
		IsDirectAttack = isDirectAttack,
		IsActiveWeaponAttack = isActiveWeaponAttack,
		TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(target),
		TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(target),
		State = state,
		Attempts = {},
		SettlementTasks = [],
		SettlementTasksDrained = false,
		SettlementPublished = false
	};
	runtime.OpenContexts.push(context);
	return context;
};

::$bvvar{namespace}.beginImplicitValkyrieAction <- function( _user, _skill, _target )
{
	if (_user == null || _skill == null)
	{
		return null;
	}

	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local actionToken = "bv-action-" + runtime.Epoch + "-" + runtime.NextActionOrdinal;
	runtime.NextActionOrdinal++;
	local sourceFrame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_user, _skill);
	local explicitSource = sourceFrame == null ? null : sourceFrame.Source;
	local source = ::BattleValkyriesCombatActionStateReducer.classifyValkyrieCombatActionSource(
		explicitSource, false, explicitSource == "followup", explicitSource == "followup");
	local parentContext = runtime.DispatchStack.len() == 0 ? null : runtime.DispatchStack[runtime.DispatchStack.len() - 1];
	local metadataParentActionToken = sourceFrame != null && "ParentActionToken" in sourceFrame.Metadata ? sourceFrame.Metadata.ParentActionToken : null;
	local parentActionToken = explicitSource != "followup" ? null
		: (metadataParentActionToken != null ? metadataParentActionToken : (parentContext == null ? null : parentContext.ActionToken));
	local skillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill);
	local isDirectAttack = ::$bvvar{namespace}.isDirectAttack(_skill);
	local isActiveWeaponAttack = ::$bvvar{namespace}.isActiveWeaponAttack(_skill);
	local context = {
		ActionToken = actionToken,
		ParentActionToken = parentActionToken,
		Source = source,
		IsFree = false,
		IsImplicit = true,
		UserRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_user),
		UserID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_user),
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill),
		SkillID = skillID,
		IsDirectAttack = isDirectAttack,
		IsActiveWeaponAttack = isActiveWeaponAttack,
		TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target),
		TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target),
		State = ::BattleValkyriesCombatActionStateReducer.createValkyrieCombatActionState({
			Epoch = runtime.Epoch,
			Generation = 0,
			ActionToken = actionToken,
			Source = source,
			IsFree = false,
			IsImplicit = true,
			ParentActionToken = parentActionToken
		}),
		Attempts = {},
		SettlementTasks = [],
		SettlementTasksDrained = false,
		SettlementPublished = false
	};
	runtime.OpenContexts.push(context);
	return context;
};

// Register a finite tactical mutation that must run after all original attack
// callbacks have completed, but before ActionSettling subscribers are notified.
// The weak skill reference keeps open action contexts free of persistent actor
// ownership, while the dedicated callback avoids starting a nested attack from
// inside the combat-event subscriber stack.
::$bvvar{namespace}.queueValkyrieActionSettlementTask <- function( _actionToken, _skill )
{
	if (typeof _actionToken != "string" || _actionToken.len() == 0 || _skill == null)
	{
		return false;
	}
	local context = null;
	foreach (candidate in ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts)
	{
		if (candidate.ActionToken == _actionToken && !candidate.State.Cancelled && !candidate.State.Finalized)
		{
			context = candidate;
			break;
		}
	}
	if (context == null || context.SettlementPublished || context.SettlementTasksDrained)
	{
		return false;
	}

	local skillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill);
	foreach (task in context.SettlementTasks)
	{
		if (::$bvvar{namespace}.sameValkyrieCombatObject(task.SkillRef, _skill, task.SkillID))
		{
			return true;
		}
	}
	context.SettlementTasks.push({
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill),
		SkillID = skillID
	});
	return true;
};

::$bvvar{namespace}.runValkyrieActionSettlementTasks <- function( _context )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context)
		|| _context.SettlementTasksDrained)
	{
		return false;
	}

	_context.SettlementTasksDrained = true;
	local tasks = _context.SettlementTasks;
	_context.SettlementTasks = [];
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local entryEpoch = runtime.Epoch;
	local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.UserRef);
	foreach (task in tasks)
	{
		if (runtime.Epoch != entryEpoch || !::$bvvar{namespace}.isOpenValkyrieActionContext(_context))
		{
			break;
		}
		local skill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(task.SkillRef);
		if (skill == null || !("onValkyrieActionSettlement" in skill))
		{
			continue;
		}
		try
		{
			skill.onValkyrieActionSettlement(_context.ActionToken);
		}
		catch (e)
		{
			try { ::$bvvar{namespace}.logValkyrieSkillFailure(actor, task.SkillID, e, "combat_event.settlement_task"); } catch (ignored) {}
		}
	}
	return true;
};

::$bvvar{namespace}.enterValkyrieActionDispatch <- function( _context )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context))
	{
		return false;
	}

	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, { Type = "DISPATCH_ENTERED" });
	::$bvvar{namespace}.ValkyrieCombatEvents.DispatchStack.push(_context);
	return true;
};

::$bvvar{namespace}.leaveValkyrieActionDispatch <- function( _context )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.DispatchStack;
	if (stack.len() == 0 || stack[stack.len() - 1] != _context)
	{
		return false;
	}
	stack.remove(stack.len() - 1);

	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context) || _context.State.DispatchDepth <= 0)
	{
		return false;
	}

	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, { Type = "DISPATCH_LEFT" });
	return true;
};

::$bvvar{namespace}.getCurrentValkyrieActionContext <- function( _user = null, _skill = null )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.DispatchStack;
	for (local i = stack.len() - 1; i >= 0; i = i - 1)
	{
		local context = stack[i];
		if (( _user == null || ::$bvvar{namespace}.sameValkyrieCombatObject(context.UserRef, _user, context.UserID))
			&& (_skill == null || ::$bvvar{namespace}.sameValkyrieCombatObject(context.SkillRef, _skill, context.SkillID)))
		{
			return context;
		}
	}

	return null;
};

::$bvvar{namespace}.findUnresolvedValkyrieAction <- function( _user, _skill )
{
	local contexts = ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts;
	for (local i = contexts.len() - 1; i >= 0; i = i - 1)
	{
		local context = contexts[i];
		if (context.State.Cancelled || context.State.Finalized || !context.State.RootReturned)
		{
			continue;
		}
		if (::$bvvar{namespace}.sameValkyrieCombatObject(context.UserRef, _user, context.UserID)
			&& ::$bvvar{namespace}.sameValkyrieCombatObject(context.SkillRef, _skill, context.SkillID))
		{
			return context;
		}
	}

	return null;
};

::$bvvar{namespace}.beginValkyrieTargetAttempt <- function( _context, _user, _skill, _target )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context) || _context.State.Cancelled || _context.State.Finalized)
	{
		return null;
	}

	::$bvvar{namespace}.commitValkyrieAction(_context);
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local attemptID = _context.ActionToken + ":attempt-" + runtime.NextAttemptOrdinal;
	runtime.NextAttemptOrdinal++;
	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, {
		Type = "ATTEMPT_OPENED",
		AttemptID = attemptID,
		TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target)
	});
	local attempt = {
		Context = _context,
		AttemptID = attemptID,
		UserRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_user),
		UserID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_user),
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill),
		SkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill),
		TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target),
		TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target),
		BodyPart = null,
		HitpointDamage = 0,
		ArmorDamage = 0,
		LegacyHit = false,
		LegacyMiss = false,
		Published = false
	};
	_context.Attempts[attemptID] <- attempt;
	return attempt;
};

::$bvvar{namespace}.isPendingValkyrieAttempt <- function( _attempt )
{
	return _attempt != null
		&& ::$bvvar{namespace}.isOpenValkyrieActionContext(_attempt.Context)
		&& ::BattleValkyriesCombatActionStateReducer.isValkyrieCombatAttemptOpen(_attempt.Context.State, _attempt.AttemptID);
};

::$bvvar{namespace}.retargetValkyrieTargetAttempt <- function( _attempt, _target )
{
	if (!::$bvvar{namespace}.isPendingValkyrieAttempt(_attempt) || _target == null)
	{
		return false;
	}
	local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
	if (targetID == null || (_attempt.TargetID == targetID && ::$bvvar{namespace}.sameValkyrieCombatObject(_attempt.TargetRef, _target, targetID)))
	{
		return false;
	}
	local context = _attempt.Context;
	local beforeGeneration = context.State.Generation;
	context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, {
		Type = "ATTEMPT_RETARGETED",
		AttemptID = _attempt.AttemptID,
		TargetID = targetID
	});
	if (context.State.Generation == beforeGeneration)
	{
		return false;
	}
	_attempt.TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target);
	_attempt.TargetID = targetID;
	::$bvvar{namespace}.deferValkyrieActionResolved(context);
	return true;
};

::$bvvar{namespace}.retargetCurrentValkyrieTargetAttempt <- function( _attacker, _target )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.AttemptStack;
	if (stack.len() == 0)
	{
		return false;
	}
	local attempt = stack[stack.len() - 1];
	return ::$bvvar{namespace}.isPendingValkyrieAttempt(attempt)
		&& ::$bvvar{namespace}.sameValkyrieCombatObject(attempt.UserRef, _attacker, attempt.UserID)
		&& ::$bvvar{namespace}.retargetValkyrieTargetAttempt(attempt, _target);
};

::$bvvar{namespace}.pushValkyrieAttempt <- function( _attempt )
{
	if (!::$bvvar{namespace}.isPendingValkyrieAttempt(_attempt))
	{
		return false;
	}
	::$bvvar{namespace}.ValkyrieCombatEvents.AttemptStack.push(_attempt);
	return true;
};

::$bvvar{namespace}.popValkyrieAttempt <- function( _attempt )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.AttemptStack;
	for (local i = stack.len() - 1; i >= 0; i = i - 1)
	{
		if (stack[i] == _attempt)
		{
			stack.remove(i);
			return true;
		}
	}
	return false;
};

::$bvvar{namespace}.findValkyrieTargetAttempt <- function( _user, _skill, _target )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.AttemptStack;
	for (local i = stack.len() - 1; i >= 0; i = i - 1)
	{
		local attempt = stack[i];
		if (::$bvvar{namespace}.isPendingValkyrieAttempt(attempt)
			&& ::$bvvar{namespace}.sameValkyrieCombatObject(attempt.UserRef, _user, attempt.UserID)
			&& ::$bvvar{namespace}.sameValkyrieCombatObject(attempt.SkillRef, _skill, attempt.SkillID)
			&& ::$bvvar{namespace}.sameValkyrieCombatObject(attempt.TargetRef, _target, attempt.TargetID))
		{
			return attempt;
		}
	}

	foreach (context in ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts)
	{
		foreach (attemptID in context.State.AttemptOrder)
		{
			if (!(attemptID in context.Attempts))
			{
				continue;
			}
			local attempt = context.Attempts[attemptID];
			if (!::$bvvar{namespace}.isPendingValkyrieAttempt(attempt)
				|| !::$bvvar{namespace}.sameValkyrieCombatObject(attempt.UserRef, _user, attempt.UserID)
				|| !::$bvvar{namespace}.sameValkyrieCombatObject(attempt.SkillRef, _skill, attempt.SkillID))
			{
				continue;
			}
			if (::$bvvar{namespace}.sameValkyrieCombatObject(attempt.TargetRef, _target, attempt.TargetID))
			{
				return attempt;
			}
		}
	}
	return null;
};

::$bvvar{namespace}.claimValkyrieScheduledTargetAttempt <- function( _user, _skill, _actualTarget )
{
	if (_actualTarget != null)
	{
		local exact = ::$bvvar{namespace}.findValkyrieTargetAttempt(_user, _skill, _actualTarget);
		if (exact != null)
		{
			return exact;
		}
	}
	// actor.onAttacked normally retargets before scheduling.  This explicit
	// callback-only fallback is deterministic FIFO for compatibility with a
	// third-party attack implementation that skips onAttacked.
	foreach (context in ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts)
	{
		foreach (attemptID in context.State.AttemptOrder)
		{
			if (!(attemptID in context.Attempts)) continue;
			local attempt = context.Attempts[attemptID];
			if (::$bvvar{namespace}.isPendingValkyrieAttempt(attempt)
				&& ::$bvvar{namespace}.sameValkyrieCombatObject(attempt.UserRef, _user, attempt.UserID)
				&& ::$bvvar{namespace}.sameValkyrieCombatObject(attempt.SkillRef, _skill, attempt.SkillID)
				&& (_actualTarget == null || ::$bvvar{namespace}.retargetValkyrieTargetAttempt(attempt, _actualTarget)))
			{
				return attempt;
			}
		}
	}
	return null;
};

::$bvvar{namespace}.publishValkyrieTargetResolved <- function( _attacker, _skill, _target, _bodyPart, _hpDamage, _armorDamage, _hit )
{
	local attempt = ::$bvvar{namespace}.findValkyrieTargetAttempt(_attacker, _skill, _target);
	local implicit = false;
	if (attempt == null)
	{
		local context = ::$bvvar{namespace}.beginImplicitValkyrieAction(_attacker, _skill, _target);
		if (context == null)
		{
			return false;
		}
		attempt = ::$bvvar{namespace}.beginValkyrieTargetAttempt(context, _attacker, _skill, _target);
		implicit = true;
	}

	local resolved = ::$bvvar{namespace}.resolveValkyrieTargetAttempt(attempt, _hit, _bodyPart, _hpDamage, _armorDamage);
	if (implicit)
	{
		::$bvvar{namespace}.finishValkyrieAction(attempt.Context, true);
	}
	return resolved;
};

::$bvvar{namespace}.resolveValkyrieTargetAttempt <- function( _attempt, _hit, _bodyPart = null, _hpDamage = 0, _armorDamage = 0, _resolveContext = null )
{
	if (!::$bvvar{namespace}.isPendingValkyrieAttempt(_attempt) || _attempt.Published)
	{
		return false;
	}

	_attempt.BodyPart = _bodyPart == null ? _attempt.BodyPart : _bodyPart;
	_attempt.HitpointDamage = ::Math.max(_attempt.HitpointDamage, _hpDamage);
	_attempt.ArmorDamage = ::Math.max(_attempt.ArmorDamage, _armorDamage);
	local context = _attempt.Context;
	context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, {
		Type = "ATTEMPT_RESOLVED",
		AttemptID = _attempt.AttemptID,
		Hit = _hit,
		BodyPart = _attempt.BodyPart,
		HitpointDamage = _attempt.HitpointDamage,
		ArmorDamage = _attempt.ArmorDamage
	});
	_attempt.Published = true;
	local actualAttacker = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_attempt.UserRef);
	local actualSkill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_attempt.SkillRef);
	local actualTarget = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_attempt.TargetRef);
	if ("finalizeValkyrieAttackDefenseAttempt" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(_attempt, true, {
			User = actualAttacker,
			Skill = actualSkill,
			Target = actualTarget,
			Hit = _hit,
			Result = _resolveContext != null && "Result" in _resolveContext ? _resolveContext.Result : _hit,
			IsScheduled = _resolveContext != null && "IsScheduled" in _resolveContext && _resolveContext.IsScheduled
		});
	}
	::$bvvar{namespace}.dispatchValkyrieCombatEvent({
		Type = "TargetResolved",
		ActionToken = context.ActionToken,
		AttemptToken = _attempt.AttemptID,
		Attacker = actualAttacker,
		Skill = actualSkill,
		Target = actualTarget,
		TargetID = _attempt.TargetID,
		BodyPart = _attempt.BodyPart,
		HitpointDamage = _attempt.HitpointDamage,
		ArmorDamage = _attempt.ArmorDamage,
		Hit = _hit,
		Nullified = _resolveContext != null && "Nullified" in _resolveContext && _resolveContext.Nullified,
		Source = context.Source,
		IsFree = context.IsFree,
		IsImplicit = context.IsImplicit
	});
	::$bvvar{namespace}.deferValkyrieActionResolved(context);
	return true;
};

::$bvvar{namespace}.cancelValkyrieTargetAttempt <- function( _attempt, _reason = "cancelled" )
{
	if (!::$bvvar{namespace}.isPendingValkyrieAttempt(_attempt))
	{
		return false;
	}
	local context = _attempt.Context;
	context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, {
		Type = "ATTEMPT_CANCELLED",
		AttemptID = _attempt.AttemptID,
		Reason = _reason
	});
	::$bvvar{namespace}.deferValkyrieActionResolved(context);
	return true;
};

::$bvvar{namespace}.purgeValkyrieActionFrames <- function( _context )
{
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	for (local i = runtime.AttemptStack.len() - 1; i >= 0; i = i - 1)
	{
		if (runtime.AttemptStack[i].Context == _context)
		{
			runtime.AttemptStack.remove(i);
		}
	}
	for (local i = runtime.DispatchStack.len() - 1; i >= 0; i = i - 1)
	{
		if (runtime.DispatchStack[i] == _context)
		{
			runtime.DispatchStack.remove(i);
		}
	}
};

::$bvvar{namespace}.cancelValkyrieAction <- function( _context, _reason = "cancelled" )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context))
	{
		return false;
	}
	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, {
		Type = "CANCELLED",
		Reason = _reason
	});
	::$bvvar{namespace}.purgeValkyrieActionFrames(_context);
	::$bvvar{namespace}.removeOpenValkyrieActionContext(_context);
	return true;
};

// Last synchronous action phase: every target and delayed hit callback is
// complete, but the next-tick ActionResolved notification has not handed
// control back to tactical AI yet. Finite tactical mutations run as dedicated
// settlement tasks before the read-only ActionSettling subscriber broadcast.
::$bvvar{namespace}.trySettleValkyrieAction <- function( _context )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context)
		|| _context.State.Cancelled
		|| _context.State.Finalized
		|| ("SettlementPublished" in _context && _context.SettlementPublished))
	{
		return false;
	}

	local busy = ::$bvvar{namespace}.getValkyrieActionContainerBusy(_context);
	if (!::BattleValkyriesCombatActionStateReducer.canFinalizeValkyrieCombatAction(
		_context.State, _context.State.Epoch, _context.State.Generation, busy))
	{
		return false;
	}

	::$bvvar{namespace}.runValkyrieActionSettlementTasks(_context);
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context)
		|| _context.State.Cancelled || _context.State.Finalized)
	{
		return false;
	}
	busy = ::$bvvar{namespace}.getValkyrieActionContainerBusy(_context);
	if (!::BattleValkyriesCombatActionStateReducer.canFinalizeValkyrieCombatAction(
		_context.State, _context.State.Epoch, _context.State.Generation, busy))
	{
		return false;
	}

	// Claim before dispatch so nested attacks and re-entrant subscribers cannot
	// publish the same settlement twice.
	_context.SettlementPublished = true;
	local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.UserRef);
	local skill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.SkillRef);
	local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_context.TargetRef);
	return ::$bvvar{namespace}.dispatchValkyrieCombatEvent({
		Type = "ActionSettling",
		ActionToken = _context.ActionToken,
		ParentActionToken = _context.ParentActionToken,
		Actor = actor,
		Skill = skill,
		SkillID = _context.SkillID,
		Target = target,
		TargetID = _context.TargetID,
		Source = _context.Source,
		IsFree = _context.IsFree,
		IsImplicit = _context.IsImplicit,
		IsDirectAttack = _context.IsDirectAttack,
		IsActiveWeaponAttack = _context.IsActiveWeaponAttack,
		IsCounterOrAOO = ::$bvvar{namespace}.isCounterOrAOO(_context),
		IsFollowup = ::$bvvar{namespace}.isValkyrieFollowup(_context),
		UseResult = _context.State.UseResult,
		TargetResults = _context.State.TargetResults
	});
};

::$bvvar{namespace}.finishValkyrieAction <- function( _context, _result )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context))
	{
		return _result;
	}

	local valid = _result || _context.State.AttemptOrder.len() > 0 || _context.State.Committed;
	if (valid)
	{
		::$bvvar{namespace}.commitValkyrieAction(_context);
	}
	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, {
		Type = "ROOT_RETURNED",
		Result = _result,
		Valid = valid
	});
	if (_context.State.Cancelled)
	{
		::$bvvar{namespace}.removeOpenValkyrieActionContext(_context);
		return _result;
	}

	::$bvvar{namespace}.trySettleValkyrieAction(_context);
	::$bvvar{namespace}.deferValkyrieActionResolved(_context);
	return _result;
};

// Custom delayed skills that do not keep skill_container busy must reserve a
// finite continuation before returning, then release it immediately before or
// after their later segment.  This avoids polling or global Time hooks.
::$bvvar{namespace}.reserveValkyrieActionContinuation <- function( _context, _reason = null )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context) || _context.State.Cancelled || _context.State.Finalized)
	{
		return null;
	}
	::$bvvar{namespace}.commitValkyrieAction(_context);
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local continuationID = "bv-continuation-" + runtime.Epoch + "-" + runtime.NextContinuationOrdinal;
	runtime.NextContinuationOrdinal++;
	local beforeGeneration = _context.State.Generation;
	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, {
		Type = "CONTINUATION_RESERVED",
		ContinuationID = continuationID,
		Reason = _reason
	});
	if (_context.State.Generation == beforeGeneration)
	{
		return null;
	}
	::$bvvar{namespace}.deferValkyrieActionResolved(_context);
	return continuationID;
};

::$bvvar{namespace}.releaseValkyrieActionContinuation <- function( _context, _continuationID )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context)
		|| typeof _continuationID != "string"
		|| !(_continuationID in _context.State.Continuations)
		|| _context.State.Continuations[_continuationID].Status != "pending")
	{
		return false;
	}
	local beforeGeneration = _context.State.Generation;
	_context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(_context.State, {
		Type = "CONTINUATION_RELEASED",
		ContinuationID = _continuationID
	});
	if (_context.State.Generation == beforeGeneration)
	{
		return false;
	}
	::$bvvar{namespace}.trySettleValkyrieAction(_context);
	::$bvvar{namespace}.deferValkyrieActionResolved(_context);
	return true;
};

::$bvvar{namespace}.deferValkyrieActionResolved <- function( _context )
{
	if (!::$bvvar{namespace}.isOpenValkyrieActionContext(_context) || _context.State.Cancelled || _context.State.Finalized)
	{
		return false;
	}

	local tag = {
		Context = _context,
		Epoch = _context.State.Epoch,
		Generation = _context.State.Generation
	};
	::Time.scheduleEvent(::TimeUnit.Virtual, 1, function( _tag )
	{
		local context = _tag.Context;
		if (::$bvvar{namespace}.ValkyrieCombatEvents.Epoch != _tag.Epoch
			|| !::$bvvar{namespace}.isOpenValkyrieActionContext(context)
			|| context.State.Epoch != _tag.Epoch
			|| context.State.Generation != _tag.Generation)
		{
			return;
		}

		local busy = ::$bvvar{namespace}.getValkyrieActionContainerBusy(context);
		if (!::BattleValkyriesCombatActionStateReducer.canFinalizeValkyrieCombatAction(context.State, _tag.Epoch, _tag.Generation, busy))
		{
			return;
		}

		local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(context.UserRef);
		local skill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(context.SkillRef);
		local targetResults = context.State.TargetResults;
		context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, {
			Type = "FINALIZED",
			Epoch = _tag.Epoch,
			Generation = _tag.Generation,
			Busy = busy
		});
		if (!context.State.Finalized)
		{
			return;
		}
		::$bvvar{namespace}.removeOpenValkyrieActionContext(context);
		::$bvvar{namespace}.dispatchValkyrieCombatEvent({
			Type = "ActionResolved",
			ActionToken = context.ActionToken,
			ParentActionToken = context.ParentActionToken,
			Actor = actor,
			Skill = skill,
			SkillID = context.SkillID,
			Source = context.Source,
			IsFree = context.IsFree,
			IsImplicit = context.IsImplicit,
			IsDirectAttack = context.IsDirectAttack,
			IsActiveWeaponAttack = context.IsActiveWeaponAttack,
			UseResult = context.State.UseResult,
			PaidAP = "PaidAP" in context ? context.PaidAP : 0,
			TargetResults = targetResults
		});
	}, tag);
	return true;
};

::$bvvar{namespace}.touchValkyrieActionBusy <- function( _container, _busy )
{
	local actor = null;
	try
	{
		actor = _container.getActor();
	}
	catch (e)
	{
		return;
	}

	foreach (context in ::$bvvar{namespace}.ValkyrieCombatEvents.OpenContexts)
	{
		if (!::$bvvar{namespace}.sameValkyrieCombatObject(context.UserRef, actor, context.UserID) || context.State.Cancelled || context.State.Finalized)
		{
			continue;
		}
		context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, { Type = "BUSY_CHANGED", Busy = _busy });
		context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, { Type = "TOUCHED" });
		::$bvvar{namespace}.deferValkyrieActionResolved(context);
	}
};

::$bvvar{namespace}.snapshotValkyrieDamageState <- function( _actor )
{
	local ret = { Hitpoints = 0, HeadArmor = 0, BodyArmor = 0 };
	if (_actor == null)
	{
		return ret;
	}
	try { ret.Hitpoints = _actor.getHitpoints(); } catch (e) {}
	try { ret.HeadArmor = _actor.getArmor(::Const.BodyPart.Head); } catch (e) {}
	try { ret.BodyArmor = _actor.getArmor(::Const.BodyPart.Body); } catch (e) {}
	return ret;
};

::$bvvar{namespace}.recordValkyrieAttemptBodyPart <- function( _attempt, _hitInfo )
{
	if (!::$bvvar{namespace}.isPendingValkyrieAttempt(_attempt) || _hitInfo == null || !("BodyPart" in _hitInfo))
	{
		return false;
	}
	_attempt.BodyPart = _hitInfo.BodyPart;
	return true;
};

::$bvvar{namespace}.publishValkyrieDamageResolved <- function( _victim, _attacker, _skill, _before, _after, _identity = null )
{
	if (_before == null || _after == null)
	{
		return false;
	}
	local hpDamage = ::Math.max(0, _before.Hitpoints - _after.Hitpoints);
	local headArmorDamage = ::Math.max(0, _before.HeadArmor - _after.HeadArmor);
	local bodyArmorDamage = ::Math.max(0, _before.BodyArmor - _after.BodyArmor);
	local armorDamage = headArmorDamage + bodyArmorDamage;
	local attempt = ::$bvvar{namespace}.findValkyrieTargetAttempt(_attacker, _skill, _victim);
	if (attempt != null)
	{
		attempt.HitpointDamage = attempt.HitpointDamage + hpDamage;
		attempt.ArmorDamage = attempt.ArmorDamage + armorDamage;
	}
	::$bvvar{namespace}.dispatchValkyrieCombatEvent({
		Type = "DamageResolved",
		ActionToken = _identity != null && "ActionToken" in _identity ? _identity.ActionToken : (attempt == null ? null : attempt.Context.ActionToken),
		AttemptToken = _identity != null && "AttemptToken" in _identity ? _identity.AttemptToken : (attempt == null ? null : attempt.AttemptID),
		FrameToken = _identity != null && "FrameToken" in _identity ? _identity.FrameToken : null,
		Source = _identity != null && "Source" in _identity ? _identity.Source : (attempt == null ? null : attempt.Context.Source),
		Victim = _victim,
		Attacker = _attacker,
		Skill = _skill,
		Before = _before,
		After = _after,
		HitpointDamage = hpDamage,
		HeadArmorDamage = headArmorDamage,
		BodyArmorDamage = bodyArmorDamage,
		ArmorDamage = armorDamage
	});
	return true;
};

::$bvvar{namespace}.prepareValkyrieAttackAttempt <- function( _user, _skill, _target )
{
	local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, _skill);
	local implicit = false;
	if (context == null)
	{
		context = ::$bvvar{namespace}.findUnresolvedValkyrieAction(_user, _skill);
	}
	if (context == null)
	{
		context = ::$bvvar{namespace}.beginImplicitValkyrieAction(_user, _skill, _target);
		implicit = true;
	}
	if (context == null)
	{
		return null;
	}

	::$bvvar{namespace}.enterValkyrieActionDispatch(context);
	local attempt = ::$bvvar{namespace}.beginValkyrieTargetAttempt(context, _user, _skill, _target);
	if (attempt == null)
	{
		::$bvvar{namespace}.leaveValkyrieActionDispatch(context);
		return null;
	}
	::$bvvar{namespace}.pushValkyrieAttempt(attempt);
	return { Context = context, Attempt = attempt, IsImplicit = implicit };
};

::$bvvar{namespace}.completeValkyrieAttackAttempt <- function( _route, _result )
{
	if (_route == null)
	{
		return _result;
	}
	::$bvvar{namespace}.popValkyrieAttempt(_route.Attempt);
	if (!_result && ::$bvvar{namespace}.isPendingValkyrieAttempt(_route.Attempt))
	{
		::$bvvar{namespace}.resolveValkyrieTargetAttempt(_route.Attempt, false, null, 0, 0);
	}
	::$bvvar{namespace}.leaveValkyrieActionDispatch(_route.Context);
	if (_route.IsImplicit)
	{
		::$bvvar{namespace}.finishValkyrieAction(_route.Context, _result || _route.Context.State.AttemptOrder.len() > 0);
	}
	else
	{
		::$bvvar{namespace}.deferValkyrieActionResolved(_route.Context);
	}
	return _result;
};

::$bvvar{namespace}.failValkyrieAttackAttempt <- function( _route, _reason )
{
	if (_route == null)
	{
		return;
	}
	::$bvvar{namespace}.popValkyrieAttempt(_route.Attempt);
	::$bvvar{namespace}.cancelValkyrieTargetAttempt(_route.Attempt, _reason);
	::$bvvar{namespace}.leaveValkyrieActionDispatch(_route.Context);
	::$bvvar{namespace}.cancelValkyrieAction(_route.Context, _reason);
};

::$bvvar{namespace}.failValkyrieScheduledTargetAttempt <- function( _attempt, _reason )
{
	if (_attempt == null)
	{
		return;
	}
	::$bvvar{namespace}.popValkyrieAttempt(_attempt);
	::$bvvar{namespace}.cancelValkyrieAction(_attempt.Context, _reason);
};

::$bvvar{namespace}.failValkyrieDamageAttempt <- function( _route, _attempt, _reason )
{
	if (_route != null)
	{
		::$bvvar{namespace}.failValkyrieAttackAttempt(_route, _reason);
	}
	else if (_attempt != null)
	{
		::$bvvar{namespace}.failValkyrieScheduledTargetAttempt(_attempt, _reason);
	}
};

::$bvvar{namespace}.markValkyrieLegacyTargetResult <- function( _caller, _target, _hit, _bodyPart = null, _hpDamage = 0, _armorDamage = 0 )
{
	local user = null;
	try { user = _caller.getContainer().getActor(); } catch (e) { user = null; }
	local attempt = ::$bvvar{namespace}.findValkyrieTargetAttempt(user, _caller, _target);
	if (attempt == null)
	{
		// Some vanilla/third-party actives inherit the shared use() lifecycle
		// but override attackEntity(). A successful hit is rescued later by
		// actor.onDamageReceived; a miss (including a shield block) only reaches
		// skill_container.onTargetMissed. Bridge that asymmetric legacy path
		// into the already-open explicit action so it can still publish
		// TargetResolved and, after root return, ActionResolved.
		//
		// Do not manufacture an implicit action here. Without an open root use
		// we cannot distinguish a paid active attack from a counter/AOO owned by
		// another mod, and those must not trigger active-attack passives.
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(user, _caller);
		if (context == null)
		{
			return;
		}
		local route = ::$bvvar{namespace}.prepareValkyrieAttackAttempt(user, _caller, _target);
		if (route == null || route.Attempt == null)
		{
			return;
		}
		::$bvvar{namespace}.resolveValkyrieTargetAttempt(route.Attempt, _hit, _bodyPart, _hpDamage, _armorDamage);
		::$bvvar{namespace}.completeValkyrieAttackAttempt(route, _hit);
		return;
	}
	if (_hit)
	{
		attempt.LegacyHit = true;
		attempt.BodyPart = _bodyPart;
		attempt.HitpointDamage = ::Math.max(attempt.HitpointDamage, _hpDamage);
		attempt.ArmorDamage = ::Math.max(attempt.ArmorDamage, _armorDamage);
	}
	else
	{
		attempt.LegacyMiss = true;
	}
};

::$bvvar{namespace}.resetValkyrieCombatEvents <- function( _reason = "reset" )
{
	if ("resetValkyrieTemporaryPlayerControls" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.resetValkyrieTemporaryPlayerControls(_reason);
	}
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local nextEpoch = runtime.Epoch + 1;
	foreach (context in runtime.OpenContexts)
	{
		context.State = ::BattleValkyriesCombatActionStateReducer.reduceValkyrieCombatActionState(context.State, {
			Type = "EPOCH_RESET",
			Epoch = nextEpoch,
			Reason = _reason
		});
	}
	runtime.Epoch = nextEpoch;
	runtime.NextActionOrdinal = 1;
	runtime.NextAttemptOrdinal = 1;
	runtime.NextContinuationOrdinal = 1;
	runtime.NextSourceOrdinal = 1;
	runtime.NextFixedDamageOrdinal = 1;
	runtime.NextWeaponAttackPolicyOrdinal = 1;
	runtime.NextNeutralWeaponAttackOrdinal = 1;
	runtime.OpenContexts = [];
	runtime.DispatchStack = [];
	runtime.AttemptStack = [];
	runtime.SourceStack = [];
	runtime.FixedDamageFrames = [];
	runtime.WeaponAttackPolicies = [];
	runtime.FixedDamageMarkerToken = {};
	runtime.DispatchEventDepth = 0;
	runtime.ActiveSubscriberFrames = [];
	if ("resetValkyrieAttackDefenseClaims" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.resetValkyrieAttackDefenseClaims();
	}
	if ("resetValkyrieAttackDefenseAdapter" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.resetValkyrieAttackDefenseAdapter();
	}
	if ("resetValkyrieAttackNullifications" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.resetValkyrieAttackNullifications();
	}
	if ("resetValkyrieAttackNullificationAdapter" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.resetValkyrieAttackNullificationAdapter();
	}
	if ("resetValkyrieWeaponSkillModifiers" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.resetValkyrieWeaponSkillModifiers(_reason);
	}
};
