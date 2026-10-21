::$bvvar{namespace}.shouldBattleValkyriesIgnoreShield <- function( _usedSkill )
{
	if ("isValkyrieShieldRelevanceBypassed" in ::$bvvar{namespace}
		&& ::$bvvar{namespace}.isValkyrieShieldRelevanceBypassed(_usedSkill))
	{
		return false;
	}
	if ("isValkyrieShieldRelevanceOverridden" in ::$bvvar{namespace}
		&& ::$bvvar{namespace}.isValkyrieShieldRelevanceOverridden(_usedSkill))
	{
		return true;
	}

	if (_usedSkill == null)
	{
		return false;
	}

	local attacker = null;

	try
	{
		attacker = _usedSkill.getContainer().getActor();
	}
	catch (e)
	{
		return false;
	}

	if (attacker == null)
	{
		return false;
	}

	local container = null;

	try
	{
		container = attacker.getSkills();
	}
	catch (e)
	{
		return false;
	}

	if (container == null || !("m" in container) || !("Skills" in container.m))
	{
		return false;
	}

	foreach( passive in container.m.Skills )
	{
		if (!::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(passive))
		{
			continue;
		}

		local key = null;
		try
		{
			key = passive.getBattleValkyriesSkillKey();
			local definition = ::$bvvar{namespace}.getSkillDefinition(key);
			if (definition == null || definition.Kind != "passive")
			{
				continue;
			}

			if (passive.ignoresShieldFor(_usedSkill))
			{
				return true;
			}
		}
		catch (e)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(attacker, key, e, "shield_policy");
			continue;
		}
	}

	return false;
};

// Some third-party actives own a compound lifecycle that the shared combat
// adapter cannot safely split into ordinary use/attack/target callbacks. Keep
// those skills opaque: their original mod remains the sole owner of action
// completion, busy-state cleanup, self-damage, and post-attack effects.
::$bvvar{namespace}.ValkyrieOpaqueCombatSkillIDs <- {};
::$bvvar{namespace}.ValkyrieOpaqueCombatSkillIDs["actives.sb_devablow_skill"] <- true;

::$bvvar{namespace}.registerValkyrieOpaqueCombatSkillID <- function( _skillID )
{
	if (typeof _skillID != "string" || _skillID == "")
	{
		return false;
	}

	::$bvvar{namespace}.ValkyrieOpaqueCombatSkillIDs[_skillID] <- true;
	return true;
};

::$bvvar{namespace}.isValkyrieOpaqueCombatSkill <- function( _skill )
{
	if (_skill == null)
	{
		return false;
	}

	local skillID = null;
	try { skillID = _skill.getID(); }
	catch (e)
	{
		try
		{
			if ("m" in _skill && _skill.m != null && "ID" in _skill.m)
			{
				skillID = _skill.m.ID;
			}
		}
		catch (ignored) {}
	}

	return typeof skillID == "string" && skillID in ::$bvvar{namespace}.ValkyrieOpaqueCombatSkillIDs;
};

// Hook the shared base script once. Hooking every descendant with hookTree is
// incompatible with broad packs that replace skill.nut and individual active
// scripts: inherited getters can be shadowed out of the descendant table.
::$bvvar{namespace}.clearValkyrieStaleSkillPreview <- function( _skill )
{
	if (!("Tactical" in getroottable()) || ::Tactical == null || !("TurnSequenceBar" in ::Tactical) || ::Tactical.TurnSequenceBar == null) return;
	local container = _skill.getContainer();
	if (container == null) return;
	local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(container.getActor());
	if (actor == null) return;
	local bar = ::Tactical.TurnSequenceBar, preview = bar.m.ActiveEntityCostsPreview;
	if (preview == null || preview.id != actor.getID()) return;
	local id = actor.getPreviewSkillID();
	if (id == "" || container.getSkillByID(id) != null) return;
	// Equipment swaps and managed-skill rebuilds can remove the selected skill.
	// Clear its full cost preview before MSU dereferences it for the tooltip.
	local active = bar.getActiveEntity();
	if (active != null && active.getID() == actor.getID()) bar.resetActiveEntityCostsPreview();
	else
	{
		actor.setPreviewActionPoints(actor.getActionPoints());
		actor.setPreviewFatigue(actor.getFatigue());
		actor.setPreviewSkillID("");
		bar.m.ActiveEntityCostsPreview = null;
	}
};

