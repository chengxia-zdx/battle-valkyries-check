::$bvvar{namespace}.getActorHitpointRatio <- function( _actor )
{
	if (_actor == null)
	{
		return 1.0;
	}

	local maxHp = 1;
	local hp = 1;

	try
	{
		maxHp = ::Math.max(1, _actor.getHitpointsMax());
		hp = ::Math.max(0, _actor.getHitpoints());
	}
	catch (e)
	{
		return 1.0;
	}

	return hp.tofloat() / maxHp.tofloat();
};

::$bvvar{namespace}.applyValkyrieFlatBonuses <- function( _properties, _bonuses )
{
	if (_properties == null || _bonuses == null)
	{
		return;
	}

	foreach( stat, value in _bonuses )
	{
		if (stat == "MentalMorale")
		{
			_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += value;
		}
		else if (stat in _properties)
		{
			_properties[stat] += value;
		}
	}
};

::$bvvar{namespace}.doesSkillMatchAttackType <- function( _skill, _attackType )
{
	if (_skill == null || !_skill.isAttack())
	{
		return false;
	}

	if (_attackType == null || _attackType == "any")
	{
		return true;
	}

	if (_attackType == "melee")
	{
		return !_skill.isRanged();
	}

	if (_attackType == "ranged")
	{
		return _skill.isRanged();
	}

	return false;
};

::$bvvar{namespace}.ValkyrieThrowingWeaponSkillIDs <- {
	["actives.throw_axe"] = true,
	["actives.throw_balls"] = true,
	["actives.throw_javelin"] = true,
	["actives.throw_spear"] = true,
	["actives.sling_stone"] = true
};

::$bvvar{namespace}.registerValkyrieThrowingWeaponSkillID <- function( _skillID )
{
	if (typeof _skillID != "string" || _skillID.len() == 0)
	{
		return false;
	}

	::$bvvar{namespace}.ValkyrieThrowingWeaponSkillIDs[_skillID] <- true;
	return true;
};

::$bvvar{namespace}.isValkyrieThrowingWeaponAttack <- function( _skill )
{
	if (!::$bvvar{namespace}.isActiveWeaponAttack(_skill))
	{
		return false;
	}

	local isRanged = false;
	local skillID = null;
	try
	{
		isRanged = _skill.isRanged();
		skillID = _skill.getID();
	}
	catch (e)
	{
		return false;
	}

	return isRanged && skillID != null && skillID in ::$bvvar{namespace}.ValkyrieThrowingWeaponSkillIDs;
};

::$bvvar{namespace}.canApplyMentalMoraleCheck <- function( _target )
{
	if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
	{
		return false;
	}

	if (!_target.isAttackable() || _target.getMoraleState() == ::Const.MoraleState.Ignore)
	{
		return false;
	}

	local properties = _target.getCurrentProperties();
	if (!properties.IsAffectedByLosingHitpoints)
	{
		return false;
	}

	return properties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] < 1000.0;
};

::$bvvar{namespace}.applyMentalMoraleCheck <- function( _target, _penalty )
{
	if (_target == null || !::$bvvar{namespace}.canApplyMentalMoraleCheck(_target))
	{
		return false;
	}

	_target.checkMorale(-1, _penalty, ::Const.MoraleCheckType.MentalAttack);
	return true;
};

