::$bvvar{namespace}.getValkyriePassiveSkillOrder <- function()
{
	return ::Const.SkillOrder.Trait + 500;
};

::$bvvar{namespace}.makeValkyrieSkillResult <- function( _key, _success, _code )
{
	return {
		Success = _success,
		Code = _code,
		SkillKey = _key,
		Added = 0,
		Kept = 0,
		Removed = 0
	};
};

::$bvvar{namespace}.makeValkyrieSkillSyncResult <- function( _reason )
{
	return {
		Success = false,
		Code = "sync_failed",
		SkillKey = null,
		Added = 0,
		Kept = 0,
		Removed = 0,
		Reason = _reason,
		FailedKey = null
	};
};

::$bvvar{namespace}.getValkyrieSkillLogActor <- function( _actor )
{
	if (_actor == null)
	{
		return "null";
	}

	try
	{
		local actorName = _actor.getName();
		return actorName == null ? "unknown" : actorName.tostring();
	}
	catch (e)
	{
		return "unknown";
	}
};

::$bvvar{namespace}.logValkyrieSkillFailure <- function( _actor, _key, _reason, _stage )
{
	local keyText = _key == null ? "null" : _key.tostring();
	local reasonText = _reason == null ? "unknown" : _reason.tostring();
	::logError("[Battle Valkyries] [SkillSystem] actor=" + ::$bvvar{namespace}.getValkyrieSkillLogActor(_actor) + " key=" + keyText + " reason=" + reasonText + " stage=" + _stage);
};

::$bvvar{namespace}.getValkyrieSkillActorContainer <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		local container = _actor.getSkills();
		return container != null && "m" in container && "Skills" in container.m ? container : null;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getValkyrieSkillActorFlags <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		return _actor.getFlags();
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.isValidValkyrieSkillActor <- function( _actor )
{
	return ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor) != null && ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor) != null;
};

