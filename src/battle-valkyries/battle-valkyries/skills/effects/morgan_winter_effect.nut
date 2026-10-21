this.morgan_winter_effect <- this.inherit("$bvvar{privateFolder}/skills/core/morgan_timed_effect", {
	function create()
	{
		this.morgan_timed_effect.create();
		this.m.ID = "$bvvar{modId}.effects.morgan_winter";
		this.m.Name = "$bv{effect.morgan_winter.name}"; this.m.Description = "$bv{effect.morgan_winter.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/morgan_holy_lance.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/morgan_holy_lance_sw.png";
		this.m.IconMini = "status_effect_111_mini";
		this.m.Overlay = "status_effect_111";
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill != null && _skill.isAttack()) _properties.DamageTotalMult *= 0.85;
	}
});
