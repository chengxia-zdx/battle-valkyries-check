this.xilian_shard_camp_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/xilian_bond_camp_base", {
	function getBondStage() { return 20; }
	function getLocationName() { return "$bv{location.xilian_shard_camp.name}"; }
	function getLocationDescription() { return "$bv{location.xilian_shard_camp.description}"; }
	function getWorldBrush() { return "world_bandit_camp_01"; }
	function getTacticalTemplate() { return "tactical.human_camp"; }
	function getFortification() { return this.Const.Tactical.FortificationType.Palisade; }
	function getAdditionalRadius() { return 2; }
	function shouldCutDownTrees() { return true; }
});
