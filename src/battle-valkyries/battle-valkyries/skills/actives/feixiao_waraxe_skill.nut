this.feixiao_waraxe_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { UsedThisRound = false },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxRangeBonus = 0;
		this.m.UsedThisRound = false;
	}

	function getPassive()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("feixiao_thunderhunt"));
	}

	function hasMeleeWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local weapon = null;
		try { weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isUsable() { return this.skill.isUsable() && !this.m.UsedThisRound && this.hasMeleeWeapon(); }

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, target, this.m.MaxRange, true)
			&& actor.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function isOwnWeaponAttack( _skill, _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target);
		return policy != null && "SourceSkillRef" in policy && ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this;
	}

	function onAnySkillUsed( _skill, _target, _properties ) { if (_properties != null && this.isOwnWeaponAttack(_skill, _target)) _properties.MeleeSkill += 20; }

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() }, { id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.feixiao_waraxe.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.feixiao_waraxe.tooltip.armor}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.feixiao_waraxe.tooltip.followup}" }
		];
		if (this.m.UsedThisRound) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.feixiao_waraxe.tooltip.spent}" });
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || this.m.UsedThisRound || !this.hasMeleeWeapon() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, { WeaponDamageMult = 1.0, ArmorDamageMult = 1.25, DirectDamageAdd = 0.0, HitChance = 20, IgnoreDistance = true, IgnoreShield = true });
		if (result == null || !("Applied" in result) || !result.Applied) return false;
		if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "feixiao_axe", result);
		this.m.UsedThisRound = true;
		local passive = this.getPassive();
		if (passive != null) passive.executeThunderhunt(target, false);
		return true;
	}

	function onValkyrieCombatEvent( _event ) { if (_event != null && "Type" in _event && _event.Type == "NewRound") this.m.UsedThisRound = false; }
	function onCombatStarted() { this.m.UsedThisRound = false; }
	function onCombatFinished() { this.m.UsedThisRound = false; this.skill.onCombatFinished(); }
});
