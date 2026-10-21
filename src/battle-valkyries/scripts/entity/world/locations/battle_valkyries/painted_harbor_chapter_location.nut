this.painted_harbor_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
	function create() { this.yunki_chapter_location.create(); this.m.TypeID = "$bvvar{modId}.location.painted_harbor"; },
	function reinforceDefenders() {},
	function addPainted(script, name, count)
	{
		local troop = clone this.Const.World.Spawn.Troops.Necromancer;
		troop.Script = "scripts/entity/tactical/enemies/battle_valkyries/" + script; troop.Variant = 0;
		for (local i = 0; i < count; ++i)
		{
			local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0); added.Name = name;
		}
	},
	function populateDefenders()
	{
		if (this.m.Troops.len() > 0) return;
		local node = this.node(), d = this.data(); if (d == null || !d.Battle) return;
		local puppet = "$bv{enemy.painted_harbor.puppet.name}";
		if (node == "warehouse")
		{
			for (local i = 0; i < 6; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditRaider }, false, 0);
			for (local i = 0; i < 3; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditMarksman }, false, 0);
			this.addPainted("painted_harbor_ink_puppet", puppet, 3); this.addExpandedDefenders("brigands_t4", 2);
		}
		else if (node == "clocktower")
		{
			for (local i = 0; i < 6; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.SkeletonMedium }, false, 0);
			this.addPainted("painted_harbor_ink_puppet", puppet, 4);
			this.addExpandedDefenders("ancients_t4", 3); this.addExpandedDefenders("ancients_t5", 1);
		}
		else if (node == "gallery")
		{
			this.addPainted("painted_harbor_archivist", "$bv{enemy.painted_harbor.archivist.name}", 1);
			this.addPainted("painted_harbor_ink_puppet", puppet, 5);
			this.addExpandedDefenders("ancients_t4", 4); this.addExpandedDefenders("ancients_t5", 2);
		}
		else if (node == "curator")
		{
			this.addPainted("painted_harbor_curator", "$bv{enemy.painted_harbor.curator.name}", 1);
			this.addPainted("painted_harbor_ink_puppet", puppet, 6);
			this.addExpandedDefenders("ancients_t4", 3); this.addExpandedDefenders("ancients_t5", 2);
		}
		this.updateStrength();
	}
});
