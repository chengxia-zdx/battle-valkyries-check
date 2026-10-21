// Character-specific attack runner; never borrows a weapon active or its damage.
this.morgan_spell_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { SpellBase = 80, ResolveFactor = 0.5, SpellArmor = 1.5, SpellPierce = 0.35, SpellHit = 25, CastResolve = null, AreaMultiplier = 1.0, ImpactTheme = "morgan_lance_impact" },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true;
		this.m.IsAttack = true; this.m.IsRanged = true; this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = true; this.m.IsShieldRelevant = false;
		this.m.IsShowingProjectile = false; this.m.IsDoingAttackMove = false;
		this.m.IsVisibleTileNeeded = true; this.m.IsIgnoredAsAOO = true;
		this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 99;
		this.m.DirectDamageMult = this.m.SpellPierce;
	}
	function getPassive()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "morgan_from_worlds_end");
	}
	function onVerifyTarget( _origin, _tile )
	{
		if (_tile == null || !_tile.IsOccupiedByActor || !this.skill.onVerifyTarget(_origin, _tile)) return false;
		local actor = this.getContainer().getActor();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, _tile.getEntity(), this.m.MaxRange, true)
			&& _origin.getDistanceTo(_tile) >= this.m.MinRange
			&& _origin.hasLineOfSightTo(_tile, this.m.MaxRange);
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill != this) return;
		local resolve = this.m.CastResolve == null ? this.getContainer().getActor().getCurrentProperties().getBravery() : this.m.CastResolve;
		local damage = this.Math.floor((this.m.SpellBase + resolve * this.m.ResolveFactor) * this.m.AreaMultiplier);
		_properties.DamageRegularMin = damage; _properties.DamageRegularMax = damage;
		_properties.DamageRegularMult = 1.0; _properties.DamageArmorMult = this.m.SpellArmor;
		_properties.DamageDirectMult = 1.0; _properties.DamageDirectAdd = 0.0;
		_properties.DamageDirectMeleeAdd = 0.0; _properties.DamageDirectRangedAdd = 0.0;
		_properties.RangedDamageMult = 1.0;
		_properties.DamageAdditionalWithEachTile = 0.0; _properties.HitChanceAdditionalWithEachTile = 0.0;
		_properties.RangedSkill += this.m.SpellHit;
		_properties.HitChance[::Const.BodyPart.Head] = 0; _properties.HitChance[::Const.BodyPart.Body] = 100;
		_properties.HitChanceMult[::Const.BodyPart.Body] = 1.0;
	}
	function strike( _user, _target, _multiplier )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return false;
		this.m.AreaMultiplier = _multiplier;
		::$bvvar{namespace}.playValkyrieVisual(this, _target, this.m.ImpactTheme);
		local hit = false;
		try { hit = this.attackEntity(_user, _target, false); }
		catch (e) { this.m.AreaMultiplier = 1.0; this.m.CastResolve = null; throw e; }
		this.m.AreaMultiplier = 1.0;
		if (hit && !::$bvvar{namespace}.isActorDeadOrDying(_target))
			::$bvvar{namespace}.applyMorganEffect(_target, "morgan_winter", _user);
		return hit;
	}
});
