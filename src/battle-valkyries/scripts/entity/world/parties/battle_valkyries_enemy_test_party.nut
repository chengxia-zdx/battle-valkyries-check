this.battle_valkyries_enemy_test_party <- this.inherit("scripts/entity/world/party", {
	m = {},
	function create()
	{
		this.party.create();
		this.m.IsAttackableByAI = false;
		this.m.IsAlwaysAttackingPlayer = false;
		this.m.IsLeavingFootprints = false;
	}
	function onInit()
	{
		this.party.onInit();
		this.getSprite("body").setBrush("figure_bandit_01");
		this.setShowName(true);
	}
	function onUpdate()
	{
		// Deliberately stationary. Retain the ordinary party combat/save lifecycle.
		this.world_entity.onUpdate();
	}
	function getTroopComposition()
	{
		local result = [];
		foreach (troop in this.getTroops())
			result.push({ id = 10 + result.len(), type = "text", icon = "ui/orientation/" + this.Const.EntityIcon[troop.ID] + ".png", text = troop.Name });
		return result;
	}
});