::$bvvar{namespace}.addOrRefreshStatus <- function( _user, _target, _effectSpec )
{
	if (_target == null || _effectSpec == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
	{
		return null;
	}

	local effectType = "Type" in _effectSpec ? _effectSpec.Type : "";
	local turns = "Turns" in _effectSpec ? _effectSpec.Turns : 1;
	local effect = null;

	if (effectType == "dazed")
	{
		if (_target.getCurrentProperties().IsImmuneToDaze)
		{
			return null;
		}

		effect = _target.getSkills().getSkillByID("effects.dazed");
		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/dazed_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}
	}
	else if (effectType == "staggered")
	{
		effect = _target.getSkills().getSkillByID("effects.staggered");
		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/staggered_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}
	}
	else if (effectType == "stunned")
	{
		if (_target.getCurrentProperties().IsImmuneToStun)
		{
			return null;
		}

		effect = _target.getSkills().getSkillByID("effects.stunned");
		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/stunned_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.setTurns(turns);
		}
	}
	else if (effectType == "disarmed")
	{
		if (_target.getCurrentProperties().IsImmuneToDisarm || _target.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand) == null)
		{
			return null;
		}

		effect = _target.getSkills().getSkillByID("effects.disarmed");
		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/disarmed_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.setTurns(turns);
		}
	}
	else if (effectType == "poison")
	{
		effect = _target.getSkills().getSkillByID("effects.goblin_poison");
		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/goblin_poison_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.resetTime();
		}
	}
	else if (effectType == "web")
	{
		local currentProperties = _target.getCurrentProperties();
		effect = _target.getSkills().getSkillByID("effects.web");
		if (effect == null && (currentProperties.IsImmuneToRoot || currentProperties.IsRooted))
		{
			return null;
		}

		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/web_effect");
			_target.getSkills().add(effect);
		}

		local breakFree = _target.getSkills().getSkillByID("actives.break_free");
		if (breakFree == null)
		{
			breakFree = ::new("scripts/skills/actives/break_free_skill");
			breakFree.setDecal("web_destroyed");
			breakFree.m.Icon = "skills/active_113.png";
			breakFree.m.IconDisabled = "skills/active_113_sw.png";
			breakFree.m.Overlay = "active_113";
			breakFree.m.SoundOnUse = [
				"sounds/combat/break_free_net_01.wav",
				"sounds/combat/break_free_net_02.wav",
				"sounds/combat/break_free_net_03.wav"
			];
			_target.getSkills().add(breakFree);
		}

		if (_target.isPlacedOnMap())
		{
			try
			{
				local rooted = _target.getSprite("status_rooted");
				rooted.setBrush("bust_web2");
				rooted.Visible = true;
				local rootedBack = _target.getSprite("status_rooted_back");
				rootedBack.setBrush("bust_web2_back");
				rootedBack.Visible = true;
				_target.setDirty(true);
			}
			catch (e)
			{
			}
		}
	}
	if (effect != null && "m" in effect && "TurnsLeft" in effect.m)
	{
		effect.m.TurnsLeft = ::Math.max(1, turns + _target.getCurrentProperties().NegativeStatusEffectDuration);
	}

	if (effect != null && !effect.isGarbage() && _user != null && !_user.isHiddenToPlayer() && _target.isPlacedOnMap() && _target.getTile().IsVisibleForPlayer)
	{
		try
		{
			::Tactical.EventLog.log(effect.getLogEntryOnAdded(::Const.UI.getColorizedEntityName(_user), ::Const.UI.getColorizedEntityName(_target)));
		}
		catch (e)
		{
		}
	}

	return effect;
};

::$bvvar{namespace}.applyStatusEffects <- function( _user, _target, _effects )
{
	if (_effects == null)
	{
		return;
	}

	foreach( effectSpec in _effects )
	{
		::$bvvar{namespace}.addOrRefreshStatus(_user, _target, effectSpec);
	}
};

::$bvvar{namespace}.getValkyrieDamageSnapshot <- function( _target )
{
	if (_target == null)
	{
		return null;
	}

	return {
		Hitpoints = _target.getHitpoints(),
		HeadArmor = _target.getArmor(::Const.BodyPart.Head),
		BodyArmor = _target.getArmor(::Const.BodyPart.Body)
	};
};

::$bvvar{namespace}.getValkyrieDamageDelta <- function( _target, _snapshot )
{
	if (_target == null || _snapshot == null)
	{
		return { Hitpoints = 0, Armor = 0 };
	}

	return {
		Hitpoints = ::Math.max(0, _snapshot.Hitpoints - _target.getHitpoints()),
		Armor = ::Math.max(0, _snapshot.HeadArmor - _target.getArmor(::Const.BodyPart.Head))
			+ ::Math.max(0, _snapshot.BodyArmor - _target.getArmor(::Const.BodyPart.Body))
	};
};

