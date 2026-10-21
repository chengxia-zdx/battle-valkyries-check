::$bvvar{namespace}.ValkyrieBountyDifficulty <- {
	// TEMP TEST SWITCH: set to false after the low-budget acceptance test.
	// Normal escort-budget and fixed-champion code remains intact below.
	DebugLowBudgetTest = false,
	DebugTestEscortBudget = 60,
	MaxOwnedValkyries = 12,
	MinEscortBudget = 180,
	MaxEscortBudget = 1200,
	CurveExponent = 1.5,
	TargetThreatCost = 300,
	TargetLevel = 11,
	TargetHitpointsBonus = 300,
	RewardsByStars = [3000, 6000, 12000],
	StarThresholds = [
		{ Min = 0, Max = 3, Stars = 1 },
		{ Min = 4, Max = 7, Stars = 2 },
		{ Min = 8, Max = 12, Stars = 3 }
	]
};

// Phase two deliberately uses one vanilla-safe theme. More themes and DLC-specific
// candidates are data additions, never per-bounty contract forks.
::$bvvar{namespace}.ValkyrieBountyEnemyThemes <- {
	bandits = {
		ID = "bandits",
		FactionType = "Bandits",
		SpawnTemplate = "BanditRaiders",
		ChampionTroop = "BanditLeader",
		ChampionTroopScript = "scripts/entity/tactical/enemies/bandit_leader",
		BountyEliteTroop = "BanditRaider",
		BountyEliteTroopScript = "scripts/entity/tactical/enemies/bandit_raider",
		FootprintType = "Brigands",
		RequiredDLC = null
	}
};

// ValkyrieOrder is the authoritative built-in roster. Every registered template gets
// a bounty card; role overrides only describe future enemy-factory equipment and AI.
::$bvvar{namespace}.ValkyrieBountyCombatProfiles <- {
	saber = { AIProfile = "melee_aggressive", WeaponProfile = "sword", CanUseNamedShield = true },
	silver_wolf = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	yae_miko = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	kafka = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	himeko = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	feixiao = { AIProfile = "melee_aggressive", WeaponProfile = "axe", CanUseNamedShield = false },
	raiden_shogun = { AIProfile = "melee_aggressive", WeaponProfile = "polearm", CanUseNamedShield = false },
	xilian = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	castorice = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	hysilens = { AIProfile = "melee_aggressive", WeaponProfile = "polearm", CanUseNamedShield = false },
	tilixibiesi = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	cipher = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	cerydra = { AIProfile = "melee_defensive", WeaponProfile = "sword", CanUseNamedShield = false },
	fengjin = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	yuno = { AIProfile = "ranged_support", WeaponProfile = "ranged", CanUseNamedShield = false },
	aglaea = { AIProfile = "melee_aggressive", WeaponProfile = "polearm", CanUseNamedShield = false }
};

::$bvvar{namespace}.ValkyrieBountyOrder <- clone ::$bvvar{namespace}.ValkyrieOrder;
::$bvvar{namespace}.ValkyrieBounties <- {};

foreach( valkyrieID in ::$bvvar{namespace}.ValkyrieBountyOrder )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
	local profile = valkyrieID in ::$bvvar{namespace}.ValkyrieBountyCombatProfiles
		? ::$bvvar{namespace}.ValkyrieBountyCombatProfiles[valkyrieID]
		: { AIProfile = "melee_aggressive", WeaponProfile = "sword", CanUseNamedShield = false };

	::$bvvar{namespace}.ValkyrieBounties[valkyrieID] <- {
		ID = valkyrieID,
		ValkyrieID = valkyrieID,
		Poster = template == null || !("Portrait" in template) ? "" : template.Portrait,
		AIProfile = profile.AIProfile,
		BountyWeaponProfile = profile.WeaponProfile,
		CanUseNamedShield = profile.CanUseNamedShield
	};
}

::$bvvar{namespace}.getBountyByID <- function( _bountyID )
{
	if (typeof _bountyID != "string" || _bountyID.len() == 0 || !(_bountyID in ::$bvvar{namespace}.ValkyrieBounties))
	{
		return null;
	}

	return ::$bvvar{namespace}.ValkyrieBounties[_bountyID];
};

::$bvvar{namespace}.getValkyrieBountyEnemyThemeByID <- function( _themeID )
{
	if (typeof _themeID != "string" || _themeID.len() == 0 || !(_themeID in ::$bvvar{namespace}.ValkyrieBountyEnemyThemes))
	{
		return null;
	}

	return ::$bvvar{namespace}.ValkyrieBountyEnemyThemes[_themeID];
};

