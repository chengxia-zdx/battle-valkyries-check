this.jinhsi_illuminous_epiphany_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { PrimaryTargetID = null },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxRangeBonus = 0;
	}

	function getIncandescenceEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.jinhsi_incandescence");
	}

	function ensureIncandescenceEffect()
	{
		local effect = this.getIncandescenceEffect();
		if (effect != null) return effect;
		local c = this.getContainer();
		if (c == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/jinhsi_incandescence_effect");
		c.add(effect);
		return effect;
	}

	function hasMeleeWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getItems() == null) return false;
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isOwnWeaponAttack( _skill, _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target);
		return policy != null && "SourceSkillRef" in policy && ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this;
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_properties == null || !this.isOwnWeaponAttack(_skill, _target)) return;
		_properties.MeleeSkill += _target != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(_target) == this.m.PrimaryTargetID ? 30 : 20;
	}

	function isUsable()
	{
		local effect = this.ensureIncandescenceEffect();
		return this.skill.isUsable() && this.hasMeleeWeapon() && effect != null && effect.isReady();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, target, this.m.MaxRange, true)
			&& actor.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function getTargets( _user, _targetTile )
	{
		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true);
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, tiles);
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.primary}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.area}" }
		];
		local effect = this.ensureIncandescenceEffect();
		if (effect == null || !effect.isReady()) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.jinhsi_illuminous_epiphany.tooltip.not_ready}" });
		return ret;
	}

	function attackTarget( _user, _target, _isPrimary, _actionToken )
	{
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _target, "jinhsi_dragon", { Scale = _isPrimary ? 0.96 : 0.68, EndScale = _isPrimary ? 1.16 : 0.88 });
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, _target, {
			WeaponDamageMult = _isPrimary ? 2.0 : 1.2,
			ArmorDamageMult = _isPrimary ? 1.5 : 1.25,
			DirectDamageAdd = _isPrimary ? 0.30 : 0.15,
			HitChance = _isPrimary ? 30 : 20,
			IgnoreDistance = true, IgnoreShield = true, ParentActionToken = _actionToken
		});
		if (_isPrimary && result != null && "Hit" in result && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, _target, 40, { ActionToken = _actionToken, Source = "jinhsi_illuminous_epiphany_fixed" });
		}
	}

	function onUse( _user, _targetTile )
	{
		local effect = this.getIncandescenceEffect();
		if (_user == null || effect == null || !effect.isReady() || !this.hasMeleeWeapon() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local primary = _targetTile.getEntity();
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "jinhsi_incarnation_cast");
		local targets = this.getTargets(_user, _targetTile);
		if (targets.len() == 0) return false;
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
		local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
		this.m.PrimaryTargetID <- ::$bvvar{namespace}.getValkyrieCombatObjectID(primary);
		this.attackTarget(_user, primary, true, actionToken);
		foreach (target in targets)
		{
			if (::$bvvar{namespace}.getValkyrieCombatObjectID(target) == this.m.PrimaryTargetID || ::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			this.attackTarget(_user, target, false, actionToken);
		}
		effect.clear();
		this.m.PrimaryTargetID <- null;
		return true;
	}

	function onCombatFinished() { this.m.PrimaryTargetID <- null; this.skill.onCombatFinished(); }
});
