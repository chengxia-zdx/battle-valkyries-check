this.seven_shields_prim <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "prim"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.prim.name}"; }
});