::$bvvar{namespace}.getValkyrieBountyEnemyThemeIDs <- function()
{
	local result = [];
	foreach( themeID, theme in ::$bvvar{namespace}.ValkyrieBountyEnemyThemes )
	{
		if (theme == null || !("RequiredDLC" in theme) || theme.RequiredDLC == null)
		{
			result.push(themeID);
			continue;
		}

		if ("Const" in getroottable() && "DLC" in ::Const && theme.RequiredDLC in ::Const.DLC && ::Const.DLC[theme.RequiredDLC])
		{
			result.push(themeID);
		}
	}

	return result;
};

::$bvvar{namespace}.getValkyrieBountyOwnedCountClamped <- function( _ownedCount )
{
	if (typeof _ownedCount != "integer" && typeof _ownedCount != "float")
	{
		return 0;
	}

	return ::Math.max(0, ::Math.min(::$bvvar{namespace}.ValkyrieBountyDifficulty.MaxOwnedValkyries, _ownedCount));
};

::$bvvar{namespace}.getValkyrieBountyStars <- function( _ownedCount )
{
	local count = ::$bvvar{namespace}.getValkyrieBountyOwnedCountClamped(_ownedCount);

	foreach( threshold in ::$bvvar{namespace}.ValkyrieBountyDifficulty.StarThresholds )
	{
		if (count >= threshold.Min && count <= threshold.Max)
		{
			return threshold.Stars;
		}
	}

	return 3;
};

::$bvvar{namespace}.getValkyrieBountyEscortBudget <- function( _ownedCount )
{
	local config = ::$bvvar{namespace}.ValkyrieBountyDifficulty;
	local count = ::$bvvar{namespace}.getValkyrieBountyOwnedCountClamped(_ownedCount);
	local ratio = count.tofloat() / config.MaxOwnedValkyries.tofloat();
	local raw = config.MinEscortBudget + (config.MaxEscortBudget - config.MinEscortBudget) * ::Math.pow(ratio, config.CurveExponent);
	return ::Math.floor(raw / 10.0 + 0.5) * 10;
};

::$bvvar{namespace}.getValkyrieBountyReward <- function( _stars )
{
	local index = ::Math.max(1, ::Math.min(::$bvvar{namespace}.ValkyrieBountyDifficulty.RewardsByStars.len(), _stars)) - 1;
	return ::$bvvar{namespace}.ValkyrieBountyDifficulty.RewardsByStars[index];
};

