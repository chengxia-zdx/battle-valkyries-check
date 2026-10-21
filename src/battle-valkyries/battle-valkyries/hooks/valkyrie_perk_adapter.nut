::$bvvar{namespace}.appendValkyrieLegendsPerkTree <- function( _trees, _key )
{
	if (_trees == null || !("Const" in getroottable()) || !("Perks" in ::Const) || !(_key in ::Const.Perks))
	{
		return false;
	}

	local tree = ::Const.Perks[_key];

	if (tree == null)
	{
		return false;
	}

	_trees.push(tree);
	return true;
};

::$bvvar{namespace}.hasLegendsPerkTreeRuntime <- function()
{
	local root = getroottable();
	return "Const" in root
		&& "Perks" in ::Const
		&& "GetDynamicPerkTree" in ::Const.Perks
		&& "BuildCustomPerkTree" in ::Const.Perks;
};

::$bvvar{namespace}.hasReforgedPerkTreeRuntime <- function()
{
	local root = getroottable();
	return !::$bvvar{namespace}.hasLegendsPerkTreeRuntime()
		&& "Hooks" in root
		&& ::Hooks.hasMod("mod_reforged")
		&& "Reforged" in root
		&& "DynamicPerks" in root
		&& "Class" in ::DynamicPerks
		&& "PerkTree" in ::DynamicPerks.Class
		&& "PerkGroups" in ::DynamicPerks;
};

::$bvvar{namespace}.getAvailableValkyrieReforgedPerkGroups <- function( _ids )
{
	local ret = [];

	if (_ids == null || !::$bvvar{namespace}.hasReforgedPerkTreeRuntime())
	{
		return ret;
	}

	foreach( id in _ids )
	{
		if (::DynamicPerks.PerkGroups.findById(id) != null)
		{
			ret.push(id);
		}
	}

	return ret;
};

::$bvvar{namespace}.createValkyrieReforgedPerkTree <- function( _actor )
{
	if (_actor == null || !::$bvvar{namespace}.hasReforgedPerkTreeRuntime())
	{
		return null;
	}

	local dynamicMap = {
		"pgc.rf_exclusive_1": ::$bvvar{namespace}.getAvailableValkyrieReforgedPerkGroups([
			"pg.rf_swordmaster"
		]),
		"pgc.rf_shared_1": ::$bvvar{namespace}.getAvailableValkyrieReforgedPerkGroups([
			"pg.rf_trained",
			"pg.rf_vicious"
		]),
		"pgc.rf_weapon": ::$bvvar{namespace}.getAvailableValkyrieReforgedPerkGroups([
			"pg.rf_sword",
			"pg.rf_axe",
			"pg.rf_mace",
			"pg.rf_flail",
			"pg.rf_hammer"
		]),
		"pgc.rf_armor": ::$bvvar{namespace}.getAvailableValkyrieReforgedPerkGroups([
			"pg.rf_medium_armor",
			"pg.rf_heavy_armor"
		]),
		"pgc.rf_fighting_style": ::$bvvar{namespace}.getAvailableValkyrieReforgedPerkGroups([
			"pg.rf_power",
			"pg.rf_shield"
		])
	};
	local tree = ::new(::DynamicPerks.Class.PerkTree).init({ DynamicMap = dynamicMap });
	tree.setActor(_actor);
	tree.build();
	return tree;
};

::$bvvar{namespace}.applyValkyrieReforgedPerkTree <- function( _actor, _background, _reason, _onlyIfDefault = false )
{
	if (_actor == null || _background == null || !::$bvvar{namespace}.hasReforgedPerkTreeRuntime())
	{
		return false;
	}

	local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);

	// During a new summon the stable actor flags are written a little later in
	// the transaction, but the public background already carries the same ID.
	if ((valkyrieID == null || valkyrieID == "") && "ValkyrieID" in _background.m)
	{
		valkyrieID = _background.m.ValkyrieID;
	}

	if (valkyrieID == null || valkyrieID == "" || ::$bvvar{namespace}.getValkyrieByID(valkyrieID) == null)
	{
		return false;
	}

	if (_onlyIfDefault)
	{
		local current = null;

		try { current = _actor.getPerkTree(); } catch (e) { current = null; }

		if (current != null)
		{
			try
			{
				if (current.getPerkGroups().len() != 0)
				{
					return false;
				}
			}
			catch (e)
			{
			}
		}
	}

	local tree = ::$bvvar{namespace}.createValkyrieReforgedPerkTree(_actor);

	if (tree == null)
	{
		return false;
	}

	_actor.m.PerkTree = tree;
	::$bvvar{namespace}.logPerkDebug("stage=reforged-tree-built actor=" + ::$bvvar{namespace}.getPerkDebugObjectID(_actor) + " valkyrie=" + valkyrieID + " groups=" + tree.getPerkGroups().len() + " reason=" + _reason);
	return true;
};

