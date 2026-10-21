this.silent_city_echo_lord <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/silent_city_resonance_beast", {
	function create() { this.silent_city_resonance_beast.create(); this.m.IsEchoLord = true; this.m.Name = "$bv{enemy.silent_city.lord.name}"; this.m.XP = 2400; }
});
