this.yixuan_sanctuary_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Used = false },
	function create() { this.valkyrie_active_skill.create(); this.m.IsTargeted = false; this.m.IsTargetingActor = false; this.m.IsAttack = false; this.m.IsWeaponSkill = false; this.m.ActionPointCost = 3; this.m.FatigueCost = 0; }
	function isUsable() { return !this.m.Used && this.skill.isUsable(); }
	function onCombatStarted() { this.m.Used = false; }
	function onCombatFinished() { this.m.Used = false; this.skill.onCombatFinished(); }
	function getTooltip() { return this.getDefaultTooltip(); }
	function onUse(user, tile)
	{
		if (this.m.Used || user == null || !user.isAlive()) return false;
		this.m.Used = true;
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(user, "yixuan_sanctuary_cast");

		foreach (ally in ::World.getPlayerRoster().getAll())
		{
			if (!ally.isAlive() || ally.isDying() || !ally.isPlacedOnMap() || user.getTile().getDistanceTo(ally.getTile()) > 3) continue;
			local ward = ally.getSkills().getSkillByID("$bvvar{modId}.effects.yixuan_sanctuary");
			if (ward == null) { ward = ::new("$bvvar{privateFolder}/skills/effects/yixuan_sanctuary_effect"); ally.getSkills().add(ward); }
			ward.m.Remaining = ::Math.max(ward.m.Remaining, 40);
			ally.setFatigue(::Math.max(0, ally.getFatigue() - 20)); ally.setDirty(true);
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, ally, "yixuan_ward");
		}
		local technique = user.getSkills().getSkillByID("$bvvar{modId}.effects.yixuan_technique_points");
		if (technique != null) technique.setCount(3);
		return true;
	}
});
