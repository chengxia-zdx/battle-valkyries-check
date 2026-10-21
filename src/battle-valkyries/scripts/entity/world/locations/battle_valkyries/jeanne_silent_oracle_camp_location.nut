this.jeanne_silent_oracle_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/jeanne_bond_camp_base", {
	function getBondStage() { return 40; }
	function getLocationName() { return "$bv{location.jeanne_bond.40.name}"; }
	function getLocationDescription() { return "$bv{location.jeanne_bond.40.description}"; }
	function getWorldBrush() { return "world_goblin_camp_01"; }
	function getTacticalTemplate() { return "tactical.goblin_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Palisade; }
	function getAdditionalRadius() { return 3; }
	function shouldCutDownTrees() { return true; }
});
