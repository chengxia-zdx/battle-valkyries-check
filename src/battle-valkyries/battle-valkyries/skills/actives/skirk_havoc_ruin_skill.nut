this.skirk_havoc_ruin_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Snapshot = 0 },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = true; this.m.IsWeaponSkill = false; this.m.IsRanged = false;
		this.m.ActionPointCost = 5; this.m.FatigueCost = 30; this.m.MinRange = 1; this.m.MaxRange = 4; this.m.Snapshot = 0;
	}
	function getPassive() { local c = this.getContainer(); return c == null ? null : c.getSkillByID("$bvvar{modId}.skill.skirk_serpents_subtlety"); }
	function hasMeleeWeapon() { local p = this.getPassive(); return p != null && p.hasMeleeWeapon(); }
	function isUsable() { local p = this.getPassive(); return this.skill.isUsable() && this.hasMeleeWeapon() && p != null && p.getCount() >= 3; }
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor(); local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true) && owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}
	function getTargets( _user, _targetTile ) { return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true)); }
	function getTooltip()
	{
		local ret = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", text = this.getCostString() }, { id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.skirk_havoc_ruin.tooltip.damage}" }, { id = 5, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.skirk_havoc_ruin.tooltip.resource}" }];
		if (!this.isUsable()) ret.push({ id = 6, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.skirk_havoc_ruin.tooltip.unusable}" });
		return ret;
	}
	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local passive = this.getPassive(); local snapshot = passive.getCount(); local targets = this.getTargets(_user, _targetTile);
		if (snapshot < 3 || targets.len() == 0) return false;
		this.m.Snapshot = snapshot; passive.clear();
		foreach (target in targets)
		{
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "skirk_abyss_impact");
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, { WeaponDamageMult = 1.0 + 0.30 * snapshot, ArmorDamageMult = 1.50, DirectDamageAdd = 0.05 * snapshot, HitChance = 30, IgnoreDistance = true, IgnoreShield = true });
			if (result != null && result.Applied && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target)) ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, target, 5 * snapshot, { Source = "fixed_damage", IgnoreArmor = true });
		}
		local phase = passive.getPhaseEffect(); if (phase != null) phase.deactivate();
		return true;
	}
	function onCombatStarted() { this.m.Snapshot = 0; }
	function onCombatFinished() { this.m.Snapshot = 0; this.skill.onCombatFinished(); }
});
