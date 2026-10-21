foreach (entry in [
	["silent_city_robin_breath", "$bv{skill.silent_city_robin_breath.name}", "$bv{skill.silent_city_robin_breath.description}", "robin_winged_sunny_song"],
	["silent_city_sakiko_entry", "$bv{skill.silent_city_sakiko_entry.name}", "$bv{skill.silent_city_sakiko_entry.description}", "togawa_sakiko_full_moon_dance"]
])
	::$bvvar{namespace}.ValkyrieSkillCatalog[entry[0]] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/silent_city_encore_memory_skill",
		Name = entry[1], Description = entry[2], Icon = entry[3], Kind = "passive", Lifetime = "persistent", Learnable = true,
		Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
	};
