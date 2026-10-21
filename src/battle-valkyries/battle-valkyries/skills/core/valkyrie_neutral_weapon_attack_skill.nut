// Ephemeral, non-serialized attack carrier used by follow-up helpers.  It is
// intentionally not added to the skill container, so no concrete weapon
// active or originating managed passive contributes caller-specific hooks.
this.valkyrie_neutral_weapon_attack_skill <- this.inherit("scripts/skills/skill", {
	m = {
		DamageType = null,
		FallbackDamageType = null
	},

	function create()
	{
		this.m.ID = "$bvvar{modId}.skill.neutral_weapon_attack.unconfigured";
		this.m.Name = "$bv{skill.neutral_weapon_attack.name}";
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsTargetingActor = true;
		this.m.IsRangeLimitsEnforced = false;
		this.m.IsUsingHitchance = true;
		this.m.IsShieldRelevant = true;
		this.m.IsShowingProjectile = false;
		this.m.Item = null;
		this.m.InjuriesOnBody = null;
		this.m.FallbackDamageType = ::MSU.Class.DamageType();
		this.m.FallbackDamageType.setSkill(this);
		this.m.DamageType = this.m.FallbackDamageType;
	}

	function isSameWeaponItem( _first, _second )
	{
		if (_first == _second) return true;
		try { return ::MSU.isEqual(_first, _second); } catch (e) { return false; }
	}

	function isUsableDamageType( _damageType )
	{
		if (_damageType == null) return false;
		// DamageType is lazily initialized. Calling len() initializes normal
		// attack types, while a DamageType bound to a passive remains empty.
		try { return _damageType.len() > 0; } catch (e) { return false; }
	}

	function findWeaponDamageType( _actor, _weapon, _sourceSkill )
	{
		local skills = null;
		try { skills = _actor.getSkills().m.Skills; } catch (e) { skills = null; }
		if (skills != null)
		{
			foreach (candidate in skills)
			{
				if (candidate == null || candidate == this) continue;
				local isAttack = false;
				local item = null;
				try
				{
					isAttack = candidate.isAttack();
					item = candidate.getItem();
				}
				catch (e)
				{
					continue;
				}
				if (!isAttack || !this.isSameWeaponItem(item, _weapon)) continue;

				local damageType = null;
				try { damageType = candidate.getDamageType(); } catch (e) { damageType = null; }
				if (this.isUsableDamageType(damageType)) return damageType;
			}
		}

		local sourceDamageType = null;
		try { sourceDamageType = _sourceSkill == null ? null : _sourceSkill.getDamageType(); } catch (e) { sourceDamageType = null; }
		return this.isUsableDamageType(sourceDamageType) ? sourceDamageType : this.m.FallbackDamageType;
	}

	function configureValkyrieNeutralWeaponAttack( _actor, _weapon, _isRanged, _runtimeID, _sourceSkill = null )
	{
		this.setContainer(_actor.getSkills());
		this.m.ID = _runtimeID;
		// Battle Brothers and Legends both treat a skill Item as a WeakTableRef.
		// In particular, Legends calls m.Item.isNull() during attack resolution.
		this.m.Item = ::WeakTableRef(_weapon);
		this.m.DamageType = this.findWeaponDamageType(_actor, _weapon, _sourceSkill);
		local sourceName = null;
		try { sourceName = _sourceSkill == null ? null : _sourceSkill.getName(); } catch (e) { sourceName = null; }
		this.m.Name = sourceName != null && typeof sourceName == "string" && sourceName.len() > 0
			? sourceName : "$bv{skill.neutral_weapon_attack.name}";
		try
		{
			if (_sourceSkill != null && typeof _sourceSkill.m.KilledString == "string" && _sourceSkill.m.KilledString.len() > 0)
			{
				this.m.KilledString = _sourceSkill.m.KilledString;
			}
		}
		catch (e)
		{
		}
		this.m.IsRanged = _isRanged;
		this.m.DirectDamageMult = _weapon.m.DirectDamageMult;
		this.m.MinRange = _weapon.getRangeMin();
		this.m.MaxRange = _weapon.getRangeMax();
		return this;
	}

	function getItem()
	{
		if (this.m.Item == null || this.m.Item.isNull()) return null;
		return this.m.Item.get();
	}

	function getDamageType()
	{
		return this.m.DamageType;
	}

	function getWeightedRandomDamageType()
	{
		local rolled = null;
		try { rolled = this.m.DamageType == null ? null : this.m.DamageType.roll(); } catch (e) { rolled = null; }
		if (rolled != null) return rolled;

		// A malformed or modded source DamageType must never let a successful
		// follow-up reach the engine with a null damage-type index.
		this.m.DamageType = this.m.FallbackDamageType;
		return this.m.FallbackDamageType.roll();
	}
});
