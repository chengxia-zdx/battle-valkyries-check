::$bvvar{namespace}.normalizeValkyriePackSkills <- function( _packID, _skills )
{
	if (typeof _skills != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, "Skills", "must be a table");
	local ret = {};
	foreach( key, definition in _skills )
	{
		local path = "Skills." + key;
		::$bvvar{namespace}.requireValkyriePackQualifiedID(_packID, key, path);
		if (typeof definition != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path, "must be a table");
		foreach( field in ["RuntimeScript", "Name", "Description", "Icon", "IconDisabled"] )
			::$bvvar{namespace}.requireValkyriePackString(definition, field, _packID, path + "." + field);
		foreach( field in ["Tags"] )
			::$bvvar{namespace}.requireValkyriePackArray(definition, field, _packID, path + "." + field);
		foreach( field in ["Requirements", "Spec"] )
			::$bvvar{namespace}.requireValkyriePackTable(definition, field, _packID, path + "." + field);
		local kind = ::$bvvar{namespace}.requireValkyriePackString(definition, "Kind", _packID, path + ".Kind");
		local lifetime = ::$bvvar{namespace}.requireValkyriePackString(definition, "Lifetime", _packID, path + ".Lifetime");
		if (kind != "active" && kind != "passive") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Kind", "must be active or passive");
		if (lifetime != "persistent" && lifetime != "transient") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Lifetime", "must be persistent or transient");
		if (!("Learnable" in definition) || typeof definition.Learnable != "bool") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Learnable", "must be a bool");
		if (lifetime == "transient" && definition.Learnable) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Learnable", "transient skills cannot be learnable");
		foreach( field in ["MinLevel", "RequiredSkills", "ForbiddenSkills"] )
			if (!(field in definition.Requirements)) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Requirements." + field, "field is required");
		local allowedRequirementFields = { MinLevel = true, RequiredSkills = true, ForbiddenSkills = true };
		foreach( requirementField, requirementValue in definition.Requirements )
		{
			if (requirementField in allowedRequirementFields) continue;
			local requirementFieldText = requirementField == null ? "null" : requirementField.tostring();
			::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Requirements." + requirementFieldText, "field is not allowed");
		}
		if (typeof definition.Requirements.MinLevel != "integer" || definition.Requirements.MinLevel < 1)
			::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Requirements.MinLevel", "must be an integer of at least 1");
		foreach( field in ["RequiredSkills", "ForbiddenSkills"] )
		{
			if (typeof definition.Requirements[field] != "array") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Requirements." + field, "must be an array");
			local seenReferences = {};
			foreach( reference in definition.Requirements[field] )
			{
				if (typeof reference != "string" || reference.len() == 0) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Requirements." + field, "entries must be a non-empty string");
				if (reference in seenReferences) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Requirements." + field, "must not contain duplicate skill " + reference);
				seenReferences[reference] <- true;
			}
		}
		ret[key] <- ::$bvvar{namespace}.deepCopyValkyriePackValue(definition);
	}
	foreach( key, definition in ret )
		foreach( field in ["RequiredSkills", "ForbiddenSkills"] )
			foreach( reference in definition.Requirements[field] )
				if (!(reference in ret) && !(reference in ::$bvvar{namespace}.ValkyrieSkillCatalog))
					::$bvvar{namespace}.failValkyriePackRegistration(_packID, "Skills." + key + ".Requirements." + field, "unknown skill " + reference);
	return ret;
};

::$bvvar{namespace}.normalizeValkyriePackSkins <- function( _packID, _skins )
{
	if (typeof _skins != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, "Skins", "must be a table");
	local ret = {};
	foreach( key, skin in _skins )
	{
		local path = "Skins." + key;
		::$bvvar{namespace}.requireValkyriePackQualifiedID(_packID, key, path);
		if (typeof skin != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path, "must be a table");
		foreach( field in ["ID", "Name", "Brush", "DeathBrush"] )
			::$bvvar{namespace}.requireValkyriePackString(skin, field, _packID, path + "." + field);
		foreach( field in ["TabName", "Description", "Portrait", "Preview", "TraitIcon", "TraitDescription", "ItemIcon", "ItemName"] )
			if (field in skin) ::$bvvar{namespace}.requireValkyriePackString(skin, field, _packID, path + "." + field);
		if (skin.ID != key) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".ID", "must equal table key");
		if (skin.Brush.find(_packID) == null || skin.DeathBrush.find(_packID) == null)
			::$bvvar{namespace}.failValkyriePackRegistration(_packID, path, "Brush IDs must contain Pack ID");
		local normalized = {
			ID = skin.ID,
			Name = skin.Name,
			Brush = skin.Brush,
			DeathBrush = skin.DeathBrush
		};
		foreach( field in ["TabName", "Description", "Portrait", "Preview", "TraitIcon", "TraitDescription", "ItemIcon", "ItemName"] )
			if (field in skin) normalized[field] <- skin[field];
		ret[key] <- normalized;
	}
	return ret;
};

