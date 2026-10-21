::$bvvar{namespace}.ValkyrieAttackDefenseAdapter <- {
	ShieldRelevanceBypassFrames = [],
	ShieldRelevanceOverrideFrames = []
};

::$bvvar{namespace}.resetValkyrieAttackDefenseAdapter <- function()
{
	local frames = this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames;
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		try
		{
			if (frames[i].Applied) frames[i].Skill.m.IsShieldRelevant = frames[i].OriginalShieldRelevant;
		}
		catch (e)
		{
		}
	}
	this.ValkyrieAttackDefenseAdapter.ShieldRelevanceBypassFrames = [];
	this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames = [];
};

::$bvvar{namespace}.pushValkyrieShieldRelevanceBypass <- function( _skill )
{
	local frame = { Skill = _skill };
	this.ValkyrieAttackDefenseAdapter.ShieldRelevanceBypassFrames.push(frame);
	return frame;
};

::$bvvar{namespace}.popValkyrieShieldRelevanceBypass <- function( _frame )
{
	local stack = this.ValkyrieAttackDefenseAdapter.ShieldRelevanceBypassFrames;
	for (local i = stack.len() - 1; i >= 0; i--)
	{
		if (stack[i] == _frame)
		{
			stack.remove(i);
			return true;
		}
	}
	return false;
};

::$bvvar{namespace}.isValkyrieShieldRelevanceBypassed <- function( _skill )
{
	local stack = this.ValkyrieAttackDefenseAdapter.ShieldRelevanceBypassFrames;
	return stack.len() > 0 && stack[stack.len() - 1].Skill == _skill;
};

::$bvvar{namespace}.armValkyrieShieldRelevanceOverride <- function( _attempt, _skill, _target )
{
	if (_attempt == null || _skill == null) return null;
	local targetID = this.getValkyrieCombatObjectID(_target);
	foreach (frame in this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames)
	{
		if (frame.AttemptID == _attempt.AttemptID && frame.Skill == _skill)
		{
			frame.TargetID = targetID;
			this.syncValkyrieShieldRelevanceOverride(_skill);
			return frame;
		}
	}
	local originalShieldRelevant = true;
	try { originalShieldRelevant = _skill.m.IsShieldRelevant; } catch (e) {}
	local frame = {
		AttemptID = _attempt.AttemptID,
		Skill = _skill,
		TargetID = targetID,
		OriginalShieldRelevant = originalShieldRelevant,
		Applied = false
	};
	this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames.push(frame);
	this.syncValkyrieShieldRelevanceOverride(_skill);
	return frame;
};

::$bvvar{namespace}.getCurrentValkyrieShieldRelevanceOverride <- function( _skill )
{
	if (_skill == null) return null;
	local attempts = this.ValkyrieCombatEvents.AttemptStack;
	if (attempts.len() == 0) return null;
	local attempt = attempts[attempts.len() - 1];
	if (!this.isPendingValkyrieAttempt(attempt)
		|| !this.sameValkyrieCombatObject(attempt.SkillRef, _skill, attempt.SkillID))
	{
		return null;
	}
	local frames = this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames;
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		if (frames[i].AttemptID == attempt.AttemptID && frames[i].Skill == _skill) return frames[i];
	}
	return null;
};

::$bvvar{namespace}.syncValkyrieShieldRelevanceOverride <- function( _skill )
{
	if (_skill == null) return null;
	local active = this.getCurrentValkyrieShieldRelevanceOverride(_skill);
	local frames = this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames;
	for (local i = frames.len() - 1; i >= 0; i--)
	{
		local frame = frames[i];
		if (frame.Skill == _skill && frame != active && frame.Applied)
		{
			try { frame.Skill.m.IsShieldRelevant = frame.OriginalShieldRelevant; } catch (e) {}
			frame.Applied = false;
		}
	}
	if (active != null)
	{
		try { active.Skill.m.IsShieldRelevant = false; } catch (e) {}
		active.Applied = true;
	}
	return active;
};

