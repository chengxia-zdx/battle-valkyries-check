foreach (key in ["painted_harbor_human_stroke", "painted_harbor_homeward_prayer"])
{
	::$bvvar{namespace}.ValkyrieSkillCatalog[key] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/painted_harbor_memory_skill",
		Name = key == "painted_harbor_human_stroke" ? "$bv{skill.painted_harbor_human_stroke.name}" : "$bv{skill.painted_harbor_homeward_prayer.name}",
		Description = key == "painted_harbor_human_stroke" ? "$bv{skill.painted_harbor_human_stroke.description}" : "$bv{skill.painted_harbor_homeward_prayer.description}",
		Icon = key, Kind = "passive", Lifetime = "persistent", Learnable = true, Tags = [],
		Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
	};
}
