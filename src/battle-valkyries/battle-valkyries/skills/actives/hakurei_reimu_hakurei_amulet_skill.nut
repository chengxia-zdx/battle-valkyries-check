this.hakurei_reimu_hakurei_amulet_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { HitChanceBonus = 20, DamageMin = 55, DamageMax = 75, ArmorDamageMult = 0.80, DirectDamage = 0.35 },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.hakurei_reimu_hakurei_amulet.killed}";
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
		this.m.DirectDamageMult = this.m.DirectDamage;
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition == null || !("Spec" in _definition)) return;
		local spec = _definition.Spec;
		if ("ActionPointCost" in spec) this.m.ActionPointCost = spec.ActionPointCost;
		if ("FatigueCost" in spec) this.m.FatigueCost = spec.FatigueCost;
		if ("MinRange" in spec) this.m.MinRange = spec.MinRange;
		if ("MaxRange" in spec) this.m.MaxRange = spec.MaxRange;
		if ("HitChance" in spec) this.m.HitChanceBonus = spec.HitChance;
		if ("DamageMin" in spec) this.m.DamageMin = spec.DamageMin;
		if ("DamageMax" in spec) this.m.DamageMax = spec.DamageMax;
		if ("ArmorDamageMult" in spec) this.m.ArmorDamageMult = spec.ArmorDamageMult;
		if ("DirectDamage" in spec) { this.m.DirectDamage = spec.DirectDamage; this.m.DirectDamageMult = spec.DirectDamage; }
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill != this || _properties == null) return;
		_properties.RangedSkill += this.m.HitChanceBonus;
		_properties.DamageRegularMin = this.m.DamageMin;
		_properties.DamageRegularMax = this.m.DamageMax;
		_properties.DamageRegularMult = 1.0;
		_properties.DamageArmorMult = this.m.ArmorDamageMult;
		_properties.DamageDirectAdd = 0.0;
		_properties.DamageDirectMeleeAdd = 0.0;
		_properties.DamageDirectRangedAdd = 0.0;
		_properties.DamageDirectMult = 1.0;
		_properties.DamageTotalMult = 1.0;
		_properties.MeleeDamageMult = 1.0;
		_properties.RangedDamageMult = 1.0;
		_properties.DamageAdditionalWithEachTile = 0.0;
		_properties.HitChanceAdditionalWithEachTile = 0.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true)
			&& owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function applySeal( _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return;
		local c = _target.getSkills();
		local effect = c.getSkillByID("$bvvar{modId}.effects.hakurei_reimu_sealing_charm");
		if (effect != null) effect.onRefresh();
		else c.add(::new("$bvvar{privateFolder}/skills/effects/hakurei_reimu_sealing_charm_effect"));
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "TargetResolved" || !("Skill" in _event)
			|| !::$bvvar{namespace}.sameValkyrieCombatObject(::$bvvar{namespace}.makeValkyrieCombatWeakRef(this), _event.Skill, ::$bvvar{namespace}.getValkyrieCombatObjectID(this))
			|| !("Hit" in _event) || !_event.Hit || ("Nullified" in _event && _event.Nullified) || !("Target" in _event)) return;
		this.applySeal(_event.Target);
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || _targetTile == null || !_targetTile.IsOccupiedByActor || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		return this.attackEntity(_user, _targetTile.getEntity(), false);
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.hakurei_reimu_hakurei_amulet.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.hakurei_reimu_hakurei_amulet.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.hakurei_reimu_hakurei_amulet.tooltip.direct}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.hakurei_reimu_hakurei_amulet.tooltip.seal}" }
		];
	}
});