::$bvvar{namespace}.releaseValkyrieShieldRelevanceOverridesForAttempt <- function( _attemptID )
{
	local stack = this.ValkyrieAttackDefenseAdapter.ShieldRelevanceOverrideFrames;
	local removed = false;
	for (local i = stack.len() - 1; i >= 0; i--)
	{
		if (stack[i].AttemptID == _attemptID)
		{
			local skill = stack[i].Skill;
			if (stack[i].Applied)
			{
				try { skill.m.IsShieldRelevant = stack[i].OriginalShieldRelevant; } catch (e) {}
			}
			stack.remove(i);
			try { this.syncValkyrieShieldRelevanceOverride(skill); } catch (e) {}
			removed = true;
		}
	}
	return removed;
};

::$bvvar{namespace}.isValkyrieShieldRelevanceOverridden <- function( _skill )
{
	return this.getCurrentValkyrieShieldRelevanceOverride(_skill) != null;
};

::$bvvar{namespace}.finalizeValkyrieAttackDefenseAttempt <- function( _attempt, _consume, _context = null )
{
	if (_attempt == null) return false;
	local consumed = false;
	if (_consume)
	{
		try
		{
			consumed = this.consumeValkyrieAttackDefenseClaim(_attempt.AttemptID, _attempt.TargetID, _context);
		}
		catch (e)
		{
		}
	}
	try { this.releaseValkyrieAttackDefenseClaimsForAttempt(_attempt.AttemptID); } catch (e) {}
	try { this.releaseValkyrieShieldRelevanceOverridesForAttempt(_attempt.AttemptID); } catch (e) {}
	try { this.syncValkyrieShieldRelevanceOverride(this.readValkyrieCombatWeakRef(_attempt.SkillRef)); } catch (e) {}
	return consumed;
};

::$bvvar{namespace}.getValkyrieAttackDefenseSkillSnapshot <- function( _actor )
{
	local ret = [];
	try
	{
		local container = _actor == null ? null : _actor.getSkills();
		if (container == null || !("m" in container) || !("Skills" in container.m))
		{
			return ret;
		}
		foreach (skill in container.m.Skills) ret.push(skill);
	}
	catch (e)
	{
	}
	return ret;
};

::$bvvar{namespace}.getValkyrieAttackDefenseManagedPassives <- function( _attacker )
{
	local ret = [];
	foreach (provider in ::$bvvar{namespace}.getValkyrieAttackDefenseSkillSnapshot(_attacker))
	{
		try
		{
			if (!::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(provider)) continue;
			local definition = ::$bvvar{namespace}.getSkillDefinition(provider.getBattleValkyriesSkillKey());
			if (definition != null && definition.Kind == "passive") ret.push(provider);
		}
		catch (e)
		{
		}
	}
	return ret;
};

::$bvvar{namespace}.getValkyrieAttackDefenseManagedEffects <- function( _target )
{
	local ret = [];
	foreach (provider in ::$bvvar{namespace}.getValkyrieAttackDefenseSkillSnapshot(_target))
	{
		try
		{
			if (provider != null && provider.isBattleValkyriesManagedCombatEffect() == true && provider.isGarbage() == false)
			{
				ret.push(provider);
			}
		}
		catch (e)
		{
		}
	}
	return ret;
};

