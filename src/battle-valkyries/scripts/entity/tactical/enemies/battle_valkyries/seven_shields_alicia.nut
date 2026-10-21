this.seven_shields_alicia <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "alicia"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.alicia.name}"; }
});
