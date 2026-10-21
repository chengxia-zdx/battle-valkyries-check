::$bvvar{namespace}.ValkyrieWeaponSkillModifiers <- {
	UseFrames = [],
	OperationFrames = [],
	PreviewRangeFrames = [],
	GetterFrames = [],
	PolicyQueryDepth = 0
};

::$bvvar{namespace}.resetValkyrieWeaponSkillModifiers <- function( _reason = "reset" )
{
	local runtime = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers;
	foreach (frame in runtime.UseFrames)
	{
		if (frame.Frame != null && frame.Frame.Skill != null && frame.Frame.OriginalMinRange != null)
		{
			try { frame.Frame.Skill.m.MinRange = frame.Frame.OriginalMinRange; } catch (e) {}
		}
	}
	foreach (frame in runtime.PreviewRangeFrames)
	{
		try
		{
			frame.Skill.m.MinRange = frame.OriginalMinRange;
			frame.Skill.m.MaxRange = frame.OriginalMaxRange;
		}
		catch (e) {}
	}
	runtime.UseFrames = [];
	runtime.OperationFrames = [];
	runtime.PreviewRangeFrames = [];
	runtime.GetterFrames = [];
	runtime.PolicyQueryDepth = 0;
};

::$bvvar{namespace}.beginValkyrieSkillAdapterOperation <- function( _kind, _skill, _identity = null, _layerToken = null )
{
	local stack = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.OperationFrames;
	if (stack.len() > 0)
	{
		local current = stack[stack.len() - 1];
		if (current.Kind == _kind && current.Skill == _skill)
		{
			if (_kind == "attack" && current.LayerToken != _layerToken)
			{
				return { Owned = false, Route = current };
			}
			else if (_kind != "attack" && (_identity == null || current.Identity == _identity))
			{
				return { Owned = false, Route = current };
			}
		}
	}
	local route = { Kind = _kind, Skill = _skill, Identity = _identity, LayerToken = _layerToken };
	stack.push(route);
	return { Owned = true, Route = route };
};

::$bvvar{namespace}.finishValkyrieSkillAdapterOperation <- function( _owner )
{
	if (_owner == null || !_owner.Owned)
	{
		return false;
	}
	local stack = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.OperationFrames;
	for (local i = stack.len() - 1; i >= 0; i--)
	{
		if (stack[i] == _owner.Route)
		{
			stack.remove(i);
			return true;
		}
	}
	return false;
};

::$bvvar{namespace}.getActiveValkyrieWeaponSkillPreviewRange <- function( _skill )
{
	local stack = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.PreviewRangeFrames;
	if (stack.len() == 0) return null;
	local frame = stack[stack.len() - 1];
	return frame.Skill == _skill ? frame : null;
};

::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseRoute <- function( _skill )
{
	local stack = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames;
	if (stack.len() == 0)
	{
		return null;
	}
	local route = stack[stack.len() - 1];
	return route.Skill == _skill ? route : null;
};

::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseFrame <- function( _skill )
{
	local route = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseRoute(_skill);
	return route == null ? null : route.Frame;
};

