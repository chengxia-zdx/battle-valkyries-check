// The vanilla alp AI looks up actives.nightmare; preserve that ID and every
// targeting, AP, sleep and protection rule. Only these custom alps gain damage.
this.bv_enemy_nightmare_skill <- this.inherit("scripts/skills/actives/nightmare_skill", {
	m = { BVExpandedNightmare = true },
	function create()
	{
		this.nightmare_skill.create();
		this.m.Name = "$bv{enemy_expansion.nightmare.name}";
		this.m.KilledString = "$bv{enemy_expansion.nightmare.killed}";
	}
	function getDamage( _actor )
	{
		local damage = this.nightmare_skill.getDamage(_actor);
		local owner = this.getContainer().getActor();
		if (owner == null) return damage;
		local profile = ::$bvvar{namespace}.getExpandedEnemyCombatProfile(owner.getFlags().get("BVExpandedEnemyKey"));
		return damage + (profile != null && "NightmareDamage" in profile ? profile.NightmareDamage : 0);
	}
});