::$bvvar{namespace}.notifyValkyrieAttackHit <- function( _attacker, _skill, _target, _bodyPart, _hpDamage, _armorDamage )
{
	if (_attacker == null || ::$bvvar{namespace}.isActorDeadOrDying(_attacker) || _attacker.getSkills() == null || _skill == null || !_skill.isAttack() || _target == null)
	{
		return false;
	}

	_attacker.getSkills().onTargetHit(_skill, _target, _bodyPart, ::Math.max(0, _hpDamage), ::Math.max(0, _armorDamage));
	return true;
};

::$bvvar{namespace}.notifyValkyrieAttackHitFromSnapshot <- function( _attacker, _skill, _target, _bodyPart, _snapshot )
{
	local damage = ::$bvvar{namespace}.getValkyrieDamageDelta(_target, _snapshot);
	return ::$bvvar{namespace}.notifyValkyrieAttackHit(_attacker, _skill, _target, _bodyPart, damage.Hitpoints, damage.Armor);
};

::$bvvar{namespace}.notifyValkyrieAttackMiss <- function( _attacker, _skill, _target )
{
	if (_attacker == null || ::$bvvar{namespace}.isActorDeadOrDying(_attacker) || _attacker.getSkills() == null || _skill == null || !_skill.isAttack() || _target == null)
	{
		return false;
	}

	_attacker.getSkills().onTargetMissed(_skill, _target);
	return true;
};

::$bvvar{namespace}.pushValkyrieFixedDamageFrame <- function( _actor, _skill, _target, _mode, _amount, _options = null )
{
	if (_actor == null || _skill == null || _target == null || (_mode != "hitpoints" && _mode != "armor") || _amount <= 0)
	{
		return null;
	}
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local attempt = ::$bvvar{namespace}.findValkyrieTargetAttempt(_actor, _skill, _target);
	local actionToken = attempt == null ? null : attempt.Context.ActionToken;
	local attemptToken = attempt == null ? null : attempt.AttemptID;
	local source = attempt == null ? "fixed" : attempt.Context.Source;
	local bodyPart = _options != null && "BodyPart" in _options ? _options.BodyPart : ::Const.BodyPart.Body;
	if (bodyPart != ::Const.BodyPart.Body && bodyPart != ::Const.BodyPart.Head) return null;
	if (_options != null)
	{
		if ("ActionToken" in _options) actionToken = _options.ActionToken;
		if ("AttemptToken" in _options) attemptToken = _options.AttemptToken;
		if ("Source" in _options) source = _options.Source;
	}
	local token = "bv-fixed-" + runtime.Epoch + "-" + runtime.NextFixedDamageOrdinal;
	runtime.NextFixedDamageOrdinal++;
	local frame = {
		Token = token,
		FrameToken = token,
		ActorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor),
		ActorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor),
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill),
		SkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill),
		TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target),
		TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target),
		ActionToken = actionToken,
		AttemptToken = attemptToken,
		Mode = _mode,
		Amount = _amount,
		BodyPart = bodyPart,
		Source = source
	};
	frame.Marker <- ::BattleValkyriesFixedDamageState.createValkyrieFixedDamageMarker({
		MarkerToken = runtime.FixedDamageMarkerToken,
		FrameToken = token,
		Mode = _mode,
		Amount = _amount,
		BodyPart = bodyPart,
		OwnerID = frame.ActorID,
		TargetID = frame.TargetID,
		SkillID = frame.SkillID,
		ActionToken = actionToken,
		AttemptToken = attemptToken,
		Source = source
	});
	runtime.FixedDamageFrames.push(frame);
	return frame;
};

::$bvvar{namespace}.popValkyrieFixedDamageFrame <- function( _token )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.FixedDamageFrames;
	if (stack.len() == 0 || _token == null || stack[stack.len() - 1].Token != _token) return false;
	stack.remove(stack.len() - 1);
	return true;
};

