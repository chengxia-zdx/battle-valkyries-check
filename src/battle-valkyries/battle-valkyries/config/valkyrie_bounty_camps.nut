// Dedicated encounter prices. These are not host spawn-table costs.
// Per-star budget targets, before integer rounding and hard elite caps.
// Champions remain additional native units, outside this defender budget.
::$bvvar{namespace}.BountyCampBudgetShares <- [
	{ T5 = 0.0, T4 = 0.15, Other = 0.85 },
	{ T5 = 0.10, T4 = 0.20, Other = 0.70 },
	{ T5 = 0.15, T4 = 0.25, Other = 0.60 }
];
::$bvvar{namespace}.BountyCampRules <- [
	{ MinOwned = 0, MaxOwned = 3, MinBudget = 1200, MaxBudget = 1800, MinSize = 10, MaxSize = 12, MaxT4 = 2, MaxT5 = 0 },
	{ MinOwned = 4, MaxOwned = 7, MinBudget = 2000, MaxBudget = 2800, MinSize = 12, MaxSize = 16, MaxT4 = 3, MaxT5 = 1 },
	{ MinOwned = 8, MaxOwned = 12, MinBudget = 3200, MaxBudget = 4200, MinSize = 16, MaxSize = 20, MaxT4 = 4, MaxT5 = 2 }
];
::$bvvar{namespace}.BountyCampThemes <- {};
// Custom melee leaders form the front line; host leader Row=2 would otherwise
// place virtually the whole army behind its ordinary archers.
::$bvvar{namespace}.BountyCampRows <- {};
foreach (group in ["brigands", "nomads", "barbarians", "nobles", "southern", "militia", "mercenaries", "bounty_hunters", "ancients", "orcs"])
	foreach (tier in ["t25", "t4", "t5"]) ::$bvvar{namespace}.BountyCampRows[group + "_" + tier] <- 0;
