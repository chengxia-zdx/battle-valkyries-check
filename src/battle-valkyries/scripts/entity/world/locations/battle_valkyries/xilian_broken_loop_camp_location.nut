this.xilian_broken_loop_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/xilian_bond_camp_base", {
	function getBondStage() { return 80; }
	function getLocationName() { return "$bv{location.xilian_broken_loop_camp.name}"; }
	function getLocationDescription() { return "$bv{location.xilian_broken_loop_camp.description}"; }
	function getWorldBrush() { return "world_orc_camp_01"; }
	function getTacticalTemplate() { return "tactical.orc_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 4; }
	function shouldCutDownTrees() { return true; }
});
