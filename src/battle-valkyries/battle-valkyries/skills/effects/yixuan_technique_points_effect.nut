this.yixuan_technique_points_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Count = 0,
		MaxCount = 3
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.yixuan_technique_points";
		this.m.Name = "$bv{effect.yixuan_technique_points.name}";
		this.m.Description = "$bv{effect.yixuan_technique_points.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/yixuan_preceptor_stance.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/yixuan_preceptor_stance_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount()
	{
		return this.Math.max(0, this.Math.min(this.m.MaxCount, this.m.Count));
	}

	function setCount( _count )
	{
		local old = this.getCount();
		this.m.Count = this.Math.max(0, this.Math.min(this.m.MaxCount, _count));
		if (old < this.m.MaxCount && this.m.Count == this.m.MaxCount)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			try
			{
				if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_56", actor.getTile());
			}
			catch (e)
			{
			}
		}
		return this.m.Count;
	}

	function addCount( _amount = 1 )
	{
		local old = this.getCount(), count = this.setCount(this.m.Count + _amount);
		if (old < this.m.MaxCount && count == this.m.MaxCount)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(actor, "yixuan_technique_ready");
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, actor, "yixuan_cast");
		}
		return count;
	}

	function clear()
	{
		this.m.Count = 0;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.yixuan_technique_points.tooltip.count_prefix}" + this.getCount() + "/" + this.m.MaxCount + "$bv{effect.yixuan_technique_points.tooltip.count_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.yixuan_technique_points.tooltip.gain}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.yixuan_technique_points.tooltip.ready}" }
		];
	}

	function onCombatStarted()
	{
		this.clear();
	}

	function onCombatFinished()
	{
		this.clear();
		this.skill.onCombatFinished();
	}
});
