// Hooks outside scripts/skills/skill live here.  The sole skill-tree adapter
// remains valkyrie_shield_relevance_adapter.nut so hook composition is stable.

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onAttackOfOpportunity = @(__original) function( _entity, _isOnEnter )
	{
		local sourceToken = ::$bvvar{namespace}.pushValkyrieCombatSource("aoo", this);
		local ret = false;
		try
		{
			ret = __original(_entity, _isOnEnter);
		}
		catch (e)
		{
			::$bvvar{namespace}.popValkyrieCombatSource(sourceToken);
			throw e;
		}
		::$bvvar{namespace}.popValkyrieCombatSource(sourceToken);
		return ret;
	}

	q.onRiposte = @(__original) function( _info )
	{
		local sourceToken = ::$bvvar{namespace}.pushValkyrieCombatSource("riposte", this, _info);
		local ret = null;
		try
		{
			ret = __original(_info);
		}
		catch (e)
		{
			::$bvvar{namespace}.popValkyrieCombatSource(sourceToken);
			throw e;
		}
		::$bvvar{namespace}.popValkyrieCombatSource(sourceToken);
		return ret;
	}

	q.onAttacked = @(__original) function( _attacker )
	{
		::$bvvar{namespace}.retargetCurrentValkyrieTargetAttempt(_attacker, this);
		return __original(_attacker);
	}

	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		// Opaque third-party compound skills own their full damage and death
		// lifecycle. In particular, do not create an implicit Valkyrie action
		// after one of their sub-targets dies.
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_skill))
		{
			return __original(_attacker, _skill, _hitInfo);
		}
		local before = ::$bvvar{namespace}.snapshotValkyrieDamageState(this);
		local fixedFrame = ::$bvvar{namespace}.getValkyrieFixedDamageFrameForHit(_hitInfo, this, _attacker, _skill);
		local route = null;
		local attempt = ::$bvvar{namespace}.findValkyrieTargetAttempt(_attacker, _skill, this);
		if (fixedFrame != null && attempt != null)
		{
			local actionMismatch = fixedFrame.ActionToken != null && fixedFrame.ActionToken != attempt.Context.ActionToken;
			local attemptMismatch = fixedFrame.AttemptToken != null && fixedFrame.AttemptToken != attempt.AttemptID;
			if (actionMismatch || attemptMismatch) attempt = null;
		}
		if (fixedFrame == null && attempt == null && _attacker != null && ::$bvvar{namespace}.isDirectAttack(_skill))
		{
			route = ::$bvvar{namespace}.prepareValkyrieAttackAttempt(_attacker, _skill, this);
			attempt = route == null ? null : route.Attempt;
		}
		else if (attempt != null)
		{
			::$bvvar{namespace}.pushValkyrieAttempt(attempt);
		}

		local ret = 0;
		try
		{
			ret = __original(_attacker, _skill, _hitInfo);
		}
		catch (e)
		{
			::$bvvar{namespace}.failValkyrieDamageAttempt(route, attempt, "damage_exception");
			throw e;
		}

		local after = ::$bvvar{namespace}.snapshotValkyrieDamageState(this);
		local wasNullified = attempt != null && "Nullified" in attempt && attempt.Nullified;
		::$bvvar{namespace}.recordValkyrieAttemptBodyPart(attempt, _hitInfo);
		if (!wasNullified) ::$bvvar{namespace}.publishValkyrieDamageResolved(this, _attacker, _skill, before, after, fixedFrame);
		if (route != null)
		{
			local bodyPart = _hitInfo != null && "BodyPart" in _hitInfo ? _hitInfo.BodyPart : null;
			local resolveContext = wasNullified ? { Result = ::$bvvar{namespace}.makeValkyrieNullifiedAttackResult(), Nullified = true } : null;
			::$bvvar{namespace}.resolveValkyrieTargetAttempt(route.Attempt, true, bodyPart,
				::Math.max(0, before.Hitpoints - after.Hitpoints),
				::Math.max(0, before.HeadArmor + before.BodyArmor - after.HeadArmor - after.BodyArmor), resolveContext);
			::$bvvar{namespace}.completeValkyrieAttackAttempt(route, true);
		}
		else if (attempt != null)
		{
			if (fixedFrame == null && wasNullified && ::$bvvar{namespace}.isPendingValkyrieAttempt(attempt))
			{
				local bodyPart = _hitInfo != null && "BodyPart" in _hitInfo ? _hitInfo.BodyPart : null;
				::$bvvar{namespace}.resolveValkyrieTargetAttempt(attempt, true, bodyPart, 0, 0, {
					Result = ::$bvvar{namespace}.makeValkyrieNullifiedAttackResult(),
					Nullified = true
				});
			}
			::$bvvar{namespace}.popValkyrieAttempt(attempt);
		}
		return ret;
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.resetValkyrieCombatEvents("world_deserialize");
		return __original(_in);
	}
});

