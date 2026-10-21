::$bvvar{namespace}.logValkyrieBountyDebug <- function( _stage, _bountyID = "", _details = "" )
{
	try
	{
		::logInfo("[Battle Valkyries][BountyDebug] stage=" + _stage
			+ (_bountyID == "" ? "" : " bounty=" + _bountyID)
			+ (_details == "" ? "" : " " + _details));
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.getValkyrieBountyCompletedFlag <- function( _bountyID )
{
	return "$bvvar{modId}.bounty.completed." + _bountyID;
};

::$bvvar{namespace}.getNearestValkyrieBountyHome <- function()
{
	if (::World == null || ::World.EntityManager == null || ::World.State == null || ::World.State.getPlayer() == null || ::World.FactionManager == null)
	{
		return null;
	}

	local playerTile = ::World.State.getPlayer().getTile();
	local nearest = null;
	local nearestDistance = 999999;
	foreach( settlement in ::World.EntityManager.getSettlements() )
	{
		if (settlement == null)
		{
			continue;
		}

		// Legends may expose settlement registry entries as lightweight tables.
		// Resolve the authoritative world entity before storing it as Contract.Home,
		// because contract UI integrations expect methods such as getName().
		local candidate = settlement;
		try
		{
			local resolved = ::World.getEntityByID(settlement.getID());
			if (resolved != null)
			{
				candidate = resolved;
			}
		}
		catch (e)
		{
			::$bvvar{namespace}.logValkyrieBountyDebug("home.resolve.failed", "", "reason=" + e);
		}

		// Squirrel's `in` operator does not reliably report inherited methods on
		// world entities, so validate by invoking the required public API instead.
		local candidateName;
		local candidateFaction;
		local candidateTile;
		try
		{
			candidateName = candidate.getName();
			candidateFaction = candidate.getFaction();
			candidateTile = candidate.getTile();
		}
		catch (e)
		{
			::$bvvar{namespace}.logValkyrieBountyDebug("home.skip", "", "reason=missing_world_entity_api detail=" + e);
			continue;
		}

		local faction = ::World.FactionManager.getFaction(candidateFaction);
		if (faction == null || faction.getType() != ::Const.FactionType.Settlement)
		{
			continue;
		}

		local distance = playerTile.getDistanceTo(candidateTile);
		if (distance < nearestDistance)
		{
			nearest = candidate;
			nearestDistance = distance;
			::$bvvar{namespace}.logValkyrieBountyDebug("home.candidate", "", "id=" + candidate.getID() + " name=" + candidateName + " distance=" + distance);
		}
	}

	return nearest;
};

::$bvvar{namespace}.getValkyrieBountyChampionPolicyID <- function()
{
	try
	{
		if ("DLC" in ::Const && "Wildmen" in ::Const.DLC && ::Const.DLC.Wildmen)
		{
			return "vanilla_champion";
		}
	}
	catch (e)
	{
	}

	return "bounty_elite";
};

::$bvvar{namespace}.getValkyrieBountyChampionPolicyText <- function( _policyID )
{
	if (_policyID == "vanilla_champion")
	{
		return "$bv{ui.hub.bounty.champion_policy.vanilla_champion}";
	}

	return "$bv{ui.hub.bounty.champion_policy.bounty_elite}";
};

::$bvvar{namespace}.getValkyrieBountyStatusText <- function( _state )
{
	local messages = {
		available = "$bv{ui.hub.bounty.status.available}",
		active = "$bv{ui.hub.bounty.status.active}",
		completed = "$bv{ui.hub.bounty.status.completed}",
		pending = "$bv{ui.hub.bounty.status.pending}",
		owned = "$bv{ui.hub.bounty.status.owned}",
		blocked = "$bv{ui.hub.bounty.status.blocked}"
	};
	return _state in messages ? messages[_state] : messages.available;
};

::$bvvar{namespace}.getValkyrieBountyErrorText <- function( _code )
{
	local messages = {
		invalid_bounty = "$bv{ui.hub.bounty.error.invalid_bounty}",
		active_contract = "$bv{ui.hub.bounty.error.active_contract}",
		already_owned = "$bv{ui.hub.bounty.error.already_owned}",
		already_completed = "$bv{ui.hub.bounty.error.already_completed}",
		world_unavailable = "$bv{ui.hub.bounty.error.world_unavailable}",
		no_home = "$bv{ui.hub.bounty.error.no_home}",
		no_enemy_theme = "$bv{ui.hub.bounty.error.no_enemy_theme}",
		spawn_failed = "$bv{ui.hub.bounty.error.spawn_failed}"
	};
	return _code in messages ? messages[_code] : messages.invalid_bounty;
};

::$bvvar{namespace}.getValkyrieBountyAcceptanceSnapshot <- function( _bountyID )
{
	::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.begin", _bountyID);
	if (::World == null || ::World.Contracts == null)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=world_unavailable");
		return { Success = false, Code = "world_unavailable" };
	}

	local bounty = ::$bvvar{namespace}.getBountyByID(_bountyID);
	if (bounty == null)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=invalid_bounty");
		return { Success = false, Code = "invalid_bounty" };
	}

	if (::World.Contracts.getActiveContract() != null)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=active_contract");
		return { Success = false, Code = "active_contract" };
	}

	local owned = ::$bvvar{namespace}.getOwnedValkyrieBountyIDs();
	if (bounty.ValkyrieID in owned)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=already_owned");
		return { Success = false, Code = "already_owned" };
	}

	if (::$bvvar{namespace}.hasValkyrieBountyWorldFlag(::$bvvar{namespace}.getValkyrieBountyCompletedFlag(bounty.ID)))
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=already_completed");
		return { Success = false, Code = "already_completed" };
	}

	local home = ::$bvvar{namespace}.getNearestValkyrieBountyHome();
	if (home == null)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=no_home");
		return { Success = false, Code = "no_home" };
	}

	local campTheme = ::$bvvar{namespace}.BountyCamps.offer(_bountyID);
	if (campTheme == null)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.reject", _bountyID, "code=no_enemy_theme");
		return { Success = false, Code = "no_enemy_theme" };
	}

	local count = owned.len();
	local stars = ::$bvvar{namespace}.getValkyrieBountyStars(count);
	local campProfile = ::$bvvar{namespace}.BountyCamps.profile(count, campTheme);
	local snapshot = {
		Success = true,
		Home = home,
		BountyID = bounty.ID,
		ValkyrieID = bounty.ValkyrieID,
		Stars = stars,
		Reward = ::$bvvar{namespace}.getValkyrieBountyReward(stars),
		AcceptedValkyrieCount = count,
		IsCamp = true,
		CampSize = campProfile.Size,
		CampT4 = campProfile.T4,
		CampT5 = campProfile.T5,
		EscortBudget = campProfile.Budget,
		FixedChampionCount = campProfile.Champions,
		ChampionPolicyID = campProfile.Champions > 0 ? "vanilla_champion" : "camp_elites",
		EnemyThemeID = campTheme.ID
	};
	::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.ready", _bountyID, "owned=" + count + " stars=" + stars + " budget=" + snapshot.EscortBudget + " champions=" + snapshot.FixedChampionCount + " theme=" + snapshot.EnemyThemeID);
	return snapshot;
};

