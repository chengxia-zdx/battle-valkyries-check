::$bvvar{namespace}.ValkyrieOrder.push("renne");
::$bvvar{namespace}.Valkyries.renne <- {
 ID = "renne", LegendsPerkProfile = "melee_mobile", SkinID = "renne_skin", SkinIDs = ["renne_skin"],
 Name = "$bv{valkyrie.renne.name}", Portrait = "ui/valkyries/renne_card.png", WorldLeaderBrush = "world_bv_renne_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/renne_background", BackgroundID = "$bvvar{modId}.background.renne",
 BackgroundName = "$bv{valkyrie.renne.background.name}", BackgroundDescription = "$bv{valkyrie.renne.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/renne_trait", TraitID = "$bvvar{modId}.trait.renne",
 TraitName = "$bv{valkyrie.renne.trait.name}", TraitDescription = "$bv{valkyrie.renne.trait.description}",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/renne_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1,
 BaseAttributes = { Hitpoints = 75, Bravery = 80, Stamina = 125, MeleeSkill = 80, RangedSkill = 75, MeleeDefense = 15, RangedDefense = 10, Initiative = 115 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 1, Bravery = 2, Stamina = 3, MeleeSkill = 3, RangedSkill = 2, MeleeDefense = 2, RangedDefense = 1, Initiative = 2 },
 SkillLoadout = ["renne_genius_executor", "renne_annihilation_mark", "renne_calamity_projection", "renne_death_scythe", "renne_shadow_step", "renne_calamity_waltz", "renne_annihilation_angel"],
 Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon = "renne_genius_executor", Name = "$bv{renne.passives}", Description = "$bv{skill.renne_genius_executor.description}\n$bv{skill.renne_annihilation_mark.description}" },
  Active = { Icon = "renne_calamity_projection", Name = "$bv{renne.actives}", Description = "$bv{skill.renne_calamity_projection.description}\n$bv{skill.renne_annihilation_angel.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.renne <- { TraitTooltip = "$bv{valkyrie.renne.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.renne_skin <- {
 ID = "renne_skin", Name = "$bv{skin.renne_skin.name}", TabName = "$bv{skin.renne_skin.name}", Description = "$bv{skin.renne_skin.description}",
 Brush = "bust_bv_renne_skin", DeathBrush = "bust_bv_renne_skin_dead", WorldLeaderBrush = "world_bv_renne_leader",
 Portrait = "ui/valkyries/renne_card.png", Preview = "ui/valkyries/renne_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/renne_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/renne_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/renne_skin_poster.jpg", Video = "ui/valkyries/detail/renne_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 }
};

::$bvvar{namespace}.ValkyrieOrder.push("alisa");
::$bvvar{namespace}.Valkyries.alisa <- {
 ID = "alisa", LegendsPerkProfile = "ranged_support", SkinID = "alisa_skin", SkinIDs = ["alisa_skin"],
 Name = "$bv{valkyrie.alisa.name}", Portrait = "ui/valkyries/alisa_card.png", WorldLeaderBrush = "world_bv_alisa_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/alisa_background", BackgroundID = "$bvvar{modId}.background.alisa",
 BackgroundName = "$bv{valkyrie.alisa.background.name}", BackgroundDescription = "$bv{valkyrie.alisa.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/alisa_trait", TraitID = "$bvvar{modId}.trait.alisa",
 TraitName = "$bv{valkyrie.alisa.trait.name}", TraitDescription = "$bv{valkyrie.alisa.trait.description}",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/alisa_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1,
 BaseAttributes = { Hitpoints = 70, Bravery = 70, Stamina = 125, MeleeSkill = 45, RangedSkill = 80, MeleeDefense = 8, RangedDefense = 18, Initiative = 110 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 1, Bravery = 2, Stamina = 3, MeleeSkill = 0, RangedSkill = 3, MeleeDefense = 1, RangedDefense = 2, Initiative = 2 },
 SkillLoadout = ["alisa_orbal_bow_expert", "alisa_radiant_resonance", "alisa_flame_arrow", "alisa_molten_arrow_rain", "alisa_holy_blessing", "alisa_heavens_gift", "alisa_celestial_blazing_wings"],
 Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon = "alisa_orbal_bow_expert", Name = "$bv{alisa.passives}", Description = "$bv{skill.alisa_orbal_bow_expert.description}\n$bv{skill.alisa_radiant_resonance.description}" },
  Active = { Icon = "alisa_flame_arrow", Name = "$bv{alisa.actives}", Description = "$bv{skill.alisa_flame_arrow.description}\n$bv{skill.alisa_celestial_blazing_wings.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.alisa <- { TraitTooltip = "$bv{valkyrie.alisa.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.alisa_skin <- {
 ID = "alisa_skin", Name = "$bv{skin.alisa_skin.name}", TabName = "$bv{skin.alisa_skin.name}", Description = "$bv{skin.alisa_skin.description}",
 Brush = "bust_bv_alisa_skin", DeathBrush = "bust_bv_alisa_skin_dead", WorldLeaderBrush = "world_bv_alisa_leader",
 Portrait = "ui/valkyries/alisa_card.png", Preview = "ui/valkyries/alisa_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/alisa_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/alisa_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/alisa_skin_poster.jpg", Video = "ui/valkyries/detail/alisa_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 }
};