local installBattleValkyriesSkillGetterAdapter = function(q) {
	if ("getCostString" in q)
	{
		q.getCostString = @(__original) function()
		{
			::$bvvar{namespace}.clearValkyrieStaleSkillPreview(this);
			return __original.bindenv(this)();
		}
	}
	if ("isUsable" in q)
	{
		q.isUsable = @(__original) function()
		{
			if ("isValkyrieSkillUseBlocked" in ::$bvvar{namespace}
				&& ::$bvvar{namespace}.isValkyrieSkillUseBlocked(this))
			{
				return false;
			}

			return __original.bindenv(this)();
		}
	}

	q.isShieldRelevant = @(__original) function()
	{
		if (::$bvvar{namespace}.shouldBattleValkyriesIgnoreShield(this))
		{
			return false;
		}

		return __original.bindenv(this)();
	}

	q.getActionPointCost = @(__original) function()
	{
		return ::$bvvar{namespace}.getValkyrieWeaponSkillActionPointCost(this, __original.bindenv(this));
	}

	q.getFatigueCost = @(__original) function()
	{
		return ::$bvvar{namespace}.getValkyrieWeaponSkillFatigueCost(this, __original.bindenv(this));
	}

	q.getMinRange = @(__original) function()
	{
		return ::$bvvar{namespace}.getValkyrieWeaponSkillMinRange(this, __original.bindenv(this));
	}

	q.getMaxRange = @(__original) function()
	{
		return ::$bvvar{namespace}.getValkyrieWeaponSkillMaxRange(this, __original.bindenv(this));
	}

	q.isAffordable = @(__original) function()
	{
		return ::$bvvar{namespace}.getValkyrieWeaponSkillAffordability(this, __original.bindenv(this));
	}

	q.isUsableOn = @(__original) function( _targetTile, _userTile = null )
	{
		local skill = this;
		local original = __original.bindenv(skill);
		local result = ::$bvvar{namespace}.withValkyrieWeaponSkillPreviewRange(skill, function()
		{
			return original(_targetTile, _userTile);
		});
		if ("logSilverWolfTargetDebug" in ::$bvvar{namespace})
		{
			local key = "";
			try { key = skill.getBattleValkyriesSkillKey(); } catch (e) {}
			if (typeof key == "string" && key.find("silver_wolf_") == 0)
			{
				local details = "";
				try { details = "distance=" + skill.getContainer().getActor().getTile().getDistanceTo(_targetTile) + " min=" + skill.m.MinRange + " max=" + skill.m.MaxRange + " tileVisible=" + _targetTile.IsVisibleForEntity; } catch (e) { details = "details_error=" + e; }
				::$bvvar{namespace}.logSilverWolfTargetDebug(skill,_targetTile,"isUsableOn",result ? "accepted" : "rejected",details);
			}
		}
		return result;
	}

	q.isInRange = @(__original) function( _targetTile, _userTile = null )
	{
		local skill = this;
		local original = __original.bindenv(skill);
		local result = ::$bvvar{namespace}.withValkyrieWeaponSkillPreviewRange(skill, function()
		{
			return original(_targetTile, _userTile);
		});
		if ("logSilverWolfTargetDebug" in ::$bvvar{namespace})
		{
			local key = "";
			try { key = skill.getBattleValkyriesSkillKey(); } catch (e) {}
			if (typeof key == "string" && key.find("silver_wolf_") == 0)
			{
				local details = "";
				try { details = "distance=" + skill.getContainer().getActor().getTile().getDistanceTo(_targetTile) + " min=" + skill.m.MinRange + " max=" + skill.m.MaxRange; } catch (e) { details = "details_error=" + e; }
				::$bvvar{namespace}.logSilverWolfTargetDebug(skill,_targetTile,"isInRange",result ? "accepted" : "rejected",details);
			}
		}
		return result;
	}
};

