this.royal_tide_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create() { this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.royal_banner_returning_tide"; },
	function reinforceDefenders() {},
	function configure()
	{
		this.yunki_chapter_location.configure();
		// Use native ruins layouts; never put a tactical template in the decorator
		// slot. Different radius/fortification and troop rows vary the four fights.
		local layouts = { causeway = [0, true, true], archive = [3, true, false], signal_corridor = [1, false, false], oath_core = [2, true, true] }, node = this.node();
		if (!(node in layouts)) return;
		this.m.CombatLocation.Template = ["tactical.ruins", null];
		this.m.CombatLocation.AdditionalRadius = layouts[node][0];
		this.m.CombatLocation.Fortification = layouts[node][1] ? this.Const.Tactical.FortificationType.Walls : this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.ForceLineBattle = layouts[node][2];
	},
	function getChapterFactionType() { return this.Const.FactionType.Undead; },
	function addOathTroops(script, name, count, template = "SkeletonHeavy")
	{
		local troop = clone this.Const.World.Spawn.Troops[template];
		troop.Script = script; troop.Variant = 0;
		for (local i = 0; i < count; ++i) { local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0); added.Name = name; }
	},
	function populateDefenders()
	{
		local d = this.data(); if (this.m.Troops.len() > 0 || d == null || !d.Battle) return;
		local groups = { causeway = [3, 0, 2], archive = [4, 3, 0], signal_corridor = [3, 2, 3], oath_core = [4, 2, 0] }, node = this.node();
		if (!(node in groups)) return;
		this.addOathTroops("scripts/entity/tactical/enemies/battle_valkyries/royal_tide_oath_guard", "$bv{enemy.royal_tide.guard.name}", groups[node][0]);
		this.addOathTroops("scripts/entity/tactical/enemies/skeleton_medium_polearm", "$bv{enemy.royal_tide.spearman.name}", groups[node][1], "SkeletonMediumPolearm");
		this.addOathTroops("scripts/entity/tactical/enemies/battle_valkyries/royal_tide_crossbowman", "$bv{enemy.royal_tide.crossbowman.name}", groups[node][2], "BanditMarksman");
		if (node == "oath_core") this.addOathTroops("scripts/entity/tactical/enemies/battle_valkyries/royal_tide_last_oath_regent", "$bv{enemy.royal_tide.regent.name}", 1);
		this.updateStrength();
	}
});