::$bvvar{namespace}.validateValkyrieBountyData <- function()
{
	local difficulty = ::$bvvar{namespace}.ValkyrieBountyDifficulty;
	if (difficulty == null
		|| !("DebugLowBudgetTest" in difficulty) || typeof difficulty.DebugLowBudgetTest != "bool"
		|| !("DebugTestEscortBudget" in difficulty) || typeof difficulty.DebugTestEscortBudget != "integer" || difficulty.DebugTestEscortBudget <= 0
		|| !("MaxOwnedValkyries" in difficulty) || typeof difficulty.MaxOwnedValkyries != "integer" || difficulty.MaxOwnedValkyries <= 0
		|| !("MinEscortBudget" in difficulty) || (typeof difficulty.MinEscortBudget != "integer" && typeof difficulty.MinEscortBudget != "float") || difficulty.MinEscortBudget < 0
		|| !("MaxEscortBudget" in difficulty) || (typeof difficulty.MaxEscortBudget != "integer" && typeof difficulty.MaxEscortBudget != "float") || difficulty.MaxEscortBudget < difficulty.MinEscortBudget
		|| !("CurveExponent" in difficulty) || (typeof difficulty.CurveExponent != "integer" && typeof difficulty.CurveExponent != "float") || difficulty.CurveExponent <= 0
		|| !("TargetThreatCost" in difficulty) || (typeof difficulty.TargetThreatCost != "integer" && typeof difficulty.TargetThreatCost != "float") || difficulty.TargetThreatCost <= 0
		|| !("TargetLevel" in difficulty) || typeof difficulty.TargetLevel != "integer" || difficulty.TargetLevel <= 0
		|| !("TargetHitpointsBonus" in difficulty) || (typeof difficulty.TargetHitpointsBonus != "integer" && typeof difficulty.TargetHitpointsBonus != "float") || difficulty.TargetHitpointsBonus < 0
		|| !("StarThresholds" in difficulty) || typeof difficulty.StarThresholds != "array"
		|| !("RewardsByStars" in difficulty) || typeof difficulty.RewardsByStars != "array"
		|| difficulty.StarThresholds.len() == 0 || difficulty.StarThresholds.len() != difficulty.RewardsByStars.len())
	{
		return false;
	}

	local nextMin = 0;
	for (local i = 0; i < difficulty.StarThresholds.len(); ++i)
	{
		local threshold = difficulty.StarThresholds[i];
		local reward = difficulty.RewardsByStars[i];
		if (threshold == null
			|| !("Min" in threshold) || typeof threshold.Min != "integer" || threshold.Min != nextMin
			|| !("Max" in threshold) || typeof threshold.Max != "integer" || threshold.Max < threshold.Min
			|| !("Stars" in threshold) || typeof threshold.Stars != "integer" || threshold.Stars != i + 1
			|| (typeof reward != "integer" && typeof reward != "float") || reward <= 0)
		{
			return false;
		}

		nextMin = threshold.Max + 1;
	}

	if (nextMin != difficulty.MaxOwnedValkyries + 1
		|| typeof ::$bvvar{namespace}.ValkyrieBountyOrder != "array"
		|| ::$bvvar{namespace}.ValkyrieBountyOrder.len() != ::$bvvar{namespace}.ValkyrieOrder.len())
	{
		return false;
	}

	if (typeof ::$bvvar{namespace}.ValkyrieBountyEnemyThemes != "table" || ::$bvvar{namespace}.getValkyrieBountyEnemyThemeIDs().len() == 0)
	{
		return false;
	}

	foreach( themeID, theme in ::$bvvar{namespace}.ValkyrieBountyEnemyThemes )
	{
		if (typeof themeID != "string" || themeID.len() == 0 || theme == null
			|| !("ID" in theme) || theme.ID != themeID
			|| !("FactionType" in theme) || typeof theme.FactionType != "string" || theme.FactionType == ""
			|| !("SpawnTemplate" in theme) || typeof theme.SpawnTemplate != "string" || theme.SpawnTemplate == ""
			|| !("ChampionTroop" in theme) || typeof theme.ChampionTroop != "string" || theme.ChampionTroop == ""
			|| !("ChampionTroopScript" in theme) || typeof theme.ChampionTroopScript != "string" || theme.ChampionTroopScript == ""
			|| !("BountyEliteTroop" in theme) || typeof theme.BountyEliteTroop != "string" || theme.BountyEliteTroop == ""
			|| !("BountyEliteTroopScript" in theme) || typeof theme.BountyEliteTroopScript != "string" || theme.BountyEliteTroopScript == ""
			|| !("FootprintType" in theme) || typeof theme.FootprintType != "string" || theme.FootprintType == ""
			|| !("RequiredDLC" in theme) || (theme.RequiredDLC != null && typeof theme.RequiredDLC != "string"))
		{
			return false;
		}
	}

	local seen = {};

	for (local i = 0; i < ::$bvvar{namespace}.ValkyrieBountyOrder.len(); ++i)
	{
		local bountyID = ::$bvvar{namespace}.ValkyrieBountyOrder[i];
		if (bountyID != ::$bvvar{namespace}.ValkyrieOrder[i])
		{
			return false;
		}

		local bounty = ::$bvvar{namespace}.getBountyByID(bountyID);
		local template = bounty == null || !("ValkyrieID" in bounty) ? null : ::$bvvar{namespace}.getValkyrieByID(bounty.ValkyrieID);
		if (typeof bountyID != "string" || bountyID.len() == 0 || bounty == null || bountyID in seen || !("ID" in bounty) || bounty.ID != bountyID || template == null || !("Poster" in bounty) || typeof bounty.Poster != "string" || bounty.Poster == "" || !("Portrait" in template) || bounty.Poster != template.Portrait || !("AIProfile" in bounty) || typeof bounty.AIProfile != "string" || bounty.AIProfile == "" || !("BountyWeaponProfile" in bounty) || typeof bounty.BountyWeaponProfile != "string" || bounty.BountyWeaponProfile == "" || !("CanUseNamedShield" in bounty) || typeof bounty.CanUseNamedShield != "bool")
		{
			return false;
		}

		seen[bountyID] <- true;
	}

	local definitionCount = 0;
	foreach( bountyID, bounty in ::$bvvar{namespace}.ValkyrieBounties )
	{
		definitionCount = ++definitionCount;
		if (!(bountyID in seen) || bounty == null || !("ID" in bounty) || bounty.ID != bountyID)
		{
			return false;
		}
	}

	return definitionCount == seen.len();
};
