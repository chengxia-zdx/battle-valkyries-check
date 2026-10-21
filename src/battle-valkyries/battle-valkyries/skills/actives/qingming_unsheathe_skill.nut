this.qingming_unsheathe_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create(); this.m.IsTargeted = false; this.m.IsTargetingActor = false;
		this.m.IsAttack = false; this.m.IsWeaponSkill = false; this.m.ActionPointCost = 2; this.m.FatigueCost = 10;
	}
	function eligible()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor != null && actor.isAlive() && ::$bvvar{namespace}.getActorValkyrieID(actor) == "ye_shunguang" && ::$bvvar{namespace}.getYunkiWeaponStage(actor) >= 6
			&& ::$bvvar{namespace}.getQingmingWeapon(actor) != null && !("BVQingmingUnsheathed" in actor.m && actor.m.BVQingmingUnsheathed);
	}
	function isUsable() { return this.skill.isUsable() && this.eligible(); }
	function getTooltip() { return this.getDefaultTooltip(); }
	function onUse(user, tile)
	{
		// Costs have already been paid by skill.use. Do not call isUsable here.
		if (!this.eligible()) return false;
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(user, "ye_unsheathe_cast");
		user.m.BVQingmingUnsheathed <- true;
		::$bvvar{namespace}.getQingmingWeapon(user).setSwordForm(true);
		local clarity = ::$bvvar{namespace}.getRuntimeSkillByKey(user, "ye_shunguang_enlightened_clarity");
		if (clarity != null) clarity.ensureStance().setCount(6);
		// Filling Sword Stance only prepares Reflection; it must not enter the state.
		::$bvvar{namespace}.playValkyrieVisual(this, user, "ye_shunguang_reflection_cast");
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(user, ::$bvvar{namespace}.getValkyrieRadiusTiles(user.getTile(), 2, true)))
		{
			if (!user.isAlive() || user.isDying()) break;
			if (!target.isAlive() || target.isDying()) continue;
			::$bvvar{namespace}.playValkyrieVisual(this, target, "ye_shunguang_dust");
			::$bvvar{namespace}.applyValkyrieWeaponAttack(user, this, target, { WeaponDamageMult = 1.50, ArmorDamageMult = 1.0, DirectDamageAdd = 0.0, HitChance = 15, IgnoreDistance = true, IgnoreShield = false });
		}
		return true;
	}
});
