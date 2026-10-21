::$bvvar{namespace}.ValkyrieOrder.push("ryza");
::$bvvar{namespace}.Valkyries.ryza <- {
 ID = "ryza", LegendsPerkProfile = "ranged_support", SkinID = "ryza_skin", SkinIDs = ["ryza_skin"],
 Name = "$bv{valkyrie.ryza.name}", Portrait = "ui/valkyries/ryza_card.png", WorldLeaderBrush = "world_bv_ryza_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/ryza_background", BackgroundID = "$bvvar{modId}.background.ryza",
 BackgroundName = "$bv{valkyrie.ryza.background.name}", BackgroundDescription = "$bv{valkyrie.ryza.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/ryza_trait", TraitID = "$bvvar{modId}.trait.ryza",
 TraitName = "$bv{valkyrie.ryza.trait.name}", TraitDescription = "$bv{valkyrie.ryza.trait.description}",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/ryza_trait_icon.png",
 Level = 1, XP = 0, DailyWage = 1,
 BaseAttributes = { Hitpoints = 95, Bravery = 90, Stamina = 120, MeleeSkill = 60, RangedSkill = 85, MeleeDefense = 15, RangedDefense = 20, Initiative = 100 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 3, Bravery = 2, Stamina = 3, MeleeSkill = 1, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 2, Initiative = 0 },
 SkillLoadout = ["ryza_core_crystal", "ryza_pulse", "ryza_flame", "ryza_frost", "ryza_elixir", "ryza_core_drive"],
 Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon = "ryza_core_crystal", Name = "$bv{ryza.passives}", Description = "$bv{skill.ryza_core_crystal.description}" },
  Active = { Icon = "ryza_pulse", Name = "$bv{ryza.actives}", Description = "$bv{skill.ryza_pulse.name}: $bv{skill.ryza_pulse.description}\n$bv{skill.ryza_core_drive.name}: $bv{skill.ryza_core_drive.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.ryza <- { TraitTooltip = "$bv{valkyrie.ryza.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.ryza_skin <- {
 ID = "ryza_skin", Name = "$bv{skin.ryza_skin.name}", TabName = "$bv{skin.ryza_skin.name}", Description = "$bv{skin.ryza_skin.description}",
 Brush = "bust_bv_ryza_skin", DeathBrush = "bust_bv_ryza_skin_dead", WorldLeaderBrush = "world_bv_ryza_leader",
 Portrait = "ui/valkyries/ryza_card.png", Preview = "ui/valkyries/ryza_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/ryza_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/ryza_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/ryza_skin_poster.jpg", Video = "ui/valkyries/detail/ryza_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 }
};
