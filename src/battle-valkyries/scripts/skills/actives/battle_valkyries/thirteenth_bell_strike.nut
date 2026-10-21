this.thirteenth_bell_strike <- this.inherit("scripts/skills/skill", {
	function create()
	{
		// The native default-attack AI recognizes this active ID.
		this.m.ID = "actives.warhound_bite"; this.m.Name = "$bv{chapter.thirteenth_bell.enemy.strike}";
		this.m.Description = "$bv{chapter.thirteenth_bell.enemy.strike_description}";
		this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted; this.m.IsSerialized = false;
		this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = true; this.m.IsWeaponSkill = false;
		this.m.DirectDamageMult = 0.25; this.m.ActionPointCost = 4; this.m.FatigueCost = 10; this.m.MinRange = 1; this.m.MaxRange = 1;
		this.m.Icon = "skills/$bvvar{iconPrefix}/thirteenth_bell_clock.png";
	},
	function onUpdate(p)
	{
		local boss = this.getContainer().getActor().m.ClockRole == "keeper";
		p.DamageRegularMin += boss ? 65 : 35; p.DamageRegularMax += boss ? 85 : 55; p.DamageArmorMult *= 1.2;
	},
	function onUse(user, tile) { return tile != null && tile.IsOccupiedByActor && this.attackEntity(user, tile.getEntity()); }
});
