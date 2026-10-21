this.valkyrie_runtime_skill <- this.inherit("scripts/skills/skill", {
	m = {
		BVSkillKey = null,
		BVSkillLifetime = null,
		BVTransientOwners = null,
		IsBattleValkyriesManagedSkill = true,
		DamageType = null
	},

	function create()
	{
		if (this.m.DamageType == null)
		{
			this.m.DamageType = ::MSU.Class.DamageType();
			this.m.DamageType.setSkill(this);
		}

		this.m.BVTransientOwners = {};
		this.m.IsSerialized = false;
	}

	function bindValkyrieSkill( _key, _definition )
	{
		if (_definition == null || this.m.Container != null)
		{
			throw "Invalid Battle Valkyries runtime bind for key=" + _key;
		}

		this.m.BVSkillKey = _key;
		this.m.BVSkillLifetime = _definition.Lifetime;
		this.m.ID = ::$bvvar{namespace}.getValkyrieSkillRuntimeID(_key);
		this.m.Name = _definition.Name;
		this.m.Description = _definition.Description;
		this.m.Icon = ::$bvvar{namespace}.getValkyrieSkillIconPath(_definition, false);
		this.m.IconDisabled = ::$bvvar{namespace}.getValkyrieSkillIconPath(_definition, true);
		this.onValkyrieSkillBound(_definition);
		return this;
	}

	function getBattleValkyriesSkillKey()
	{
		return this.m.BVSkillKey;
	}

	function getBattleValkyriesSkillLifetime()
	{
		return this.m.BVSkillLifetime;
	}

	function isBattleValkyriesManagedSkill()
	{
		return this.m.IsBattleValkyriesManagedSkill;
	}

	// Managed runtime skills use the service's entitlement/owner bookkeeping,
	// not Stack Based Skills' serialized stack bookkeeping. Their private script
	// paths cannot be reconstructed through SBS' ClassNameHash lookup.
	function removeSelf()
	{
		this.m.IsGarbage = true;
	}

	// See valkyrie_effect_skill: Legends' optional tooltip extension invokes
	// this callback unconditionally while inspecting another actor.
	function onOtherActorTooltip( _tooltip, _targetActor )
	{
	}

	function onValkyrieSkillBound( _definition )
	{
	}

	function onValkyrieCombatEvent( _event )
	{
	}

	function isValkyrieWeaponSkillPolicyOptOut()
	{
		return false;
	}

	function getValkyrieWeaponSkillPolicy( _usedSkill )
	{
		return null;
	}

	function allowsValkyrieRangedWeaponSkillPolicy( _usedSkill )
	{
		return false;
	}

	function commitValkyrieWeaponSkillPolicy( _token, _context )
	{
	}

	function getValkyrieAttackDefensePolicy( _usedSkill )
	{
		return null;
	}

	function consumeValkyrieAttackDefensePolicy( _token, _context )
	{
	}

	function getValkyrieAttackNullificationPolicy( _usedSkill, _attacker )
	{
		return null;
	}

	function consumeValkyrieAttackNullificationPolicy( _token, _context )
	{
	}

	function getDamageType()
	{
		return this.m.DamageType;
	}

	function getWeightedRandomDamageType()
	{
		return this.m.DamageType == null ? null : this.m.DamageType.roll();
	}

	function hasTransientOwner( _ownerToken )
	{
		return typeof _ownerToken == "string" && _ownerToken.len() > 0 && _ownerToken in this.m.BVTransientOwners;
	}

	function addTransientOwner( _ownerToken )
	{
		if (typeof _ownerToken != "string" || _ownerToken.len() == 0 || _ownerToken in this.m.BVTransientOwners)
		{
			return false;
		}

		this.m.BVTransientOwners[_ownerToken] <- true;
		return true;
	}

	function removeTransientOwner( _ownerToken )
	{
		if (!this.hasTransientOwner(_ownerToken))
		{
			return false;
		}

		delete this.m.BVTransientOwners[_ownerToken];
		return true;
	}

	function getTransientOwnerCount()
	{
		return this.m.BVTransientOwners.len();
	}
});
