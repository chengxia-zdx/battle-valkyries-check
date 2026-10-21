this.spring_liuchun_strike_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create(); this.m.IsTargeted = true; this.m.IsTargetingActor = true;
		this.m.IsAttack = true; this.m.IsWeaponSkill = true; this.m.IsRanged = false;
		this.m.ActionPointCost = 6; this.m.FatigueCost = 15; this.m.MinRange = 1; this.m.MaxRange = 1;
		this.m.DirectDamageMult = 0.25;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody; this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
	}
	function bindWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor(), weapon = ::$bvvar{namespace}.getLiuchunWeapon(actor);
		this.setItem(weapon); return weapon;
	}
	function onAdded() { this.skill.onAdded(); this.bindWeapon(); }
	function isUsable() { return this.skill.isUsable() && this.bindWeapon() != null; }
	function onVerifyTarget(origin, target)
	{
		return this.skill.onVerifyTarget(origin, target) && target != null && target.IsOccupiedByActor
			&& !this.getContainer().getActor().isAlliedWith(target.getEntity()) && !::$bvvar{namespace}.isActorDeadOrDying(target.getEntity());
	}
	function onUse(user, tile)
	{
		local bv = ::$bvvar{namespace};
		if (bv.isActorDeadOrDying(user) || this.bindWeapon() == null || tile == null || !tile.IsOccupiedByActor) return false;
		local target = tile.getEntity();
		if (target.isAlliedWith(user) || !target.isAttackable() || bv.isActorDeadOrDying(target)) return false;
		this.Tactical.spawnSpriteEffect("fx_bv_spring_retention_bloom", this.createColor("ffffff"), tile, 0, 30, 0.7, 0.2, 0, 150, 150);
		return this.attackEntity(user, target);
	}
	function getTooltip() { return this.getDefaultTooltip(); }
});
