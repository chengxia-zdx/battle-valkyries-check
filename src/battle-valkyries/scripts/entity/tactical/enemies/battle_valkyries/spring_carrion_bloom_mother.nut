this.spring_carrion_bloom_mother <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/spring_root_beast", {
	function create() { this.spring_root_beast.create(); this.m.SpringForm = "carrion_bloom_mother"; this.m.Name = "$bv{enemy.spring.carrion_bloom_mother.name}"; this.m.XP = 1600; }
});
