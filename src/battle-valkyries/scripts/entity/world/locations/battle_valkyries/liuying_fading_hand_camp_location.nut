this.liuying_fading_hand_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/liuying_bond_camp_base", {
	function getBondStage() { return 40; }
	function getLocationName() { return "$bv{location.liuying_fading_hand_camp.name}"; }
	function getLocationDescription() { return "$bv{location.liuying_fading_hand_camp.description}"; }
	function getWorldBrush() { return "world_bandit_camp_01"; }
	function getTacticalTemplate() { return "tactical.human_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Palisade; }
	function getAdditionalRadius() { return 2; }
	function shouldCutDownTrees() { return true; }
});
