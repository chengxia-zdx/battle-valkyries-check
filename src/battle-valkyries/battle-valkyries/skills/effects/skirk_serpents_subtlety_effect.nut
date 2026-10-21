this.skirk_serpents_subtlety_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.skirk_serpents_subtlety";
		this.m.Name = "$bv{effect.skirk_serpents_subtlety.name}";
		this.m.Description = "$bv{effect.skirk_serpents_subtlety.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/skirk_abyss_swordsmanship.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/skirk_abyss_swordsmanship_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount() { return this.Math.max(0, this.m.Count); }
	function setCount( _value ) { this.m.Count = this.Math.min(6, this.Math.max(0, _value)); return this.m.Count; }
	function clear() { return this.setCount(0); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.skirk_serpents_subtlety.tooltip.count_prefix}" + this.getCount() + "$bv{effect.skirk_serpents_subtlety.tooltip.count_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.skirk_serpents_subtlety.tooltip.gain}" }
		];
	}

	function onCombatStarted() { this.clear(); }
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
