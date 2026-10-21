this.valkyrie_bounty_elite <- this.inherit("scripts/entity/tactical/enemies/bandit_raider", {
	function onInit()
	{
		this.bandit_raider.onInit();
		local properties = this.m.BaseProperties;
		properties.Hitpoints += 20;
		properties.MeleeSkill += 10;
		properties.MeleeDefense += 5;
		properties.Bravery += 10;
		this.m.Hitpoints = properties.Hitpoints;
		this.m.CurrentProperties = clone properties;
	}
});