::$bvvar{namespace}.getActorValkyrieSkillTemplate <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);
		return valkyrieID == null || valkyrieID == "" ? null : ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.hasValkyrieTemplateSkillEntitlement <- function( _actor, _key )
{
	local template = ::$bvvar{namespace}.getActorValkyrieSkillTemplate(_actor);
	if (template == null || !("SkillLoadout" in template) || typeof template.SkillLoadout != "array")
	{
		return false;
	}

	foreach( skillKey in template.SkillLoadout )
	{
		if (skillKey == _key)
		{
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement <- function( _actor, _key )
{
	local flags = ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor);
	local flag = ::$bvvar{namespace}.getValkyrieLearnedSkillFlag(_key);
	if (flags == null || flag == null || !flags.has(flag))
	{
		return false;
	}

	local value = flags.get(flag);
	return typeof value == "integer" && value == 1;
};

::$bvvar{namespace}.hasValkyrieSkillDefinitionTag <- function( _definition, _tag )
{
	if (_definition == null || typeof _tag != "string" || !("Tags" in _definition) || typeof _definition.Tags != "array")
	{
		return false;
	}

	foreach( tag in _definition.Tags )
	{
		if (tag == _tag)
		{
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.hasHimekoTrailblazeUnlocked <- function( _actor )
{
	local container = ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor);
	if (container == null)
	{
		return false;
	}

	try
	{
		local trait = container.getSkillByID("$bvvar{modId}.trait.himeko_bond");
		return trait != null && "hasTrailblazeUnlocked" in trait && trait.hasTrailblazeUnlocked();
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isValkyrieSkillEntitlementActive <- function( _actor, _definition )
{
	if (::$bvvar{namespace}.hasValkyrieSkillDefinitionTag(_definition, "the_herta_full_bond"))
        return "hasHertaBondUpgrade" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasHertaBondUpgrade(_actor,100);
	if (::$bvvar{namespace}.hasValkyrieSkillDefinitionTag(_definition, "saber_full_bond"))
        return "hasSaberBondUpgrade" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasSaberBondUpgrade(_actor,100);
	if ("EsStage" in _definition) return ::$bvvar{namespace}.Es.entitled(_actor,_definition.EsStage);
	if ("OlgaStage" in _definition) return ::$bvvar{namespace}.Olga.entitled(_actor, _definition);
	if ("BlackBeastStage" in _definition) return ::$bvvar{namespace}.BlackBeast.entitled(_actor, _definition);
	if (::$bvvar{namespace}.hasValkyrieSkillDefinitionTag(_definition, "ye_shunguang_full_bond"))
	{
		local container = ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor);
		if (container == null || ::$bvvar{namespace}.getActorValkyrieID(_actor) != "ye_shunguang") return false;
		local trait = container.getSkillByID("$bvvar{modId}.trait.ye_shunguang_bond");
		return trait != null && trait.hasTriggeredStage(100);
	}
	if ("FiveOwner" in _definition) return ::$bvvar{namespace}.FiveValkyries.entitled(_actor, _definition);
	if ("SwordMaidenHuntPoints" in _definition)
	{
		return "isSwordMaidenMilestoneUnlocked" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isSwordMaidenMilestoneUnlocked(_actor, _definition.SwordMaidenHuntPoints);
	}

	local beforeTrailblaze = ::$bvvar{namespace}.hasValkyrieSkillDefinitionTag(_definition, "himeko_before_trailblaze");
	local afterTrailblaze = ::$bvvar{namespace}.hasValkyrieSkillDefinitionTag(_definition, "himeko_after_trailblaze");
	if (!beforeTrailblaze && !afterTrailblaze)
	{
		return true;
	}

	local unlocked = ::$bvvar{namespace}.hasHimekoTrailblazeUnlocked(_actor);
	return beforeTrailblaze ? !unlocked : unlocked;
};

::$bvvar{namespace}.hasSkillEntitlement <- function( _actor, _key )
{
	if (!::$bvvar{namespace}.isValidValkyrieSkillActor(_actor))
	{
		return false;
	}

	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	if (definition == null || definition.Lifetime != "persistent")
	{
		return false;
	}

	local entitled = ::$bvvar{namespace}.hasValkyrieTemplateSkillEntitlement(_actor, _key)
		|| ::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement(_actor, _key);
	return entitled && ::$bvvar{namespace}.isValkyrieSkillEntitlementActive(_actor, definition);
};

::$bvvar{namespace}.canLearnSkill <- function( _actor, _key, _source )
{
	local result = ::$bvvar{namespace}.makeValkyrieSkillResult(_key, false, "invalid_actor");
	if (!::$bvvar{namespace}.isValidValkyrieSkillActor(_actor))
	{
		return result;
	}

	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	if (definition == null)
	{
		result.Code = "unknown_skill";
		return result;
	}

	if (definition.Lifetime != "persistent")
	{
		result.Code = "not_persistent";
		return result;
	}

	if (!definition.Learnable)
	{
		result.Code = "not_learnable";
		return result;
	}

	if (::$bvvar{namespace}.hasSkillEntitlement(_actor, _key))
	{
		result.Code = "already_known";
		return result;
	}

	local actorLevel = 0;
	try
	{
		actorLevel = _actor.getLevel();
	}
	catch (e)
	{
		result.Code = "invalid_actor";
		return result;
	}

	if (actorLevel < definition.Requirements.MinLevel)
	{
		result.Code = "requirements_failed";
		return result;
	}

	foreach( requiredKey in definition.Requirements.RequiredSkills )
	{
		if (!::$bvvar{namespace}.hasSkillEntitlement(_actor, requiredKey))
		{
			result.Code = "requirements_failed";
			return result;
		}
	}

	foreach( forbiddenKey in definition.Requirements.ForbiddenSkills )
	{
		if (::$bvvar{namespace}.hasSkillEntitlement(_actor, forbiddenKey))
		{
			result.Code = "requirements_failed";
			return result;
		}
	}

	result.Success = true;
	result.Code = "success";
	return result;
};

::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill <- function( _skill )
{
	if (_skill == null)
	{
		return false;
	}

	try
	{
		return _skill.isBattleValkyriesManagedSkill() && !_skill.isGarbage();
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isValkyrieRuntimeSkillValidForKey <- function( _skill, _key, _lifetime )
{
	if (!::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(_skill))
	{
		return false;
	}

	try
	{
		return _skill.getBattleValkyriesSkillKey() == _key
			&& _skill.getBattleValkyriesSkillLifetime() == _lifetime
			&& _skill.getID() == ::$bvvar{namespace}.getValkyrieSkillRuntimeID(_key);
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.doesValkyrieSkillArrayContain <- function( _skills, _skill )
{
	foreach( current in _skills )
	{
		if (current == _skill)
		{
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.getValkyrieSkillContainerState <- function( _container )
{
	local state = [];
	if (_container == null || !("m" in _container) || !("Skills" in _container.m))
	{
		return state;
	}

	foreach( skill in _container.m.Skills )
	{
		if (!::$bvvar{namespace}.doesValkyrieSkillArrayContain(state, skill))
		{
			state.push(skill);
		}
	}

	if ("SkillsToAdd" in _container.m)
	{
		foreach( skill in _container.m.SkillsToAdd )
		{
			if (!::$bvvar{namespace}.doesValkyrieSkillArrayContain(state, skill))
			{
				state.push(skill);
			}
		}
	}

	return state;
};

::$bvvar{namespace}.getRuntimeSkillByKey <- function( _actor, _key )
{
	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	local container = ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor);
	if (definition == null || container == null)
	{
		return null;
	}

	foreach( skill in ::$bvvar{namespace}.getValkyrieSkillContainerState(container) )
	{
		if (::$bvvar{namespace}.isValkyrieRuntimeSkillValidForKey(skill, _key, definition.Lifetime))
		{
			return skill;
		}
	}

	return null;
};

::$bvvar{namespace}.createValkyrieRuntimeSkill <- function( _actor, _key )
{
	local result = ::$bvvar{namespace}.makeValkyrieSkillResult(_key, false, "runtime_create_failed");
	result.RuntimeSkill <- null;

	if (!::$bvvar{namespace}.isValidValkyrieSkillActor(_actor))
	{
		result.Code = "invalid_actor";
		return result;
	}

	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	if (definition == null)
	{
		result.Code = "unknown_skill";
		return result;
	}

	local runtimeSkill = null;
	try
	{
		runtimeSkill = ::new(definition.RuntimeScript);
		if (runtimeSkill == null)
		{
			throw "runtime script returned null";
		}

		runtimeSkill.bindValkyrieSkill(_key, definition);
		if (!::$bvvar{namespace}.isValkyrieRuntimeSkillValidForKey(runtimeSkill, _key, definition.Lifetime))
		{
			throw "runtime binding verification failed";
		}
	}
	catch (e)
	{
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, e, "runtime.create");
		return result;
	}

	result.Success = true;
	result.Code = "success";
	result.RuntimeSkill = runtimeSkill;
	return result;
};

::$bvvar{namespace}.doesValkyrieSkillContainerContain <- function( _container, _skill )
{
	if (_container == null || _skill == null || !("m" in _container))
	{
		return false;
	}

	try
	{
		if (_skill.isGarbage())
		{
			return false;
		}
	}
	catch (e)
	{
		return false;
	}

	foreach( current in ::$bvvar{namespace}.getValkyrieSkillContainerState(_container) )
	{
		if (current == _skill)
		{
			return true;
		}
	}

	return false;
};

::$bvvar{namespace}.removeValkyrieSkillFromContainerState <- function( _container, _skill )
{
	if (_container == null || _skill == null || !("m" in _container) || !("Skills" in _container.m))
	{
		return false;
	}

	if ("SkillsToAdd" in _container.m)
	{
		foreach( i, pendingSkill in _container.m.SkillsToAdd )
		{
			if (pendingSkill == _skill)
			{
				_container.m.SkillsToAdd.remove(i);
				_skill.setContainer(null);
				return true;
			}
		}
	}

	foreach( activeSkill in _container.m.Skills )
	{
		if (activeSkill == _skill)
		{
			_container.remove(_skill);
			return !::$bvvar{namespace}.doesValkyrieSkillContainerContain(_container, _skill);
		}
	}

	return false;
};

::$bvvar{namespace}.dirtyValkyrieSkillActor <- function( _actor )
{
	try
	{
		_actor.setDirty(true);
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.syncActorSkills <- function( _actor, _reason )
{
	local result = ::$bvvar{namespace}.makeValkyrieSkillSyncResult(_reason);
	local container = ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor);
	if (container == null || ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor) == null)
	{
		result.Code = "invalid_actor";
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, null, result.Code, "sync.validate");
		return result;
	}

	local entitlements = {};
	foreach( key, definition in ::$bvvar{namespace}.ValkyrieSkillCatalog )
	{
		if (definition.Lifetime == "persistent" && ::$bvvar{namespace}.hasSkillEntitlement(_actor, key))
		{
			entitlements[key] <- true;
		}
	}

	local existingByKey = {};
	local removeCandidates = [];
	foreach( skill in ::$bvvar{namespace}.getValkyrieSkillContainerState(container) )
	{
		if (!::$bvvar{namespace}.isBattleValkyriesManagedRuntimeSkill(skill))
		{
			continue;
		}

		local key = null;
		try
		{
			if (skill.getBattleValkyriesSkillLifetime() != "persistent")
			{
				continue;
			}

			key = skill.getBattleValkyriesSkillKey();
		}
		catch (e)
		{
			removeCandidates.push({ Skill = skill, Key = key });
			continue;
		}

		local isEntitled = typeof key == "string" && key in entitlements;
		local isValid = isEntitled && ::$bvvar{namespace}.isValkyrieRuntimeSkillValidForKey(skill, key, "persistent");
		if (isValid && !(key in existingByKey))
		{
			existingByKey[key] <- skill;
			result.Kept = result.Kept + 1;
		}
		else
		{
			removeCandidates.push({ Skill = skill, Key = key });
		}
	}

	local prepared = {};
	foreach( key, entitled in entitlements )
	{
		if (key in existingByKey)
		{
			continue;
		}

		local creation = ::$bvvar{namespace}.createValkyrieRuntimeSkill(_actor, key);
		if (!creation.Success)
		{
			result.Code = "runtime_create_failed";
			result.FailedKey = key;
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, key, creation.Code, "sync.precreate");
			return result;
		}

		prepared[key] <- creation.RuntimeSkill;
	}

	foreach( candidate in removeCandidates )
	{
		try
		{
			if (!::$bvvar{namespace}.removeValkyrieSkillFromContainerState(container, candidate.Skill))
			{
				throw "persistent runtime removal did not detach the object";
			}
			result.Removed = result.Removed + 1;
		}
		catch (e)
		{
			result.Code = "sync_failed";
			result.FailedKey = candidate.Key;
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, candidate.Key, e, "sync.remove");
			if (result.Removed > 0)
			{
				::$bvvar{namespace}.dirtyValkyrieSkillActor(_actor);
			}
			return result;
		}
	}

	local addedThisCall = [];
	foreach( key, runtimeSkill in prepared )
	{
		local addFailure = null;
		try
		{
			container.add(runtimeSkill);
			if (!::$bvvar{namespace}.doesValkyrieSkillContainerContain(container, runtimeSkill))
			{
				throw "persistent runtime add did not retain the prepared object";
			}
			addedThisCall.push(runtimeSkill);
		}
		catch (e)
		{
			addFailure = e;
			if (::$bvvar{namespace}.doesValkyrieSkillContainerContain(container, runtimeSkill) && !::$bvvar{namespace}.doesValkyrieSkillArrayContain(addedThisCall, runtimeSkill))
			{
				addedThisCall.push(runtimeSkill);
			}
		}

		if (addFailure != null)
		{
			foreach( addedSkill in addedThisCall )
			{
				try
				{
					if (!::$bvvar{namespace}.removeValkyrieSkillFromContainerState(container, addedSkill))
					{
						throw "added runtime rollback did not detach the object";
					}
				}
				catch (rollbackError)
				{
					::$bvvar{namespace}.logValkyrieSkillFailure(_actor, addedSkill.getBattleValkyriesSkillKey(), rollbackError, "sync.add_rollback");
				}
			}

			result.Code = "runtime_add_failed";
			result.FailedKey = key;
			result.Added = 0;
			foreach( addedSkill in addedThisCall )
			{
				if (::$bvvar{namespace}.doesValkyrieSkillContainerContain(container, addedSkill))
				{
					result.Added = result.Added + 1;
				}
			}
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, key, addFailure, "sync.add");
			if (result.Removed > 0 || result.Added > 0)
			{
				::$bvvar{namespace}.dirtyValkyrieSkillActor(_actor);
			}
			return result;
		}
	}

	result.Added = addedThisCall.len();
	result.Success = true;
	result.Code = "success";
	if (result.Added > 0 || result.Removed > 0)
	{
		::$bvvar{namespace}.dirtyValkyrieSkillActor(_actor);
	}
	return result;
};

::$bvvar{namespace}.learnSkill <- function( _actor, _key, _source )
{
	local result = ::$bvvar{namespace}.canLearnSkill(_actor, _key, _source);
	if (!result.Success)
	{
		return result;
	}

	local preflight = ::$bvvar{namespace}.createValkyrieRuntimeSkill(_actor, _key);
	if (!preflight.Success)
	{
		result.Success = false;
		result.Code = "runtime_create_failed";
		return result;
	}

	local flags = ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor);
	local flag = ::$bvvar{namespace}.getValkyrieLearnedSkillFlag(_key);
	try
	{
		flags.set(flag, 1);
	}
	catch (e)
	{
		result.Success = false;
		result.Code = "sync_failed";
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, e, "learn.flag_write");
		return result;
	}

	local sourceText = _source == null ? "unknown" : _source.tostring();
	local sync = ::$bvvar{namespace}.syncActorSkills(_actor, "learn:" + sourceText);
	if (!sync.Success)
	{
		try
		{
			flags.remove(flag);
		}
		catch (rollbackError)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, rollbackError, "learn.flag_rollback");
		}

		result.Success = false;
		result.Code = "sync_failed";
		result.Added = sync.Added;
		result.Kept = sync.Kept;
		result.Removed = sync.Removed;
		return result;
	}

	result.Code = "success";
	result.Added = sync.Added;
	result.Kept = sync.Kept;
	result.Removed = sync.Removed;
	return result;
};

::$bvvar{namespace}.forgetLearnedSkill <- function( _actor, _key )
{
	local result = ::$bvvar{namespace}.makeValkyrieSkillResult(_key, false, "invalid_actor");
	if (!::$bvvar{namespace}.isValidValkyrieSkillActor(_actor))
	{
		return result;
	}

	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	if (definition == null)
	{
		result.Code = "unknown_skill";
		return result;
	}

	if (definition.Lifetime != "persistent")
	{
		result.Code = "not_persistent";
		return result;
	}

	local flags = ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor);
	local flag = ::$bvvar{namespace}.getValkyrieLearnedSkillFlag(_key);
	if (!flags.has(flag))
	{
		result.Success = true;
		result.Code = "success";
		return result;
	}

	local previousValue = flags.get(flag);
	try
	{
		flags.remove(flag);
	}
	catch (e)
	{
		result.Code = "sync_failed";
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, e, "forget.flag_remove");
		return result;
	}

	local sync = ::$bvvar{namespace}.syncActorSkills(_actor, "forget");
	if (!sync.Success)
	{
		try
		{
			flags.set(flag, previousValue);
		}
		catch (rollbackError)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, rollbackError, "forget.flag_rollback");
		}

		result.Code = "sync_failed";
		result.Added = sync.Added;
		result.Kept = sync.Kept;
		result.Removed = sync.Removed;
		return result;
	}

	result.Success = true;
	result.Code = "success";
	result.Added = sync.Added;
	result.Kept = sync.Kept;
	result.Removed = sync.Removed;
	return result;
};

