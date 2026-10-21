this.xilian_campfire_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/xilian_bond_camp_base", {
	function getBondStage() { return 40; }
	function getLocationName() { return "$bv{location.xilian_campfire_camp.name}"; }
	function getLocationDescription() { return "$bv{location.xilian_campfire_camp.description}"; }
	function getWorldBrush() { return "world_goblin_camp_01"; }
	function getTacticalTemplate() { return "tactical.goblin_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Palisade; }
	function getAdditionalRadius() { return 3; }
	function shouldCutDownTrees() { return true; }
});
