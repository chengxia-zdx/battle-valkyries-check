this.skirk_havoc_warp_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false; this.m.IsTargetingActor = false; this.m.IsAttack = false; this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 2; this.m.FatigueCost = 10; this.m.MinRange = 0; this.m.MaxRange = 0;
	}
	function getPassive() { local c = this.getContainer(); return c == null ? null : c.getSkillByID("$bvvar{modId}.skill.skirk_serpents_subtlety"); }
	function getPhase() { local p = this.getPassive(); return p == null ? null : p.getPhaseEffect(); }
	function isUsable() { local p = this.getPassive(); local phase = this.getPhase(); return this.skill.isUsable() && p != null && p.hasMeleeWeapon() && p.getCount() >= 1 && (phase == null || !phase.isPhaseActive()); }
	function getTooltip()
	{
		local ret = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", text = this.getCostString() }, { id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.skirk_havoc_warp.tooltip.phase}" }];
		if (!this.isUsable()) ret.push({ id = 5, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.skirk_havoc_warp.tooltip.unusable}" });
		return ret;
	}
	function onUse( _user, _targetTile ) { if (_user == null || !this.isUsable()) return false; local phase = this.getPhase(); if (phase == null) phase = this.getPassive().ensurePhaseEffect(); local activated = phase != null && phase.activate(); if (activated && "playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "skirk_abyss_warp"); return activated; }
	function onCombatStarted() { local phase = this.getPhase(); if (phase != null) phase.deactivate(); }
	function onCombatFinished() { local phase = this.getPhase(); if (phase != null) phase.deactivate(); this.skill.onCombatFinished(); }
});