::$bvvar{namespace}.tryAcceptValkyrieBounty <- function( _bountyID )
{
	::$bvvar{namespace}.logValkyrieBountyDebug("accept.begin", _bountyID);
	local accepted;
	try
	{
		accepted = ::$bvvar{namespace}.getValkyrieBountyAcceptanceSnapshot(_bountyID);
	}
	catch (e)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("snapshot.exception", _bountyID, "reason=" + e);
		::logWarning("[Battle Valkyries] Bounty acceptance snapshot failed for '" + _bountyID + "': " + e);
		return { Success = false, Code = "spawn_failed" };
	}

	if (!accepted.Success)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("accept.rejected", _bountyID, "code=" + accepted.Code);
		return accepted;
	}

	local contract;
	try
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("contract.new.begin", _bountyID);
		contract = ::new("scripts/contracts/contracts/battle_valkyries/valkyrie_bounty_contract");
		::$bvvar{namespace}.logValkyrieBountyDebug("contract.new.done", _bountyID);
		contract.configureBounty(accepted, accepted.Home);
		::$bvvar{namespace}.logValkyrieBountyDebug("contract.configure.done", _bountyID, "home=" + accepted.Home.getID() + " home_name=" + accepted.Home.getName());
		::World.Contracts.addContract(contract);
		::$bvvar{namespace}.logValkyrieBountyDebug("contract.add.done", _bountyID);
		contract.startBounty();
		::$bvvar{namespace}.logValkyrieBountyDebug("contract.start.done", _bountyID);
		::World.Contracts.setActiveContract(contract, true);
		::World.Flags.set("$bvvar{modId}.bounty.camp.recent", accepted.EnemyThemeID);
		::$bvvar{namespace}.logValkyrieBountyDebug("contract.activate.done", _bountyID);
	}
	catch (e)
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("accept.exception", _bountyID, "reason=" + e);
		if (contract != null)
		{
			try { contract.cleanupBountyTarget("acceptance_failed"); } catch (ignoredCleanup) {}
			try { ::World.Contracts.removeContract(contract); } catch (ignored) {}
		}
		::logWarning("[Battle Valkyries] Bounty acceptance failed for '" + _bountyID + "': " + e);
		return { Success = false, Code = "spawn_failed" };
	}

	::logInfo("[Battle Valkyries] Bounty accepted: id=" + accepted.BountyID + ", valkyrie=" + accepted.ValkyrieID + ", stars=" + accepted.Stars + ", owned=" + accepted.AcceptedValkyrieCount + ", budget=" + accepted.EscortBudget + ", champions=" + accepted.FixedChampionCount + ", theme=" + accepted.EnemyThemeID + ", day=" + ::World.getTime().Days);
	::$bvvar{namespace}.logValkyrieBountyDebug("accept.success", _bountyID);
	return { Success = true, Code = "success", Contract = contract };
};

