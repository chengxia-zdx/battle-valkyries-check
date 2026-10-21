this.seven_shields_luu_luu <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/seven_shields_commander", {
	function create() { this.m.SevenShieldsRole = "luu_luu"; this.seven_shields_commander.create(); this.m.Name = "$bv{valkyrie.luu_luu.name}"; }
});
