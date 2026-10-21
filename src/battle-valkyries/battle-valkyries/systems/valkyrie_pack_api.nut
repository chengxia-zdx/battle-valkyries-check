::$bvvar{namespace}.ValkyriePackAPIState <- {
	RegisteredPacks = {},
	BuiltinOrder = clone ::$bvvar{namespace}.ValkyrieOrder,
	RegistrationClosed = false,
	RegistrationClosedReason = ""
};

::$bvvar{namespace}.API <- { Version = 1 };

::$bvvar{namespace}.API.isPackRegistered <- function( _packID )
{
	return typeof _packID == "string" && _packID in ::$bvvar{namespace}.ValkyriePackAPIState.RegisteredPacks;
};

::$bvvar{namespace}.API.getRegisteredPack <- function( _packID )
{
	if (!this.isPackRegistered(_packID)) return null;
	return ::$bvvar{namespace}.deepCopyValkyriePackValue(::$bvvar{namespace}.ValkyriePackAPIState.RegisteredPacks[_packID]);
};

::$bvvar{namespace}.closeValkyriePackRegistration <- function( _reason )
{
	::$bvvar{namespace}.ValkyriePackAPIState.RegistrationClosed = true;
	::$bvvar{namespace}.ValkyriePackAPIState.RegistrationClosedReason = _reason == null ? "world" : _reason.tostring();
};

::$bvvar{namespace}.compareValkyriePackOrderEntries <- function( _a, _b )
{
	if (_a.PackOrder < _b.PackOrder) return -1;
	if (_a.PackOrder > _b.PackOrder) return 1;
	if (_a.Order < _b.Order) return -1;
	if (_a.Order > _b.Order) return 1;
	if (_a.ID < _b.ID) return -1;
	if (_a.ID > _b.ID) return 1;
	return 0;
};

::$bvvar{namespace}.rebuildValkyrieOrderFromPacks <- function()
{
	local state = ::$bvvar{namespace}.ValkyriePackAPIState;
	local entries = [];
	foreach( packID, pack in state.RegisteredPacks )
		foreach( template in pack.Valkyries )
			entries.push({ PackOrder = pack.PackOrder, Order = template.Order, ID = template.ID });
	entries.sort(::$bvvar{namespace}.compareValkyriePackOrderEntries);
	local nextOrder = clone state.BuiltinOrder;
	foreach( entry in entries ) nextOrder.push(entry.ID);
	::$bvvar{namespace}.ValkyrieOrder = nextOrder;
};

::$bvvar{namespace}.API.registerPack <- function( _definition )
{
	local state = ::$bvvar{namespace}.ValkyriePackAPIState;
	if (state.RegistrationClosed)
		::$bvvar{namespace}.failValkyriePackRegistration(null, "pack", "registration is closed: " + state.RegistrationClosedReason);

	local pack = ::$bvvar{namespace}.normalizeValkyriePackDefinition(_definition);
	if (pack.ID in state.RegisteredPacks)
		::$bvvar{namespace}.failValkyriePackRegistration(pack.ID, "pack.ID", "pack is already registered");

	local nextSkills = clone ::$bvvar{namespace}.ValkyrieSkillCatalog;
	local nextSkins = clone ::$bvvar{namespace}.Skins;
	local nextValkyries = clone ::$bvvar{namespace}.Valkyries;
	local nextVoices = clone ::$bvvar{namespace}.ValkyrieVoiceSoundConfigs;
	local nextPacks = clone state.RegisteredPacks;

	foreach( key, value in pack.Skills )
	{
		if (key in nextSkills) ::$bvvar{namespace}.failValkyriePackRegistration(pack.ID, "Skills." + key, "ID already exists");
		nextSkills[key] <- ::$bvvar{namespace}.deepCopyValkyriePackValue(value);
	}
	foreach( key, value in pack.Skins )
	{
		if (key in nextSkins) ::$bvvar{namespace}.failValkyriePackRegistration(pack.ID, "Skins." + key, "ID already exists");
		nextSkins[key] <- ::$bvvar{namespace}.deepCopyValkyriePackValue(value);
	}
	foreach( value in pack.Valkyries )
	{
		if (value.ID in nextValkyries) ::$bvvar{namespace}.failValkyriePackRegistration(pack.ID, "Valkyries." + value.ID, "ID already exists");
		nextValkyries[value.ID] <- ::$bvvar{namespace}.deepCopyValkyriePackValue(value);
	}
	foreach( value in pack.VoiceConfigs )
	{
		foreach( existing in nextVoices )
		{
			if (existing.SkinID != value.SkinID) continue;
			local existingOwner = "<builtin>";
			foreach( registeredPackID, registeredPack in state.RegisteredPacks )
			{
				foreach( registeredConfig in registeredPack.VoiceConfigs )
				{
					if (registeredConfig.SkinID == value.SkinID)
					{
						existingOwner = registeredPackID;
						break;
					}
				}
				if (existingOwner != "<builtin>") break;
			}
			::$bvvar{namespace}.failValkyriePackRegistration(pack.ID, "VoiceConfigs." + value.SkinID, "SkinID already exists; existing owner=" + existingOwner);
		}
		nextVoices.push(::$bvvar{namespace}.deepCopyValkyriePackValue(value));
	}
	nextPacks[pack.ID] <- ::$bvvar{namespace}.deepCopyValkyriePackValue(pack);

	::$bvvar{namespace}.ValkyrieSkillCatalog = nextSkills;
	::$bvvar{namespace}.Skins = nextSkins;
	::$bvvar{namespace}.Valkyries = nextValkyries;
	::$bvvar{namespace}.ValkyrieVoiceSoundConfigs = nextVoices;
	state.RegisteredPacks = nextPacks;
	if ("bindAllValkyrieSkinPresentations" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.bindAllValkyrieSkinPresentations();
	}
	::$bvvar{namespace}.rebuildValkyrieOrderFromPacks();
	return true;
};
