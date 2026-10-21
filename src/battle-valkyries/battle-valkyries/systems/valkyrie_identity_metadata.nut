::$bvvar{namespace}.DefaultValkyrieGender <- 1;
::$bvvar{namespace}.DefaultValkyrieLegendsBackgroundTypes <- ["Combat", "Female"];

// Only normalize the built-in templates which are present during the core load.
// Valkyrie Pack schema/defaults are deliberately outside this compatibility pass.
::$bvvar{namespace}.initializeBuiltinValkyrieIdentityMetadata <- function()
{
	foreach( valkyrieID in ::$bvvar{namespace}.ValkyrieOrder )
	{
		if (!(valkyrieID in ::$bvvar{namespace}.Valkyries))
		{
			continue;
		}

		local template = ::$bvvar{namespace}.Valkyries[valkyrieID];

		if (!("Gender" in template))
		{
			template.Gender <- ::$bvvar{namespace}.DefaultValkyrieGender;
		}

		if (!("LegendsBackgroundTypes" in template))
		{
			template.LegendsBackgroundTypes <- clone ::$bvvar{namespace}.DefaultValkyrieLegendsBackgroundTypes;
		}
	}
};

::$bvvar{namespace}.getValkyrieIdentityTemplate <- function( _actor, _template = null )
{
	if (_template != null)
	{
		return _template;
	}

	if (_actor == null)
	{
		return null;
	}

	local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);
	return valkyrieID == null || valkyrieID == "" ? null : ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
};

::$bvvar{namespace}.applyValkyrieGender <- function( _actor, _template = null )
{
	local template = ::$bvvar{namespace}.getValkyrieIdentityTemplate(_actor, _template);

	if (_actor == null || template == null || !("Gender" in template) || typeof template.Gender != "integer")
	{
		return false;
	}

	local gender = template.Gender;
	_actor.m.VoiceSet = 0;

	// Legends' setter refreshes its gender-specific body and sound tables. Its
	// Gender Equality setting may reject a forced female value, so restore the
	// canonical template value directly afterwards for identity/pronoun checks.
	try
	{
		_actor.setGender(gender, false);
	}
	catch (e)
	{
	}

	try
	{
		_actor.m.Gender = gender;
		return _actor.m.Gender == gender;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.applyValkyrieLegendsBackgroundTypes <- function( _actor, _template = null, _background = null )
{
	local template = ::$bvvar{namespace}.getValkyrieIdentityTemplate(_actor, _template);

	if (template == null || !("LegendsBackgroundTypes" in template) || typeof template.LegendsBackgroundTypes != "array")
	{
		return 0;
	}

	if (!("BackgroundType" in ::Const))
	{
		return 0;
	}

	local background = _background;

	if (background == null && _actor != null)
	{
		try
		{
			background = _actor.getBackground();
		}
		catch (e)
		{
			background = null;
		}
	}

	if (background == null)
	{
		return 0;
	}

	local applied = 0;

	foreach( typeName in template.LegendsBackgroundTypes )
	{
		if (typeof typeName != "string" || !(typeName in ::Const.BackgroundType))
		{
			continue;
		}

		try
		{
			background.addBackgroundType(::Const.BackgroundType[typeName]);
			applied++;
		}
		catch (e)
		{
			// Vanilla and non-Legends backgrounds do not expose this method.
			return 0;
		}
	}

	return applied;
};

::$bvvar{namespace}.applyValkyrieIdentityMetadata <- function( _actor, _template = null, _background = null )
{
	local template = ::$bvvar{namespace}.getValkyrieIdentityTemplate(_actor, _template);

	if (_actor == null || template == null)
	{
		return false;
	}

	local genderApplied = ::$bvvar{namespace}.applyValkyrieGender(_actor, template);
	::$bvvar{namespace}.applyValkyrieLegendsBackgroundTypes(_actor, template, _background);
	return genderApplied;
};

::$bvvar{namespace}.initializeBuiltinValkyrieIdentityMetadata();
