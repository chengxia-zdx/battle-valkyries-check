this.qingming_casket_strike_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { ImpactPosition = null, ImpactPlayed = false },
	function create()
	{
		this.valkyrie_active_skill.create(); this.m.IsTargeted = true; this.m.IsTargetingActor = true;
		this.m.IsAttack = true; this.m.IsWeaponSkill = true; this.m.IsRanged = false;
		this.m.ActionPointCost = 6; this.m.FatigueCost = 15; this.m.MinRange = 1; this.m.MaxRange = 2;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody; this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
	}
	function bindWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor(), weapon = ::$bvvar{namespace}.getQingmingWeapon(actor);
		this.setItem(weapon); if (weapon != null) this.m.DirectDamageMult = weapon.m.DirectDamageMult; return weapon;
	}
	function onAdded()
	{
		this.skill.onAdded();
		// Cost previews and skill.use check affordability before isUsable(). Bind
		// the weapon now so Flowing Light applies to the very first cost query.
		this.bindWeapon();
	}
	function isUsable() { return this.skill.isUsable() && ::$bvvar{namespace}.getActorValkyrieID(this.getContainer().getActor()) == "ye_shunguang" && this.bindWeapon() != null; }
	function onVerifyTarget(origin, target) { return this.skill.onVerifyTarget(origin, target) && target != null && target.IsOccupiedByActor && !this.getContainer().getActor().isAlliedWith(target.getEntity()); }
	function onAnySkillUsed(skill, target, properties) { if (skill != this) return; local w = this.bindWeapon(); if (w != null) properties.MeleeSkill += w.getAdditionalAccuracy(); }
	function onBeforeTargetHit(skill, target, hitInfo)
	{
		if (skill == this && "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace})
			this.m.ImpactPosition = ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target);
	}
	function onTargetHit(skill, target, bodyPart, hp, armor)
	{
		if (skill != this || this.m.ImpactPlayed) return;
		this.m.ImpactPlayed = true;
		if (this.m.ImpactPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			::$bvvar{namespace}.playValkyrieSkillAudio(this.getContainer().getActor(), "ye_slash_impact", this.m.ImpactPosition);
	}
	function onUse(user, tile)
	{
		if (this.bindWeapon() == null || tile == null || !tile.IsOccupiedByActor) return false;
		this.m.ImpactPosition = null; this.m.ImpactPlayed = false;
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(user, "ye_casket_cast");
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, tile.getEntity(), "ye_shunguang_slash");
		local result = this.attackEntity(user, tile.getEntity());
		this.m.ImpactPosition = null;
		return result;
	}
	function getTooltip() { return this.getDefaultTooltip(); }
});
