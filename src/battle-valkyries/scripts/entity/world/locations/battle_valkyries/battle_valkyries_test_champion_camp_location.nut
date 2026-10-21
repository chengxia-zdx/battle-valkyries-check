this.battle_valkyries_test_champion_camp_location <- this.inherit("scripts/entity/world/locations/bandit_camp_location", {
	m = {},

	function getDescription()
	{
		return "$bv{location.test_champion_camp.description}";
	}

	function create()
	{
		this.bandit_camp_location.create();
		this.m.TypeID = "$bvvar{modId}.location.test_champion_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.Name = "$bv{location.test_champion_camp.name}";
		this.m.Description = "$bv{location.test_champion_camp.description}";
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = true;
		this.m.IsSpawningDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.IsDespawningDefenders = true;
		this.m.DefenderSpawnList = null;
		this.m.Resources = 200;
	}

	function populateDefenders()
	{
		if (this.m.Troops.len() != 0)
		{
			return;
		}

		for( local i = 0; i < 5; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.BanditLeader
			}, false, 100);
		}

		this.updateStrength();
	}

	function onSpawned()
	{
		this.bandit_camp_location.onSpawned();
		this.setName("$bv{location.test_champion_camp.name}");
	}

	function onBeforeCombatStarted()
	{
		this.populateDefenders();
		this.location.onBeforeCombatStarted();
	}
});
