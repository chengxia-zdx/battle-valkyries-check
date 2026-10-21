local requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] };
foreach (entry in [
	{ Key = "qingming_casket_strike", Kind = "active", Folder = "actives", Lifetime = "transient", Learnable = false, Icon = "qingming_casket" },
	{ Key = "qingming_unsheathe", Kind = "active", Folder = "actives", Lifetime = "transient", Learnable = false, Icon = "qingming_sword" },
	{ Key = "yixuan_yunki_oath", Kind = "passive", Folder = "passives", Lifetime = "persistent", Learnable = true, Icon = "yixuan_sanctuary" },
	{ Key = "yixuan_sanctuary", Kind = "active", Folder = "actives", Lifetime = "persistent", Learnable = true, Icon = "yixuan_sanctuary" }
])
{
	::$bvvar{namespace}.ValkyrieSkillCatalog[entry.Key] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/" + entry.Folder + "/" + entry.Key + "_skill",
		Name = "", Description = "", Icon = entry.Icon, Kind = entry.Kind, Lifetime = entry.Lifetime,
		Learnable = entry.Learnable, Tags = [], Requirements = clone requirements, Spec = {}
	};
}
local catalog = ::$bvvar{namespace}.ValkyrieSkillCatalog;
catalog.qingming_casket_strike.Name = "$bv{skill.qingming_casket_strike.name}";
catalog.qingming_casket_strike.Description = "$bv{skill.qingming_casket_strike.description}";
catalog.qingming_unsheathe.Name = "$bv{skill.qingming_unsheathe.name}";
catalog.qingming_unsheathe.Description = "$bv{skill.qingming_unsheathe.description}";
catalog.yixuan_yunki_oath.Name = "$bv{skill.yixuan_yunki_oath.name}";
catalog.yixuan_yunki_oath.Description = "$bv{skill.yixuan_yunki_oath.description}";
catalog.yixuan_sanctuary.Name = "$bv{skill.yixuan_sanctuary.name}";
catalog.yixuan_sanctuary.Description = "$bv{skill.yixuan_sanctuary.description}";
