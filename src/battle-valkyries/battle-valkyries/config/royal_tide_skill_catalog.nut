foreach (entry in [
	["cerydra", "$bv{skill.royal_tide_cerydra_growth.name}", "$bv{skill.royal_tide_cerydra_growth.description}"],
	["hysilens", "$bv{skill.royal_tide_hysilens_growth.name}", "$bv{skill.royal_tide_hysilens_growth.description}"]
]) ::$bvvar{namespace}.ValkyrieSkillCatalog["royal_tide_" + entry[0] + "_growth"] <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/passives/royal_tide_memory_skill",
	Name = entry[1], Description = entry[2], Icon = "ui/traits/$bvvar{iconPrefix}/royal_banner_returning_tide_" + entry[0] + "_growth.png",
	IconDisabled = "ui/traits/$bvvar{iconPrefix}/royal_banner_returning_tide_" + entry[0] + "_growth.png",
	Kind = "passive", Lifetime = "persistent", Learnable = true,
	Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
};
::$bvvar{namespace}.ValkyrieSkillCatalog.royal_tide_slash <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/actives/royal_tide_slash_skill",
	Name = "$bv{skill.royal_tide_slash.name}", Description = "$bv{skill.royal_tide_slash.description}", Icon = "returning_tide_slash",
	Kind = "active", Lifetime = "transient", Learnable = false,
	Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
};
