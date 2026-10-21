this.liuying_glamoth_signal_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/liuying_bond_camp_base", {
	function getBondStage() { return 60; }
	function getLocationName() { return "$bv{location.liuying_glamoth_signal_camp.name}"; }
	function getLocationDescription() { return "$bv{location.liuying_glamoth_signal_camp.description}"; }
	function getWorldBrush() { return "world_vampire_coven"; }
	function getTacticalTemplate() { return "tactical.ruins"; }
	function getFortification() { return this.Const.Tactical.FortificationType.None; }
	function getAdditionalRadius() { return 3; }
	function shouldCutDownTrees() { return false; }
});
