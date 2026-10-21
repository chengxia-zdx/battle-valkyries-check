this.skirk_seven_phase_flash_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Active = false, Exhausted = false },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.skirk_seven_phase_flash";
		this.m.Name = "$bv{effect.skirk_seven_phase_flash.name}";
		this.m.Description = "$bv{effect.skirk_seven_phase_flash.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/skirk_abyssal_flash.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/skirk_abyssal_flash_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.Active = false;
		this.m.Exhausted = false;
	}

	function activate()
	{
		this.m.Active = true;
		this.m.Exhausted = false;
		this.m.IsHidden = false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		try { if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_34", actor.getTile()); } catch (e) {}
		return true;
	}
	function deactivate() { this.m.Active = false; this.m.Exhausted = false; this.m.IsHidden = true; return true; }
	function markExhausted() { if (!this.m.Active) return false; this.m.Exhausted = true; return true; }
	// Do not override skill.isActive(): the tactical UI uses that base method
	// to decide whether an object belongs in the active skill bar.
	function isPhaseActive() { return this.m.Active; }
	function isExhausted() { return this.m.Exhausted; }

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.skirk_seven_phase_flash.tooltip.cost}" },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{effect.skirk_seven_phase_flash.tooltip.attack}" }
		];
		if (this.isExhausted()) ret.push({ id = 5, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{effect.skirk_seven_phase_flash.tooltip.exhausted}" });
		return ret;
	}

	function onCombatStarted() { this.deactivate(); }
	function onCombatFinished() { this.deactivate(); this.skill.onCombatFinished(); }
});