::$bvvar{namespace}.resolveValkyrieActorDefensePolicy <- function( _attacker, _usedSkill, _target, _isPreview = false )
{
	local passives = ::$bvvar{namespace}.getValkyrieAttackDefenseManagedPassives(_attacker);
	local providers = [];
	foreach (provider in passives) providers.push(provider);
	foreach (provider in ::$bvvar{namespace}.getValkyrieAttackDefenseManagedEffects(_target)) providers.push(provider);

	local ret = ::$bvvar{namespace}.resolveValkyrieAttackDefensePolicy(providers, _usedSkill);
	local ignoreActualShield = false;
	foreach (provider in passives)
	{
		try
		{
			if (provider.ignoresShieldFor(_usedSkill)) ignoreActualShield = true;
			if ("ignoresShieldAgainst" in provider && provider.ignoresShieldAgainst(_usedSkill, _target)) ignoreActualShield = true;
		}
		catch (e)
		{
		}
	}

	try
	{
		local weaponPolicy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(_attacker, _usedSkill, _target);
		if (weaponPolicy == null)
		{
			weaponPolicy = ::$bvvar{namespace}.getValkyrieWeaponSkillPolicyForGetter(_usedSkill);
		}
		if (weaponPolicy != null)
		{
			if ("IgnoreShield" in weaponPolicy && weaponPolicy.IgnoreShield) ignoreActualShield = true;
			else if ("Raw" in weaponPolicy && weaponPolicy.Raw != null
				&& "IgnoreShield" in weaponPolicy.Raw && weaponPolicy.Raw.IgnoreShield == true) ignoreActualShield = true;
		}
	}
	catch (e)
	{
	}

	if (ignoreActualShield)
	{
		ret = ::$bvvar{namespace}.mergeValkyrieAttackDefensePolicy(ret,
			::$bvvar{namespace}.normalizeValkyrieAttackDefensePolicy({ IgnoreActualShield = true }));
	}
	return ret;
};

::$bvvar{namespace}.getTopValkyrieAttackDefenseAttempt <- function( _attacker, _usedSkill )
{
	local stack = ::$bvvar{namespace}.ValkyrieCombatEvents.AttemptStack;
	if (stack.len() == 0) return null;
	local attempt = stack[stack.len() - 1];
	if (!::$bvvar{namespace}.isPendingValkyrieAttempt(attempt)
		|| !::$bvvar{namespace}.sameValkyrieCombatObject(attempt.UserRef, _attacker, attempt.UserID)
		|| !::$bvvar{namespace}.sameValkyrieCombatObject(attempt.SkillRef, _usedSkill, attempt.SkillID))
	{
		return null;
	}
	return attempt;
};

::$bvvar{namespace}.getValkyrieActualShieldDefenseContribution <- function( _target, _usedSkill )
{
	local shield = null;
	try { shield = _target.getItems().getItemAtSlot(::Const.ItemSlot.Offhand); } catch (e) { shield = null; }
	local hasUsableShield = false;
	local rawMelee = 0;
	local rawRanged = 0;
	if (shield != null)
	{
		try
		{
			hasUsableShield = shield.isItemType(::Const.Items.ItemType.Shield) && shield.getCondition() > 0;
			if (hasUsableShield)
			{
				rawMelee = shield.getMeleeDefense();
				rawRanged = shield.getRangedDefense();
			}
		}
		catch (e)
		{
			hasUsableShield = false;
		}
	}

	local properties = null;
	try { properties = _target.getCurrentProperties(); } catch (e) { properties = null; }
	local specialized = properties != null && "IsSpecializedInShields" in properties && properties.IsSpecializedInShields;
	local proficient = properties != null && "IsProficientWithShieldSkills" in properties && properties.IsProficientWithShieldSkills;
	local wall = null;
	try { wall = _target.getSkills().getSkillByID("effects.shieldwall"); } catch (e) { wall = null; }
	local adjacentCount = 0;
	if (wall != null)
	{
		try { adjacentCount = ::Math.floor(wall.getBonus() / 5); } catch (e) { adjacentCount = 0; }
	}
	return ::$bvvar{namespace}.calculateValkyrieShieldDefenseContribution(
		hasUsableShield,
		rawMelee,
		rawRanged,
		_usedSkill.isRanged(),
		specialized,
		wall != null,
		proficient,
		adjacentCount,
		::Const.Combat.ShieldWallMaxAllies
	);
};