::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
	// Earlier hooks may make the target optional; never require it again.
	q.buildPropertiesForUse = @(__original) function( _caller, _targetEntity = null )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_caller))
		{
			return __original(_caller, _targetEntity);
		}
		if (_caller!=null&&"EsSnapshot" in _caller.m&&_caller.m.EsSnapshot!=null) return clone _caller.m.EsSnapshot;
		local properties = __original(_caller, _targetEntity);
		local actor = null;
		try { actor = this.getActor(); } catch (e) { actor = null; }
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _caller, _targetEntity);
		properties = ::$bvvar{namespace}.applyValkyrieWeaponAttackPolicyToProperties(properties, policy, _caller, _targetEntity);
		local modifierPolicy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyForGetter(_caller);
		properties = ::$bvvar{namespace}.applyValkyrieWeaponSkillModifierPolicyToProperties(properties, modifierPolicy, _caller, _targetEntity);
		if ("finalizeEnterpriseAirstrikeProperties" in ::$bvvar{namespace})
			properties = ::$bvvar{namespace}.finalizeEnterpriseAirstrikeProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeHokusaiSpellProperties" in ::$bvvar{namespace})
			properties = ::$bvvar{namespace}.finalizeHokusaiSpellProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeAbigailUseProperties" in ::$bvvar{namespace})
			properties = ::$bvvar{namespace}.finalizeAbigailUseProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeOlgaProperties" in ::$bvvar{namespace})
			properties = ::$bvvar{namespace}.finalizeOlgaProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeBlackBeastProperties" in ::$bvvar{namespace})
			properties = ::$bvvar{namespace}.finalizeBlackBeastProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeRyzaProperties" in ::$bvvar{namespace})
			::$bvvar{namespace}.finalizeRyzaProperties(actor, _caller, properties);
		if ("finalizeTrailsDuoProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeTrailsDuoProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeOrbalProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeOrbalProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeAemeathProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeAemeathProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeKanadeProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeKanadeProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeFateProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeFateProperties(actor, _caller, _targetEntity, properties);
		if ("finalizeHuTaoProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeHuTaoProperties(actor,_caller,_targetEntity,properties);
		if ("finalizeEsProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeEsProperties(actor,_caller,_targetEntity,properties);
		if ("finalizeRachelProperties" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.finalizeRachelProperties(actor,_caller,_targetEntity,properties);
		if ("HertaForesight" in ::$bvvar{namespace}) properties = ::$bvvar{namespace}.HertaForesight.finalize(actor, _caller, properties);
		return properties;
	}

	q.setBusy = @(__original) function( _busy )
	{
		local ret = __original(_busy);
		local busy = false;
		try { busy = this.isBusy(); } catch (e) { busy = _busy; }
		::$bvvar{namespace}.touchValkyrieActionBusy(this, busy);
		return ret;
	}
	q.isBusy = @(__original) function()
	{
		return ("isValkyrieMovementBusy" in ::$bvvar{namespace} && ::$bvvar{namespace}.isValkyrieMovementBusy(this)) || __original();
	}

	q.onTargetHit = @(__original) function( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_caller))
		{
			return __original(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		}
		::$bvvar{namespace}.markValkyrieLegacyTargetResult(_caller, _targetEntity, true, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		return __original(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	}

	q.onTargetMissed = @(__original) function( _caller, _targetEntity )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_caller))
		{
			return __original(_caller, _targetEntity);
		}
		::$bvvar{namespace}.markValkyrieLegacyTargetResult(_caller, _targetEntity, false);
		return __original(_caller, _targetEntity);
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieCombatEvents("tactical_init");
		return __original();
	}

	q.onFinish = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieCombatEvents("tactical_finish");
		return __original();
	}
});