local installBattleValkyriesSkillCombatAdapter = function(q) {
	// Target verification arms payment. Legends replaces this method during
	// inheritance, so restore its wrapper with the late combat layer as well.
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return ::$bvvar{namespace}.verifyValkyrieWeaponSkillTarget(this, __original.bindenv(this), _originTile, _targetTile);
	}

	local adapterLayerToken = {};
	q.use = @(__original) function( _targetTile, _forFree = false )
	{
		local original = __original.bindenv(this);
		if (::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(this))
		{
			return original(_targetTile, _forFree);
		}
		local modifierRoute = ::$bvvar{namespace}.beginValkyrieWeaponSkillUse(this, _targetTile, _forFree);
		if (!modifierRoute.Owned)
		{
			return original(_targetTile, _forFree);
		}
		local user = null;
		try { user = this.getContainer().getActor(); } catch (e) { user = null; }
		local context = null;
		local entered = false;
		local hasError = false;
		local failure = null;
		local ret = false;
		try
		{
			context = ::$bvvar{namespace}.beginValkyrieAction(user, this, _targetTile, _forFree);
			if (context != null)
			{
				::$bvvar{namespace}.enterValkyrieActionDispatch(context);
				entered = true;
			}
			ret = original(_targetTile, _forFree);
			if (!ret && context != null && "HadConsumedNullification" in context
				&& context.HadConsumedNullification && context.State.AttemptOrder.len() > 0)
			{
				ret = true;
			}
		}
		catch (e)
		{
			hasError = true;
			failure = e;
		}
		if (entered)
		{
			try
			{
				::$bvvar{namespace}.leaveValkyrieActionDispatch(context);
			}
			catch (e)
			{
				if (!hasError)
				{
					hasError = true;
					failure = e;
				}
			}
		}
		if (context != null && hasError)
		{
			try { ::$bvvar{namespace}.cancelValkyrieAction(context, "use_exception"); } catch (cleanupError) {}
		}
		else if (context != null)
		{
			try { ret = ::$bvvar{namespace}.finishValkyrieAction(context, ret); }
			catch (e)
			{
				hasError = true;
				failure = e;
				try { ::$bvvar{namespace}.cancelValkyrieAction(context, "finish_exception"); } catch (cleanupError) {}
			}
		}
		try { ::$bvvar{namespace}.finishValkyrieWeaponSkillUse(modifierRoute); }
		catch (e)
		{
			if (!hasError)
			{
				hasError = true;
				failure = e;
			}
		}
		if (hasError) throw failure;
		return ret;
	}

	q.attackEntity = @(__original) function( _user, _targetEntity, _allowDiversion = true )
	{
		local original = __original.bindenv(this);
		if (::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(this))
		{
			return original(_user, _targetEntity, _allowDiversion);
		}
		local owner = ::$bvvar{namespace}.beginValkyrieSkillAdapterOperation("attack", this, _targetEntity, adapterLayerToken);
		if (!owner.Owned)
		{
			return original(_user, _targetEntity, _allowDiversion);
		}
		local route = null;
		local weaponPolicy = null;
		local ignoreShield = false;
		local originalShieldRelevant = this.m.IsShieldRelevant;
		local hasError = false;
		local failure = null;
		local ret = false;
		try
		{
			route = ::$bvvar{namespace}.prepareValkyrieAttackAttempt(_user, this, _targetEntity);
			weaponPolicy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(_user, this, _targetEntity);
			ignoreShield = (weaponPolicy != null && weaponPolicy.IgnoreShield) || ::$bvvar{namespace}.shouldBattleValkyriesIgnoreShield(this);
			if (ignoreShield) this.m.IsShieldRelevant = false;
			ret = original(_user, _targetEntity, _allowDiversion);
		}
		catch (e)
		{
			hasError = true;
			failure = e;
		}
		if (hasError)
		{
			try { ::$bvvar{namespace}.failValkyrieAttackAttempt(route, "attack_exception"); } catch (cleanupError) {}
			try { ::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(route == null ? null : route.Attempt, false); } catch (cleanupError) {}
		}
		else
		{
			try
			{
				ret = ::$bvvar{namespace}.completeValkyrieAttackAttempt(route, ret);
				if (!ret && route != null && "releaseValkyrieAttackNullificationForAttempt" in ::$bvvar{namespace})
				{
					::$bvvar{namespace}.releaseValkyrieAttackNullificationForAttempt(route.Attempt);
				}
				if (ret && route != null && route.Attempt != null
					&& "Nullified" in route.Attempt && route.Attempt.Nullified)
				{
					ret = false;
				}
				if (ret && route != null && ::$bvvar{namespace}.isPendingValkyrieAttempt(route.Attempt)
					&& "armValkyrieAttackNullificationEffectGate" in ::$bvvar{namespace}
					&& ::$bvvar{namespace}.getValkyrieAttackNullification(route.Context.ActionToken, route.Attempt.TargetID) != null)
				{
					::$bvvar{namespace}.armValkyrieAttackNullificationEffectGate(route.Attempt, _user, this,
						::$bvvar{namespace}.readValkyrieCombatWeakRef(route.Attempt.TargetRef));
				}
				if (route != null && ::$bvvar{namespace}.isPendingValkyrieAttempt(route.Attempt))
				{
					if ("releaseValkyrieShieldRelevanceOverridesForAttempt" in ::$bvvar{namespace})
					{
						::$bvvar{namespace}.releaseValkyrieShieldRelevanceOverridesForAttempt(route.Attempt.AttemptID);
					}
					if ("syncValkyrieShieldRelevanceOverride" in ::$bvvar{namespace})
					{
						::$bvvar{namespace}.syncValkyrieShieldRelevanceOverride(this);
					}
				}
			}
			catch (e)
			{
				hasError = true;
				failure = e;
				try { ::$bvvar{namespace}.failValkyrieAttackAttempt(route, "attack_complete_exception"); } catch (cleanupError) {}
				try { ::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(route == null ? null : route.Attempt, false); } catch (cleanupError) {}
			}
		}
		try { ::$bvvar{namespace}.finishValkyrieSkillAdapterOperation(owner); }
		catch (e)
		{
			if (!hasError)
			{
				hasError = true;
				failure = e;
			}
		}
		local managedTouched = ignoreShield;
		if (!managedTouched && route != null && route.Attempt != null)
		{
			managedTouched = "AttackDefenseRawTouched" in route.Attempt && route.Attempt.AttackDefenseRawTouched == true;
		}
		if (managedTouched) this.m.IsShieldRelevant = originalShieldRelevant;
		if (hasError) throw failure;
		return ret;
	}

	q.onScheduledTargetHit = @(__original) function( _info )
	{
		// Projectile timers invoke this callback without a skill receiver. The
		// payload owns the originating skill in both vanilla and Legends; binding
		// to the timer's `this` makes the original callback fail on this.m.
		local skill = _info != null && "Skill" in _info && _info.Skill != null
			? ::$bvvar{namespace}.readValkyrieCombatWeakRef(_info.Skill) : this;
		local original = __original.bindenv(skill);
		if (::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(skill))
		{
			return original(_info);
		}
		local owner = ::$bvvar{namespace}.beginValkyrieSkillAdapterOperation("scheduled_target_hit", skill, _info);
		if (!owner.Owned)
		{
			return original(_info);
		}
		local execute = function()
		{
		local user = _info != null && "User" in _info ? _info.User : null;
		local target = _info != null && "TargetEntity" in _info ? ::$bvvar{namespace}.readValkyrieCombatWeakRef(_info.TargetEntity) : null;
		local weaponPolicy = _info != null && "Properties" in _info && _info.Properties != null
			&& "BattleValkyriesWeaponAttackPolicy" in _info.Properties ? _info.Properties.BattleValkyriesWeaponAttackPolicy : null;
		local attempt = ::$bvvar{namespace}.claimValkyrieScheduledTargetAttempt(user, skill, target);
		if (attempt == null)
		{
			local activatedOrphanPolicy = weaponPolicy != null && ::$bvvar{namespace}.activateValkyrieWeaponAttackPolicy(weaponPolicy);
			local orphanRet = null;
			try
			{
				orphanRet = original(_info);
			}
			catch (e)
			{
				if (activatedOrphanPolicy) ::$bvvar{namespace}.deactivateValkyrieWeaponAttackPolicy(weaponPolicy);
				throw e;
			}
			if (activatedOrphanPolicy) ::$bvvar{namespace}.deactivateValkyrieWeaponAttackPolicy(weaponPolicy);
			return orphanRet;
		}

		local targetAvailable = target != null;
		try
		{
			targetAvailable = targetAvailable && !(typeof target == "instance" && target.isNull()) && target.isAlive();
		}
		catch (e)
		{
			targetAvailable = false;
		}
		if (!targetAvailable)
		{
			try
			{
				if (_info != null && "Container" in _info && _info.Container != null)
				{
					_info.Container.setBusy(false);
				}
			}
			catch (e)
			{
			}
			::$bvvar{namespace}.cancelValkyrieTargetAttempt(attempt, "scheduled_target_unavailable");
			::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(attempt, false);
			return null;
		}

		local nullified = false;
		try
		{
			nullified = "consumeValkyrieAttackNullificationForAttempt" in ::$bvvar{namespace}
				&& ::$bvvar{namespace}.consumeValkyrieAttackNullificationForAttempt(attempt, user, skill, target, {
					User = user,
					Skill = skill,
					Target = target,
					Hit = true,
					IsScheduled = true
				});
		}
		catch (e)
		{
			try { ::$bvvar{namespace}.cancelValkyrieAction(attempt.Context, "nullification_consume_exception"); } catch (cleanupError) {}
			try { ::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(attempt, false); } catch (cleanupError) {}
			throw e;
		}
		if (nullified)
		{
			local nullificationFailure = null;
			try
			{
				if (_info != null && "Container" in _info && _info.Container != null)
				{
					_info.Container.setBusy(false);
				}
				local nullifiedResult = ::$bvvar{namespace}.makeValkyrieNullifiedAttackResult();
				::$bvvar{namespace}.resolveValkyrieTargetAttempt(attempt, true, attempt.BodyPart, 0, 0, {
					Result = nullifiedResult,
					IsScheduled = true,
					Nullified = true
				});
				if ("trySettleValkyrieAction" in ::$bvvar{namespace})
				{
					::$bvvar{namespace}.trySettleValkyrieAction(attempt.Context);
				}
			}
			catch (e)
			{
				nullificationFailure = e;
			}
			if (nullificationFailure != null)
			{
				try { ::$bvvar{namespace}.cancelValkyrieAction(attempt.Context, "nullification_resolve_exception"); } catch (cleanupError) {}
				try { ::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(attempt, false); } catch (cleanupError) {}
				throw nullificationFailure;
			}
			return null;
		}
		if (!::$bvvar{namespace}.isPendingValkyrieAttempt(attempt))
		{
			try
			{
				if (_info != null && "Container" in _info && _info.Container != null) _info.Container.setBusy(false);
			}
			catch (e)
			{
			}
			return null;
		}
		if ("releaseValkyrieAttackNullificationForAttempt" in ::$bvvar{namespace}
			&& "NullificationReservationTargetID" in attempt)
		{
			::$bvvar{namespace}.releaseValkyrieAttackNullificationForAttempt(attempt);
		}

		local activatedWeaponPolicy = weaponPolicy != null && ::$bvvar{namespace}.activateValkyrieWeaponAttackPolicy(weaponPolicy);
		::$bvvar{namespace}.pushValkyrieAttempt(attempt);
		local ret = null;
		try
		{
			ret = original(_info);
			if (weaponPolicy != null && weaponPolicy.PostFixedHP > 0 && target != null && !::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(user, skill, target, weaponPolicy.PostFixedHP, {
					ActionToken = attempt.Context.ActionToken,
					AttemptToken = attempt.AttemptID,
					Source = weaponPolicy.Source,
					BodyPart = weaponPolicy.ForcedBodyPart == null ? ::Const.BodyPart.Body : weaponPolicy.ForcedBodyPart
				});
			}
		}
		catch (e)
		{
			if (activatedWeaponPolicy) ::$bvvar{namespace}.deactivateValkyrieWeaponAttackPolicy(weaponPolicy);
			if (::$bvvar{namespace}.isPendingValkyrieAttempt(attempt))
			{
				::$bvvar{namespace}.failValkyrieScheduledTargetAttempt(attempt, "scheduled_hit_exception");
			}
			else
			{
				::$bvvar{namespace}.popValkyrieAttempt(attempt);
			}
			::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt(attempt, false);
			throw e;
		}
		if (activatedWeaponPolicy) ::$bvvar{namespace}.deactivateValkyrieWeaponAttackPolicy(weaponPolicy);
		::$bvvar{namespace}.popValkyrieAttempt(attempt);
		if (::$bvvar{namespace}.isPendingValkyrieAttempt(attempt))
		{
			::$bvvar{namespace}.resolveValkyrieTargetAttempt(attempt, true, attempt.BodyPart, attempt.HitpointDamage, attempt.ArmorDamage, {
				Result = ret,
				IsScheduled = true
			});
		}
		if ("trySettleValkyrieAction" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.trySettleValkyrieAction(attempt.Context);
		}
		return ret;
		};
		local hasError = false;
		local failure = null;
		local result = null;
		try { result = execute(); }
		catch (e)
		{
			hasError = true;
			failure = e;
		}
		try { ::$bvvar{namespace}.finishValkyrieSkillAdapterOperation(owner); }
		catch (e)
		{
			if (!hasError)
			{
				hasError = true;
				failure = e;
			}
		}
		if (hasError) throw failure;
		return result;
	}
};

