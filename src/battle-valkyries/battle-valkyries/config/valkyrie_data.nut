::$bvvar{namespace}.ValkyrieIDFlag <- "$bvvar{modId}.valkyrie_id";
::$bvvar{namespace}.ValkyrieSkinIDFlag <- "$bvvar{modId}.valkyrie_skin_id";

::$bvvar{namespace}.getValkyrieActiveSkillOrder <- function()
{
	return ::Const.SkillOrder.Any - 1000;
};

::$bvvar{namespace}.ValkyrieAttributeNames <- [
	"Hitpoints",
	"Bravery",
	"Stamina",
	"MeleeSkill",
	"RangedSkill",
	"MeleeDefense",
	"RangedDefense",
	"Initiative"
];

::$bvvar{namespace}.ValkyrieAttributeConst <- {
	Hitpoints = ::Const.Attributes.Hitpoints,
	Bravery = ::Const.Attributes.Bravery,
	Stamina = ::Const.Attributes.Fatigue,
	MeleeSkill = ::Const.Attributes.MeleeSkill,
	RangedSkill = ::Const.Attributes.RangedSkill,
	MeleeDefense = ::Const.Attributes.MeleeDefense,
	RangedDefense = ::Const.Attributes.RangedDefense,
	Initiative = ::Const.Attributes.Initiative
};

::$bvvar{namespace}.ValkyrieOrder <- [
	"abigail_williams",
	"katsushika_hokusai",
	"c_c",
	"enterprise",
	"togawa_sakiko",
	"m4a1",
	"morgan",
	"meltryllis",
	"saber",
	"silver_wolf",
	"robin",
	"jeanne",
	"sword_maiden",
	"jeanne_alter",
	"jingliu",
	"skirk",
	"jinhsi",
	"nahida",
	"hakurei_reimu",
	"yae_miko",
	"chisaki",
	"kafka",
	"ye_shunguang",
	"himeko",
	"feixue",
	"feixiao",
	"changli",
	"raiden_shogun",
	"yixuan",
	"xilian",
	"liuying",
	"cartethyia",
	"castorice",
	"changyeyue",
	"hysilens",
	"tilixibiesi",
	"cipher",
	"cerydra",
	"fengjin",
	"yuno",
	"phoebe",
	"wisadel",
	"aglaea",
	"mai_shiranui",
	"scarlet_shadow",
	"texas_omertosa",
	"sparxie",
	"the_herta"
];

