::$bvvar{namespace}.ValkyrieAttackNullificationAdapter <- {
	EffectGateFrames = [],
	ExplicitSourceFrames = [],
	NextExplicitSourceOrdinal = 1,
	LateContainerGuardInstalled = false
};

::$bvvar{namespace}.resetValkyrieAttackNullificationAdapter <- function()
{
	this.ValkyrieAttackNullificationAdapter.EffectGateFrames = [];
	this.ValkyrieAttackNullificationAdapter.ExplicitSourceFrames = [];
};

::$bvvar{namespace}.getValkyrieAttackNullificationTargetProviders <- function( _target )
{
	local ret = [];
	try
	{
		local container = _target == null ? null : _target.getSkills();
		if (container == null || !("m" in container) || !("Skills" in container.m)) return ret;
		foreach (provider in container.m.Skills)
		{
			local accepted = false;
			try
			{
				accepted = this.isBattleValkyriesManagedRuntimeSkill(provider);
			}
			catch (e)
			{
				accepted = false;
			}
			if (!accepted)
			{
				try
				{
					accepted = provider != null
						&& provider.isBattleValkyriesManagedCombatEffect() == true
						&& provider.isGarbage() == false;
				}
				catch (e)
				{
					accepted = false;
				}
			}
			if (accepted) ret.push(provider);
		}
	}
	catch (e)
	{
	}
	return ret;
};

::$bvvar{namespace}.isEligibleValkyrieAttackNullification <- function( _attacker, _skill, _target )
{
	if (_attacker == null || _skill == null || _target == null || _attacker == _target)
	{
		return false;
	}
	try
	{
		if (!this.isDirectAttack(_skill) || _target.isAlliedWith(_attacker)) return false;
	}
	catch (e)
	{
		return false;
	}
	return true;
};

::$bvvar{namespace}.reserveValkyrieAttackNullificationForAttempt <- function( _attempt, _attacker, _skill, _target )
{
	if (_attempt == null || _attempt.Context == null
		|| !this.isEligibleValkyrieAttackNullification(_attacker, _skill, _target))
	{
		return null;
	}
	if ("NullificationPolicyFrozen" in _attempt) _attempt.NullificationPolicyFrozen = true;
	else _attempt.NullificationPolicyFrozen <- true;
	local actionToken = _attempt.Context.ActionToken;
	local targetID = this.getValkyrieCombatObjectID(_target);
	if (actionToken == null || targetID == null) return null;
	if ("NullificationReservationTargetID" in _attempt
		&& _attempt.NullificationReservationTargetID != targetID)
	{
		if ("NullificationReservationOwned" in _attempt && _attempt.NullificationReservationOwned)
		{
			this.releaseValkyrieAttackNullification(actionToken, _attempt.NullificationReservationTargetID);
		}
		delete _attempt.NullificationReservationTargetID;
		if ("NullificationReservationOwned" in _attempt) delete _attempt.NullificationReservationOwned;
	}
	local existing = this.getValkyrieAttackNullification(actionToken, targetID);
	if (existing != null)
	{
		_attempt.NullificationReservationTargetID <- targetID;
		_attempt.NullificationReservationOwned <- false;
		return existing;
	}
	local providers = this.getValkyrieAttackNullificationTargetProviders(_target);
	local policy = this.resolveValkyrieAttackNullificationPolicy(providers, _skill, _attacker);
	local reservation = this.reserveValkyrieAttackNullification(actionToken, targetID, policy);
	if (reservation != null)
	{
		_attempt.NullificationReservationTargetID <- targetID;
		_attempt.NullificationReservationOwned <- true;
	}
	return reservation;
};

