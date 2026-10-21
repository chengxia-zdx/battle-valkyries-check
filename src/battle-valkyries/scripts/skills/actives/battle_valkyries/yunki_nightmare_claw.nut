this.yunki_nightmare_claw <- this.inherit("scripts/skills/skill", {
	function create()
	{
		// The wardog agent's offensive behavior selects this stable vanilla skill ID.
		this.m.ID = "actives.warhound_bite"; this.m.Name = "$bv{enemy.yunki_claw.name}"; this.m.Description = "$bv{enemy.yunki_claw.description}";
		this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted; this.m.IsSerialized = false;
		this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = true; this.m.IsWeaponSkill = false;
		this.m.DirectDamageMult = 0.3; this.m.ActionPointCost = 4; this.m.FatigueCost = 10; this.m.MinRange = 1; this.m.MaxRange = 1;
		this.m.Icon = "skills/$bvvar{iconPrefix}/yunki_nightmare.png";
	}
	function onUpdate(properties)
	{
		local phantom = this.getContainer().getActor().m.IsYunkiPhantom;
		properties.DamageRegularMin += phantom ? 45 : 80; properties.DamageRegularMax += phantom ? 65 : 110; properties.DamageArmorMult *= 1.3;
	}
	function onUse(user, tile) { return tile != null && tile.IsOccupiedByActor && this.attackEntity(user, tile.getEntity()); }
});
