this.spring_root_bound_guard <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/spring_root_beast", {
	function create() { this.spring_root_beast.create(); this.m.SpringForm = "root_bound_guard"; this.m.Name = "$bv{enemy.spring.root_bound_guard.name}"; }
});