local installBattleValkyriesSharedSkillAdapter = function(q) {
	installBattleValkyriesSkillGetterAdapter(q);
	installBattleValkyriesSkillCombatAdapter(q);
};

try
{
	::$bvvar{namespace}.MH.hook("scripts/skills/skill", installBattleValkyriesSharedSkillAdapter);
}
catch (baseHookError)
{
	// Minimal legacy hook loaders used by older packs expose only hookTree.
	// Modern Hooks takes the direct base path above.
	::$bvvar{namespace}.MH.hookTree("scripts/skills/skill", installBattleValkyriesSharedSkillAdapter);
}

// Legends' legacy mods_hookBaseClass replaces onVerifyTarget, attackEntity and
// onScheduledTargetHit on each inherited skill AFTER the shared prototype's
// Modern Hooks wrappers have run. Tree hooks run after that inheritance phase.
// Rewrap only the combat lifecycle: broad getter tree hooks break inherited
// cost getters in large compatibility packs. Existing operation owners prevent
// duplicate actions/attempts when an inherited method kept its base wrapper.
if ("Legends" in getroottable())
{
	::$bvvar{namespace}.MH.hookTree("scripts/skills/skill", installBattleValkyriesSkillCombatAdapter);
}

// The large Chinese compatibility archive replaces both skill.nut and
// quick_shot.nut. In that combination Modern Hooks can leave quick_shot with
// isAffordable inherited but without the inherited cost getters. Repair the
// concrete script itself so bow AI cannot get stuck retrying it every frame.
try
{
::$bvvar{namespace}.MH.hook("scripts/skills/actives/quick_shot", function( q )
{
	// Minimal test/compatibility loaders may expose no concrete quick-shot
	// members. The real Modern Hooks table exposes both inherited members.
	if (!("create" in q) || !("isAffordable" in q)) return;
	q.create = @(__original) function()
	{
		__original.bindenv(this)();
		::$bvvar{namespace}.repairValkyrieWeaponSkillCostGetters(this);
	}

	q.isAffordable = @(__original) function()
	{
		local original = __original.bindenv(this);
		::$bvvar{namespace}.repairValkyrieWeaponSkillCostGetters(this);
		try
		{
			if (typeof this.getActionPointCost != "function" || typeof this.getFatigueCost != "function") return false;
		}
		catch (e)
		{
			return false;
		}
		return original();
	}
});
}
catch (quickShotHookError)
{
	// Optional for minimal legacy hook loaders; the shared base adapter remains active.
}
