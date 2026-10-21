::$bvvar{namespace}.ValkyrieLegendsPerkProfileRequirements <- {
	Weapon = 8,
	Defense = 2,
	Traits = 7
};

::$bvvar{namespace}.ValkyrieLegendsPerkProfiles <- {
	melee_frontline = {
		Weapon = ["SwordTree", "AxeTree", "MaceTree", "FlailTree", "HammerTree", "CleaverTree", "SpearTree", "PolearmTree"],
		Defense = ["MediumArmorTree", "HeavyArmorTree"],
		Traits = ["TrainedTree", "ViciousTree", "FitTree", "IndestructibleTree", "SturdyTree", "CalmTree", "LargeTree"],
		Enemy = ["SwordmastersTree"],
		Class = [],
		Profession = [],
		Magic = []
	},
	melee_mobile = {
		Weapon = ["SwordTree", "AxeTree", "MaceTree", "FlailTree", "HammerTree", "CleaverTree", "SpearTree", "PolearmTree"],
		Defense = ["LightArmorTree", "MediumArmorTree"],
		Traits = ["TrainedTree", "ViciousTree", "AgileTree", "FastTree", "FitTree", "CalmTree", "DeviousTree"],
		Enemy = ["SwordmastersTree"],
		Class = [],
		Profession = [],
		Magic = []
	},
	melee_support = {
		Weapon = ["SwordTree", "AxeTree", "MaceTree", "FlailTree", "HammerTree", "CleaverTree", "SpearTree", "PolearmTree"],
		Defense = ["MediumArmorTree", "HeavyArmorTree"],
		Traits = ["TrainedTree", "FitTree", "CalmTree", "InspirationalTree", "OrganisedTree", "SturdyTree", "IntelligentTree"],
		Enemy = [],
		Class = [],
		Profession = [],
		Magic = []
	},
	ranged_damage = {
		Weapon = ["BowTree", "CrossbowTree", "ThrowingTree", "SlingTree", "DaggerTree", "SwordTree", "SpearTree", "PolearmTree"],
		Defense = ["ClothArmorTree", "LightArmorTree"],
		Traits = ["AgileTree", "FastTree", "FitTree", "IntelligentTree", "CalmTree", "DeviousTree", "ViciousTree"],
		Enemy = [],
		Class = [],
		Profession = [],
		Magic = ["MasterArcherTree"]
	},
	ranged_support = {
		Weapon = ["BowTree", "CrossbowTree", "ThrowingTree", "SlingTree", "DaggerTree", "SwordTree", "SpearTree", "PolearmTree"],
		Defense = ["ClothArmorTree", "LightArmorTree"],
		Traits = ["AgileTree", "FastTree", "FitTree", "IntelligentTree", "CalmTree", "InspirationalTree", "OrganisedTree"],
		Enemy = [],
		Class = [],
		Profession = [],
		Magic = []
	},
	hybrid_skirmisher = {
		Weapon = ["SwordTree", "DaggerTree", "SpearTree", "PolearmTree", "BowTree", "CrossbowTree", "ThrowingTree", "SlingTree"],
		Defense = ["LightArmorTree", "MediumArmorTree"],
		Traits = ["TrainedTree", "AgileTree", "FastTree", "FitTree", "IntelligentTree", "CalmTree", "ViciousTree"],
		Enemy = [],
		Class = [],
		Profession = [],
		Magic = []
	}
};

::$bvvar{namespace}.getValkyrieLegendsPerkProfile <- function( _profileID )
{
	if (typeof _profileID != "string" || _profileID.len() == 0 || !(_profileID in ::$bvvar{namespace}.ValkyrieLegendsPerkProfiles))
	{
		return null;
	}

	return ::$bvvar{namespace}.ValkyrieLegendsPerkProfiles[_profileID];
};

::$bvvar{namespace}.validateValkyrieLegendsPerkProfiles <- function()
{
	local categories = ["Weapon", "Defense", "Traits", "Enemy", "Class", "Profession", "Magic"];

	foreach( profileID, profile in ::$bvvar{namespace}.ValkyrieLegendsPerkProfiles )
	{
		if (profile == null)
		{
			throw "[Battle Valkyries] Legends perk profile is null: " + profileID;
		}

		foreach( category in categories )
		{
			if (!(category in profile) || typeof profile[category] != "array")
			{
				throw "[Battle Valkyries] Legends perk profile category is missing or malformed: " + profileID + "." + category;
			}

			local seen = {};

			foreach( treeKey in profile[category] )
			{
				if (typeof treeKey != "string" || treeKey.len() == 0)
				{
					throw "[Battle Valkyries] Legends perk profile contains an invalid tree key: " + profileID + "." + category;
				}

				if (treeKey in seen)
				{
					throw "[Battle Valkyries] Legends perk profile contains a duplicate tree key: " + profileID + "." + category + "." + treeKey;
				}

				seen[treeKey] <- true;
			}
		}

		foreach( category, requiredCount in ::$bvvar{namespace}.ValkyrieLegendsPerkProfileRequirements )
		{
			if (profile[category].len() != requiredCount)
			{
				throw "[Battle Valkyries] Legends perk profile must provide exactly " + requiredCount + " " + category + " trees: " + profileID;
			}
		}
	}

	foreach( valkyrieID in ::$bvvar{namespace}.ValkyrieOrder )
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);

		if (template == null || !("LegendsPerkProfile" in template) || ::$bvvar{namespace}.getValkyrieLegendsPerkProfile(template.LegendsPerkProfile) == null)
		{
			throw "[Battle Valkyries] Valkyrie has no valid Legends perk profile: " + valkyrieID;
		}
	}

	return true;
};