::$bvvar{namespace}.getValkyrieBountyPendingRecruitFlag <- function( _valkyrieID )
{
	return "$bvvar{modId}.bounty.pending_recruit." + _valkyrieID;
};

::$bvvar{namespace}.hasValkyrieBountyWorldFlag <- function( _flag )
{
	return ::World != null && ::World.Flags != null && ::World.Flags.has(_flag) && ::World.Flags.get(_flag) == true;
};

::$bvvar{namespace}.getOwnedValkyrieBountyIDs <- function()
{
	local owned = {};
	if (::World == null || ::World.getPlayerRoster() == null)
	{
		return owned;
	}

	foreach( bro in ::World.getPlayerRoster().getAll() )
	{
		local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(bro);
		if (valkyrieID != null && valkyrieID != "")
		{
			owned[valkyrieID] <- true;
		}
	}

	return owned;
};

::$bvvar{namespace}.isValkyrieBountyRewardWorldAvailable <- function()
{
	return ::World != null
		&& ::World.Flags != null
		&& ::World.Assets != null
		&& ::World.getPlayerRoster() != null;
};

::$bvvar{namespace}.isValkyrieBountyRewardRosterFull <- function()
{
	local roster = ::World.getPlayerRoster();
	return roster.getSize() >= ::$bvvar{namespace}.getValkyrieEffectiveRosterMax();
};

::$bvvar{namespace}.createValkyrieBountyRewardActor <- function( _valkyrieID, _context, _template )
{
	return ::$bvvar{namespace}.createValkyrieRosterActor(_valkyrieID, _context, {
		StartingLevel = _template.Level,
		StartingXP = _template.XP,
		ChargeCrowns = false,
		SummonCost = 0,
		HireReason = "bounty_reward",
		FormationPolicy = "summon"
	});
};