::$bvvar{namespace}.armValkyrieAttackNullificationEffectGate <- function( _attempt, _attacker, _skill, _target )
{
	if (_attempt == null || _attempt.Context == null || _target == null
		|| !this.isPendingValkyrieAttempt(_attempt)) return null;
	local actionToken = _attempt.Context.ActionToken;
	local targetID = this.getValkyrieCombatObjectID(_target);
	foreach (frame in this.ValkyrieAttackNullificationAdapter.EffectGateFrames)
	{
		if (frame.AttemptID == _attempt.AttemptID)
		{
			frame.Armed = true;
			return frame;
		}
	}
	local frame = {
		ActionToken = actionToken,
		AttemptID = _attempt.AttemptID,
		TargetID = targetID,
		AttackerRef = this.makeValkyrieCombatWeakRef(_attacker),
		AttackerID = this.getValkyrieCombatObjectID(_attacker),
		SkillRef = this.makeValkyrieCombatWeakRef(_skill),
		SkillID = this.getValkyrieCombatObjectID(_skill),
		Armed = true
	};
	this.ValkyrieAttackNullificationAdapter.EffectGateFrames.push(frame);
	return frame;
};

::$bvvar{namespace}.consumeValkyrieAttackNullificationForAttempt <- function( _attempt, _attacker, _skill, _target, _context = null )
{
	if (_attempt == null || _attempt.Context == null
		|| !this.isEligibleValkyrieAttackNullification(_attacker, _skill, _target)) return false;
	local actionToken = _attempt.Context.ActionToken;
	local targetID = this.getValkyrieCombatObjectID(_target);
	local reservation = this.getValkyrieAttackNullification(actionToken, targetID);
	if (reservation == null) return false;
	local entryEpoch = "Epoch" in this.ValkyrieCombatEvents ? this.ValkyrieCombatEvents.Epoch : null;
	if (!reservation.Consumed && !this.consumeValkyrieAttackNullification(actionToken, targetID, _context)) return false;
	if ((entryEpoch != null && this.ValkyrieCombatEvents.Epoch != entryEpoch)
		|| !this.isPendingValkyrieAttempt(_attempt)
		|| this.getValkyrieAttackNullification(actionToken, targetID) != reservation)
	{
		return false;
	}
	_attempt.Nullified <- true;
	_attempt.NullificationReservationTargetID <- targetID;
	if ("HadConsumedNullification" in _attempt.Context) _attempt.Context.HadConsumedNullification = true;
	else _attempt.Context.HadConsumedNullification <- true;
	this.armValkyrieAttackNullificationEffectGate(_attempt, _attacker, _skill, _target);
	return true;
};

::$bvvar{namespace}.releaseValkyrieAttackNullificationForAttempt <- function( _attempt, _force = false )
{
	if (_attempt == null || _attempt.Context == null) return false;
	local removed = false;
	if (_force || ("NullificationReservationOwned" in _attempt && _attempt.NullificationReservationOwned))
	{
		local targetID = "NullificationReservationTargetID" in _attempt ? _attempt.NullificationReservationTargetID : _attempt.TargetID;
		removed = this.releaseValkyrieAttackNullification(_attempt.Context.ActionToken, targetID);
	}
	local frames = this.ValkyrieAttackNullificationAdapter.EffectGateFrames;
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		if (frames[i].AttemptID == _attempt.AttemptID)
		{
			frames.remove(i);
			removed = true;
		}
	}
	return removed;
};

::$bvvar{namespace}.releaseValkyrieAttackNullificationAdapterForAction <- function( _actionToken )
{
	local frames = this.ValkyrieAttackNullificationAdapter.EffectGateFrames;
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		if (frames[i].ActionToken == _actionToken) frames.remove(i);
	}
	local sources = this.ValkyrieAttackNullificationAdapter.ExplicitSourceFrames;
	for (local i = sources.len() - 1; i >= 0; i--)
	{
		if (sources[i].ActionToken == _actionToken) sources.remove(i);
	}
	return this.releaseValkyrieAttackNullificationsForAction(_actionToken);
};

::$bvvar{namespace}.pushValkyrieAttackNullificationEffectSource <- function( _actionToken, _target, _attemptID = null )
{
	local targetID = this.getValkyrieCombatObjectID(_target);
	if (_actionToken == null || targetID == null || this.getValkyrieAttackNullification(_actionToken, targetID) == null)
	{
		return null;
	}
	local ordinal = this.ValkyrieAttackNullificationAdapter.NextExplicitSourceOrdinal;
	this.ValkyrieAttackNullificationAdapter.NextExplicitSourceOrdinal = ordinal + 1;
	local frame = {
		Token = "bv-nullification-source-" + ordinal,
		ActionToken = _actionToken,
		AttemptID = _attemptID,
		TargetID = targetID
	};
	this.ValkyrieAttackNullificationAdapter.ExplicitSourceFrames.push(frame);
	return frame.Token;
};

