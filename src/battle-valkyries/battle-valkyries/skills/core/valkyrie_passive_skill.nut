this.valkyrie_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_runtime_skill", {
	function create()
	{
		this.valkyrie_runtime_skill.create();
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = ::$bvvar{namespace}.getValkyriePassiveSkillOrder();
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function ignoresShieldFor( _usedSkill )
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
});
