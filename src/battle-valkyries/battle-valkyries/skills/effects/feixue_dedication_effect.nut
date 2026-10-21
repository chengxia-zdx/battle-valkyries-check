this.feixue_dedication_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0 },
	function create() { this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.feixue_dedication"; this.m.Name = "$bv{effect.feixue_dedication.name}"; this.m.Description = "$bv{effect.feixue_dedication.description}"; this.m.Icon = "skills/$bvvar{iconPrefix}/feixue_snowstep.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/feixue_snowstep_sw.png"; this.m.IconMini <- "status_effect_34_mini"; this.m.IsStacking = false; this.m.Count = 0; }
	function getCount() { return this.Math.max(0, this.m.Count); }
	function setCount( _value ) { this.m.Count = this.Math.min(3, this.Math.max(0, _value)); return this.m.Count; }
	function addCount( _value = 1 ) { return this.setCount(this.getCount() + _value); }
	function clear() { return this.setCount(0); }
	function getTooltip() { return [{ id=1,type="title",text=this.getName() },{ id=2,type="description",text=this.getDescription() },{ id=3,type="text",icon="ui/icons/special.png",text="$bv{effect.feixue_dedication.tooltip.count_prefix}" + this.getCount() + "$bv{effect.feixue_dedication.tooltip.count_suffix}" }]; }
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
