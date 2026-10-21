foreach (entry in [
	["grey_falcon_return_route", "$bv{skill.grey_falcon_return_route.name}", "$bv{skill.grey_falcon_return_route.description}", "enterprise_sortie_points"],
	["grey_falcon_cover_reload", "$bv{skill.grey_falcon_cover_reload.name}", "$bv{skill.grey_falcon_cover_reload.description}", "m4a1_tactical_reload"]
])
	::$bvvar{namespace}.ValkyrieSkillCatalog[entry[0]] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/grey_falcon_memory_skill",
		Name = entry[1], Description = entry[2], Icon = entry[3], Kind = "passive", Lifetime = "persistent", Learnable = true,
		Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
	};
