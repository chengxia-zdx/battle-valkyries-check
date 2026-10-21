this.feixiao_terraverge_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 35;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxRangeBonus = 0;
	}

	function getAureusEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.feixiao_flying_aureus");
	}

	function ensureAureusEffect()
	{
		local effect = this.getAureusEffect();
		if (effect != null) return effect;
		local c = this.getContainer();
		if (c == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/feixiao_flying_aureus_effect");
		c.add(effect);
		return effect;
	}

	function hasMeleeWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local weapon = null;
		try { weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isUsable()
	{
		local effect = this.ensureAureusEffect();
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

	function isOwnWeaponAttack( _skill, _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target);
		return policy != null && "SourceSkillRef" in policy && ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this;
	}

	function onAnySkillUsed( _skill, _target, _properties ) { if (_properties != null && this.isOwnWeaponAttack(_skill, _target)) _properties.MeleeSkill += 30; }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() }, { id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.feixiao_terraverge.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.feixiao_terraverge.tooltip.armor}" }, { id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.feixiao_terraverge.tooltip.execute}" }
		];
	}

	function getBestArmoredPart( _target )
	{
		local head = 0; local body = 0;
		try { head = _target.getArmor(this.Const.BodyPart.Head); body = _target.getArmor(this.Const.BodyPart.Body); } catch (e) { return null; }
		if (head <= 0 && body <= 0) return null;
		if (head == body) return this.Math.rand(0, 1) == 0 ? this.Const.BodyPart.Head : this.Const.BodyPart.Body;
		return head >= body ? this.Const.BodyPart.Head : this.Const.BodyPart.Body;
	}

	function makeAdaptiveSpec( _target )
	{
		local part = this.getBestArmoredPart(_target);
		if (part != null) return { WeaponDamageMult = 0.30, ArmorDamageMult = 2.50, DirectDamageOverride = 0.0, ForcedBodyPart = part, HitChance = 30, IgnoreDistance = true, IgnoreShield = true };
		return { WeaponDamageMult = 0.30, ArmorDamageMult = 1.0, DirectDamageAdd = 0.0, PostFixedHP = 5, HitChance = 30, IgnoreDistance = true, IgnoreShield = true };
	}

	function onUse( _user, _targetTile )
	{
		local effect = this.ensureAureusEffect();
		if (_user == null || effect == null || !effect.isReady() || !this.hasMeleeWeapon() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		effect.clear();
		for (local i = 0; i < 6; i++)
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(target)) return true;
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, this.makeAdaptiveSpec(target));
			if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, i % 2 == 0 ? "feixiao_axe" : "feixiao_lance", result);
		}
		if (!::$bvvar{namespace}.isActorDeadOrDying(target))
			::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, { WeaponDamageMult = 1.0, ArmorDamageMult = 1.50, DirectDamageAdd = 0.30, PostFixedHP = 20, HitChance = 30, IgnoreDistance = true, IgnoreShield = true });
		return true;
	}

	function onCombatFinished() { this.skill.onCombatFinished(); }
});