::$bvvar{namespace}.getValkyrieFixedDamageFrameForHit <- function( _hitInfo, _target, _actor, _skill )
{
	if (_hitInfo == null || !("BattleValkyriesFixedDamageMarker" in _hitInfo)) return null;
	local marker = _hitInfo.BattleValkyriesFixedDamageMarker;
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	for (local i = runtime.FixedDamageFrames.len() - 1; i >= 0; i = i - 1)
	{
		local frame = runtime.FixedDamageFrames[i];
		if (!::$bvvar{namespace}.sameValkyrieCombatObject(frame.ActorRef, _actor, frame.ActorID)
			|| !::$bvvar{namespace}.sameValkyrieCombatObject(frame.SkillRef, _skill, frame.SkillID)
			|| !::$bvvar{namespace}.sameValkyrieCombatObject(frame.TargetRef, _target, frame.TargetID)) continue;
		if (::BattleValkyriesFixedDamageState.isTrustedValkyrieFixedDamageMarker(marker, runtime.FixedDamageMarkerToken,
			frame.Token, frame.ActorID, frame.TargetID, frame.SkillID)) return frame;
	}
	return null;
};

::$bvvar{namespace}.applyValkyrieFixedDamage <- function( _actor, _skill, _target, _mode, _amount, _options = null )
{
	local failed = { Applied = false, Hit = false, HitpointDamage = 0, ArmorDamage = 0 };
	if (_actor == null || _skill == null || _target == null || _amount <= 0 || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return failed;
	local bodyPart = _options != null && "BodyPart" in _options ? _options.BodyPart : ::Const.BodyPart.Body;
	if (bodyPart != ::Const.BodyPart.Body && bodyPart != ::Const.BodyPart.Head) return failed;
	if (_mode == "armor" && _target.getArmor(bodyPart) <= 0) return failed;
	local existingAttempt = ::$bvvar{namespace}.findValkyrieTargetAttempt(_actor, _skill, _target);
	local hasExplicitIdentity = _options != null && ("ActionToken" in _options || "AttemptToken" in _options);
	local standaloneRoute = null;
	if (existingAttempt == null && !hasExplicitIdentity && ::$bvvar{namespace}.isDirectAttack(_skill)
		&& !_target.isAlliedWith(_actor))
	{
		standaloneRoute = ::$bvvar{namespace}.prepareValkyrieAttackAttempt(_actor, _skill, _target);
	}
	local frame = ::$bvvar{namespace}.pushValkyrieFixedDamageFrame(_actor, _skill, _target, _mode, _amount, _options);
	if (frame == null)
	{
		if (standaloneRoute != null) ::$bvvar{namespace}.failValkyrieAttackAttempt(standaloneRoute, "fixed_damage_frame_failed");
		return failed;
	}
	local hitInfo = clone ::Const.Tactical.HitInfo;
	// Direct=1 and both channels non-zero before skill/item callbacks prevents
	// ordinary plating/equipment effects from treating this as a weapon hit.
	hitInfo.DamageRegular = _amount;
	hitInfo.DamageArmor = _amount;
	hitInfo.DamageDirect = 1.0;
	hitInfo.DamageMinimum = 0;
	hitInfo.DamageFatigue = 0;
	hitInfo.BodyPart = bodyPart;
	hitInfo.BodyDamageMult = 1.0;
	hitInfo.FatalityChanceMult = 0.0;
	hitInfo.BattleValkyriesFixedDamageMarker <- frame.Marker;
	local before = ::$bvvar{namespace}.snapshotValkyrieDamageState(_target);
	try
	{
		_target.onDamageReceived(_actor, _skill, hitInfo);
	}
	catch (e)
	{
		::$bvvar{namespace}.popValkyrieFixedDamageFrame(frame.Token);
		if (standaloneRoute != null) ::$bvvar{namespace}.failValkyrieAttackAttempt(standaloneRoute, "fixed_damage_exception");
		throw e;
	}
	::$bvvar{namespace}.popValkyrieFixedDamageFrame(frame.Token);
	local after = ::$bvvar{namespace}.snapshotValkyrieDamageState(_target);
	local delta = {
		Hitpoints = ::Math.max(0, before.Hitpoints - after.Hitpoints),
		Armor = ::Math.max(0, before.HeadArmor + before.BodyArmor - after.HeadArmor - after.BodyArmor)
	};
	if (standaloneRoute != null)
	{
		try
		{
			if (::$bvvar{namespace}.isPendingValkyrieAttempt(standaloneRoute.Attempt))
			{
				local resolveContext = "Nullified" in standaloneRoute.Attempt && standaloneRoute.Attempt.Nullified
					? { Result = ::$bvvar{namespace}.makeValkyrieNullifiedAttackResult(), Nullified = true }
					: null;
				::$bvvar{namespace}.resolveValkyrieTargetAttempt(standaloneRoute.Attempt, true, bodyPart, delta.Hitpoints, delta.Armor, resolveContext);
			}
			::$bvvar{namespace}.completeValkyrieAttackAttempt(standaloneRoute, true);
		}
		catch (e)
		{
			::$bvvar{namespace}.failValkyrieAttackAttempt(standaloneRoute, "fixed_damage_finalize_exception");
			throw e;
		}
	}
	return { Applied = true, Hit = true, HitpointDamage = delta.Hitpoints, ArmorDamage = delta.Armor, BodyPart = bodyPart, FrameToken = frame.Token };
};

::$bvvar{namespace}.applyValkyrieFixedHitpointDamage <- function( _actor, _skill, _target, _amount, _options = null )
{
	return ::$bvvar{namespace}.applyValkyrieFixedDamage(_actor, _skill, _target, "hitpoints", _amount, _options);
};

::$bvvar{namespace}.applyValkyrieFixedArmorDamage <- function( _actor, _skill, _target, _bodyPart, _amount, _options = null )
{
	local opts = _options == null ? {} : clone _options;
	if ("BodyPart" in opts) opts.BodyPart = _bodyPart;
	else opts.BodyPart <- _bodyPart;
	return ::$bvvar{namespace}.applyValkyrieFixedDamage(_actor, _skill, _target, "armor", _amount, opts);
};

::$bvvar{namespace}.pushValkyrieWeaponAttackPolicy <- function( _actor, _skill, _target, _weapon, _spec, _sourceSkill = null )
{
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local token = "bv-weapon-policy-" + runtime.Epoch + "-" + runtime.NextWeaponAttackPolicyOrdinal;
	runtime.NextWeaponAttackPolicyOrdinal++;
	local policy = {
		Token = token,
		ActorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor), ActorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor),
		SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill), SkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill),
		SourceSkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_sourceSkill), SourceSkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_sourceSkill),
		TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target), TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target),
		WeaponRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_weapon),
		WeaponDamageMult = _spec != null && "WeaponDamageMult" in _spec ? _spec.WeaponDamageMult : 1.0,
		ArmorDamageMult = _spec != null && "ArmorDamageMult" in _spec ? _spec.ArmorDamageMult : 1.0,
		DirectDamageAdd = _spec != null && "DirectDamageAdd" in _spec ? _spec.DirectDamageAdd : 0.0,
		DirectDamageOverride = _spec != null && "DirectDamageOverride" in _spec ? _spec.DirectDamageOverride : null,
		DirectDamageCap = _spec != null && "DirectDamageCap" in _spec ? _spec.DirectDamageCap : null,
		ShieldDefenseScale = _spec != null && "ShieldDefenseScale" in _spec ? _spec.ShieldDefenseScale : 1.0,
		HitChance = _spec != null && "HitChance" in _spec ? _spec.HitChance : 0,
		IgnoreDistance = _spec != null && "IgnoreDistance" in _spec && _spec.IgnoreDistance,
		IgnoreShield = _spec != null && "IgnoreShield" in _spec && _spec.IgnoreShield,
		ForcedBodyPart = _spec != null && "ForcedBodyPart" in _spec ? _spec.ForcedBodyPart : null,
		HighOfTwoDamageRoll = _spec != null && "HighOfTwoDamageRoll" in _spec && _spec.HighOfTwoDamageRoll,
		PostFixedHP = _spec != null && "PostFixedHP" in _spec ? _spec.PostFixedHP : 0,
		Source = _spec != null && "Source" in _spec && typeof _spec.Source == "string" && _spec.Source.len() > 0 ? _spec.Source : "followup"
	};
	runtime.WeaponAttackPolicies.push(policy);
	return policy;
};