::$bvvar{namespace}.settleValkyrieBountyReward <- function( _snapshot, _context )
{
	if (!::$bvvar{namespace}.isValkyrieBountyRewardWorldAvailable())
	{
		return { Success = false, Code = "world_unavailable", Reward = 0 };
	}

	if (typeof _snapshot != "table"
		|| !("BountyID" in _snapshot) || typeof _snapshot.BountyID != "string"
		|| !("ValkyrieID" in _snapshot) || typeof _snapshot.ValkyrieID != "string")
	{
		return { Success = false, Code = "invalid_bounty", Reward = 0 };
	}

	local bounty = ::$bvvar{namespace}.getBountyByID(_snapshot.BountyID);
	local template = bounty == null ? null : ::$bvvar{namespace}.getValkyrieByID(_snapshot.ValkyrieID);
	if (bounty == null
		|| !("ID" in bounty) || bounty.ID != _snapshot.BountyID
		|| !("ValkyrieID" in bounty) || bounty.ValkyrieID != _snapshot.ValkyrieID
		|| template == null || template.ID != _snapshot.ValkyrieID)
	{
		return { Success = false, Code = "invalid_bounty", Reward = 0 };
	}

	if (!("Stars" in _snapshot) || typeof _snapshot.Stars != "integer"
		|| _snapshot.Stars < 1 || _snapshot.Stars > ::$bvvar{namespace}.ValkyrieBountyDifficulty.RewardsByStars.len()
		|| !("Reward" in _snapshot) || typeof _snapshot.Reward != "integer"
		|| _snapshot.Reward <= 0)
	{
		return { Success = false, Code = "invalid_reward", Reward = 0 };
	}

	local completedFlag = ::$bvvar{namespace}.getValkyrieBountyCompletedFlag(bounty.ID);
	local pendingFlag = ::$bvvar{namespace}.getValkyrieBountyPendingRecruitFlag(template.ID);
	local owned = ::$bvvar{namespace}.getOwnedValkyrieBountyIDs();
	if (::$bvvar{namespace}.hasValkyrieBountyWorldFlag(completedFlag))
	{
		local outcome = ::$bvvar{namespace}.hasValkyrieBountyWorldFlag(pendingFlag) ? "pending" : (template.ID in owned ? "already_owned" : "immediate");
		return { Success = true, Code = "already_settled", RecruitOutcome = outcome, Reward = 0 };
	}

	::World.Assets.addMoney(_snapshot.Reward);
	::World.Flags.set(completedFlag, true);

	if (template.ID in owned)
	{
		::World.Flags.set(pendingFlag, false);
		return { Success = true, Code = "success", RecruitOutcome = "already_owned", Reward = _snapshot.Reward };
	}

	::World.Flags.set(pendingFlag, true);
	if (::$bvvar{namespace}.isValkyrieBountyRewardRosterFull())
	{
		return { Success = true, Code = "success", RecruitOutcome = "pending", RecruitCode = "roster_full", Reward = _snapshot.Reward };
	}

	local construction = ::$bvvar{namespace}.createValkyrieBountyRewardActor(template.ID, _context, template);
	if (!construction.Success)
	{
		return { Success = true, Code = "success", RecruitOutcome = "pending", RecruitCode = "recruit_create_failed", Reward = _snapshot.Reward };
	}

	::World.Flags.set(pendingFlag, false);
	return { Success = true, Code = "success", RecruitOutcome = "immediate", Reward = _snapshot.Reward, Actor = construction.Actor };
};

::$bvvar{namespace}.claimPendingValkyrieBountyRecruit <- function( _valkyrieID, _context )
{
	if (!::$bvvar{namespace}.isValkyrieBountyRewardWorldAvailable())
	{
		return { Success = false, Code = "world_unavailable" };
	}

	local template = typeof _valkyrieID == "string" ? ::$bvvar{namespace}.getValkyrieByID(_valkyrieID) : null;
	if (template == null)
	{
		return { Success = false, Code = "invalid_bounty" };
	}

	local pendingFlag = ::$bvvar{namespace}.getValkyrieBountyPendingRecruitFlag(template.ID);
	if (!::$bvvar{namespace}.hasValkyrieBountyWorldFlag(pendingFlag))
	{
		return { Success = false, Code = "pending_not_found" };
	}

	local owned = ::$bvvar{namespace}.getOwnedValkyrieBountyIDs();
	if (template.ID in owned)
	{
		::World.Flags.set(pendingFlag, false);
		return { Success = true, Code = "success", RecruitOutcome = "already_owned" };
	}

	if (::$bvvar{namespace}.isValkyrieBountyRewardRosterFull())
	{
		return { Success = false, Code = "roster_full" };
	}

	local construction = ::$bvvar{namespace}.createValkyrieBountyRewardActor(template.ID, _context, template);
	if (!construction.Success)
	{
		return { Success = false, Code = "recruit_create_failed" };
	}

	::World.Flags.set(pendingFlag, false);
	return { Success = true, Code = "success", RecruitOutcome = "immediate", Actor = construction.Actor };
};

