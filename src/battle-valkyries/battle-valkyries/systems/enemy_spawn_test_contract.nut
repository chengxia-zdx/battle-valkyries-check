// Publish a host contract offer. Acceptance owns all defender generation.
::$bvvar{namespace}.getBanditTestContractBlock <- function()
{
	if (!::$bvvar{namespace}.isTestPanelOriginAvailable()) return "$bv{ui.test_panel.error.origin}";
	if (::World.State == null || ::World.State.getPlayer() == null || ::World.State.getCombatStartTime() != 0)
		return "$bv{ui.test_panel.natural.require.world}";
	if (::World.Contracts.getActiveContract() != null) return "$bv{ui.test_panel.natural.require.contract}";
	return "";
};

::$bvvar{namespace}.findBanditTestContractHome <- function()
{
	local bandits = ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits);
	if (bandits == null) return null;
	local playerTile = ::World.State.getPlayer().getTile();
	local best = null, bestDistance = 999999;
	foreach (entry in ::World.EntityManager.getSettlements())
	{
		if (entry == null) continue;
		// Resolve Legends registry entries to the actual world entity.
		local town = ::World.getEntityByID(entry.getID());
		if (town == null || !town.isAlive() || !town.isAlliedWithPlayer() || town.isIsolated()) continue;
		local faction = ::World.FactionManager.getFaction(town.getFaction());
		if (faction == null || faction.getType() != ::Const.FactionType.Settlement || faction.getRoster().getSize() == 0) continue;
		// The host town UI shows at most ten offers; never evict another contract.
		if (town.getContracts().len() >= 10) continue;
		// Use the same target selector as drive_away_bandits_contract.start().
		local camp = bandits.getNearestSettlement(town.getTile());
		if (camp == null || !camp.isAlive() || camp.isAlliedWithPlayer()
			|| camp.isLocationType(::Const.World.LocationType.Unique) || camp.getFlags().get("IsEventLocation")) continue;
		if (town.getTile().getDistanceTo(camp.getTile()) > 15 || town.isIsolatedFromLocation(camp)) continue;
		local distance = playerTile.getDistanceTo(town.getTile());
		if (distance < bestDistance)
		{
			best = town;
			bestDistance = distance;
		}
	}
	return best;
};

::$bvvar{namespace}.createBanditTestContract <- function()
{
	local ns = ::$bvvar{namespace};
	local blocked = ns.getBanditTestContractBlock();
	if (blocked != "") return ns.makeTestPanelResult(false, "conditions", blocked);
	local contract = null;
	try
	{
		// Flags survive saves. Repeated clicks reuse the pending offer.
		foreach (pending in ::World.Contracts.getOpenContracts())
			if (pending.m.Flags.get("BVTestBanditContract") && pending.isValid() && !pending.isTimedOut())
				return ns.makeTestPanelResult(true, "existing", ::format("$bv{ui.test_panel.bandit_contract.existing}", pending.getHome().getName()));
		local home = ns.findBanditTestContractHome();
		if (home == null) return ns.makeTestPanelResult(false, "no_home", "$bv{ui.test_panel.bandit_contract.no_home}");
		local faction = ::World.FactionManager.getFaction(home.getFaction());
		contract = ::new("scripts/contracts/contracts/drive_away_bandits_contract");
		contract.setFaction(faction.getID());
		contract.setHome(home);
		contract.setEmployerID(faction.getRandomCharacter().getID());
		// Upper end of the native three-skull range, also three skulls in Legends.
		contract.m.DifficultyMult = 1.35;
		contract.m.IsDifficultyHidden = false;
		contract.m.Flags.set("BVTestBanditContract", true);
		::World.Contracts.addContract(contract);
		if (::World.Contracts.getOpenContracts().find(contract) == null) throw "host rejected test contract";
	}
	catch (e)
	{
		// Includes a partially registered offer, without touching other contracts.
		if (contract != null)
			try { ::World.Contracts.removeContract(contract); } catch (cleanup) { ::logWarning("[Battle Valkyries] Test contract cleanup failed: " + cleanup); }
		::logWarning("[Battle Valkyries] Could not publish brigand test contract: " + e);
		return ns.makeTestPanelResult(false, "contract", "$bv{ui.test_panel.bandit_contract.failed}");
	}
	try { ::World.State.getTownScreen().updateContracts(); }
	catch (e) { ::logWarning("[Battle Valkyries] Test contract town UI refresh failed: " + e); }
	return ns.makeTestPanelResult(true, "ok", ::format("$bv{ui.test_panel.bandit_contract.success}", contract.getHome().getName()));
};
