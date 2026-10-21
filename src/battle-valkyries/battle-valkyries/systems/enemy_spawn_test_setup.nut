// Test-origin preparation changes real campaign inputs; it never generates enemy troops.
::$bvvar{namespace}.getEnemySpawnTestActors <- function()
{
	local actors = [];
	if (::World.getPlayerRoster() == null) return actors;
	foreach (actor in ::World.getPlayerRoster().getAll())
		if (actor.isAlive() && ::$bvvar{namespace}.isActorValkyrie(actor)) actors.push(actor);
	actors.sort(function(a, b) { return a.getLevel() > b.getLevel() ? -1 : (a.getLevel() < b.getLevel() ? 1 : 0); });
	return actors;
};

::$bvvar{namespace}.getEnemySpawnTestSetupBlock <- function()
{
	if (!::$bvvar{namespace}.isTestPanelOriginAvailable()) return "$bv{ui.test_panel.error.origin}";
	if (::World.State == null || ::World.State.getPlayer() == null || ::World.getPlayerRoster() == null)
		return "$bv{ui.test_panel.natural.require.world}";
	if (::World.State.getCombatStartTime() != 0) return "$bv{ui.test_panel.natural.require.world}";
	if (::World.Contracts.getActiveContract() != null) return "$bv{ui.test_panel.natural.require.contract}";
	local missing = ::Math.max(0, 8 - ::$bvvar{namespace}.getEnemySpawnTestActors().len());
	if (::World.getPlayerRoster().getSize() + missing > ::$bvvar{namespace}.getValkyrieEffectiveRosterMax())
		return "$bv{ui.test_panel.natural.require.roster}";
	return "";
};

::$bvvar{namespace}.getEnemySpawnTestStatus <- function()
{
	local ready = 0;
	foreach (actor in ::$bvvar{namespace}.getEnemySpawnTestActors()) if (actor.getLevel() >= 11) ++ready;
	return ::format("$bv{ui.test_panel.natural.status}", ::World.getTime().Days, ready,
		::$bvvar{namespace}.isValkyrieEnemyScalingEnabled() ? "$bv{ui.test_panel.natural.on}" : "$bv{ui.test_panel.natural.off}",
		::$bvvar{namespace}.getValkyrieEnemyLevelThreat(),
		::$bvvar{namespace}.getValkyrieEnemyBudgetMult("contract"),
		::$bvvar{namespace}.getValkyrieEnemyBudgetMult("roamer"),
		::$bvvar{namespace}.getValkyrieEnemyBudgetMult("location"));
};

::$bvvar{namespace}.advanceEnemySpawnTestDay <- function()
{
	local time = ::World.getTime();
	if (time.Days >= 51) return;
	local start = time.Time;
	local target = start + (51 - time.Days) * time.SecondsPerDay;
	local virtualStart = ::Time.getVirtualTimeF();
	local wasClockPaused = time.IsPaused;
	::World.State.setPause(true);
	local pausedSpeed = ::World.getSpeedMult();
	local error = null;
	try
	{
		// The native calendar accumulates getDelta() * World speed in World.update().
		// setVirtualTime alone only changes script timers, not World.getTime().Days.
		// Native calendar updates reject a step >= SecondsPerDay, so use half days.
		time.IsPaused = false;
		for (local step = 0; step < 128; ++step)
		{
			local before = ::World.getTime().Time;
			local remaining = target - before;
			if (remaining <= 0.01 && ::World.getTime().Days >= 51) break;
			local delta = ::Time.getDelta();
			if (delta <= 0.0) throw "no world frame delta; retry preparation";
			local advance = ::Math.minf(time.SecondsPerDay * 0.5, ::Math.maxf(0.02, remaining));
			::World.setSpeedMult(advance / delta);
			// Only the native map clock/visual update; no State, faction or contract tick.
			::World.update();
			if (::World.getTime().Time <= before) throw "world calendar did not advance";
		}
		if (::World.getTime().Days < 51 || ::World.getTime().Time + 0.01 < target)
			throw "world calendar did not reach target";
	}
	catch (e) { error = e; }
	// Restore speed even on failure, and keep script timers aligned with any partial advance.
	::World.setSpeedMult(pausedSpeed);
	time.IsPaused = wasClockPaused;
	local elapsed = ::World.getTime().Time - start;
	if (elapsed > 0.0) ::Time.setVirtualTime(virtualStart + elapsed);
	if (error != null) throw error;
};

