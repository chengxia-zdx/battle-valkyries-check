this.ye_shunguang_heart_recalled_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false; this.m.IsTargetingActor = false;
		this.m.IsAttack = false; this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 2; this.m.FatigueCost = 10;
	}
	function getStance()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor == null ? null : actor.getSkills().getSkillByID("$bvvar{modId}.effects.ye_shunguang_qingming_stance");
	}
	function eligible()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.isPlacedOnMap()
			|| ::$bvvar{namespace}.getActorValkyrieID(actor) != "ye_shunguang") return false;
		local trait = actor.getSkills().getSkillByID("$bvvar{modId}.trait.ye_shunguang_bond");
		local flags = actor.getFlags(), stance = this.getStance();
		return trait != null && trait.hasTriggeredStage(100) && flags.get("BVYeBondInCombat") == true
			&& flags.get("BVYeHeartRecalledUsed") != true && stance != null && stance.getCount() < 6;
	}
	function isUsable() { return this.skill.isUsable() && this.eligible(); }
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({ id = 20, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.ye_shunguang_heart_recalled.rules}" });
		if (!this.eligible()) ret.push({ id = 21, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.ye_shunguang_heart_recalled.unavailable}" });
		return ret;
	}
	function onUse(user, tile)
	{
		// Costs were paid by skill.use. Recheck state, not remaining AP or fatigue.
		if (user != this.getContainer().getActor() || !this.eligible()) return false;
		user.getFlags().set("BVYeHeartRecalledUsed", true);
		this.getStance().setCount(6);
		// Do not recreate Enlightened State: spent stance and the round's block stay intact.
		::$bvvar{namespace}.playValkyrieVisual(this, user, "ye_shunguang_reflection_cast");
		::$bvvar{namespace}.playValkyrieSkillAudio(user, "ye_stance_ready");
		return true;
	}
});
