this.jeanne_ashen_chapel_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/jeanne_bond_camp_base", {
	function getBondStage() { return 20; }
	function getLocationName() { return "$bv{location.jeanne_bond.20.name}"; }
	function getLocationDescription() { return "$bv{location.jeanne_bond.20.description}"; }
	function getWorldBrush() { return "world_bandit_camp_01"; }
	function getTacticalTemplate() { return "tactical.human_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Palisade; }
	function shouldCutDownTrees() { return true; }
});
