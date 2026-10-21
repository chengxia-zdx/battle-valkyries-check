// The opponents are story cast, not required player participants. Recruitment
// uses the shared constructor; flags record delivery, never inferred from skins.
local chapters = ::$bvvar{namespace}.Chapters;
chapters.BlackCityRecruitBusy <- false;
chapters.syncBlackCityRecruits <- function()
{
	local id = "black_city_falls", d = this.definition(id);
	if (d == null || this.completed(id) < d.Stages.len() || this.BlackCityRecruitBusy) return;
	local missing = [], present = [];
	foreach (actorID in ["chloe", "olga"])
	{
		if (this.read(id, "recruit_delivered." + actorID) == 1) continue;
		local a = this.actor(actorID);
		if (a != null) present.push(actorID); else missing.push(actorID);
	}
	local roster = ::World.getPlayerRoster();
	// Do not deliver half the pair because only one roster slot was free.
	if (roster.getAll().len() + missing.len() > ::$bvvar{namespace}.getValkyrieSummonRosterMax()) return;
	this.BlackCityRecruitBusy = true;
	local created = [];
	try
	{
		foreach (actorID in missing)
		{
			local result = ::$bvvar{namespace}.createValkyrieRosterActor(actorID, getroottable(), {
				ChargeCrowns = false, HireReason = "chapter:black_city_falls", FormationPolicy = "summon"
			});
			if (!result.Success || !("Actor" in result) || result.Actor == null) throw "Recruit construction failed: " + actorID;
			created.push({ ID = actorID, Actor = result.Actor });
			::$bvvar{namespace}.equipBlackBeastStarter(result.Actor, actorID, getroottable());
		}
		foreach (actorID in present) this.write(id, "recruit_delivered." + actorID, 1);
		foreach (entry in created) this.write(id, "recruit_delivered." + entry.ID, 1);
	}
	catch (e)
	{
		// A flag write may fail after a constructor succeeds. Roll back the
		// delivery ledger together with the newly created actors.
		foreach (actorID in present) try { this.write(id, "recruit_delivered." + actorID, 0); } catch (ignored) {}
		foreach (entry in created) try { this.write(id, "recruit_delivered." + entry.ID, 0); } catch (ignored) {}
		foreach (entry in created) roster.remove(entry.Actor);
		try { ::World.State.getPlayer().updateStrength(); } catch (ignored) {}
		::logError("[Battle Valkyries] Black City recruitment pending: " + e);
	}
	this.BlackCityRecruitBusy = false;
};
local originalRewards = chapters.syncRewards;
chapters.syncRewards = function(id)
{
	originalRewards.call(this, id);
	if (id == "black_city_falls") this.syncBlackCityRecruits();
};
local originalDTO = chapters.dto;
chapters.dto = function(id)
{
	local result = originalDTO.call(this, id);
	if (id != "black_city_falls" || result == null) return result;
	result.StartHint <- "$bv{chapter.black_city.start_hint}";
	result.PendingRecruit <- result.Finished && (this.read(id, "recruit_delivered.chloe") != 1 || this.read(id, "recruit_delivered.olga") != 1);
	result.EndingScene <- result.Finished ? this.scene(id, "epilogue") : null;
	return result;
};