::$bvvar{namespace}.getActiveValkyrieBountyID <- function()
{
	if (::World == null || ::World.Contracts == null)
	{
		return null;
	}

	local active = ::World.Contracts.getActiveContract();
	if (active == null)
	{
		return null;
	}

	if ("BountyID" in active && active.BountyID != null && active.BountyID != "")
	{
		return active.BountyID;
	}

	try
	{
		return active.getBountyID();
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getActiveValkyrieContractType <- function()
{
	if (::World == null || ::World.Contracts == null)
	{
		return "";
	}

	local active = ::World.Contracts.getActiveContract();
	if (active == null)
	{
		return "";
	}

	try
	{
		return active.getType();
	}
	catch (e)
	{
		return "";
	}
};

::$bvvar{namespace}.getValkyrieBountyCardByID <- function( _bountyID )
{
	local bounty = ::$bvvar{namespace}.getBountyByID(_bountyID);
	if (bounty == null)
	{
		return null;
	}

	local ownedIDs = ::$bvvar{namespace}.getOwnedValkyrieBountyIDs();
	local ownedCount = ownedIDs.len();
	local stars = ::$bvvar{namespace}.getValkyrieBountyStars(ownedCount);
	local activeBountyID = ::$bvvar{namespace}.getActiveValkyrieBountyID();
	local hasActiveContract = ::World != null && ::World.Contracts != null && ::World.Contracts.getActiveContract() != null;
	local isPending = ::$bvvar{namespace}.hasValkyrieBountyWorldFlag(::$bvvar{namespace}.getValkyrieBountyPendingRecruitFlag(bounty.ValkyrieID));
	local isActive = activeBountyID == bounty.ID;
	local isCompleted = ::$bvvar{namespace}.hasValkyrieBountyWorldFlag(::$bvvar{namespace}.getValkyrieBountyCompletedFlag(bounty.ID));
	local isOwned = bounty.ValkyrieID in ownedIDs;
	local state = "available";

	// State priority is intentional: pending > active > completed > owned > blocked > available.
	if (isPending)
	{
		state = "pending";
	}
	else if (isActive)
	{
		state = "active";
	}
	else if (isCompleted)
	{
		state = "completed";
	}
	else if (isOwned)
	{
		state = "owned";
	}
	else if (hasActiveContract)
	{
		state = "blocked";
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(bounty.ValkyrieID);
	local active = isActive ? ::World.Contracts.getActiveContract() : null;
	local campTheme = active != null && "m" in active ? ::$bvvar{namespace}.BountyCamps.theme(active.m.EnemyThemeID) : ::$bvvar{namespace}.BountyCamps.offer(bounty.ID);
	local campProfile = campTheme == null ? null : ::$bvvar{namespace}.BountyCamps.profile(ownedCount, campTheme);
	local campSummary = campProfile == null ? "" : ::$bvvar{namespace}.BountyCamps.summary(campProfile.Size, campProfile.T4, campProfile.T5, campProfile.Champions);
	local budget = campProfile == null ? 0 : campProfile.Budget;
	local champions = campProfile == null ? 0 : campProfile.Champions;
	local championPolicy = champions > 0 ? "vanilla_champion" : "camp_elites";
	local reward = ::$bvvar{namespace}.getValkyrieBountyReward(stars);
	if (active != null && "m" in active)
	{
		stars = active.m.Stars; budget = active.m.EscortBudget; reward = active.m.Reward;
		ownedCount = active.m.AcceptedValkyrieCount;
		champions = active.m.FixedChampionCount; championPolicy = active.m.ChampionPolicyID;
		campSummary = active.m.IsCamp ? ::$bvvar{namespace}.BountyCamps.summary(active.m.CampSize, active.m.CampT4, active.m.CampT5, active.m.FixedChampionCount) : "$bv{bounty.camp.legacy}";
	}
	return {
		ID = bounty.ID,
		ValkyrieID = bounty.ValkyrieID,
		Name = template == null ? bounty.ValkyrieID : template.Name,
		Poster = bounty.Poster,
		Stars = stars,
		Reward = reward,
		OwnedValkyrieCount = ownedCount,
		EscortBudget = budget,
		FixedChampionCount = champions,
		ChampionPolicyID = championPolicy,
		ChampionPolicy = champions > 0 ? "$bv{bounty.camp.objective.champions}" : "$bv{bounty.camp.objective.elites}",
		EnemyTheme = campTheme == null ? "$bv{bounty.camp.legacy}" : campTheme.Name,
		CampSummary = campSummary,
		State = state,
		Status = ::$bvvar{namespace}.getValkyrieBountyStatusText(state),
		CanAccept = state == "available" && campTheme != null,
		CanClaim = state == "pending",
		IsOwned = isOwned,
		IsCompleted = isCompleted,
		IsActive = isActive
	};
};

::$bvvar{namespace}.getValkyrieBountyCards <- function()
{
	local cards = [];
	foreach( bountyID in ::$bvvar{namespace}.ValkyrieBountyOrder )
	{
		local card = ::$bvvar{namespace}.getValkyrieBountyCardByID(bountyID);
		if (card != null)
		{
			cards.push(card);
		}
	}

	return cards;
};