::$bvvar{namespace}.Valkyries <- {
	abigail_williams = {
		ID="abigail_williams",LegendsPerkProfile="ranged_damage",SkinID="abigail_williams_skin",
		Name="$bv{valkyrie.abigail_williams.name}",Portrait="ui/valkyries/abigail_williams_card.png",WorldLeaderBrush="world_bv_abigail_williams_leader",
		BackgroundScript="scripts/skills/backgrounds/battle_valkyries/abigail_williams_background",
		BackgroundID="$bvvar{modId}.background.abigail_williams",BackgroundName="$bv{valkyrie.abigail_williams.background.name}",BackgroundDescription="$bv{valkyrie.abigail_williams.background.description}",
		TraitScript="scripts/skills/traits/battle_valkyries/abigail_williams_trait",
		TraitID="$bvvar{modId}.trait.abigail_williams",TraitName="$bv{valkyrie.abigail_williams.trait.name}",TraitDescription="$bv{valkyrie.abigail_williams.trait.description}",TraitIcon="ui/traits/$bvvar{iconPrefix}/abigail_williams_trait_icon.png",
		Level=1,XP=0,DailyWage=1,
		BaseAttributes={Hitpoints=65,Bravery=75,Stamina=120,MeleeSkill=45,RangedSkill=70,MeleeDefense=5,RangedDefense=12,Initiative=100},
		AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
		Talents={Hitpoints=2,Bravery=3,Stamina=2,MeleeSkill=0,RangedSkill=3,MeleeDefense=0,RangedDefense=1,Initiative=1},
		SkillLoadout=["abigail_outer_realm","abigail_root_touch","abigail_faithful_prayer","abigail_mass_hysteria","abigail_witch_trial","abigail_qliphoth_rhizome"],
		HubDetails={
			Passive={Icon="abigail_outer_realm",Name="$bv{skill.abigail_outer_realm.name}",Description="$bv{skill.abigail_outer_realm.description}"},
			Active={Icon="abigail_qliphoth_rhizome",Name="$bv{abigail.hub.active}",Description="$bv{skill.abigail_root_touch.name}\n$bv{skill.abigail_root_touch.description}\n\n$bv{skill.abigail_faithful_prayer.name}\n$bv{skill.abigail_faithful_prayer.description}\n\n$bv{skill.abigail_mass_hysteria.name}\n$bv{skill.abigail_mass_hysteria.description}\n\n$bv{skill.abigail_witch_trial.name}\n$bv{skill.abigail_witch_trial.description}\n\n$bv{skill.abigail_qliphoth_rhizome.name}\n$bv{skill.abigail_qliphoth_rhizome.description}"}
		},Equipment={},Quests=[]
	},
	katsushika_hokusai = {
		ID="katsushika_hokusai", LegendsPerkProfile="ranged_damage", SkinID="katsushika_hokusai_skin",
		Name="$bv{valkyrie.katsushika_hokusai.name}", Portrait="ui/valkyries/katsushika_hokusai_card.png",
		WorldLeaderBrush="world_bv_katsushika_hokusai_leader",
		BackgroundScript="scripts/skills/backgrounds/battle_valkyries/katsushika_hokusai_background",
		BackgroundID="$bvvar{modId}.background.katsushika_hokusai", BackgroundName="$bv{valkyrie.katsushika_hokusai.background.name}", BackgroundDescription="$bv{valkyrie.katsushika_hokusai.background.description}",
		TraitScript="scripts/skills/traits/battle_valkyries/katsushika_hokusai_trait",
		TraitID="$bvvar{modId}.trait.katsushika_hokusai", TraitName="$bv{valkyrie.katsushika_hokusai.trait.name}", TraitDescription="$bv{valkyrie.katsushika_hokusai.trait.description}", TraitIcon="ui/traits/$bvvar{iconPrefix}/katsushika_hokusai_trait_icon.png",
		Level=1, XP=0, DailyWage=1,
		BaseAttributes={Hitpoints=75,Bravery=70,Stamina=120,MeleeSkill=50,RangedSkill=70,MeleeDefense=8,RangedDefense=12,Initiative=105},
		AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
		Talents={Hitpoints=1,Bravery=3,Stamina=2,MeleeSkill=0,RangedSkill=3,MeleeDefense=1,RangedDefense=1,Initiative=1},
		SkillLoadout=["hokusai_painting_mania","hokusai_brushstroke","hokusai_all_things_in_nature","hokusai_father_daughter_bond","hokusai_alien_octopus","hokusai_thirty_six_views"],
		HubDetails = {
			Passive = {Icon="hokusai_painting_mania",Name="$bv{skill.hokusai_painting_mania.name}",Description="$bv{skill.hokusai_painting_mania.description}"},
			Active = {Icon="hokusai_thirty_six_views",Name="$bv{hokusai.hub.active}",Description="$bv{skill.hokusai_brushstroke.description}\n\n$bv{skill.hokusai_all_things_in_nature.description}\n\n$bv{skill.hokusai_father_daughter_bond.description}\n\n$bv{skill.hokusai_alien_octopus.description}\n\n$bv{skill.hokusai_thirty_six_views.description}"}
		},
		Equipment={}, Quests=[]
	},
	c_c = {
		ID="c_c", LegendsPerkProfile="melee_support", SkinID="c_c_skin",
		Name="$bv{valkyrie.c_c.name}", Portrait="ui/valkyries/c_c_card.png",
		WorldLeaderBrush="world_bv_c_c_leader",
		BackgroundScript="scripts/skills/backgrounds/battle_valkyries/c_c_background",
		BackgroundID="$bvvar{modId}.background.c_c", BackgroundName="$bv{valkyrie.c_c.background.name}", BackgroundDescription="$bv{valkyrie.c_c.background.description}",
		TraitScript="scripts/skills/traits/battle_valkyries/c_c_trait",
		TraitID="$bvvar{modId}.trait.c_c", TraitName="$bv{valkyrie.c_c.trait.name}", TraitDescription="$bv{valkyrie.c_c.trait.description}", TraitIcon="ui/traits/$bvvar{iconPrefix}/c_c_trait_icon.png",
		Level=1, XP=0, DailyWage=1,
		BaseAttributes={Hitpoints=80,Bravery=65,Stamina=115,MeleeSkill=60,RangedSkill=45,MeleeDefense=10,RangedDefense=10,Initiative=100},
		AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
		Talents={Hitpoints=2,Bravery=3,Stamina=3,MeleeSkill=1,RangedSkill=0,MeleeDefense=1,RangedDefense=0,Initiative=0},
		SkillLoadout=["c_c_immortal_witch","c_c_accomplice","c_c_geass_contract","c_c_shock_image","c_c_unfinished_contract"],
		HubDetails={
			Passive={Icon="c_c_immortal_witch",Name="$bv{cc.hub.passive}",Description="$bv{skill.c_c_immortal_witch.description}\n\n$bv{skill.c_c_accomplice.description}"},
			Active={Icon="c_c_geass_contract",Name="$bv{cc.hub.active}",Description="$bv{skill.c_c_geass_contract.description}\n\n$bv{skill.c_c_shock_image.description}\n\n$bv{skill.c_c_unfinished_contract.description}"}
		},
		Equipment={}, Quests=[]
	},
	enterprise = {
		ID = "enterprise", LegendsPerkProfile = "ranged_damage", SkinID = "enterprise_skin",
		Name = "$bv{valkyrie.enterprise.name}", Portrait = "ui/valkyries/enterprise_card.png", WorldLeaderBrush = "world_bv_enterprise_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/enterprise_background",
		BackgroundID = "$bvvar{modId}.background.enterprise", BackgroundName = "$bv{valkyrie.enterprise.background.name}", BackgroundDescription = "$bv{valkyrie.enterprise.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/enterprise_trait",
		TraitID = "$bvvar{modId}.trait.enterprise", TraitName = "$bv{valkyrie.enterprise.trait.name}", TraitDescription = "$bv{valkyrie.enterprise.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/enterprise_trait_icon.png",
		Level = 1, XP = 0, DailyWage = 1,
		BaseAttributes = {Hitpoints = 85,Bravery = 70,Stamina = 125,MeleeSkill = 55,RangedSkill = 75,MeleeDefense = 10,RangedDefense = 20,Initiative = 115},
		AttributeAdjustments = {Hitpoints = [0,0],Bravery = [0,0],Stamina = [0,0],MeleeSkill = [0,0],RangedSkill = [0,0],MeleeDefense = [0,0],RangedDefense = [0,0],Initiative = [0,0]},
		Talents = {Hitpoints = 2,Bravery = 0,Stamina = 2,MeleeSkill = 0,RangedSkill = 3,MeleeDefense = 0,RangedDefense = 0,Initiative = 0},
		SkillLoadout = ["enterprise_white_eagle_airwing","enterprise_lucky_e","enterprise_eagle_guidance","enterprise_dauntless_dive","enterprise_carrier_strafe","enterprise_decisive_airwing"],
		HubDetails = {
			Passive = {Icon = "enterprise_lucky_e",Name = "$bv{enterprise.hub.passive}",Description = "$bv{skill.enterprise_white_eagle_airwing.description}\n\n$bv{skill.enterprise_lucky_e.description}"},
			Active = {Icon = "enterprise_decisive_airwing",Name = "$bv{enterprise.hub.active}",Description = "$bv{skill.enterprise_eagle_guidance.description}\n\n$bv{skill.enterprise_dauntless_dive.description}\n\n$bv{skill.enterprise_carrier_strafe.description}\n\n$bv{skill.enterprise_decisive_airwing.description}"}
		},
		Equipment = {}, Quests = []
	},
	togawa_sakiko = {
		ID = "togawa_sakiko", LegendsPerkProfile = "melee_support", SkinID = "togawa_sakiko_skin",
		Name = "$bv{valkyrie.togawa_sakiko.name}", Portrait = "ui/valkyries/togawa_sakiko_card.png",
		WorldLeaderBrush = "world_bv_togawa_sakiko_skin_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/togawa_sakiko_background",
		BackgroundID = "$bvvar{modId}.background.togawa_sakiko", BackgroundName = "$bv{valkyrie.togawa_sakiko.background.name}", BackgroundDescription = "$bv{valkyrie.togawa_sakiko.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/togawa_sakiko_trait",
		TraitID = "$bvvar{modId}.trait.togawa_sakiko", TraitName = "$bv{valkyrie.togawa_sakiko.trait.name}", TraitDescription = "$bv{valkyrie.togawa_sakiko.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/togawa_sakiko_trait_icon.png",
		Level = 1, XP = 0, DailyWage = 1,
		BaseAttributes = { Hitpoints=75, Bravery=65, Stamina=115, MeleeSkill=60, RangedSkill=50, MeleeDefense=10, RangedDefense=10, Initiative=110 },
		AttributeAdjustments = { Hitpoints=[0,0], Bravery=[0,0], Stamina=[0,0], MeleeSkill=[0,0], RangedSkill=[0,0], MeleeDefense=[0,0], RangedDefense=[0,0], Initiative=[0,0] },
		Talents = { Hitpoints=2, Bravery=3, Stamina=3, MeleeSkill=1, RangedSkill=0, MeleeDefense=1, RangedDefense=1, Initiative=2 },
		SkillLoadout = ["togawa_sakiko_ensemble_stage", "togawa_sakiko_full_moon_dance", "togawa_sakiko_crescent_echo"],
		HubDetails = {
			Passive = { Icon="togawa_sakiko_ensemble_stage", Name="$bv{skill.togawa_sakiko_ensemble_stage.name}", Description="$bv{skill.togawa_sakiko_ensemble_stage.description}" },
			Active = { Icon="togawa_sakiko_crescent_echo", Name="$bv{sakiko.hub.active}", Description="$bv{skill.togawa_sakiko_full_moon_dance.description}\n\n$bv{skill.togawa_sakiko_crescent_echo.description}" }
		},
		Equipment = {}, Quests = []
	},
	m4a1 = {
		ID = "m4a1", LegendsPerkProfile = "ranged_damage", SkinID = "m4a1_skin",
		Name = "$bv{valkyrie.m4a1.name}", Portrait = "ui/valkyries/m4a1_card.png",
		WorldLeaderBrush = "world_bv_m4a1_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/m4a1_background",
		BackgroundID = "$bvvar{modId}.background.m4a1", BackgroundName = "$bv{valkyrie.m4a1.background.name}", BackgroundDescription = "$bv{valkyrie.m4a1.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/m4a1_trait",
		TraitID = "$bvvar{modId}.trait.m4a1", TraitName = "$bv{valkyrie.m4a1.trait.name}", TraitDescription = "$bv{valkyrie.m4a1.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/m4a1_trait_icon.png",
		Level = 1, XP = 0, DailyWage = 1,
		BaseAttributes = { Hitpoints = 75, Bravery = 55, Stamina = 120, MeleeSkill = 45, RangedSkill = 70, MeleeDefense = 8, RangedDefense = 12, Initiative = 110 },
		AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
		Talents = { Hitpoints = 1, Bravery = 2, Stamina = 3, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = ["m4a1_ar_commander", "m4a1_inheritor", "m4a1_tactical_shot", "m4a1_three_round_burst", "m4a1_tactical_reload", "m4a1_reload_ap", "m4a1_firepower_focus", "m4a1_mark_of_vengeance"],
		HubDetails = {
			Passive = { Icon = "m4a1_ar_commander", Name = "$bv{m4a1.hub.passive}", Description = "$bv{skill.m4a1_ar_commander.description}\n\n$bv{skill.m4a1_inheritor.description}" },
			Active = { Icon = "m4a1_mark_of_vengeance", Name = "$bv{m4a1.hub.active}", Description = "$bv{skill.m4a1_tactical_shot.description}\n\n$bv{skill.m4a1_three_round_burst.description}\n\n$bv{skill.m4a1_tactical_reload.description}\n\n$bv{skill.m4a1_reload_ap.description}\n\n$bv{skill.m4a1_firepower_focus.description}\n\n$bv{skill.m4a1_mark_of_vengeance.description}" }
		},
		Equipment = {}, Quests = []
	},
	morgan = {
		ID = "morgan", LegendsPerkProfile = "ranged_damage", SkinID = "morgan_skin",
		Name = "$bv{valkyrie.morgan.name}", Portrait = "ui/valkyries/morgan_card.png",
		WorldLeaderBrush = "world_bv_morgan_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/morgan_background",
		BackgroundID = "$bvvar{modId}.background.morgan", BackgroundName = "$bv{valkyrie.morgan.background.name}", BackgroundDescription = "$bv{valkyrie.morgan.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/morgan_trait",
		TraitID = "$bvvar{modId}.trait.morgan", TraitName = "$bv{valkyrie.morgan.trait.name}", TraitDescription = "$bv{valkyrie.morgan.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/morgan_trait_icon.png",
		Level = 1, XP = 0, DailyWage = 1,
		BaseAttributes = { Hitpoints = 80, Bravery = 65, Stamina = 115, MeleeSkill = 45, RangedSkill = 70, MeleeDefense = 8, RangedDefense = 15, Initiative = 105 },
		AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
		Talents = { Hitpoints = 1, Bravery = 3, Stamina = 2, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 1 },
		SkillLoadout = ["morgan_from_worlds_end", "morgan_holy_lance", "morgan_lake_grace", "morgan_roadless_camelot"],
		HubDetails = {
			Passive = { Icon = "morgan_from_worlds_end", Name = "$bv{skill.morgan_from_worlds_end.name}", Description = "$bv{skill.morgan_from_worlds_end.description}", Tooltip = [{ SkillKey = "morgan_from_worlds_end", Text = "$bv{skill.morgan_from_worlds_end.tooltip.mana}" },{ SkillKey = "morgan_from_worlds_end", Text = "$bv{skill.morgan_from_worlds_end.tooltip.guts}" }] },
			Active = { Icon = "morgan_roadless_camelot", Name = "$bv{morgan.hub.active.name}", Description = "$bv{skill.morgan_holy_lance.name}" + " / " + "$bv{skill.morgan_lake_grace.name}" + " / " + "$bv{skill.morgan_roadless_camelot.name}" + "\n" + "$bv{morgan.hub.active.description}", Tooltip = [{ SkillKey = "morgan_holy_lance", Text = "$bv{morgan.hub.lance}" },{ SkillKey = "morgan_lake_grace", Text = "$bv{morgan.hub.grace}" },{ SkillKey = "morgan_roadless_camelot", Text = "$bv{morgan.hub.camelot}" }] }
		},
		Equipment = {}, Quests = []
	},
	meltryllis = {
		ID = "meltryllis", LegendsPerkProfile = "melee_frontline", SkinID = "meltryllis_skin",
		Name = "$bv{valkyrie.meltryllis.name}", Portrait = "ui/valkyries/meltryllis_card.png",
		WorldLeaderBrush = "world_bv_meltryllis_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/meltryllis_background",
		BackgroundID = "$bvvar{modId}.background.meltryllis", BackgroundName = "$bv{valkyrie.meltryllis.background.name}", BackgroundDescription = "$bv{valkyrie.meltryllis.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/meltryllis_trait",
		TraitID = "$bvvar{modId}.trait.meltryllis", TraitName = "$bv{valkyrie.meltryllis.trait.name}", TraitDescription = "$bv{valkyrie.meltryllis.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/meltryllis_trait_icon.png",
		Level = 1, XP = 0, DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = ["meltryllis_sadistic_constitution", "meltryllis_blade_dance", "meltryllis_crime_ballet", "meltryllis_melt_virus", "meltryllis_sarasvati_meltout"],
		HubDetails = {
			Passive = { Icon = "meltryllis_sadistic_constitution", Name = "$bv{skill.meltryllis_sadistic_constitution.name}", Description = "$bv{skill.meltryllis_sadistic_constitution.description}" },
			Active = { Icon = "meltryllis_sarasvati_meltout", Name = "$bv{meltryllis.hub.active.name}", Description = "$bv{skill.meltryllis_blade_dance.description}" + "\n\n" + "$bv{skill.meltryllis_crime_ballet.description}" + "\n\n" + "$bv{skill.meltryllis_melt_virus.description}" + "\n\n" + "$bv{skill.meltryllis_sarasvati_meltout.description}" }
		},
		Equipment = {}, Quests = []
	},
	saber = {
		ID = "saber",
		LegendsPerkProfile = "melee_frontline",
		SkinID = "saber_skin",
		Name = "$bv{valkyrie.saber.name}",
		Portrait = "ui/valkyries/saber_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/saber_background",
		BackgroundID = "$bvvar{modId}.background.saber",
		BackgroundName = "$bv{valkyrie.saber.background.name}",
		BackgroundDescription = "$bv{valkyrie.saber.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/saber_trait",
		TraitID = "$bvvar{modId}.trait.saber",
		TraitName = "$bv{valkyrie.saber.trait.name}",
		TraitDescription = "$bv{valkyrie.saber.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/saber_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"saber_invisible_air",
			"saber_strike_air",
			"saber_excalibur"
		],
		HubDetails = {
			Passive = { Icon = "saber_invisible_air", Name = "$bv{skill.saber_invisible_air.name}", Description = "$bv{skill.saber_invisible_air.description}", Tooltip = [ { SkillKey = "saber_invisible_air", Text = "$bv{skill.saber_invisible_air.tooltip.attack}" }, { SkillKey = "saber_invisible_air", Text = "$bv{skill.saber_invisible_air.tooltip.mana}" } ] },
			Active = { Icon = "saber_excalibur", Name = "$bv{skill.saber_strike_air.name}" + " / " + "$bv{skill.saber_excalibur.name}", Description = "$bv{skill.saber_strike_air.description}" + "\n" + "$bv{skill.saber_excalibur.description}", Tooltip = [ { SkillKey = "saber_strike_air", Text = "$bv{skill.saber_strike_air.tooltip.damage}" }, { SkillKey = "saber_strike_air", Text = "$bv{skill.saber_strike_air.tooltip.control}" }, { SkillKey = "saber_excalibur", Text = "$bv{skill.saber_excalibur.tooltip.damage}" }, { SkillKey = "saber_excalibur", Text = "$bv{skill.saber_excalibur.tooltip.fixed}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	silver_wolf = {
		ID = "silver_wolf",
		LegendsPerkProfile = "hybrid_skirmisher",
		SkinID = "silver_wolf_skin",
		Name = "$bv{valkyrie.silver_wolf.name}",
		Portrait = "ui/valkyries/silver_wolf_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/silver_wolf_background",
		BackgroundID = "$bvvar{modId}.background.silver_wolf",
		BackgroundName = "$bv{valkyrie.silver_wolf.background.name}",
		BackgroundDescription = "$bv{valkyrie.silver_wolf.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/silver_wolf_trait",
		TraitID = "$bvvar{modId}.trait.silver_wolf",
		TraitName = "$bv{valkyrie.silver_wolf.trait.name}",
		TraitDescription = "$bv{valkyrie.silver_wolf.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/silver_wolf_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"silver_wolf_aether_editing",
			"silver_wolf_attack_vulnerability",
			"silver_wolf_defense_vulnerability",
			"silver_wolf_speed_vulnerability"
		],
		Equipment = {},
		Quests = []
	},
	robin = {
		ID = "robin",
		LegendsPerkProfile = "ranged_support",
		SkinID = "robin_skin",
		Name = "$bv{valkyrie.robin.name}",
		Portrait = "ui/valkyries/robin_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/robin_background",
		BackgroundID = "$bvvar{modId}.background.robin",
		BackgroundName = "$bv{valkyrie.robin.background.name}",
		BackgroundDescription = "$bv{valkyrie.robin.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/robin_trait",
		TraitID = "$bvvar{modId}.trait.robin",
		TraitName = "$bv{valkyrie.robin.trait.name}",
		TraitDescription = "$bv{valkyrie.robin.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/robin_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 82, Bravery = 70, Stamina = 140, MeleeSkill = 45, RangedSkill = 65, MeleeDefense = 10, RangedDefense = 25, Initiative = 120 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 1, Bravery = 3, Stamina = 2, MeleeSkill = 0, RangedSkill = 2, MeleeDefense = 1, RangedDefense = 3, Initiative = 2 },
		SkillLoadout = [
			"robin_harmonic_resonance",
			"robin_winged_sunny_song",
			"robin_encore_for_you",
			"robin_myriad_tones_starry_fugue"
		],
		HubDetails = {
			Passive = { Icon = "robin_harmonic_resonance", Name = "$bv{skill.robin_harmonic_resonance.name}", Description = "$bv{skill.robin_harmonic_resonance.description}", Tooltip = [ { SkillKey = "robin_harmonic_resonance", Text = "$bv{skill.robin_harmonic_resonance.tooltip.harmony}" }, { SkillKey = "robin_harmonic_resonance", Text = "$bv{skill.robin_harmonic_resonance.tooltip.aura}" } ] },
			Active = { Icon = "robin_myriad_tones_starry_fugue", Name = "$bv{skill.robin_winged_sunny_song.name}" + " / " + "$bv{skill.robin_encore_for_you.name}" + " / " + "$bv{skill.robin_myriad_tones_starry_fugue.name}", Description = "$bv{skill.robin_winged_sunny_song.description}" + "\n" + "$bv{skill.robin_encore_for_you.description}" + "\n" + "$bv{skill.robin_myriad_tones_starry_fugue.description}", Tooltip = [ { SkillKey = "robin_winged_sunny_song", Text = "$bv{skill.robin_winged_sunny_song.tooltip.buff}" }, { SkillKey = "robin_encore_for_you", Text = "$bv{skill.robin_encore_for_you.tooltip.restore}" }, { SkillKey = "robin_myriad_tones_starry_fugue", Text = "$bv{skill.robin_myriad_tones_starry_fugue.tooltip.ap}" }, { SkillKey = "robin_myriad_tones_starry_fugue", Text = "$bv{skill.robin_myriad_tones_starry_fugue.tooltip.concerto}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	jeanne = {
		ID = "jeanne",
		LegendsPerkProfile = "melee_support",
		SkinID = "jeanne_skin",
		SkinIDs = ["jeanne_skin", "jeanne_summer_skin", "jeanne_beach_skin"],
		Name = "$bv{valkyrie.jeanne.name}",
		Portrait = "ui/valkyries/jeanne_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/jeanne_background",
		BackgroundID = "$bvvar{modId}.background.jeanne",
		BackgroundName = "$bv{valkyrie.jeanne.background.name}",
		BackgroundDescription = "$bv{valkyrie.jeanne.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/jeanne_trait",
		TraitID = "$bvvar{modId}.trait.jeanne",
		TraitName = "$bv{valkyrie.jeanne.trait.name}",
		TraitDescription = "$bv{valkyrie.jeanne.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jeanne_trait_icon.png",
		AdditionalTraitScripts = [
			"scripts/skills/traits/battle_valkyries/jeanne_bond_trait"
		],
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 95, Bravery = 70, Stamina = 135, MeleeSkill = 70, RangedSkill = 45, MeleeDefense = 20, RangedDefense = 18, Initiative = 110 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 2, RangedDefense = 2, Initiative = 1 },
		SkillLoadout = [
			"jeanne_revelation_holy_banner",
			"jeanne_true_name_divine_judgement",
			"jeanne_luminosite_eternelle"
		],
		HubDetails = {
			Passive = { Icon = "jeanne_revelation_holy_banner", Name = "$bv{skill.jeanne_revelation_holy_banner.name}", Description = "$bv{skill.jeanne_revelation_holy_banner.description}", Tooltip = [ { SkillKey = "jeanne_revelation_holy_banner", Text = "$bv{skill.jeanne_revelation_holy_banner.tooltip.hub_aura}" }, { SkillKey = "jeanne_revelation_holy_banner", Text = "$bv{skill.jeanne_revelation_holy_banner.tooltip.hub_revelation}" } ] },
			Active = { Icon = "jeanne_luminosite_eternelle", Name = "$bv{skill.jeanne_true_name_divine_judgement.name}" + " / " + "$bv{skill.jeanne_luminosite_eternelle.name}", Description = "$bv{skill.jeanne_true_name_divine_judgement.description}" + "\n" + "$bv{skill.jeanne_luminosite_eternelle.description}", Tooltip = [ { SkillKey = "jeanne_true_name_divine_judgement", Text = "$bv{skill.jeanne_true_name_divine_judgement.tooltip.damage}" }, { SkillKey = "jeanne_true_name_divine_judgement", Text = "$bv{skill.jeanne_true_name_divine_judgement.tooltip.discernment}" }, { SkillKey = "jeanne_luminosite_eternelle", Text = "$bv{skill.jeanne_luminosite_eternelle.tooltip.protection}" }, { SkillKey = "jeanne_luminosite_eternelle", Text = "$bv{skill.jeanne_luminosite_eternelle.tooltip.blessing}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	sword_maiden = {
		ID = "sword_maiden",
		LegendsPerkProfile = "melee_frontline",
		SkinID = "sword_maiden_skin",
		Name = "$bv{valkyrie.sword_maiden.name}",
		Portrait = "ui/valkyries/sword_maiden_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/sword_maiden_background",
		BackgroundID = "$bvvar{modId}.background.sword_maiden",
		BackgroundName = "$bv{valkyrie.sword_maiden.background.name}",
		BackgroundDescription = "$bv{valkyrie.sword_maiden.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/sword_maiden_trait",
		TraitID = "$bvvar{modId}.trait.sword_maiden",
		TraitName = "$bv{valkyrie.sword_maiden.trait.name}",
		TraitDescription = "$bv{valkyrie.sword_maiden.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/sword_maiden_trait_icon.png",
		AdditionalTraitScripts = ["scripts/skills/traits/battle_valkyries/sword_maiden_hunt_record_trait"],
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 105, Bravery = 80, Stamina = 145, MeleeSkill = 78, RangedSkill = 45, MeleeDefense = 22, RangedDefense = 20, Initiative = 120 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"sword_maiden_unseeing_mind",
			"sword_maiden_balance_condemnation",
			"sword_maiden_goblin_codex",
			"sword_maiden_cave_survivor",
			"sword_maiden_holy_binding_judgment",
			"sword_maiden_root_extermination",
			"sword_maiden_balance_final_judgment",
			"sword_maiden_light_in_darkness"
		],
		HubDetails = {
			Passive = { Icon = "sword_maiden_unseeing_mind", Name = "$bv{skill.sword_maiden_unseeing_mind.name}", Description = "$bv{skill.sword_maiden_unseeing_mind.description}", Tooltip = [ { SkillKey = "sword_maiden_unseeing_mind", Text = "$bv{skill.sword_maiden_unseeing_mind.tooltip.first_strike}" }, { SkillKey = "sword_maiden_unseeing_mind", Text = "$bv{skill.sword_maiden_unseeing_mind.tooltip.miss}" } ] },
			Active = { Icon = "sword_maiden_balance_condemnation", Name = "$bv{skill.sword_maiden_balance_condemnation.name}", Description = "$bv{skill.sword_maiden_balance_condemnation.description}", Tooltip = [ { SkillKey = "sword_maiden_balance_condemnation", Text = "$bv{skill.sword_maiden_balance_condemnation.tooltip.damage}" }, { SkillKey = "sword_maiden_balance_condemnation", Text = "$bv{skill.sword_maiden_balance_condemnation.tooltip.goblin}" }, { SkillKey = "sword_maiden_balance_condemnation", Text = "$bv{skill.sword_maiden_balance_condemnation.tooltip.kill}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	jeanne_alter = {
		ID = "jeanne_alter",
		LegendsPerkProfile = "melee_frontline",
		SkinID = "jeanne_alter_skin",
		Name = "$bv{valkyrie.jeanne_alter.name}",
		Portrait = "ui/valkyries/jeanne_alter_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/jeanne_alter_background",
		BackgroundID = "$bvvar{modId}.background.jeanne_alter",
		BackgroundName = "$bv{valkyrie.jeanne_alter.background.name}",
		BackgroundDescription = "$bv{valkyrie.jeanne_alter.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/jeanne_alter_trait",
		TraitID = "$bvvar{modId}.trait.jeanne_alter",
		TraitName = "$bv{valkyrie.jeanne_alter.trait.name}",
		TraitDescription = "$bv{valkyrie.jeanne_alter.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jeanne_alter_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"jeanne_alter_dragon_witch",
			"jeanne_alter_la_grondement_du_haine"
		],
		Equipment = {},
		Quests = []
	},
	jingliu = {
		ID = "jingliu",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "jingliu_skin",
		SkinIDs = ["jingliu_skin", "jingliu_frostmoon_tide_skin", "jingliu_bride_skin"],
		Name = "$bv{valkyrie.jingliu.name}",
		Portrait = "ui/valkyries/jingliu_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/jingliu_background",
		BackgroundID = "$bvvar{modId}.background.jingliu",
		BackgroundName = "$bv{valkyrie.jingliu.background.name}",
		BackgroundDescription = "$bv{valkyrie.jingliu.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/jingliu_trait",
		TraitID = "$bvvar{modId}.trait.jingliu",
		TraitName = "$bv{valkyrie.jingliu.trait.name}",
		TraitDescription = "$bv{valkyrie.jingliu.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jingliu_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"jingliu_cold_moon_sword_heart",
			"jingliu_moonflower_birth_and_death"
		],
		Equipment = {},
		Quests = []
	},
	skirk = {
		ID = "skirk",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "skirk_skin",
		Name = "$bv{valkyrie.skirk.name}",
		Portrait = "ui/valkyries/skirk_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/skirk_background",
		BackgroundID = "$bvvar{modId}.background.skirk",
		BackgroundName = "$bv{valkyrie.skirk.background.name}",
		BackgroundDescription = "$bv{valkyrie.skirk.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/skirk_trait",
		TraitID = "$bvvar{modId}.trait.skirk",
		TraitName = "$bv{valkyrie.skirk.trait.name}",
		TraitDescription = "$bv{valkyrie.skirk.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/skirk_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"skirk_serpents_subtlety",
			"skirk_havoc_warp",
			"skirk_havoc_ruin"
		],
		Equipment = {},
		Quests = []
	},
	jinhsi = {
		ID = "jinhsi",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "jinhsi_skin",
		Name = "$bv{valkyrie.jinhsi.name}",
		Portrait = "ui/valkyries/jinhsi_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/jinhsi_background",
		BackgroundID = "$bvvar{modId}.background.jinhsi",
		BackgroundName = "$bv{valkyrie.jinhsi.background.name}",
		BackgroundDescription = "$bv{valkyrie.jinhsi.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/jinhsi_trait",
		TraitID = "$bvvar{modId}.trait.jinhsi",
		TraitName = "$bv{valkyrie.jinhsi.trait.name}",
		TraitDescription = "$bv{valkyrie.jinhsi.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jinhsi_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"jinhsi_era_of_unity",
			"jinhsi_incarnation",
			"jinhsi_illuminous_epiphany"
		],
		HubDetails = {
			Passive = { Icon = "jinhsi_edict_guard", Name = "$bv{skill.jinhsi_era_of_unity.name}", Description = "$bv{skill.jinhsi_era_of_unity.description}", Tooltip = [ { SkillKey = "jinhsi_era_of_unity", Text = "$bv{skill.jinhsi_era_of_unity.tooltip.ally}" }, { SkillKey = "jinhsi_era_of_unity", Text = "$bv{skill.jinhsi_era_of_unity.tooltip.cap}" }, { SkillKey = "jinhsi_era_of_unity", Text = "$bv{skill.jinhsi_era_of_unity.tooltip.ready}" } ] },
			Active = { Icon = "jinhsi_edict_guard", Name = "$bv{skill.jinhsi_incarnation.name}" + " / " + "$bv{skill.jinhsi_illuminous_epiphany.name}", Description = "$bv{skill.jinhsi_incarnation.description}" + "\n" + "$bv{skill.jinhsi_illuminous_epiphany.description}", Tooltip = [ { SkillKey = "jinhsi_incarnation", Text = "$bv{skill.jinhsi_incarnation.tooltip.light}" }, { SkillKey = "jinhsi_illuminous_epiphany", Text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.primary}" }, { SkillKey = "jinhsi_illuminous_epiphany", Text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.area}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	nahida = {
		ID = "nahida",
		LegendsPerkProfile = "ranged_support",
		SkinID = "nahida_skin",
		Name = "$bv{valkyrie.nahida.name}",
		Portrait = "ui/valkyries/nahida_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/nahida_background",
		BackgroundID = "$bvvar{modId}.background.nahida",
		BackgroundName = "$bv{valkyrie.nahida.background.name}",
		BackgroundDescription = "$bv{valkyrie.nahida.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/nahida_trait",
		TraitID = "$bvvar{modId}.trait.nahida",
		TraitName = "$bv{valkyrie.nahida.trait.name}",
		TraitDescription = "$bv{valkyrie.nahida.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/nahida_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 75, Bravery = 75, Stamina = 120, MeleeSkill = 45, RangedSkill = 75, MeleeDefense = 5, RangedDefense = 20, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 1, Bravery = 3, Stamina = 2, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 0, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"nahida_tri_karma_purification",
			"nahida_akara",
			"nahida_all_schemes_to_know",
			"nahida_illusory_heart"
		],
		HubDetails = {
			Passive = { Icon = "nahida_tri_karma_purification", Name = "$bv{skill.nahida_tri_karma_purification.name}", Description = "$bv{skill.nahida_tri_karma_purification.description}", Tooltip = [ { SkillKey = "nahida_tri_karma_purification", Text = "$bv{skill.nahida_tri_karma_purification.tooltip.trigger}" }, { SkillKey = "nahida_tri_karma_purification", Text = "$bv{skill.nahida_tri_karma_purification.tooltip.resolve}" } ] },
			Active = { Icon = "nahida_shrine_of_maya", Name = "$bv{skill.nahida_akara.name}" + " / " + "$bv{skill.nahida_all_schemes_to_know.name}" + " / " + "$bv{skill.nahida_illusory_heart.name}", Description = "$bv{skill.nahida_akara.description}" + "\n" + "$bv{skill.nahida_all_schemes_to_know.description}" + "\n" + "$bv{skill.nahida_illusory_heart.description}", Tooltip = [ { SkillKey = "nahida_akara", Text = "$bv{skill.nahida_akara.tooltip.damage}" }, { SkillKey = "nahida_all_schemes_to_know", Text = "$bv{skill.nahida_all_schemes_to_know.tooltip.mark}" }, { SkillKey = "nahida_illusory_heart", Text = "$bv{skill.nahida_illusory_heart.tooltip.domain}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	hakurei_reimu = {
		ID = "hakurei_reimu",
		LegendsPerkProfile = "ranged_support",
		SkinID = "hakurei_reimu_skin",
		Name = "$bv{valkyrie.hakurei_reimu.name}",
		Portrait = "ui/valkyries/hakurei_reimu_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/hakurei_reimu_background",
		BackgroundID = "$bvvar{modId}.background.hakurei_reimu",
		BackgroundName = "$bv{valkyrie.hakurei_reimu.background.name}",
		BackgroundDescription = "$bv{valkyrie.hakurei_reimu.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/hakurei_reimu_trait",
		TraitID = "$bvvar{modId}.trait.hakurei_reimu",
		TraitName = "$bv{valkyrie.hakurei_reimu.trait.name}",
		TraitDescription = "$bv{valkyrie.hakurei_reimu.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/hakurei_reimu_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 82, Bravery = 65, Stamina = 125, MeleeSkill = 45, RangedSkill = 70, MeleeDefense = 10, RangedDefense = 20, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 1, Bravery = 3, Stamina = 2, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"hakurei_reimu_inborn_intuition",
			"hakurei_reimu_hakurei_amulet",
			"hakurei_reimu_duplex_barrier",
			"hakurei_reimu_fantasy_seal"
		],
		HubDetails = {
			Passive = { Icon = "hakurei_reimu_inborn_intuition", Name = "$bv{skill.hakurei_reimu_inborn_intuition.name}", Description = "$bv{skill.hakurei_reimu_inborn_intuition.description}", Tooltip = [ { SkillKey = "hakurei_reimu_inborn_intuition", Text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.offense}" }, { SkillKey = "hakurei_reimu_inborn_intuition", Text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.defense}" }, { SkillKey = "hakurei_reimu_inborn_intuition", Text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.resource}" } ] },
			Active = { Icon = "hakurei_reimu_fantasy_seal", Name = "$bv{skill.hakurei_reimu_hakurei_amulet.name}" + " / " + "$bv{skill.hakurei_reimu_duplex_barrier.name}" + " / " + "$bv{skill.hakurei_reimu_fantasy_seal.name}", Description = "$bv{skill.hakurei_reimu_hakurei_amulet.description}" + "\n" + "$bv{skill.hakurei_reimu_duplex_barrier.description}" + "\n" + "$bv{skill.hakurei_reimu_fantasy_seal.description}", Tooltip = [ { SkillKey = "hakurei_reimu_hakurei_amulet", Text = "$bv{skill.hakurei_reimu_hakurei_amulet.tooltip.damage}" }, { SkillKey = "hakurei_reimu_duplex_barrier", Text = "$bv{skill.hakurei_reimu_duplex_barrier.tooltip.layers}" }, { SkillKey = "hakurei_reimu_fantasy_seal", Text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.primary}" }, { SkillKey = "hakurei_reimu_fantasy_seal", Text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.area}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	yae_miko = {
		ID = "yae_miko",
		LegendsPerkProfile = "ranged_damage",
		SkinID = "yae_miko_skin",
		Name = "$bv{valkyrie.yae_miko.name}",
		Portrait = "ui/valkyries/yae_miko_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/yae_miko_background",
		BackgroundID = "$bvvar{modId}.background.yae_miko",
		BackgroundName = "$bv{valkyrie.yae_miko.background.name}",
		BackgroundDescription = "$bv{valkyrie.yae_miko.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/yae_miko_trait",
		TraitID = "$bvvar{modId}.trait.yae_miko",
		TraitName = "$bv{valkyrie.yae_miko.trait.name}",
		TraitDescription = "$bv{valkyrie.yae_miko.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/yae_miko_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"yae_miko_kitsune_thunder",
			"yae_miko_tenko_thunder_domain"
		],
		Equipment = {},
		Quests = []
	},
	chisaki = {
		ID = "chisaki",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "chisaki_skin",
		Name = "$bv{valkyrie.chisaki.name}",
		Portrait = "ui/valkyries/chisaki_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/chisaki_background",
		BackgroundID = "$bvvar{modId}.background.chisaki",
		BackgroundName = "$bv{valkyrie.chisaki.background.name}",
		BackgroundDescription = "$bv{valkyrie.chisaki.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/chisaki_trait",
		TraitID = "$bvvar{modId}.trait.chisaki",
		TraitName = "$bv{valkyrie.chisaki.trait.name}",
		TraitDescription = "$bv{valkyrie.chisaki.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/chisaki_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"chisaki_edge_followup",
			"chisaki_blood_slash"
		],
		Equipment = {},
		Quests = []
	},
	kafka = {
		ID = "kafka",
		LegendsPerkProfile = "ranged_support",
		SkinID = "kafka_skin",
		Name = "$bv{valkyrie.kafka.name}",
		Portrait = "ui/valkyries/kafka_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/kafka_background",
		BackgroundID = "$bvvar{modId}.background.kafka",
		BackgroundName = "$bv{valkyrie.kafka.background.name}",
		BackgroundDescription = "$bv{valkyrie.kafka.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/kafka_trait",
		TraitID = "$bvvar{modId}.trait.kafka",
		TraitName = "$bv{valkyrie.kafka.trait.name}",
		TraitDescription = "$bv{valkyrie.kafka.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/kafka_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"kafka_script_direction",
			"kafka_your_turn",
			"kafka_listen_to_me"
		],
		HubDetails = {
			Passive = { Icon = "kafka_spirit_whisper", Name = "$bv{skill.kafka_script_direction.name}", Description = "$bv{skill.kafka_script_direction.description}", Tooltip = [ { SkillKey = "kafka_script_direction", Text = "$bv{skill.kafka_script_direction.tooltip.slot}" }, { SkillKey = "kafka_script_direction", Text = "$bv{skill.kafka_script_direction.tooltip.echo}" }, { SkillKey = "kafka_script_direction", Text = "$bv{skill.kafka_script_direction.tooltip.round}" } ] },
			Active = { Icon = "kafka_listen_to_me", Name = "$bv{skill.kafka_your_turn.name}" + " / " + "$bv{skill.kafka_listen_to_me.name}", Description = "$bv{skill.kafka_your_turn.description}" + "\n" + "$bv{skill.kafka_listen_to_me.description}", Tooltip = [ { SkillKey = "kafka_your_turn", Text = "$bv{skill.kafka_your_turn.name}" + ": " + "$bv{skill.kafka_your_turn.tooltip.attributes}" }, { SkillKey = "kafka_listen_to_me", Text = "$bv{skill.kafka_listen_to_me.name}" + ": " + "$bv{skill.kafka_listen_to_me.tooltip.control}" }, { SkillKey = "kafka_your_turn", Text = "$bv{skill.kafka_your_turn.tooltip.spent}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	ye_shunguang = {
		ID = "ye_shunguang",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "ye_shunguang_skin",
		Name = "$bv{valkyrie.ye_shunguang.name}",
		Portrait = "ui/valkyries/ye_shunguang_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/ye_shunguang_background",
		BackgroundID = "$bvvar{modId}.background.ye_shunguang",
		BackgroundName = "$bv{valkyrie.ye_shunguang.background.name}",
		BackgroundDescription = "$bv{valkyrie.ye_shunguang.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/ye_shunguang_trait",
		AdditionalTraitScripts = ["scripts/skills/traits/battle_valkyries/ye_shunguang_bond_trait"],
		TraitID = "$bvvar{modId}.trait.ye_shunguang",
		TraitName = "$bv{valkyrie.ye_shunguang.trait.name}",
		TraitDescription = "$bv{valkyrie.ye_shunguang.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/ye_shunguang_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"ye_shunguang_enlightened_clarity",
			"ye_shunguang_reflection",
			"ye_shunguang_return_to_dust",
			"ye_shunguang_heart_recalled"
		],
		HubDetails = {
			Passive = { Icon = "ye_shunguang_qingming_guard", Name = "$bv{skill.ye_shunguang_enlightened_clarity.name}", Description = "$bv{skill.ye_shunguang_enlightened_clarity.description}", Tooltip = [ { SkillKey = "ye_shunguang_enlightened_clarity", Text = "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.attack}" }, { SkillKey = "ye_shunguang_enlightened_clarity", Text = "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.evade}" }, { SkillKey = "ye_shunguang_enlightened_clarity", Text = "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.ready}" } ] },
			Active = { Icon = "ye_shunguang_cut_filth", Name = "$bv{skill.ye_shunguang_reflection.name}" + " / " + "$bv{skill.ye_shunguang_return_to_dust.name}", Description = "$bv{skill.ye_shunguang_reflection.description}" + "\n" + "$bv{skill.ye_shunguang_return_to_dust.description}", Tooltip = [ { SkillKey = "ye_shunguang_reflection", Text = "$bv{skill.ye_shunguang_reflection.tooltip.state}" }, { SkillKey = "ye_shunguang_return_to_dust", Text = "$bv{skill.ye_shunguang_return_to_dust.tooltip.hit}" }, { SkillKey = "ye_shunguang_return_to_dust", Text = "$bv{skill.ye_shunguang_return_to_dust.tooltip.fixed_prefix}" + "6" + "$bv{skill.ye_shunguang_return_to_dust.tooltip.fixed_suffix}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	himeko = {
		ID = "himeko",
		LegendsPerkProfile = "hybrid_skirmisher",
		SkinID = "himeko_skin",
		SkinIDs = ["himeko_skin", "himeko_departure_skin"],
		Name = "$bv{valkyrie.himeko.name}",
		Portrait = "ui/valkyries/himeko_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/himeko_background",
		BackgroundID = "$bvvar{modId}.background.himeko",
		BackgroundName = "$bv{valkyrie.himeko.background.name}",
		BackgroundDescription = "$bv{valkyrie.himeko.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/himeko_trait",
		TraitID = "$bvvar{modId}.trait.himeko",
		TraitName = "$bv{valkyrie.himeko.trait.name}",
		TraitDescription = "$bv{valkyrie.himeko.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/himeko_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"himeko_victory_rush",
			"himeko_heavenly_flare",
			"himeko_we_are_trailblaze"
		],
		AdditionalTraitScripts = [
			"scripts/skills/traits/battle_valkyries/himeko_bond_trait"
		],
		Equipment = {},
		Quests = []
	},
	feixue = {
		ID = "feixue",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "feixue_skin",
		Name = "$bv{valkyrie.feixue.name}",
		Portrait = "ui/valkyries/feixue_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/feixue_background",
		BackgroundID = "$bvvar{modId}.background.feixue",
		BackgroundName = "$bv{valkyrie.feixue.background.name}",
		BackgroundDescription = "$bv{valkyrie.feixue.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/feixue_trait",
		TraitID = "$bvvar{modId}.trait.feixue",
		TraitName = "$bv{valkyrie.feixue.trait.name}",
		TraitDescription = "$bv{valkyrie.feixue.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/feixue_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"feixue_everfrost_dominion",
			"feixue_mushin_iai",
			"feixue_blade_liberation"
		],
		HubDetails = {
			Passive = { Icon = "feixue_snowstep", Name = "$bv{skill.feixue_everfrost_dominion.name}", Description = "$bv{skill.feixue_everfrost_dominion.description}", Tooltip = [ { SkillKey = "feixue_everfrost_dominion", Text = "$bv{skill.feixue_everfrost_dominion.tooltip.dedication}" }, { SkillKey = "feixue_everfrost_dominion", Text = "$bv{skill.feixue_everfrost_dominion.tooltip.iai}" } ] },
			Active = { Icon = "feixue_mushin_iai", Name = "$bv{skill.feixue_mushin_iai.name}" + " / " + "$bv{skill.feixue_blade_liberation.name}", Description = "$bv{skill.feixue_mushin_iai.description}" + "\n" + "$bv{skill.feixue_blade_liberation.description}", Tooltip = [ { SkillKey = "feixue_mushin_iai", Text = "$bv{skill.feixue_mushin_iai.tooltip.damage}" }, { SkillKey = "feixue_blade_liberation", Text = "$bv{skill.feixue_blade_liberation.tooltip.damage}" }, { SkillKey = "feixue_blade_liberation", Text = "$bv{skill.feixue_blade_liberation.tooltip.fixed}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	feixiao = {
		ID = "feixiao",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "feixiao_skin",
		Name = "$bv{valkyrie.feixiao.name}",
		Portrait = "ui/valkyries/feixiao_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/feixiao_background",
		BackgroundID = "$bvvar{modId}.background.feixiao",
		BackgroundName = "$bv{valkyrie.feixiao.background.name}",
		BackgroundDescription = "$bv{valkyrie.feixiao.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/feixiao_trait",
		TraitID = "$bvvar{modId}.trait.feixiao",
		TraitName = "$bv{valkyrie.feixiao.trait.name}",
		TraitDescription = "$bv{valkyrie.feixiao.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/feixiao_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"feixiao_thunderhunt",
			"feixiao_waraxe",
			"feixiao_terraverge"
		],
		HubDetails = {
			Passive = { Icon = "feixiao_hunt_pressure", Name = "$bv{skill.feixiao_thunderhunt.name}", Description = "$bv{skill.feixiao_thunderhunt.description}", Tooltip = [ { SkillKey = "feixiao_thunderhunt", Text = "$bv{skill.feixiao_thunderhunt.tooltip.aureus}" }, { SkillKey = "feixiao_thunderhunt", Text = "$bv{skill.feixiao_thunderhunt.tooltip.followup}" } ] },
			Active = { Icon = "feixiao_waraxe", Name = "$bv{skill.feixiao_waraxe.name}" + " / " + "$bv{skill.feixiao_terraverge.name}", Description = "$bv{skill.feixiao_waraxe.description}" + "\n" + "$bv{skill.feixiao_terraverge.description}", Tooltip = [ { SkillKey = "feixiao_waraxe", Text = "$bv{skill.feixiao_waraxe.name}" + ": " + "$bv{skill.feixiao_waraxe.tooltip.followup}" }, { SkillKey = "feixiao_terraverge", Text = "$bv{skill.feixiao_terraverge.name}" + ": " + "$bv{skill.feixiao_terraverge.tooltip.armor}" }, { SkillKey = "feixiao_terraverge", Text = "$bv{skill.feixiao_terraverge.tooltip.execute}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	changli = {
		ID = "changli",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "changli_skin",
		Name = "$bv{valkyrie.changli.name}",
		Portrait = "ui/valkyries/changli_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/changli_background",
		BackgroundID = "$bvvar{modId}.background.changli",
		BackgroundName = "$bv{valkyrie.changli.background.name}",
		BackgroundDescription = "$bv{valkyrie.changli.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/changli_trait",
		TraitID = "$bvvar{modId}.trait.changli",
		TraitName = "$bv{valkyrie.changli.trait.name}",
		TraitDescription = "$bv{valkyrie.changli.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/changli_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"changli_true_sight_enflamement",
			"changli_radiance_of_fealty",
			"changli_flaming_sacrifice"
		],
		HubDetails = {
			Passive = {
				Icon = "changli_delayed_strategy",
				Name = "$bv{skill.changli_true_sight_enflamement.name}",
				Description = "$bv{skill.changli_true_sight_enflamement.description}",
				Tooltip = [
					{ SkillKey = "changli_true_sight_enflamement", Text = "$bv{skill.changli_true_sight_enflamement.tooltip.heart_eye}" },
					{ SkillKey = "changli_true_sight_enflamement", Text = "$bv{skill.changli_true_sight_enflamement.tooltip.layers}" }
				]
			},
			Active = {
				Icon = "changli_inferno" + "_seal",
				Name = "$bv{skill.changli_radiance_of_fealty.name}" + " / " + "$bv{skill.changli_flaming_sacrifice.name}",
				Description = "$bv{skill.changli_radiance_of_fealty.description}" + "\n" + "$bv{skill.changli_flaming_sacrifice.description}",
				Tooltip = [
					{ SkillKey = "changli_radiance_of_fealty", Text = "$bv{skill.changli_radiance_of_fealty.name}" + ": " + "$bv{skill.changli_radiance_of_fealty.tooltip.damage}" },
					{ SkillKey = "changli_radiance_of_fealty", Text = "$bv{skill.changli_radiance_of_fealty.tooltip.layers}" },
					{ SkillKey = "changli_flaming_sacrifice", Text = "$bv{skill.changli_flaming_sacrifice.name}" + ": " + "$bv{skill.changli_flaming_sacrifice.tooltip.damage}" },
					{ SkillKey = "changli_flaming_sacrifice", Text = "$bv{skill.changli_flaming_sacrifice.tooltip.layers}" }
				]
			}
		},
		Equipment = {},
		Quests = []
	},
	raiden_shogun = {
		ID = "raiden_shogun",
		LegendsPerkProfile = "melee_frontline",
		SkinID = "raiden_shogun_skin",
		Name = "$bv{valkyrie.raiden_shogun.name}",
		Portrait = "ui/valkyries/raiden_shogun_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/raiden_shogun_background",
		BackgroundID = "$bvvar{modId}.background.raiden_shogun",
		BackgroundName = "$bv{valkyrie.raiden_shogun.background.name}",
		BackgroundDescription = "$bv{valkyrie.raiden_shogun.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/raiden_shogun_trait",
		TraitID = "$bvvar{modId}.trait.raiden_shogun",
		TraitName = "$bv{valkyrie.raiden_shogun.trait.name}",
		TraitDescription = "$bv{valkyrie.raiden_shogun.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/raiden_shogun_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"raiden_shogun_eternal_authority",
			"raiden_shogun_musou_no_hitotachi"
		],
		Equipment = {},
		Quests = []
	},
	yixuan = {
		ID = "yixuan",
		LegendsPerkProfile = "melee_frontline",
		SkinID = "yixuan_skin",
		SkinIDs = ["yixuan_skin", "yixuan_ink_shadow_skin"],
		Name = "$bv{valkyrie.yixuan.name}",
		Portrait = "ui/valkyries/yixuan_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/yixuan_background",
		BackgroundID = "$bvvar{modId}.background.yixuan",
		BackgroundName = "$bv{valkyrie.yixuan.background.name}",
		BackgroundDescription = "$bv{valkyrie.yixuan.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/yixuan_trait",
		TraitID = "$bvvar{modId}.trait.yixuan",
		TraitName = "$bv{valkyrie.yixuan.trait.name}",
		TraitDescription = "$bv{valkyrie.yixuan.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/yixuan_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"yixuan_arcane_mastery",
			"yixuan_auric_ink_shock",
			"yixuan_endless_talisman_suppression"
		],
		HubDetails = {
			Passive = {
				Icon = "yixuan_preceptor_stance",
				Name = "$bv{skill.yixuan_arcane_mastery.name}",
				Description = "$bv{skill.yixuan_arcane_mastery.description}",
				Tooltip = [
					{ SkillKey = "yixuan_arcane_mastery", Text = "$bv{skill.yixuan_arcane_mastery.tooltip.piercing}" },
					{ SkillKey = "yixuan_arcane_mastery", Text = "$bv{skill.yixuan_arcane_mastery.tooltip.points}" }
				]
			},
			Active = {
				Icon = "yixuan_mountain" + "_suppression",
				Name = "$bv{skill.yixuan_auric_ink_shock.name}" + " / " + "$bv{skill.yixuan_endless_talisman_suppression.name}",
				Description = "$bv{skill.yixuan_auric_ink_shock.description}" + "\n" + "$bv{skill.yixuan_endless_talisman_suppression.description}",
				Tooltip = [
					{ SkillKey = "yixuan_auric_ink_shock", Text = "$bv{skill.yixuan_auric_ink_shock.name}" + ": " + "$bv{skill.yixuan_auric_ink_shock.tooltip.damage}" },
					{ SkillKey = "yixuan_auric_ink_shock", Text = "$bv{skill.yixuan_auric_ink_shock.tooltip.piercing}" },
					{ SkillKey = "yixuan_endless_talisman_suppression", Text = "$bv{skill.yixuan_endless_talisman_suppression.name}" + ": " + "$bv{skill.yixuan_endless_talisman_suppression.tooltip.damage}" },
					{ SkillKey = "yixuan_endless_talisman_suppression", Text = "$bv{skill.yixuan_endless_talisman_suppression.tooltip.points}" }
				]
			}
		},
		Equipment = {},
		Quests = []
	},
	xilian = {
		ID = "xilian",
		LegendsPerkProfile = "ranged_support",
		SkinID = "xilian_skin",
		Name = "$bv{valkyrie.xilian.name}",
		Portrait = "ui/valkyries/xilian_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/xilian_background",
		BackgroundID = "$bvvar{modId}.background.xilian",
		BackgroundName = "$bv{valkyrie.xilian.background.name}",
		BackgroundDescription = "$bv{valkyrie.xilian.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/xilian_trait",
		TraitID = "$bvvar{modId}.trait.xilian",
		TraitName = "$bv{valkyrie.xilian.trait.name}",
		TraitDescription = "$bv{valkyrie.xilian.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/xilian_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"xilian_memory_sanctuary",
			"xilian_beyond_closed_loop"
		],
		AdditionalTraitScripts = [
			"scripts/skills/traits/battle_valkyries/xilian_bond_trait"
		],
		Equipment = {},
		Quests = []
	},
	liuying = {
		ID = "liuying",
		LegendsPerkProfile = "melee_frontline",
		SkinID = "liuying_skin",
		Name = "$bv{valkyrie.liuying.name}",
		Portrait = "ui/valkyries/liuying_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/liuying_background",
		BackgroundID = "$bvvar{modId}.background.liuying",
		BackgroundName = "$bv{valkyrie.liuying.background.name}",
		BackgroundDescription = "$bv{valkyrie.liuying.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/liuying_trait",
		TraitID = "$bvvar{modId}.trait.liuying",
		TraitName = "$bv{valkyrie.liuying.trait.name}",
		TraitDescription = "$bv{valkyrie.liuying.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/liuying_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"liuying_iron_cavalry_armor",
			"liuying_sam_suppression_charge"
		],
		AdditionalTraitScripts = [
			"scripts/skills/traits/battle_valkyries/liuying_bond_trait"
		],
		Equipment = {},
		Quests = []
	},
	cartethyia = {
		ID = "cartethyia",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "cartethyia_skin",
		Name = "$bv{valkyrie.cartethyia.name}",
		Portrait = "ui/valkyries/cartethyia_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/cartethyia_background",
		BackgroundID = "$bvvar{modId}.background.cartethyia",
		BackgroundName = "$bv{valkyrie.cartethyia.background.name}",
		BackgroundDescription = "$bv{valkyrie.cartethyia.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/cartethyia_trait",
		TraitID = "$bvvar{modId}.trait.cartethyia",
		TraitName = "$bv{valkyrie.cartethyia.trait.name}",
		TraitDescription = "$bv{valkyrie.cartethyia.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/cartethyia_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"cartethyia_aero_erosion_web",
			"cartethyia_sword_in_humanity_name",
			"cartethyia_knights_heartfelt_prayers",
			"cartethyia_tempest_break_tides",
			"cartethyia_blade_howling_squall"
		],
		HubDetails = {
			Passive = { Icon = "cartethyia_wind_net", Name = "$bv{skill.cartethyia_aero_erosion_web.name}", Description = "$bv{skill.cartethyia_aero_erosion_web.description}", Tooltip = [ { SkillKey = "cartethyia_aero_erosion_web", Text = "$bv{skill.cartethyia_aero_erosion_web.tooltip}" } ] },
			Active = { Icon = "cartethyia_storm_verdict", Name = "$bv{skill.cartethyia_sword_in_humanity_name.name}" + " / " + "$bv{skill.cartethyia_knights_heartfelt_prayers.name}" + " / " + "$bv{skill.cartethyia_tempest_break_tides.name}" + " / " + "$bv{skill.cartethyia_blade_howling_squall.name}", Description = "$bv{skill.cartethyia_sword_in_humanity_name.description}" + "\n" + "$bv{skill.cartethyia_knights_heartfelt_prayers.description}" + "\n" + "$bv{skill.cartethyia_tempest_break_tides.description}" + "\n" + "$bv{skill.cartethyia_blade_howling_squall.description}", Tooltip = [ { SkillKey = "cartethyia_sword_in_humanity_name", Text = "$bv{skill.cartethyia_sword_in_humanity_name.tooltip}" }, { SkillKey = "cartethyia_knights_heartfelt_prayers", Text = "$bv{skill.cartethyia_knights_heartfelt_prayers.tooltip}" }, { SkillKey = "cartethyia_tempest_break_tides", Text = "$bv{skill.cartethyia_tempest_break_tides.tooltip}" }, { SkillKey = "cartethyia_blade_howling_squall", Text = "$bv{skill.cartethyia_blade_howling_squall.tooltip}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	castorice = {
		ID = "castorice",
		LegendsPerkProfile = "ranged_damage",
		SkinID = "castorice_skin",
		Name = "$bv{valkyrie.castorice.name}",
		Portrait = "ui/valkyries/castorice_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/castorice_background",
		BackgroundID = "$bvvar{modId}.background.castorice",
		BackgroundName = "$bv{valkyrie.castorice.background.name}",
		BackgroundDescription = "$bv{valkyrie.castorice.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/castorice_trait",
		TraitID = "$bvvar{modId}.trait.castorice",
		TraitName = "$bv{valkyrie.castorice.trait.name}",
		TraitDescription = "$bv{valkyrie.castorice.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/castorice_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 55, Stamina = 140, MeleeSkill = 60, RangedSkill = 70, MeleeDefense = 12, RangedDefense = 22, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 3, Bravery = 3, Stamina = 2, MeleeSkill = 1, RangedSkill = 2, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"castorice_newbud",
			"castorice_cocoon_drain",
			"castorice_netherwing_descent"
		],
		Equipment = {},
		Quests = []
	},
	changyeyue = {
		ID = "changyeyue",
		LegendsPerkProfile = "ranged_damage",
		SkinID = "changyeyue_skin",
		Name = "$bv{valkyrie.changyeyue.name}",
		Portrait = "ui/valkyries/changyeyue_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/changyeyue_background",
		BackgroundID = "$bvvar{modId}.background.changyeyue",
		BackgroundName = "$bv{valkyrie.changyeyue.background.name}",
		BackgroundDescription = "$bv{valkyrie.changyeyue.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/changyeyue_trait",
		TraitID = "$bvvar{modId}.trait.changyeyue",
		TraitName = "$bv{valkyrie.changyeyue.trait.name}",
		TraitDescription = "$bv{valkyrie.changyeyue.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/changyeyue_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 105, Bravery = 60, Stamina = 135, MeleeSkill = 60, RangedSkill = 70, MeleeDefense = 14, RangedDefense = 25, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 3, Bravery = 3, Stamina = 2, MeleeSkill = 1, RangedSkill = 2, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"changyeyue_long_night",
			"changyeyue_darkest_riddle"
		],
		Equipment = {},
		Quests = []
	},
	hysilens = {
		ID = "hysilens",
		LegendsPerkProfile = "hybrid_skirmisher",
		SkinID = "hysilens_skin",
		Name = "$bv{valkyrie.hysilens.name}",
		Portrait = "ui/valkyries/hysilens_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/hysilens_background",
		BackgroundID = "$bvvar{modId}.background.hysilens",
		BackgroundName = "$bv{valkyrie.hysilens.background.name}",
		BackgroundDescription = "$bv{valkyrie.hysilens.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/hysilens_trait",
		TraitID = "$bvvar{modId}.trait.hysilens",
		TraitName = "$bv{valkyrie.hysilens.trait.name}",
		TraitDescription = "$bv{valkyrie.hysilens.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/hysilens_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 55, Stamina = 135, MeleeSkill = 55, RangedSkill = 75, MeleeDefense = 12, RangedDefense = 25, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 2, Stamina = 2, MeleeSkill = 1, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 3, Initiative = 2 },
		SkillLoadout = [
			"hysilens_tidal_erosion",
			"hysilens_crystal_tide"
		],
		Equipment = {},
		Quests = []
	},
	tilixibiesi = {
		ID = "tilixibiesi",
		LegendsPerkProfile = "ranged_support",
		SkinID = "tilixibiesi_skin",
		Name = "$bv{valkyrie.tilixibiesi.name}",
		Portrait = "ui/valkyries/tilixibiesi_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/tilixibiesi_background",
		BackgroundID = "$bvvar{modId}.background.tilixibiesi",
		BackgroundName = "$bv{valkyrie.tilixibiesi.background.name}",
		BackgroundDescription = "$bv{valkyrie.tilixibiesi.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/tilixibiesi_trait",
		TraitID = "$bvvar{modId}.trait.tilixibiesi",
		TraitName = "$bv{valkyrie.tilixibiesi.trait.name}",
		TraitDescription = "$bv{valkyrie.tilixibiesi.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/tilixibiesi_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"tilixibiesi_underworld_coordinates",
			"tilixibiesi_beyond_warp"
		],
		Equipment = {},
		Quests = []
	},
	cipher = {
		ID = "cipher",
		LegendsPerkProfile = "hybrid_skirmisher",
		SkinID = "cipher_skin",
		Name = "$bv{valkyrie.cipher.name}",
		Portrait = "ui/valkyries/cipher_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/cipher_background",
		BackgroundID = "$bvvar{modId}.background.cipher",
		BackgroundName = "$bv{valkyrie.cipher.background.name}",
		BackgroundDescription = "$bv{valkyrie.cipher.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/cipher_trait",
		TraitID = "$bvvar{modId}.trait.cipher",
		TraitName = "$bv{valkyrie.cipher.trait.name}",
		TraitDescription = "$bv{valkyrie.cipher.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/cipher_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 80, Bravery = 50, Stamina = 130, MeleeSkill = 65, RangedSkill = 70, MeleeDefense = 18, RangedDefense = 20, Initiative = 140 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 1, Bravery = 2, Stamina = 2, MeleeSkill = 2, RangedSkill = 3, MeleeDefense = 2, RangedDefense = 2, Initiative = 3 },
		SkillLoadout = [
			"cipher_old_patron",
			"cipher_name_your_price",
			"cipher_moonlit_heist"
		],
		Equipment = {},
		Quests = []
	},
	cerydra = {
		ID = "cerydra",
		LegendsPerkProfile = "ranged_support",
		SkinID = "cerydra_skin",
		Name = "$bv{valkyrie.cerydra.name}",
		Portrait = "ui/valkyries/cerydra_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/cerydra_background",
		BackgroundID = "$bvvar{modId}.background.cerydra",
		BackgroundName = "$bv{valkyrie.cerydra.background.name}",
		BackgroundDescription = "$bv{valkyrie.cerydra.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/cerydra_trait",
		TraitID = "$bvvar{modId}.trait.cerydra",
		TraitName = "$bv{valkyrie.cerydra.trait.name}",
		TraitDescription = "$bv{valkyrie.cerydra.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/cerydra_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 85, Bravery = 65, Stamina = 135, MeleeSkill = 60, RangedSkill = 60, MeleeDefense = 18, RangedDefense = 22, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 3, MeleeSkill = 1, RangedSkill = 1, MeleeDefense = 2, RangedDefense = 3, Initiative = 2 },
		SkillLoadout = [
			"cerydra_war_banner",
			"cerydra_promote_pawn",
			"cerydra_checkmate_command"
		],
		Equipment = {},
		Quests = []
	},
	fengjin = {
		ID = "fengjin",
		LegendsPerkProfile = "ranged_support",
		SkinID = "fengjin_skin",
		Name = "$bv{valkyrie.fengjin.name}",
		Portrait = "ui/valkyries/fengjin_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/fengjin_background",
		BackgroundID = "$bvvar{modId}.background.fengjin",
		BackgroundName = "$bv{valkyrie.fengjin.background.name}",
		BackgroundDescription = "$bv{valkyrie.fengjin.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/fengjin_trait",
		TraitID = "$bvvar{modId}.trait.fengjin",
		TraitName = "$bv{valkyrie.fengjin.trait.name}",
		TraitDescription = "$bv{valkyrie.fengjin.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/fengjin_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"fengjin_tailwind_rhythm",
			"fengjin_feather_rescue",
			"fengjin_icarus_impact"
		],
		Equipment = {},
		Quests = []
	},
	yuno = {
		ID = "yuno",
		LegendsPerkProfile = "ranged_support",
		SkinID = "yuno_skin",
		Name = "$bv{valkyrie.yuno.name}",
		Portrait = "ui/valkyries/yuno_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/yuno_background",
		BackgroundID = "$bvvar{modId}.background.yuno",
		BackgroundName = "$bv{valkyrie.yuno.background.name}",
		BackgroundDescription = "$bv{valkyrie.yuno.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/yuno_trait",
		TraitID = "$bvvar{modId}.trait.yuno",
		TraitName = "$bv{valkyrie.yuno.trait.name}",
		TraitDescription = "$bv{valkyrie.yuno.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/yuno_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"yuno_destined_hunt",
			"yuno_death_omen"
		],
		HubDetails = {
			Passive = { Icon = "yuno_oracle_guard", Name = "$bv{skill.yuno_destined_hunt.name}", Description = "$bv{skill.yuno_destined_hunt.description}", Tooltip = [ { SkillKey = "yuno_destined_hunt", Text = "$bv{skill.yuno_destined_hunt.tooltip.hit}" }, { SkillKey = "yuno_destined_hunt", Text = "$bv{skill.yuno_destined_hunt.tooltip.damage}" }, { SkillKey = "yuno_destined_hunt", Text = "$bv{skill.yuno_destined_hunt.tooltip.duration}" } ] },
			Active = { Icon = "yuno_fate_rewrite", Name = "$bv{skill.yuno_death_omen.name}", Description = "$bv{skill.yuno_death_omen.description}", Tooltip = [ { SkillKey = "yuno_death_omen", Text = "$bv{skill.yuno_death_omen.tooltip.attack}" }, { SkillKey = "yuno_death_omen", Text = "$bv{skill.yuno_death_omen.tooltip.followup}" }, { SkillKey = "yuno_death_omen", Text = "$bv{skill.yuno_death_omen.tooltip.refund}" }, { SkillKey = "yuno_death_omen", Text = "$bv{skill.yuno_death_omen.tooltip.duration}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	phoebe = {
		ID = "phoebe",
		LegendsPerkProfile = "ranged_support",
		SkinID = "phoebe_skin",
		Name = "$bv{valkyrie.phoebe.name}",
		Portrait = "ui/valkyries/phoebe_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/phoebe_background",
		BackgroundID = "$bvvar{modId}.background.phoebe",
		BackgroundName = "$bv{valkyrie.phoebe.background.name}",
		BackgroundDescription = "$bv{valkyrie.phoebe.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/phoebe_trait",
		TraitID = "$bvvar{modId}.trait.phoebe",
		TraitName = "$bv{valkyrie.phoebe.trait.name}",
		TraitDescription = "$bv{valkyrie.phoebe.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/phoebe_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 60, RangedSkill = 65, MeleeDefense = 12, RangedDefense = 20, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 1, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 3, Initiative = 2 },
		SkillLoadout = [
			"phoebe_absolution_litany",
			"phoebe_to_where_light_shines"
		],
		HubDetails = {
			Passive = { Icon = "phoebe_absolution_litany", Name = "$bv{skill.phoebe_absolution_litany.name}", Description = "$bv{skill.phoebe_absolution_litany.description}", Tooltip = [ { SkillKey = "phoebe_absolution_litany", Text = "$bv{skill.phoebe_absolution_litany.tooltip.hit}" }, { SkillKey = "phoebe_absolution_litany", Text = "$bv{skill.phoebe_absolution_litany.tooltip.absolution}" }, { SkillKey = "phoebe_absolution_litany", Text = "$bv{skill.phoebe_absolution_litany.tooltip.condition}" } ] },
			Active = { Icon = "phoebe_to_where_light_shines", Name = "$bv{skill.phoebe_to_where_light_shines.name}", Description = "$bv{skill.phoebe_to_where_light_shines.description}", Tooltip = [ { SkillKey = "phoebe_to_where_light_shines", Text = "$bv{skill.phoebe_to_where_light_shines.tooltip.cost}" }, { SkillKey = "phoebe_to_where_light_shines", Text = "$bv{skill.phoebe_to_where_light_shines.tooltip.primary}" }, { SkillKey = "phoebe_to_where_light_shines", Text = "$bv{skill.phoebe_to_where_light_shines.tooltip.area}" }, { SkillKey = "phoebe_to_where_light_shines", Text = "$bv{skill.phoebe_to_where_light_shines.tooltip.rules}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	wisadel = {
		ID = "wisadel",
		LegendsPerkProfile = "ranged_damage",
		SkinID = "wisadel_skin",
		Name = "$bv{valkyrie.wisadel.name}",
		Portrait = "ui/valkyries/wisadel_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/wisadel_background",
		BackgroundID = "$bvvar{modId}.background.wisadel",
		BackgroundName = "$bv{valkyrie.wisadel.background.name}",
		BackgroundDescription = "$bv{valkyrie.wisadel.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/wisadel_trait",
		TraitID = "$bvvar{modId}.trait.wisadel",
		TraitName = "$bv{valkyrie.wisadel.trait.name}",
		TraitDescription = "$bv{valkyrie.wisadel.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/wisadel_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 60, Stamina = 135, MeleeSkill = 60, RangedSkill = 75, MeleeDefense = 12, RangedDefense = 25, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 1, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"wisadel_souvenir",
			"wisadel_explosive_dawn"
		],
		HubDetails = {
			Passive = { Icon = "wisadel_souvenir", Name = "$bv{skill.wisadel_souvenir.name}", Description = "$bv{skill.wisadel_souvenir.description}", Tooltip = [ { SkillKey = "wisadel_souvenir", Text = "$bv{skill.wisadel_souvenir.tooltip.damage}" }, { SkillKey = "wisadel_souvenir", Text = "$bv{skill.wisadel_souvenir.tooltip.stagger}" } ] },
			Active = { Icon = "wisadel_explosive_dawn", Name = "$bv{skill.wisadel_explosive_dawn.name}", Description = "$bv{skill.wisadel_explosive_dawn.description}", Tooltip = [ { SkillKey = "wisadel_explosive_dawn", Text = "$bv{skill.wisadel_explosive_dawn.tooltip.cost}" }, { SkillKey = "wisadel_explosive_dawn", Text = "$bv{skill.wisadel_explosive_dawn.tooltip.damage}" }, { SkillKey = "wisadel_explosive_dawn", Text = "$bv{skill.wisadel_explosive_dawn.tooltip.area}" }, { SkillKey = "wisadel_explosive_dawn", Text = "$bv{skill.wisadel_explosive_dawn.tooltip.control}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	aglaea = {
		ID = "aglaea",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "aglaea_skin",
		Name = "$bv{valkyrie.aglaea.name}",
		Portrait = "ui/valkyries/aglaea_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/aglaea_background",
		BackgroundID = "$bvvar{modId}.background.aglaea",
		BackgroundName = "$bv{valkyrie.aglaea.background.name}",
		BackgroundDescription = "$bv{valkyrie.aglaea.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/aglaea_trait",
		TraitID = "$bvvar{modId}.trait.aglaea",
		TraitName = "$bv{valkyrie.aglaea.trait.name}",
		TraitDescription = "$bv{valkyrie.aglaea.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/aglaea_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 60, Stamina = 130, MeleeSkill = 70, RangedSkill = 50, MeleeDefense = 20, RangedDefense = 15, Initiative = 125 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 3, RangedSkill = 1, MeleeDefense = 2, RangedDefense = 1, Initiative = 2 },
		SkillLoadout = [
			"aglaea_seam_stitch",
			"aglaea_destined_weaving_dance"
		],
		Equipment = {},
		Quests = []
	},
	mai_shiranui = {
		ID = "mai_shiranui",
		LegendsPerkProfile = "hybrid_skirmisher",
		SkinID = "mai_shiranui_skin",
		Name = "$bv{valkyrie.mai_shiranui.name}",
		Portrait = "ui/valkyries/mai_shiranui_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/mai_shiranui_background",
		BackgroundID = "$bvvar{modId}.background.mai_shiranui",
		BackgroundName = "$bv{valkyrie.mai_shiranui.background.name}",
		BackgroundDescription = "$bv{valkyrie.mai_shiranui.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/mai_shiranui_trait",
		TraitID = "$bvvar{modId}.trait.mai_shiranui",
		TraitName = "$bv{valkyrie.mai_shiranui.trait.name}",
		TraitDescription = "$bv{valkyrie.mai_shiranui.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/mai_shiranui_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 140 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 2, Stamina = 2, MeleeSkill = 2, RangedSkill = 3, MeleeDefense = 2, RangedDefense = 2, Initiative = 3 },
		SkillLoadout = [
			"mai_shiranui_kachosen",
			"mai_shiranui_chou_hissatsu_shinobi_bachi"
		],
		HubDetails = {
			Passive = { Icon = "mai_shiranui_kachosen", Name = "$bv{skill.mai_shiranui_kachosen.name}", Description = "$bv{skill.mai_shiranui_kachosen.description}", Tooltip = [ { SkillKey = "mai_shiranui_kachosen", Text = "$bv{skill.mai_shiranui_kachosen.tooltip.penetration}" }, { SkillKey = "mai_shiranui_kachosen", Text = "$bv{skill.mai_shiranui_kachosen.tooltip.fixed}" } ] },
			Active = { Icon = "mai_shiranui_chou_hissatsu_shinobi_bachi", Name = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.name}", Description = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.description}", Tooltip = [ { SkillKey = "mai_shiranui_chou_hissatsu_shinobi_bachi", Text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.attack}" }, { SkillKey = "mai_shiranui_chou_hissatsu_shinobi_bachi", Text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.buff}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	scarlet_shadow = {
		ID = "scarlet_shadow",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "scarlet_shadow_kimono_skin",
		Name = "$bv{valkyrie.scarlet_shadow.name}",
		Portrait = "ui/valkyries/scarlet_shadow_kimono_card.png",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/scarlet_shadow_background",
		BackgroundID = "$bvvar{modId}.background.scarlet_shadow",
		BackgroundName = "$bv{valkyrie.scarlet_shadow.background.name}",
		BackgroundDescription = "$bv{valkyrie.scarlet_shadow.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/scarlet_shadow_trait",
		TraitID = "$bvvar{modId}.trait.scarlet_shadow",
		TraitName = "$bv{valkyrie.scarlet_shadow.trait.name}",
		TraitDescription = "$bv{valkyrie.scarlet_shadow.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/scarlet_shadow_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 50, Stamina = 140, MeleeSkill = 65, RangedSkill = 65, MeleeDefense = 15, RangedDefense = 20, Initiative = 130 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 2, Initiative = 2 },
		SkillLoadout = [
			"scarlet_shadow_flyflower",
			"scarlet_shadow_flower_shadow_trinity",
			"scarlet_shadow_fading_blossom"
		],
		Equipment = {},
		Quests = []
	},
	texas_omertosa = {
		ID = "texas_omertosa",
		LegendsPerkProfile = "melee_mobile",
		SkinID = "texas_omertosa_skin",
		Name = "$bv{valkyrie.texas_omertosa.name}",
		Portrait = "ui/valkyries/texas_omertosa_card.png",
		WorldLeaderBrush = "world_bv_texas_omertosa_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/texas_omertosa_background",
		BackgroundID = "$bvvar{modId}.background.texas_omertosa",
		BackgroundName = "$bv{valkyrie.texas_omertosa.background.name}",
		BackgroundDescription = "$bv{valkyrie.texas_omertosa.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/texas_omertosa_trait",
		TraitID = "$bvvar{modId}.trait.texas_omertosa",
		TraitName = "$bv{valkyrie.texas_omertosa.trait.name}",
		TraitDescription = "$bv{valkyrie.texas_omertosa.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/texas_omertosa_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 90, Bravery = 55, Stamina = 135, MeleeSkill = 70, RangedSkill = 40, MeleeDefense = 18, RangedDefense = 15, Initiative = 140 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 2, Stamina = 2, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 1, Initiative = 3 },
		SkillLoadout = [
			"texas_omertosa_tradition",
			"texas_omertosa_unrelenting_downpour",
			"texas_omertosa_torrential_sword_rain"
		],
		HubDetails = {
			Passive = { Icon = "texas_omertosa_tradition", Name = "$bv{skill.texas_omertosa_tradition.name}", Description = "$bv{skill.texas_omertosa_tradition.description}", Tooltip = [ { SkillKey = "texas_omertosa_tradition", Text = "$bv{skill.texas_omertosa_tradition.tooltip.cut_in}" }, { SkillKey = "texas_omertosa_tradition", Text = "$bv{skill.texas_omertosa_tradition.tooltip.first_kill}" } ] },
			Active = { Icon = "texas_omertosa_torrential_sword_rain", Name = "$bv{skill.texas_omertosa_unrelenting_downpour.name}" + " / " + "$bv{skill.texas_omertosa_torrential_sword_rain.name}", Description = "$bv{skill.texas_omertosa_unrelenting_downpour.description}" + "\n" + "$bv{skill.texas_omertosa_torrential_sword_rain.description}", Tooltip = [ { SkillKey = "texas_omertosa_unrelenting_downpour", Text = "$bv{skill.texas_omertosa_unrelenting_downpour.tooltip.entry}" }, { SkillKey = "texas_omertosa_unrelenting_downpour", Text = "$bv{skill.texas_omertosa_unrelenting_downpour.tooltip.followup}" }, { SkillKey = "texas_omertosa_torrential_sword_rain", Text = "$bv{skill.texas_omertosa_torrential_sword_rain.tooltip.entry}" }, { SkillKey = "texas_omertosa_torrential_sword_rain", Text = "$bv{skill.texas_omertosa_torrential_sword_rain.tooltip.rain}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	sparxie = {
		ID = "sparxie",
		LegendsPerkProfile = "ranged_damage",
		SkinID = "sparxie_skin",
		Name = "$bv{valkyrie.sparxie.name}",
		Portrait = "ui/valkyries/sparxie_card.png",
		WorldLeaderBrush = "world_bv_sparxie_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/sparxie_background",
		BackgroundID = "$bvvar{modId}.background.sparxie",
		BackgroundName = "$bv{valkyrie.sparxie.background.name}",
		BackgroundDescription = "$bv{valkyrie.sparxie.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/sparxie_trait",
		TraitID = "$bvvar{modId}.trait.sparxie",
		TraitName = "$bv{valkyrie.sparxie.trait.name}",
		TraitDescription = "$bv{valkyrie.sparxie.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/sparxie_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 85, Bravery = 55, Stamina = 135, MeleeSkill = 55, RangedSkill = 70, MeleeDefense = 12, RangedDefense = 22, Initiative = 135 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 2, Bravery = 2, Stamina = 2, MeleeSkill = 1, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 3 },
		SkillLoadout = [
			"sparxie_backstage_trick",
			"sparxie_live_connection",
			"sparxie_carnival_live"
		],
		HubDetails = {
			Passive = { Icon = "sparxie_backstage_trick", Name = "$bv{skill.sparxie_backstage_trick.name}", Description = "$bv{skill.sparxie_backstage_trick.description}", Tooltip = [ { SkillKey = "sparxie_backstage_trick", Text = "$bv{skill.sparxie_backstage_trick.tooltip.gift}" }, { SkillKey = "sparxie_backstage_trick", Text = "$bv{skill.sparxie_backstage_trick.tooltip.damage}" }, { SkillKey = "sparxie_backstage_trick", Text = "$bv{skill.sparxie_backstage_trick.tooltip.exclusive}" } ] },
			Active = { Icon = "sparxie_carnival_live", Name = "$bv{skill.sparxie_live_connection.name}" + " / " + "$bv{skill.sparxie_carnival_live.name}", Description = "$bv{skill.sparxie_live_connection.description}" + "\n" + "$bv{skill.sparxie_carnival_live.description}", Tooltip = [ { SkillKey = "sparxie_live_connection", Text = "$bv{skill.sparxie_live_connection.tooltip.guest}" }, { SkillKey = "sparxie_carnival_live", Text = "$bv{skill.sparxie_carnival_live.tooltip.area}" }, { SkillKey = "sparxie_carnival_live", Text = "$bv{skill.sparxie_carnival_live.tooltip.followup}" } ] }
		},
		Equipment = {},
		Quests = []
	},
	the_herta = {
		ID = "the_herta",
		LegendsPerkProfile = "ranged_damage",
		SkinID = "the_herta_skin",
		Name = "$bv{valkyrie.the_herta.name}",
		Portrait = "ui/valkyries/the_herta_card.png",
		WorldLeaderBrush = "world_bv_the_herta_leader",
		BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/the_herta_background",
		BackgroundID = "$bvvar{modId}.background.the_herta",
		BackgroundName = "$bv{valkyrie.the_herta.background.name}",
		BackgroundDescription = "$bv{valkyrie.the_herta.background.description}",
		TraitScript = "scripts/skills/traits/battle_valkyries/the_herta_trait",
		TraitID = "$bvvar{modId}.trait.the_herta",
		TraitName = "$bv{valkyrie.the_herta.trait.name}",
		TraitDescription = "$bv{valkyrie.the_herta.trait.description}",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/the_herta_trait_icon.png",
		Level = 1,
		XP = 0,
		DailyWage = 1,
		BaseAttributes = { Hitpoints = 85, Bravery = 65, Stamina = 125, MeleeSkill = 45, RangedSkill = 75, MeleeDefense = 8, RangedDefense = 22, Initiative = 135 },
		AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
		Talents = { Hitpoints = 1, Bravery = 2, Stamina = 2, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 3 },
		SkillLoadout = [
			"the_herta_optimal_solution",
			"the_herta_false_premise",
			"the_herta_answer_written"
		],
		HubDetails = {
			Passive = { Icon = "the_herta_optimal_solution", Name = "$bv{skill.the_herta_optimal_solution.name}", Description = "$bv{skill.the_herta_optimal_solution.description}", Tooltip = [ { SkillKey = "the_herta_optimal_solution", Text = "$bv{skill.the_herta_optimal_solution.tooltip.inspiration}" }, { SkillKey = "the_herta_optimal_solution", Text = "$bv{skill.the_herta_optimal_solution.tooltip.calculation}" } ] },
			Active = { Icon = "the_herta_answer_written", Name = "$bv{skill.the_herta_false_premise.name}" + " / " + "$bv{skill.the_herta_answer_written.name}", Description = "$bv{skill.the_herta_false_premise.description}" + "\n" + "$bv{skill.the_herta_answer_written.description}", Tooltip = [ { SkillKey = "the_herta_false_premise", Text = "$bv{skill.the_herta_false_premise.tooltip.control}" }, { SkillKey = "the_herta_answer_written", Text = "$bv{skill.the_herta_answer_written.tooltip.primary}" }, { SkillKey = "the_herta_answer_written", Text = "$bv{skill.the_herta_answer_written.tooltip.area}" } ] }
		},
		Equipment = {},
		Quests = []
	}
};

::$bvvar{namespace}.getValkyrieByID <- function( _valkyrieID )
{
	return _valkyrieID in ::$bvvar{namespace}.Valkyries ? ::$bvvar{namespace}.Valkyries[_valkyrieID] : null;
};

::$bvvar{namespace}.getValkyrieSkinIDs <- function( _template )
{
	local ret = [];
	local seen = {};

	if (_template == null)
	{
		return ret;
	}

	if ("SkinID" in _template && _template.SkinID != null && _template.SkinID != "")
	{
		ret.push(_template.SkinID);
		seen[_template.SkinID] <- true;
	}

	if ("SkinIDs" in _template && typeof _template.SkinIDs == "array")
	{
		foreach( skinID in _template.SkinIDs )
		{
			if (skinID == null || skinID == "" || skinID in seen)
			{
				continue;
			}

			ret.push(skinID);
			seen[skinID] <- true;
		}
	}

	return ret;
};

::$bvvar{namespace}.getValkyrieDefaultSkinID <- function( _template )
{
	local skinIDs = ::$bvvar{namespace}.getValkyrieSkinIDs(_template);
	return skinIDs.len() > 0 ? skinIDs[0] : null;
};

::$bvvar{namespace}.isValkyrieSkinAllowed <- function( _template, _skinID )
{
	if (_template == null || _skinID == null || _skinID == "")
	{
		return false;
	}

	foreach( skinID in ::$bvvar{namespace}.getValkyrieSkinIDs(_template) )
	{
		if (skinID == _skinID)
		{
			return true;
		}
	}

	return false;
};

// Entitlement is separate from identity validation: an existing selected skin
// remains readable across upgrades, while new acquisition is chapter-gated.
::$bvvar{namespace}.isValkyrieSkinUnlocked <- function( _template, _skinID, _actor = null )
{
	local skin = ::$bvvar{namespace}.getSkin(_skinID);
	if (skin != null && "UnlockHuTaoBond" in skin)
		return _template != null && _template.ID == "hu_tao" && "HuTaoBond" in ::$bvvar{namespace} && ::$bvvar{namespace}.HuTaoBond.skinUnlocked(_actor);
	if (skin != null && "UnlockKanadeBond" in skin)
		return _template != null && _template.ID == "kanade_tachibana" && "KanadeBond" in ::$bvvar{namespace} && ::$bvvar{namespace}.KanadeBond.skinUnlocked(_actor, skin.UnlockKanadeBond);
	if (skin != null && "UnlockHertaBond" in skin)
        return _template != null && _template.ID == "the_herta" && "HertaBond" in ::$bvvar{namespace} && ::$bvvar{namespace}.HertaBond.skinUnlocked(_actor);
	if (skin != null && "UnlockSaberBond" in skin)
        return _template != null && _template.ID == "saber" && "SaberBond" in ::$bvvar{namespace} && ::$bvvar{namespace}.SaberBond.skinUnlocked(_actor);
	if (skin != null && "UnlockBlackBeastStage" in skin)
		return _template != null && _template.ID == skin.BlackBeastOwner && "BlackBeast" in ::$bvvar{namespace} && ::$bvvar{namespace}.BlackBeast.skinUnlocked(_actor, skin.BlackBeastOwner, skin.UnlockBlackBeastStage);
	if (skin != null && "UnlockOlgaStage" in skin)
		return _template != null && _template.ID == "olga" && "Olga" in ::$bvvar{namespace} && ::$bvvar{namespace}.Olga.skinUnlocked(_actor, skin.UnlockOlgaStage);
	if (skin == null || !("UnlockChapter" in skin)) return true;
	local unlockedFlag = "$bvvar{modId}.skin.unlocked." + _skinID;
	if (_actor != null && (_actor.getFlags().get(unlockedFlag) == true || _actor.getFlags().get(::$bvvar{namespace}.ValkyrieSkinIDFlag) == _skinID)) return true;
	if (!("World" in ::getroottable()) || ::World == null || ::World.Flags == null) return false;
	local prefix = "$bvvar{modId}.chapter." + skin.UnlockChapter + ".";
	local completed = ::World.Flags.get(prefix + "completed"), schema = ::World.Flags.get(prefix + "schema");
	if (::World.Flags.get(prefix + "skin_unlocked") == 1 || (typeof completed == "integer" && completed >= (schema == 2 ? 8 : 7))) return true;
	if ("getPlayerRoster" in ::World)
		foreach (a in ::World.getPlayerRoster().getAll())
			if (a != null && (a.getFlags().get(unlockedFlag) == true || a.getFlags().get(::$bvvar{namespace}.ValkyrieSkinIDFlag) == _skinID)) return true;
	return false;
};

::$bvvar{namespace}.resolveValkyrieSkinID <- function( _template, _skinID = null )
{
	if (::$bvvar{namespace}.isValkyrieSkinAllowed(_template, _skinID) && ::$bvvar{namespace}.getSkin(_skinID) != null)
	{
		return _skinID;
	}

	local defaultSkinID = ::$bvvar{namespace}.getValkyrieDefaultSkinID(_template);
	return ::$bvvar{namespace}.isValkyrieSkinAllowed(_template, defaultSkinID) && ::$bvvar{namespace}.getSkin(defaultSkinID) != null ? defaultSkinID : null;
};

::$bvvar{namespace}.getValkyrieBySkinID <- function( _skinID )
{
	if (_skinID == null || _skinID == "")
	{
		return null;
	}

	foreach( _, template in ::$bvvar{namespace}.Valkyries )
	{
		if (::$bvvar{namespace}.isValkyrieSkinAllowed(template, _skinID))
		{
			return template;
		}
	}

	return null;
};

::$bvvar{namespace}.getValkyrieSkinPortraitPath <- function( _template, _skinID = null )
{
	if (_template == null)
	{
		return "";
	}

	local skin = ::$bvvar{namespace}.getSkin(::$bvvar{namespace}.resolveValkyrieSkinID(_template, _skinID));
	return skin != null && "Portrait" in skin && skin.Portrait != "" ? skin.Portrait : _template.Portrait;
};

::$bvvar{namespace}.getValkyrieSkinPreviewPath <- function( _template, _skinID = null )
{
	if (_template == null)
	{
		return "";
	}

	local skin = ::$bvvar{namespace}.getSkin(::$bvvar{namespace}.resolveValkyrieSkinID(_template, _skinID));
	if (skin != null && "Preview" in skin && skin.Preview != "") return skin.Preview;
	return "SkinPreview" in _template ? _template.SkinPreview : "ui/valkyries/" + _template.ID + "_skin_preview.png";
};

::$bvvar{namespace}.getValkyrieSkinItemIconPath <- function( _template, _skinID = null )
{
	if (_template == null)
	{
		return "$bvvar{iconPrefix}/valkyries_hub_icon.png";
	}

	local skin = ::$bvvar{namespace}.getSkin(::$bvvar{namespace}.resolveValkyrieSkinID(_template, _skinID));
	if (skin != null && "ItemIcon" in skin && skin.ItemIcon != "") return skin.ItemIcon;
	return "SkinItemIcon" in _template ? _template.SkinItemIcon : "$bvvar{iconPrefix}/" + _template.ID + "_skin_icon.png";
};

::$bvvar{namespace}.getValkyrieSkinTabName <- function( _template, _skinID )
{
	local skin = ::$bvvar{namespace}.getSkin(_skinID);
	if (skin == null) return "";
	if (_skinID == ::$bvvar{namespace}.getValkyrieDefaultSkinID(_template)) return "$bv{ui.hub.skin_tab.original}";
	if ("TabName" in skin && skin.TabName != "") return skin.TabName;
	return skin.Name;
};

::$bvvar{namespace}.getValkyrieSkinItemBaseName <- function( _template, _skinID )
{
	local skin = ::$bvvar{namespace}.getSkin(_skinID);
	if (skin != null && "ItemName" in skin && skin.ItemName != "") return skin.ItemName;
	if (_template != null && _skinID == ::$bvvar{namespace}.getValkyrieDefaultSkinID(_template)) return _template.Name;
	return skin != null ? skin.Name : (_template != null ? _template.Name : "$bv{item.valkyrie_skin.fallback_name}");
};

::$bvvar{namespace}.bindValkyrieSkinPresentation <- function( _template, _skinID )
{
	local skin = ::$bvvar{namespace}.getSkin(_skinID);
	if (_template == null || skin == null)
	{
		return false;
	}

	if ("ValkyrieID" in skin && skin.ValkyrieID != _template.ID)
	{
		throw "Skin '" + _skinID + "' is already bound to Valkyrie '" + skin.ValkyrieID + "'";
	}

	if (!("ValkyrieID" in skin)) skin.ValkyrieID <- _template.ID;
	if (!("IsOriginal" in skin)) skin.IsOriginal <- _skinID == ::$bvvar{namespace}.getValkyrieDefaultSkinID(_template);
	if (!("TabName" in skin)) skin.TabName <- skin.IsOriginal ? "$bv{ui.hub.skin_tab.original}" : skin.Name;
	if (!("Description" in skin)) skin.Description <- "$bv{ui.hub.skin_description.original}";
	if (!("Portrait" in skin)) skin.Portrait <- _template.Portrait;
	if (!("Preview" in skin)) skin.Preview <- "SkinPreview" in _template ? _template.SkinPreview : "ui/valkyries/" + _template.ID + "_skin_preview.png";
	if (!("TraitIcon" in skin)) skin.TraitIcon <- "TraitIcon" in _template ? _template.TraitIcon : "ui/traits/trait_icon_63.png";
	if (!("ItemIcon" in skin)) skin.ItemIcon <- "SkinItemIcon" in _template ? _template.SkinItemIcon : "$bvvar{iconPrefix}/" + _template.ID + "_skin_icon.png";
	return true;
};

::$bvvar{namespace}.bindAllValkyrieSkinPresentations <- function()
{
	foreach( _, template in ::$bvvar{namespace}.Valkyries )
	{
		foreach( skinID in ::$bvvar{namespace}.getValkyrieSkinIDs(template) )
		{
			::$bvvar{namespace}.bindValkyrieSkinPresentation(template, skinID);
		}
	}
};

if ("getSkin" in ::$bvvar{namespace})
{
	::$bvvar{namespace}.bindAllValkyrieSkinPresentations();
}

::$bvvar{namespace}.getValkyrieWorldLeaderBrush <- function( _template, _skinID = null )
{
	if (_template == null) return null;
	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(_template, _skinID);
	local skin = skinID == null ? null : ::$bvvar{namespace}.getSkin(skinID);
	if (skin != null && "WorldLeaderBrush" in skin)
	{
		return skin.WorldLeaderBrush == "" ? null : skin.WorldLeaderBrush;
	}
	if ("WorldLeaderBrush" in _template) return _template.WorldLeaderBrush == "" ? null : _template.WorldLeaderBrush;
	return "world_bv_" + _template.ID + "_leader";
};

::$bvvar{namespace}.makeEmptyAttributeRangeTable <- function()
{
	return {
		Hitpoints = [0, 0],
		Bravery = [0, 0],
		Stamina = [0, 0],
		MeleeSkill = [0, 0],
		RangedSkill = [0, 0],
		MeleeDefense = [0, 0],
		RangedDefense = [0, 0],
		Initiative = [0, 0]
	};
};

::$bvvar{namespace}.getValkyrieAttributeAdjustments <- function( _valkyrieID )
{
	local ret = ::$bvvar{namespace}.makeEmptyAttributeRangeTable();
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null || !("AttributeAdjustments" in template))
	{
		return ret;
	}

	foreach( stat, range in template.AttributeAdjustments )
	{
		if (stat in ret)
		{
			ret[stat] = range;
		}
	}

	return ret;
};

::$bvvar{namespace}.setupValkyrieBackground <- function( _background, _valkyrieID )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null)
	{
		return;
	}

	_background.m.ID = template.BackgroundID;
	_background.m.Name = template.BackgroundName;
	_background.m.Icon = "ui/backgrounds/$bvvar{iconPrefix}/valkyrie_background_icon.png";
	_background.m.BackgroundDescription = template.BackgroundDescription;
	_background.m.HiringCost = 0;
	_background.m.DailyCost = template.DailyWage;
	_background.m.DailyCostMult = 1.0;
	_background.m.Level = template.Level;
	_background.m.IsCombatBackground = true;
	_background.m.Names = [template.Name];
	_background.m.Titles = [];
	_background.m.LastNames = [];
	_background.m.RawDescription = template.BackgroundDescription;
};

::$bvvar{namespace}.setupValkyrieTrait <- function( _trait, _valkyrieID )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null)
	{
		return;
	}

	_trait.m.ID = template.TraitID;
	_trait.m.Name = template.TraitName;
	_trait.m.Icon = "TraitIcon" in template ? template.TraitIcon : "ui/traits/trait_icon_63.png";
	_trait.m.Description = template.TraitDescription;
	_trait.m.Titles = [];
	_trait.m.Excluded = [];
};

::$bvvar{namespace}.getValkyrieSkinTraitScript <- function( _valkyrieID )
{
	if (_valkyrieID == null || _valkyrieID == "")
	{
		return null;
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template != null && "PackID" in template)
	{
		return "$bvvar{privateFolder}/skills/traits/valkyrie_generic_skin_trait";
	}

	return "$bvvar{privateFolder}/skills/traits/" + _valkyrieID + "_skin_trait";
};

::$bvvar{namespace}.createValkyrieSkinTrait <- function( _context, _actor, _template, _skinID = null )
{
	if (_template == null || !("ID" in _template))
	{
		return null;
	}

	local script = ::$bvvar{namespace}.getValkyrieSkinTraitScript(_template.ID);

	if (script == null)
	{
		return null;
	}

	local trait = ::$bvvar{namespace}.createValkyrieScriptObject(_context, _actor, script);

	if (trait != null)
	{
		::$bvvar{namespace}.setupValkyrieSkinTrait(trait, _template.ID, _skinID);
	}

	return trait;
};

::$bvvar{namespace}.getValkyrieSkinTraitID <- function( _skinID )
{
	if (_skinID == null || _skinID == "")
	{
		return null;
	}

	return "$bvvar{modId}.skin_trait." + _skinID;
};

::$bvvar{namespace}.setupValkyrieSkinTrait <- function( _trait, _valkyrieID, _skinID = null )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null)
	{
		return;
	}

	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _skinID);
	local skin = ::$bvvar{namespace}.getSkin(skinID);

	if (skin == null)
	{
		return;
	}

	_trait.m.IsSerialized = false;
	_trait.m.ID = ::$bvvar{namespace}.getValkyrieSkinTraitID(skin.ID);
	_trait.m.Name = skin.Name;
	_trait.m.Icon = "TraitIcon" in skin && skin.TraitIcon != "" ? skin.TraitIcon : ("TraitIcon" in template ? template.TraitIcon : "ui/traits/trait_icon_63.png");
	_trait.m.Description = "TraitDescription" in skin && skin.TraitDescription != "" ? skin.TraitDescription : "$bv{skin_trait.description_prefix}" + skin.Name + "$bv{skin_trait.description_suffix}";
	_trait.m.Titles = [];
	_trait.m.Excluded = [];
	if ("IsBattleValkyriesSkinTrait" in _trait.m)
	{
		_trait.m.IsBattleValkyriesSkinTrait = true;
	}
	else
	{
		_trait.m.IsBattleValkyriesSkinTrait <- true;
	}

	if ("BattleValkyriesSkinID" in _trait.m)
	{
		_trait.m.BattleValkyriesSkinID = skin.ID;
	}
	else
	{
		_trait.m.BattleValkyriesSkinID <- skin.ID;
	}

	if ("BattleValkyriesSkinValkyrieID" in _trait.m)
	{
		_trait.m.BattleValkyriesSkinValkyrieID = template.ID;
	}
	else
	{
		_trait.m.BattleValkyriesSkinValkyrieID <- template.ID;
	}
};

::$bvvar{namespace}.getValkyrieSkinTraitTooltip <- function( _trait )
{
	return [
		{
			id = 1,
			type = "title",
			text = _trait.getName()
		},
		{
			id = 2,
			type = "description",
			text = _trait.getDescription()
		},
		{
			id = 3,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{skin_trait.tooltip.visual_only}"
		},
		{
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{skin_trait.tooltip.hide_weapons}"
		}
	];
};

::$bvvar{namespace}.applyValkyrieBaseAttributes <- function( _actor, _template )
{
	if (_actor == null || _template == null || !("BaseAttributes" in _template))
	{
		return;
	}

	local properties = _actor.getBaseProperties();

	foreach( stat in ::$bvvar{namespace}.ValkyrieAttributeNames )
	{
		if (stat in _template.BaseAttributes)
		{
			properties[stat] = _template.BaseAttributes[stat];
		}
	}

	_actor.m.CurrentProperties = clone properties;
	_actor.setHitpoints(properties.Hitpoints);
};

::$bvvar{namespace}.applyValkyrieTalents <- function( _actor, _template )
{
	if (_actor == null || _template == null || !("Talents" in _template))
	{
		return;
	}

	_actor.m.Talents = [];
	local talents = _actor.getTalents();
	talents.resize(::Const.Attributes.COUNT, 0);

	foreach( stat, value in _template.Talents )
	{
		if (stat in ::$bvvar{namespace}.ValkyrieAttributeConst)
		{
			talents[::$bvvar{namespace}.ValkyrieAttributeConst[stat]] = value;
		}
	}
};

::$bvvar{namespace}.isActorDeadOrDying <- function( _actor )
{
	if (_actor == null)
	{
		return true;
	}

	try
	{
		if (!_actor.isAlive() || _actor.isDying())
		{
			return true;
		}
	}
	catch (e)
	{
		return true;
	}

	try
	{
		if (_actor.getHitpoints() <= 0)
		{
			return true;
		}
	}
	catch (e)
	{
	}

	return false;
};

::$bvvar{namespace}.isActorValkyrie <- function( _actor )
{
	local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);
	return valkyrieID != null && valkyrieID != "";
};

::$bvvar{namespace}.getActorFlagString <- function( _actor, _flag )
{
	if (_actor == null)
	{
		return null;
	}

	local flags = null;

	try
	{
		flags = _actor.getFlags();
	}
	catch (e)
	{
		return null;
	}

	if (flags == null || !flags.has(_flag))
	{
		return null;
	}

	local value = flags.get(_flag);
	return value == false ? null : value;
};

::$bvvar{namespace}.isValkyrieSkinTrait <- function( _skill )
{
	return _skill != null
		&& "m" in _skill
		&& "IsBattleValkyriesSkinTrait" in _skill.m
		&& _skill.m.IsBattleValkyriesSkinTrait;
};

::$bvvar{namespace}.getActorValkyrieSkinTrait <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	local skills = null;

	try
	{
		skills = _actor.getSkills();
	}
	catch (e)
	{
		skills = null;
	}

	if (skills == null || !("m" in skills) || !("Skills" in skills.m))
	{
		return null;
	}

	foreach( skill in skills.m.Skills )
	{
		if (!::$bvvar{namespace}.isValkyrieSkinTrait(skill))
		{
			continue;
		}

		local isGarbage = false;

		try
		{
			isGarbage = skill.isGarbage();
		}
		catch (e)
		{
			isGarbage = false;
		}

		if (!isGarbage)
		{
			return skill;
		}
	}

	return null;
};

::$bvvar{namespace}.getActorValkyrieSkinIDFromTrait <- function( _actor )
{
	local trait = ::$bvvar{namespace}.getActorValkyrieSkinTrait(_actor);

	if (trait == null || !("BattleValkyriesSkinID" in trait.m))
	{
		return null;
	}

	local skinID = trait.m.BattleValkyriesSkinID;
	return skinID != null && skinID != "" && ::$bvvar{namespace}.getSkin(skinID) != null ? skinID : null;
};

::$bvvar{namespace}.setActorValkyrieSkinID <- function( _actor, _skinID )
{
	if (_actor == null || _skinID == null || _skinID == "" || ::$bvvar{namespace}.getSkin(_skinID) == null)
	{
		return false;
	}

	try
	{
		local flags = _actor.getFlags();

		if (flags == null)
		{
			return false;
		}

		flags.set(::$bvvar{namespace}.ValkyrieSkinIDFlag, _skinID);
		return true;
	}
	catch (e)
	{
	}

	return false;
};

::$bvvar{namespace}.persistActorValkyrieSkinTrait <- function( _actor )
{
	local skinID = ::$bvvar{namespace}.getActorValkyrieSkinIDFromTrait(_actor);
	return skinID != null && skinID != "" && ::$bvvar{namespace}.setActorValkyrieSkinID(_actor, skinID);
};

::$bvvar{namespace}.removeActorValkyrieSkinTraits <- function( _actor )
{
	if (_actor == null)
	{
		return 0;
	}

	local skills = null;

	try
	{
		skills = _actor.getSkills();
	}
	catch (e)
	{
		return 0;
	}

	if (skills == null || !("m" in skills) || !("Skills" in skills.m))
	{
		return 0;
	}

	local ids = [];

	foreach( skill in skills.m.Skills )
	{
		if (::$bvvar{namespace}.isValkyrieSkinTrait(skill))
		{
			try
			{
				ids.push(skill.getID());
			}
			catch (e)
			{
			}
		}
	}

	foreach( id in ids )
	{
		try
		{
			skills.removeByID(id);
		}
		catch (e)
		{
		}
	}

	return ids.len();
};

::$bvvar{namespace}.grantActorValkyrieSkinTrait <- function( _actor, _valkyrieID, _context = null, _skinID = null )
{
	if (_actor == null || _valkyrieID == null || _valkyrieID == "")
	{
		return false;
	}

	if (::$bvvar{namespace}.isActorDeadOrDying(_actor))
	{
		return false;
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);
	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _skinID);

	if (template == null || skinID == null || (_skinID != null && _skinID != "" && skinID != _skinID))
	{
		return false;
	}

	if (!::$bvvar{namespace}.isValkyrieSkinUnlocked(template, skinID, _actor)) return false;
	local trait = ::$bvvar{namespace}.createValkyrieSkinTrait(_context, _actor, template, skinID);

	if (trait == null)
	{
		return false;
	}

	// Skin traits are runtime-only. Persist the selected visual identity on the
	// actor before installing the trait so it can be rebuilt after loading.
	if (!::$bvvar{namespace}.setActorValkyrieSkinID(_actor, skinID))
	{
		return false;
	}

	::$bvvar{namespace}.removeActorValkyrieSkinTraits(_actor);
	_actor.getSkills().add(trait);
	_actor.getSkills().update();

	try
	{
		_actor.getItems().updateAppearance();
	}
	catch (e)
	{
	}

	if ("applySkinToActor" in ::$bvvar{namespace})
	{
		::$bvvar{namespace}.applySkinToActor(_actor, true);
	}

	try
	{
		_actor.setDirty(true);
	}
	catch (e)
	{
	}

	return true;
};

::$bvvar{namespace}.setActorValkyrieIdentity <- function( _actor, _valkyrieID, _skinID = null )
{
	if (_actor == null)
	{
		return;
	}

	if (_valkyrieID == null || _valkyrieID == "")
	{
		return;
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);
	local skinID = _skinID;

	if (skinID == null || skinID == "")
	{
		skinID = ::$bvvar{namespace}.getValkyrieDefaultSkinID(template);
	}

	local flags = null;

	try
	{
		flags = _actor.getFlags();
	}
	catch (e)
	{
		flags = null;
	}

	if (flags != null)
	{
		flags.set(::$bvvar{namespace}.ValkyrieIDFlag, _valkyrieID);

		if (skinID != null && skinID != "")
		{
			flags.set(::$bvvar{namespace}.ValkyrieSkinIDFlag, skinID);
		}
	}

};

::$bvvar{namespace}.syncActorValkyrieIdentity <- function( _actor )
{
	if (_actor == null)
	{
		return;
	}

	local valkyrieID = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieIDFlag);

	if (valkyrieID == null || valkyrieID == "")
	{
		return;
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);

	local defaultSkinID = ::$bvvar{namespace}.getValkyrieDefaultSkinID(template);

	if (template == null || defaultSkinID == null)
	{
		return;
	}

	local skinID = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);

	if (skinID != null && skinID != "")
	{
		return;
	}

	try
	{
		_actor.getFlags().set(::$bvvar{namespace}.ValkyrieSkinIDFlag, defaultSkinID);
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.getActorValkyrieID <- function( _actor )
{
	return ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieIDFlag);
};

::$bvvar{namespace}.getActorValkyrieSkinID <- function( _actor )
{
	local traitSkinID = ::$bvvar{namespace}.getActorValkyrieSkinIDFromTrait(_actor);

	if (traitSkinID != null && traitSkinID != "")
	{
		return traitSkinID;
	}

	local skinID = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);

	if (skinID != null && skinID != "")
	{
		return skinID;
	}

	local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);

	if (valkyrieID == null || valkyrieID == "")
	{
		return null;
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
	return ::$bvvar{namespace}.getValkyrieDefaultSkinID(template);
};

::$bvvar{namespace}.getActorValkyrieSkinTemplate <- function( _actor )
{
	return ::$bvvar{namespace}.getValkyrieBySkinID(::$bvvar{namespace}.getActorValkyrieSkinID(_actor));
};
