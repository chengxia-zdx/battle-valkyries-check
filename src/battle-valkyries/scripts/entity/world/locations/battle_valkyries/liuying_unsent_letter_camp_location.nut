this.liuying_unsent_letter_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/liuying_bond_camp_base", {
	function getBondStage() { return 20; }
	function getLocationName() { return "$bv{location.liuying_unsent_letter_camp.name}"; }
	function getLocationDescription() { return "$bv{location.liuying_unsent_letter_camp.description}"; }
	function getWorldBrush() { return "world_cave_01"; }
	function getTacticalTemplate() { return "tactical.ruins"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 2; }
	function shouldCutDownTrees() { return true; }
});
