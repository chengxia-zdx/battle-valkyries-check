this.memory_ranged_skill_keepsake_item <- this.inherit("scripts/items/misc/battle_valkyries/memory_keepsake_item", {
	m = {},
	function create()
	{
		this.memory_keepsake_item.create();
		this.configureMemoryKeepsake("ranged_skill_keepsake", "$bv{item.memory_ranged_skill.name}", "$bv{item.memory_ranged_skill.description}", "$bv{item.memory_ranged_skill.effect}", "stat", "RangedSkill", 2, "$bvvar{iconPrefix}/memory_ranged_skill_keepsake.png");
	}
});
