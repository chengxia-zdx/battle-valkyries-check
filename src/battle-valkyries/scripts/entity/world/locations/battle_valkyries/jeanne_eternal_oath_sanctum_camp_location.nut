this.jeanne_eternal_oath_sanctum_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/jeanne_bond_camp_base", {
	function getBondStage() { return 100; }
	function getLocationName() { return "$bv{location.jeanne_bond.100.name}"; }
	function getLocationDescription() { return "$bv{location.jeanne_bond.100.description}"; }
	function getWorldBrush() { return "world_nomad_camp_03"; }
	function getTacticalTemplate() { return "tactical.desert_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Walls; }
	function getAdditionalRadius() { return 4; }
});