::$bvvar{namespace}.BountyCampRows.ancients_t4 = 1;
::$bvvar{namespace}.BountyCampRows.bounty_hunters_t4 = 1;
local themes = ::$bvvar{namespace}.BountyCampThemes;
local add = function(id, name, group, faction, brush, battlefield, supports, biome = "any", dlc = null, large = false) {
	themes[id] <- { ID = id, Name = name, Groups = [group], Faction = faction, Brush = brush,
		Battlefield = battlefield, Supports = supports, Biome = biome, DLC = dlc, Large = large,
		BudgetMult = large ? 1.5 : 1.0, Prices = large ? [150, 450, 800] : [60, 150, 300],
		T4Cap = 99, SupportCount = large ? 0 : 3, Champions = [] };
};
add("black_flag", "$bv{bounty.camp.black_flag}", "brigands", "Bandits", "world_bandit_camp_01", "tactical.human_camp", ["BanditMarksman", "BanditRaider"]);
add("desert_raiders", "$bv{bounty.camp.desert_raiders}", "nomads", "OrientalBandits", "world_nomad_camp_02", "tactical.desert_camp", ["NomadArcher", "NomadOutlaw"], "desert", "Desert");
add("frost_warband", "$bv{bounty.camp.frost_warband}", "barbarians", "Barbarians", "world_wildmen_02", "tactical.barbarian_camp", ["BarbarianMarauder"], "north", "Wildmen");
add("rebel_fort", "$bv{bounty.camp.rebel_fort}", "nobles", "Bandits", "world_bandit_camp_01", "tactical.human_camp", ["Billman", "Arbalester", "Footman"]);
add("southern_deserters", "$bv{bounty.camp.southern_deserters}", "southern", "OrientalBandits", "world_nomad_camp_02", "tactical.desert_camp", ["Conscript", "Gunner"], "desert", "Desert");
add("black_contract", "$bv{bounty.camp.black_contract}", "mercenaries", "Bandits", "world_bandit_camp_01", "tactical.human_camp", ["MercenaryRanged", "BountyHunterRanged"]);
add("rotting_graveyard", "$bv{bounty.camp.rotting_graveyard}", "zombies", "Zombies", "world_graveyard_01", "tactical.graveyard", ["Necromancer", "Ghoul"]);
add("ancient_tomb", "$bv{bounty.camp.ancient_tomb}", "ancients", "Undead", "world_ruins_01", "tactical.ruins", ["SkeletonHeavyPolearm", "SkeletonMediumPolearm"]);
add("blood_fang", "$bv{bounty.camp.blood_fang}", "orcs", "Orcs", "world_orc_camp_01", "tactical.orc_camp", ["OrcBerserker", "OrcWarrior"]);
add("poison_thorn", "$bv{bounty.camp.poison_thorn}", "goblins", "Goblins", "world_goblin_camp_01", "tactical.goblin_camp", ["GoblinSkirmisher", "GoblinWolfrider"]);
add("wolf_den", "$bv{bounty.camp.wolf_den}", "direwolves", "Beasts", "world_unhold_graveyard", null, [], "north");
add("hyena_den", "$bv{bounty.camp.hyena_den}", "hyenas", "Beasts", "world_unhold_graveyard", null, [], "desert", "Desert");
add("spider_nest", "$bv{bounty.camp.spider_nest}", "spiders", "Beasts", "world_unhold_graveyard", null, []);
add("serpent_nest", "$bv{bounty.camp.serpent_nest}", "serpents", "Beasts", "world_unhold_graveyard", null, [], "desert", "Desert");
add("unhold_den", "$bv{bounty.camp.unhold_den}", "unholds", "Beasts", "world_cave_01", null, [], "north", "Unhold", true);
add("schrat_grove", "$bv{bounty.camp.schrat_grove}", "schrats", "Beasts", "world_cave_01", null, [], "north", "Unhold", true);
add("lindwurm_den", "$bv{bounty.camp.lindwurm_den}", "lindwurms", "Beasts", "world_unhold_graveyard", null, [], "any", "Lindwurm", true);
themes.rebel_fort.Groups.push("militia");
// Native actors with real makeMiniboss support. Never turn an expanded T4/T5
// actor into a champion or pretend that a beast with Variant=0 is one.
themes.black_flag.Champions = ["BanditLeader", "HedgeKnight"];
themes.desert_raiders.Champions = ["NomadLeader", "Executioner", "DesertDevil"];
themes.frost_warband.Champions = ["BarbarianChampion"];
themes.rebel_fort.Champions = ["Knight", "Swordmaster"];
themes.southern_deserters.Champions = ["Officer", "Executioner"];
themes.black_contract.Champions = ["HedgeKnight", "Swordmaster", "MasterArcher"];
themes.rotting_graveyard.Champions = ["ZombieKnight"];
themes.ancient_tomb.Champions = ["SkeletonHeavy"];
themes.blood_fang.Champions = ["OrcWarlord", "OrcWarrior"];
themes.poison_thorn.Champions = ["GoblinSkirmisher", "GoblinAmbusher"];
themes.black_contract.Groups.push("bounty_hunters");
themes.rotting_graveyard.SupportCount = 2; // At most one necromancer, purchased from the shared T2.5/support allocation.
themes.poison_thorn.T4Cap = 4; // T4 goblins are ranged; their melee T5 uses a separate quota.
themes.poison_thorn.Prices = [60, 210, 330];
themes.black_contract.Prices = [70, 180, 330];
themes.blood_fang.Prices = [90, 190, 350];
themes.black_contract.BudgetMult = 1.2;
themes.poison_thorn.BudgetMult = 1.2;
themes.blood_fang.BudgetMult = 1.3;
themes.rotting_graveyard.BudgetMult = 1.1;
themes.schrat_grove.Prices = [200, 600, 1100];
themes.schrat_grove.BudgetMult = 2.0;
themes.lindwurm_den.Prices = [250, 750, 1400];
themes.lindwurm_den.BudgetMult = 2.5;
foreach (id, theme in themes) if (theme.Supports.len() == 0)
{
	theme.SupportCount = 0;
	theme.Brush = "world_cave_01";
	if (!theme.Large) theme.BudgetMult = 1.1;
}
