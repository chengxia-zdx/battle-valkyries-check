::$bvvar{namespace}.ValkyrieOrder.push("shu");
::$bvvar{namespace}.Valkyries.shu <- {
 ID = "shu", LegendsPerkProfile = "melee_support", SkinID = "shu_skin", SkinIDs = ["shu_skin"],
 Name = "$bv{valkyrie.shu.name}", Portrait = "ui/valkyries/shu_card.png", WorldLeaderBrush = "world_bv_shu_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/shu_background", BackgroundID = "$bvvar{modId}.background.shu",
 BackgroundName = "$bv{valkyrie.shu.background.name}", BackgroundDescription = "$bv{valkyrie.shu.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/shu_trait", TraitID = "$bvvar{modId}.trait.shu",
 TraitName = "$bv{valkyrie.shu.trait.name}", TraitDescription = "$bv{valkyrie.shu.trait.description}",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/shu_trait_icon.png",
 Level = 1, XP = 0, DailyWage = 1,
 BaseAttributes = { Hitpoints = 130, Bravery = 90, Stamina = 140, MeleeSkill = 60, RangedSkill = 40, MeleeDefense = 25, RangedDefense = 20, Initiative = 100 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 3, Bravery = 2, Stamina = 3, MeleeSkill = 1, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 2, Initiative = 0 },
 SkillLoadout = ["shu_thick_earth", "shu_evergreen", "shu_bountiful_harvest", "shu_nurture", "shu_granary"],
 Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon = "shu_evergreen", Name = "$bv{shu.passives}", Description = "$bv{skill.shu_thick_earth.description}\n$bv{skill.shu_evergreen.description}\n$bv{skill.shu_bountiful_harvest.description}" },
  Active = { Icon = "shu_nurture", Name = "$bv{shu.actives}", Description = "$bv{skill.shu_nurture.name}: $bv{skill.shu_nurture.description}\n$bv{skill.shu_granary.name}: $bv{skill.shu_granary.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.shu <- { TraitTooltip = "$bv{valkyrie.shu.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.shu_skin <- {
 ID = "shu_skin", Name = "$bv{skin.shu_skin.name}", TabName = "$bv{skin.shu_skin.name}", Description = "$bv{skin.shu_skin.description}",
 Brush = "bust_bv_shu_skin", DeathBrush = "bust_bv_shu_skin_dead", WorldLeaderBrush = "world_bv_shu_leader",
 Portrait = "ui/valkyries/shu_card.png", Preview = "ui/valkyries/shu_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/shu_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/shu_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/shu_skin_poster.jpg", Video = "ui/valkyries/detail/shu_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 }
};
