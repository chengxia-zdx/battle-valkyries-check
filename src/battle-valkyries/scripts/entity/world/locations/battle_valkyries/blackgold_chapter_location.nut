this.blackgold_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create() { this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.blackgold"; },
	function reinforceDefenders() {},
	function getChapterFactionType() { return this.Const.FactionType.Bandits; },
	function populateDefenders()
	{
		local d = this.data(); if (this.m.Troops.len() > 0 || d == null || !d.Battle) return;
		local groups = {
			depot = { Raiders = 8, Marksmen = 4, Expanded = [["brigands_t4", 3], ["brigands_t5", 1]] },
			vault = { Raiders = 6, Marksmen = 4, Expanded = [["mercenaries_t4", 4], ["nobles_t4", 2], ["mercenaries_t5", 1]] },
			backstage = { Raiders = 6, Marksmen = 4, Expanded = [["mercenaries_t4", 3], ["bounty_hunters_t4", 3], ["bounty_hunters_t5", 2]] },
			yard = { Raiders = 4, Marksmen = 2, Expanded = [["nobles_t4", 3], ["mercenaries_t4", 3], ["nobles_t5", 2]] }
		};
		if (!(this.node() in groups)) return;
		local group = groups[this.node()];
		for (local i = 0; i < group.Raiders; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditRaider }, false, 0);
		for (local i = 0; i < group.Marksmen; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditMarksman }, false, 0);
		foreach (entry in group.Expanded) this.addExpandedDefenders(entry[0], entry[1]);
		if (this.node() == "yard")
		{
			local troop = clone this.Const.World.Spawn.Troops.BanditLeader;
			troop.Script = "scripts/entity/tactical/enemies/battle_valkyries/blackgold_weiss"; troop.Variant = 0;
			local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0); added.Name = "$bv{chapter.blackgold.weiss.name}";
		}
		this.updateStrength();
	}
});
