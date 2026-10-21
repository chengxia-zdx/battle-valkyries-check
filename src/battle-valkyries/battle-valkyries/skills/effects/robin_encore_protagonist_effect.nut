this.robin_encore_protagonist_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.robin_encore_protagonist";
		this.m.Name = "$bv{effect.robin_encore_protagonist.name}";
		this.m.Description = "$bv{effect.robin_encore_protagonist.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/robin_encore_for_you.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/robin_encore_for_you_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
	}
	function onUpdate( _properties ) { _properties.DamageTotalMult *= 1.25; }
	function onRefresh() {}
	function onTurnEnd() { this.removeSelf(); }
	function onDeath( _fatalityType ) { this.removeSelf(); }
});