::$bvvar{namespace}.popValkyrieAttackNullificationEffectSource <- function( _token )
{
	local stack = this.ValkyrieAttackNullificationAdapter.ExplicitSourceFrames;
	if (stack.len() == 0 || stack[stack.len() - 1].Token != _token) return false;
	stack.remove(stack.len() - 1);
	return true;
};

::$bvvar{namespace}.getCurrentValkyrieAttackNullificationEffectSource <- function( _target )
{
	local targetID = this.getValkyrieCombatObjectID(_target);
	local explicit = this.ValkyrieAttackNullificationAdapter.ExplicitSourceFrames;
	if (explicit.len() > 0)
	{
		local frame = explicit[explicit.len() - 1];
		return frame.TargetID == targetID ? frame : null;
	}
	local attempts = this.ValkyrieCombatEvents.AttemptStack;
	if (attempts.len() > 0)
	{
		local attempt = attempts[attempts.len() - 1];
		foreach (frame in this.ValkyrieAttackNullificationAdapter.EffectGateFrames)
		{
			if (frame.Armed && frame.AttemptID == attempt.AttemptID && frame.TargetID == targetID)
			{
				return this.isValkyrieAttackNullificationSubscriberMutation(frame) ? null : frame;
			}
		}
		local activeDispatch = this.ValkyrieCombatEvents.DispatchStack;
		if (activeDispatch.len() == 0 || attempt.Context == activeDispatch[activeDispatch.len() - 1]) return null;
	}
	local dispatch = this.ValkyrieCombatEvents.DispatchStack;
	if (dispatch.len() == 0) return null;
	local context = dispatch[dispatch.len() - 1];
	local frames = this.ValkyrieAttackNullificationAdapter.EffectGateFrames;
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		local frame = frames[i];
		if (frame.Armed && frame.ActionToken == context.ActionToken && frame.TargetID == targetID
			&& this.sameValkyrieCombatObject(frame.AttackerRef, this.readValkyrieCombatWeakRef(context.UserRef), frame.AttackerID)
			&& this.sameValkyrieCombatObject(frame.SkillRef, this.readValkyrieCombatWeakRef(context.SkillRef), frame.SkillID))
		{
			if (this.isValkyrieAttackNullificationSubscriberMutation(frame)) return null;
		}
	}
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		local frame = frames[i];
		if (frame.Armed && frame.ActionToken == context.ActionToken && frame.TargetID == targetID
			&& this.sameValkyrieCombatObject(frame.AttackerRef, this.readValkyrieCombatWeakRef(context.UserRef), frame.AttackerID)
			&& this.sameValkyrieCombatObject(frame.SkillRef, this.readValkyrieCombatWeakRef(context.SkillRef), frame.SkillID))
		{
			return frame;
		}
	}
	return null;
};

::$bvvar{namespace}.isValkyrieAttackNullificationSubscriberMutation <- function( _frame )
{
	if (_frame == null) return false;
	local subscribers = this.ValkyrieCombatEvents.ActiveSubscriberFrames;
	if (subscribers.len() == 0) return false;
	local subscriber = subscribers[subscribers.len() - 1];
	return subscriber.ActionToken == _frame.ActionToken
		&& (subscriber.AttemptToken == null || subscriber.AttemptToken == _frame.AttemptID);
};

::$bvvar{namespace}.shouldBlockValkyrieAttackNullificationSkillAdd <- function( _container )
{
	local target = null;
	try { target = _container.getActor(); } catch (e) { target = null; }
	local frame = this.getCurrentValkyrieAttackNullificationEffectSource(target);
	return frame != null && this.getValkyrieAttackNullification(frame.ActionToken, frame.TargetID) != null;
};