::$bvvar{namespace}.attachTransientSkill <- function( _actor, _key, _ownerToken )
{
	local result = ::$bvvar{namespace}.makeValkyrieSkillResult(_key, false, "invalid_actor");
	local container = ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor);
	if (container == null || ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor) == null)
	{
		return result;
	}

	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	if (definition == null)
	{
		result.Code = "unknown_skill";
		return result;
	}

	if (definition.Lifetime != "transient")
	{
		result.Code = "not_transient";
		return result;
	}

	if (typeof _ownerToken != "string" || _ownerToken.len() == 0)
	{
		result.Code = "invalid_owner";
		return result;
	}

	local runtimeSkill = ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, _key);
	if (runtimeSkill != null)
	{
		if (runtimeSkill.hasTransientOwner(_ownerToken))
		{
			result.Success = true;
			result.Code = "already_attached";
			result.Kept = 1;
			return result;
		}

		if (!runtimeSkill.addTransientOwner(_ownerToken))
		{
			result.Code = "sync_failed";
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, result.Code, "transient.owner_add");
			return result;
		}

		result.Success = true;
		result.Code = "success";
		result.Kept = 1;
		return result;
	}

	local creation = ::$bvvar{namespace}.createValkyrieRuntimeSkill(_actor, _key);
	if (!creation.Success)
	{
		result.Code = "runtime_create_failed";
		return result;
	}

	runtimeSkill = creation.RuntimeSkill;
	local addFailure = null;
	try
	{
		container.add(runtimeSkill);
		if (!::$bvvar{namespace}.doesValkyrieSkillContainerContain(container, runtimeSkill))
		{
			throw "transient runtime add did not retain the prepared object";
		}
	}
	catch (e)
	{
		addFailure = e;
	}

	if (addFailure != null)
	{
		if (::$bvvar{namespace}.doesValkyrieSkillContainerContain(container, runtimeSkill))
		{
			try
			{
				if (!::$bvvar{namespace}.removeValkyrieSkillFromContainerState(container, runtimeSkill))
				{
					throw "transient add rollback did not detach the object";
				}
			}
			catch (rollbackError)
			{
				::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, rollbackError, "transient.add_rollback");
			}
		}

		result.Code = "runtime_add_failed";
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, addFailure, "transient.add");
		return result;
	}

	if (!runtimeSkill.addTransientOwner(_ownerToken))
	{
		try
		{
			if (!::$bvvar{namespace}.removeValkyrieSkillFromContainerState(container, runtimeSkill))
			{
				throw "transient owner rollback did not detach the object";
			}
		}
		catch (rollbackError)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, rollbackError, "transient.owner_rollback");
		}
		result.Code = "runtime_add_failed";
		return result;
	}

	result.Success = true;
	result.Code = "success";
	result.Added = 1;
	::$bvvar{namespace}.dirtyValkyrieSkillActor(_actor);
	return result;
};

