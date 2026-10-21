this.painted_harbor_curator <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/painted_harbor_ink_puppet", {
	function create()
	{
		this.painted_harbor_ink_puppet.create(); this.m.IsPaintedPuppet = false; this.m.IsCurator = true;
		this.m.Name = "$bv{enemy.painted_harbor.curator.name}"; this.m.XP = 2200;
	}
});
