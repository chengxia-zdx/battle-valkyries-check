::$bvvar{namespace}.getSkillDefinition <- function( _key )
{
	if (typeof _key != "string" || !(_key in ::$bvvar{namespace}.ValkyrieSkillCatalog))
	{
		return null;
	}

	return ::$bvvar{namespace}.ValkyrieSkillCatalog[_key];
};

::$bvvar{namespace}.getValkyrieSkillIconPath <- function( _definition, _disabled = false )
{
	if (_definition == null) return "";
	if (_disabled && "IconDisabled" in _definition && typeof _definition.IconDisabled == "string") return _definition.IconDisabled;
	if (!_disabled && "Icon" in _definition && typeof _definition.Icon == "string" && _definition.Icon.find("/") != null) return _definition.Icon;
	if (!("Icon" in _definition) || typeof _definition.Icon != "string") return "";
	return "skills/$bvvar{iconPrefix}/" + _definition.Icon + (_disabled ? "_sw.png" : ".png");
};

::$bvvar{namespace}.getValkyrieSkillRuntimeID <- function( _key )
{
	if (::$bvvar{namespace}.getSkillDefinition(_key) == null)
	{
		return null;
	}

	return "$bvvar{modId}.skill." + _key;
};

::$bvvar{namespace}.getValkyrieLearnedSkillFlag <- function( _key )
{
	if (::$bvvar{namespace}.getSkillDefinition(_key) == null)
	{
		return null;
	}

	return "$bvvar{modId}.skill.learned." + _key;
};

::$bvvar{namespace}.failValkyrieSkillCatalogValidation <- function( _key, _reason )
{
	local keyText = _key == null ? "null" : _key.tostring();
	local message = "[Battle Valkyries] [SkillSystem] catalog key=" + keyText + " error=" + _reason;
	::logError(message);
	throw message;
};

::$bvvar{namespace}.validateValkyrieSkillCatalog <- function()
{
	local runtimeIDs = {};
	local allowedRequirementKeys = {
		MinLevel = true,
		RequiredSkills = true,
		ForbiddenSkills = true
	};

	foreach( key, definition in ::$bvvar{namespace}.ValkyrieSkillCatalog )
	{
		if (typeof key != "string" || key.len() == 0)
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "key must be a non-empty string");
		}

		if (typeof definition != "table")
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "definition must be a table");
		}

		foreach( fieldName in ["RuntimeScript", "Name", "Description", "Icon"] )
		{
			if (!(fieldName in definition) || typeof definition[fieldName] != "string")
			{
				::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, fieldName + " must be a string");
			}
		}

		if (!("Kind" in definition) || typeof definition.Kind != "string" || (definition.Kind != "active" && definition.Kind != "passive"))
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "Kind must be active or passive");
		}

		if (!("Lifetime" in definition) || typeof definition.Lifetime != "string" || (definition.Lifetime != "persistent" && definition.Lifetime != "transient"))
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "Lifetime must be persistent or transient");
		}

		if (!("Learnable" in definition) || typeof definition.Learnable != "bool")
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "Learnable must be a bool");
		}

		if (!("Tags" in definition) || typeof definition.Tags != "array")
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "Tags must be an array");
		}

		if (!("Requirements" in definition) || typeof definition.Requirements != "table")
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "Requirements must be a table");
		}

		foreach( requirementKey, requirementValue in definition.Requirements )
		{
			if (!(requirementKey in allowedRequirementKeys))
			{
				local requirementKeyText = requirementKey == null ? "null" : requirementKey.tostring();
				::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "unknown requirement key " + requirementKeyText);
			}
		}

		if (!("MinLevel" in definition.Requirements) || typeof definition.Requirements.MinLevel != "integer" || definition.Requirements.MinLevel < 1)
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "MinLevel must be an integer of at least 1");
		}

		foreach( fieldName in ["RequiredSkills", "ForbiddenSkills"] )
		{
			if (!(fieldName in definition.Requirements) || typeof definition.Requirements[fieldName] != "array")
			{
				::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, fieldName + " must be an array");
			}

			foreach( requiredKey in definition.Requirements[fieldName] )
			{
				if (typeof requiredKey != "string" || !(requiredKey in ::$bvvar{namespace}.ValkyrieSkillCatalog))
				{
					local requiredKeyText = requiredKey == null ? "null" : requiredKey.tostring();
					::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, fieldName + " contains unknown catalog key " + requiredKeyText);
				}
			}
		}

		if (!("Spec" in definition) || typeof definition.Spec != "table")
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "Spec must be a table");
		}

		if (definition.Lifetime == "transient" && definition.Learnable)
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "transient skills cannot be learnable");
		}

		local runtimeID = ::$bvvar{namespace}.getValkyrieSkillRuntimeID(key);
		if (runtimeID in runtimeIDs)
		{
			::$bvvar{namespace}.failValkyrieSkillCatalogValidation(key, "duplicate runtime ID " + runtimeID);
		}

		runtimeIDs[runtimeID] <- key;
	}

	return true;
};

::$bvvar{namespace}.failValkyrieSkillLoadoutValidation <- function( _valkyrieID, _reason )
{
	local idText = _valkyrieID == null ? "null" : _valkyrieID.tostring();
	local message = "[Battle Valkyries] [SkillSystem] loadout valkyrie=" + idText + " error=" + _reason;
	::logError(message);
	throw message;
};

::$bvvar{namespace}.validateValkyrieSkillLoadouts <- function()
{
	foreach( valkyrieID in ::$bvvar{namespace}.ValkyrieOrder )
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
		if (template == null)
		{
			::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "template is missing");
		}

		if (!("SkillLoadout" in template) || typeof template.SkillLoadout != "array")
		{
			::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "SkillLoadout must be an array");
		}

		local seen = {};
		foreach( key in template.SkillLoadout )
		{
			if (typeof key != "string" || key.len() == 0)
			{
				::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "SkillLoadout contains an invalid key");
			}

			if (key in seen)
			{
				::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "SkillLoadout contains duplicate key " + key);
			}

			seen[key] <- true;
			local definition = ::$bvvar{namespace}.getSkillDefinition(key);
			if (definition == null)
			{
				::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "SkillLoadout contains unknown key " + key);
			}

			if (definition.Lifetime != "persistent")
			{
				::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "SkillLoadout contains nonpersistent key " + key);
			}
		}

		if ("AdditionalTraitScripts" in template)
		{
			if (typeof template.AdditionalTraitScripts != "array")
			{
				::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "AdditionalTraitScripts must be an array");
			}

			foreach( script in template.AdditionalTraitScripts )
			{
				if (typeof script != "string" || script.len() == 0)
				{
					::$bvvar{namespace}.failValkyrieSkillLoadoutValidation(valkyrieID, "AdditionalTraitScripts contains an invalid script");
				}
			}
		}
	}

	return true;
};