::$bvvar{namespace}.detachTransientSkill <- function( _actor, _key, _ownerToken )
{
	local result = ::$bvvar{namespace}.makeValkyrieSkillResult(_key, false, "invalid_actor");
	local container = ::$bvvar{namespace}.getValkyrieSkillActorContainer(_actor);
	if (container == null || ::$bvvar{namespace}.getValkyrieSkillActorFlags(_actor) == null)
	{
		return result;
	}

	local definition = ::$bvvar{namespace}.getSkillDefinition(_key);
	if (definition == null)
	{
		result.Code = "unknown_skill";
		return result;
	}

	if (definition.Lifetime != "transient")
	{
		result.Code = "not_transient";
		return result;
	}

	if (typeof _ownerToken != "string" || _ownerToken.len() == 0)
	{
		result.Code = "invalid_owner";
		return result;
	}

	local runtimeSkill = ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, _key);
	if (runtimeSkill == null || !runtimeSkill.hasTransientOwner(_ownerToken))
	{
		result.Code = "owner_not_found";
		return result;
	}

	runtimeSkill.removeTransientOwner(_ownerToken);
	if (runtimeSkill.getTransientOwnerCount() > 0)
	{
		result.Success = true;
		result.Code = "success";
		result.Kept = 1;
		return result;
	}

	local removeFailure = null;
	try
	{
		if (!::$bvvar{namespace}.removeValkyrieSkillFromContainerState(container, runtimeSkill))
		{
			throw "transient runtime removal did not detach the object";
		}
	}
	catch (e)
	{
		removeFailure = e;
	}

	if (removeFailure != null)
	{
		runtimeSkill.addTransientOwner(_ownerToken);
		result.Code = "sync_failed";
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, _key, removeFailure, "transient.remove");
		return result;
	}

	result.Success = true;
	result.Code = "success";
	result.Removed = 1;
	::$bvvar{namespace}.dirtyValkyrieSkillActor(_actor);
	return result;
};

::$bvvar{namespace}.repairAllActorSkills <- function( _reason )
{
	local result = {
		Success = true,
		Code = "success",
		Reason = _reason,
		Actors = 0,
		Failed = 0,
		Added = 0,
		Kept = 0,
		Removed = 0
	};

	local roster = null;
	try
	{
		roster = ::World.getPlayerRoster().getAll();
	}
	catch (e)
	{
		result.Success = false;
		result.Code = "sync_failed";
		::$bvvar{namespace}.logValkyrieSkillFailure(null, null, e, "repair.roster");
		return result;
	}

	foreach( actor in roster )
	{
		result.Actors = result.Actors + 1;
		local sync = ::$bvvar{namespace}.syncActorSkills(actor, _reason);
		result.Added = result.Added + sync.Added;
		result.Kept = result.Kept + sync.Kept;
		result.Removed = result.Removed + sync.Removed;
		if (!sync.Success)
		{
			result.Success = false;
			result.Code = "sync_failed";
			result.Failed = result.Failed + 1;
		}
	}

	return result;
};
