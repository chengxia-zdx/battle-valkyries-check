this.feixiao_flying_aureus_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.feixiao_flying_aureus";
		this.m.Name = "$bv{effect.feixiao_flying_aureus.name}";
		this.m.Description = "$bv{effect.feixiao_flying_aureus.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/feixiao_flying_aureus_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/feixiao_flying_aureus_effect_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount() { return this.Math.max(0, this.m.Count); }
	function refreshDisplay()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return;
		try { actor.setDirty(true); } catch (e) {}
		try
		{
			if ("scheduleActiveValkyrieTacticalPanelRefresh" in ::$bvvar{namespace})
				::$bvvar{namespace}.scheduleActiveValkyrieTacticalPanelRefresh(actor.getID());
		}
		catch (e) {}
	}
	function setCount( _count )
	{
		local old = this.m.Count;
		this.m.Count = this.Math.min(6, this.Math.max(0, _count));
		if (old != this.m.Count) this.refreshDisplay();
		return this.m.Count;
	}
	function addCount( _amount = 1 ) { return this.setCount(this.m.Count + _amount); }
	function clear() { return this.setCount(0); }
	function isReady() { return this.getCount() >= 6; }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.feixiao_flying_aureus.tooltip.count_prefix}" + this.getCount() + "$bv{effect.feixiao_flying_aureus.tooltip.count_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.feixiao_flying_aureus.tooltip.ready}" }
		];
	}

	// The passive owns combat initialization and sets the starting value to 3.
	// Clearing here can run after that initialization when this effect is added
	// during skill-container iteration, erasing the starting Flying Aureus.
	function onCombatStarted() {}
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
