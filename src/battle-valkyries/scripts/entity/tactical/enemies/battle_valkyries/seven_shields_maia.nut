this.seven_shields_maia <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "maia"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.maia.name}"; }
});
