this.seven_shields_kaguya <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "kaguya"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.kaguya.name}"; }
});
