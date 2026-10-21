this.jinhsi_incandescence_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jinhsi_incandescence";
		this.m.Name = "$bv{effect.jinhsi_incandescence.name}";
		this.m.Description = "$bv{effect.jinhsi_incandescence.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jinhsi_edict_guard.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jinhsi_edict_guard_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount() { return this.Math.max(0, this.m.Count); }
	function setCount( _count ) { this.m.Count = this.Math.min(6, this.Math.max(0, _count)); return this.m.Count; }
	function addCount( _amount = 1 ) { return this.setCount(this.m.Count + _amount); }
	function clear() { return this.setCount(0); }
	function isReady() { return this.getCount() >= 6; }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.jinhsi_incandescence.tooltip.count_prefix}" + this.getCount() + "$bv{effect.jinhsi_incandescence.tooltip.count_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.jinhsi_incandescence.tooltip.ready}" }
		];
	}

	function onCombatStarted() { this.clear(); }
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
