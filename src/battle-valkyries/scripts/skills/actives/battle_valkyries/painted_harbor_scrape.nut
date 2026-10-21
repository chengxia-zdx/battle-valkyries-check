this.painted_harbor_scrape <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "actives.warhound_bite"; this.m.Name = "$bv{enemy.painted_harbor.claw.name}"; this.m.Description = "$bv{enemy.painted_harbor.claw.description}";
		this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted; this.m.IsSerialized = false;
		this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = true; this.m.IsWeaponSkill = false;
		this.m.DirectDamageMult = 0.3; this.m.ActionPointCost = 4; this.m.FatigueCost = 10; this.m.MinRange = 1; this.m.MaxRange = 1;
		this.m.Icon = "skills/$bvvar{iconPrefix}/painted_harbor_human_stroke.png";
	},
	function onUpdate(properties)
	{
		local boss = this.getContainer().getActor().m.IsCurator;
		properties.DamageRegularMin += boss ? 80 : 45; properties.DamageRegularMax += boss ? 105 : 65; properties.DamageArmorMult *= 1.2;
	},
	function onUse(user, tile) { return tile != null && tile.IsOccupiedByActor && this.attackEntity(user, tile.getEntity()); }
});
