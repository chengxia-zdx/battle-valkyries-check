this.memory_melee_skill_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("melee_skill_keepsake", "$bv{item.memory_melee_skill.name}", "$bv{item.memory_melee_skill.description}", "$bv{item.memory_melee_skill.effect}", "stat", "MeleeSkill", 2, "$bvvar{iconPrefix}/memory_melee_skill_keepsake.png");
	}
});
