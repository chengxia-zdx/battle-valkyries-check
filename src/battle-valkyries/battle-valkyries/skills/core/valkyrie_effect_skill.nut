this.valkyrie_effect_skill <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		if (!("DamageType" in this.m)) this.m.DamageType <- null;
		if (this.m.DamageType == null)
		{
			this.m.DamageType = ::MSU.Class.DamageType();
			this.m.DamageType.setSkill(this);
		}
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}

	function isBattleValkyriesManagedCombatEffect()
	{
		return true;
	}

	// Stack Based Skills reconstructs a skill from ClassNameHash before removal.
	// Private runtime scripts are not present in that public script lookup, so
	// combat cleanup (including retreat) would try to instantiate a null path.
	// These effects are non-serialized and never use SBS stack ownership; the
	// vanilla removal operation for them is simply to mark them for collection.
	function removeSelf()
	{
		this.m.IsGarbage = true;
	}

	// Jimmy's Legends tooltips dispatch this hook to every skill on the hovered
	// actor. Private runtime effects are not covered by its public skill hooks,
	// so they must provide the optional no-op callback themselves.
	function onOtherActorTooltip( _tooltip, _targetActor )
	{
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
});