::$bvvar{namespace}.normalizeValkyriePackValkyries <- function( _packID, _valkyries, _skills, _skins )
{
	if (typeof _valkyries != "array" || _valkyries.len() == 0)
		::$bvvar{namespace}.failValkyriePackRegistration(_packID, "Valkyries", "must be a non-empty array");
	local ret = [];
	local seen = {};
	local stringFields = ["ID", "SkinID", "Name", "Portrait", "SkinPreview", "BackgroundScript", "BackgroundID", "BackgroundName", "BackgroundDescription", "TraitScript", "TraitID", "TraitName", "TraitDescription", "TraitIcon", "SkinItemIcon"];
	local tableFields = ["BaseAttributes", "AttributeAdjustments", "Talents", "Equipment"];
	local arrayFields = ["SkillLoadout", "Quests"];
	local stats = ["Hitpoints", "Bravery", "Stamina", "MeleeSkill", "RangedSkill", "MeleeDefense", "RangedDefense", "Initiative"];
	foreach( index, template in _valkyries )
	{
		local path = "Valkyries[" + index + "]";
		if (typeof template != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path, "must be a table");
		foreach( field in stringFields ) ::$bvvar{namespace}.requireValkyriePackString(template, field, _packID, path + "." + field);
		foreach( field in tableFields ) ::$bvvar{namespace}.requireValkyriePackTable(template, field, _packID, path + "." + field);
		foreach( field in arrayFields ) ::$bvvar{namespace}.requireValkyriePackArray(template, field, _packID, path + "." + field);
		::$bvvar{namespace}.requireValkyriePackQualifiedID(_packID, template.ID, path + ".ID");
		if (template.ID in seen || template.ID in ::$bvvar{namespace}.Valkyries) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".ID", "ID already exists");
		if (!(template.SkinID in _skins)) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkinID", "unknown Pack skin");
		if ("SkinIDs" in template)
		{
			if (typeof template.SkinIDs != "array") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkinIDs", "must be an array");
			local seenSkinIDs = {};
			foreach( skinID in template.SkinIDs )
			{
				if (typeof skinID != "string" || skinID.len() == 0) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkinIDs", "entries must be non-empty strings");
				if (!(skinID in _skins)) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkinIDs", "unknown Pack skin " + skinID);
				if (skinID in seenSkinIDs) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkinIDs", "must not contain duplicate skin " + skinID);
				seenSkinIDs[skinID] <- true;
			}
		}
		foreach( field in ["Level", "XP", "DailyWage"] )
			if (!(field in template) || typeof template[field] != "integer") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + "." + field, "must be an integer");
		if (!("WorldLeaderBrush" in template) || typeof template.WorldLeaderBrush != "string") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".WorldLeaderBrush", "must be a string, optionally empty");
		foreach( stat in stats )
		{
			if (!(stat in template.BaseAttributes) || typeof template.BaseAttributes[stat] != "integer") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".BaseAttributes." + stat, "must be an integer");
			if (!(stat in template.Talents) || typeof template.Talents[stat] != "integer" || template.Talents[stat] < 0 || template.Talents[stat] > 3) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Talents." + stat, "must be 0 through 3");
			if (!(stat in template.AttributeAdjustments) || typeof template.AttributeAdjustments[stat] != "array" || template.AttributeAdjustments[stat].len() != 2) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".AttributeAdjustments." + stat, "must be a two-value array");
			foreach( adjustment in template.AttributeAdjustments[stat] )
				if (typeof adjustment != "integer" && typeof adjustment != "float") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".AttributeAdjustments." + stat, "values must be numeric");
		}
		local seenLoadoutSkills = {};
		foreach( skillKey in template.SkillLoadout )
		{
			if (typeof skillKey != "string" || skillKey.len() == 0) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkillLoadout", "entries must be a non-empty string");
			if (skillKey in seenLoadoutSkills) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkillLoadout", "must not contain duplicate skill " + skillKey);
			seenLoadoutSkills[skillKey] <- true;
			local definition = skillKey in _skills ? _skills[skillKey] : (skillKey in ::$bvvar{namespace}.ValkyrieSkillCatalog ? ::$bvvar{namespace}.ValkyrieSkillCatalog[skillKey] : null);
			if (definition == null || definition.Lifetime != "persistent") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkillLoadout", "unknown or nonpersistent skill " + skillKey);
		}
		if ("AdditionalTraitScripts" in template)
		{
			if (typeof template.AdditionalTraitScripts != "array") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".AdditionalTraitScripts", "must be an array");
			foreach( script in template.AdditionalTraitScripts )
				if (typeof script != "string" || script.len() == 0) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".AdditionalTraitScripts", "entries must be non-empty strings");
		}
		if ("HubDetails" in template && typeof template.HubDetails != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".HubDetails", "must be a table");
		if ("Order" in template && typeof template.Order != "integer") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".Order", "must be an integer");
		local normalized = ::$bvvar{namespace}.deepCopyValkyriePackValue(template);
		if (!("SkinIDs" in normalized)) normalized.SkinIDs <- [template.SkinID];
		normalized.PackID <- _packID;
		if ("Order" in normalized) normalized.Order = template.Order;
		else normalized.Order <- index;
		seen[template.ID] <- true;
		ret.push(normalized);
	}
	return ret;
};

