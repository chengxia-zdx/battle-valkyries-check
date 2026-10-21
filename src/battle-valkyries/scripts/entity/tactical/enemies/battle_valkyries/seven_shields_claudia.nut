this.seven_shields_claudia <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "claudia"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.claudia.name}"; }
});
