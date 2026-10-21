this.morgan_charisma_effect <- this.inherit("$bvvar{privateFolder}/skills/core/morgan_timed_effect", {
	function create()
	{
		this.morgan_timed_effect.create();
		this.m.ID = "$bvvar{modId}.effects.morgan_charisma";
		this.m.Name = "$bv{effect.morgan_charisma.name}"; this.m.Description = "$bv{effect.morgan_charisma.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/morgan_lake_grace.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/morgan_lake_grace_sw.png";
		this.m.IconMini = "status_effect_34_mini";
		this.m.Overlay = "status_effect_34";
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill != null && _skill.isAttack()) _properties.DamageTotalMult *= 1.2;
	}
});