::$bvvar{namespace}.isSameValkyrieWeaponItem <- function( _skillItem, _weapon )
{
	if (_skillItem == null || _weapon == null)
	{
		return false;
	}
	local resolved = _skillItem;
	try
	{
		if ("get" in _skillItem)
		{
			resolved = _skillItem.get();
		}
	}
	catch (e)
	{
		return false;
	}
	if (resolved == _weapon)
	{
		return true;
	}
	try
	{
		return resolved != null && resolved.getInstanceID() == _weapon.getInstanceID();
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isEligibleValkyrieWeaponSkillForPolicy <- function( _usedSkill, _forFree = false )
{
	if (_usedSkill == null || _forFree || !("m" in _usedSkill))
	{
		return false;
	}
	local m = _usedSkill.m;
	// Vanilla and large compatibility packs commonly keep these fields on the
	// m-table delegate. The `in` operator only sees own slots, so it silently
	// rejected otherwise valid inherited weapon skills such as Puncture.
	local isActive = false;
	local isAttack = false;
	local isTargeted = false;
	local isWeaponSkill = false;
	local isRanged = false;
	try
	{
		isActive = m.IsActive;
		isAttack = m.IsAttack;
		isTargeted = m.IsTargeted;
		isWeaponSkill = m.IsWeaponSkill;
		isRanged = m.IsRanged;
	}
	catch (e)
	{
		return false;
	}
	if (!isActive || !isAttack || !isTargeted || !isWeaponSkill)
	{
		return false;
	}
	local optedOut = false;
	try { optedOut = _usedSkill.isValkyrieWeaponSkillPolicyOptOut(); } catch (e) { optedOut = false; }
	if (optedOut) return false;

	local actor = null;
	local weapon = null;
	try
	{
		actor = _usedSkill.getContainer().getActor();
		weapon = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.Weapon)
			|| !::$bvvar{namespace}.isSameValkyrieWeaponItem(m.Item, weapon))
		{
			return false;
		}
	}
	catch (e)
	{
		return false;
	}

	local source = null;
	try { source = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(actor, _usedSkill); } catch (e) { source = null; }
	if (source != null && "Source" in source && (source.Source == "aoo" || source.Source == "riposte" || source.Source == "followup"))
	{
		return false;
	}
	return true;
};

::$bvvar{namespace}.getValkyrieWeaponSkillPolicyFor <- function( _usedSkill, _forFree = false )
{
	local runtime = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers;
	if (runtime.PolicyQueryDepth > 0)
	{
		return null;
	}
	if (!::$bvvar{namespace}.isEligibleValkyrieWeaponSkillForPolicy(_usedSkill, _forFree))
	{
		return null;
	}
	local actor = null;
	local skills = null;
	try
	{
		actor = _usedSkill.getContainer().getActor();
		skills = actor.getSkills().m.Skills;
	}
	catch (e)
	{
		return null;
	}
	foreach (provider in skills)
	{
		local isRuntimePassive = ::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(provider);
		local isManagedEffect = false;
		try { isManagedEffect = provider != null && provider.isBattleValkyriesManagedCombatEffect() == true && !provider.isGarbage(); } catch (e) { isManagedEffect = false; }
		if (!isRuntimePassive && !isManagedEffect)
		{
			continue;
		}
		local isRanged = false;
		try { isRanged = _usedSkill.isRanged(); }
		catch (e)
		{
			try { isRanged = _usedSkill.m.IsRanged; } catch (fallbackError) { isRanged = false; }
		}
		if (isRanged)
		{
			local allowsRanged = false;
			try { allowsRanged = provider.allowsValkyrieRangedWeaponSkillPolicy(_usedSkill) == true; } catch (e) { allowsRanged = false; }
			if (!allowsRanged) continue;
		}
		local key = null;
		try
		{
			if (isRuntimePassive)
			{
				key = provider.getBattleValkyriesSkillKey();
				local definition = ::$bvvar{namespace}.getSkillDefinition(key);
				if (definition == null || definition.Kind != "passive")
				{
					continue;
				}
			}
			runtime.PolicyQueryDepth++;
			local policy = null;
			try
			{
				policy = provider.getValkyrieWeaponSkillPolicy(_usedSkill);
			}
			catch (e)
			{
				runtime.PolicyQueryDepth--;
				throw e;
			}
			runtime.PolicyQueryDepth--;
			if (policy == null)
			{
				continue;
			}
			local normalized = ::$bvvar{namespace}.normalizeValkyrieWeaponSkillPolicy(policy);
			if (normalized.IsVeto)
			{
				return null;
			}
			if (!normalized.IsValid)
			{
				try { ::$bvvar{namespace}.logValkyrieSkillFailure(actor, key, normalized.Reason, "weapon_skill_policy_invalid"); } catch (logError) {}
				continue;
			}
			local ret = normalized.Policy;
			ret.Provider <- provider;
			ret.ProviderKey <- key;
			ret.Raw <- policy;
			return "appendSakikoWeaponPolicy" in this ? this.appendSakikoWeaponPolicy(_usedSkill, ret) : ret;
		}
		catch (e)
		{
			try { ::$bvvar{namespace}.logValkyrieSkillFailure(actor, key, e, "weapon_skill_policy"); } catch (logError) {}
		}
	}
	return "appendSakikoWeaponPolicy" in this ? this.appendSakikoWeaponPolicy(_usedSkill, null) : null;
};

