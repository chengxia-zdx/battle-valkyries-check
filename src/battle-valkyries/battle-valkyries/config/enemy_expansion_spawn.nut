// Only these host templates can receive custom troops. Compare table identity,
// never localized names, faction IDs, or a substring such as "legend".
::$bvvar{namespace}.ExpandedEnemySpawnConfig <- {
	Version = 2,
	Templates = [
		"BanditRoamers", "BanditScouts", "BanditRaiders", "BanditDefenders", "BanditMarauders",
		"NomadRoamers", "NomadRaiders", "NomadDefenders", "Barbarians", "BarbarianHunters",
		"Noble", "Southern", "Militia", "Mercenaries", "BountyHunters",
		"OrcRoamers", "OrcScouts", "OrcRaiders", "OrcDefenders", "YoungOrcsOnly", "YoungOrcsAndBerserkers", "BerserkersOnly",
		"GoblinRoamers", "GoblinScouts", "GoblinRaiders", "GoblinDefenders", "GreenskinHorde",
		"UndeadArmy", "UndeadScourge", "Zombies", "ZombiesAndGhouls", "ZombiesAndGhosts", "Necromancer", "NecromancerSouthern",
		"ZombiesLight", "ZombiesOrZombiesAndGhosts", "ZombiesOrZombiesAndGhouls",
		"Direwolves", "Hyenas", "Ghouls", "Spiders", "Serpents", "Unhold", "UnholdFrost", "UnholdBog",
		"Alps", "Hexen", "HexenAndMore", "HexenAndNoSpiders", "Schrats", "Lindwurm", "Beasts",
		"BanditArmy", "LegendWhiteDirewolf", "LegendRockUnhold", "LegendSkinGhouls", "LegendRedbackSpider",
		"LegendDemonAlp", "LegendHexeLeader", "LegendGreenwoodSchrat", "LegendStollwurm"
	],
	EliteTemplates = [ "BanditMarauders", "BanditArmy", "GreenskinHorde", "UndeadArmy", "UndeadScourge" ],
	// Fixed bosses, arena, tutorials, holy sites and unreviewed scripted contracts
	// deliberately stay outside this list. Legends' ordinary contract rewrites
	// retain these types and use the same generation adapters.
	Contracts = [
		"drive_away_bandits", "drive_away_barbarians", "drive_away_nomads", "destroy_goblin_camp", "destroy_orc_camp",
		"escort_caravan", "escort_envoy", "defend_settlement_bandits", "defend_settlement_greenskins",
		"hunting_alps", "hunting_hexen", "hunting_lindwurms", "hunting_schrats", "hunting_serpents", "hunting_unholds", "hunting_webknechts",
		"roaming_beasts", "roaming_beasts_desert", "root_out_undead", "investigate_cemetery", "marauding_greenskins",
		"patrol", "intercept_raiding_parties", "raid_caravan", "privateering", "big_game_hunt",
		"legend_hunting_white_direwolf", "legend_hunting_rock_unholds", "legend_hunting_skin_ghouls",
		"legend_hunting_redback_webknechts", "legend_hunting_demon_alps", "legend_hunting_greenwood_schrats",
		"legend_hunting_stollwurms", "legend_hunting_coven_leader", "legend_bandit_army_contract"
	],
	Large = [ "unholds", "schrats", "lindwurms", "flesh_golems" ],
	Control = [ "alps", "hexen" ],
	// Explicit high-threat actors consume one T5 pressure slot each, without
	// ever becoming replacement candidates themselves.
	NativeElites = [
		"enemies/legend_white_direwolf", "enemies/legend_white_direwolf_bodyguard", "enemies/legend_rock_unhold",
		"enemies/legend_redback_spider", "enemies/legend_redback_spider_bodyguard", "enemies/legend_skin_ghoul_high",
		"enemies/legend_greenwood_schrat", "enemies/legend_stollwurm", "enemies/legend_demon_alp", "enemies/legend_hexe_leader",
		"enemies/legend_orc_elite", "enemies/legend_orc_tyrant", "enemies/legend_orc_behemoth", "enemies/legend_orc_mad_berserker",
		"enemies/legend_goblin_witch_doctor", "enemies/legend_goblin_white_direwolf_rider", "enemies/legend_vampire_lord",
		"enemies/legend_robber_baron", "humans/legend_barbarian_runechosen", "humans/barbarian_chosen"
	],
	// Script-observable roles only: no archers, polearm specialists, servants,
	// animals or bodyguards become an unrelated melee leader. Random melee
	// equipment is not a role until the actor is actually created.
	Sources = [
		{ Group = "brigands", Mid = ["enemies/bandit_raider_low", "enemies/bandit_raider", "enemies/legend_bandit_raider_low", "enemies/legend_bandit_raider"], High = ["enemies/bandit_raider", "enemies/bandit_marauder", "enemies/bandit_leader", "enemies/legend_bandit_raider"] },
		{ Group = "nomads", Mid = ["humans/nomad_outlaw"], High = ["humans/nomad_outlaw", "humans/nomad_leader"] },
		{ Group = "barbarians", Mid = ["humans/barbarian_marauder"], High = ["humans/barbarian_champion"] },
		{ Group = "nobles", Mid = ["humans/noble_man_at_arms"], High = ["humans/noble_footman", "humans/noble_sergeant", "humans/knight"], T5 = ["humans/noble_greatsword", "humans/knight"] },
		{ Group = "southern", Mid = ["humans/conscript"], High = ["humans/officer"], T5 = ["humans/conscript", "humans/officer"] },
		{ Group = "militia", Mid = ["humans/militia_veteran"], High = ["humans/militia_veteran", "humans/militia_captain"] },
		{ Group = "mercenaries", Mid = ["humans/mercenary_low"], High = ["humans/mercenary", "humans/hedge_knight"] },
		{ Group = "bounty_hunters", Mid = [], High = ["humans/bounty_hunter_ranged"], T5 = ["humans/bounty_hunter"] },
		{ Group = "zombies", Mid = ["enemies/zombie_yeoman", "enemies/zombie_nomad"], High = ["enemies/zombie_knight"] },
		{ Group = "ancients", Mid = ["enemies/skeleton_medium"], High = ["enemies/skeleton_heavy"] },
		{ Group = "flesh_golems", Mid = ["enemies/lesser_flesh_golem"], High = ["enemies/greater_flesh_golem"] },
		{ Group = "orcs", Mid = ["enemies/orc_warrior_low"], High = ["enemies/orc_warrior", "enemies/orc_warlord"] },
		{ Group = "goblins", Mid = ["enemies/goblin_fighter_low"], High = ["enemies/goblin_ambusher"], T5 = ["enemies/goblin_leader"] },
		{ Group = "direwolves", Mid = ["enemies/direwolf"], High = ["enemies/direwolf_high"] },
		{ Group = "hyenas", Mid = ["enemies/hyena"], High = ["enemies/hyena_high"] },
		{ Group = "ghouls", Mid = ["enemies/ghoul_medium"], High = ["enemies/ghoul_high"] },
		{ Group = "spiders", Mid = [], High = ["enemies/spider"] },
		{ Group = "serpents", Mid = [], High = ["enemies/serpent"] },
		{ Group = "unholds", Mid = ["enemies/unhold", "enemies/unhold_bog"], High = ["enemies/unhold", "enemies/unhold_bog", "enemies/unhold_frost"] },
		{ Group = "alps", Mid = [], High = ["enemies/alp"] },
		{ Group = "hexen", Mid = [], High = ["enemies/hexe"] },
		{ Group = "schrats", Mid = [], High = ["enemies/schrat"] },
		{ Group = "lindwurms", Mid = [], High = ["enemies/lindwurm"] }
	]
};
