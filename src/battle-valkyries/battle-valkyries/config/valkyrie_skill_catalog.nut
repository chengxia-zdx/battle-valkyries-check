::$bvvar{namespace}.ValkyrieSkillCatalog <- {
	abigail_outer_realm = {
		RuntimeScript="$bvvar{privateFolder}/skills/passives/abigail_outer_realm_skill",
		Name="$bv{skill.abigail_outer_realm.name}",Description="$bv{skill.abigail_outer_realm.description}",Icon="abigail_outer_realm",
		Kind="passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {}
	},
	abigail_root_touch = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/abigail_witchcraft_skill",
		Name="$bv{skill.abigail_root_touch.name}",Description="$bv{skill.abigail_root_touch.description}",Icon="abigail_root_touch",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="root",AP=4,Fatigue=12,MinRange=1,MaxRange=4,Cooldown=0,Base=55,Resolve=0.4,Armor=1,Pierce=0.35,Hit=20}
	},
	abigail_faithful_prayer = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/abigail_witchcraft_skill",
		Name="$bv{skill.abigail_faithful_prayer.name}",Description="$bv{skill.abigail_faithful_prayer.description}",Icon="abigail_faithful_prayer",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="prayer",AP=3,Fatigue=18,MinRange=0,MaxRange=0,Cooldown=3,Base=0,Resolve=0,Armor=1,Pierce=0,Hit=0}
	},
	abigail_mass_hysteria = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/abigail_witchcraft_skill",
		Name="$bv{skill.abigail_mass_hysteria.name}",Description="$bv{skill.abigail_mass_hysteria.description}",Icon="abigail_mass_hysteria",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="terror",AP=4,Fatigue=22,MinRange=1,MaxRange=4,Cooldown=3,Base=0,Resolve=0,Armor=1,Pierce=0,Hit=0}
	},
	abigail_witch_trial = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/abigail_witchcraft_skill",
		Name="$bv{skill.abigail_witch_trial.name}",Description="$bv{skill.abigail_witch_trial.description}",Icon="abigail_witch_trial",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="trial",AP=3,Fatigue=18,MinRange=1,MaxRange=5,Cooldown=3,Base=0,Resolve=0,Armor=1,Pierce=0,Hit=0}
	},
	abigail_qliphoth_rhizome = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/abigail_witchcraft_skill",
		Name="$bv{skill.abigail_qliphoth_rhizome.name}",Description="$bv{skill.abigail_qliphoth_rhizome.description}",Icon="abigail_qliphoth_rhizome",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="gate",AP=6,Fatigue=35,MinRange=2,MaxRange=6,Cooldown=3,Base=160,Resolve=0.6,Armor=1.5,Pierce=0.65,Hit=35}
	},
	hokusai_painting_mania = {
		RuntimeScript="$bvvar{privateFolder}/skills/passives/hokusai_painting_mania_skill",
		Name="$bv{skill.hokusai_painting_mania.name}",Description="$bv{skill.hokusai_painting_mania.description}",Icon="hokusai_painting_mania",
		Kind="passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec={}
	},
	hokusai_brushstroke = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/hokusai_painting_skill",
		Name="$bv{skill.hokusai_brushstroke.name}",Description="$bv{skill.hokusai_brushstroke.description}",Icon="hokusai_brushstroke",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec={Mode="brush",AP=3,Fatigue=10,MinRange=1,MaxRange=4,Cooldown=0,Base=55,Resolve=0.35,Armor=1.0,Pierce=0.25,Hit=15}
	},
	hokusai_all_things_in_nature = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/hokusai_painting_skill",
		Name="$bv{skill.hokusai_all_things_in_nature.name}",Description="$bv{skill.hokusai_all_things_in_nature.description}",Icon="hokusai_all_things_in_nature",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec={Mode="nature",AP=2,Fatigue=12,MinRange=0,MaxRange=0,Cooldown=3,Base=0,Resolve=0.0,Armor=1.0,Pierce=0.0,Hit=0}
	},
	hokusai_father_daughter_bond = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/hokusai_painting_skill",
		Name="$bv{skill.hokusai_father_daughter_bond.name}",Description="$bv{skill.hokusai_father_daughter_bond.description}",Icon="hokusai_father_daughter_bond",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec={Mode="bond",AP=2,Fatigue=12,MinRange=0,MaxRange=0,Cooldown=3,Base=0,Resolve=0.0,Armor=1.0,Pierce=0.0,Hit=0}
	},
	hokusai_alien_octopus = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/hokusai_painting_skill",
		Name="$bv{skill.hokusai_alien_octopus.name}",Description="$bv{skill.hokusai_alien_octopus.description}",Icon="hokusai_alien_octopus",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec={Mode="alien",AP=4,Fatigue=18,MinRange=2,MaxRange=4,Cooldown=2,Base=40,Resolve=0.25,Armor=1.0,Pierce=0.25,Hit=20}
	},
	hokusai_thirty_six_views = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/hokusai_painting_skill",
		Name="$bv{skill.hokusai_thirty_six_views.name}",Description="$bv{skill.hokusai_thirty_six_views.description}",Icon="hokusai_thirty_six_views",
		Kind="active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec={Mode="wave",AP=6,Fatigue=35,MinRange=2,MaxRange=5,Cooldown=3,Base=110,Resolve=0.5,Armor=1.5,Pierce=0.35,Hit=25}
	},
	c_c_immortal_witch = {
		RuntimeScript="$bvvar{privateFolder}/skills/passives/c_c_immortal_witch_skill",
		Name="$bv{skill.c_c_immortal_witch.name}",Description="$bv{skill.c_c_immortal_witch.description}",Icon="c_c_immortal_witch",
		Kind="passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {}
	},
	c_c_accomplice = {
		RuntimeScript="$bvvar{privateFolder}/skills/passives/c_c_accomplice_skill",
		Name="$bv{skill.c_c_accomplice.name}",Description="$bv{skill.c_c_accomplice.description}",Icon="c_c_accomplice",
		Kind="passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {}
	},
	c_c_geass_contract = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/c_c_contract_skill",
		Name="$bv{skill.c_c_geass_contract.name}",Description="$bv{skill.c_c_geass_contract.description}",Icon="c_c_geass_contract",
		Kind="active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="contract",AP=3,Fatigue=12,Range=4}
	},
	c_c_shock_image = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/c_c_contract_skill",
		Name="$bv{skill.c_c_shock_image.name}",Description="$bv{skill.c_c_shock_image.description}",Icon="c_c_shock_image",
		Kind="active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="shock",AP=4,Fatigue=18,Range=1}
	},
	c_c_unfinished_contract = {
		RuntimeScript="$bvvar{privateFolder}/skills/actives/c_c_contract_skill",
		Name="$bv{skill.c_c_unfinished_contract.name}",Description="$bv{skill.c_c_unfinished_contract.description}",Icon="c_c_unfinished_contract",
		Kind="active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
		Spec = {Mode="oath",AP=6,Fatigue=30,Range=4}
	},
	enterprise_white_eagle_airwing = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/enterprise_white_eagle_airwing_skill",
		Name = "$bv{skill.enterprise_white_eagle_airwing.name}", Description = "$bv{skill.enterprise_white_eagle_airwing.description}", Icon = "enterprise_white_eagle_airwing",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1,RequiredSkills = [],ForbiddenSkills = []},
		Spec = {}
	},
	enterprise_lucky_e = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/enterprise_lucky_e_skill",
		Name = "$bv{skill.enterprise_lucky_e.name}", Description = "$bv{skill.enterprise_lucky_e.description}", Icon = "enterprise_lucky_e",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1,RequiredSkills = [],ForbiddenSkills = []},
		Spec = {}
	},
	enterprise_eagle_guidance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/enterprise_eagle_guidance_skill",
		Name = "$bv{skill.enterprise_eagle_guidance.name}", Description = "$bv{skill.enterprise_eagle_guidance.description}", Icon = "enterprise_eagle_guidance",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1,RequiredSkills = [],ForbiddenSkills = []},
		Spec = {}
	},
	enterprise_dauntless_dive = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/enterprise_airstrike_skill",
		Name = "$bv{skill.enterprise_dauntless_dive.name}", Description = "$bv{skill.enterprise_dauntless_dive.description}", Icon = "enterprise_dauntless_dive",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1,RequiredSkills = [],ForbiddenSkills = []},
		Spec = {Mode = "dauntless_dive",AP = 6,Fatigue = 20,Sorties = 2,DamageMin = 55,DamageMax = 70,Armor = 1.5,Pierce = 0.25,Hit = 15}
	},
	enterprise_carrier_strafe = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/enterprise_airstrike_skill",
		Name = "$bv{skill.enterprise_carrier_strafe.name}", Description = "$bv{skill.enterprise_carrier_strafe.description}", Icon = "enterprise_carrier_strafe",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1,RequiredSkills = [],ForbiddenSkills = []},
		Spec = {Mode = "carrier_strafe",AP = 6,Fatigue = 24,Sorties = 2,DamageMin = 35,DamageMax = 45,Armor = 1.0,Pierce = 0.20,Hit = 10}
	},
	enterprise_decisive_airwing = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/enterprise_airstrike_skill",
		Name = "$bv{skill.enterprise_decisive_airwing.name}", Description = "$bv{skill.enterprise_decisive_airwing.description}", Icon = "enterprise_decisive_airwing",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1,RequiredSkills = [],ForbiddenSkills = []},
		Spec = {Mode = "decisive_airwing",AP = 7,Fatigue = 35,Sorties = 3,DamageMin = 60,DamageMax = 80,OuterMin = 30,OuterMax = 40,Armor = 1.5,Pierce = 0.25,Hit = 15}
	},
	togawa_sakiko_ensemble_stage = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/togawa_sakiko_ensemble_stage_skill",
		Name = "$bv{skill.togawa_sakiko_ensemble_stage.name}", Description = "$bv{skill.togawa_sakiko_ensemble_stage.description}", Icon = "togawa_sakiko_ensemble_stage",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1, RequiredSkills = [], ForbiddenSkills = []},
		Spec = {}
	},
	togawa_sakiko_full_moon_dance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/togawa_sakiko_full_moon_dance_skill",
		Name = "$bv{skill.togawa_sakiko_full_moon_dance.name}", Description = "$bv{skill.togawa_sakiko_full_moon_dance.description}", Icon = "togawa_sakiko_full_moon_dance",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1, RequiredSkills = [], ForbiddenSkills = []},
		Spec = {}
	},
	togawa_sakiko_crescent_echo = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/togawa_sakiko_crescent_echo_skill",
		Name = "$bv{skill.togawa_sakiko_crescent_echo.name}", Description = "$bv{skill.togawa_sakiko_crescent_echo.description}", Icon = "togawa_sakiko_crescent_echo",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {MinLevel = 1, RequiredSkills = [], ForbiddenSkills = []},
		Spec = {}
	},
	m4a1_ar_commander = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/m4a1_ar_commander_skill",
		Name = "$bv{skill.m4a1_ar_commander.name}", Description = "$bv{skill.m4a1_ar_commander.description}", Icon = "m4a1_ar_commander",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	m4a1_inheritor = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/m4a1_inheritor_skill",
		Name = "$bv{skill.m4a1_inheritor.name}", Description = "$bv{skill.m4a1_inheritor.description}", Icon = "m4a1_inheritor",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	m4a1_tactical_shot = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/m4a1_fire_control_skill",
		Name = "$bv{skill.m4a1_tactical_shot.name}", Description = "$bv{skill.m4a1_tactical_shot.description}", Icon = "m4a1_tactical_shot",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { Mode = "shot", AP = 3, Fatigue = 8 }
	},
	m4a1_three_round_burst = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/m4a1_fire_control_skill",
		Name = "$bv{skill.m4a1_three_round_burst.name}", Description = "$bv{skill.m4a1_three_round_burst.description}", Icon = "m4a1_three_round_burst",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { Mode = "burst", AP = 4, Fatigue = 18 }
	},
	m4a1_tactical_reload = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/m4a1_fire_control_skill",
		Name = "$bv{skill.m4a1_tactical_reload.name}", Description = "$bv{skill.m4a1_tactical_reload.description}", Icon = "m4a1_tactical_reload",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { Mode = "reload", AP = 3, Fatigue = 8, AmmoType = "standard" }
	},
	m4a1_reload_ap = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/m4a1_fire_control_skill",
		Name = "$bv{skill.m4a1_reload_ap.name}", Description = "$bv{skill.m4a1_reload_ap.description}", Icon = "m4a1_ap_ammo",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { Mode = "reload", AP = 3, Fatigue = 8, AmmoType = "ap" }
	},
	m4a1_firepower_focus = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/m4a1_fire_control_skill",
		Name = "$bv{skill.m4a1_firepower_focus.name}", Description = "$bv{skill.m4a1_firepower_focus.description}", Icon = "m4a1_firepower_focus",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { Mode = "focus", AP = 2, Fatigue = 15 }
	},
	m4a1_mark_of_vengeance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/m4a1_fire_control_skill",
		Name = "$bv{skill.m4a1_mark_of_vengeance.name}", Description = "$bv{skill.m4a1_mark_of_vengeance.description}", Icon = "m4a1_mark_of_vengeance",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { Mode = "cannon", AP = 6, Fatigue = 30 }
	},
	morgan_from_worlds_end = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/morgan_from_worlds_end_skill",
		Name = "$bv{skill.morgan_from_worlds_end.name}", Description = "$bv{skill.morgan_from_worlds_end.description}", Icon = "morgan_from_worlds_end",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { MaxMana = 6, StartingMana = 2, NormalTurnMana = 1, LanceManaLimit = 2, GutsHitpoints = 30 }
	},
	morgan_holy_lance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/morgan_holy_lance_skill",
		Name = "$bv{skill.morgan_holy_lance.name}", Description = "$bv{skill.morgan_holy_lance.description}", Icon = "morgan_holy_lance",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 18, MinRange = 1, MaxRange = 6, BaseDamage = 80, ResolveFactor = 0.5, ArmorDamageMult = 1.5, DirectDamageMult = 0.35, HitChance = 25 }
	},
	morgan_lake_grace = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/morgan_lake_grace_skill",
		Name = "$bv{skill.morgan_lake_grace.name}", Description = "$bv{skill.morgan_lake_grace.description}", Icon = "morgan_lake_grace",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 2, FatigueCost = 15, MinRange = 0, MaxRange = 4, CooldownRounds = 3, ActionPoints = 4, FatigueRecovery = 30, ManaGain = 2, DamageMult = 1.2 }
	},
	morgan_roadless_camelot = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/morgan_roadless_camelot_skill",
		Name = "$bv{skill.morgan_roadless_camelot.name}", Description = "$bv{skill.morgan_roadless_camelot.description}", Icon = "morgan_roadless_camelot",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 6, FatigueCost = 40, MinRange = 2, MaxRange = 7, Radius = 2, ManaCost = 6, BaseDamage = 160, ResolveFactor = 0.6, ArmorDamageMult = 2.0, DirectDamageMult = 0.40, HitChance = 40, OuterDamageMult = 0.7, CurseDamage = 15 }
	},
	meltryllis_sadistic_constitution = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/meltryllis_sadistic_constitution_skill",
		Name = "$bv{skill.meltryllis_sadistic_constitution.name}",
		Description = "$bv{skill.meltryllis_sadistic_constitution.description}",
		Icon = "meltryllis_sadistic_constitution",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	meltryllis_blade_dance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/meltryllis_blade_dance_skill",
		Name = "$bv{skill.meltryllis_blade_dance.name}",
		Description = "$bv{skill.meltryllis_blade_dance.description}",
		Icon = "meltryllis_blade_dance",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { AP = 3, Fatigue = 10, MinRange = 1, MaxRange = 1, Cooldown = 0, Attack = true, Ultimate = false }
	},
	meltryllis_crime_ballet = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/meltryllis_crime_ballet_skill",
		Name = "$bv{skill.meltryllis_crime_ballet.name}",
		Description = "$bv{skill.meltryllis_crime_ballet.description}",
		Icon = "meltryllis_crime_ballet",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { AP = 2, Fatigue = 15, MinRange = 0, MaxRange = 2, Cooldown = 2, Attack = false, Ultimate = false }
	},
	meltryllis_melt_virus = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/meltryllis_melt_virus_skill",
		Name = "$bv{skill.meltryllis_melt_virus.name}",
		Description = "$bv{skill.meltryllis_melt_virus.description}",
		Icon = "meltryllis_melt_virus",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { AP = 2, Fatigue = 10, MinRange = 1, MaxRange = 3, Cooldown = 3, Attack = false, Ultimate = false }
	},
	meltryllis_sarasvati_meltout = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/meltryllis_sarasvati_meltout_skill",
		Name = "$bv{skill.meltryllis_sarasvati_meltout.name}",
		Description = "$bv{skill.meltryllis_sarasvati_meltout.description}",
		Icon = "meltryllis_sarasvati_meltout",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { AP = 5, Fatigue = 30, MinRange = 1, MaxRange = 2, Cooldown = 3, Attack = true, Ultimate = true }
	},
	saber_invisible_air = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/saber_invisible_air_skill",
		Name = "$bv{skill.saber_invisible_air.name}",
		Description = "$bv{skill.saber_invisible_air.description}",
		Icon = "saber_invisible_air",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { HitChance = 10, MaxMana = 4, StartingMana = 1 }
	},
	saber_strike_air = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/saber_strike_air_skill",
		Name = "$bv{skill.saber_strike_air.name}",
		Description = "$bv{skill.saber_strike_air.description}",
		Icon = "saber_strike_air",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { ActionPointCost = 4, FatigueCost = 20, MinRange = 1, MaxRange = 4, ManaCost = 2, HitChance = 25, WeaponDamageMult = 1.0, ArmorDamageMult = 2.0, PushDistance = 2, DazeTurns = 1, IgnoreDistance = true, IgnoreShield = true }
	},
	saber_excalibur = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/saber_excalibur_skill",
		Name = "$bv{skill.saber_excalibur.name}",
		Description = "$bv{skill.saber_excalibur.description}",
		Icon = "saber_excalibur",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { ActionPointCost = 7, FatigueCost = 40, MinRange = 1, MaxRange = 8, ManaCost = 4, PerBattleUses = 1, BeamWidth = 1, HitChance = 50, WeaponDamageMult = 2.0, ArmorDamageMult = 2.0, DirectDamageAdd = 0.30, FixedBase = 50, BraveryMult = 0.25, IgnoreDistance = true, IgnoreShield = true }
	},
	jeanne_revelation_holy_banner = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/jeanne_revelation_holy_banner_skill",
		Name = "$bv{skill.jeanne_revelation_holy_banner.name}",
		Description = "$bv{skill.jeanne_revelation_holy_banner.description}",
		Icon = "jeanne_revelation_holy_banner",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { MaxRevelation = 4, StartingRevelation = 2, BaseAuraRange = 4, TrueBannerRange = 5 }
	},
	jeanne_true_name_divine_judgement = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jeanne_true_name_divine_judgement_skill",
		Name = "$bv{skill.jeanne_true_name_divine_judgement.name}",
		Description = "$bv{skill.jeanne_true_name_divine_judgement.description}",
		Icon = "jeanne_true_name_divine_judgement",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 20, RevelationCost = 2, MinRange = 1, MaxRange = 2, HitChance = 25, WeaponDamageMult = 1.30, ArmorDamageMult = 1.50, DirectDamageAdd = 0.15, IgnoreDistance = true, IgnoreShield = true }
	},
	jeanne_luminosite_eternelle = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jeanne_luminosite_eternelle_skill",
		Name = "$bv{skill.jeanne_luminosite_eternelle.name}",
		Description = "$bv{skill.jeanne_luminosite_eternelle.description}",
		Icon = "jeanne_luminosite_eternelle",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 6, FatigueCost = 30, RevelationCost = 4, BaseRange = 4, TrueBannerRange = 5, ProtectionTurns = 2, BlessingTurns = 2, HealPerTurn = 10 }
	},
	silver_wolf_aether_editing = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/silver_wolf_aether_editing_skill",
		Name = "$bv{skill.silver_wolf_aether_editing.name}",
		Description = "$bv{skill.silver_wolf_aether_editing.description}",
		Icon = "silver_wolf_weakness_implant",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	silver_wolf_attack_vulnerability = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/silver_wolf_attack_vulnerability_skill",
		Name = "$bv{skill.silver_wolf_attack_vulnerability.name}",
		Description = "$bv{skill.silver_wolf_attack_vulnerability.description}",
		Icon = "silver_wolf_attack_vulnerability",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jeanne_alter_dragon_witch = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/jeanne_alter_dragon_witch_skill",
		Name = "$bv{skill.jeanne_alter_dragon_witch.name}",
		Description = "$bv{skill.jeanne_alter_dragon_witch.description}",
		Icon = "jeanne_alter_dragon_witch",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jeanne_alter_la_grondement_du_haine = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jeanne_alter_la_grondement_du_haine_skill",
		Name = "$bv{skill.jeanne_alter_la_grondement_du_haine.name}",
		Description = "$bv{skill.jeanne_alter_la_grondement_du_haine.description}",
		Icon = "jeanne_alter_la_grondement_du_haine",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jingliu_cold_moon_sword_heart = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/jingliu_cold_moon_sword_heart_skill",
		Name = "$bv{skill.jingliu_cold_moon_sword_heart.name}",
		Description = "$bv{skill.jingliu_cold_moon_sword_heart.description}",
		Icon = "jingliu_cold_moon_sword_heart",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jingliu_moonflower_birth_and_death = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jingliu_moonflower_birth_and_death_skill",
		Name = "$bv{skill.jingliu_moonflower_birth_and_death.name}",
		Description = "$bv{skill.jingliu_moonflower_birth_and_death.description}",
		Icon = "jingliu_moonflower_birth_and_death",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	skirk_serpents_subtlety = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/skirk_serpents_subtlety_skill",
		Name = "$bv{skill.skirk_serpents_subtlety.name}",
		Description = "$bv{skill.skirk_serpents_subtlety.description}",
		Icon = "skirk_abyss_swordsmanship",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	skirk_havoc_warp = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/skirk_havoc_warp_skill",
		Name = "$bv{skill.skirk_havoc_warp.name}",
		Description = "$bv{skill.skirk_havoc_warp.description}",
		Icon = "skirk_abyssal_flash",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jinhsi_era_of_unity = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/jinhsi_era_of_unity_skill",
		Name = "$bv{skill.jinhsi_era_of_unity.name}",
		Description = "$bv{skill.jinhsi_era_of_unity.description}",
		Icon = "jinhsi_edict_guard",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/special.png", Text = "$bv{skill.jinhsi_era_of_unity.tooltip.ally}" }
			]
		}
	},
	jinhsi_incarnation = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jinhsi_incarnation_skill",
		Name = "$bv{skill.jinhsi_incarnation.name}",
		Description = "$bv{skill.jinhsi_incarnation.description}",
		Icon = "jinhsi_temporal_stasis",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	silver_wolf_defense_vulnerability = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/silver_wolf_defense_vulnerability_skill",
		Name = "$bv{skill.silver_wolf_defense_vulnerability.name}",
		Description = "$bv{skill.silver_wolf_defense_vulnerability.description}",
		Icon = "silver_wolf_defense_vulnerability",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	silver_wolf_speed_vulnerability = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/silver_wolf_speed_vulnerability_skill",
		Name = "$bv{skill.silver_wolf_speed_vulnerability.name}",
		Description = "$bv{skill.silver_wolf_speed_vulnerability.description}",
		Icon = "silver_wolf_speed_vulnerability",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	skirk_havoc_ruin = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/skirk_havoc_ruin_skill",
		Name = "$bv{skill.skirk_havoc_ruin.name}",
		Description = "$bv{skill.skirk_havoc_ruin.description}",
		Icon = "skirk_havoc_ruin",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jinhsi_illuminous_epiphany = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jinhsi_illuminous_epiphany_skill",
		Name = "$bv{skill.jinhsi_illuminous_epiphany.name}",
		Description = "$bv{skill.jinhsi_illuminous_epiphany.description}",
		Icon = "jinhsi_illuminous_epiphany",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	nahida_tri_karma_purification = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/nahida_tri_karma_purification_skill",
		Name = "$bv{skill.nahida_tri_karma_purification.name}",
		Description = "$bv{skill.nahida_tri_karma_purification.description}",
		Icon = "nahida_tri_karma_purification",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {
			DamageMin = 45,
			DamageMax = 60,
			BaseDirectDamage = 0.25,
			BaseTriggerCap = 2,
			ShrineTriggerCap = 3,
			ResolveFloor = 70,
			ResolvePerStep = 5,
			MaxResolveSteps = 10,
			DamagePerStep = 2,
			DirectPerStep = 0.015
		}
	},
	nahida_akara = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/nahida_akara_skill",
		Name = "$bv{skill.nahida_akara.name}",
		Description = "$bv{skill.nahida_akara.description}",
		Icon = "nahida_akara",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 10, MinRange = 1, MaxRange = 6, HitChance = 10, DamageMin = 55, DamageMax = 75, DirectDamage = 0.20 }
	},
	nahida_all_schemes_to_know = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/nahida_all_schemes_to_know_skill",
		Name = "$bv{skill.nahida_all_schemes_to_know.name}",
		Description = "$bv{skill.nahida_all_schemes_to_know.description}",
		Icon = "nahida_seed_of_skandha",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 18, MinRange = 2, MaxRange = 7, Radius = 2, MaxTargets = 4, Cooldown = 3, MarkDuration = 3, DamageMin = 40, DamageMax = 60, DirectDamage = 0.25 }
	},
	nahida_illusory_heart = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/nahida_illusory_heart_skill",
		Name = "$bv{skill.nahida_illusory_heart.name}",
		Description = "$bv{skill.nahida_illusory_heart.description}",
		Icon = "nahida_shrine_of_maya",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 25, Radius = 4, Duration = 3, MarkExtension = 1, SharedResolvePercent = 0.20, SharedResolveCap = 20, AllyDamagePercent = 0.50, KarmaDamageMult = 1.20 }
	},
	yae_miko_kitsune_thunder = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/yae_miko_kitsune_thunder_skill",
		Name = "$bv{skill.yae_miko_kitsune_thunder.name}",
		Description = "$bv{skill.yae_miko_kitsune_thunder.description}",
		Icon = "yae_miko_kitsune_thunder",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	yae_miko_tenko_thunder_domain = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/valkyrie_generic_active_skill",
		Name = "$bv{skill.yae_miko_tenko_thunder_domain.name}",
		Description = "$bv{skill.yae_miko_tenko_thunder_domain.description}",
		Icon = "yae_miko_tenko_thunder_domain",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			KilledString = "$bv{skill.yae_miko_tenko_thunder_domain.killed}",
			Tooltip = [
				{ Icon = "ui/icons/hitchance.png", Text = "$bv{skill.yae_miko_tenko_thunder_domain.tooltip.hit}" },
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.yae_miko_tenko_thunder_domain.tooltip.damage}" },
				{ Icon = "ui/icons/special.png", Text = "$bv{skill.yae_miko_tenko_thunder_domain.tooltip.special}" }
			],
			Target = "enemy",
			IsAttack = true,
			AttackType = "ranged",
			DamageMode = "fixed",
			MinRange = 2,
			MaxRange = 6,
			HitChance = 25,
			FixedDamage = 300,
			DirectDamage = 0.25,
			ArmorDamageMult = 1.25,
			VisualThemeOwner = "yae_miko_domain_cast",
			VisualThemeTarget = "yae_miko_thunder"
		}
	},
	chisaki_edge_followup = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.chisaki_edge_followup.name}",
		Description = "$bv{skill.chisaki_edge_followup.description}",
		Icon = "chisaki_edge_followup",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.chisaki_edge_followup.tooltip.damage}" },
				{ Icon = "ui/icons/action_points.png", Text = "$bv{skill.chisaki_edge_followup.tooltip.ap}" }
			],
			FirstHitBonusDamage = { AttackType = "melee", Damage = 30 },
			RecoverAPOnKill = { AttackType = "melee", Amount = 3 }
		}
	},
	chisaki_blood_slash = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/valkyrie_generic_active_skill",
		Name = "$bv{skill.chisaki_blood_slash.name}",
		Description = "$bv{skill.chisaki_blood_slash.description}",
		Icon = "chisaki_blood_slash",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			KilledString = "$bv{skill.chisaki_blood_slash.killed}",
			Tooltip = [
				{ Icon = "ui/icons/hitchance.png", Text = "$bv{skill.chisaki_blood_slash.tooltip.hit}" },
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.chisaki_blood_slash.tooltip.damage}" },
				{ Icon = "ui/icons/direct_damage.png", Text = "$bv{skill.chisaki_blood_slash.tooltip.direct}" },
				{ Icon = "ui/icons/fatigue.png", Text = "$bv{skill.chisaki_blood_slash.tooltip.fatigue}" }
			],
			Target = "enemy",
			IsAttack = true,
			AttackType = "melee",
			DamageMode = "weapon",
			MinRange = 1,
			MaxRange = 1,
			HitChance = 30,
			WeaponDamageMult = 2.0,
			ArmorDamageMult = 2.0,
			DirectDamageAdd = 0.20,
			FatigueMultOnKill = 0.5,
			VisualThemeOwner = "chisaki_blood_cast",
			VisualThemeTarget = "chisaki_blood_slash"
		}
	},
	kafka_script_direction = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/kafka_script_direction_skill",
		Name = "$bv{skill.kafka_script_direction.name}",
		Description = "$bv{skill.kafka_script_direction.description}",
		Icon = "kafka_spirit_whisper",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { SharedUsesPerRound = 1, EchoAP = 2, UniqueDirectiveSlots = 1 }
	},
	kafka_your_turn = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/kafka_your_turn_skill",
		Name = "$bv{skill.kafka_your_turn.name}",
		Description = "$bv{skill.kafka_your_turn.description}",
		Icon = "kafka_your_turn",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { Target = "ally", IsAttack = false, ActionPointCost = 5, FatigueCost = 15, MinRange = 1, MaxRange = 5 }
	},
	kafka_listen_to_me = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/kafka_listen_to_me_skill",
		Name = "$bv{skill.kafka_listen_to_me.name}",
		Description = "$bv{skill.kafka_listen_to_me.description}",
		Icon = "kafka_listen_to_me",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { Target = "enemy", IsAttack = false, ActionPointCost = 5, FatigueCost = 15, MinRange = 1, MaxRange = 5 }
	},
	ye_shunguang_enlightened_clarity = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/ye_shunguang_enlightened_clarity_skill",
		Name = "$bv{skill.ye_shunguang_enlightened_clarity.name}",
		Description = "$bv{skill.ye_shunguang_enlightened_clarity.description}",
		Icon = "ye_shunguang_qingming_guard",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	ye_shunguang_reflection = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/ye_shunguang_reflection_skill",
		Name = "$bv{skill.ye_shunguang_reflection.name}",
		Description = "$bv{skill.ye_shunguang_reflection.description}",
		Icon = "ye_shunguang_reflection",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { IsAttack = false, ActionPointCost = 2, FatigueCost = 10 }
	},
	ye_shunguang_return_to_dust = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/ye_shunguang_return_to_dust_skill",
		Name = "$bv{skill.ye_shunguang_return_to_dust.name}",
		Description = "$bv{skill.ye_shunguang_return_to_dust.description}",
		Icon = "ye_shunguang_cut_filth",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { IsAttack = false, ActionPointCost = 5, FatigueCost = 25 }
	},
	himeko_victory_rush = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/himeko_victory_rush_skill",
		Name = "$bv{skill.himeko_victory_rush.name}",
		Description = "$bv{skill.himeko_victory_rush.description}",
		Icon = "himeko_fire_support_calibration",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = ["himeko_before_trailblaze"],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	himeko_heavenly_flare = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/himeko_heavenly_flare_skill",
		Name = "$bv{skill.himeko_heavenly_flare.name}",
		Description = "$bv{skill.himeko_heavenly_flare.description}",
		Icon = "himeko_orbital_suppression",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	feixue_everfrost_dominion = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/feixue_everfrost_dominion_skill",
		Name = "$bv{skill.feixue_everfrost_dominion.name}",
		Description = "$bv{skill.feixue_everfrost_dominion.description}",
		Icon = "feixue_snowstep",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	feixue_mushin_iai = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/feixue_mushin_iai_skill",
		Name = "$bv{skill.feixue_mushin_iai.name}",
		Description = "$bv{skill.feixue_mushin_iai.description}",
		Icon = "feixue_mushin_iai",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 3, FatigueCost = 15, MinRange = 1, MaxRange = 3 }
	},
	feixue_blade_liberation = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/feixue_blade_liberation_skill",
		Name = "$bv{skill.feixue_blade_liberation.name}",
		Description = "$bv{skill.feixue_blade_liberation.description}",
		Icon = "feixue_blade_liberation",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 30 }
	},
	feixiao_thunderhunt = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/feixiao_thunderhunt_skill",
		Name = "$bv{skill.feixiao_thunderhunt.name}",
		Description = "$bv{skill.feixiao_thunderhunt.description}",
		Icon = "feixiao_hunt_pressure",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { StartingAureus = 3, MaxAureus = 6, AttacksPerAureus = 2, MaxGainsPerRound = 2, FollowupRange = 4, FollowupHitChance = 20, FollowupWeaponDamageMult = 0.60, FollowupArmorDamageMult = 1.0 }
	},
	feixiao_waraxe = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/feixiao_waraxe_skill",
		Name = "$bv{skill.feixiao_waraxe.name}",
		Description = "$bv{skill.feixiao_waraxe.description}",
		Icon = "feixiao_waraxe",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 20, MinRange = 1, MaxRange = 3, UsesPerRound = 1, HitChance = 20, WeaponDamageMult = 1.0, ArmorDamageMult = 1.25, FollowupWeaponDamageMult = 0.60, FollowupArmorDamageMult = 1.0 }
	},
	feixiao_terraverge = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/feixiao_terraverge_skill",
		Name = "$bv{skill.feixiao_terraverge.name}",
		Description = "$bv{skill.feixiao_terraverge.description}",
		Icon = "feixiao_terraverge",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 35, MinRange = 1, MaxRange = 4, RequiredAureus = 6, Strikes = 6, HitChance = 30, ArmorStrikeWeaponDamageMult = 0.30, ArmorStrikeArmorDamageMult = 2.50, ArmorStrikeDirectDamage = 0.0, UnarmoredFixedDamage = 5, FinisherWeaponDamageMult = 1.0, FinisherArmorDamageMult = 1.50, FinisherDirectDamageAdd = 0.30, FinisherFixedDamage = 20 }
	},
	changli_true_sight_enflamement = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/changli_true_sight_enflamement_skill",
		Name = "$bv{skill.changli_true_sight_enflamement.name}",
		Description = "$bv{skill.changli_true_sight_enflamement.description}",
		Icon = "changli_delayed_strategy",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	changli_radiance_of_fealty = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/changli_radiance_of_fealty_skill",
		Name = "$bv{skill.changli_radiance_of_fealty.name}",
		Description = "$bv{skill.changli_radiance_of_fealty.description}",
		Icon = "changli_inferno_seal",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Radius = 2,
			HitChance = 20,
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.25,
			ActionPointCost = 5,
			FatigueCost = 20,
			MaxUses = 1
		}
	},
	changli_flaming_sacrifice = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/changli_flaming_sacrifice_skill",
		Name = "$bv{skill.changli_flaming_sacrifice.name}",
		Description = "$bv{skill.changli_flaming_sacrifice.description}",
		Icon = "changli_flaming_sacrifice",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Radius = 1,
			HitChance = 25,
			WeaponDamageMult = 1.6,
			ArmorDamageMult = 1.5,
			ActionPointCost = 4,
			FatigueCost = 20,
			RequiredLayers = 4
		}
	},
	raiden_shogun_eternal_authority = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.raiden_shogun_eternal_authority.name}",
		Description = "$bv{skill.raiden_shogun_eternal_authority.description}",
		Icon = "raiden_shogun_eternal_authority",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/hitchance.png", Text = "$bv{skill.raiden_shogun_eternal_authority.tooltip.hit}" },
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.raiden_shogun_eternal_authority.tooltip.damage}" },
				{ Icon = "ui/icons/direct_damage.png", Text = "$bv{skill.raiden_shogun_eternal_authority.tooltip.ignore_armor}" }
			],
			AttackBonus = { AttackType = "melee", HitChance = 10, DamageMult = 1.1 },
			IgnoreArmor = { AttackType = "any" }
		}
	},
	raiden_shogun_musou_no_hitotachi = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/valkyrie_generic_active_skill",
		Name = "$bv{skill.raiden_shogun_musou_no_hitotachi.name}",
		Description = "$bv{skill.raiden_shogun_musou_no_hitotachi.description}",
		Icon = "raiden_shogun_musou_no_hitotachi",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			KilledString = "$bv{skill.raiden_shogun_musou_no_hitotachi.killed}",
			Tooltip = [
				{ Icon = "ui/icons/hitchance.png", Text = "$bv{skill.raiden_shogun_musou_no_hitotachi.tooltip.hit}" },
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.raiden_shogun_musou_no_hitotachi.tooltip.damage}" },
				{ Icon = "ui/icons/special.png", Text = "$bv{skill.raiden_shogun_musou_no_hitotachi.tooltip.special}" }
			],
			Target = "enemy",
			IsAttack = true,
			AttackType = "melee",
			DamageMode = "fixed",
			MinRange = 1,
			MaxRange = 5,
			HitChance = 30,
			FixedDamage = 140,
			DirectDamage = 0.30,
			ArmorDamageMult = 1.5,
			EffectsOnHit = [{ Type = "stunned", Turns = 1 }]
		}
	},
	yixuan_arcane_mastery = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/yixuan_arcane_mastery_skill",
		Name = "$bv{skill.yixuan_arcane_mastery.name}",
		Description = "$bv{skill.yixuan_arcane_mastery.description}",
		Icon = "yixuan_preceptor_stance",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	yixuan_auric_ink_shock = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/yixuan_auric_ink_shock_skill",
		Name = "$bv{skill.yixuan_auric_ink_shock.name}",
		Description = "$bv{skill.yixuan_auric_ink_shock.description}",
		Icon = "yixuan_mountain_suppression",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			MinRange = 1,
			MaxRange = 3,
			HitChance = 20,
			WeaponDamageMult = 1.2,
			ArmorDamageMult = 1.5,
			ActionPointCost = 4,
			FatigueCost = 20,
			PerTurnUses = 1,
			IgnoreDistance = true,
			IgnoreShield = true
		}
	},
	yixuan_endless_talisman_suppression = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/yixuan_endless_talisman_suppression_skill",
		Name = "$bv{skill.yixuan_endless_talisman_suppression.name}",
		Description = "$bv{skill.yixuan_endless_talisman_suppression.description}",
		Icon = "yixuan_endless_talisman_suppression",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			MinRange = 2,
			MaxRange = 6,
			Radius = 1,
			HitChance = 30,
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.5,
			ActionPointCost = 6,
			FatigueCost = 30,
			RequiredPoints = 3,
			IgnoreDistance = true,
			IgnoreShield = true
		}
	},
	xilian_memory_sanctuary = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.xilian_memory_sanctuary.name}",
		Description = "$bv{skill.xilian_memory_sanctuary.description}",
		Icon = "xilian_memory_sanctuary",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/melee_defense.png", Text = "$bv{skill.xilian_memory_sanctuary.tooltip.melee_defense}" },
				{ Icon = "ui/icons/ranged_defense.png", Text = "$bv{skill.xilian_memory_sanctuary.tooltip.ranged_defense}" }
			],
			Bonuses = { MeleeDefense = 10, RangedDefense = 10 }
		}
	},
	xilian_beyond_closed_loop = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/xilian_beyond_closed_loop_skill",
		Name = "$bv{skill.xilian_beyond_closed_loop.name}",
		Description = "$bv{skill.xilian_beyond_closed_loop.description}",
		Icon = "xilian_beyond_closed_loop",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/action_points.png", Text = "$bv{skill.xilian_beyond_closed_loop.tooltip.ap}" },
				{ Icon = "ui/icons/health.png", Text = "$bv{skill.xilian_beyond_closed_loop.tooltip.health}" },
				{ Icon = "ui/icons/armor_body.png", Text = "$bv{skill.xilian_beyond_closed_loop.tooltip.armor}" },
				{ Icon = "ui/icons/special.png", Text = "$bv{skill.xilian_beyond_closed_loop.tooltip.injuries}" }
			],
			Target = "ally",
			IsAttack = false,
			MinRange = 1,
			MaxRange = 5,
			SetTargetAP = "max",
			RestoreTargetVitals = true,
			RestoreTargetInjuries = true
		}
	},
	xilian_test_full_vision = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/xilian_test_full_vision_skill",
		Name = "$bv{skill.xilian_test_full_vision.name}",
		Description = "$bv{skill.xilian_test_full_vision.description}",
		Icon = "skills/active_104.png",
		IconDisabled = "skills/active_104_sw.png",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = ["test_origin"],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	xilian_test_annihilation = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/xilian_test_annihilation_skill",
		Name = "$bv{skill.xilian_test_annihilation.name}",
		Description = "$bv{skill.xilian_test_annihilation.description}",
		Icon = "xilian_beyond_closed_loop",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = ["test_origin"],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	himeko_we_are_trailblaze = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/himeko_we_are_trailblaze_skill",
		Name = "$bv{skill.himeko_we_are_trailblaze.name}",
		Description = "$bv{skill.himeko_we_are_trailblaze.description}",
		Icon = "himeko_astral_oath",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = ["himeko_after_trailblaze"],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	liuying_iron_cavalry_armor = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.liuying_iron_cavalry_armor.name}",
		Description = "$bv{skill.liuying_iron_cavalry_armor.description}",
		Icon = "liuying_iron_cavalry_armor",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.liuying_iron_cavalry_armor.tooltip.reduction}" }
			],
			DamageReductionMult = 0.5
		}
	},
	liuying_sam_suppression_charge = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/valkyrie_generic_active_skill",
		Name = "$bv{skill.liuying_sam_suppression_charge.name}",
		Description = "$bv{skill.liuying_sam_suppression_charge.description}",
		Icon = "liuying_sam_suppression_charge",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/action_points.png", Text = "$bv{skill.liuying_sam_suppression_charge.tooltip.ap}" },
				{ Icon = "ui/icons/health.png", Text = "$bv{skill.liuying_sam_suppression_charge.tooltip.health}" },
				{ Icon = "ui/icons/armor_body.png", Text = "$bv{skill.liuying_sam_suppression_charge.tooltip.armor}" },
				{ Icon = "ui/icons/special.png", Text = "$bv{skill.liuying_sam_suppression_charge.tooltip.injuries}" }
			],
			Target = "self",
			IsAttack = false,
			MinRange = 0,
			MaxRange = 0,
			SetTargetAP = "max",
			RestoreTargetVitals = true,
			RestoreTargetInjuries = true
		}
	},
	cartethyia_aero_erosion_web = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/cartethyia_aero_erosion_web_skill",
		Name = "$bv{skill.cartethyia_aero_erosion_web.name}",
		Description = "$bv{skill.cartethyia_aero_erosion_web.description}",
		Icon = "cartethyia_wind_net",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cartethyia_sword_in_humanity_name = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cartethyia_sword_in_humanity_name_skill",
		Name = "$bv{skill.cartethyia_sword_in_humanity_name.name}",
		Description = "$bv{skill.cartethyia_sword_in_humanity_name.description}",
		Icon = "cartethyia_storm_verdict",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cartethyia_knights_heartfelt_prayers = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cartethyia_knights_heartfelt_prayers_skill",
		Name = "$bv{skill.cartethyia_knights_heartfelt_prayers.name}",
		Description = "$bv{skill.cartethyia_knights_heartfelt_prayers.description}",
		Icon = "cartethyia_knights_heartfelt_prayers",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	cartethyia_tempest_break_tides = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cartethyia_tempest_break_tides_skill",
		Name = "$bv{skill.cartethyia_tempest_break_tides.name}",
		Description = "$bv{skill.cartethyia_tempest_break_tides.description}",
		Icon = "cartethyia_tempest_break_tides",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	cartethyia_blade_howling_squall = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cartethyia_blade_howling_squall_skill",
		Name = "$bv{skill.cartethyia_blade_howling_squall.name}",
		Description = "$bv{skill.cartethyia_blade_howling_squall.description}",
		Icon = "cartethyia_blade_howling_squall",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = {}
	},
	castorice_newbud = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/castorice_newbud_skill",
		Name = "$bv{skill.castorice_newbud.name}",
		Description = "$bv{skill.castorice_newbud.description}",
		Icon = "castorice_newbud",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	castorice_cocoon_drain = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/castorice_cocoon_drain_skill",
		Name = "$bv{skill.castorice_cocoon_drain.name}",
		Description = "$bv{skill.castorice_cocoon_drain.description}",
		Icon = "castorice_cocoon_drain",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	castorice_netherwing_descent = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/castorice_netherwing_descent_skill",
		Name = "$bv{skill.castorice_netherwing_descent.name}",
		Description = "$bv{skill.castorice_netherwing_descent.description}",
		Icon = "castorice_netherwing_descent",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	changyeyue_long_night = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/changyeyue_long_night_skill",
		Name = "$bv{skill.changyeyue_long_night.name}",
		Description = "$bv{skill.changyeyue_long_night.description}",
		Icon = "changyeyue_moonbound_crystal_thread",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	changyeyue_darkest_riddle = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/changyeyue_darkest_riddle_skill",
		Name = "$bv{skill.changyeyue_darkest_riddle.name}",
		Description = "$bv{skill.changyeyue_darkest_riddle.description}",
		Icon = "changyeyue_darkest_riddle",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	hysilens_tidal_erosion = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/hysilens_tidal_erosion_skill",
		Name = "$bv{skill.hysilens_tidal_erosion.name}",
		Description = "$bv{skill.hysilens_tidal_erosion.description}",
		Icon = "hysilens_tidal_erosion",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	hysilens_crystal_tide = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/hysilens_crystal_tide_skill",
		Name = "$bv{skill.hysilens_crystal_tide.name}",
		Description = "$bv{skill.hysilens_crystal_tide.description}",
		Icon = "hysilens_crystal_tide",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	tilixibiesi_underworld_coordinates = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.tilixibiesi_underworld_coordinates.name}",
		Description = "$bv{skill.tilixibiesi_underworld_coordinates.description}",
		Icon = "tilixibiesi_underworld_coordinates",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/initiative.png", Text = "$bv{skill.tilixibiesi_underworld_coordinates.tooltip.initiative}" }
			]
		}
	},
	tilixibiesi_beyond_warp = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/tilixibiesi_beyond_warp_skill",
		Name = "$bv{skill.tilixibiesi_beyond_warp.name}",
		Description = "$bv{skill.tilixibiesi_beyond_warp.description}",
		Icon = "tilixibiesi_beyond_warp",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cipher_old_patron = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/cipher_old_patron_skill",
		Name = "$bv{skill.cipher_old_patron.name}",
		Description = "$bv{skill.cipher_old_patron.description}",
		Icon = "cipher_lucky_paw",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cipher_name_your_price = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cipher_name_your_price_skill",
		Name = "$bv{skill.cipher_name_your_price.name}",
		Description = "$bv{skill.cipher_name_your_price.description}",
		Icon = "cipher_name_your_price",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cipher_moonlit_heist = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cipher_moonlit_heist_skill",
		Name = "$bv{skill.cipher_moonlit_heist.name}",
		Description = "$bv{skill.cipher_moonlit_heist.description}",
		Icon = "cipher_moonlit_heist",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cerydra_war_banner = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/cerydra_war_banner_skill",
		Name = "$bv{skill.cerydra_war_banner.name}",
		Description = "$bv{skill.cerydra_war_banner.description}",
		Icon = "cerydra_royal_edict",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cerydra_promote_pawn = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cerydra_promote_pawn_skill",
		Name = "$bv{skill.cerydra_promote_pawn.name}",
		Description = "$bv{skill.cerydra_promote_pawn.description}",
		Icon = "cerydra_promote_pawn",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	cerydra_checkmate_command = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/cerydra_checkmate_command_skill",
		Name = "$bv{skill.cerydra_checkmate_command.name}",
		Description = "$bv{skill.cerydra_checkmate_command.description}",
		Icon = "cerydra_checkmate_command",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	fengjin_tailwind_rhythm = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.fengjin_tailwind_rhythm.name}",
		Description = "$bv{skill.fengjin_tailwind_rhythm.description}",
		Icon = "fengjin_healing_breeze",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/initiative.png", Text = "$bv{skill.fengjin_tailwind_rhythm.tooltip.initiative}" }
			],
			Bonuses = { Initiative = 40 }
		}
	},
	fengjin_feather_rescue = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/fengjin_feather_rescue_skill",
		Name = "$bv{skill.fengjin_feather_rescue.name}",
		Description = "$bv{skill.fengjin_feather_rescue.description}",
		Icon = "fengjin_feather_rescue",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	fengjin_icarus_impact = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/fengjin_icarus_impact_skill",
		Name = "$bv{skill.fengjin_icarus_impact.name}",
		Description = "$bv{skill.fengjin_icarus_impact.description}",
		Icon = "fengjin_skyward_companion",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	yuno_destined_hunt = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/yuno_destined_hunt_skill",
		Name = "$bv{skill.yuno_destined_hunt.name}",
		Description = "$bv{skill.yuno_destined_hunt.description}",
		Icon = "yuno_oracle_guard",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { HitChanceBonus = 15, DamageMultiplier = 1.20, Duration = "round" }
	},
	yuno_death_omen = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/yuno_death_omen_skill",
		Name = "$bv{skill.yuno_death_omen.name}",
		Description = "$bv{skill.yuno_death_omen.description}",
		Icon = "yuno_fate_rewrite",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { Target = "enemy", IsAttack = false, MinRange = 1, MaxRange = 6, APPerUse = 6, HitChanceBonus = 35, FixedDamage = 20, WeaponDamageMult = 1.0, APReduction = 4, KillRefund = 4 }
	},
	phoebe_absolution_litany = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/phoebe_absolution_litany_skill",
		Name = "$bv{skill.phoebe_absolution_litany.name}",
		Description = "$bv{skill.phoebe_absolution_litany.description}",
		Icon = "phoebe_absolution_litany",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { HitChanceBonus = 10, DamageMultiplier = 1.25, DirectDamageAdd = 0.30 }
	},
	phoebe_to_where_light_shines = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/phoebe_to_where_light_shines_skill",
		Name = "$bv{skill.phoebe_to_where_light_shines.name}",
		Description = "$bv{skill.phoebe_to_where_light_shines.description}",
		Icon = "phoebe_to_where_light_shines",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { Target = "enemy", IsAttack = false, MinRange = 2, MaxRange = 6, ActionPointCost = 2, FatigueCost = 30, Radius = 1, DazedTurns = 1, StaggeredTurns = 1 }
	},
	wisadel_souvenir = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/valkyrie_generic_passive_skill",
		Name = "$bv{skill.wisadel_souvenir.name}",
		Description = "$bv{skill.wisadel_souvenir.description}",
		Icon = "wisadel_souvenir",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			Tooltip = [
				{ Icon = "ui/icons/regular_damage.png", Text = "$bv{skill.wisadel_souvenir.tooltip.damage}" },
				{ Icon = "ui/icons/special.png", Text = "$bv{skill.wisadel_souvenir.tooltip.stagger}" }
			],
			AttackBonus = { AttackType = "ranged", DamageMult = 1.15 },
			FirstHitEffect = { AttackType = "ranged", Effects = [{ Type = "staggered", Turns = 1 }] }
		}
	},
	wisadel_explosive_dawn = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/wisadel_explosive_dawn_skill",
		Name = "$bv{skill.wisadel_explosive_dawn.name}",
		Description = "$bv{skill.wisadel_explosive_dawn.description}",
		Icon = "wisadel_explosive_dawn",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = { ActionPointCost = 7, FatigueCost = 30, MinRange = 2, MaxRange = 7, Radius = 1, HitChance = 25, WeaponDamageMult = 1.50, ArmorDamageMult = 1.50, DazedTurns = 1, IgnoreDistance = true, IgnoreShield = true }
	},
	aglaea_seam_stitch = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/aglaea_seam_stitch_skill",
		Name = "$bv{skill.aglaea_seam_stitch.name}",
		Description = "$bv{skill.aglaea_seam_stitch.description}",
		Icon = "aglaea_seam_stitch",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	aglaea_destined_weaving_dance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/aglaea_destined_weaving_dance_skill",
		Name = "$bv{skill.aglaea_destined_weaving_dance.name}",
		Description = "$bv{skill.aglaea_destined_weaving_dance.description}",
		Icon = "aglaea_destined_weaving_dance",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	mai_shiranui_kachosen = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/mai_shiranui_kachosen_skill",
		Name = "$bv{skill.mai_shiranui_kachosen.name}",
		Description = "$bv{skill.mai_shiranui_kachosen.description}",
		Icon = "mai_shiranui_kachosen",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	mai_shiranui_chou_hissatsu_shinobi_bachi = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/mai_shiranui_chou_hissatsu_shinobi_bachi_skill",
		Name = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.name}",
		Description = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.description}",
		Icon = "mai_shiranui_chou_hissatsu_shinobi_bachi",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	scarlet_shadow_flyflower = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/scarlet_shadow_flyflower_skill",
		Name = "$bv{skill.scarlet_shadow_flyflower.name}",
		Description = "$bv{skill.scarlet_shadow_flyflower.description}",
		Icon = "scarlet_shadow_flyflower",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	scarlet_shadow_flower_shadow_trinity = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/scarlet_shadow_flower_shadow_trinity_skill",
		Name = "$bv{skill.scarlet_shadow_flower_shadow_trinity.name}",
		Description = "$bv{skill.scarlet_shadow_flower_shadow_trinity.description}",
		Icon = "scarlet_shadow_flower_shadow_trinity",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	scarlet_shadow_fading_blossom = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/scarlet_shadow_fading_blossom_skill",
		Name = "$bv{skill.scarlet_shadow_fading_blossom.name}",
		Description = "$bv{skill.scarlet_shadow_fading_blossom.description}",
		Icon = "scarlet_shadow_fading_blossom",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	liuying_sam_deploy = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/liuying_sam_deploy_skill",
		Name = "$bv{skill.liuying_sam_deploy.name}",
		Description = "$bv{skill.liuying_sam_deploy.description}",
		Icon = "liuying_sam_deploy",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	himeko_astral_lance_strike = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/himeko_astral_lance_strike_skill",
		Name = "$bv{skill.himeko_astral_lance_strike.name}",
		Description = "$bv{skill.himeko_astral_lance_strike.description}",
		Icon = "himeko_astral_lance_strike",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jeanne_holy_banner_thrust = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jeanne_holy_banner_thrust_skill",
		Name = "$bv{skill.jeanne_holy_banner_thrust.name}",
		Description = "$bv{skill.jeanne_holy_banner_thrust.description}",
		Icon = "jeanne_holy_banner_thrust",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	jeanne_holy_banner_sweep = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/jeanne_holy_banner_sweep_skill",
		Name = "$bv{skill.jeanne_holy_banner_sweep.name}",
		Description = "$bv{skill.jeanne_holy_banner_sweep.description}",
		Icon = "jeanne_holy_banner_sweep",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	himeko_trailblazer_deploy = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/himeko_trailblazer_deploy_skill",
		Name = "$bv{skill.himeko_trailblazer_deploy.name}",
		Description = "$bv{skill.himeko_trailblazer_deploy.description}",
		Icon = "himeko_trailblazer_deploy",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	liuying_molten_drive = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/liuying_molten_drive_skill",
		Name = "$bv{skill.liuying_molten_drive.name}",
		Description = "$bv{skill.liuying_molten_drive.description}",
		Icon = "liuying_molten_drive",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	liuying_ignite_the_sea = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/liuying_ignite_the_sea_skill",
		Name = "$bv{skill.liuying_ignite_the_sea.name}",
		Description = "$bv{skill.liuying_ignite_the_sea.description}",
		Icon = "liuying_ignite_the_sea",
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {}
	},
	sparxie_backstage_trick = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/sparxie_backstage_trick_skill",
		Name = "$bv{skill.sparxie_backstage_trick.name}",
		Description = "$bv{skill.sparxie_backstage_trick.description}",
		Icon = "sparxie_backstage_trick",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			MaxSmile = 6,
			TeamDamagePerSmile = 0.02,
			ExclusiveDamagePerSmile = 0.04,
			GuestGiftCount = 3,
			GiftWeaponDamageMult = 0.30,
			GiftArmorDamageMult = 1.0
		}
	},
	sparxie_live_connection = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/sparxie_live_connection_skill",
		Name = "$bv{skill.sparxie_live_connection.name}",
		Description = "$bv{skill.sparxie_live_connection.description}",
		Icon = "sparxie_live_connection",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			ActionPointCost = 4,
			FatigueCost = 15,
			MinRange = 2,
			MaxRange = 6,
			HitChance = 20,
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.0
		}
	},
	sparxie_carnival_live = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/sparxie_carnival_live_skill",
		Name = "$bv{skill.sparxie_carnival_live.name}",
		Description = "$bv{skill.sparxie_carnival_live.description}",
		Icon = "sparxie_carnival_live",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = {
			MinLevel = 1,
			RequiredSkills = [],
			ForbiddenSkills = []
		},
		Spec = {
			ActionPointCost = 5,
			FatigueCost = 30,
			Radius = 6,
			HitChance = 30,
			WeaponDamageMult = 0.80,
			ArmorDamageMult = 1.25,
			FollowupWeaponDamageMult = 0.25,
			FollowupArmorDamageMult = 0.50
		}
	},
	robin_harmonic_resonance = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/robin_harmonic_resonance_skill",
		Name = "$bv{skill.robin_harmonic_resonance.name}",
		Description = "$bv{skill.robin_harmonic_resonance.description}",
		Icon = "robin_harmonic_resonance",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { MaxHarmony = 12 }
	},
	robin_winged_sunny_song = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/robin_winged_sunny_song_skill",
		Name = "$bv{skill.robin_winged_sunny_song.name}",
		Description = "$bv{skill.robin_winged_sunny_song.description}",
		Icon = "robin_winged_sunny_song",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 20, CooldownRounds = 3, Heal = 15, FatigueRecovery = 20 }
	},
	robin_encore_for_you = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/robin_encore_for_you_skill",
		Name = "$bv{skill.robin_encore_for_you.name}",
		Description = "$bv{skill.robin_encore_for_you.description}",
		Icon = "robin_encore_for_you",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 15, HarmonyCost = 3, MinRange = 1, MaxRange = 7, APRecovery = 6, HealPercent = 0.20 }
	},
	robin_myriad_tones_starry_fugue = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/robin_myriad_tones_starry_fugue_skill",
		Name = "$bv{skill.robin_myriad_tones_starry_fugue.name}",
		Description = "$bv{skill.robin_myriad_tones_starry_fugue.description}",
		Icon = "robin_myriad_tones_starry_fugue",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 9, FatigueCost = 35, HarmonyCost = 12, APRecovery = 4, FatigueRecovery = 20, HealPercent = 0.20, EchoDamage = 25, EchoHeal = 15, EchoFatigueRecovery = 10 }
	},
	hakurei_reimu_inborn_intuition = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/hakurei_reimu_inborn_intuition_skill",
		Name = "$bv{skill.hakurei_reimu_inborn_intuition.name}",
		Description = "$bv{skill.hakurei_reimu_inborn_intuition.description}",
		Icon = "hakurei_reimu_inborn_intuition",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { MaxSpiritPower = 4, StartingSpiritPower = 1 }
	},
	hakurei_reimu_hakurei_amulet = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/hakurei_reimu_hakurei_amulet_skill",
		Name = "$bv{skill.hakurei_reimu_hakurei_amulet.name}",
		Description = "$bv{skill.hakurei_reimu_hakurei_amulet.description}",
		Icon = "hakurei_reimu_hakurei_amulet",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 15, MinRange = 2, MaxRange = 6, HitChance = 20, DamageMin = 55, DamageMax = 75, ArmorDamageMult = 0.80, DirectDamage = 0.35 }
	},
	hakurei_reimu_duplex_barrier = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/hakurei_reimu_duplex_barrier_skill",
		Name = "$bv{skill.hakurei_reimu_duplex_barrier.name}",
		Description = "$bv{skill.hakurei_reimu_duplex_barrier.description}",
		Icon = "hakurei_reimu_duplex_barrier",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 20, MaxRange = 4, DefenseBonus = 20, HitpointReduction = 25 }
	},
	hakurei_reimu_fantasy_seal = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/hakurei_reimu_fantasy_seal_skill",
		Name = "$bv{skill.hakurei_reimu_fantasy_seal.name}",
		Description = "$bv{skill.hakurei_reimu_fantasy_seal.description}",
		Icon = "hakurei_reimu_fantasy_seal",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 30, MinRange = 2, MaxRange = 7, SpiritPowerCost = 4, PrimaryDamageMin = 150, PrimaryDamageMax = 190, PrimaryArmorDamageMult = 1.25, PrimaryDirectDamage = 0.40, AreaDamageMin = 80, AreaDamageMax = 110, AreaArmorDamageMult = 1.0, AreaDirectDamage = 0.25, MarkBonusDamage = 30 }
	},
	sword_maiden_unseeing_mind = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/sword_maiden_unseeing_mind_skill",
		Name = "$bv{skill.sword_maiden_unseeing_mind.name}",
		Description = "$bv{skill.sword_maiden_unseeing_mind.description}",
		Icon = "sword_maiden_unseeing_mind",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { FirstHitChance = 20, WeaponDamageMult = 1.20, DirectDamageAdd = 0.15 }
	},
	sword_maiden_balance_condemnation = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/sword_maiden_balance_condemnation_skill",
		Name = "$bv{skill.sword_maiden_balance_condemnation.name}",
		Description = "$bv{skill.sword_maiden_balance_condemnation.description}",
		Icon = "sword_maiden_balance_condemnation",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 18, MinRange = 1, MaxRange = 2, HitChance = 20, WeaponDamageMult = 1.60, GoblinDamageMult = 2.10, ArmorDamageMult = 1.40, DirectDamageAdd = 0.25 }
	},
	sword_maiden_goblin_codex = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/sword_maiden_goblin_codex_skill",
		Name = "$bv{skill.sword_maiden_goblin_codex.name}",
		Description = "$bv{skill.sword_maiden_goblin_codex.description}",
		Icon = "sword_maiden_goblin_codex",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		SwordMaidenHuntPoints = 0,
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { RankStep = 25, MaxRank = 12, HitpointsPerRank = 2, FatiguePerRank = 2, MeleeSkillPerRank = 1, MeleeDefensePerRank = 1, DamagePerRank = 0.01 }
	},
	sword_maiden_cave_survivor = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/sword_maiden_cave_survivor_skill",
		Name = "$bv{skill.sword_maiden_cave_survivor.name}",
		Description = "$bv{skill.sword_maiden_cave_survivor.description}",
		Icon = "sword_maiden_cave_survivor",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		SwordMaidenHuntPoints = 25,
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointRestore = 2, ControlledDamageMult = 1.15 }
	},
	sword_maiden_holy_binding_judgment = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/sword_maiden_holy_binding_judgment_skill",
		Name = "$bv{skill.sword_maiden_holy_binding_judgment.name}",
		Description = "$bv{skill.sword_maiden_holy_binding_judgment.description}",
		Icon = "sword_maiden_holy_binding_judgment",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		SwordMaidenHuntPoints = 75,
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 3, FatigueCost = 15, MaxRange = 4, Cooldown = 2, Duration = 2, CombatStatPenalty = 15 }
	},
	sword_maiden_root_extermination = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/sword_maiden_root_extermination_skill",
		Name = "$bv{skill.sword_maiden_root_extermination.name}",
		Description = "$bv{skill.sword_maiden_root_extermination.description}",
		Icon = "sword_maiden_root_extermination",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		SwordMaidenHuntPoints = 150,
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { FirstKillActionPoints = 4, FirstKillFatigue = 12, GoblinTriggersPerTurn = 2 }
	},
	sword_maiden_balance_final_judgment = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/sword_maiden_balance_final_judgment_skill",
		Name = "$bv{skill.sword_maiden_balance_final_judgment.name}",
		Description = "$bv{skill.sword_maiden_balance_final_judgment.description}",
		Icon = "sword_maiden_balance_final_judgment",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		SwordMaidenHuntPoints = 250,
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 6, FatigueCost = 30, MaxRange = 4, Radius = 2, HitChance = 30, WeaponDamageMult = 2.50, ArmorDamageMult = 1.60, DirectDamageAdd = 0.40, AreaHitpointDamage = 60, GoblinAreaHitpointDamage = 100 }
	},
	sword_maiden_light_in_darkness = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/sword_maiden_light_in_darkness_skill",
		Name = "$bv{skill.sword_maiden_light_in_darkness.name}",
		Description = "$bv{skill.sword_maiden_light_in_darkness.description}",
		Icon = "sword_maiden_light_in_darkness",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		SwordMaidenHuntPoints = 300,
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { FirstCondemnationDamageMult = 1.30, KillFollowupHitChance = 25, KillFollowupDamageMult = 1.25 }
	},
	the_herta_optimal_solution = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/the_herta_optimal_solution_skill",
		Name = "$bv{skill.the_herta_optimal_solution.name}", Description = "$bv{skill.the_herta_optimal_solution.description}", Icon = "the_herta_optimal_solution",
		Kind = "passive", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { MaxInspiration = 4, StartingInspiration = 2 }
	},
	the_herta_false_premise = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/the_herta_false_premise_skill",
		Name = "$bv{skill.the_herta_false_premise.name}", Description = "$bv{skill.the_herta_false_premise.description}", Icon = "the_herta_false_premise",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 20, MinRange = 1, MaxRange = 6, Radius = 1, InspirationGain = 2, InitiativePenalty = 30, ActionPointPenalty = 2 }
	},
	the_herta_answer_written = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/the_herta_answer_written_skill",
		Name = "$bv{skill.the_herta_answer_written.name}", Description = "$bv{skill.the_herta_answer_written.description}", Icon = "the_herta_answer_written",
		Kind = "active", Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 30, MinRange = 1, MaxRange = 7, Radius = 2, InspirationCost = 4, MainHitChance = 35, MainWeaponDamageMult = 1.80, MainArmorDamageMult = 2.0, MainDirectDamageAdd = 0.30, MainFixedHP = 40, AreaHitChance = 25, AreaWeaponDamageMult = 1.30, AreaArmorDamageMult = 1.50, AreaDirectDamageAdd = 0.15, AreaFixedHP = 15 }
	},
	texas_omertosa_tradition = {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/texas_omertosa_tradition_skill",
		Name = "$bv{skill.texas_omertosa_tradition.name}",
		Description = "$bv{skill.texas_omertosa_tradition.description}",
		Icon = "texas_omertosa_tradition",
		Kind = "passive",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { DamageReductionMult = 0.75, ModeDamageMult = 1.20, Duration = 2, CutInCooldownTurns = 2, FirstKillOnce = true }
	},
	texas_omertosa_unrelenting_downpour = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/texas_omertosa_unrelenting_downpour_skill",
		Name = "$bv{skill.texas_omertosa_unrelenting_downpour.name}",
		Description = "$bv{skill.texas_omertosa_unrelenting_downpour.description}",
		Icon = "texas_omertosa_unrelenting_downpour",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 4, FatigueCost = 20, MinRange = 1, MaxRange = 5, EntryWeaponDamageMult = 1.20, EntryArmorDamageMult = 1.50, EntryDirectDamageAdd = 0.30, EntryHitChance = 25, FollowupCount = 3, FollowupWeaponDamageMult = 0.60, FollowupHitChance = 20 }
	},
	texas_omertosa_torrential_sword_rain = {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/texas_omertosa_torrential_sword_rain_skill",
		Name = "$bv{skill.texas_omertosa_torrential_sword_rain.name}",
		Description = "$bv{skill.texas_omertosa_torrential_sword_rain.description}",
		Icon = "texas_omertosa_torrential_sword_rain",
		Kind = "active",
		Lifetime = "persistent",
		Learnable = false,
		Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
		Spec = { ActionPointCost = 5, FatigueCost = 25, MinRange = 1, MaxRange = 5, EntryStrikeCount = 2, WeaponDamageMult = 0.70, ArmorDamageMult = 1.0, DirectDamageAdd = 0.20, HitChance = 30, EndTurnTargets = 3, EndTurnRange = 4 }
	}
};