::$bvvar{namespace}.normalizeValkyrieWeaponSkillPolicy <- function( _policy )
{
	if (typeof _policy != "table")
	{
		return { IsValid = false, IsVeto = false, Reason = "policy_not_table", Policy = null };
	}
	if ("OptOut" in _policy)
	{
		if (typeof _policy.OptOut != "bool")
		{
			return { IsValid = false, IsVeto = false, Reason = "invalid_opt_out", Policy = null };
		}
		if (_policy.OptOut)
		{
			return { IsValid = false, IsVeto = true, Reason = "provider_veto", Policy = null };
		}
	}
	if (!("Token" in _policy) || typeof _policy.Token != "string" || _policy.Token.len() == 0)
	{
		return { IsValid = false, IsVeto = false, Reason = "invalid_token", Policy = null };
	}
	foreach (field in ["APDelta", "FatigueDelta"])
	{
		if (field in _policy && typeof _policy[field] != "integer")
		{
			return { IsValid = false, IsVeto = false, Reason = "invalid_" + field, Policy = null };
		}
	}
	if ("MinimumAPCost" in _policy && (typeof _policy.MinimumAPCost != "integer" || _policy.MinimumAPCost < 0))
	{
		return { IsValid = false, IsVeto = false, Reason = "invalid_minimum_ap_cost", Policy = null };
	}
	if ("HitChanceBonus" in _policy && (typeof _policy.HitChanceBonus != "integer" && typeof _policy.HitChanceBonus != "float"))
	{
		return { IsValid = false, IsVeto = false, Reason = "invalid_hit_chance_bonus", Policy = null };
	}
	if ("IgnoreDistance" in _policy && typeof _policy.IgnoreDistance != "bool")
	{
		return { IsValid = false, IsVeto = false, Reason = "invalid_ignore_distance", Policy = null };
	}
	foreach (field in ["MinRange", "MaxRange"])
	{
		if (field in _policy && (typeof _policy[field] != "integer" || _policy[field] < 0))
		{
			return { IsValid = false, IsVeto = false, Reason = "invalid_" + field, Policy = null };
		}
	}
	if ("TargetWeaponDamageMultiplier" in _policy && typeof _policy.TargetWeaponDamageMultiplier != "function")
	{
		return { IsValid = false, IsVeto = false, Reason = "invalid_target_weapon_damage_multiplier", Policy = null };
	}
	local minimum = "MinRange" in _policy ? _policy.MinRange : null;
	local maximum = "MaxRange" in _policy ? _policy.MaxRange : null;
	if (minimum != null && maximum != null && minimum > maximum)
	{
		return { IsValid = false, IsVeto = false, Reason = "invalid_range_order", Policy = null };
	}
	return {
		IsValid = true,
		IsVeto = false,
		Reason = null,
		Policy = {
			Token = _policy.Token,
			APDelta = "APDelta" in _policy ? _policy.APDelta : 0,
			MinimumAPCost = "MinimumAPCost" in _policy ? _policy.MinimumAPCost : 0,
			FatigueDelta = "FatigueDelta" in _policy ? _policy.FatigueDelta : 0,
			HitChanceBonus = "HitChanceBonus" in _policy ? _policy.HitChanceBonus : 0,
			IgnoreDistance = "IgnoreDistance" in _policy && _policy.IgnoreDistance,
			MinRange = minimum,
			MaxRange = maximum,
			TargetWeaponDamageMultiplier = "TargetWeaponDamageMultiplier" in _policy ? _policy.TargetWeaponDamageMultiplier : null
		}
	};
};

