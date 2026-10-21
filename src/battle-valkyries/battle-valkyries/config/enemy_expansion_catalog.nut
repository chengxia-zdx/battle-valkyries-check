// Shared test/natural roster. Natural generation uses explicit source adapters;
// these definitions are never inserted into the host global spawn tables.
::$bvvar{namespace}.ExpandedEnemyTiers <- {
	t25 = { Hitpoints = 0.81, Damage = 0.90, Attack = -8, Defense = -5 }
};
// T4/T5 use per-unit profiles in enemy_expansion_combat.nut.

::$bvvar{namespace}.ExpandedEnemyGroups <- [
	{ ID = "brigands", Label = "$bv{enemy_expansion.group.brigands}", Action = "$bv{enemy_expansion.action.brigands}", Enemies = [
		{ Key = "brigands_t25", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.brigands_t25}", Tier = "t25", Troop = "BanditLeader", Art = "bust_bv_enemy_brigands_t25", DeathArt = "bust_bv_enemy_brigands_t25_dead" },
		{ Key = "brigands_t4", VisualScale = 1.0, LiveOffsetY = -16, Name = "$bv{enemy_expansion.enemy.brigands_t4}", Tier = "t4", Troop = "BanditLeader", Art = "bust_bv_enemy_brigands_t4", DeathArt = "bust_bv_enemy_brigands_t4_dead" },
		{ Key = "brigands_t5", VisualScale = 1.0, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.brigands_t5}", Tier = "t5", Troop = "BanditLeader", Art = "bust_bv_enemy_brigands_t5", DeathArt = "bust_bv_enemy_brigands_t5_dead" },
	] },
	{ ID = "nomads", Label = "$bv{enemy_expansion.group.nomads}", Action = "$bv{enemy_expansion.action.nomads}", Enemies = [
		{ Key = "nomads_t25", VisualScale = 1.0, LiveOffsetY = -9, Name = "$bv{enemy_expansion.enemy.nomads_t25}", Tier = "t25", Troop = "NomadLeader", Art = "bust_bv_enemy_nomads_t25", DeathArt = "bust_bv_enemy_nomads_t25_dead" },
		{ Key = "nomads_t4", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.nomads_t4}", Tier = "t4", Troop = "NomadLeader", Art = "bust_bv_enemy_nomads_t4", DeathArt = "bust_bv_enemy_nomads_t4_dead" },
		{ Key = "nomads_t5", VisualScale = 1.0, LiveOffsetY = 0, Name = "$bv{enemy_expansion.enemy.nomads_t5}", Tier = "t5", Troop = "NomadLeader", Art = "bust_bv_enemy_nomads_t5", DeathArt = "bust_bv_enemy_nomads_t5_dead" },
	] },
	{ ID = "barbarians", Label = "$bv{enemy_expansion.group.barbarians}", Action = "$bv{enemy_expansion.action.barbarians}", Enemies = [
		{ Key = "barbarians_t25", VisualScale = 1.0, LiveOffsetY = -16, Name = "$bv{enemy_expansion.enemy.barbarians_t25}", Tier = "t25", Troop = "BarbarianChampion", Art = "bust_bv_enemy_barbarians_t25", DeathArt = "bust_bv_enemy_barbarians_t25_dead" },
		{ Key = "barbarians_t4", VisualScale = 1.0, LiveOffsetY = -17, Name = "$bv{enemy_expansion.enemy.barbarians_t4}", Tier = "t4", Troop = "BarbarianChampion", Art = "bust_bv_enemy_barbarians_t4", DeathArt = "bust_bv_enemy_barbarians_t4_dead" },
		{ Key = "barbarians_t5", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.barbarians_t5}", Tier = "t5", Troop = "BarbarianChampion", Art = "bust_bv_enemy_barbarians_t5", DeathArt = "bust_bv_enemy_barbarians_t5_dead" },
	] },
	{ ID = "nobles", Label = "$bv{enemy_expansion.group.nobles}", Action = "$bv{enemy_expansion.action.nobles}", Enemies = [
		{ Key = "nobles_t25", VisualScale = 1.0, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.nobles_t25}", Tier = "t25", Troop = "Knight", Art = "bust_bv_enemy_nobles_t25", DeathArt = "bust_bv_enemy_nobles_t25_dead" },
		{ Key = "nobles_t4", VisualScale = 1.0, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.nobles_t4}", Tier = "t4", Troop = "Knight", Art = "bust_bv_enemy_nobles_t4", DeathArt = "bust_bv_enemy_nobles_t4_dead" },
		{ Key = "nobles_t5", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.nobles_t5}", Tier = "t5", Troop = "Knight", Art = "bust_bv_enemy_nobles_t5", DeathArt = "bust_bv_enemy_nobles_t5_dead" },
	] },
	{ ID = "southern", Label = "$bv{enemy_expansion.group.southern}", Action = "$bv{enemy_expansion.action.southern}", Enemies = [
		{ Key = "southern_t25", VisualScale = 1.0, LiveOffsetY = -8, Name = "$bv{enemy_expansion.enemy.southern_t25}", Tier = "t25", Troop = "Officer", Art = "bust_bv_enemy_southern_t25", DeathArt = "bust_bv_enemy_southern_t25_dead" },
		{ Key = "southern_t4", VisualScale = 1.0, LiveOffsetY = -15, Name = "$bv{enemy_expansion.enemy.southern_t4}", Tier = "t4", Troop = "Officer", Art = "bust_bv_enemy_southern_t4", DeathArt = "bust_bv_enemy_southern_t4_dead" },
		{ Key = "southern_t5", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.southern_t5}", Tier = "t5", Troop = "Officer", Art = "bust_bv_enemy_southern_t5", DeathArt = "bust_bv_enemy_southern_t5_dead" },
	] },
	{ ID = "militia", Label = "$bv{enemy_expansion.group.militia}", Action = "$bv{enemy_expansion.action.militia}", Enemies = [
		{ Key = "militia_t25", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.militia_t25}", Tier = "t25", Troop = "MilitiaCaptain", Art = "bust_bv_enemy_militia_t25", DeathArt = "bust_bv_enemy_militia_t25_dead" },
		{ Key = "militia_t4", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.militia_t4}", Tier = "t4", Troop = "MilitiaCaptain", Art = "bust_bv_enemy_militia_t4", DeathArt = "bust_bv_enemy_militia_t4_dead" },
		{ Key = "militia_t5", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.militia_t5}", Tier = "t5", Troop = "MilitiaCaptain", Art = "bust_bv_enemy_militia_t5", DeathArt = "bust_bv_enemy_militia_t5_dead" },
	] },
	{ ID = "mercenaries", Label = "$bv{enemy_expansion.group.mercenaries}", Action = "$bv{enemy_expansion.action.mercenaries}", Enemies = [
		{ Key = "mercenaries_t25", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.mercenaries_t25}", Tier = "t25", Troop = "HedgeKnight", Art = "bust_bv_enemy_mercenaries_t25", DeathArt = "bust_bv_enemy_mercenaries_t25_dead" },
		{ Key = "mercenaries_t4", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.mercenaries_t4}", Tier = "t4", Troop = "HedgeKnight", Art = "bust_bv_enemy_mercenaries_t4", DeathArt = "bust_bv_enemy_mercenaries_t4_dead" },
		{ Key = "mercenaries_t5", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.mercenaries_t5}", Tier = "t5", Troop = "HedgeKnight", Art = "bust_bv_enemy_mercenaries_t5", DeathArt = "bust_bv_enemy_mercenaries_t5_dead" },
	] },
	{ ID = "bounty_hunters", Label = "$bv{enemy_expansion.group.bounty_hunters}", Action = "$bv{enemy_expansion.action.bounty_hunters}", Enemies = [
		{ Key = "bounty_hunters_t25", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.bounty_hunters_t25}", Tier = "t25", Troop = "BountyHunter", Art = "bust_bv_enemy_bounty_hunters_t25", DeathArt = "bust_bv_enemy_bounty_hunters_t25_dead" },
		{ Key = "bounty_hunters_t4", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.bounty_hunters_t4}", Tier = "t4", Troop = "BountyHunterRanged", Art = "bust_bv_enemy_bounty_hunters_t4", DeathArt = "bust_bv_enemy_bounty_hunters_t4_dead" },
		{ Key = "bounty_hunters_t5", VisualScale = 1.0, LiveOffsetY = -6, Name = "$bv{enemy_expansion.enemy.bounty_hunters_t5}", Tier = "t5", Troop = "BountyHunter", Art = "bust_bv_enemy_bounty_hunters_t5", DeathArt = "bust_bv_enemy_bounty_hunters_t5_dead" },
	] },
	{ ID = "zombies", Label = "$bv{enemy_expansion.group.zombies}", Action = "$bv{enemy_expansion.action.zombies}", Enemies = [
		{ Key = "zombies_t25", VisualScale = 1.0, LiveOffsetY = -8, Name = "$bv{enemy_expansion.enemy.zombies_t25}", Tier = "t25", Troop = "ZombieKnight", Art = "bust_bv_enemy_zombies_t25", DeathArt = "bust_bv_enemy_zombies_t25_dead" },
		{ Key = "zombies_t4", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.zombies_t4}", Tier = "t4", Troop = "ZombieKnight", Art = "bust_bv_enemy_zombies_t4", DeathArt = "bust_bv_enemy_zombies_t4_dead" },
		{ Key = "zombies_t5", VisualScale = 1.0, LiveOffsetY = -1, Name = "$bv{enemy_expansion.enemy.zombies_t5}", Tier = "t5", Troop = "ZombieKnight", Art = "bust_bv_enemy_zombies_t5", DeathArt = "bust_bv_enemy_zombies_t5_dead" },
	] },
	{ ID = "ancients", Label = "$bv{enemy_expansion.group.ancients}", Action = "$bv{enemy_expansion.action.ancients}", Enemies = [
		{ Key = "ancients_t25", VisualScale = 1.0, LiveOffsetY = -4, Name = "$bv{enemy_expansion.enemy.ancients_t25}", Tier = "t25", Troop = "SkeletonHeavy", Art = "bust_bv_enemy_ancients_t25", DeathArt = "bust_bv_enemy_ancients_t25_dead" },
		{ Key = "ancients_t4", VisualScale = 1.0, LiveOffsetY = -2, Name = "$bv{enemy_expansion.enemy.ancients_t4}", Tier = "t4", Troop = "SkeletonHeavy", Art = "bust_bv_enemy_ancients_t4", DeathArt = "bust_bv_enemy_ancients_t4_dead" },
		{ Key = "ancients_t5", VisualScale = 1.0, LiveOffsetY = 1, Name = "$bv{enemy_expansion.enemy.ancients_t5}", Tier = "t5", Troop = "SkeletonHeavy", Art = "bust_bv_enemy_ancients_t5", DeathArt = "bust_bv_enemy_ancients_t5_dead" },
	] },
	{ ID = "flesh_golems", Label = "$bv{enemy_expansion.group.flesh_golems}", Action = "$bv{enemy_expansion.action.flesh_golems}", Enemies = [
		{ Key = "flesh_golems_t25", VisualScale = 1.3, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.flesh_golems_t25}", Tier = "t25", Troop = "GreaterFleshGolem", Art = "bust_bv_enemy_flesh_golems_t25", DeathArt = "bust_bv_enemy_flesh_golems_t25_dead" },
		{ Key = "flesh_golems_t4", VisualScale = 1.3, LiveOffsetY = -14, Name = "$bv{enemy_expansion.enemy.flesh_golems_t4}", Tier = "t4", Troop = "GreaterFleshGolem", Art = "bust_bv_enemy_flesh_golems_t4", DeathArt = "bust_bv_enemy_flesh_golems_t4_dead" },
		{ Key = "flesh_golems_t5", VisualScale = 1.3, LiveOffsetY = -5, Name = "$bv{enemy_expansion.enemy.flesh_golems_t5}", Tier = "t5", Troop = "GreaterFleshGolem", Art = "bust_bv_enemy_flesh_golems_t5", DeathArt = "bust_bv_enemy_flesh_golems_t5_dead" },
	] },
	{ ID = "orcs", Label = "$bv{enemy_expansion.group.orcs}", Action = "$bv{enemy_expansion.action.orcs}", Enemies = [
		{ Key = "orcs_t25", VisualScale = 1.15, LiveOffsetY = -14, Name = "$bv{enemy_expansion.enemy.orcs_t25}", Tier = "t25", Troop = "OrcWarlord", Art = "bust_bv_enemy_orcs_t25", DeathArt = "bust_bv_enemy_orcs_t25_dead" },
		{ Key = "orcs_t4", VisualScale = 1.15, LiveOffsetY = -13, Name = "$bv{enemy_expansion.enemy.orcs_t4}", Tier = "t4", Troop = "OrcWarlord", Art = "bust_bv_enemy_orcs_t4", DeathArt = "bust_bv_enemy_orcs_t4_dead" },
		{ Key = "orcs_t5", VisualScale = 1.15, LiveOffsetY = -13, Name = "$bv{enemy_expansion.enemy.orcs_t5}", Tier = "t5", Troop = "OrcWarlord", Art = "bust_bv_enemy_orcs_t5", DeathArt = "bust_bv_enemy_orcs_t5_dead" },
	] },
	{ ID = "goblins", Label = "$bv{enemy_expansion.group.goblins}", Action = "$bv{enemy_expansion.action.goblins}", Enemies = [
		{ Key = "goblins_t25", VisualScale = 0.85, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.goblins_t25}", Tier = "t25", Troop = "GoblinSkirmisher", Art = "bust_bv_enemy_goblins_t25", DeathArt = "bust_bv_enemy_goblins_t25_dead" },
		{ Key = "goblins_t4", VisualScale = 0.85, LiveOffsetY = -5, Name = "$bv{enemy_expansion.enemy.goblins_t4}", Tier = "t4", Troop = "GoblinAmbusher", Art = "bust_bv_enemy_goblins_t4", DeathArt = "bust_bv_enemy_goblins_t4_dead" },
		{ Key = "goblins_t5", VisualScale = 0.85, LiveOffsetY = -6, Name = "$bv{enemy_expansion.enemy.goblins_t5}", Tier = "t5", Troop = "GoblinOverseer", Art = "bust_bv_enemy_goblins_t5", DeathArt = "bust_bv_enemy_goblins_t5_dead" },
	] },
	{ ID = "direwolves", Label = "$bv{enemy_expansion.group.direwolves}", Action = "$bv{enemy_expansion.action.direwolves}", Enemies = [
		{ Key = "direwolves_t25", VisualScale = 1.0, LiveOffsetY = -2, Name = "$bv{enemy_expansion.enemy.direwolves_t25}", Tier = "t25", Troop = "DirewolfHIGH", Art = "bust_bv_enemy_direwolves_t25", DeathArt = "bust_bv_enemy_direwolves_t25_dead" },
		{ Key = "direwolves_t4", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.direwolves_t4}", Tier = "t4", Troop = "DirewolfHIGH", Art = "bust_bv_enemy_direwolves_t4", DeathArt = "bust_bv_enemy_direwolves_t4_dead" },
		{ Key = "direwolves_t5", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.direwolves_t5}", Tier = "t5", Troop = "DirewolfHIGH", Art = "bust_bv_enemy_direwolves_t5", DeathArt = "bust_bv_enemy_direwolves_t5_dead" },
	] },
	{ ID = "hyenas", Label = "$bv{enemy_expansion.group.hyenas}", Action = "$bv{enemy_expansion.action.hyenas}", Enemies = [
		{ Key = "hyenas_t25", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.hyenas_t25}", Tier = "t25", Troop = "HyenaHIGH", Art = "bust_bv_enemy_hyenas_t25", DeathArt = "bust_bv_enemy_hyenas_t25_dead" },
		{ Key = "hyenas_t4", VisualScale = 1.0, LiveOffsetY = -10, Name = "$bv{enemy_expansion.enemy.hyenas_t4}", Tier = "t4", Troop = "HyenaHIGH", Art = "bust_bv_enemy_hyenas_t4", DeathArt = "bust_bv_enemy_hyenas_t4_dead" },
		{ Key = "hyenas_t5", VisualScale = 1.0, LiveOffsetY = -4, Name = "$bv{enemy_expansion.enemy.hyenas_t5}", Tier = "t5", Troop = "HyenaHIGH", Art = "bust_bv_enemy_hyenas_t5", DeathArt = "bust_bv_enemy_hyenas_t5_dead" },
	] },
	{ ID = "spiders", Label = "$bv{enemy_expansion.group.spiders}", Action = "$bv{enemy_expansion.action.spiders}", Enemies = [
		{ Key = "spiders_t25", VisualScale = 1.0, LiveOffsetY = -36, Name = "$bv{enemy_expansion.enemy.spiders_t25}", Tier = "t25", Troop = "Spider", Art = "bust_bv_enemy_spiders_t25", DeathArt = "bust_bv_enemy_spiders_t25_dead" },
		{ Key = "spiders_t4", VisualScale = 1.0, LiveOffsetY = -32, Name = "$bv{enemy_expansion.enemy.spiders_t4}", Tier = "t4", Troop = "Spider", Art = "bust_bv_enemy_spiders_t4", DeathArt = "bust_bv_enemy_spiders_t4_dead" },
		{ Key = "spiders_t5", VisualScale = 1.0, LiveOffsetY = -24, Name = "$bv{enemy_expansion.enemy.spiders_t5}", Tier = "t5", Troop = "Spider", Art = "bust_bv_enemy_spiders_t5", DeathArt = "bust_bv_enemy_spiders_t5_dead" },
	] },
	{ ID = "ghouls", Label = "$bv{enemy_expansion.group.ghouls}", Action = "$bv{enemy_expansion.action.ghouls}", Enemies = [
		{ Key = "ghouls_t25", VisualScale = 1.2, LiveOffsetY = -29, Name = "$bv{enemy_expansion.enemy.ghouls_t25}", Tier = "t25", Troop = "GhoulHIGH", Art = "bust_bv_enemy_ghouls_t25", DeathArt = "bust_bv_enemy_ghouls_t25_dead" },
		{ Key = "ghouls_t4", VisualScale = 1.2, LiveOffsetY = -28, Name = "$bv{enemy_expansion.enemy.ghouls_t4}", Tier = "t4", Troop = "GhoulHIGH", Art = "bust_bv_enemy_ghouls_t4", DeathArt = "bust_bv_enemy_ghouls_t4_dead" },
		{ Key = "ghouls_t5", VisualScale = 1.2, LiveOffsetY = -24, Name = "$bv{enemy_expansion.enemy.ghouls_t5}", Tier = "t5", Troop = "GhoulHIGH", Art = "bust_bv_enemy_ghouls_t5", DeathArt = "bust_bv_enemy_ghouls_t5_dead" },
	] },
	{ ID = "serpents", Label = "$bv{enemy_expansion.group.serpents}", Action = "$bv{enemy_expansion.action.serpents}", Enemies = [
		{ Key = "serpents_t25", VisualScale = 1.0, LiveOffsetY = -2, Name = "$bv{enemy_expansion.enemy.serpents_t25}", Tier = "t25", Troop = "Serpent", Art = "bust_bv_enemy_serpents_t25", DeathArt = "bust_bv_enemy_serpents_t25_dead" },
		{ Key = "serpents_t4", VisualScale = 1.0, LiveOffsetY = -4, Name = "$bv{enemy_expansion.enemy.serpents_t4}", Tier = "t4", Troop = "Serpent", Art = "bust_bv_enemy_serpents_t4", DeathArt = "bust_bv_enemy_serpents_t4_dead" },
		{ Key = "serpents_t5", VisualScale = 1.0, LiveOffsetY = 0, Name = "$bv{enemy_expansion.enemy.serpents_t5}", Tier = "t5", Troop = "Serpent", Art = "bust_bv_enemy_serpents_t5", DeathArt = "bust_bv_enemy_serpents_t5_dead" },
	] },
	{ ID = "unholds", Label = "$bv{enemy_expansion.group.unholds}", Action = "$bv{enemy_expansion.action.unholds}", Enemies = [
		{ Key = "unholds_t25", VisualScale = 1.3, LiveOffsetY = -36, Name = "$bv{enemy_expansion.enemy.unholds_t25}", Tier = "t25", Troop = "UnholdFrost", Art = "bust_bv_enemy_unholds_t25", DeathArt = "bust_bv_enemy_unholds_t25_dead" },
		{ Key = "unholds_t4", VisualScale = 1.3, LiveOffsetY = -25, Name = "$bv{enemy_expansion.enemy.unholds_t4}", Tier = "t4", Troop = "UnholdFrost", Art = "bust_bv_enemy_unholds_t4", DeathArt = "bust_bv_enemy_unholds_t4_dead" },
		{ Key = "unholds_t5", VisualScale = 1.3, LiveOffsetY = -27, Name = "$bv{enemy_expansion.enemy.unholds_t5}", Tier = "t5", Troop = "UnholdFrost", Art = "bust_bv_enemy_unholds_t5", DeathArt = "bust_bv_enemy_unholds_t5_dead" },
	] },
	{ ID = "alps", Label = "$bv{enemy_expansion.group.alps}", Action = "$bv{enemy_expansion.action.alps}", Enemies = [
		{ Key = "alps_t25", VisualScale = 1.0, LiveOffsetY = -3, Name = "$bv{enemy_expansion.enemy.alps_t25}", Tier = "t25", Troop = "Alp", Art = "bust_bv_enemy_alps_t25", DeathArt = "bust_bv_enemy_alps_t25_dead" },
		{ Key = "alps_t4", VisualScale = 1.0, LiveOffsetY = -3, Name = "$bv{enemy_expansion.enemy.alps_t4}", Tier = "t4", Troop = "Alp", Art = "bust_bv_enemy_alps_t4", DeathArt = "bust_bv_enemy_alps_t4_dead" },
		{ Key = "alps_t5", VisualScale = 1.0, LiveOffsetY = 0, Name = "$bv{enemy_expansion.enemy.alps_t5}", Tier = "t5", Troop = "Alp", Art = "bust_bv_enemy_alps_t5", DeathArt = "bust_bv_enemy_alps_t5_dead" },
	] },
	{ ID = "hexen", Label = "$bv{enemy_expansion.group.hexen}", Action = "$bv{enemy_expansion.action.hexen}", Enemies = [
		{ Key = "hexen_t25", VisualScale = 1.0, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.hexen_t25}", Tier = "t25", Troop = "Hexe", Art = "bust_bv_enemy_hexen_t25", DeathArt = "bust_bv_enemy_hexen_t25_dead" },
		{ Key = "hexen_t4", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.hexen_t4}", Tier = "t4", Troop = "Hexe", Art = "bust_bv_enemy_hexen_t4", DeathArt = "bust_bv_enemy_hexen_t4_dead" },
		{ Key = "hexen_t5", VisualScale = 1.0, LiveOffsetY = -2, Name = "$bv{enemy_expansion.enemy.hexen_t5}", Tier = "t5", Troop = "Hexe", Art = "bust_bv_enemy_hexen_t5", DeathArt = "bust_bv_enemy_hexen_t5_dead" },
	] },
	{ ID = "sand_golems", Label = "$bv{enemy_expansion.group.sand_golems}", Action = "$bv{enemy_expansion.action.sand_golems}", Enemies = [
		{ Key = "sand_golems_t25", VisualScale = 1.2, LiveOffsetY = -22, Name = "$bv{enemy_expansion.enemy.sand_golems_t25}", Tier = "t25", Troop = "SandGolemHIGH", Art = "bust_bv_enemy_sand_golems_t25", DeathArt = "bust_bv_enemy_sand_golems_t25_dead" },
		{ Key = "sand_golems_t4", VisualScale = 1.2, LiveOffsetY = -3, Name = "$bv{enemy_expansion.enemy.sand_golems_t4}", Tier = "t4", Troop = "SandGolemHIGH", Art = "bust_bv_enemy_sand_golems_t4", DeathArt = "bust_bv_enemy_sand_golems_t4_dead" },
		{ Key = "sand_golems_t5", VisualScale = 1.2, LiveOffsetY = 2, Name = "$bv{enemy_expansion.enemy.sand_golems_t5}", Tier = "t5", Troop = "SandGolemHIGH", Art = "bust_bv_enemy_sand_golems_t5", DeathArt = "bust_bv_enemy_sand_golems_t5_dead" },
	] },
	{ ID = "schrats", Label = "$bv{enemy_expansion.group.schrats}", Action = "$bv{enemy_expansion.action.schrats}", Enemies = [
		{ Key = "schrats_t25", VisualScale = 1.3, LiveOffsetY = -3, Name = "$bv{enemy_expansion.enemy.schrats_t25}", Tier = "t25", Troop = "Schrat", Art = "bust_bv_enemy_schrats_t25", DeathArt = "bust_bv_enemy_schrats_t25_dead" },
		{ Key = "schrats_t4", VisualScale = 1.3, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.schrats_t4}", Tier = "t4", Troop = "Schrat", Art = "bust_bv_enemy_schrats_t4", DeathArt = "bust_bv_enemy_schrats_t4_dead" },
		{ Key = "schrats_t5", VisualScale = 1.3, LiveOffsetY = 7, Name = "$bv{enemy_expansion.enemy.schrats_t5}", Tier = "t5", Troop = "Schrat", Art = "bust_bv_enemy_schrats_t5", DeathArt = "bust_bv_enemy_schrats_t5_dead" },
	] },
	{ ID = "lindwurms", Label = "$bv{enemy_expansion.group.lindwurms}", Action = "$bv{enemy_expansion.action.lindwurms}", Enemies = [
		{ Key = "lindwurms_t25", VisualScale = 1.4, LiveOffsetY = 8, Name = "$bv{enemy_expansion.enemy.lindwurms_t25}", Tier = "t25", Troop = "Lindwurm", Art = "bust_bv_enemy_lindwurms_t25", DeathArt = "bust_bv_enemy_lindwurms_t25_dead" },
		{ Key = "lindwurms_t4", VisualScale = 1.4, LiveOffsetY = 1, Name = "$bv{enemy_expansion.enemy.lindwurms_t4}", Tier = "t4", Troop = "Lindwurm", Art = "bust_bv_enemy_lindwurms_t4", DeathArt = "bust_bv_enemy_lindwurms_t4_dead" },
		{ Key = "lindwurms_t5", VisualScale = 1.4, LiveOffsetY = 7, Name = "$bv{enemy_expansion.enemy.lindwurms_t5}", Tier = "t5", Troop = "Lindwurm", Art = "bust_bv_enemy_lindwurms_t5", DeathArt = "bust_bv_enemy_lindwurms_t5_dead" },
	] },
	{ ID = "cultists", Label = "$bv{enemy_expansion.group.cultists}", Action = "$bv{enemy_expansion.action.cultists}", Enemies = [
		{ Key = "cultists_t4", VisualScale = 1.0, LiveOffsetY = -7, Name = "$bv{enemy_expansion.enemy.cultists_t4}", Tier = "t4", Troop = "Cultist", Art = "bust_bv_enemy_cultists_t4", DeathArt = "bust_bv_enemy_cultists_t4_dead" },
		{ Key = "cultists_t5", VisualScale = 1.0, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.cultists_t5}", Tier = "t5", Troop = "Cultist", Art = "bust_bv_enemy_cultists_t5", DeathArt = "bust_bv_enemy_cultists_t5_dead" },
	] },
	{ ID = "gladiators", Label = "$bv{enemy_expansion.group.gladiators}", Action = "$bv{enemy_expansion.action.gladiators}", Enemies = [
		{ Key = "gladiators_t4", VisualScale = 1.0, LiveOffsetY = -15, Name = "$bv{enemy_expansion.enemy.gladiators_t4}", Tier = "t4", Troop = "Gladiator", Art = "bust_bv_enemy_gladiators_t4", DeathArt = "bust_bv_enemy_gladiators_t4_dead" },
		{ Key = "gladiators_t5", VisualScale = 1.0, LiveOffsetY = -14, Name = "$bv{enemy_expansion.enemy.gladiators_t5}", Tier = "t5", Troop = "Gladiator", Art = "bust_bv_enemy_gladiators_t5", DeathArt = "bust_bv_enemy_gladiators_t5_dead" },
	] },
	{ ID = "oathbringers", Label = "$bv{enemy_expansion.group.oathbringers}", Action = "$bv{enemy_expansion.action.oathbringers}", Enemies = [
		{ Key = "oathbringers_t4", VisualScale = 1.0, LiveOffsetY = -12, Name = "$bv{enemy_expansion.enemy.oathbringers_t4}", Tier = "t4", Troop = "Oathbringer", Art = "bust_bv_enemy_oathbringers_t4", DeathArt = "bust_bv_enemy_oathbringers_t4_dead" },
		{ Key = "oathbringers_t5", VisualScale = 1.0, LiveOffsetY = -11, Name = "$bv{enemy_expansion.enemy.oathbringers_t5}", Tier = "t5", Troop = "Oathbringer", Art = "bust_bv_enemy_oathbringers_t5", DeathArt = "bust_bv_enemy_oathbringers_t5_dead" },
	] },
];
