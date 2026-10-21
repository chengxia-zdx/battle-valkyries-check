this.jeanne_revelation_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0, MaxCount = 4 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_revelation";
		this.m.Name = "$bv{effect.jeanne_revelation.name}";
		this.m.Description = "$bv{effect.jeanne_revelation.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_revelation_holy_banner.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_revelation_holy_banner_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount() { return this.Math.max(0, this.Math.min(this.m.MaxCount, this.m.Count)); }

	function setCount( _value )
	{
		local old = this.getCount();
		this.m.Count = this.Math.max(0, this.Math.min(this.m.MaxCount, _value));
		if (old < this.m.MaxCount && this.m.Count == this.m.MaxCount)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			try { if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_56", actor.getTile()); } catch (e) {}
		}
		try
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null) actor.setDirty(true);
		}
		catch (e) {}
		return this.m.Count;
	}

	function addCount( _value = 1 ) { return this.setCount(this.getCount() + _value); }
	function consumeCount( _value ) { if (this.getCount() < _value) return false; this.setCount(this.getCount() - _value); return true; }
	function clear() { return this.setCount(0); }
	function getName() { return "$bv{effect.jeanne_revelation.name_prefix}" + this.getCount() + "/" + this.m.MaxCount; }
	function getStartingRevelation()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return ::$bvvar{namespace}.getJeanneStartingRevelation(actor);
	}

	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_revelation.tooltip.current_prefix}" + this.getCount() + "/4" + "$bv{effect.jeanne_revelation.tooltip.current_suffix}" },
			{ id=4, type="text", icon="ui/icons/action_points.png", text="$bv{effect.jeanne_revelation.tooltip.gain_prefix}" + this.getStartingRevelation() + "$bv{effect.jeanne_revelation.tooltip.gain_suffix}" },
			{ id=5, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_revelation.tooltip.costs}" }
		];
	}

	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