::$bvvar{namespace}.activateValkyrieWeaponAttackPolicy <- function( _policy )
{
	if (_policy == null || typeof _policy != "table") return false;
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.WeaponAttackPolicies;
	if (stack.len() > 0 && stack[stack.len() - 1] == _policy) return false;
	stack.push(_policy);
	return true;
};

::$bvvar{namespace}.deactivateValkyrieWeaponAttackPolicy <- function( _policy )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.WeaponAttackPolicies;
	if (_policy == null || stack.len() == 0 || stack[stack.len() - 1] != _policy) return false;
	stack.remove(stack.len() - 1);
	return true;
};

::$bvvar{namespace}.popValkyrieWeaponAttackPolicy <- function( _token )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.WeaponAttackPolicies;
	if (stack.len() == 0 || stack[stack.len() - 1].Token != _token) return false;
	stack.remove(stack.len() - 1); return true;
};

::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy <- function( _actor, _skill, _target = null )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.WeaponAttackPolicies;
	for (local i = stack.len() - 1; i >= 0; i = i - 1)
	{
		local p = stack[i];
		if (::$bvvar{namespace}.sameValkyrieCombatObject(p.ActorRef, _actor, p.ActorID)
			&& ::$bvvar{namespace}.sameValkyrieCombatObject(p.SkillRef, _skill, p.SkillID)
			&& (_target == null || ::$bvvar{namespace}.sameValkyrieCombatObject(p.TargetRef, _target, p.TargetID))) return p;
	}
	return null;
};

