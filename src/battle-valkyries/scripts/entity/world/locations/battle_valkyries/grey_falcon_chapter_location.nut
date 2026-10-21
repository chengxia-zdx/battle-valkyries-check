this.grey_falcon_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create() { this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.grey_falcon"; },
	function reinforceDefenders() {},
	function getChapterFactionType() { return this.Const.FactionType.Bandits; },
	function addSoldiers(type, script, name, count)
	{
		local troop = clone this.Const.World.Spawn.Troops[type];
		troop.Script = "scripts/entity/tactical/enemies/battle_valkyries/" + script; troop.Variant = 0;
		for (local i = 0; i < count; ++i)
		{
			local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0);
			added.Name = name;
		}
	},
	function populateDefenders()
	{
		local d = this.data(); if (this.m.Troops.len() > 0 || d == null || !d.Battle) return;
		local groups = { roadblock = [5, 2, 2], courier_station = [6, 3, 3], pursuit = [7, 4, 3], mountain_exit = [8, 4, 4] };
		if (!(this.node() in groups)) return;
		local group = groups[this.node()];
		this.addSoldiers("Footman", "grey_falcon_guard", "$bv{enemy.grey_falcon.guard.name}", group[0]);
		this.addSoldiers("Billman", "grey_falcon_billman", "$bv{enemy.grey_falcon.billman.name}", group[1]);
		this.addSoldiers("Arbalester", "grey_falcon_arbalester", "$bv{enemy.grey_falcon.arbalester.name}", group[2]);
		if (this.node() == "mountain_exit") this.addSoldiers("BanditLeader", "grey_falcon_hermann", "$bv{enemy.grey_falcon.hermann.name}", 1);
		this.updateStrength();
	}
});
