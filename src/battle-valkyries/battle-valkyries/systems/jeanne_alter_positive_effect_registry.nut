// Explicit allow-list for effects that Jeanne Alter may dispel or lock out.
// Never infer positivity from an ID, a type, or a display name: unrelated mods
// can use any of those values for stateful mechanics.

::$bvvar{namespace}.JeanneAlterPositiveEffectRegistry <- { IDs = {
	["effects.adrenaline"] = true,
	["effects.killing_frenzy"] = true
} };

::$bvvar{namespace}.registerJeanneAlterPositiveEffectID <- function( _id )
{
	if (typeof _id != "string" || _id.len() == 0) return false;
	::$bvvar{namespace}.JeanneAlterPositiveEffectRegistry.IDs[_id] <- true;
	return true;
};

::$bvvar{namespace}.isJeanneAlterRegisteredPositiveEffectID <- function( _id )
{
	return typeof _id == "string" && _id in ::$bvvar{namespace}.JeanneAlterPositiveEffectRegistry.IDs;
};

::$bvvar{namespace}.getJeanneAlterBuffBlock <- function( _target )
{
	if (_target == null) return null;
	try { return _target.getSkills().getSkillByID("$bvvar{modId}.effects.jeanne_alter_buff_block"); }
	catch (e) { return null; }
};

::$bvvar{namespace}.canReceiveJeanneAlterRegisteredPositiveEffect <- function( _target, _id )
{
	return ::$bvvar{namespace}.isJeanneAlterRegisteredPositiveEffectID(_id)
		&& ::$bvvar{namespace}.getJeanneAlterBuffBlock(_target) == null;
};

::$bvvar{namespace}.getJeanneAlterPositiveEffectID <- function( _effect )
{
	if (_effect == null) return null;
	try { return _effect.getID(); } catch (e) {}
	try { return _effect.m.ID; } catch (e) {}
	return null;
};

::$bvvar{namespace}.shouldBlockJeanneAlterPositiveEffect <- function( _target, _effect )
{
	return ::$bvvar{namespace}.getJeanneAlterBuffBlock(_target) != null
		&& ::$bvvar{namespace}.isJeanneAlterRegisteredPositiveEffectID(::$bvvar{namespace}.getJeanneAlterPositiveEffectID(_effect));
};

::$bvvar{namespace}.removeJeanneAlterPositiveEffects <- function( _target )
{
	if (_target == null) return 0;
	local container = null;
	try { container = _target.getSkills(); }
	catch (e) { return 0; }
	if (container == null || !("m" in container) || !("Skills" in container.m)) return 0;

	local snapshot = [];
	foreach (skill in container.m.Skills) snapshot.push(skill);
	local removed = 0;
	foreach (skill in snapshot)
	{
		local id = null;
		try { id = skill.m.ID; } catch (e) { id = null; }
		if (!::$bvvar{namespace}.isJeanneAlterRegisteredPositiveEffectID(id)) continue;
		try { skill.removeSelf(); removed++; }
		catch (e)
		{
			try { container.remove(skill); removed++; } catch (ignored) {}
		}
	}
	return removed;
};