::$bvvar{namespace}.PerkDebugSeen <- {};

::$bvvar{namespace}.logPerkDebug <- function( _message )
{
	try
	{
		::logInfo("[Battle Valkyries] [PerkDebug] " + _message);
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.logPerkDebugOnce <- function( _key, _message )
{
	if (_key in ::$bvvar{namespace}.PerkDebugSeen)
	{
		return;
	}

	::$bvvar{namespace}.PerkDebugSeen[_key] <- true;
	::$bvvar{namespace}.logPerkDebug(_message);
};

::$bvvar{namespace}.getPerkDebugObjectID <- function( _object )
{
	if (_object == null)
	{
		return "null";
	}

	try
	{
		return "" + _object.getID();
	}
	catch (e)
	{
	}

	return "unknown";
};

::$bvvar{namespace}.logValkyriePerkTreeState <- function( _actor, _background, _stage, _onceKey = null )
{
	if (_onceKey != null)
	{
		if (_onceKey in ::$bvvar{namespace}.PerkDebugSeen)
		{
			return;
		}

		::$bvvar{namespace}.PerkDebugSeen[_onceKey] <- true;
	}

	local actorID = ::$bvvar{namespace}.getPerkDebugObjectID(_actor);
	local actorName = "unknown";
	local backgroundID = ::$bvvar{namespace}.getPerkDebugObjectID(_background);

	try { actorName = _actor == null ? "null" : "" + _actor.getName(); } catch (e) {}

	if (_background == null)
	{
		::$bvvar{namespace}.logPerkDebug("stage=" + _stage + " actor=" + actorID + " name=" + actorName + " background=" + backgroundID + " state=no-background");
		return;
	}

	local dynamicCounts = "none";
	local customRows = -1;
	local perkRows = -1;
	local mapEntries = -1;
	local perkEntries = 0;
	local missingTooltip = 0;
	local missingScript = 0;
	local samples = "";

	try
	{
		if ("PerkTreeDynamic" in _background.m && _background.m.PerkTreeDynamic != null)
		{
			local d = _background.m.PerkTreeDynamic;
			dynamicCounts = "W" + d.Weapon.len() + "/D" + d.Defense.len() + "/T" + d.Traits.len() + "/E" + d.Enemy.len() + "/C" + d.Class.len() + "/P" + d.Profession.len() + "/M" + d.Magic.len();
		}
	}
	catch (e)
	{
		dynamicCounts = "error:" + e;
	}

	try { customRows = "CustomPerkTree" in _background.m && _background.m.CustomPerkTree != null ? _background.m.CustomPerkTree.len() : -1; } catch (e) {}
	try { perkRows = "PerkTree" in _background.m && _background.m.PerkTree != null ? _background.m.PerkTree.len() : -1; } catch (e) {}
	try { mapEntries = "PerkTreeMap" in _background.m && _background.m.PerkTreeMap != null ? _background.m.PerkTreeMap.len() : -1; } catch (e) {}

	try
	{
		if ("PerkTree" in _background.m && _background.m.PerkTree != null)
		{
			foreach (row in _background.m.PerkTree)
			{
				if (row == null) continue;

				foreach (perk in row)
				{
					if (perk == null) continue;
					perkEntries++;
					if (!("Tooltip" in perk) || perk.Tooltip == null) missingTooltip++;
					if (!("Script" in perk) || perk.Script == null) missingScript++;

					if (perkEntries <= 8)
					{
						local perkID = "ID" in perk ? "" + perk.ID : "no-id";
						samples += (samples == "" ? "" : ",") + perkID + "[tip=" + (("Tooltip" in perk && perk.Tooltip != null) ? "1" : "0") + ",script=" + (("Script" in perk && perk.Script != null) ? "1" : "0") + "]";
					}
				}
			}
		}
	}
	catch (e)
	{
		samples += (samples == "" ? "" : ",") + "scan-error:" + e;
	}

	::$bvvar{namespace}.logPerkDebug("stage=" + _stage + " actor=" + actorID + " name=" + actorName + " background=" + backgroundID + " dynamic=" + dynamicCounts + " customRows=" + customRows + " perkRows=" + perkRows + " mapEntries=" + mapEntries + " perks=" + perkEntries + " missingTooltip=" + missingTooltip + " missingScript=" + missingScript + " samples=" + samples);
};

::$bvvar{namespace}.configureValkyrieLegendsPerkTree <- function( _background )
{
	if (_background == null || !::$bvvar{namespace}.hasLegendsPerkTreeRuntime())
	{
		return false;
	}

	local valkyrieID = "ValkyrieID" in _background.m ? _background.m.ValkyrieID : null;
	local template = valkyrieID == null ? null : ::$bvvar{namespace}.getValkyrieByID(valkyrieID);

	if (template == null || !("LegendsPerkProfile" in template))
	{
		throw "Valkyrie Legends perk profile is unavailable: " + (valkyrieID == null ? "unknown" : valkyrieID);
	}

	local profileID = template.LegendsPerkProfile;
	local definition = ::$bvvar{namespace}.getValkyrieLegendsPerkProfile(profileID);

	if (definition == null)
	{
		throw "Valkyrie Legends perk profile definition is unavailable: " + profileID;
	}

	local profile = {
		Weapon = [],
		Defense = [],
		Traits = [],
		Enemy = [],
		Class = [],
		Profession = [],
		Magic = []
	};

	foreach( category in ["Weapon", "Defense", "Traits", "Enemy", "Class", "Profession", "Magic"] )
	{
		foreach( key in definition[category] )
		{
			if (!::$bvvar{namespace}.appendValkyrieLegendsPerkTree(profile[category], key))
			{
				throw "Valkyrie Legends perk tree is unavailable: " + profileID + "." + category + "." + key;
			}
		}
	}

	foreach( category, requiredCount in ::$bvvar{namespace}.ValkyrieLegendsPerkProfileRequirements )
	{
		if (profile[category].len() != requiredCount)
		{
			throw "Valkyrie Legends perk profile is incomplete: " + profileID + "." + category;
		}
	}

	_background.m.PerkTreeDynamic = profile;
	::$bvvar{namespace}.logPerkDebug("stage=profile-selected valkyrie=" + valkyrieID + " profile=" + profileID);
	::$bvvar{namespace}.logValkyriePerkTreeState(null, _background, "profile-assigned");
	return true;
};

::$bvvar{namespace}.validateLegendsBackgroundPerkTree <- function( _background, _label )
{
	if (_background == null || !::$bvvar{namespace}.hasLegendsPerkTreeRuntime())
	{
		return true;
	}

	if (_background.m.CustomPerkTree == null || _background.m.PerkTree == null || _background.m.PerkTreeMap == null)
	{
		throw "Legends perk tree initialization failed: " + (_label == null ? "unknown" : _label);
	}

	return true;
};

::$bvvar{namespace}.initializeValkyrieBackground <- function( _actor, _background )
{
	if (_actor == null || _background == null)
	{
		throw "Invalid Valkyrie background initialization";
	}

	if (::$bvvar{namespace}.hasLegendsPerkTreeRuntime())
	{
		local attributes = _background.buildPerkTree();
		_actor.m.StarWeights = _background.buildAttributes(null, attributes);
		::$bvvar{namespace}.validateLegendsBackgroundPerkTree(_background, "valkyrie summon");
		::$bvvar{namespace}.logValkyriePerkTreeState(_actor, _background, "tree-built");
	}
	else if (::$bvvar{namespace}.hasReforgedPerkTreeRuntime())
	{
		_background.buildAttributes();
		::$bvvar{namespace}.applyValkyrieReforgedPerkTree(_actor, _background, "summon", false);
	}
	else
	{
		_background.buildAttributes();
	}
};