::$bvvar{namespace}.applyValkyrieWeaponSkillDelta <- function( _value, _delta, _minimum = 0 )
{
	local delta = typeof _delta == "integer" || typeof _delta == "float" ? _delta : 0;
	local minimum = typeof _minimum == "integer" || typeof _minimum == "float" ? ::Math.max(0, _minimum) : 0;
	return ::Math.max(minimum, _value + delta);
};

::$bvvar{namespace}.applyValkyrieWeaponSkillModifierPolicyToProperties <- function( _properties, _policy, _usedSkill, _target = null )
{
	if (_properties == null || _policy == null) return _properties;
	local multiplier = 1.0;
	if ("TargetWeaponDamageMultiplier" in _policy && _policy.TargetWeaponDamageMultiplier != null)
	{
		try
		{
			local candidate = _policy.TargetWeaponDamageMultiplier(_target);
			if ((typeof candidate == "integer" || typeof candidate == "float") && candidate >= 0.0) multiplier = candidate;
		}
		catch (e) {}
	}
	_properties.DamageRegularMult *= multiplier;
	if ("HitChanceBonus" in _policy && _policy.HitChanceBonus != 0)
	{
		local isRanged = false;
		try { isRanged = _usedSkill != null && _usedSkill.isRanged(); } catch (e) { isRanged = false; }
		if (isRanged) _properties.RangedSkill += _policy.HitChanceBonus;
		else _properties.MeleeSkill += _policy.HitChanceBonus;
	}
	if ("IgnoreDistance" in _policy && _policy.IgnoreDistance)
	{
		_properties.DamageAdditionalWithEachTile = 0.0;
		_properties.HitChanceAdditionalWithEachTile = 0.0;
	}
	return _properties;
};

::$bvvar{namespace}.evaluateValkyrieWeaponSkillGetter <- function( _kind, _usedSkill, _original )
{
	local runtime = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers;
	if (runtime.GetterFrames.len() > 0)
	{
		local current = runtime.GetterFrames[runtime.GetterFrames.len() - 1];
		if (current.Kind == _kind && current.Skill == _usedSkill)
		{
			return { Owned = false, Value = _original() };
		}
	}
	local route = { Kind = _kind, Skill = _usedSkill };
	runtime.GetterFrames.push(route);
	local ret = null;
	try
	{
		ret = _original();
	}
	catch (e)
	{
		runtime.GetterFrames.remove(runtime.GetterFrames.len() - 1);
		throw e;
	}
	runtime.GetterFrames.remove(runtime.GetterFrames.len() - 1);
	return { Owned = true, Value = ret };
};

::$bvvar{namespace}.getValkyrieWeaponSkillPolicyForGetter <- function( _usedSkill )
{
	local useRoute = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseRoute(_usedSkill);
	if (useRoute != null)
	{
		return useRoute.Disabled || useRoute.Frame == null ? null : useRoute.Frame.Policy;
	}
	local preview = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillPreviewRange(_usedSkill);
	if (preview != null)
	{
		return preview.Disabled ? null : preview.Policy;
	}
	return ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyFor(_usedSkill, false);
};

::$bvvar{namespace}.repairValkyrieWeaponSkillCostGetters <- function( _skill )
{
	if (_skill == null) return false;
	local repaired = false;
	try
	{
		if (typeof _skill.m != "table") return false;
		local hasAPGetter = false;
		try { hasAPGetter = typeof _skill.getActionPointCost == "function"; } catch (missingAPGetter) { hasAPGetter = false; }
		if (!hasAPGetter)
		{
			_skill.getActionPointCost <- function()
			{
				return this.m.ActionPointCost;
			};
			repaired = true;
		}
		local hasFatigueGetter = false;
		try { hasFatigueGetter = typeof _skill.getFatigueCost == "function"; } catch (missingFatigueGetter) { hasFatigueGetter = false; }
		if (!hasFatigueGetter)
		{
			_skill.getFatigueCost <- function()
			{
				return this.m.FatigueCost;
			};
			repaired = true;
		}
	}
	catch (e)
	{
		return false;
	}
	return repaired;
};

