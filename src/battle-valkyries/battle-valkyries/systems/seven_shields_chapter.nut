// Only these two IDs add a prerequisite and a grouped recruitment entitlement.
local chapters = ::$bvvar{namespace}.Chapters;
chapters.SevenShieldsRecruitBusy <- false;
chapters.isSevenShieldsChapter <- function(id) { return id == "seven_shields_upper" || id == "seven_shields_lower"; };
chapters.sevenShieldsPrerequisiteMet <- function(id)
{
	local d = this.definition(id), before = this.definition(d.RequiredChapter);
	return before != null && this.read(d.RequiredChapter, "started") == 1 && this.completed(d.RequiredChapter) >= before.Stages.len();
};
local originalCanStart = chapters.canStart;
chapters.canStart = function(id)
{
	return originalCanStart.call(this, id) && (!this.isSevenShieldsChapter(id) || this.sevenShieldsPrerequisiteMet(id));
};
local originalStart = chapters.start;
chapters.start = function(id)
{
	if (this.isSevenShieldsChapter(id) && !this.sevenShieldsPrerequisiteMet(id))
		return { Success = false, Code = "locked", Message = id == "seven_shields_upper" ? "$bv{chapter.seven_shields.upper.start_hint}" : "$bv{chapter.seven_shields.lower.start_hint}" };
	return originalStart.call(this, id);
};
chapters.syncSevenShieldsRecruits <- function(id)
{
	local d = this.definition(id);
	if (!this.isSevenShieldsChapter(id) || d == null || this.completed(id) < d.Stages.len() || this.SevenShieldsRecruitBusy) return;
	local missing = [], present = [];
	foreach (role in d.RecruitActors)
	{
		if (this.read(id, "recruit_delivered." + role) == 1) continue;
		if (this.actor(role) != null) present.push(role); else missing.push(role);
	}
	local roster = ::World.getPlayerRoster();
	// Deliver an entire part together. A full roster never rewinds story progress.
	if (roster.getAll().len() + missing.len() > ::$bvvar{namespace}.getValkyrieSummonRosterMax()) return;
	this.SevenShieldsRecruitBusy = true;
	local created = [];
	try
	{
		foreach (role in missing)
		{
			local result = ::$bvvar{namespace}.createValkyrieRosterActor(role, getroottable(), {
				ChargeCrowns = false, HireReason = "chapter:" + id, FormationPolicy = "summon"
			});
			if (!result.Success || !("Actor" in result) || result.Actor == null) throw "Recruit construction failed: " + role;
			created.push({ ID = role, Actor = result.Actor });
			::$bvvar{namespace}.equipBlackBeastStarter(result.Actor, role, getroottable());
		}
		foreach (role in present) this.write(id, "recruit_delivered." + role, 1);
		foreach (entry in created) this.write(id, "recruit_delivered." + entry.ID, 1);
	}
	catch (e)
	{
		foreach (role in present) try { this.write(id, "recruit_delivered." + role, 0); } catch (ignored) {}
		foreach (entry in created) try { this.write(id, "recruit_delivered." + entry.ID, 0); } catch (ignored) {}
		foreach (entry in created) roster.remove(entry.Actor);
		try { ::World.State.getPlayer().updateStrength(); } catch (ignored) {}
		::logError("[Battle Valkyries] Seven Shields recruitment pending: " + e);
	}
	this.SevenShieldsRecruitBusy = false;
};
local originalRewards = chapters.syncRewards;
chapters.syncRewards = function(id)
{
	originalRewards.call(this, id);
	if (this.isSevenShieldsChapter(id)) this.syncSevenShieldsRecruits(id);
};
local originalDTO = chapters.dto;
chapters.dto = function(id)
{
	local result = originalDTO.call(this, id);
	if (!this.isSevenShieldsChapter(id) || result == null) return result;
	local d = this.definition(id), upper = id == "seven_shields_upper";
	result.StartHint <- upper ? "$bv{chapter.seven_shields.upper.start_hint}" : "$bv{chapter.seven_shields.lower.start_hint}";
	result.PendingRecruitMessage <- upper ? "$bv{chapter.seven_shields.upper.pending}" : "$bv{chapter.seven_shields.lower.pending}";
	result.PendingRecruit <- false;
	if (result.Finished) foreach (role in d.RecruitActors)
		if (this.read(id, "recruit_delivered." + role) != 1) result.PendingRecruit = true;
	result.EndingScene <- result.Finished ? this.scene(id, "epilogue") : null;
	result.EndingReplayLabel <- "$bv{chapter.seven_shields.epilogue_replay}";
	return result;
};
