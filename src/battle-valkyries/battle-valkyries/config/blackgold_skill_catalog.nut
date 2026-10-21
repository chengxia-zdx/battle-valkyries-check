foreach (entry in [
	["blackgold_leave_an_exit", "silver_wolf", ["silver_wolf_attack_vulnerability", "silver_wolf_defense_vulnerability", "silver_wolf_speed_vulnerability"], "$bv{chapter.blackgold.growth.silver_wolf.name}", "$bv{chapter.blackgold.growth.silver_wolf.description}"],
	["blackgold_listen_this_time", "kafka", ["kafka_your_turn"], "$bv{chapter.blackgold.growth.kafka.name}", "$bv{chapter.blackgold.growth.kafka.description}"]
])
	::$bvvar{namespace}.ValkyrieSkillCatalog[entry[0]] <- {
		RuntimeScript = "$bvvar{privateFolder}/skills/passives/blackgold_memory_skill",
		Name = entry[3], Description = entry[4], Icon = "ui/traits/$bvvar{iconPrefix}/blackgold_thirteenth_lot_" + entry[1] + "_growth.png",
		IconDisabled = "ui/traits/$bvvar{iconPrefix}/blackgold_thirteenth_lot_" + entry[1] + "_growth.png",
		Kind = "passive", Lifetime = "persistent", Learnable = true,
		Tags = [], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = { Actor = entry[1], Triggers = entry[2] }
	};
