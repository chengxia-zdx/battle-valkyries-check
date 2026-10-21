this.hakurei_reimu_spirit_power_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0, MaxCount = 4 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.hakurei_reimu_spirit_power";
		this.m.Name = "$bv{effect.hakurei_reimu_spirit_power.name}";
		this.m.Description = "$bv{effect.hakurei_reimu_spirit_power.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/hakurei_reimu_inborn_intuition.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/hakurei_reimu_inborn_intuition_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
		this.m.MaxCount = 4;
	}

	function configure( _maxCount )
	{
		this.m.MaxCount = this.Math.max(1, _maxCount);
		this.setCount(this.m.Count);
		return this;
	}

	function getCount() { return this.Math.max(0, this.m.Count); }
	function getMaxCount() { return this.Math.max(1, this.m.MaxCount); }
	function setCount( _count ) { this.m.Count = this.Math.min(this.getMaxCount(), this.Math.max(0, _count)); return this.m.Count; }
	function addCount( _amount = 1 ) { return this.setCount(this.m.Count + _amount); }
	function consume( _amount )
	{
		if (_amount <= 0 || this.getCount() < _amount) return false;
		this.m.Count -= _amount;
		return true;
	}
	function isReady() { return this.getCount() >= this.getMaxCount(); }
	function clear() { return this.setCount(0); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.hakurei_reimu_spirit_power.tooltip.count_prefix}" + this.getCount() + " / " + this.getMaxCount() },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = this.isReady() ? "$bv{effect.hakurei_reimu_spirit_power.tooltip.ready}" : "$bv{effect.hakurei_reimu_spirit_power.tooltip.charging}" }
		];
	}

	function onCombatFinished()
	{
		this.clear();
		this.skill.onCombatFinished();
	}
});