::$bvvar{namespace}.MH.hookTree("scripts/entity/tactical/actor", function(q) {
	local adapterLayerToken = {};
	q.getDefense = @(__original) function( _attackingEntity, _skill, _properties )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_skill))
		{
			return __original(_attackingEntity, _skill, _properties);
		}
		local owner = ::$bvvar{namespace}.beginValkyrieSkillAdapterOperation("actor_defense", _skill, this, adapterLayerToken);
		if (!owner.Owned)
		{
			return __original(_attackingEntity, _skill, _properties);
		}
		local execute = function()
		{
		local originalShieldRelevant = _skill.m.IsShieldRelevant;
		local callProperties = _properties;
		local policy = null;
		local attempt = ::$bvvar{namespace}.getTopValkyrieAttackDefenseAttempt(_attackingEntity, _skill);
		::$bvvar{namespace}.syncValkyrieShieldRelevanceOverride(_skill);
		if (attempt != null)
		{
			local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(this);
			policy = ::$bvvar{namespace}.getValkyrieAttackDefenseClaim(attempt.AttemptID, targetID);
			if (attempt.TargetID != targetID)
			{
				::$bvvar{namespace}.releaseValkyrieAttackDefenseClaim(attempt.AttemptID, attempt.TargetID);
				::$bvvar{namespace}.releaseValkyrieShieldRelevanceOverridesForAttempt(attempt.AttemptID);
				::$bvvar{namespace}.retargetValkyrieTargetAttempt(attempt, this);
				::$bvvar{namespace}.syncValkyrieShieldRelevanceOverride(_skill);
			}
			if ("reserveValkyrieAttackNullificationForAttempt" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.reserveValkyrieAttackNullificationForAttempt(attempt, _attackingEntity, _skill, this);
			}
		}
		originalShieldRelevant = _skill.m.IsShieldRelevant;

		if (policy == null)
		{
			policy = ::$bvvar{namespace}.resolveValkyrieActorDefensePolicy(_attackingEntity, _skill, this, attempt == null);
			if (attempt != null && policy != null)
			{
				local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(this);
				policy = ::$bvvar{namespace}.reserveValkyrieAttackDefenseClaim(attempt.AttemptID, targetID, policy);
			}
		}

		local ignoreActualShield = policy != null && policy.IgnoreActualShield;
		local shieldBypass = null;
		if (ignoreActualShield && attempt != null)
		{
			if ("AttackDefenseRawTouched" in attempt) attempt.AttackDefenseRawTouched = true;
			else attempt.AttackDefenseRawTouched <- true;
			::$bvvar{namespace}.armValkyrieShieldRelevanceOverride(attempt, _skill, this);
		}
		local hasError = false;
		local failure = null;
		local ret = null;
		try
		{
			if (ignoreActualShield)
			{
				callProperties = _properties.getClone();
				local contribution = ::$bvvar{namespace}.getValkyrieActualShieldDefenseContribution(this, _skill);
				if (_skill.isRanged()) callProperties.RangedDefense -= contribution;
				else callProperties.MeleeDefense -= contribution;
				shieldBypass = ::$bvvar{namespace}.pushValkyrieShieldRelevanceBypass(_skill);
				_skill.m.IsShieldRelevant = true;
			}
			// Scoped partial shield bypass, including shieldwall, before the native soft cap.
			// No equipment or skill flags are mutated, and nested actor wrappers run once.
			local weaponPolicy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(_attackingEntity, _skill, this);
			local shieldScale = weaponPolicy != null && "ShieldDefenseScale" in weaponPolicy ? weaponPolicy.ShieldDefenseScale : 1.0;
			if (weaponPolicy == null && "getValkyrieShieldDefenseScale" in _skill) shieldScale = _skill.getValkyrieShieldDefenseScale();
			if (!ignoreActualShield && _skill.isShieldRelevant() && shieldScale >= 0.0 && shieldScale < 1.0)
			{
				callProperties = callProperties.getClone();
				local contribution = ::$bvvar{namespace}.getValkyrieActualShieldDefenseContribution(this, _skill) * (1.0 - shieldScale);
				if (_skill.isRanged()) callProperties.RangedDefense -= contribution;
				else callProperties.MeleeDefense -= contribution;
			}
			ret = __original(_attackingEntity, _skill, callProperties);
			if (policy != null) ret -= policy.HitChanceBonus;
		}
		catch (e)
		{
			hasError = true;
			failure = e;
		}
		if (shieldBypass != null) ::$bvvar{namespace}.popValkyrieShieldRelevanceBypass(shieldBypass);
		_skill.m.IsShieldRelevant = originalShieldRelevant;
		::$bvvar{namespace}.syncValkyrieShieldRelevanceOverride(_skill);
		if (hasError) throw failure;
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
});
