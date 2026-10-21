this.saber_mana_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0, MaxCount = 4 },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.saber_mana";
		this.m.Name = "$bv{effect.saber_mana.name}";
		this.m.Description = "$bv{effect.saber_mana.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/saber_invisible_air.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/saber_invisible_air_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Count = 0;
		this.m.IsStacking = false;
	}
	function getCount() { return this.Math.max(0, this.Math.min(this.m.MaxCount, this.m.Count)); }
	function setCount( _value ) { this.m.Count = this.Math.max(0, this.Math.min(this.m.MaxCount, _value)); return this.m.Count; }
	function addCount( _value = 1 ) { return this.setCount(this.m.Count + _value); }
	function clear() { this.m.Count = 0; }
	function getTooltip()
	{
		return [
			{ id=1,type="title",text=this.getName() }, { id=2,type="description",text=this.getDescription() },
			{ id=3,type="text",icon="ui/icons/fatigue.png",text="$bv{effect.saber_mana.tooltip.count_prefix}"+this.getCount()+"/"+this.m.MaxCount+"$bv{effect.saber_mana.tooltip.count_suffix}" },
			{ id=4,type="text",icon="ui/icons/special.png",text="$bv{effect.saber_mana.tooltip.gain}" }
		];
	}
	function onCombatStarted()
    {
        local actor=this.getContainer().getActor();
        local count="getSaberStartingMana" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getSaberStartingMana(actor)
            : (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(actor)) ? 2 : 1);
        this.setCount(count);
    }
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
