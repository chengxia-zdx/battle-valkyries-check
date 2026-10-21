local lilyCoreRequirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] };

::$bvvar{namespace}.ValkyrieSkillCatalog.lily_blight_controller <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/passives/lily_blight_controller_skill", Name = "$bv{skill.lily_blight_controller.name}", Description = "$bv{skill.lily_blight_controller.description}", Icon = "lily_blight_controller",
	Kind = "passive", Lifetime = "persistent", Learnable = false, Tags = [], Requirements = clone lilyCoreRequirements, Spec = { MaxBlight = 6, BlightedTurns = 3 }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.lily_prayer <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/actives/lily_prayer_skill", Name = "$bv{skill.lily_prayer.name}", Description = "$bv{skill.lily_prayer.description}", Icon = "lily_prayer",
	Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [], Requirements = clone lilyCoreRequirements, Spec = { ActionPointCost = 4, FatigueCost = 20, Radius = 2, Uses = 3 }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.lily_accept_blight <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/actives/lily_accept_blight_skill", Name = "$bv{skill.lily_accept_blight.name}", Description = "$bv{skill.lily_accept_blight.description}", Icon = "lily_accept_blight",
	Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [], Requirements = clone lilyCoreRequirements, Spec = {}
};
::$bvvar{namespace}.ValkyrieSkillCatalog.lily_final_purification <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/actives/lily_final_purification_skill", Name = "$bv{skill.lily_final_purification.name}", Description = "$bv{skill.lily_final_purification.description}", Icon = "lily_final_purification",
	Kind = "active", Lifetime = "persistent", Learnable = false, Tags = [], Requirements = clone lilyCoreRequirements, Spec = { Radius = 2 }
};
::$bvvar{namespace}.ValkyrieSkillCatalog.lily_ulv_step <- {
	RuntimeScript = "$bvvar{privateFolder}/skills/actives/lily_ulv_step_skill", Name = "$bv{skill.lily_ulv_step.name}", Description = "$bv{skill.lily_ulv_step.description}", Icon = "lily_spirit_mad_knight_ulv",
	Kind = "active", Lifetime = "transient", Learnable = false, Tags = ["lily_spirit", "utility"], Requirements = clone lilyCoreRequirements, Spec = {}
};

foreach (spirit in ::$bvvar{namespace}.LilySpirits)
{
	local key = "lily_spirit_" + spirit.Key;
	::$bvvar{namespace}.ValkyrieSkillCatalog[key] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/actives/lily_spirit_skill",
		Name = spirit.Name,
		Description = spirit.Description,
		Icon = key,
		Kind = "active",
		Lifetime = "transient",
		Learnable = false,
		Tags = ["lily_spirit", spirit.Type],
		Requirements = clone lilyCoreRequirements,
		Spec = clone spirit
	};
}
