this.jeanne_iron_judgment_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/jeanne_bond_camp_base", {
	function getBondStage() { return 80; }
	function getLocationName() { return "$bv{location.jeanne_bond.80.name}"; }
	function getLocationDescription() { return "$bv{location.jeanne_bond.80.description}"; }
	function getWorldBrush() { return "world_orc_camp_01"; }
	function getTacticalTemplate() { return "tactical.orc_camp"; }
	function getAdditionalRadius() { return 4; }
	function shouldCutDownTrees() { return true; }
});
