::$bvvar{namespace}.ValkyrieOrder.push("onigawara_rin");
::$bvvar{namespace}.Valkyries.onigawara_rin <- {
 ID = "onigawara_rin", LegendsPerkProfile = "melee_frontline",
 SkinID = "onigawara_rin_skin", SkinIDs = ["onigawara_rin_skin"], Name = "$bv{valkyrie.onigawara_rin.name}", Portrait = "ui/valkyries/onigawara_rin_card.png", WorldLeaderBrush = "world_bv_onigawara_rin_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/onigawara_rin_background", BackgroundID = "$bvvar{modId}.background.onigawara_rin",
 BackgroundName = "$bv{valkyrie.onigawara_rin.background.name}", BackgroundDescription = "$bv{valkyrie.onigawara_rin.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/onigawara_rin_trait", TraitID = "$bvvar{modId}.trait.onigawara_rin",
 TraitName = "$bv{valkyrie.onigawara_rin.trait.name}", TraitDescription = "$bv{valkyrie.onigawara_rin.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/onigawara_rin_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1, BaseAttributes = { Hitpoints = 120, Bravery = 80, Stamina = 150, Initiative = 110, MeleeSkill = 88, MeleeDefense = 26, RangedDefense = 14, RangedSkill = 55 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 2, Bravery = 2, Stamina = 3, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 1, Initiative = 2 },
 SkillLoadout = ["onigawara_rin_mastery","onigawara_rin_tactics","onigawara_rin_step","onigawara_rin_breath","onigawara_rin_heavy","onigawara_rin_guard"], Equipment = {}, Quests = [],
 HubDetails = { Passive = { Icon = "onigawara_rin_mastery", Name = "$bv{skill.onigawara_rin_mastery.name}", Description = "$bv{skill.onigawara_rin_mastery.description}\n$bv{skill.onigawara_rin_tactics.description}" },
 Active = { Icon = "onigawara_rin_breath", Name = "$bv{tenka.sword_arts}", Description = "$bv{skill.onigawara_rin_step.name}: $bv{skill.onigawara_rin_step.description}\n$bv{skill.onigawara_rin_breath.name}: $bv{skill.onigawara_rin_breath.description}\n$bv{skill.onigawara_rin_heavy.name}: $bv{skill.onigawara_rin_heavy.description}\n$bv{skill.onigawara_rin_guard.name}: $bv{skill.onigawara_rin_guard.description}\n$bv{skill.onigawara_rin_weapon.name}: $bv{skill.onigawara_rin_weapon.description}\n$bv{skill.onigawara_rin_weapon_guard.name}: $bv{skill.onigawara_rin_weapon_guard.description}" } }
};
::$bvvar{namespace}.ValkyrieTraitData.onigawara_rin <- { TraitTooltip = "$bv{valkyrie.onigawara_rin.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.onigawara_rin_skin <- { ID = "onigawara_rin_skin", Name = "$bv{skin.onigawara_rin_skin.name}", TabName = "$bv{skin.onigawara_rin_skin.name}", Description = "$bv{skin.onigawara_rin_skin.description}",
 Brush = "bust_bv_onigawara_rin_skin", DeathBrush = "bust_bv_onigawara_rin_skin_dead", WorldLeaderBrush = "world_bv_onigawara_rin_leader",
 Portrait = "ui/valkyries/onigawara_rin_card.png", Preview = "ui/valkyries/onigawara_rin_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/onigawara_rin_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/onigawara_rin_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/onigawara_rin_skin_poster.jpg", Video = "ui/valkyries/detail/onigawara_rin_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 } };

::$bvvar{namespace}.ValkyrieOrder.push("kikakujo_mary");
::$bvvar{namespace}.Valkyries.kikakujo_mary <- {
 ID = "kikakujo_mary", LegendsPerkProfile = "melee_mobile",
 SkinID = "kikakujo_mary_skin", SkinIDs = ["kikakujo_mary_skin"], Name = "$bv{valkyrie.kikakujo_mary.name}", Portrait = "ui/valkyries/kikakujo_mary_card.png", WorldLeaderBrush = "world_bv_kikakujo_mary_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/kikakujo_mary_background", BackgroundID = "$bvvar{modId}.background.kikakujo_mary",
 BackgroundName = "$bv{valkyrie.kikakujo_mary.background.name}", BackgroundDescription = "$bv{valkyrie.kikakujo_mary.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/kikakujo_mary_trait", TraitID = "$bvvar{modId}.trait.kikakujo_mary",
 TraitName = "$bv{valkyrie.kikakujo_mary.trait.name}", TraitDescription = "$bv{valkyrie.kikakujo_mary.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/kikakujo_mary_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1, BaseAttributes = { Hitpoints = 105, Bravery = 75, Stamina = 145, Initiative = 150, MeleeSkill = 92, MeleeDefense = 24, RangedDefense = 16, RangedSkill = 55 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 2, Bravery = 2, Stamina = 3, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 1, Initiative = 2 },
 SkillLoadout = ["kikakujo_mary_mastery","kikakujo_mary_tactics","kikakujo_mary_step","kikakujo_mary_nerve","kikakujo_mary_lunge","kikakujo_mary_guard"], Equipment = {}, Quests = [],
 HubDetails = { Passive = { Icon = "kikakujo_mary_mastery", Name = "$bv{skill.kikakujo_mary_mastery.name}", Description = "$bv{skill.kikakujo_mary_mastery.description}\n$bv{skill.kikakujo_mary_tactics.description}" },
 Active = { Icon = "kikakujo_mary_nerve", Name = "$bv{tenka.sword_arts}", Description = "$bv{skill.kikakujo_mary_step.name}: $bv{skill.kikakujo_mary_step.description}\n$bv{skill.kikakujo_mary_nerve.name}: $bv{skill.kikakujo_mary_nerve.description}\n$bv{skill.kikakujo_mary_lunge.name}: $bv{skill.kikakujo_mary_lunge.description}\n$bv{skill.kikakujo_mary_guard.name}: $bv{skill.kikakujo_mary_guard.description}\n$bv{skill.kikakujo_mary_weapon.name}: $bv{skill.kikakujo_mary_weapon.description}\n$bv{skill.kikakujo_mary_weapon_advance.name}: $bv{skill.kikakujo_mary_weapon_advance.description}" } }
};
::$bvvar{namespace}.ValkyrieTraitData.kikakujo_mary <- { TraitTooltip = "$bv{valkyrie.kikakujo_mary.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.kikakujo_mary_skin <- { ID = "kikakujo_mary_skin", Name = "$bv{skin.kikakujo_mary_skin.name}", TabName = "$bv{skin.kikakujo_mary_skin.name}", Description = "$bv{skin.kikakujo_mary_skin.description}",
 Brush = "bust_bv_kikakujo_mary_skin", DeathBrush = "bust_bv_kikakujo_mary_skin_dead", WorldLeaderBrush = "world_bv_kikakujo_mary_leader",
 Portrait = "ui/valkyries/kikakujo_mary_card.png", Preview = "ui/valkyries/kikakujo_mary_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/kikakujo_mary_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/kikakujo_mary_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/kikakujo_mary_skin_poster.jpg", Video = "ui/valkyries/detail/kikakujo_mary_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 } };

::$bvvar{namespace}.ValkyrieOrder.push("tamaba_satori");
::$bvvar{namespace}.Valkyries.tamaba_satori <- {
 ID = "tamaba_satori", LegendsPerkProfile = "melee_mobile",
 SkinID = "tamaba_satori_skin", SkinIDs = ["tamaba_satori_skin"], Name = "$bv{valkyrie.tamaba_satori.name}", Portrait = "ui/valkyries/tamaba_satori_card.png", WorldLeaderBrush = "world_bv_tamaba_satori_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/tamaba_satori_background", BackgroundID = "$bvvar{modId}.background.tamaba_satori",
 BackgroundName = "$bv{valkyrie.tamaba_satori.background.name}", BackgroundDescription = "$bv{valkyrie.tamaba_satori.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/tamaba_satori_trait", TraitID = "$bvvar{modId}.trait.tamaba_satori",
 TraitName = "$bv{valkyrie.tamaba_satori.trait.name}", TraitDescription = "$bv{valkyrie.tamaba_satori.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/tamaba_satori_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1, BaseAttributes = { Hitpoints = 110, Bravery = 80, Stamina = 145, Initiative = 125, MeleeSkill = 92, MeleeDefense = 26, RangedDefense = 14, RangedSkill = 55 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 2, Bravery = 2, Stamina = 3, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 1, Initiative = 2 },
 SkillLoadout = ["tamaba_satori_mastery","tamaba_satori_tactics","tamaba_satori_step","tamaba_satori_feint","tamaba_satori_chain","tamaba_satori_guard"], Equipment = {}, Quests = [],
 HubDetails = { Passive = { Icon = "tamaba_satori_mastery", Name = "$bv{skill.tamaba_satori_mastery.name}", Description = "$bv{skill.tamaba_satori_mastery.description}\n$bv{skill.tamaba_satori_tactics.description}" },
 Active = { Icon = "tamaba_satori_feint", Name = "$bv{tenka.sword_arts}", Description = "$bv{skill.tamaba_satori_step.name}: $bv{skill.tamaba_satori_step.description}\n$bv{skill.tamaba_satori_feint.name}: $bv{skill.tamaba_satori_feint.description}\n$bv{skill.tamaba_satori_chain.name}: $bv{skill.tamaba_satori_chain.description}\n$bv{skill.tamaba_satori_guard.name}: $bv{skill.tamaba_satori_guard.description}\n$bv{skill.tamaba_satori_weapon.name}: $bv{skill.tamaba_satori_weapon.description}\n$bv{skill.tamaba_satori_weapon_intercept.name}: $bv{skill.tamaba_satori_weapon_intercept.description}" } }
};
::$bvvar{namespace}.ValkyrieTraitData.tamaba_satori <- { TraitTooltip = "$bv{valkyrie.tamaba_satori.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.tamaba_satori_skin <- { ID = "tamaba_satori_skin", Name = "$bv{skin.tamaba_satori_skin.name}", TabName = "$bv{skin.tamaba_satori_skin.name}", Description = "$bv{skin.tamaba_satori_skin.description}",
 Brush = "bust_bv_tamaba_satori_skin", DeathBrush = "bust_bv_tamaba_satori_skin_dead", WorldLeaderBrush = "world_bv_tamaba_satori_leader",
 Portrait = "ui/valkyries/tamaba_satori_card.png", Preview = "ui/valkyries/tamaba_satori_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/tamaba_satori_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/tamaba_satori_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/tamaba_satori_skin_poster.jpg", Video = "ui/valkyries/detail/tamaba_satori_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 } };

::$bvvar{namespace}.ValkyrieOrder.push("hanasaka_warabi");
::$bvvar{namespace}.Valkyries.hanasaka_warabi <- {
 ID = "hanasaka_warabi", LegendsPerkProfile = "melee_mobile",
 SkinID = "hanasaka_warabi_skin", SkinIDs = ["hanasaka_warabi_skin"], Name = "$bv{valkyrie.hanasaka_warabi.name}", Portrait = "ui/valkyries/hanasaka_warabi_card.png", WorldLeaderBrush = "world_bv_hanasaka_warabi_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/hanasaka_warabi_background", BackgroundID = "$bvvar{modId}.background.hanasaka_warabi",
 BackgroundName = "$bv{valkyrie.hanasaka_warabi.background.name}", BackgroundDescription = "$bv{valkyrie.hanasaka_warabi.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/hanasaka_warabi_trait", TraitID = "$bvvar{modId}.trait.hanasaka_warabi",
 TraitName = "$bv{valkyrie.hanasaka_warabi.trait.name}", TraitDescription = "$bv{valkyrie.hanasaka_warabi.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/hanasaka_warabi_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1, BaseAttributes = { Hitpoints = 110, Bravery = 80, Stamina = 145, Initiative = 150, MeleeSkill = 90, MeleeDefense = 24, RangedDefense = 18, RangedSkill = 55 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 2, Bravery = 2, Stamina = 3, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 1, Initiative = 2 },
 SkillLoadout = ["hanasaka_warabi_mastery","hanasaka_warabi_tactics","hanasaka_warabi_step","hanasaka_warabi_leap","hanasaka_warabi_dance","hanasaka_warabi_bear"], Equipment = {}, Quests = [],
 HubDetails = { Passive = { Icon = "hanasaka_warabi_mastery", Name = "$bv{skill.hanasaka_warabi_mastery.name}", Description = "$bv{skill.hanasaka_warabi_mastery.description}\n$bv{skill.hanasaka_warabi_tactics.description}" },
 Active = { Icon = "hanasaka_warabi_leap", Name = "$bv{tenka.sword_arts}", Description = "$bv{skill.hanasaka_warabi_step.name}: $bv{skill.hanasaka_warabi_step.description}\n$bv{skill.hanasaka_warabi_leap.name}: $bv{skill.hanasaka_warabi_leap.description}\n$bv{skill.hanasaka_warabi_dance.name}: $bv{skill.hanasaka_warabi_dance.description}\n$bv{skill.hanasaka_warabi_bear.name}: $bv{skill.hanasaka_warabi_bear.description}\n$bv{skill.hanasaka_warabi_weapon.name}: $bv{skill.hanasaka_warabi_weapon.description}\n$bv{skill.hanasaka_warabi_weapon_step.name}: $bv{skill.hanasaka_warabi_weapon_step.description}" } }
};
::$bvvar{namespace}.ValkyrieTraitData.hanasaka_warabi <- { TraitTooltip = "$bv{valkyrie.hanasaka_warabi.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.hanasaka_warabi_skin <- { ID = "hanasaka_warabi_skin", Name = "$bv{skin.hanasaka_warabi_skin.name}", TabName = "$bv{skin.hanasaka_warabi_skin.name}", Description = "$bv{skin.hanasaka_warabi_skin.description}",
 Brush = "bust_bv_hanasaka_warabi_skin", DeathBrush = "bust_bv_hanasaka_warabi_skin_dead", WorldLeaderBrush = "world_bv_hanasaka_warabi_leader",
 Portrait = "ui/valkyries/hanasaka_warabi_card.png", Preview = "ui/valkyries/hanasaka_warabi_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/hanasaka_warabi_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/hanasaka_warabi_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/hanasaka_warabi_skin_poster.jpg", Video = "ui/valkyries/detail/hanasaka_warabi_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 } };

::$bvvar{namespace}.ValkyrieOrder.push("inaba_tsukuyo");
::$bvvar{namespace}.Valkyries.inaba_tsukuyo <- {
 ID = "inaba_tsukuyo", LegendsPerkProfile = "melee_mobile",
 SkinID = "inaba_tsukuyo_skin", SkinIDs = ["inaba_tsukuyo_skin"], Name = "$bv{valkyrie.inaba_tsukuyo.name}", Portrait = "ui/valkyries/inaba_tsukuyo_card.png", WorldLeaderBrush = "world_bv_inaba_tsukuyo_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/inaba_tsukuyo_background", BackgroundID = "$bvvar{modId}.background.inaba_tsukuyo",
 BackgroundName = "$bv{valkyrie.inaba_tsukuyo.background.name}", BackgroundDescription = "$bv{valkyrie.inaba_tsukuyo.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/inaba_tsukuyo_trait", TraitID = "$bvvar{modId}.trait.inaba_tsukuyo",
 TraitName = "$bv{valkyrie.inaba_tsukuyo.trait.name}", TraitDescription = "$bv{valkyrie.inaba_tsukuyo.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/inaba_tsukuyo_trait_icon.png",
 Level = 5, XP = 2000, DailyWage = 1, BaseAttributes = { Hitpoints = 110, Bravery = 85, Stamina = 145, Initiative = 155, MeleeSkill = 94, MeleeDefense = 30, RangedDefense = 14, RangedSkill = 55 },
 AttributeAdjustments = { Hitpoints = [0,0], Bravery = [0,0], Stamina = [0,0], MeleeSkill = [0,0], RangedSkill = [0,0], MeleeDefense = [0,0], RangedDefense = [0,0], Initiative = [0,0] },
 Talents = { Hitpoints = 2, Bravery = 2, Stamina = 3, MeleeSkill = 3, RangedSkill = 0, MeleeDefense = 3, RangedDefense = 1, Initiative = 2 },
 SkillLoadout = ["inaba_tsukuyo_mastery","inaba_tsukuyo_tactics","inaba_tsukuyo_step","inaba_tsukuyo_dash","inaba_tsukuyo_iaido","inaba_tsukuyo_guard"], Equipment = {}, Quests = [],
 HubDetails = { Passive = { Icon = "inaba_tsukuyo_mastery", Name = "$bv{skill.inaba_tsukuyo_mastery.name}", Description = "$bv{skill.inaba_tsukuyo_mastery.description}\n$bv{skill.inaba_tsukuyo_tactics.description}" },
 Active = { Icon = "inaba_tsukuyo_dash", Name = "$bv{tenka.sword_arts}", Description = "$bv{skill.inaba_tsukuyo_step.name}: $bv{skill.inaba_tsukuyo_step.description}\n$bv{skill.inaba_tsukuyo_dash.name}: $bv{skill.inaba_tsukuyo_dash.description}\n$bv{skill.inaba_tsukuyo_iaido.name}: $bv{skill.inaba_tsukuyo_iaido.description}\n$bv{skill.inaba_tsukuyo_guard.name}: $bv{skill.inaba_tsukuyo_guard.description}\n$bv{skill.inaba_tsukuyo_weapon.name}: $bv{skill.inaba_tsukuyo_weapon.description}\n$bv{skill.inaba_tsukuyo_weapon_flash.name}: $bv{skill.inaba_tsukuyo_weapon_flash.description}" } }
};
::$bvvar{namespace}.ValkyrieTraitData.inaba_tsukuyo <- { TraitTooltip = "$bv{valkyrie.inaba_tsukuyo.trait.tooltip}", TraitBonuses = {} };
::$bvvar{namespace}.Skins.inaba_tsukuyo_skin <- { ID = "inaba_tsukuyo_skin", Name = "$bv{skin.inaba_tsukuyo_skin.name}", TabName = "$bv{skin.inaba_tsukuyo_skin.name}", Description = "$bv{skin.inaba_tsukuyo_skin.description}",
 Brush = "bust_bv_inaba_tsukuyo_skin", DeathBrush = "bust_bv_inaba_tsukuyo_skin_dead", WorldLeaderBrush = "world_bv_inaba_tsukuyo_leader",
 Portrait = "ui/valkyries/inaba_tsukuyo_card.png", Preview = "ui/valkyries/inaba_tsukuyo_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/inaba_tsukuyo_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/inaba_tsukuyo_skin_icon.png",
 DetailMedia = { Poster = "ui/valkyries/detail/inaba_tsukuyo_skin_poster.jpg", Video = "ui/valkyries/detail/inaba_tsukuyo_skin_idle.webm", PositionX = 0.30, PositionY = 0.25 } };
