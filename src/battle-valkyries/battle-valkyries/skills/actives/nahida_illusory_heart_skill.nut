this.nahida_illusory_heart_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Used = false, Radius = 4, Duration = 3, MarkExtension = 1, SharedResolvePercent = 0.20, SharedResolveCap = 20, AllyDamagePercent = 0.50, KarmaDamageMult = 1.20 },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition == null || !("Spec" in _definition)) return;
		local spec = _definition.Spec;
		foreach (key, target in {
			ActionPointCost = "ActionPointCost", FatigueCost = "FatigueCost", Radius = "Radius", Duration = "Duration",
			MarkExtension = "MarkExtension", SharedResolvePercent = "SharedResolvePercent", SharedResolveCap = "SharedResolveCap",
			AllyDamagePercent = "AllyDamagePercent", KarmaDamageMult = "KarmaDamageMult"
		}) if (key in spec) this.m[target] = spec[key];
	}

	function getPassive()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "nahida_tri_karma_purification");
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.Used && this.getPassive() != null;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || ! _user.isPlacedOnMap()) return false;
		local passive = this.getPassive();
		if (passive == null || !passive.beginShrine(_user.getTile(), this.m)) return false;
		this.m.Used = true;
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "nahida_shrine", { Scale = 1.0, EndScale = 1.28 });
		try { this.spawnIcon("status_effect_34", _user.getTile()); } catch (e) {}
		return true;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_illusory_heart.tooltip.domain}" },
			{ id = 5, type = "text", icon = "ui/icons/bravery.png", text = "$bv{skill.nahida_illusory_heart.tooltip.resolve}" },
			{ id = 6, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.nahida_illusory_heart.tooltip.damage}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_illusory_heart.tooltip.karma}" }
		];
		if (this.m.Used) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.nahida_illusory_heart.tooltip.spent}" });
		return ret;
	}

	function onCombatStarted() { this.m.Used = false; }
	function onCombatFinished() { this.m.Used = false; this.skill.onCombatFinished(); }
});
