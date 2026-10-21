::$bvvar{namespace}.findTooltipRosterEntity <- function( _entityId )
{
	if (_entityId == null || ::World == null || ::World.getPlayerRoster() == null)
	{
		return null;
	}

	foreach( bro in ::World.getPlayerRoster().getAll() )
	{
		if (bro != null && bro.getID() == _entityId)
		{
			return bro;
		}
	}

	return null;
};

::$bvvar{namespace}.MH.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIPerkTooltipData = @(__original) function( _entityId, _perkId )
	{
		local entity = ::$bvvar{namespace}.findTooltipRosterEntity(_entityId);
		local debugKey = "tooltip:" + _entityId + ":" + _perkId;
		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":enter", "stage=tooltip-hook-enter entity=" + _entityId + " perk=" + _perkId + " entityFound=" + (entity == null ? "0" : "1"));

		if (entity == null || entity.getBackground() == null || !::$bvvar{namespace}.hasLegendsPerkTreeRuntime())
		{
			::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":delegate", "stage=tooltip-hook-delegate entity=" + _entityId + " perk=" + _perkId + " reason=entity-or-background");
			return __original(_entityId, _perkId);
		}

		::$bvvar{namespace}.logValkyriePerkTreeState(entity, entity.getBackground(), "tooltip-tree", "tree:" + _entityId);

		local perk = null;

		try
		{
			perk = entity.getBackground().getPerk(_perkId);
		}
		catch (e)
		{
			::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":get-failed", "stage=tooltip-get-perk-failed entity=" + _entityId + " perk=" + _perkId + " error=" + e);
			return __original(_entityId, _perkId);
		}

		local perkState = perk == null ? "null" : "found";
		local hasTooltip = perk != null && "Tooltip" in perk && perk.Tooltip != null;
		local hasScript = perk != null && "Script" in perk && perk.Script != null;
		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":perk", "stage=tooltip-perk entity=" + _entityId + " requested=" + _perkId + " state=" + perkState + " hasTooltip=" + (hasTooltip ? "1" : "0") + " hasScript=" + (hasScript ? "1" : "0"));

		if (perk == null || hasTooltip)
		{
			return __original(_entityId, _perkId);
		}

		local skill = entity.getSkills().getSkillByID(("ID" in perk) ? perk.ID : _perkId);

		if (skill == null && "Script" in perk && perk.Script != null)
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
					::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":runtime", "stage=tooltip-runtime-fallback entity=" + _entityId + " perk=" + _perkId + " result=success");
					return tooltip;
				}
			}
			catch (e)
			{
			}
		}

		::$bvvar{namespace}.logPerkDebugOnce(debugKey + ":minimal", "stage=tooltip-minimal-fallback entity=" + _entityId + " perk=" + _perkId);

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

	q.general_querySkillTooltipData = @(__original) function( _entityId, _skillId )
	{
		local ret = __original(_entityId, _skillId);

		if (ret != null)
		{
			return ret;
		}

		local entity = ::$bvvar{namespace}.findTooltipRosterEntity(_entityId);

		if (entity == null)
		{
			return null;
		}

		local skill = entity.getSkills().getSkillByID(_skillId);
		return skill != null ? skill.getTooltip() : null;
	}

	q.general_queryStatusEffectTooltipData = @(__original) function( _entityId, _statusEffectId )
	{
		local ret = __original(_entityId, _statusEffectId);

		if (ret != null)
		{
			return ret;
		}

		local entity = ::$bvvar{namespace}.findTooltipRosterEntity(_entityId);

		if (entity == null)
		{
			return null;
		}

		local statusEffect = entity.getSkills().getSkillByID(_statusEffectId);

		if (statusEffect == null)
		{
			return null;
		}

		ret = statusEffect.getTooltip();

		if (statusEffect.isType(this.Const.SkillType.Background) && ("State" in this.World) && this.World.State != null)
		{
			this.World.Assets.getOrigin().onGetBackgroundTooltip(statusEffect, ret);
		}

		return ret;
	}
});
