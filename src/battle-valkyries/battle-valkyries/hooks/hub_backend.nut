::$bvvar{namespace}.MH.hook("scripts/ui/screens/world/modules/topbar/world_screen_topbar_options_module", function(q) {
	// Temporary, bounded diagnostics for the in-game video compatibility investigation.
	// Console warnings are not reliably forwarded to Battle Brothers' log.html.
	::$bvvar{namespace}.Mod.Debug.setFlag("DetailMedia", true);
	::$bvvar{namespace}.Mod.Debug.printLog("[Battle Valkyries][DetailMedia] diagnostics=enabled revision=11 transport=session-registry audit=close-0-300-1200ms release=empty-source-after-1300ms", "DetailMedia");
	local detailMediaLogCount = 0;
	q.logBattleValkyrieDetailMedia <- function( _request )
	{
		if (typeof _request != "table" || detailMediaLogCount >= 300) return false;
		if (!("ValkyrieID" in _request) || typeof _request.ValkyrieID != "string" || !(_request.ValkyrieID in ::$bvvar{namespace}.Valkyries)) return false;
		local line = "[Battle Valkyries][DetailMedia]";
		foreach (key in ["ValkyrieID", "SkinID", "Stage", "Details"])
		{
			if (!(key in _request) || typeof _request[key] != "string") continue;
			local value = _request[key];
			local limit = key == "Details" ? 900 : 80;
			local clean = "";
			// Log is HTML: exclude markup/control characters; never accept binary media.
			for (local i = 0; i < value.len() && i < limit; ++i)
			{
				local c = value[i];
				clean += c >= 32 && c <= 126 && c != 60 && c != 62 && c != 38 ? value.slice(i, i + 1) : "_";
			}
			line += " " + key + "=" + clean;
		}
		++detailMediaLogCount;
		::$bvvar{namespace}.Mod.Debug.printLog(line, "DetailMedia");
		return true;
	}

	q.queryBattleValkyriesHubData <- function()
	{
		foreach (id, definition in ::$bvvar{namespace}.ChapterDefinitions) ::$bvvar{namespace}.Chapters.syncRewards(id);
		return {
			Title = "$bv{ui.hub.title}",
			Body = "$bv{ui.hub.body}",
			Close = "$bv{ui.hub.close}",
			ButtonTitle = "$bv{ui.hub.button_tooltip}",
			SummonCost = ::$bvvar{namespace}.getValkyrieSummonCost(),
			GachaModeEnabled = ::$bvvar{namespace}.getSettingValue("GachaMode"),
			RosterEnabled = ::$bvvar{namespace}.Roster.enabled(),
			GachaCost = ::$bvvar{namespace}.getValkyrieGachaCost(),
			GachaProgress = ::$bvvar{namespace}.getValkyrieGachaProgress(),
			GachaProgressMax = ::$bvvar{namespace}.ValkyrieGachaProgressMax,
			GachaSelectedValkyrieID = ::$bvvar{namespace}.getSelectedGachaValkyrieID(),
			GachaSelectedSkinID = ::$bvvar{namespace}.getSelectedGachaSkinID(),
			GachaSelectedValkyrieName = ::$bvvar{namespace}.getSelectedGachaValkyrieName(),
			SummonSlots = ::$bvvar{namespace}.getValkyrieSummonSlots(),
			RecruitGuideCatalog = ::$bvvar{namespace}.getValkyrieRecruitGuideCatalog(),
			BountyCards = ::$bvvar{namespace}.getValkyrieBountyCards(),
			ChapterCards = ::$bvvar{namespace}.Chapters.cards(),
			MemoryArchive = ::$bvvar{namespace}.getMemoryArchiveHubDTO(),
			MemoryShop = ::$bvvar{namespace}.getMemoryShopHubDTO(),
			ActiveContractType = ::$bvvar{namespace}.getActiveValkyrieContractType(),
			Messages = {
				SummonButton = "$bv{ui.hub.summon.button}",
				SkinItemButton = "$bv{ui.hub.skin_item.button}",
				SkinItemResultTitle = "$bv{ui.hub.skin_item.result_title}",
				LeaderSetButton = "$bv{ui.hub.leader.set}",
				LeaderCurrentButton = "$bv{ui.hub.leader.current}",
				LeaderResultTitle = "$bv{ui.hub.leader.result_title}",
				ConfirmTitle = "$bv{ui.hub.summon.confirm_title}",
				ConfirmMessage = "$bv{ui.hub.summon.confirm_message}",
				ConfirmPrefix = "$bv{ui.hub.summon.confirm_prefix}",
				ConfirmSuffix = "$bv{ui.hub.summon.confirm_suffix}",
				ConfirmYes = "$bv{ui.hub.summon.confirm_yes}",
				Cancel = "$bv{ui.hub.summon.cancel}",
				OK = "$bv{ui.hub.summon.ok}",
				ResultTitle = "$bv{ui.hub.summon.result_title}",
				Unavailable = "$bv{ui.hub.summon.error.unavailable}",
				GachaPullButton = "$bv{ui.hub.gacha.pull.button}",
				GachaCost = "$bv{ui.hub.gacha.cost}",
				GachaProgress = "$bv{ui.hub.gacha.progress}",
				GachaSelected = "$bv{ui.hub.gacha.selected}",
				GachaSelectedNone = "$bv{ui.hub.gacha.selected.none}",
				GachaSelectButton = "$bv{ui.hub.gacha.select.button}",
				GachaSelectedButton = "$bv{ui.hub.gacha.select.selected}",
				GachaResultTitle = "$bv{ui.hub.gacha.result_title}",
				BountyWanted = "$bv{ui.hub.bounty.wanted}",
				BountyReward = "$bv{ui.hub.bounty.reward}",
				BountyEscortBudget = "$bv{ui.hub.bounty.escort_budget}",
				BountyFixedChampions = "$bv{ui.hub.bounty.fixed_champions}",
				BountyChampionPolicy = "$bv{ui.hub.bounty.champion_policy}",
				BountyConfirmTitle = "$bv{ui.hub.bounty.confirm_title}",
				BountyConfirmMessage = "$bv{ui.hub.bounty.confirm_message}",
				BountyAccept = "$bv{ui.hub.bounty.accept}",
				BountyClaim = "$bv{ui.hub.bounty.claim}",
				BountyClaimTitle = "$bv{ui.hub.bounty.claim_title}",
				BountyClaimMessage = "$bv{ui.hub.bounty.claim_message}",
				BountyClaimConfirm = "$bv{ui.hub.bounty.claim_confirm}",
				MemoryArchiveButton = "$bv{memory.ui.archive_button}",
				MemoryConfirmTitle = "$bv{memory.ui.confirm_title}",
				MemoryConfirmMessage = "$bv{memory.ui.confirm_message}",
				MemoryConfirmWarning = "$bv{memory.ui.confirm_warning}",
				MemoryEmptyCandidates = "$bv{memory.ui.empty_candidates}",
				MemoryEmptyRecords = "$bv{memory.ui.empty_records}",
				MemoryResultTitle = "$bv{memory.ui.result_title}",
				MemoryRewards = "$bv{memory.ui.rewards}",
				MemoryLevel = "$bv{memory.ui.level}",
				MemoryDays = "$bv{memory.ui.days}",
				MemoryArchiveDay = "$bv{memory.ui.archive_day}",
				MemoryShopBuy = "$bv{memory.shop.ui.buy}",
				MemoryShopConfirmTitle = "$bv{memory.shop.ui.confirm_title}",
				MemoryShopConfirmMessage = "$bv{memory.shop.ui.confirm_message}",
				MemoryShopResultTitle = "$bv{memory.shop.ui.result_title}",
				MemoryShopEmpty = "$bv{memory.shop.ui.empty}"
			},
			Tabs = [
				{
					ID = "summon",
					Title = "$bv{ui.hub.tab.gacha}",
					Body = "$bv{ui.hub.tab.gacha.body}"
				},
				{ ID = "chapters", Title = "$bv{chapter.ui.tab}", Body = "$bv{chapter.ui.intro}" },
				{
					ID = "bounties",
					Title = "$bv{ui.hub.tab.bounties}",
					Body = "$bv{ui.hub.tab.bounties.body}"
				},
				{
					ID = "memory_inscribe",
					Title = "$bv{ui.hub.tab.memory_inscribe}",
					Body = "$bv{ui.hub.tab.memory_inscribe.body}"
				},
				{
					ID = "memory_shop",
					Title = "$bv{ui.hub.tab.memory_shop}",
					Body = "$bv{ui.hub.tab.memory_shop.body}"
				},
				{
					ID = "memory_biographies",
					Title = "$bv{ui.hub.tab.memory_biographies}",
					Body = "$bv{ui.hub.tab.memory_biographies.body}"
				}
			]
		};
	}

	q.summonBattleValkyrie <- function( _request )
	{
		local valkyrieID = typeof _request == "table" && "ValkyrieID" in _request ? _request.ValkyrieID : _request;
		local skinID = typeof _request == "table" && "SkinID" in _request ? _request.SkinID : null;
		return ::$bvvar{namespace}.summonValkyrie(valkyrieID, this, skinID);
	}

	q.upgradeTheHertaEquipment <- function( _request )
	{
		return ::$bvvar{namespace}.performTheHertaResearch(_request);
	}
	q.getRyzaAlchemyState <- function(request=null) { return ::$bvvar{namespace}.RyzaAlchemy.dto(); }
	q.previewRyzaSynthesis <- function(request) { return ::$bvvar{namespace}.RyzaAlchemy.preview(request); }
	q.performRyzaSynthesis <- function(request) { return ::$bvvar{namespace}.RyzaAlchemy.craft(request); }
	q.maintainRyzaPet <- function(request) { return ::$bvvar{namespace}.RyzaAlchemy.maintain(request); }

	q.saveFiveValkyrieLoadout <- function( _request )
	{
		return ::$bvvar{namespace}.FiveValkyries.save(_request);
	}

	q.saveLilySpiritLoadout <- function( _request )
	{
		return ::$bvvar{namespace}.setLilySpiritLoadout(_request);
	}

	q.grantBattleValkyrieSkinItem <- function( _request )
	{
		local valkyrieID = typeof _request == "table" && "ValkyrieID" in _request ? _request.ValkyrieID : _request;
		local skinID = typeof _request == "table" && "SkinID" in _request ? _request.SkinID : null;
		return ::$bvvar{namespace}.grantValkyrieSkinItem(valkyrieID, this, skinID);
	}

	q.setBattleValkyriesWorldLeader <- function( _request )
	{
		local valkyrieID = typeof _request == "table" && "ValkyrieID" in _request ? _request.ValkyrieID : _request;
		local skinID = typeof _request == "table" && "SkinID" in _request ? _request.SkinID : null;
		return ::$bvvar{namespace}.setWorldPartyLeaderValkyrie(valkyrieID, skinID);
	}

	q.pullBattleValkyrieGacha <- function()
	{
		return ::$bvvar{namespace}.pullGachaValkyrie(this);
	}

	q.selectBattleValkyrieGachaTarget <- function( _request )
	{
		local valkyrieID = typeof _request == "table" && "ValkyrieID" in _request ? _request.ValkyrieID : _request;
		local skinID = typeof _request == "table" && "SkinID" in _request ? _request.SkinID : null;
		return ::$bvvar{namespace}.selectGachaValkyrie(valkyrieID, skinID);
	}

	q.acceptBattleValkyrieBounty <- function( _bountyID )
	{
		::$bvvar{namespace}.logValkyrieBountyDebug("backend.enter", _bountyID);
		local result = ::$bvvar{namespace}.tryAcceptValkyrieBounty(_bountyID);
		local response = {
			Success = result != null && "Success" in result && result.Success,
			Code = result != null && "Code" in result ? result.Code : "world_unavailable",
			Message = ""
		};
		if (response.Success)
		{
			response.Message = "$bv{ui.hub.bounty.accepted}";
		}
		else if (response.Code == "invalid_bounty")
		{
			response.Message = "$bv{ui.hub.bounty.error.invalid_bounty}";
		}
		else if (response.Code == "active_contract")
		{
			response.Message = "$bv{ui.hub.bounty.error.active_contract}";
		}
		else if (response.Code == "already_owned")
		{
			response.Message = "$bv{ui.hub.bounty.error.already_owned}";
		}
		else if (response.Code == "already_completed")
		{
			response.Message = "$bv{ui.hub.bounty.error.already_completed}";
		}
		else if (response.Code == "world_unavailable")
		{
			response.Message = "$bv{ui.hub.bounty.error.world_unavailable}";
		}
		else if (response.Code == "no_home")
		{
			response.Message = "$bv{ui.hub.bounty.error.no_home}";
		}
		else if (response.Code == "no_enemy_theme")
		{
			response.Message = "$bv{ui.hub.bounty.error.no_enemy_theme}";
		}
		else if (response.Code == "spawn_failed")
		{
			response.Message = "$bv{ui.hub.bounty.error.spawn_failed}";
		}
		else
		{
			response.Message = "$bv{ui.hub.bounty.error.world_unavailable}";
		}
		::$bvvar{namespace}.logValkyrieBountyDebug("backend.return", _bountyID, "success=" + response.Success + " code=" + response.Code);
		return response;
	}

	q.claimBattleValkyrieBountyRecruit <- function( _valkyrieID )
	{
		local result = ::$bvvar{namespace}.claimPendingValkyrieBountyRecruit(_valkyrieID, this);
		if (result.Success && result.RecruitOutcome == "immediate")
		{
			result.Message <- "$bv{ui.hub.bounty.claim_success}";
		}
		else if (result.Success && result.RecruitOutcome == "already_owned")
		{
			result.Message <- "$bv{ui.hub.bounty.claim_already_owned}";
		}
		else if (result.Code == "pending_not_found")
		{
			result.Message <- "$bv{ui.hub.bounty.error.pending_not_found}";
		}
		else if (result.Code == "roster_full")
		{
			result.Message <- "$bv{ui.hub.bounty.error.roster_full}";
		}
		else if (result.Code == "recruit_create_failed")
		{
			result.Message <- "$bv{ui.hub.bounty.error.recruit_create_failed}";
		}
		else if (result.Code == "invalid_bounty")
		{
			result.Message <- "$bv{ui.hub.bounty.error.invalid_bounty}";
		}
		else
		{
			result.Message <- "$bv{ui.hub.bounty.error.world_unavailable}";
		}

		return result;
	}

	q.archiveBattleValkyriesBrotherMemory <- function( _request )
	{
		local actorID = typeof _request == "table" && "ActorID" in _request ? _request.ActorID : _request;
		return ::$bvvar{namespace}.archiveOrdinaryBrotherMemory(actorID);
	}

	q.purchaseBattleValkyriesMemoryProduct <- function( _request )
	{
		local productID = typeof _request == "table" && "ProductID" in _request ? _request.ProductID : _request;
		return ::$bvvar{namespace}.purchaseMemoryShopProduct(productID);
	}
});
