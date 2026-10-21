::$bvvar{namespace}.MH.hook("scripts/scenarios/scenario_manager", function(q) {
	q.create = @(__original) function()
	{
		__original();

		if (this.getScenario("$bvvar{scenarioId}") != null)
		{
			return;
		}

		local scenario = this.new("scripts/scenarios/world/$bvvar{scenarioScript}");

		if (scenario.isValid())
		{
			this.m.Scenarios.push(scenario);
			this.m.Scenarios.sort(this.onOrderCompare);
		}
	}
});

::$bvvar{namespace}.TestOriginXilianSkillKey <- "xilian_test_annihilation";
::$bvvar{namespace}.TestOriginXilianSkillOwnerToken <- "$bvvar{modId}.test_origin.xilian_test_annihilation";

::$bvvar{namespace}.isBattleValkyriesTestOrigin <- function()
{
	if (!("World" in getroottable()) || ::World == null || ::World.Assets == null)
	{
		return false;
	}

	try
	{
		local origin = ::World.Assets.getOrigin();
		return origin != null && origin.getID() == "$bvvar{scenarioId}";
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.syncXilianTestOriginSkillByKey <- function( _actor, _key, _ownerToken, _reason )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return false;
	}

	local key = _key;
	local ownerToken = _ownerToken;
	local shouldAttach = ::$bvvar{namespace}.isBattleValkyriesTestOrigin()
		&& ::$bvvar{namespace}.getActorValkyrieID(_actor) == "xilian";
	local runtimeSkill = ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, key);

	if (shouldAttach)
	{
		local attachResult = ::$bvvar{namespace}.attachTransientSkill(_actor, key, ownerToken);

		if (!attachResult.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(_actor, key, attachResult.Code, "test_origin.attach." + _reason);
			return false;
		}

		return true;
	}

	if (runtimeSkill == null || !runtimeSkill.hasTransientOwner(ownerToken))
	{
		return true;
	}

	local detachResult = ::$bvvar{namespace}.detachTransientSkill(_actor, key, ownerToken);

	if (!detachResult.Success && detachResult.Code != "owner_not_found")
	{
		::$bvvar{namespace}.logValkyrieSkillFailure(_actor, key, detachResult.Code, "test_origin.detach." + _reason);
		return false;
	}

	return true;
};

::$bvvar{namespace}.syncXilianTestOriginSkill <- function( _actor, _reason = "unknown" )
{
	local api = ::$bvvar{namespace};
	local annihilation = api.syncXilianTestOriginSkillByKey(_actor, api.TestOriginXilianSkillKey, api.TestOriginXilianSkillOwnerToken, _reason);
	local vision = api.syncXilianTestOriginSkillByKey(_actor, "xilian_test_full_vision", "$bvvar{modId}.test_origin.xilian_test_full_vision", _reason);
	return annihilation && vision;
};

local originalSyncActorSkillsForTestOrigin = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function( _actor, _reason = "unknown" )
{
	local result = originalSyncActorSkillsForTestOrigin(_actor, _reason);

	if (result != null && result.Success)
	{
		::$bvvar{namespace}.syncXilianTestOriginSkill(_actor, _reason);
	}

	return result;
};