::$bvvar{namespace}.shouldSuppressValkyrieNullifiedTargetHit <- function( _container, _caller, _target )
{
	if (_container == null || _caller == null || _target == null) return false;
	local frame = this.getCurrentValkyrieAttackNullificationEffectSource(_target);
	if (frame == null || this.isValkyrieAttackNullificationSubscriberMutation(frame)) return false;
	local user = null;
	try { user = _container.getActor(); } catch (e) { user = null; }
	if (!this.sameValkyrieCombatObject(frame.AttackerRef, user, frame.AttackerID)
		|| !this.sameValkyrieCombatObject(frame.SkillRef, _caller, frame.SkillID)) return false;
	local reservation = this.getValkyrieAttackNullification(frame.ActionToken, frame.TargetID);
	return reservation != null && reservation.Consumed;
};

::$bvvar{namespace}.getCurrentValkyrieAttackNullificationAttempt <- function( _attacker, _skill, _target, _requirePending = true )
{
	local stack = this.ValkyrieCombatEvents.AttemptStack;
	if (stack.len() == 0) return null;
	local attempt = stack[stack.len() - 1];
	return (!_requirePending || this.isPendingValkyrieAttempt(attempt))
		&& this.sameValkyrieCombatObject(attempt.UserRef, _attacker, attempt.UserID)
		&& this.sameValkyrieCombatObject(attempt.SkillRef, _skill, attempt.SkillID)
		&& this.sameValkyrieCombatObject(attempt.TargetRef, _target, attempt.TargetID) ? attempt : null;
};

::$bvvar{namespace}.MH.hookTree("scripts/entity/tactical/actor", function(q) {
	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_skill))
		{
			return __original(_attacker, _skill, _hitInfo);
		}
		local attempt = ::$bvvar{namespace}.getCurrentValkyrieAttackNullificationAttempt(_attacker, _skill, this);
		if (attempt == null) return __original(_attacker, _skill, _hitInfo);
		local entryEpoch = ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch;
		if (!("NullificationPolicyFrozen" in attempt) || !attempt.NullificationPolicyFrozen)
		{
			::$bvvar{namespace}.reserveValkyrieAttackNullificationForAttempt(attempt, _attacker, _skill, this);
		}
		if (!::$bvvar{namespace}.consumeValkyrieAttackNullificationForAttempt(attempt, _attacker, _skill, this, {
			User = _attacker, Skill = _skill, Target = this, Hit = true, IsScheduled = false, HitInfo = _hitInfo
		}))
		{
			if (::$bvvar{namespace}.ValkyrieCombatEvents.Epoch != entryEpoch
				|| !::$bvvar{namespace}.isPendingValkyrieAttempt(attempt)) return 0;
			return __original(_attacker, _skill, _hitInfo);
		}
		if (_hitInfo != null)
		{
			foreach (field in ["DamageRegular", "DamageArmor", "DamageMinimum", "DamageFatigue", "DamageInflictedHitpoints", "DamageInflictedArmor"])
			{
				if (field in _hitInfo) _hitInfo[field] = 0;
			}
		}
		return 0;
	}
});

::$bvvar{namespace}.MH.hookTree("scripts/skills/skill_container", function(q) {
	q.add = @(__original) function( _skill, _order = 0 )
	{
		if (::$bvvar{namespace}.shouldBlockValkyrieAttackNullificationSkillAdd(this)) return null;
		return __original(_skill, _order);
	}
});

// Install after every character-specific onTargetHit wrapper so this guard is
// the outermost layer and can suppress the entire legacy callback chain.
::$bvvar{namespace}.installValkyrieAttackNullificationLateContainerGuard <- function()
{
	if (this.ValkyrieAttackNullificationAdapter.LateContainerGuardInstalled) return false;
	this.ValkyrieAttackNullificationAdapter.LateContainerGuardInstalled = true;
	this.MH.hook("scripts/skills/skill_container", function(q) {
		q.onTargetHit = @(__original) function( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (::$bvvar{namespace}.shouldSuppressValkyrieNullifiedTargetHit(this, _caller, _targetEntity)) return null;
			return __original(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		}
	});
	return true;
};
