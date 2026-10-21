this.jeanne_broken_banner_altar_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/jeanne_bond_camp_base", {
	function getBondStage() { return 60; }
	function getLocationName() { return "$bv{location.jeanne_bond.60.name}"; }
	function getLocationDescription() { return "$bv{location.jeanne_bond.60.description}"; }
	function getWorldBrush() { return "world_vampire_coven"; }
	function getTacticalTemplate() { return "tactical.ruins"; }
	function getAdditionalRadius() { return 3; }
});
