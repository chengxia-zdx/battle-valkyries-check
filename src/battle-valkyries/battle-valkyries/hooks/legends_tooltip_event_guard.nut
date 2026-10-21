// Jimmy's Tooltip adds onOtherActorTooltip as an optional MSU skill event.
// MSU's generic dispatcher assumes every skill implements the event, but a
// number of private runtime skills and third-party skills do not inherit that
// generated no-op. A missing callback then aborts the entire actor tooltip.
//
// This file is only included from the VeryLate queue after Legends and Jimmy's
// Tooltip. It deliberately changes no normal gameplay event and leaves the
// original dispatcher intact for every event other than this optional tooltip
// enrichment callback.
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
	q.callSkillsFunction = @(__original) function( _function, _argsArray = null, _update = true, _aliveOnly = false )
	{
		if (_function != "onOtherActorTooltip")
		{
			return __original(_function, _argsArray, _update, _aliveOnly);
		}

		if (_argsArray == null)
		{
			_argsArray = [null];
		}
		else
		{
			_argsArray.insert(0, null);
		}

		local wasUpdating = this.m.IsUpdating;
		this.m.IsUpdating = true;
		this.m.IsBusy = false;
		this.m.BusyStack = 0;

		foreach (skill in this.m.Skills)
		{
			if (_aliveOnly && !this.m.Actor.isAlive())
			{
				break;
			}

			if (skill.isGarbage())
			{
				continue;
			}

			_argsArray[0] = skill;

			try
			{
				skill.onOtherActorTooltip.acall(_argsArray);
			}
			catch (e)
			{
				local skillID = "<unknown>";
				try { skillID = skill.getID(); } catch (ignored) {}
				::$bvvar{namespace}.logPerkDebugOnce(
					"legend-tooltip-event-skip:" + skillID,
					"stage=legend-tooltip-event-skip skill=" + skillID + " error=" + e
				);
			}
		}

		this.m.IsUpdating = wasUpdating;

		if (_update)
		{
			this.update();
		}
	}
});
