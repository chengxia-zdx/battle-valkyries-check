this.thirteenth_bell_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create()
	{
		this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.thirteenth_bell";
		this.m.CombatLocation.Template = ["tactical.ruins", null];
		this.m.CombatLocation.AdditionalRadius = 1;
	},
	function getChapterFactionType() { return this.Const.FactionType.Undead; },
	function reinforceDefenders() {},
	function addClockTroops(type, count, name, script = null)
	{
		local troop = clone this.Const.World.Spawn.Troops[type];
		if (script != null) troop.Script = "scripts/entity/tactical/enemies/battle_valkyries/thirteenth_bell_" + script;
		troop.Variant = 0;
		for (local i = 0; i < count; ++i)
		{
			local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0);
			added.Name = name;
		}
	},
	function populateDefenders()
	{
		if (this.getFlags().get("BVThirteenthBellPopulated") == true || this.m.Troops.len() > 0) return;
		local d = this.data(); if (d == null || !d.Battle) return;
		local node = this.node();
		if (node == "procession")
		{
			this.addClockTroops("SkeletonMedium", 4, "$bv{chapter.thirteenth_bell.enemy.patrol}");
			this.addClockTroops("BanditMarksman", 3, "$bv{chapter.thirteenth_bell.enemy.arbalist}");
			this.addClockTroops("Necromancer", 1, "$bv{chapter.thirteenth_bell.enemy.lantern}", "lantern");
		}
		else if (node == "street")
		{
			this.addClockTroops("SkeletonMedium", 6, "$bv{chapter.thirteenth_bell.enemy.patrol}");
			this.addClockTroops("BanditMarksman", 3, "$bv{chapter.thirteenth_bell.enemy.arbalist}");
			this.addClockTroops("Necromancer", 1, "$bv{chapter.thirteenth_bell.enemy.officer}", "officer");
		}
		else if (node == "shadows")
		{
			this.addClockTroops("SkeletonMedium", 6, "$bv{chapter.thirteenth_bell.enemy.patrol}");
			this.addClockTroops("Necromancer", 1, "$bv{chapter.thirteenth_bell.enemy.observer}", "observer");
			this.addClockTroops("Necromancer", 1, "$bv{chapter.thirteenth_bell.enemy.gatekeeper}", "gatekeeper");
		}
		else if (node == "keeper")
		{
			this.addClockTroops("Necromancer", 1, "$bv{chapter.thirteenth_bell.enemy.keeper}", "keeper");
			this.addClockTroops("Necromancer", 3, "$bv{chapter.thirteenth_bell.enemy.clock}", "outer_clock");
		}
		else return;
		this.getFlags().set("BVThirteenthBellPopulated", true); this.updateStrength();
	}
});
