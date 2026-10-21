this.ye_shunguang_qingming_stance_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 0 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.ye_shunguang_qingming_stance";
		this.m.Name = "$bv{effect.ye_shunguang_qingming_stance.name}";
		this.m.Description = "$bv{effect.ye_shunguang_qingming_stance.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/ye_shunguang_qingming_guard.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/ye_shunguang_qingming_guard_sw.png";
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
		try { ::logInfo("[Battle Valkyries] [YeShunguangDebug] stage=stance-set old=" + old + " requested=" + _count + " new=" + this.m.Count); } catch (e) {}
		if (this.m.Count != old) this.refreshDisplay();
		return this.m.Count;
	}
	function addCount( _amount = 1 )
	{
		local old = this.getCount(), count = this.setCount(this.getCount() + _amount);
		if (old < 6 && count == 6)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(actor, "ye_stance_ready");
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, actor, "ye_shunguang_reflection_cast", { Scale = 0.24, EndScale = 0.42, Duration = 250 });
		}
		return count;
	}
	function consumeCount( _amount = 1 ) { if (this.getCount() < _amount) return false; this.setCount(this.getCount() - _amount); return true; }
	function clear() { return this.setCount(0); }
	function isReady() { return this.getCount() >= 6; }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.ye_shunguang_qingming_stance.tooltip.count_prefix}" + this.getCount() + "$bv{effect.ye_shunguang_qingming_stance.tooltip.count_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.ye_shunguang_qingming_stance.tooltip.gain}" }
		];
	}

	function onCombatStarted() { this.clear(); }
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
