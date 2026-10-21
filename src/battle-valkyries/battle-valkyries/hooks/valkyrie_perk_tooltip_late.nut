::$bvvar{namespace}.logPerkDebug("stage=late-tooltip-hook-register");

::$bvvar{namespace}.MH.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	::$bvvar{namespace}.logPerkDebug("stage=late-tooltip-hook-applied");

	q.onQueryUIPerkTooltipData = @(__original) function( _entityId, _perkId )
	{
		local entity = ::$bvvar{namespace}.findTooltipRosterEntity(_entityId);
		local debugKey = "late-outer-tooltip:" + _entityId + ":" + _perkId;
		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":enter", "stage=late-outer-tooltip-enter entity=" + _entityId + " perk=" + _perkId + " entityFound=" + (entity == null ? "0" : "1"));

		if (entity == null || entity.getBackground() == null || !::$bvvar{namespace}.hasLegendsPerkTreeRuntime())
		{
			return __original(_entityId, _perkId);
		}

		local background = entity.getBackground();
		::$bvvar{namespace}.logValkyriePerkTreeState(entity, background, "late-outer-tooltip-tree", "late-outer-tree:" + _entityId);

		local perk = null;

		try
		{
			perk = background.getPerk(_perkId);
		}
		catch (e)
		{
			::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":get-failed", "stage=late-outer-tooltip-get-perk-failed entity=" + _entityId + " perk=" + _perkId + " error=" + e);
			return __original(_entityId, _perkId);
		}

		if (perk != null && ("Tooltip" in perk && perk.Tooltip != null))
		{
			return __original(_entityId, _perkId);
		}

		if (perk == null)
		{
			::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":null", "stage=late-outer-tooltip-null entity=" + _entityId + " requested=" + _perkId);
			return [
				{
					id = 1,
					type = "title",
					text = "" + _perkId
				},
				{
					id = 2,
					type = "description",
					text = ""
				}
			];
		}

		local hasScript = "Script" in perk && perk.Script != null;
		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":missing", "stage=late-outer-tooltip-missing entity=" + _entityId + " requested=" + _perkId + " hasScript=" + (hasScript ? "1" : "0"));
		local skill = entity.getSkills().getSkillByID(("ID" in perk) ? perk.ID : _perkId);

		if (skill == null && hasScript)
		{
			try { skill = this.new(perk.Script); } catch (e) { skill = null; }
		}

		if (skill != null)
		{
			try
			{
				local tooltip = skill.getTooltip();

				if (tooltip != null)
				{
					::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":runtime", "stage=late-outer-tooltip-runtime-fallback entity=" + _entityId + " perk=" + _perkId + " result=success");
					return tooltip;
				}
			}
			catch (e)
			{
			}
		}

		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":minimal", "stage=late-outer-tooltip-minimal-fallback entity=" + _entityId + " perk=" + _perkId);
		return [
			{
				id = 1,
				type = "title",
				text = ("Name" in perk) ? perk.Name : "" + _perkId
			},
			{
				id = 2,
				type = "description",
				text = ("Description" in perk) ? perk.Description : ""
			}
		];
	}

	q.general_queryUIPerkTooltipData = @(__original) function( _entityId, _perkId )
	{
		local entity = ::$bvvar{namespace}.findTooltipRosterEntity(_entityId);
		local debugKey = "late-tooltip:" + _entityId + ":" + _perkId;
		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":enter", "stage=late-tooltip-hook-enter entity=" + _entityId + " perk=" + _perkId + " entityFound=" + (entity == null ? "0" : "1"));

		if (entity == null || entity.getBackground() == null || !::$bvvar{namespace}.hasLegendsPerkTreeRuntime())
		{
			return __original(_entityId, _perkId);
		}

		local background = entity.getBackground();
		::$bvvar{namespace}.logValkyriePerkTreeState(entity, background, "late-tooltip-tree", "late-tree:" + _entityId);

		local perk = null;

		try
		{
			perk = background.getPerk(_perkId);
		}
		catch (e)
		{
			::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":get-failed", "stage=late-tooltip-get-perk-failed entity=" + _entityId + " perk=" + _perkId + " error=" + e);
			return __original(_entityId, _perkId);
		}

		if (perk == null || ("Tooltip" in perk && perk.Tooltip != null))
		{
			return __original(_entityId, _perkId);
		}

		local hasScript = "Script" in perk && perk.Script != null;
		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":missing", "stage=late-tooltip-missing entity=" + _entityId + " requested=" + _perkId + " hasScript=" + (hasScript ? "1" : "0"));

		local skill = entity.getSkills().getSkillByID(("ID" in perk) ? perk.ID : _perkId);

		if (skill == null && hasScript)
		{
			try
			{
				skill = this.new(perk.Script);
			}
			catch (e)
			{
				skill = null;
			}
		}

		if (skill != null)
		{
			try
			{
				local tooltip = skill.getTooltip();

				if (tooltip != null)
				{
					::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":runtime", "stage=late-tooltip-runtime-fallback entity=" + _entityId + " perk=" + _perkId + " result=success");
					return tooltip;
				}
			}
			catch (e)
			{
			}
		}

		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":minimal", "stage=late-tooltip-minimal-fallback entity=" + _entityId + " perk=" + _perkId);
		return [
			{
				id = 1,
				type = "title",
				text = ("Name" in perk) ? perk.Name : "" + _perkId
			},
			{
				id = 2,
				type = "description",
				text = ("Description" in perk) ? perk.Description : ""
			}
		];
	}
});
