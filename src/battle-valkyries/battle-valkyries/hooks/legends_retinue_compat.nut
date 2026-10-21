// Legends accepts its special melee/ranged companion backgrounds as valid
// personnel for every standard retinue fixture. Valkyries are another
// identity-driven companion type, so let them use the same compatibility path
// without injecting fake backgrounds or camp perks into their skill containers.
::$bvvar{namespace}.isLegendsCompanionRetinueRequirement <- function( _requiredSkills )
{
	if (_requiredSkills == null || typeof _requiredSkills != "array")
	{
		return false;
	}

	return _requiredSkills.find("background.legend_companion_melee") != null
		|| _requiredSkills.find("background.legend_companion_ranged") != null;
};

::$bvvar{namespace}.isLivingRegisteredValkyrie <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	try
	{
		if (!_actor.isAlive())
		{
			return false;
		}
	}
	catch (e)
	{
		return false;
	}

	local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);
	return valkyrieID != null
		&& valkyrieID != ""
		&& ::$bvvar{namespace}.getValkyrieByID(valkyrieID) != null;
};

::$bvvar{namespace}.findLivingValkyrieRetinueSponsor <- function( _follower )
{
	local roster = null;

	try
	{
		roster = _follower.World.getPlayerRoster().getAll();
	}
	catch (e)
	{
		return null;
	}

	foreach( bro in roster )
	{
		if (::$bvvar{namespace}.isLivingRegisteredValkyrie(bro))
		{
			return bro;
		}
	}

	return null;
};

// Legends adds these methods through its legacy base-class hook while scripts
// are being inherited. A Modern Hooks class hook runs before that legacy hook
// and therefore cannot wrap the methods yet. Register through the same legacy
// layer, after mod_legends, so the methods exist when this callback executes.
// Keep both guards so vanilla and future Legends variants without this API stay
// load-safe.
if ("Legends" in getroottable()
	&& "mods_hookBaseClass" in getroottable()
	&& typeof ::mods_hookBaseClass == "function")
{
	::mods_hookBaseClass("retinue/follower", function(q) {
		if (!("addSkillRequirement" in q)
			|| typeof q.addSkillRequirement != "function"
			|| !("checkRequiredSkills" in q)
			|| typeof q.checkRequiredSkills != "function")
		{
			return;
		}

		local originalAddSkillRequirement = q.addSkillRequirement;
		q.addSkillRequirement = function( _text, _requiredSkills, _isNotImportant = false, _afterAddRequirementFunction = null )
		{
			if (::$bvvar{namespace}.isLegendsCompanionRetinueRequirement(_requiredSkills))
			{
				_text += "$bv{compat.legends_retinue.valkyrie_requirement}";
			}

			return originalAddSkillRequirement.call(this, _text, _requiredSkills, _isNotImportant, _afterAddRequirementFunction);
		}

		local originalCheckRequiredSkills = q.checkRequiredSkills;
		q.checkRequiredSkills = function()
		{
			// Legends stores the previously linked brother. Clear it so every
			// evaluation is authoritative for the current roster, including after
			// a Valkyrie dies or leaves the company.
			this.m.LinkedBro = null;

			if (originalCheckRequiredSkills.call(this))
			{
				return true;
			}

			// Only followers that explicitly accept Legends companion backgrounds
			// opt into this bridge. Third-party specialist requirements stay intact.
			if (!::$bvvar{namespace}.isLegendsCompanionRetinueRequirement(this.m.RequiredSkills))
			{
				return false;
			}

			local sponsor = ::$bvvar{namespace}.findLivingValkyrieRetinueSponsor(this);
			if (sponsor == null)
			{
				return false;
			}

			this.m.LinkedBro = sponsor;
			return true;
		}
	});
}
