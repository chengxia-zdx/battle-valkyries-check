::$bvvar{namespace}.ValkyrieOrder.push("tio");
::$bvvar{namespace}.Valkyries.tio <- {
 ID = "tio", LegendsPerkProfile = "ranged_support", SkinID = "tio_skin", SkinIDs = ["tio_skin"],
 Name = "$bv{valkyrie.tio.name}", Portrait = "ui/valkyries/tio_card.png", WorldLeaderBrush = "world_bv_tio_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/tio_background", BackgroundID = "$bvvar{modId}.background.tio",
 BackgroundName = "$bv{valkyrie.tio.background.name}", BackgroundDescription = "$bv{valkyrie.tio.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/tio_trait", TraitID = "$bvvar{modId}.trait.tio",
 TraitName = "$bv{valkyrie.tio.trait.name}", TraitDescription = "$bv{valkyrie.tio.trait.description}",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/tio_trait_icon.png",
 ChapterRecruitOnly = true, ChapterRecruitHint = "$bv{orbment.recruit_hint}", Level = 1, XP = 0, DailyWage = 1,
 BaseAttributes = { Hitpoints = 60, Bravery = 65, Stamina = 110, MeleeSkill = 45, RangedSkill = 75, MeleeDefense = 5, RangedDefense = 15, Initiative = 100 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 1, Bravery = 2, Stamina = 3, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 0, RangedDefense = 2, Initiative = 1 },
 SkillLoadout = ["tio_aion_sense", "tio_septium_attunement", "tio_orbal_pulse", "tio_analyzer", "tio_beam_zanber", "tio_absolute_zero", "tio_ether_buster", "tio_zero_field"],
 Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon = "tio_aion_sense", Name = "$bv{tio.passives}", Description = "$bv{skill.tio_aion_sense.description}" },
  Active = { Icon = "tio_orbal_pulse", Name = "$bv{tio.actives}", Description = "$bv{skill.tio_orbal_pulse.name}: $bv{skill.tio_orbal_pulse.description}\n$bv{skill.tio_zero_field.name}: $bv{skill.tio_zero_field.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.tio <- { TraitTooltip = "$bv{valkyrie.tio.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.tio_skin <- {
 ID = "tio_skin", Name = "$bv{skin.tio_skin.name}", TabName = "$bv{skin.tio_skin.name}", Description = "$bv{skin.tio_skin.description}",
 Brush = "bust_bv_tio_skin", DeathBrush = "bust_bv_tio_skin_dead", WorldLeaderBrush = "world_bv_tio_leader",
 Portrait = "ui/valkyries/tio_card.png", Preview = "ui/valkyries/tio_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/tio_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/tio_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/tio_skin_poster.jpg", Video = "ui/valkyries/detail/tio_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 }
};
