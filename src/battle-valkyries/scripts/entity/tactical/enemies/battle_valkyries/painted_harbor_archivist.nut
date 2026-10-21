this.painted_harbor_archivist <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/painted_harbor_ink_puppet", {
	function create()
	{
		this.painted_harbor_ink_puppet.create(); this.m.IsPaintedPuppet = false; this.m.IsArchivist = true;
		this.m.Name = "$bv{enemy.painted_harbor.archivist.name}"; this.m.XP = 800;
	}
});
