foreach (entry in [
	["tea", "$bv{chapter.thirteenth_bell.skill.tea.name}", "$bv{chapter.thirteenth_bell.skill.tea.description}"],
	["crest", "$bv{chapter.thirteenth_bell.skill.crest.name}", "$bv{chapter.thirteenth_bell.skill.crest.description}"],
	["promise", "$bv{chapter.thirteenth_bell.skill.promise.name}", "$bv{chapter.thirteenth_bell.skill.promise.description}"]
]) ::$bvvar{namespace}.ValkyrieSkillCatalog["thirteenth_bell_" + entry[0]] <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/passives/thirteenth_bell_memory_skill",
	Name = entry[1], Description = entry[2], Icon = "thirteenth_bell_" + entry[0],
	Kind = "passive", Lifetime = "persistent", Learnable = true,
	Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
};
