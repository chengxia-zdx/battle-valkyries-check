this.seven_shields_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/black_city_chapter_location", {
	function create()
	{
		this.black_city_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.seven_shields";
	},
	function configure()
	{
		this.black_city_chapter_location.configure(); local d = this.data(); if (d == null) return;
		if (d.Battle) this.m.Description = "$bv{chapter.seven_shields.location_battle}";
		this.m.CombatLocation.Template = ["tactical.ruins", null];
		// Bridge fights are tight; shrine and court fights allow flank approaches.
		this.m.CombatLocation.AdditionalRadius = this.node() == "fortress_one" || this.node() == "fortress_six" ? 0 : 3;
	},
	function addSevenShieldsCommander(role)
	{
		local names = { alicia = "$bv{valkyrie.alicia.name}", prim = "$bv{valkyrie.prim.name}", kaguya = "$bv{valkyrie.kaguya.name}",
			maia = "$bv{valkyrie.maia.name}", luu_luu = "$bv{valkyrie.luu_luu.name}", claudia = "$bv{valkyrie.claudia.name}", celestine = "$bv{valkyrie.celestine.name}" };
		local troops = this.Const.World.Spawn.Troops;
		local type = role == "kaguya" || role == "celestine" ? troops.BanditMarksman : (role == "claudia" ? troops.Billman : troops.BanditLeader);
		this.addBlackCityTroops(type, 1, names[role], "scripts/entity/tactical/enemies/battle_valkyries/seven_shields_" + role);
	},
	function populateDefenders()
	{
		if (this.m.Troops.len() > 0) return;
		local d = this.data(); if (d == null || !d.Battle) return;
		local t = this.Const.World.Spawn.Troops;
		local plans = {
			convoy = { Roles = [], Infantry = 5, Polearms = 2, Crossbows = 3 },
			fortress_one = { Roles = ["alicia"], Infantry = 6, Polearms = 2, Crossbows = 3 },
			fortress_two = { Roles = ["prim"], Infantry = 7, Polearms = 1, Crossbows = 3 },
			fortress_three = { Roles = ["kaguya"], Infantry = 5, Polearms = 3, Crossbows = 4 },
			fortress_four = { Roles = ["maia"], Infantry = 7, Polearms = 2, Crossbows = 4 },
			fortress_five = { Roles = ["luu_luu"], Infantry = 7, Polearms = 4, Crossbows = 2 },
			fortress_six = { Roles = ["claudia"], Infantry = 7, Polearms = 4, Crossbows = 3 },
			fortress_seven = { Roles = ["celestine", "claudia"], Infantry = 7, Polearms = 4, Crossbows = 4 }
		};
		local node = this.node(); if (!(node in plans)) return;
		local p = plans[node];
		foreach (role in p.Roles) this.addSevenShieldsCommander(role);
		this.addBlackCityTroops(t.Footman, p.Infantry); this.addBlackCityTroops(t.Billman, p.Polearms); this.addBlackCityTroops(t.Arbalester, p.Crossbows);
		this.updateStrength();
	}
});
