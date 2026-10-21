this.black_city_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create()
	{
		this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.black_city_falls";
		this.m.CombatLocation.AdditionalRadius = 0;
	},
	function getChapterFactionType() { return this.Const.FactionType.Bandits; },
	function configure()
	{
		this.yunki_chapter_location.configure();
		local d = this.data(); if (d == null) return;
		if (d.Battle) this.m.Description = "$bv{chapter.black_city.location_battle}";
		// Native ruins battlefield; local space and fortifications vary by encounter.
		this.m.CombatLocation.Template = ["tactical.ruins", null];
		this.m.CombatLocation.AdditionalRadius = this.node() == "black_bridge" ? 0 : 2;
	},
	function reinforceDefenders() {},
	function addBlackCityTroops(type, count, name = null, script = null)
	{
		local troop = clone type;
		if (script != null) { troop.Script = script; troop.Variant = 0; }
		for (local i = 0; i < count; ++i)
		{
			local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0);
			if (name != null) added.Name = name;
		}
	},
	function populateDefenders()
	{
		if (this.m.Troops.len() > 0) return; // Retreat losses persist; no replenishment.
		local d = this.data(); if (d == null || !d.Battle) return;
		local troops = this.Const.World.Spawn.Troops;
		if (this.node() == "depot")
		{
			this.addBlackCityTroops(troops.BanditRaider, 6, "$bv{chapter.black_city.guard.name}");
			this.addBlackCityTroops(troops.BanditMarksman, 3, "$bv{chapter.black_city.archer.name}");
		}
		else if (this.node() == "black_bridge")
		{
			this.addBlackCityTroops(troops.BanditLeader, 1, "$bv{chapter.black_city.enemy.chloe}", "scripts/entity/tactical/enemies/battle_valkyries/black_city_chloe");
			this.addBlackCityTroops(troops.BanditRaider, 7, "$bv{chapter.black_city.guard.name}");
			this.addBlackCityTroops(troops.BanditMarksman, 2, "$bv{chapter.black_city.archer.name}");
		}
		else if (this.node() == "ward_tower")
		{
			this.addBlackCityTroops(troops.Necromancer, 1);
			this.addBlackCityTroops(troops.ZombieKnight, 2);
			this.addBlackCityTroops(troops.ZombieYeoman, 6);
		}
		else if (this.node() == "throne")
		{
			this.addBlackCityTroops(troops.BanditMarksman, 1, "$bv{chapter.black_city.enemy.olga}", "scripts/entity/tactical/enemies/battle_valkyries/black_city_olga");
			this.addBlackCityTroops(troops.BanditRaider, 6, "$bv{chapter.black_city.guard.name}");
			this.addBlackCityTroops(troops.BanditMarksman, 3, "$bv{chapter.black_city.archer.name}");
		}
		this.updateStrength();
	}
});
