::$bvvar{namespace}.ValkyrieSkillCatalog.ryza_core_crystal <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/passives/ryza_core_crystal", Name = "$bv{skill.ryza_core_crystal.name}", Description = "$bv{skill.ryza_core_crystal.description}",
 Icon = "ryza_core_crystal", IconDisabled = "skills/$bvvar{iconPrefix}/ryza_core_crystal_sw.png", Kind = "passive", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {  }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.ryza_pulse <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/ryza_alchemy_skill", Name = "$bv{skill.ryza_pulse.name}", Description = "$bv{skill.ryza_pulse.description}",
 Icon = "ryza_pulse", IconDisabled = "skills/$bvvar{iconPrefix}/ryza_pulse_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { AP = 4, Fatigue = 10, Min = 1, Max = 3, Radius = 0, CC = 0, DamageMin = 30, DamageMax = 45, Armor = 0.8, Pierce = 0.2, Cooldown = 0, Mode = "pulse" }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.ryza_flame <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/ryza_alchemy_skill", Name = "$bv{skill.ryza_flame.name}", Description = "$bv{skill.ryza_flame.description}",
 Icon = "ryza_flame", IconDisabled = "skills/$bvvar{iconPrefix}/ryza_flame_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { AP = 4, Fatigue = 18, Min = 2, Max = 4, Radius = 1, CC = 2, DamageMin = 45, DamageMax = 65, Armor = 1.1, Pierce = 0.2, Cooldown = 0, Mode = "flame" }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.ryza_frost <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/ryza_alchemy_skill", Name = "$bv{skill.ryza_frost.name}", Description = "$bv{skill.ryza_frost.description}",
 Icon = "ryza_frost", IconDisabled = "skills/$bvvar{iconPrefix}/ryza_frost_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { AP = 4, Fatigue = 15, Min = 1, Max = 4, Radius = 0, CC = 2, DamageMin = 40, DamageMax = 55, Armor = 0.8, Pierce = 0.2, Cooldown = 2, Mode = "frost" }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.ryza_elixir <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/ryza_alchemy_skill", Name = "$bv{skill.ryza_elixir.name}", Description = "$bv{skill.ryza_elixir.description}",
 Icon = "ryza_elixir", IconDisabled = "skills/$bvvar{iconPrefix}/ryza_elixir_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { AP = 4, Fatigue = 15, Min = 0, Max = 3, Radius = 0, CC = 2, DamageMin = 0, DamageMax = 0, Armor = 0.0, Pierce = 0.0, Cooldown = 2, Mode = "elixir" }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.ryza_core_drive <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/ryza_alchemy_skill", Name = "$bv{skill.ryza_core_drive.name}", Description = "$bv{skill.ryza_core_drive.description}",
 Icon = "ryza_core_drive", IconDisabled = "skills/$bvvar{iconPrefix}/ryza_core_drive_sw.png", Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [],
 Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { AP = 7, Fatigue = 30, Min = 2, Max = 4, Radius = 1, CC = 6, DamageMin = 90, DamageMax = 120, Armor = 1.5, Pierce = 0.3, Cooldown = 3, Mode = "core_drive" }
};