::$bvvar{namespace}.applyValkyrieWeaponAttackPolicyToProperties <- function( _properties, _policy, _skill, _target = null )
{
	if (_properties == null || _policy == null) return _properties;
	local targetWeaponDamageMultiplier = 1.0;
	if ("TargetWeaponDamageMultiplier" in _policy && _policy.TargetWeaponDamageMultiplier != null)
	{
		try
		{
			local candidate = _policy.TargetWeaponDamageMultiplier(_target);
			if ((typeof candidate == "integer" || typeof candidate == "float") && candidate >= 0.0)
			{
				targetWeaponDamageMultiplier = candidate;
			}
		}
		catch (e) {}
	}
	_properties.DamageRegularMult *= _policy.WeaponDamageMult * targetWeaponDamageMultiplier;
	if (_policy.HighOfTwoDamageRoll)
	{
		local damageMin = ::Math.max(0, ::Math.floor(_properties.DamageRegularMin));
		local damageMax = ::Math.max(damageMin, ::Math.floor(_properties.DamageRegularMax));
		local highRoll = ::Math.max(::Math.rand(damageMin, damageMax), ::Math.rand(damageMin, damageMax));
		_properties.DamageRegularMin = highRoll;
		_properties.DamageRegularMax = highRoll;
	}
	_properties.DamageArmorMult *= _policy.ArmorDamageMult;
	if (_policy.DirectDamageOverride != null)
	{
		local skillDirect = 0.0;
		try { if (_skill != null) skillDirect = _skill.m.DirectDamageMult; } catch (e) { skillDirect = 0.0; }
		_properties.DamageDirectMult = 1.0;
		_properties.DamageDirectAdd = _policy.DirectDamageOverride - skillDirect;
		_properties.DamageDirectMeleeAdd = 0.0;
		_properties.DamageDirectRangedAdd = 0.0;
	}
	else _properties.DamageDirectAdd += _policy.DirectDamageAdd;
	if ("DirectDamageCap" in _policy && _policy.DirectDamageCap != null && _properties.DamageDirectMult > 0)
	{
		local ranged = _skill != null && _skill.isRanged();
		local skillDirect = _skill == null ? 0.0 : _skill.m.DirectDamageMult;
		local direct = _properties.DamageDirectMult * (skillDirect + _properties.DamageDirectAdd + (ranged ? _properties.DamageDirectRangedAdd : _properties.DamageDirectMeleeAdd));
		if (direct > _policy.DirectDamageCap) _properties.DamageDirectAdd -= (direct - _policy.DirectDamageCap) / _properties.DamageDirectMult;
	}
	if ("HitChance" in _policy && (typeof _policy.HitChance == "integer" || typeof _policy.HitChance == "float") && _policy.HitChance != 0)
	{
		local isRanged = false;
		try { isRanged = _skill != null && _skill.isRanged(); } catch (e) { isRanged = false; }
		if (isRanged) _properties.RangedSkill += _policy.HitChance;
		else _properties.MeleeSkill += _policy.HitChance;
	}
	if (_policy.IgnoreDistance)
	{
		_properties.DamageAdditionalWithEachTile = 0.0;
		_properties.HitChanceAdditionalWithEachTile = 0.0;
	}
	if (_policy.ForcedBodyPart != null)
	{
		_properties.HitChance[::Const.BodyPart.Head] = _policy.ForcedBodyPart == ::Const.BodyPart.Head ? 100 : 0;
		_properties.HitChance[::Const.BodyPart.Body] = _policy.ForcedBodyPart == ::Const.BodyPart.Body ? 100 : 0;
		_properties.HitChanceMult[::Const.BodyPart.Head] = 1.0;
		_properties.HitChanceMult[::Const.BodyPart.Body] = 1.0;
	}
	_properties.BattleValkyriesWeaponAttackPolicy <- _policy;
	return _properties;
};

