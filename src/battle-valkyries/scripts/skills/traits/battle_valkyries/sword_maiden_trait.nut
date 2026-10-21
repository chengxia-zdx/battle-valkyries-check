this.sword_maiden_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "sword_maiden" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += 2;
		_properties.IsAffectedByNight = false;
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_properties == null || _target == null || !::$bvvar{namespace}.isDirectAttack(_skill)) return;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || _target.isAlliedWith(actor) || !::$bvvar{namespace}.isSwordMaidenGoblin(_target)) return;
		_properties.MeleeSkill += 15;
		_properties.RangedSkill += 15;
		_properties.DamageTotalMult *= 1.25;
	}
});
