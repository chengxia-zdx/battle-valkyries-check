this.black_city_flame <- this.inherit("scripts/skills/skill", {
	function create()
	{
		// Native bow AI selects this ID. It remains an enemy-only spell, with no ammo or weapon dependency.
		this.m.ID = "actives.quick_shot"; this.m.Name = "$bv{chapter.black_city.flame.name}";
		this.m.Description = "$bv{chapter.black_city.flame.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/olga_black_flame.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/olga_black_flame_sw.png";
		this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false; this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = true;
		this.m.IsRanged = true; this.m.IsWeaponSkill = false; this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false; this.m.ActionPointCost = 6; this.m.FatigueCost = 18;
		this.m.MinRange = 2; this.m.MaxRange = 5; this.m.MaxLevelDifference = 4; this.m.DirectDamageMult = 0.25;
	},
	function getTooltip() { return this.getDefaultTooltip(); },
	function isUsable()
	{
		local a = this.getContainer().getActor();
		return this.skill.isUsable() && a != null && a.isAlive() && !a.isDying() && a.getHitpoints() > 0 && !a.getTile().hasZoneOfControlOtherThan(a.getAlliedFactions());
	},
	function onAnySkillUsed(skill, target, properties)
	{
		if (skill != this) return;
		properties.DamageRegularMin = 55; properties.DamageRegularMax = 75; properties.DamageArmorMult = 1.0;
	},
	function onVerifyTarget(origin, target)
	{
		return this.skill.onVerifyTarget(origin, target) && target.IsOccupiedByActor && !target.getEntity().isAlliedWith(this.getContainer().getActor());
	},
	function onUse(user, tile)
	{
		if (user == null || !user.isAlive() || user.isDying() || user.getHitpoints() <= 0 || tile == null || !tile.IsOccupiedByActor) return false;
		local target = tile.getEntity();
		if (target == null || !target.isAlive() || target.isDying() || target.getHitpoints() <= 0 || target.isAlliedWith(user)) return false;
		return this.attackEntity(user, target);
	}
});
