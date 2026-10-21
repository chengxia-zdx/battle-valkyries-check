this.xilian_echo_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/xilian_bond_camp_base", {
	function getBondStage() { return 100; }
	function getLocationName() { return "$bv{location.xilian_echo_camp.name}"; }
	function getLocationDescription() { return "$bv{location.xilian_echo_camp.description}"; }
	function getWorldBrush() { return "world_vampire_coven"; }
	function getTacticalTemplate() { return "tactical.ruins"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Walls; }
	function getAdditionalRadius() { return 4; }
	function shouldCutDownTrees() { return false; }
});
