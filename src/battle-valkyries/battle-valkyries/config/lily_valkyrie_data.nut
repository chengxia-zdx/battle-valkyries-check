::$bvvar{namespace}.ValkyrieOrder.push("lily");

::$bvvar{namespace}.Valkyries.lily <- {
	ID = "lily",
	LegendsPerkProfile = "ranged_support",
	SkinID = "lily_skin",
	Name = "$bv{valkyrie.lily.name}",
	Portrait = "ui/valkyries/lily_card.png",
	WorldLeaderBrush = "world_bv_lily_leader",
	BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/lily_background",
	BackgroundID = "$bvvar{modId}.background.lily",
	BackgroundName = "$bv{valkyrie.lily.background.name}",
	BackgroundDescription = "$bv{valkyrie.lily.background.description}",
	TraitScript = "scripts/skills/traits/battle_valkyries/lily_trait",
	TraitID = "$bvvar{modId}.trait.lily",
	TraitName = "$bv{valkyrie.lily.trait.name}",
	TraitDescription = "$bv{valkyrie.lily.trait.description}",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/lily_trait_icon.png",
	Level = 1,
	XP = 0,
	DailyWage = 1,
	BaseAttributes = { Hitpoints = 78, Bravery = 75, Stamina = 120, MeleeSkill = 70, RangedSkill = 70, MeleeDefense = 12, RangedDefense = 18, Initiative = 125 },
	AttributeAdjustments = { Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0], MeleeSkill = [0, 0], RangedSkill = [0, 0], MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0] },
	Talents = { Hitpoints = 2, Bravery = 3, Stamina = 2, MeleeSkill = 2, RangedSkill = 2, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
	SkillLoadout = [
		"lily_blight_controller",
		"lily_prayer",
		"lily_accept_blight",
		"lily_final_purification"
	],
	AdditionalTraitScripts = ["scripts/skills/traits/battle_valkyries/lily_spirit_record_trait"],
	HubDetails = {
		Passive = { Icon = "lily_blight_controller", Name = "$bv{skill.lily_blight_controller.name}", Description = "$bv{skill.lily_blight_controller.description}" },
		Active = { Icon = "lily_prayer", Name = "$bv{skill.lily_prayer.name}" + " / " + "$bv{skill.lily_accept_blight.name}", Description = "$bv{skill.lily_prayer.description}" + "\n" + "$bv{skill.lily_accept_blight.description}" }
	},
	Equipment = {},
	Quests = []
};
