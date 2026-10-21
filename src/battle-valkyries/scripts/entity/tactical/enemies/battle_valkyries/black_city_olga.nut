this.black_city_olga <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/black_city_chloe", {
	function create()
	{
		this.black_city_chloe.create(); this.m.BlackCityCaster = true; this.m.BlackCityBrush = "bust_bv_olga_skin";
		this.m.Name = "$bv{chapter.black_city.enemy.olga}"; this.m.XP = 1400;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bandit_ranged_agent"); this.m.AIAgent.setActor(this);
	}
});
