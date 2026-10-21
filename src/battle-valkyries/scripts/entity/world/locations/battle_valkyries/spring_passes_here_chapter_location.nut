this.spring_passes_here_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create() { this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.spring_passes_here"; },
	function reinforceDefenders() {},
	function getChapterFactionType() { return this.Const.FactionType.Beasts; },
	function addRoots(script, name, count)
	{
		local troop = clone this.Const.World.Spawn.Troops.Unhold;
		troop.Script = "scripts/entity/tactical/enemies/battle_valkyries/spring_" + script; troop.Variant = 0;
		for (local i = 0; i < count; ++i) { local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0); added.Name = name; }
	},
	function populateDefenders()
	{
		local d = this.data(); if (this.m.Troops.len() > 0 || d == null || !d.Battle) return;
		local groups = { watermill = [3, 2], cemetery = [5, 2], nursery = [2, 6], bloom = [3, 3] }, node = this.node();
		if (!(node in groups)) return;
		this.addRoots("root_bound_guard", "$bv{enemy.spring.root_bound_guard.name}", groups[node][0]);
		this.addRoots("root_beast", "$bv{enemy.spring.root_beast.name}", groups[node][1]);
		if (node == "bloom") this.addRoots("carrion_bloom_mother", "$bv{enemy.spring.carrion_bloom_mother.name}", 1);
		this.updateStrength();
	}
});