::$bvvar{namespace}.normalizeValkyriePackVoiceConfigs <- function( _packID, _configs, _skins )
{
	if (typeof _configs != "array") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, "VoiceConfigs", "must be an array");
	local ret = [];
	local seen = {};
	local soundPrefix = "sounds/valkyrie_packs/" + _packID + "/";
	foreach( index, config in _configs )
	{
		local path = "VoiceConfigs[" + index + "]";
		if (typeof config != "table") ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path, "must be a table");
		local skinID = ::$bvvar{namespace}.requireValkyriePackString(config, "SkinID", _packID, path + ".SkinID");
		::$bvvar{namespace}.requireValkyriePackArray(config, "HurtAndDeathSounds", _packID, path + ".HurtAndDeathSounds");
		::$bvvar{namespace}.requireValkyriePackArray(config, "FatigueSounds", _packID, path + ".FatigueSounds");
		if ("DebugName" in config) ::$bvvar{namespace}.requireValkyriePackString(config, "DebugName", _packID, path + ".DebugName");
		if (!(skinID in _skins) || skinID in seen) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + ".SkinID", "unknown or duplicate Pack skin");
		foreach( field in ["HurtAndDeathSounds", "FatigueSounds"] )
			foreach( sound in config[field] )
				if (typeof sound != "string" || sound.find(soundPrefix) != 0) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, path + "." + field, "entries must start with " + soundPrefix);
		seen[skinID] <- true;
		ret.push(::$bvvar{namespace}.deepCopyValkyriePackValue(config));
	}
	return ret;
};

::$bvvar{namespace}.normalizeValkyriePackDefinition <- function( _definition )
{
	if (typeof _definition != "table")
		::$bvvar{namespace}.failValkyriePackRegistration(null, "pack", "definition must be a table");

	local packID = ::$bvvar{namespace}.requireValkyriePackString(_definition, "ID", null, "pack.ID");
	if (!::$bvvar{namespace}.isValidValkyriePackID(packID))
		::$bvvar{namespace}.failValkyriePackRegistration(packID, "pack.ID", "must be lowercase snake_case and start with a letter");

	local version = ::$bvvar{namespace}.requireValkyriePackString(_definition, "Version", packID, "pack.Version");
	if (!::$bvvar{namespace}.isValidValkyriePackVersion(version))
		::$bvvar{namespace}.failValkyriePackRegistration(packID, "pack.Version", "must use MAJOR.MINOR.PATCH");
	if (!("RequiredAPIVersion" in _definition) || typeof _definition.RequiredAPIVersion != "integer" || _definition.RequiredAPIVersion != 1)
		::$bvvar{namespace}.failValkyriePackRegistration(packID, "pack.RequiredAPIVersion", "must equal 1");

	local normalized = ::$bvvar{namespace}.deepCopyValkyriePackValue(_definition);
	if (!("PackOrder" in normalized)) normalized.PackOrder <- 1000;
	if (typeof normalized.PackOrder != "integer") ::$bvvar{namespace}.failValkyriePackRegistration(packID, "pack.PackOrder", "must be an integer");
	if (!("VoiceConfigs" in normalized)) normalized.VoiceConfigs <- [];
	if (!("Skills" in normalized)) ::$bvvar{namespace}.failValkyriePackRegistration(packID, "Skills", "field is required");
	if (!("Skins" in normalized)) ::$bvvar{namespace}.failValkyriePackRegistration(packID, "Skins", "field is required");
	if (!("Valkyries" in normalized)) ::$bvvar{namespace}.failValkyriePackRegistration(packID, "Valkyries", "field is required");
	normalized.Skills = ::$bvvar{namespace}.normalizeValkyriePackSkills(packID, normalized.Skills);
	normalized.Skins = ::$bvvar{namespace}.normalizeValkyriePackSkins(packID, normalized.Skins);
	normalized.Valkyries = ::$bvvar{namespace}.normalizeValkyriePackValkyries(packID, normalized.Valkyries, normalized.Skills, normalized.Skins);
	normalized.VoiceConfigs = ::$bvvar{namespace}.normalizeValkyriePackVoiceConfigs(packID, normalized.VoiceConfigs, normalized.Skins);
	return normalized;
};
