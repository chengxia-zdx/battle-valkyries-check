this.seven_shields_celestine <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "celestine"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.celestine.name}"; }
});
