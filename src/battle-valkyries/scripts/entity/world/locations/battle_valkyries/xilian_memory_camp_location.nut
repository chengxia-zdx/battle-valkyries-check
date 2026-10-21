this.xilian_memory_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/xilian_bond_camp_base", {
	function getBondStage() { return 60; }
	function getLocationName() { return "$bv{location.xilian_memory_camp.name}"; }
	function getLocationDescription() { return "$bv{location.xilian_memory_camp.description}"; }
	function getWorldBrush() { return "world_vampire_coven"; }
	function getTacticalTemplate() { return "tactical.ruins"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 2; }
	function shouldCutDownTrees() { return false; }
});
