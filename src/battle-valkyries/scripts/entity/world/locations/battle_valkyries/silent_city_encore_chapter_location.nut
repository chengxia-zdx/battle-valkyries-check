this.silent_city_encore_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create() { this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.silent_city_encore"; },
	function reinforceDefenders() {},
	function getChapterFactionType() { return this.Const.FactionType.Beasts; },
	function addBeasts(script, name, count)
	{
		local troop = clone this.Const.World.Spawn.Troops.Unhold;
		troop.Script = "scripts/entity/tactical/enemies/battle_valkyries/" + script; troop.Variant = 0;
		for (local i = 0; i < count; ++i) { local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0); added.Name = name; }
	},
	function populateDefenders()
	{
		local d = this.data(); if (this.m.Troops.len() > 0 || d == null || !d.Battle) return;
		local counts = { warehouse = 5, tunnels = 7, quarry = 9, resonance = 6 }, node = this.node();
		if (!(node in counts)) return;
		this.addBeasts("silent_city_resonance_beast", "$bv{enemy.silent_city.beast.name}", counts[node]);
		if (node == "resonance") this.addBeasts("silent_city_echo_lord", "$bv{enemy.silent_city.lord.name}", 1);
		this.updateStrength();
	}
});
