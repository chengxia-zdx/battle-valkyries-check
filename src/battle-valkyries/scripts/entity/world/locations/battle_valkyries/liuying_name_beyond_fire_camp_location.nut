this.liuying_name_beyond_fire_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/liuying_bond_camp_base", {
	function getBondStage() { return 80; }
	function getLocationName() { return "$bv{location.liuying_name_beyond_fire_camp.name}"; }
	function getLocationDescription() { return "$bv{location.liuying_name_beyond_fire_camp.description}"; }
	function getWorldBrush() { return "world_nomad_camp_03"; }
	function getTacticalTemplate() { return "tactical.desert_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 3; }
	function shouldCutDownTrees() { return false; }
});
