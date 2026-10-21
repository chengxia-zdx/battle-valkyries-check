foreach (key in ["shu_thick_earth", "shu_evergreen", "shu_bountiful_harvest"])
 ::$bvvar{namespace}.ValkyrieSkillCatalog[key] <- {
  RuntimeScript = "$bvvar{privateFolder}/skills/passives/shu_passive_skill",
  Name = key == "shu_thick_earth" ? "$bv{skill.shu_thick_earth.name}" : (key == "shu_evergreen" ? "$bv{skill.shu_evergreen.name}" : "$bv{skill.shu_bountiful_harvest.name}"),
  Description = key == "shu_thick_earth" ? "$bv{skill.shu_thick_earth.description}" : (key == "shu_evergreen" ? "$bv{skill.shu_evergreen.description}" : "$bv{skill.shu_bountiful_harvest.description}"),
  Icon = key, Kind = "passive", Lifetime = "persistent", Learnable = false, Tags = [],
  Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { Owner = "shu" }
 };
::$bvvar{namespace}.ValkyrieSkillCatalog.shu_nurture <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/shu_active_skill", Name = "$bv{skill.shu_nurture.name}", Description = "$bv{skill.shu_nurture.description}",
 Icon = "shu_nurture", IconDisabled = "skills/$bvvar{iconPrefix}/shu_nurture_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
 Spec = { AP = 3, Fatigue = 8, Range = 3, Cooldown = 1, Heal = 25, HealPercent = 0.15, SeedRounds = 3 }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.shu_granary <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/shu_active_skill", Name = "$bv{skill.shu_granary.name}", Description = "$bv{skill.shu_granary.description}",
 Icon = "shu_granary", IconDisabled = "skills/$bvvar{iconPrefix}/shu_granary_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] },
 Spec = { AP = 4, Fatigue = 15, Range = 1, Cooldown = 3, Heal = 20, HealPercent = 0.10, Duration = 2 }
};
