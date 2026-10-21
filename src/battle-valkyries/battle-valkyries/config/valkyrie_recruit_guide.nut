// Source-reviewed BB recruitment assessments, 2026-10-12. No optional equipment system.
// Priorities: 3 first pick, 2 recommended, 1 conditional, 0 defer. Ratings compare role contribution.
// Startup uses actual recruit level/gear; maturity includes explicitly described personal growth.
// All roles are peers: a character can match every configured role, including banner bearer.
// Stage is a preferred recruitment window, not an unlock level or an eligibility override.
// Early = scarce resources; mid = established core; late = specialized team completion.
// S/A/B/C describe outstanding/strong/conditional/low-return contribution within the role.
// Compare startup at actual recruitment unlocks plus the same ordinary-gear budget;
// compare maturity at level 11 with ordinary gear and the named personal progression.
// Hit chance, shield defense, cover, remaining armor, AP and fatigue remain BB constraints.
// Sources and ReviewedSkills document the review; re-review numbers and runtime changes
// manually even when the skill keys do not change. These are estimates, not measured DPS.
::$bvvar{namespace}.ValkyrieRecruitGuideVersion <- "2026-10-12";
::$bvvar{namespace}.ValkyrieRecruitGuideLabels <- {
	role = { guard = "$bv{ui.hub.guide.role.guard}", warrior = "$bv{ui.hub.guide.role.warrior}", middle = "$bv{ui.hub.guide.role.middle}", ranged = "$bv{ui.hub.guide.role.ranged}", mage = "$bv{ui.hub.guide.role.mage}", mobile = "$bv{ui.hub.guide.role.mobile}", healer = "$bv{ui.hub.guide.role.healer}", control = "$bv{ui.hub.guide.role.control}", banner = "$bv{ui.hub.guide.role.banner}" },
	stage = { early = "$bv{ui.hub.guide.stage.early}", mid = "$bv{ui.hub.guide.stage.mid}", late = "$bv{ui.hub.guide.stage.late}", conditional = "$bv{ui.hub.guide.stage.conditional}" },
	investment = { low = "$bv{ui.hub.guide.investment.low}", medium = "$bv{ui.hub.guide.investment.medium}", high = "$bv{ui.hub.guide.investment.high}" },
	tag = { weapon_free = "$bv{ui.hub.guide.tag.weapon_free}", signature = "$bv{ui.hub.guide.tag.signature}", area = "$bv{ui.hub.guide.tag.area}", armor = "$bv{ui.hub.guide.tag.armor}", sustain = "$bv{ui.hub.guide.tag.sustain}", healing = "$bv{ui.hub.guide.tag.healing}", protection = "$bv{ui.hub.guide.tag.protection}", team = "$bv{ui.hub.guide.tag.team}", growth = "$bv{ui.hub.guide.tag.growth}", ap = "$bv{ui.hub.guide.tag.ap}", mobility = "$bv{ui.hub.guide.tag.mobility}", control = "$bv{ui.hub.guide.tag.control}" },
	priority = { ["3"] = "$bv{ui.hub.guide.priority.3}", ["2"] = "$bv{ui.hub.guide.priority.2}", ["1"] = "$bv{ui.hub.guide.priority.1}", ["0"] = "$bv{ui.hub.guide.priority.0}" },
};
::$bvvar{namespace}.ValkyrieRecruitGuides <- {
	abigail_williams = {
		Roles = ["mage", "control"], Stage = "early", Investment = "low", Startup = "A", Mature = "A",
		Priorities = { early = 3, mid = 2, late = 2 }, Tags = ["weapon_free", "area", "control"],
		Summary = "$bv{ui.hub.guide.abigail_williams.summary}", Analysis = "$bv{ui.hub.guide.abigail_williams.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/abigail_outer_realm_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/abigail_witchcraft_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/abigail_williams_trait.nut"],
		ReviewedSkills = ["abigail_outer_realm", "abigail_root_touch", "abigail_faithful_prayer", "abigail_mass_hysteria", "abigail_witch_trial", "abigail_qliphoth_rhizome"]
	},
	katsushika_hokusai = {
		Roles = ["mage", "control"], Stage = "early", Investment = "low", Startup = "A", Mature = "A",
		Priorities = { early = 3, mid = 2, late = 2 }, Tags = ["weapon_free", "area", "sustain", "control"],
		Summary = "$bv{ui.hub.guide.katsushika_hokusai.summary}", Analysis = "$bv{ui.hub.guide.katsushika_hokusai.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/hokusai_painting_mania_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/hokusai_painting_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/katsushika_hokusai_trait.nut"],
		ReviewedSkills = ["hokusai_painting_mania", "hokusai_brushstroke", "hokusai_all_things_in_nature", "hokusai_father_daughter_bond", "hokusai_alien_octopus", "hokusai_thirty_six_views"]
	},
	c_c = {
		Roles = ["control", "guard"], Stage = "conditional", Investment = "low", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["healing", "protection", "team", "control"],
		Summary = "$bv{ui.hub.guide.c_c.summary}", Analysis = "$bv{ui.hub.guide.c_c.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/c_c_immortal_witch_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/c_c_accomplice_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/c_c_contract_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/c_c_trait.nut"],
		ReviewedSkills = ["c_c_immortal_witch", "c_c_accomplice", "c_c_geass_contract", "c_c_shock_image", "c_c_unfinished_contract"]
	},
	enterprise = {
		Roles = ["ranged"], Stage = "early", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 2 }, Tags = ["signature", "area", "armor", "protection"],
		Summary = "$bv{ui.hub.guide.enterprise.summary}", Analysis = "$bv{ui.hub.guide.enterprise.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/enterprise_white_eagle_airwing_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/enterprise_lucky_e_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/enterprise_eagle_guidance_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/enterprise_airstrike_skill.nut", "src/battle-valkyries/battle-valkyries/hooks/valkyrie_summon.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/enterprise_trait.nut"],
		ReviewedSkills = ["enterprise_white_eagle_airwing", "enterprise_lucky_e", "enterprise_eagle_guidance", "enterprise_dauntless_dive", "enterprise_carrier_strafe", "enterprise_decisive_airwing"]
	},
	togawa_sakiko = {
		Roles = ["control", "healer"], Stage = "mid", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["team", "ap", "control"],
		Summary = "$bv{ui.hub.guide.togawa_sakiko.summary}", Analysis = "$bv{ui.hub.guide.togawa_sakiko.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/togawa_sakiko_ensemble_stage_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/togawa_sakiko_full_moon_dance_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/togawa_sakiko_crescent_echo_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/togawa_sakiko_trait.nut"],
		ReviewedSkills = ["togawa_sakiko_ensemble_stage", "togawa_sakiko_full_moon_dance", "togawa_sakiko_crescent_echo"]
	},
	m4a1 = {
		Roles = ["ranged", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["signature", "area", "armor", "sustain", "control"],
		Summary = "$bv{ui.hub.guide.m4a1.summary}", Analysis = "$bv{ui.hub.guide.m4a1.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/m4a1_ar_commander_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/m4a1_inheritor_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/m4a1_fire_control_skill.nut", "src/battle-valkyries/battle-valkyries/hooks/valkyrie_summon.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/m4a1_trait.nut"],
		ReviewedSkills = ["m4a1_ar_commander", "m4a1_inheritor", "m4a1_tactical_shot", "m4a1_three_round_burst", "m4a1_tactical_reload", "m4a1_reload_ap", "m4a1_firepower_focus", "m4a1_mark_of_vengeance"]
	},
	morgan = {
		Roles = ["mage", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "armor", "sustain", "ap", "control"],
		Summary = "$bv{ui.hub.guide.morgan.summary}", Analysis = "$bv{ui.hub.guide.morgan.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/morgan_from_worlds_end_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/morgan_holy_lance_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/morgan_lake_grace_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/morgan_roadless_camelot_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/morgan_trait.nut"],
		ReviewedSkills = ["morgan_from_worlds_end", "morgan_holy_lance", "morgan_lake_grace", "morgan_roadless_camelot"]
	},
	meltryllis = {
		Roles = ["mobile", "warrior"], Stage = "early", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 3, mid = 2, late = 3 }, Tags = ["weapon_free", "sustain", "protection", "mobility"],
		Summary = "$bv{ui.hub.guide.meltryllis.summary}", Analysis = "$bv{ui.hub.guide.meltryllis.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/meltryllis_sadistic_constitution_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/meltryllis_blade_dance_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/meltryllis_crime_ballet_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/meltryllis_melt_virus_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/meltryllis_sarasvati_meltout_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/meltryllis_trait.nut"],
		ReviewedSkills = ["meltryllis_sadistic_constitution", "meltryllis_blade_dance", "meltryllis_crime_ballet", "meltryllis_melt_virus", "meltryllis_sarasvati_meltout"]
	},
	saber = {
		Roles = ["warrior", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "armor"],
		Summary = "$bv{ui.hub.guide.saber.summary}", Analysis = "$bv{ui.hub.guide.saber.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/saber_invisible_air_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/saber_strike_air_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/saber_excalibur_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/saber_trait.nut"],
		ReviewedSkills = ["saber_invisible_air", "saber_strike_air", "saber_excalibur", "saber_mana_release"]
	},
	silver_wolf = {
		Roles = ["control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "control"],
		Summary = "$bv{ui.hub.guide.silver_wolf.summary}", Analysis = "$bv{ui.hub.guide.silver_wolf.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/silver_wolf_aether_editing_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/silver_wolf_attack_vulnerability_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/silver_wolf_defense_vulnerability_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/silver_wolf_speed_vulnerability_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/silver_wolf_trait.nut"],
		ReviewedSkills = ["silver_wolf_aether_editing", "silver_wolf_attack_vulnerability", "silver_wolf_defense_vulnerability", "silver_wolf_speed_vulnerability"]
	},
	robin = {
		Roles = ["control", "healer"], Stage = "mid", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "healing", "team", "ap", "control"],
		Summary = "$bv{ui.hub.guide.robin.summary}", Analysis = "$bv{ui.hub.guide.robin.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/robin_harmonic_resonance_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/robin_winged_sunny_song_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/robin_encore_for_you_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/robin_myriad_tones_starry_fugue_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/robin_trait.nut"],
		ReviewedSkills = ["robin_harmonic_resonance", "robin_winged_sunny_song", "robin_encore_for_you", "robin_myriad_tones_starry_fugue"]
	},
	jeanne = {
		Roles = ["banner", "middle", "healer"], Stage = "early", Investment = "medium", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["area", "healing", "protection", "growth"],
		Summary = "$bv{ui.hub.guide.jeanne.summary}", Analysis = "$bv{ui.hub.guide.jeanne.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/jeanne_revelation_holy_banner_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/jeanne_true_name_divine_judgement_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/jeanne_luminosite_eternelle_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/jeanne_trait.nut"],
		ReviewedSkills = ["jeanne_revelation_holy_banner", "jeanne_true_name_divine_judgement", "jeanne_luminosite_eternelle"]
	},
	sword_maiden = {
		Roles = ["middle", "warrior"], Stage = "early", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 3, mid = 2, late = 3 }, Tags = ["armor", "growth"],
		Summary = "$bv{ui.hub.guide.sword_maiden.summary}", Analysis = "$bv{ui.hub.guide.sword_maiden.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/sword_maiden_unseeing_mind_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/sword_maiden_balance_condemnation_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/sword_maiden_goblin_codex_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/sword_maiden_cave_survivor_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/sword_maiden_holy_binding_judgment_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/sword_maiden_root_extermination_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/sword_maiden_balance_final_judgment_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/sword_maiden_light_in_darkness_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/sword_maiden_trait.nut"],
		ReviewedSkills = ["sword_maiden_unseeing_mind", "sword_maiden_balance_condemnation", "sword_maiden_goblin_codex", "sword_maiden_cave_survivor", "sword_maiden_holy_binding_judgment", "sword_maiden_root_extermination", "sword_maiden_balance_final_judgment", "sword_maiden_light_in_darkness"]
	},
	jeanne_alter = {
		Roles = ["warrior", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["area", "armor"],
		Summary = "$bv{ui.hub.guide.jeanne_alter.summary}", Analysis = "$bv{ui.hub.guide.jeanne_alter.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/jeanne_alter_dragon_witch_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/jeanne_alter_la_grondement_du_haine_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/jeanne_alter_trait.nut"],
		ReviewedSkills = ["jeanne_alter_dragon_witch", "jeanne_alter_la_grondement_du_haine"]
	},
	jingliu = {
		Roles = ["warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["sustain", "ap"],
		Summary = "$bv{ui.hub.guide.jingliu.summary}", Analysis = "$bv{ui.hub.guide.jingliu.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/jingliu_cold_moon_sword_heart_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/jingliu_moonflower_birth_and_death_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/jingliu_trait.nut"],
		ReviewedSkills = ["jingliu_cold_moon_sword_heart", "jingliu_moonflower_birth_and_death"]
	},
	skirk = {
		Roles = ["warrior", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "armor", "sustain"],
		Summary = "$bv{ui.hub.guide.skirk.summary}", Analysis = "$bv{ui.hub.guide.skirk.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/skirk_serpents_subtlety_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/skirk_havoc_warp_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/skirk_havoc_ruin_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/skirk_trait.nut"],
		ReviewedSkills = ["skirk_serpents_subtlety", "skirk_havoc_warp", "skirk_havoc_ruin"]
	},
	jinhsi = {
		Roles = ["middle", "warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "team"],
		Summary = "$bv{ui.hub.guide.jinhsi.summary}", Analysis = "$bv{ui.hub.guide.jinhsi.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/jinhsi_era_of_unity_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/jinhsi_incarnation_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/jinhsi_illuminous_epiphany_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/jinhsi_trait.nut"],
		ReviewedSkills = ["jinhsi_era_of_unity", "jinhsi_incarnation", "jinhsi_illuminous_epiphany"]
	},
	nahida = {
		Roles = ["mage", "control"], Stage = "early", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 3, mid = 2, late = 3 }, Tags = ["weapon_free", "area", "sustain", "team", "control"],
		Summary = "$bv{ui.hub.guide.nahida.summary}", Analysis = "$bv{ui.hub.guide.nahida.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/nahida_tri_karma_purification_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/nahida_akara_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/nahida_all_schemes_to_know_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/nahida_illusory_heart_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/nahida_trait.nut"],
		ReviewedSkills = ["nahida_tri_karma_purification", "nahida_akara", "nahida_all_schemes_to_know", "nahida_illusory_heart"]
	},
	hakurei_reimu = {
		Roles = ["mage", "healer"], Stage = "early", Investment = "low", Startup = "A", Mature = "A",
		Priorities = { early = 3, mid = 2, late = 2 }, Tags = ["weapon_free", "area", "protection"],
		Summary = "$bv{ui.hub.guide.hakurei_reimu.summary}", Analysis = "$bv{ui.hub.guide.hakurei_reimu.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/hakurei_reimu_inborn_intuition_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/hakurei_reimu_hakurei_amulet_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/hakurei_reimu_duplex_barrier_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/hakurei_reimu_fantasy_seal_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/hakurei_reimu_trait.nut"],
		ReviewedSkills = ["hakurei_reimu_inborn_intuition", "hakurei_reimu_hakurei_amulet", "hakurei_reimu_duplex_barrier", "hakurei_reimu_fantasy_seal"]
	},
	yae_miko = {
		Roles = ["mage", "warrior"], Stage = "early", Investment = "low", Startup = "A", Mature = "A",
		Priorities = { early = 3, mid = 2, late = 2 }, Tags = ["sustain"],
		Summary = "$bv{ui.hub.guide.yae_miko.summary}", Analysis = "$bv{ui.hub.guide.yae_miko.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/yae_miko_kitsune_thunder_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/valkyrie_generic_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/yae_miko_trait.nut"],
		ReviewedSkills = ["yae_miko_kitsune_thunder", "yae_miko_tenko_thunder_domain"]
	},
	chisaki = {
		Roles = ["warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["sustain"],
		Summary = "$bv{ui.hub.guide.chisaki.summary}", Analysis = "$bv{ui.hub.guide.chisaki.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/valkyrie_generic_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/chisaki_trait.nut"],
		ReviewedSkills = ["chisaki_edge_followup", "chisaki_blood_slash"]
	},
	kafka = {
		Roles = ["control"], Stage = "mid", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["team", "ap", "control"],
		Summary = "$bv{ui.hub.guide.kafka.summary}", Analysis = "$bv{ui.hub.guide.kafka.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/kafka_script_direction_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/kafka_your_turn_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/kafka_listen_to_me_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/kafka_trait.nut"],
		ReviewedSkills = ["kafka_script_direction", "kafka_your_turn", "kafka_listen_to_me"]
	},
	ye_shunguang = {
		Roles = ["warrior", "mobile"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["growth"],
		Summary = "$bv{ui.hub.guide.ye_shunguang.summary}", Analysis = "$bv{ui.hub.guide.ye_shunguang.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/config/ye_shunguang_bond_data.nut", "src/battle-valkyries/battle-valkyries/skills/passives/ye_shunguang_enlightened_clarity_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/ye_shunguang_reflection_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/ye_shunguang_return_to_dust_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/ye_shunguang_heart_recalled_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/ye_shunguang_trait.nut"],
		ReviewedSkills = ["ye_shunguang_enlightened_clarity", "ye_shunguang_reflection", "ye_shunguang_return_to_dust", "ye_shunguang_heart_recalled"]
	},
	himeko = {
		Roles = ["middle", "ranged"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "armor", "team", "growth"],
		Summary = "$bv{ui.hub.guide.himeko.summary}", Analysis = "$bv{ui.hub.guide.himeko.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/himeko_victory_rush_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/himeko_heavenly_flare_skill.nut", "src/battle-valkyries/battle-valkyries/skills/passives/himeko_we_are_trailblaze_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/himeko_trait.nut"],
		ReviewedSkills = ["himeko_victory_rush", "himeko_heavenly_flare", "himeko_we_are_trailblaze"]
	},
	feixue = {
		Roles = ["mobile", "warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "mobility"],
		Summary = "$bv{ui.hub.guide.feixue.summary}", Analysis = "$bv{ui.hub.guide.feixue.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/feixue_everfrost_dominion_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/feixue_mushin_iai_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/feixue_blade_liberation_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/feixue_trait.nut"],
		ReviewedSkills = ["feixue_everfrost_dominion", "feixue_mushin_iai", "feixue_blade_liberation"]
	},
	feixiao = {
		Roles = ["middle", "warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "armor", "team"],
		Summary = "$bv{ui.hub.guide.feixiao.summary}", Analysis = "$bv{ui.hub.guide.feixiao.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/feixiao_thunderhunt_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/feixiao_waraxe_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/feixiao_terraverge_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/feixiao_trait.nut"],
		ReviewedSkills = ["feixiao_thunderhunt", "feixiao_waraxe", "feixiao_terraverge"]
	},
	changli = {
		Roles = ["warrior", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area"],
		Summary = "$bv{ui.hub.guide.changli.summary}", Analysis = "$bv{ui.hub.guide.changli.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/changli_true_sight_enflamement_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/changli_radiance_of_fealty_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/changli_flaming_sacrifice_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/changli_trait.nut"],
		ReviewedSkills = ["changli_true_sight_enflamement", "changli_radiance_of_fealty", "changli_flaming_sacrifice"]
	},
	raiden_shogun = {
		Roles = ["warrior", "middle"], Stage = "early", Investment = "medium", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["armor"],
		Summary = "$bv{ui.hub.guide.raiden_shogun.summary}", Analysis = "$bv{ui.hub.guide.raiden_shogun.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/valkyrie_generic_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/raiden_shogun_trait.nut"],
		ReviewedSkills = ["raiden_shogun_eternal_authority", "raiden_shogun_musou_no_hitotachi"]
	},
	yixuan = {
		Roles = ["middle", "warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["area", "armor"],
		Summary = "$bv{ui.hub.guide.yixuan.summary}", Analysis = "$bv{ui.hub.guide.yixuan.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/yixuan_arcane_mastery_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/yixuan_auric_ink_shock_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/yixuan_endless_talisman_suppression_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/yixuan_trait.nut"],
		ReviewedSkills = ["yixuan_arcane_mastery", "yixuan_auric_ink_shock", "yixuan_endless_talisman_suppression"]
	},
	xilian = {
		Roles = ["healer", "control"], Stage = "mid", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["healing", "growth", "ap", "control"],
		Summary = "$bv{ui.hub.guide.xilian.summary}", Analysis = "$bv{ui.hub.guide.xilian.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/xilian_beyond_closed_loop_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/xilian_trait.nut"],
		ReviewedSkills = ["xilian_memory_sanctuary", "xilian_beyond_closed_loop"]
	},
	liuying = {
		Roles = ["guard", "warrior"], Stage = "early", Investment = "medium", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["protection", "growth", "ap"],
		Summary = "$bv{ui.hub.guide.liuying.summary}", Analysis = "$bv{ui.hub.guide.liuying.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/valkyrie_generic_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/liuying_trait.nut"],
		ReviewedSkills = ["liuying_iron_cavalry_armor", "liuying_sam_suppression_charge"]
	},
	cartethyia = {
		Roles = ["warrior", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "control"],
		Summary = "$bv{ui.hub.guide.cartethyia.summary}", Analysis = "$bv{ui.hub.guide.cartethyia.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/cartethyia_aero_erosion_web_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cartethyia_sword_in_humanity_name_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cartethyia_knights_heartfelt_prayers_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cartethyia_tempest_break_tides_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cartethyia_blade_howling_squall_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/cartethyia_trait.nut"],
		ReviewedSkills = ["cartethyia_aero_erosion_web", "cartethyia_sword_in_humanity_name", "cartethyia_knights_heartfelt_prayers", "cartethyia_tempest_break_tides", "cartethyia_blade_howling_squall"]
	},
	castorice = {
		Roles = ["middle", "healer"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "healing"],
		Summary = "$bv{ui.hub.guide.castorice.summary}", Analysis = "$bv{ui.hub.guide.castorice.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/castorice_newbud_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/castorice_cocoon_drain_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/castorice_netherwing_descent_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/castorice_trait.nut"],
		ReviewedSkills = ["castorice_newbud", "castorice_cocoon_drain", "castorice_netherwing_descent"]
	},
	changyeyue = {
		Roles = ["warrior", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["area"],
		Summary = "$bv{ui.hub.guide.changyeyue.summary}", Analysis = "$bv{ui.hub.guide.changyeyue.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/changyeyue_long_night_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/changyeyue_darkest_riddle_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/changyeyue_trait.nut"],
		ReviewedSkills = ["changyeyue_long_night", "changyeyue_darkest_riddle"]
	},
	hysilens = {
		Roles = ["ranged", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["area", "control"],
		Summary = "$bv{ui.hub.guide.hysilens.summary}", Analysis = "$bv{ui.hub.guide.hysilens.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/hysilens_tidal_erosion_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/hysilens_crystal_tide_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/hysilens_trait.nut"],
		ReviewedSkills = ["hysilens_tidal_erosion", "hysilens_crystal_tide"]
	},
	tilixibiesi = {
		Roles = ["control"], Stage = "conditional", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["mobility", "control"],
		Summary = "$bv{ui.hub.guide.tilixibiesi.summary}", Analysis = "$bv{ui.hub.guide.tilixibiesi.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/tilixibiesi_beyond_warp_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/tilixibiesi_trait.nut"],
		ReviewedSkills = ["tilixibiesi_underworld_coordinates", "tilixibiesi_beyond_warp"]
	},
	cipher = {
		Roles = ["mobile", "ranged"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["team", "mobility"],
		Summary = "$bv{ui.hub.guide.cipher.summary}", Analysis = "$bv{ui.hub.guide.cipher.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/cipher_old_patron_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cipher_name_your_price_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cipher_moonlit_heist_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/cipher_trait.nut"],
		ReviewedSkills = ["cipher_old_patron", "cipher_name_your_price", "cipher_moonlit_heist"]
	},
	cerydra = {
		Roles = ["banner", "control"], Stage = "mid", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["team", "ap", "control"],
		Summary = "$bv{ui.hub.guide.cerydra.summary}", Analysis = "$bv{ui.hub.guide.cerydra.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/cerydra_war_banner_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cerydra_promote_pawn_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/cerydra_checkmate_command_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/cerydra_trait.nut"],
		ReviewedSkills = ["cerydra_war_banner", "cerydra_promote_pawn", "cerydra_checkmate_command"]
	},
	fengjin = {
		Roles = ["healer", "control"], Stage = "conditional", Investment = "low", Startup = "B", Mature = "A",
		Priorities = { early = 1, mid = 2, late = 2 }, Tags = ["healing", "control"],
		Summary = "$bv{ui.hub.guide.fengjin.summary}", Analysis = "$bv{ui.hub.guide.fengjin.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/fengjin_feather_rescue_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/fengjin_icarus_impact_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/fengjin_trait.nut"],
		ReviewedSkills = ["fengjin_tailwind_rhythm", "fengjin_feather_rescue", "fengjin_icarus_impact"]
	},
	yuno = {
		Roles = ["control", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["team", "ap", "control"],
		Summary = "$bv{ui.hub.guide.yuno.summary}", Analysis = "$bv{ui.hub.guide.yuno.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/yuno_destined_hunt_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/yuno_death_omen_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/yuno_trait.nut"],
		ReviewedSkills = ["yuno_destined_hunt", "yuno_death_omen"]
	},
	phoebe = {
		Roles = ["control", "ranged"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "A",
		Priorities = { early = 2, mid = 3, late = 2 }, Tags = ["area", "control"],
		Summary = "$bv{ui.hub.guide.phoebe.summary}", Analysis = "$bv{ui.hub.guide.phoebe.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/phoebe_absolution_litany_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/phoebe_to_where_light_shines_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/phoebe_trait.nut"],
		ReviewedSkills = ["phoebe_absolution_litany", "phoebe_to_where_light_shines"]
	},
	wisadel = {
		Roles = ["ranged", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "armor", "control"],
		Summary = "$bv{ui.hub.guide.wisadel.summary}", Analysis = "$bv{ui.hub.guide.wisadel.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/valkyrie_generic_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/wisadel_explosive_dawn_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/wisadel_trait.nut"],
		ReviewedSkills = ["wisadel_souvenir", "wisadel_explosive_dawn"]
	},
	aglaea = {
		Roles = ["warrior"], Stage = "early", Investment = "medium", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["area", "sustain", "ap"],
		Summary = "$bv{ui.hub.guide.aglaea.summary}", Analysis = "$bv{ui.hub.guide.aglaea.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/aglaea_seam_stitch_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/aglaea_destined_weaving_dance_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/aglaea_trait.nut"],
		ReviewedSkills = ["aglaea_seam_stitch", "aglaea_destined_weaving_dance"]
	},
	mai_shiranui = {
		Roles = ["ranged", "mobile"], Stage = "mid", Investment = "high", Startup = "B", Mature = "A",
		Priorities = { early = 1, mid = 2, late = 2 }, Tags = ["armor", "mobility"],
		Summary = "$bv{ui.hub.guide.mai_shiranui.summary}", Analysis = "$bv{ui.hub.guide.mai_shiranui.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/mai_shiranui_kachosen_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/mai_shiranui_chou_hissatsu_shinobi_bachi_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/mai_shiranui_trait.nut"],
		ReviewedSkills = ["mai_shiranui_kachosen", "mai_shiranui_chou_hissatsu_shinobi_bachi"]
	},
	scarlet_shadow = {
		Roles = ["warrior", "middle"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "armor"],
		Summary = "$bv{ui.hub.guide.scarlet_shadow.summary}", Analysis = "$bv{ui.hub.guide.scarlet_shadow.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/scarlet_shadow_flyflower_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/scarlet_shadow_flower_shadow_trinity_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/scarlet_shadow_fading_blossom_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/scarlet_shadow_trait.nut"],
		ReviewedSkills = ["scarlet_shadow_flyflower", "scarlet_shadow_flower_shadow_trinity", "scarlet_shadow_fading_blossom"]
	},
	texas_omertosa = {
		Roles = ["mobile", "warrior", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "protection", "mobility", "control"],
		Summary = "$bv{ui.hub.guide.texas_omertosa.summary}", Analysis = "$bv{ui.hub.guide.texas_omertosa.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/texas_omertosa_tradition_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/texas_omertosa_unrelenting_downpour_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/texas_omertosa_torrential_sword_rain_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/texas_omertosa_trait.nut"],
		ReviewedSkills = ["texas_omertosa_tradition", "texas_omertosa_unrelenting_downpour", "texas_omertosa_torrential_sword_rain"]
	},
	sparxie = {
		Roles = ["ranged", "control"], Stage = "late", Investment = "medium", Startup = "B", Mature = "A",
		Priorities = { early = 1, mid = 2, late = 3 }, Tags = ["area", "team", "control"],
		Summary = "$bv{ui.hub.guide.sparxie.summary}", Analysis = "$bv{ui.hub.guide.sparxie.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/sparxie_backstage_trick_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/sparxie_live_connection_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/sparxie_carnival_live_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/sparxie_trait.nut"],
		ReviewedSkills = ["sparxie_backstage_trick", "sparxie_live_connection", "sparxie_carnival_live"]
	},
	the_herta = {
		Roles = ["middle", "control", "warrior"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["area", "control", "signature", "growth", "mobility"],
		Summary = "$bv{ui.hub.guide.the_herta.summary}", Analysis = "$bv{ui.hub.guide.the_herta.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/the_herta_bond_data.nut", "src/battle-valkyries/battle-valkyries/skills/actives/the_herta_weapon_skill.nut", "src/battle-valkyries/battle-valkyries/systems/the_herta_foresight.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/the_herta_optimal_solution_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/the_herta_false_premise_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/the_herta_answer_written_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/the_herta_trait.nut"],
		ReviewedSkills = ["the_herta_optimal_solution", "the_herta_false_premise", "the_herta_answer_written", "the_herta_answer_kept_for_you"]
	},
	lily = {
		Roles = ["healer", "mage"], Stage = "early", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 3, mid = 2, late = 3 }, Tags = ["weapon_free", "area", "healing", "growth"],
		Summary = "$bv{ui.hub.guide.lily.summary}", Analysis = "$bv{ui.hub.guide.lily.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/lily_valkyrie_data.nut", "src/battle-valkyries/battle-valkyries/config/lily_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/lily_blight_controller_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/lily_prayer_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/lily_accept_blight_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/lily_final_purification_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/lily_trait.nut"],
		ReviewedSkills = ["lily_blight_controller", "lily_prayer", "lily_accept_blight", "lily_final_purification"]
	},
	suisui = {
		Roles = ["healer", "mage"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "healing", "protection"],
		Summary = "$bv{ui.hub.guide.suisui.summary}", Analysis = "$bv{ui.hub.guide.suisui.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/suisui_trait.nut"],
		ReviewedSkills = ["suisui_clear_current", "suisui_water_fan", "suisui_spring_mountain", "suisui_river_realm"]
	},
	misono_mika = {
		Roles = ["ranged", "warrior"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["signature", "armor", "sustain", "mobility"],
		Summary = "$bv{ui.hub.guide.misono_mika.summary}", Analysis = "$bv{ui.hub.guide.misono_mika.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/hooks/valkyrie_summon.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/misono_mika_trait.nut"],
		ReviewedSkills = ["misono_mika_innocent_strength", "misono_mika_starlight_burst", "misono_mika_trinity_breach", "misono_mika_star_magazine", "misono_mika_kyrie_eleison"]
	},
	sorasaki_hina = {
		Roles = ["ranged", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["signature", "armor", "sustain", "control"],
		Summary = "$bv{ui.hub.guide.sorasaki_hina.summary}", Analysis = "$bv{ui.hub.guide.sorasaki_hina.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/hooks/valkyrie_summon.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/sorasaki_hina_trait.nut"],
		ReviewedSkills = ["sorasaki_hina_cold_prefect", "sorasaki_hina_cold_burst", "sorasaki_hina_cool_reload", "sorasaki_hina_final_sweep"]
	},
	xin = {
		Roles = ["mage", "control"], Stage = "conditional", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["weapon_free", "team", "control"],
		Summary = "$bv{ui.hub.guide.xin.summary}", Analysis = "$bv{ui.hub.guide.xin.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/xin_trait.nut"],
		ReviewedSkills = ["xin_myriad_reflections", "xin_worldly_form", "xin_unified_thought", "xin_myriad_palace"]
	},
	shizuna = {
		Roles = ["warrior", "mobile"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 2, mid = 3, late = 3 }, Tags = ["armor", "mobility"],
		Summary = "$bv{ui.hub.guide.shizuna.summary}", Analysis = "$bv{ui.hub.guide.shizuna.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/shizuna_trait.nut"],
		ReviewedSkills = ["shizuna_observing_eye", "shizuna_black_flash", "shizuna_silver_parry", "shizuna_severing_world"]
	},
	lumiore = {
		Roles = ["mage"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "armor"],
		Summary = "$bv{ui.hub.guide.lumiore.summary}", Analysis = "$bv{ui.hub.guide.lumiore.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/lumiore_trait.nut"],
		ReviewedSkills = ["lumiore_golden_prestige", "lumiore_golden_breath", "lumiore_burning_scales", "lumiore_golden_dragon"]
	},
	argente = {
		Roles = ["guard", "healer"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "protection"],
		Summary = "$bv{ui.hub.guide.argente.summary}", Analysis = "$bv{ui.hub.guide.argente.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/argente_trait.nut"],
		ReviewedSkills = ["argente_silver_guard", "argente_wing_shield_bash", "argente_silver_shelter", "argente_silver_oath"]
	},
	sekka = {
		Roles = ["mobile", "middle"], Stage = "early", Investment = "low", Startup = "A", Mature = "S",
		Priorities = { early = 3, mid = 2, late = 3 }, Tags = ["weapon_free", "mobility"],
		Summary = "$bv{ui.hub.guide.sekka.summary}", Analysis = "$bv{ui.hub.guide.sekka.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/eight_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/eight_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/eight_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/eight_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/eight_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/sekka_trait.nut"],
		ReviewedSkills = ["sekka_distant_home", "sekka_foxfire_path", "sekka_returning_shadow", "sekka_nine_tail_resolve"]
	},
	yakumo_yukari = {
		Roles = ["mage", "control", "healer"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "protection", "mobility", "control"],
		Summary = "$bv{ui.hub.guide.yakumo_yukari.summary}", Analysis = "$bv{ui.hub.guide.yakumo_yukari.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/five_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/five_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/five_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/five_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/five_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/yakumo_yukari_trait.nut"],
		ReviewedSkills = ["yakumo_yukari_boundary_youkais", "yakumo_yukari_life_death_boundary", "yakumo_yukari_gap_passage", "yakumo_yukari_phantasm_curtain", "yakumo_yukari_boundary_train"]
	},
	tokisaki_kurumi = {
		Roles = ["ranged", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "sustain", "growth", "ap", "control"],
		Summary = "$bv{ui.hub.guide.tokisaki_kurumi.summary}", Analysis = "$bv{ui.hub.guide.tokisaki_kurumi.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/five_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/five_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/five_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/five_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/five_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/tokisaki_kurumi_trait.nut"],
		ReviewedSkills = ["tokisaki_kurumi_zafkiel_controller", "tokisaki_kurumi_dual_gun_volley", "tokisaki_kurumi_bullet_one_acceleration", "tokisaki_kurumi_bullet_two_delay", "tokisaki_kurumi_bullet_four_rewind", "tokisaki_kurumi_bullet_seven_time_stop", "tokisaki_kurumi_bullet_eight_shadow", "tokisaki_kurumi_bullet_twelve_replay"]
	},
	cirno = {
		Roles = ["mage", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "protection", "control"],
		Summary = "$bv{ui.hub.guide.cirno.summary}", Analysis = "$bv{ui.hub.guide.cirno.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/five_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/five_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/five_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/five_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/five_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/cirno_trait.nut"],
		ReviewedSkills = ["cirno_strongest_ice_fairy", "cirno_icicle_volley", "cirno_diamond_blizzard", "cirno_ice_wing_guard", "cirno_perfect_freeze"]
	},
	shana = {
		Roles = ["warrior", "mobile", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "sustain", "control"],
		Summary = "$bv{ui.hub.guide.shana.summary}", Analysis = "$bv{ui.hub.guide.shana.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/five_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/five_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/five_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/five_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/five_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/shana_trait.nut"],
		ReviewedSkills = ["shana_flame_haired_hunter", "shana_nietono_no_shana", "shana_crimson_wings", "shana_fuzetsu", "shana_heavenly_flame"]
	},
	tohsaka_rin = {
		Roles = ["mage", "middle", "control"], Stage = "early", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 3, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "sustain", "growth", "control"],
		Summary = "$bv{ui.hub.guide.tohsaka_rin.summary}", Analysis = "$bv{ui.hub.guide.tohsaka_rin.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/five_valkyries_data.nut", "src/battle-valkyries/battle-valkyries/config/five_valkyries_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/five_valkyries_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/five_valkyries_active_skill.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/five_valkyries.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/tohsaka_rin_trait.nut"],
		ReviewedSkills = ["tohsaka_rin_gem_workshop", "tohsaka_rin_jeweled_sword", "tohsaka_rin_gem_magic", "tohsaka_rin_double_formula", "tohsaka_rin_prismatic_jeweled_sword", "tohsaka_rin_ruby", "tohsaka_rin_topaz", "tohsaka_rin_sapphire", "tohsaka_rin_amethyst", "tohsaka_rin_emerald"]
	},
	olga = {
		Roles = ["mage", "control"], Stage = "mid", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "armor", "growth", "control"],
		Summary = "$bv{ui.hub.guide.olga.summary}", Analysis = "$bv{ui.hub.guide.olga.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/olga_data.nut", "src/battle-valkyries/battle-valkyries/config/olga_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/olga_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/olga_spell_skill.nut", "src/battle-valkyries/battle-valkyries/systems/black_city_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/olga.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/olga_trait.nut"],
		ReviewedSkills = ["olga_dark_queen", "olga_dark_erosion", "olga_curse_recovery", "olga_black_flame", "olga_queen_curse", "olga_soul_shock", "olga_black_storm", "olga_dark_annihilation", "olga_soul_enslavement", "olga_eclipse"]
	},
	chloe = {
		Roles = ["guard", "warrior"], Stage = "mid", Investment = "medium", Startup = "S", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["armor", "growth"],
		Summary = "$bv{ui.hub.guide.chloe.summary}", Analysis = "$bv{ui.hub.guide.chloe.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/black_city_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/chloe_trait.nut"],
		ReviewedSkills = ["chloe_passive", "chloe_slash", "chloe_swap", "chloe_stance", "chloe_dual", "chloe_fortress"]
	},
	alicia = {
		Roles = ["warrior", "mobile"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["sustain", "growth"],
		Summary = "$bv{ui.hub.guide.alicia.summary}", Analysis = "$bv{ui.hub.guide.alicia.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/alicia_trait.nut"],
		ReviewedSkills = ["alicia_passive", "alicia_thrust", "alicia_counter", "alicia_breath", "alicia_triple"]
	},
	claudia = {
		Roles = ["warrior", "middle", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["area", "armor", "growth", "control"],
		Summary = "$bv{ui.hub.guide.claudia.summary}", Analysis = "$bv{ui.hub.guide.claudia.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/claudia_trait.nut"],
		ReviewedSkills = ["claudia_passive", "claudia_hammer", "claudia_wedge", "claudia_sweep", "claudia_wave", "claudia_city"]
	},
	celestine = {
		Roles = ["healer", "mage", "control"], Stage = "mid", Investment = "low", Startup = "S", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["weapon_free", "area", "healing", "protection", "growth", "mobility", "control"],
		Summary = "$bv{ui.hub.guide.celestine.summary}", Analysis = "$bv{ui.hub.guide.celestine.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/celestine_trait.nut"],
		ReviewedSkills = ["celestine_passive", "celestine_judgment", "celestine_blessing", "celestine_healing", "celestine_gate", "celestine_protect", "celestine_celestial", "celestine_resurrection"]
	},
	kaguya = {
		Roles = ["middle", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["area", "armor", "growth", "control"],
		Summary = "$bv{ui.hub.guide.kaguya.summary}", Analysis = "$bv{ui.hub.guide.kaguya.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/kaguya_trait.nut"],
		ReviewedSkills = ["kaguya_passive", "kaguya_thrust", "kaguya_talisman", "kaguya_sweep", "kaguya_array", "kaguya_purge"]
	},
	prim = {
		Roles = ["banner", "middle", "healer"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["healing", "team", "growth"],
		Summary = "$bv{ui.hub.guide.prim.summary}", Analysis = "$bv{ui.hub.guide.prim.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/prim_trait.nut"],
		ReviewedSkills = ["prim_passive", "prim_thrust", "prim_rally", "prim_twin", "prim_cleanse"]
	},
	maia = {
		Roles = ["guard", "control"], Stage = "mid", Investment = "medium", Startup = "S", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["area", "protection", "growth", "control"],
		Summary = "$bv{ui.hub.guide.maia.summary}", Analysis = "$bv{ui.hub.guide.maia.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/maia_trait.nut"],
		ReviewedSkills = ["maia_passive", "maia_taunt", "maia_fang", "maia_wall", "maia_sweep", "maia_cry"]
	},
	luu_luu = {
		Roles = ["warrior", "control"], Stage = "mid", Investment = "medium", Startup = "A", Mature = "S",
		Priorities = { early = 1, mid = 3, late = 3 }, Tags = ["area", "armor", "sustain", "growth", "control"],
		Summary = "$bv{ui.hub.guide.luu_luu.summary}", Analysis = "$bv{ui.hub.guide.luu_luu.analysis}",
		Sources = ["src/battle-valkyries/battle-valkyries/config/black_beast_data.nut", "src/battle-valkyries/battle-valkyries/config/black_beast_skill_catalog.nut", "src/battle-valkyries/battle-valkyries/skills/passives/black_beast_passive_skill.nut", "src/battle-valkyries/battle-valkyries/skills/actives/black_beast_active_skill.nut", "src/battle-valkyries/battle-valkyries/systems/seven_shields_chapter.nut", "src/battle-valkyries/battle-valkyries/config/valkyrie_trait_data.nut", "src/battle-valkyries/battle-valkyries/systems/black_beast.nut", "src/battle-valkyries/scripts/skills/traits/battle_valkyries/luu_luu_trait.nut"],
		ReviewedSkills = ["luu_luu_passive", "luu_luu_mountain", "luu_luu_vent", "luu_luu_split", "luu_luu_spin", "luu_luu_behead", "luu_luu_furnace"]
	},
};
