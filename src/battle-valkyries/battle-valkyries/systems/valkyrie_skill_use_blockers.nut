::$bvvar{namespace}.isValkyrieSkillUseBlocked <- function( _skill )
{
	if (_skill == null)
	{
		return false;
	}

	local actor = null;
	local skills = null;
	try
	{
		actor = _skill.getContainer().getActor();
		skills = actor == null ? null : actor.getSkills();
	}
	catch (e)
	{
		return false;
	}

	if (skills == null || !("m" in skills) || !("Skills" in skills.m))
	{
		return false;
	}

	foreach (provider in skills.m.Skills)
	{
		if (provider == null || provider == _skill || !("blocksValkyrieSkillUse" in provider))
		{
			continue;
		}

		try
		{
			if (provider.blocksValkyrieSkillUse(_skill))
			{
				return true;
			}
		}
		catch (e)
		{
			local key = null;
			try { key = _skill.getBattleValkyriesSkillKey(); } catch (ignored) {}
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, key, e, "skill_use_blocker");
		}
	}

	return false;
};
