this.liuying_complete_combustion_echo_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/liuying_bond_camp_base", {
	function getBondStage() { return 100; }
	function getLocationName() { return "$bv{location.liuying_complete_combustion_echo_camp.name}"; }
	function getLocationDescription() { return "$bv{location.liuying_complete_combustion_echo_camp.description}"; }
	function getWorldBrush() { return "world_orc_camp_01"; }
	function getTacticalTemplate() { return "tactical.orc_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 4; }
	function shouldCutDownTrees() { return true; }
});
