this.nahida_akara_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { DamageMin = 55, DamageMax = 75 },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.nahida_akara.killed}";
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
		this.m.HitChanceBonus = 10;
		this.m.DirectDamageMult = 0.20;
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
		if ("DirectDamage" in spec) this.m.DirectDamageMult = spec.DirectDamage;
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill != this || _properties == null) return;
		_properties.RangedSkill += this.m.HitChanceBonus;
		_properties.DamageRegularMin = this.m.DamageMin;
		_properties.DamageRegularMax = this.m.DamageMax;
		_properties.DamageRegularMult = 1.0;
		_properties.DamageArmorMult = 1.0;
		_properties.DamageDirectAdd = 0.0;
		_properties.DamageDirectMeleeAdd = 0.0;
		_properties.DamageDirectRangedAdd = 0.0;
		_properties.DamageDirectMult = 1.0;
		_properties.DamageTotalMult = 1.0;
		_properties.MeleeDamageMult = 1.0;
		_properties.RangedDamageMult = 1.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true)
			&& owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || _targetTile == null || !_targetTile.IsOccupiedByActor || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "nahida_akara", { Scale = 0.78, EndScale = 1.02 });
		return this.attackEntity(_user, target, false);
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.nahida_akara.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.nahida_akara.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.nahida_akara.tooltip.direct}" }
		];
	}
});