::$bvvar{namespace}.getValkyrieWeaponSkillActionPointCost <- function( _usedSkill, _original )
{
	local frame = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseFrame(_usedSkill);
	if (frame != null && !frame.Preparing && frame.Armed && frame.InVerify == 0 && !frame.PaymentStarted)
	{
		frame.PaymentStarted = true;
		if (!frame.CommitAttempted)
		{
			frame.CommitAttempted = true;
			try
			{
				if (frame.Policy.Provider != null) frame.Policy.Provider.commitValkyrieWeaponSkillPolicy(frame.Policy.Token, {
					Actor = frame.Actor,
					Skill = _usedSkill,
					TargetTile = frame.TargetTile,
					Policy = frame.Policy.Raw
				});
				if (frame.FinalAPAdjusted) frame.Policy.FinalAPProvider.commitFinalAP();
			}
			catch (e)
			{
				::$bvvar{namespace}.logValkyrieSkillFailure(frame.Actor, frame.Policy.ProviderKey, e, "weapon_skill_policy_commit");
			}
		}
		local additional = 0;
		try { additional = frame.Actor.getCurrentProperties().AdditionalActionPointCost; } catch (e) { additional = 0; }
		return frame.FrozenAP - additional;
	}
	if (frame != null && frame.FrozenAP != null && !frame.Preparing)
	{
		return frame.FrozenAP;
	}
	local evaluation = ::$bvvar{namespace}.evaluateValkyrieWeaponSkillGetter("AP", _usedSkill, _original);
	if (!evaluation.Owned) return evaluation.Value;
	local originalValue = evaluation.Value;
	local policy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyForGetter(_usedSkill);
	local value = policy == null ? originalValue : ::$bvvar{namespace}.applyValkyrieWeaponSkillDelta(originalValue, policy.APDelta, policy.MinimumAPCost);
	if (policy != null && "FinalAPProvider" in policy) {
		local adjusted = policy.FinalAPProvider.adjustFinalAP(value);
		if (frame != null && frame.Preparing) frame.FinalAPAdjusted = adjusted < value;
		return adjusted;
	}
	return value;
};

::$bvvar{namespace}.getValkyrieWeaponSkillFatigueCost <- function( _usedSkill, _original )
{
	local frame = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseFrame(_usedSkill);
	if (frame != null && frame.FrozenFatigue != null && !frame.Preparing)
	{
		return frame.FrozenFatigue;
	}
	local evaluation = ::$bvvar{namespace}.evaluateValkyrieWeaponSkillGetter("Fatigue", _usedSkill, _original);
	if (!evaluation.Owned) return evaluation.Value;
	local originalValue = evaluation.Value;
	local policy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyForGetter(_usedSkill);
	local value = policy == null ? originalValue : ::$bvvar{namespace}.applyValkyrieWeaponSkillDelta(originalValue, policy.FatigueDelta);
	return "adjustSakikoFatigueCost" in this ? this.adjustSakikoFatigueCost(_usedSkill, value) : value;
};

::$bvvar{namespace}.getValkyrieWeaponSkillRange <- function( _kind, _usedSkill, _original )
{
	local invalidSkillRange = _kind == "MinRange" ? 999 : 0;
	try
	{
		if (_usedSkill == null || typeof _usedSkill.m != "table")
		{
			return invalidSkillRange;
		}
		local configuredRange = _usedSkill.m[_kind];
		if (typeof configuredRange != "integer" && typeof configuredRange != "float") return invalidSkillRange;
	}
	catch (e)
	{
		return invalidSkillRange;
	}
	local frame = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseFrame(_usedSkill);
	local frozenField = _kind == "MinRange" ? "FrozenMinRange" : "FrozenMaxRange";
	if (frame != null && frame[frozenField] != null && !frame.Preparing)
	{
		return frame[frozenField];
	}
	local evaluation = ::$bvvar{namespace}.evaluateValkyrieWeaponSkillGetter(_kind, _usedSkill, _original);
	if (!evaluation.Owned) return evaluation.Value;
	local originalValue = evaluation.Value;
	local policy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyForGetter(_usedSkill);
	if (policy == null || policy[_kind] == null)
	{
		return originalValue;
	}
	return ::Math.max(0, policy[_kind]);
};