::$bvvar{namespace}.refreshEnemySpawnTestDay <- function()
{
	// The host topbar caches only the minute, which is unchanged after whole-day jumps.
	local source = ::World.State.getWorldScreen().getTopbarDatasourceModule();
	source.m.LastTimeInformationUpdate = -1000;
	::World.State.updateDayTime();
};

::$bvvar{namespace}.prepareEnemySpawnTest <- function()
{
	local ns = ::$bvvar{namespace};
	local blocked = ns.getEnemySpawnTestSetupBlock();
	if (blocked != "") return ns.makeTestPanelResult(false, "conditions", blocked);
	try
	{
		// MSU's normal setter preserves its callbacks, UI and persistence contract.
		local setting = ns.Mod.ModSettings.getSetting("EnableValkyrieEnemyScaling");
		if (!setting.set(true) || !ns.isValkyrieEnemyScalingEnabled())
			return ns.makeTestPanelResult(false, "setting", "$bv{ui.test_panel.natural.error.setting}");

		local actors = ns.getEnemySpawnTestActors();
		local preferred = ["saber", "jeanne", "robin", "morgan", "enterprise", "jingliu", "raiden_shogun", "nahida"];
		local candidates = clone preferred;
		foreach (id in ns.ValkyrieOrder) if (candidates.find(id) == null) candidates.push(id);
		foreach (id in candidates)
		{
			if (actors.len() >= 8) break;
			if (ns.findValkyrieInRoster(id) != null || ns.getValkyrieByID(id) == null) continue;
			local result = ns.createValkyrieRosterActor(id, ::World.State, { HireReason = "test-natural-spawn" });
			if (!result.Success) throw "recruit " + id + ": " + result.Code;
			actors.push(result.Actor);
		}
		if (actors.len() < 8) throw "not enough available Valkyrie templates";
		// Use the same level-up path as memory keepsakes, retaining native/Legends perk handling.
		for (local i = 0; i < 8; ++i)
		{
			local actor = actors[i];
			while (actor.getLevel() < 11)
			{
				local before = actor.getLevel();
				actor.m.XP = ::Math.max(actor.m.XP, ::Const.LevelXP[before]);
				actor.updateLevel();
				if (actor.getLevel() <= before) throw "level-up did not advance";
			}
			local sync = ns.syncActorSkills(actor, "test-natural-spawn");
			if (!sync.Success) throw "skill sync: " + sync.Code;
			actor.getSkills().update();
			actor.setDirty(true);
		}
		::World.State.getPlayer().updateStrength();

		try
		{
			ns.advanceEnemySpawnTestDay();
		}
		catch (e)
		{
			::logWarning("[Battle Valkyries] Natural spawn test calendar failed: day=" + ::World.getTime().Days + ", " + e);
			ns.refreshEnemySpawnTestDay();
			return ns.makeTestPanelResult(false, "clock", ::format("$bv{ui.test_panel.natural.error.clock}", ::World.getTime().Days));
		}
		ns.refreshEnemySpawnTestDay();
		ns.refreshTestPanelWorldAssets();
		::logInfo("[Battle Valkyries] Natural spawn test prepared: day=" + ::World.getTime().Days);
		return ns.makeTestPanelResult(true, "ok", ::format("$bv{ui.test_panel.natural.success}", ::World.getTime().Days));
	}
	catch (e)
	{
		::logWarning("[Battle Valkyries] Natural spawn test preparation failed: " + e);
		return ns.makeTestPanelResult(false, "setup", "$bv{ui.test_panel.natural.error.partial}");
	}
};
