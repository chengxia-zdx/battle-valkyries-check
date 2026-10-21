foreach (entry in [
	["spring_castorice_growth", "$bv{skill.spring_castorice_growth.name}", "$bv{skill.spring_castorice_growth.description}", "spring_passes_here_castorice_growth"],
	["spring_fengjin_growth", "$bv{skill.spring_fengjin_growth.name}", "$bv{skill.spring_fengjin_growth.description}", "spring_passes_here_fengjin_growth"]
])
	::$bvvar{namespace}.ValkyrieSkillCatalog[entry[0]] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/spring_memory_skill",
		Name = entry[1], Description = entry[2], Icon = "ui/traits/$bvvar{iconPrefix}/" + entry[3] + ".png",
		IconDisabled = "ui/traits/$bvvar{iconPrefix}/" + entry[3] + ".png",
		Kind = "passive", Lifetime = "persistent", Learnable = true,
		Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
	};
::$bvvar{namespace}.ValkyrieSkillCatalog.spring_liuchun_strike <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/actives/spring_liuchun_strike_skill",
	Name = "$bv{skill.spring_liuchun_strike.name}", Description = "$bv{skill.spring_liuchun_strike.description}", Icon = "liuchun_flow",
	Kind = "active", Lifetime = "transient", Learnable = false,
	Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
};