::$bvvar{namespace}.getValkyrieWeaponSkillMinRange <- function( _usedSkill, _original )
{
	return ::$bvvar{namespace}.getValkyrieWeaponSkillRange("MinRange", _usedSkill, _original);
};

::$bvvar{namespace}.getValkyrieWeaponSkillMaxRange <- function( _usedSkill, _original )
{
	return ::$bvvar{namespace}.getValkyrieWeaponSkillRange("MaxRange", _usedSkill, _original);
};

::$bvvar{namespace}.getValkyrieWeaponSkillAffordability <- function( _usedSkill, _original )
{
	// Some broad compatibility packs replace parts of the base skill tree.  A
	// partially constructed active can retain isAffordable while losing one of
	// the inherited cost getters.  Letting the base implementation call that
	// missing method makes tactical AI retry the same behavior forever.
	try
	{
		if (_usedSkill == null || typeof _usedSkill.m != "table"
			|| typeof _usedSkill.getActionPointCost != "function" || typeof _usedSkill.getFatigueCost != "function")
		{
			return false;
		}
	}
	catch (e)
	{
		return false;
	}
	local frame = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseFrame(_usedSkill);
	if (frame == null)
	{
		return _original();
	}
	if (frame.AffordabilityReady)
	{
		return frame.Affordable;
	}
	if (frame.EvaluatingAffordability)
	{
		return _original();
	}
	frame.EvaluatingAffordability = true;
	local ret = false;
	try
	{
		ret = _original();
	}
	catch (e)
	{
		frame.EvaluatingAffordability = false;
		throw e;
	}
	frame.EvaluatingAffordability = false;
	frame.Affordable = ret;
	frame.AffordabilityReady = true;
	return ret;
};

::$bvvar{namespace}.withValkyrieWeaponSkillPreviewRange <- function( _usedSkill, _callback )
{
	local existing = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillPreviewRange(_usedSkill);
	if (existing != null)
	{
		return _callback();
	}
	local frame = {
		Skill = _usedSkill,
		Policy = null,
		Disabled = true,
		OriginalMinRange = _usedSkill.m.MinRange,
		OriginalMaxRange = _usedSkill.m.MaxRange
	};
	::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.PreviewRangeFrames.push(frame);
	local hasError = false;
	local failure = null;
	local ret = null;
	try
	{
		frame.Policy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyFor(_usedSkill, false);
		frame.Disabled = frame.Policy == null;
		if (!frame.Disabled)
		{
			_usedSkill.m.MinRange = _usedSkill.getMinRange();
			_usedSkill.m.MaxRange = _usedSkill.getMaxRange();
		}
		ret = _callback();
	}
	catch (e)
	{
		hasError = true;
		failure = e;
	}
	try
	{
		_usedSkill.m.MinRange = frame.OriginalMinRange;
		_usedSkill.m.MaxRange = frame.OriginalMaxRange;
	}
	catch (restoreError)
	{
		if (!hasError)
		{
			hasError = true;
			failure = restoreError;
		}
	}
	local stack = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.PreviewRangeFrames;
	for (local i = stack.len() - 1; i >= 0; i--)
	{
		if (stack[i] == frame)
		{
			stack.remove(i);
			break;
		}
	}
	if (hasError) throw failure;
	return ret;
};

