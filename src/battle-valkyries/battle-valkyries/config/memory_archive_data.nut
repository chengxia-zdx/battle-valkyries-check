::$bvvar{namespace}.MemoryArchiveVersion <- 2;
::$bvvar{namespace}.MemoryRecordIDFlag <- "$bvvar{modId}.memory_archive.record_id";
::$bvvar{namespace}.MemoryArchivePrefix <- "$bvvar{modId}.memory_archive.";

::$bvvar{namespace}.MemoryArchiveAttributes <- [
	{ Key = "Hitpoints", Label = "$bv{memory.attribute.hitpoints}", Icon = "ui/icons/health.png", Thresholds = [80, 95, 110] },
	{ Key = "Stamina", Label = "$bv{memory.attribute.stamina}", Icon = "ui/icons/fatigue.png", Thresholds = [105, 120, 135] },
	{ Key = "Bravery", Label = "$bv{memory.attribute.bravery}", Icon = "ui/icons/bravery.png", Thresholds = [50, 65, 80] },
	{ Key = "Initiative", Label = "$bv{memory.attribute.initiative}", Icon = "ui/icons/initiative.png", Thresholds = [105, 125, 145] },
	{ Key = "MeleeSkill", Label = "$bv{memory.attribute.melee_skill}", Icon = "ui/icons/melee_skill.png", Thresholds = [70, 80, 90] },
	{ Key = "RangedSkill", Label = "$bv{memory.attribute.ranged_skill}", Icon = "ui/icons/ranged_skill.png", Thresholds = [65, 75, 85] },
	{ Key = "MeleeDefense", Label = "$bv{memory.attribute.melee_defense}", Icon = "ui/icons/melee_defense.png", Thresholds = [15, 25, 35] },
	{ Key = "RangedDefense", Label = "$bv{memory.attribute.ranged_defense}", Icon = "ui/icons/ranged_defense.png", Thresholds = [10, 20, 30] }
];

::$bvvar{namespace}.MemoryArchiveResources <- [
	{ Key = "Fragment", Label = "$bv{memory.resource.fragment}" },
	{ Key = "Crystal", Label = "$bv{memory.resource.crystal}" },
	{ Key = "Eternal", Label = "$bv{memory.resource.eternal}" },
	{ Key = "Emblem", Label = "$bv{memory.resource.emblem}" }
];

::$bvvar{namespace}.validateMemoryArchiveData <- function()
{
	if (::$bvvar{namespace}.MemoryArchiveAttributes.len() != 8) return false;
	foreach (attribute in ::$bvvar{namespace}.MemoryArchiveAttributes)
	{
		if (!("Key" in attribute) || !("Thresholds" in attribute) || attribute.Thresholds.len() != 3) return false;
		if (attribute.Thresholds[0] >= attribute.Thresholds[1] || attribute.Thresholds[1] >= attribute.Thresholds[2]) return false;
	}

	local expectedResources = { Fragment = true, Crystal = true, Eternal = true, Emblem = true };
	if (::$bvvar{namespace}.MemoryArchiveResources.len() != expectedResources.len()) return false;
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		if (!("Key" in resource) || !(resource.Key in expectedResources)) return false;
		delete expectedResources[resource.Key];
	}
	return expectedResources.len() == 0;
};

::$bvvar{namespace}.getMemoryArchiveRank <- function( _eliteCount, _legendaryCount )
{
	if (_legendaryCount >= 4) return { Key = "eternal", Title = "$bv{memory.rank.eternal}" };
	if (_eliteCount >= 5 || _legendaryCount >= 3) return { Key = "uncrowned", Title = "$bv{memory.rank.uncrowned}" };
	if (_eliteCount >= 4 || _legendaryCount >= 2) return { Key = "mortal_hero", Title = "$bv{memory.rank.mortal_hero}" };
	if (_eliteCount >= 3) return { Key = "pillar", Title = "$bv{memory.rank.pillar}" };
	if (_eliteCount >= 2) return { Key = "excellent", Title = "$bv{memory.rank.excellent}" };
	if (_eliteCount >= 1) return { Key = "veteran", Title = "$bv{memory.rank.veteran}" };
	return { Key = "ordinary", Title = "$bv{memory.rank.ordinary}" };
};