::$bvvar{namespace}.createValkyrieNeutralWeaponAttack <- function( _actor, _weapon, _sourceSkill = null )
{
	if (_actor == null || _weapon == null) return null;
	local isRanged = false;
	local isMelee = false;
	try
	{
		isRanged = _weapon.isItemType(::Const.Items.ItemType.RangedWeapon);
		isMelee = _weapon.isItemType(::Const.Items.ItemType.MeleeWeapon);
	}
	catch (e)
	{
		return null;
	}
	if (!isRanged && !isMelee) return null;
	local runtime = ::$bvvar{namespace}.ValkyrieCombatEvents;
	local runtimeID = "$bvvar{modId}.skill.neutral_weapon_attack." + runtime.Epoch + "." + runtime.NextNeutralWeaponAttackOrdinal;
	runtime.NextNeutralWeaponAttackOrdinal++;
	local attack = null;
	try
	{
		attack = ::new("$bvvar{privateFolder}/skills/core/valkyrie_neutral_weapon_attack_skill");
		attack.configureValkyrieNeutralWeaponAttack(_actor, _weapon, isRanged, runtimeID, _sourceSkill);
	}
	catch (e)
	{
		return null;
	}
	return attack;
};

::$bvvar{namespace}.configureValkyrieNeutralWeaponAttackSpec <- function( _attack, _spec = null )
{
	if (_attack == null || _spec == null || typeof _spec != "table") return _attack;
	if ("AutoHit" in _spec && _spec.AutoHit == true)
	{
		_attack.m.IsUsingHitchance = false;
	}
	return _attack;
};

::$bvvar{namespace}.applyValkyrieWeaponAttack <- function( _actor, _sourceSkill, _target, _spec = null )
{
	local failed = { Applied = false, Hit = false };
	if (_actor == null || _sourceSkill == null || _target == null
		|| ::$bvvar{namespace}.isActorDeadOrDying(_actor) || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return failed;
	local weapon = null;
	try { weapon = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
	if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.Weapon)) return failed;
	local attack = ::$bvvar{namespace}.createValkyrieNeutralWeaponAttack(_actor, weapon, _sourceSkill);
	if (attack == null) return failed;
	::$bvvar{namespace}.configureValkyrieNeutralWeaponAttackSpec(attack, _spec);
	local policy = ::$bvvar{namespace}.pushValkyrieWeaponAttackPolicy(_actor, attack, _target, weapon, _spec, _sourceSkill);
	local parentActionToken = ::$bvvar{namespace}.getCurrentValkyrieSubscriberActionToken(_sourceSkill);
	if (parentActionToken == null && _spec != null && "ParentActionToken" in _spec) parentActionToken = _spec.ParentActionToken;
	local sourceToken = ::$bvvar{namespace}.pushValkyrieCombatSource(policy.Source, _actor, {
		Skill = attack,
		ParentActionToken = parentActionToken
	});
	local hit = false;
	try { hit = attack.attackEntity(_actor, _target, false); }
	catch (e)
	{
		::$bvvar{namespace}.popValkyrieCombatSource(sourceToken);
		::$bvvar{namespace}.popValkyrieWeaponAttackPolicy(policy.Token);
		throw e;
	}
	::$bvvar{namespace}.popValkyrieCombatSource(sourceToken);
	::$bvvar{namespace}.popValkyrieWeaponAttackPolicy(policy.Token);
	return { Applied = true, Hit = hit };
};