::$bvvar{namespace}.verifyValkyrieWeaponSkillTarget <- function( _usedSkill, _original, _originTile, _targetTile )
{
	local useRoute = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseRoute(_usedSkill);
	local frame = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseFrame(_usedSkill);
	if (frame == null)
	{
		if (useRoute != null)
		{
			return _original(_originTile, _targetTile);
		}
		return ::$bvvar{namespace}.withValkyrieWeaponSkillPreviewRange(_usedSkill, function()
		{
			return _original(_originTile, _targetTile);
		});
	}
	if (frame.InVerify > 0)
	{
		return _original(_originTile, _targetTile);
	}
	frame.InVerify++;
	local oldMinRange = _usedSkill.m.MinRange;
	local oldMaxRange = _usedSkill.m.MaxRange;
	_usedSkill.m.MinRange = frame.FrozenMinRange;
	_usedSkill.m.MaxRange = frame.FrozenMaxRange;
	local ret = false;
	try
	{
		ret = _original(_originTile, _targetTile);
	}
	catch (e)
	{
		_usedSkill.m.MinRange = oldMinRange;
		_usedSkill.m.MaxRange = oldMaxRange;
		frame.InVerify--;
		throw e;
	}
	_usedSkill.m.MinRange = oldMinRange;
	_usedSkill.m.MaxRange = oldMaxRange;
	frame.InVerify--;
	if (ret)
	{
		frame.Armed = true;
	}
	return ret;
};

::$bvvar{namespace}.beginValkyrieWeaponSkillUse <- function( _usedSkill, _targetTile, _forFree = false )
{
	local existing = ::$bvvar{namespace}.getActiveValkyrieWeaponSkillUseRoute(_usedSkill);
	if (existing != null)
	{
		return { Owned = false, Skill = _usedSkill, Frame = existing.Frame };
	}
	local route = { Owned = true, Skill = _usedSkill, Frame = null, Disabled = true };
	::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames.push(route);
	local policy = null;
	try
	{
		policy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyFor(_usedSkill, _forFree);
	}
	catch (e)
	{
		::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames.remove(::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames.len() - 1);
		throw e;
	}
	if (policy == null)
	{
		return route;
	}
	route.Disabled = false;
	local actor = null;
	local frame = {
		Skill = _usedSkill,
		Actor = actor,
		TargetTile = _targetTile,
		Policy = policy,
		Preparing = true,
		FrozenAP = null,
		FrozenFatigue = null,
		FrozenMinRange = null,
		FrozenMaxRange = null,
		OriginalMinRange = _usedSkill.m.MinRange,
		AffordabilityReady = false,
		EvaluatingAffordability = false,
		Affordable = false,
		InVerify = 0,
		Armed = false,
		PaymentStarted = false,
		CommitAttempted = false,
		FinalAPAdjusted = false
	};
	route.Frame = frame;
	try
	{
		actor = _usedSkill.getContainer().getActor();
		frame.Actor = actor;
		frame.FrozenAP = _usedSkill.getActionPointCost();
		frame.FrozenFatigue = _usedSkill.getFatigueCost();
		frame.FrozenMinRange = _usedSkill.getMinRange();
		frame.FrozenMaxRange = _usedSkill.getMaxRange();
		frame.Preparing = false;
		_usedSkill.m.MinRange = frame.FrozenMinRange;
		_usedSkill.isAffordable();
	}
	catch (e)
	{
		_usedSkill.m.MinRange = frame.OriginalMinRange;
		::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames.remove(::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames.len() - 1);
		throw e;
	}
	return route;
};

::$bvvar{namespace}.finishValkyrieWeaponSkillUse <- function( _route )
{
	if (_route == null || !_route.Owned)
	{
		return false;
	}
	if (_route.Frame != null && _route.Frame.OriginalMinRange != null)
	{
		try { _route.Skill.m.MinRange = _route.Frame.OriginalMinRange; } catch (e) {}
	}
	local stack = ::$bvvar{namespace}.ValkyrieWeaponSkillModifiers.UseFrames;
	for (local i = stack.len() - 1; i >= 0; i--)
	{
		if (stack[i] == _route)
		{
			stack.remove(i);
			return true;
		}
	}
	return false;
};
