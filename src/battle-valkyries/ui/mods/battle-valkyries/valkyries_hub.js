(function()
{
	"use strict";

	var namespace = "$bvvar{namespace}";
	var modID = "$bvvar{modId}";
	var openHubKeybindID = "OpenHub";
	var BattleValkyriesHubModule = function()
	{
		this.mIconPath = "ui/items/$bvvar{iconPrefix}/valkyries_hub_icon.png";
		this.mFallbackData = {
			Title: "$bv{ui.hub.title}",
			Body: "$bv{ui.hub.body}",
			Close: "$bv{ui.hub.close}",
			ButtonTitle: "$bv{ui.hub.button_tooltip}",
			SummonCost: 1000,
			GachaModeEnabled: true,
			RosterEnabled: false,
			GachaCost: 100,
			GachaProgress: 4,
			GachaProgressMax: 4,
			GachaSelectedValkyrieID: "",
			GachaSelectedSkinID: "",
			GachaSelectedValkyrieName: "",
			SummonSlots: [],
			BountyCards: [],
			ChapterCards: [],
			MemoryArchive: { Resources: [], Candidates: [], Records: [] },
			MemoryShop: { Resources: [], Products: [] },
			ActiveContractType: "",
			Messages: {
				SummonButton: "$bv{ui.hub.summon.button}",
				SkinItemButton: "$bv{ui.hub.skin_item.button}",
				SkinItemResultTitle: "$bv{ui.hub.skin_item.result_title}",
				LeaderSetButton: "$bv{ui.hub.leader.set}",
				LeaderCurrentButton: "$bv{ui.hub.leader.current}",
				LeaderResultTitle: "$bv{ui.hub.leader.result_title}",
				ConfirmTitle: "$bv{ui.hub.summon.confirm_title}",
				ConfirmMessage: "$bv{ui.hub.summon.confirm_message}",
				ConfirmPrefix: "$bv{ui.hub.summon.confirm_prefix}",
				ConfirmSuffix: "$bv{ui.hub.summon.confirm_suffix}",
				ConfirmYes: "$bv{ui.hub.summon.confirm_yes}",
				Cancel: "$bv{ui.hub.summon.cancel}",
				OK: "$bv{ui.hub.summon.ok}",
				ResultTitle: "$bv{ui.hub.summon.result_title}",
				Unavailable: "$bv{ui.hub.summon.error.unavailable}",
				GachaPullButton: "$bv{ui.hub.gacha.pull.button}",
				GachaCost: "$bv{ui.hub.gacha.cost}",
				GachaProgress: "$bv{ui.hub.gacha.progress}",
				GachaSelected: "$bv{ui.hub.gacha.selected}",
				GachaSelectedNone: "$bv{ui.hub.gacha.selected.none}",
				GachaSelectButton: "$bv{ui.hub.gacha.select.button}",
				GachaSelectedButton: "$bv{ui.hub.gacha.select.selected}",
				GachaResultTitle: "$bv{ui.hub.gacha.result_title}",
				BountyWanted: "$bv{ui.hub.bounty.wanted}",
				BountyReward: "$bv{ui.hub.bounty.reward}",
				BountyEscortBudget: "$bv{ui.hub.bounty.escort_budget}",
				BountyFixedChampions: "$bv{ui.hub.bounty.fixed_champions}",
				BountyChampionPolicy: "$bv{ui.hub.bounty.champion_policy}",
				BountyConfirmTitle: "$bv{ui.hub.bounty.confirm_title}",
				BountyConfirmMessage: "$bv{ui.hub.bounty.confirm_message}",
				BountyAccept: "$bv{ui.hub.bounty.accept}",
				BountyClaim: "$bv{ui.hub.bounty.claim}",
				BountyClaimTitle: "$bv{ui.hub.bounty.claim_title}",
				BountyClaimMessage: "$bv{ui.hub.bounty.claim_message}",
				BountyClaimConfirm: "$bv{ui.hub.bounty.claim_confirm}",
				MemoryIntro: "$bv{memory.ui.intro}",
				MemoryBiographyIntro: "$bv{memory.ui.biography_intro}",
				MemoryEmptyCandidates: "$bv{memory.ui.empty_candidates}",
				MemoryEmptyRecords: "$bv{memory.ui.empty_records}",
				MemoryAttributes: "$bv{memory.ui.attributes}",
				MemoryRewards: "$bv{memory.ui.rewards}",
				MemoryEliteCount: "$bv{memory.ui.elite_count}",
				MemoryLegendaryCount: "$bv{memory.ui.legendary_count}",
				MemoryTierNone: "$bv{memory.tier.none}",
				MemoryTierFragment: "$bv{memory.tier.fragment}",
				MemoryTierCrystal: "$bv{memory.tier.crystal}",
				MemoryTierEternal: "$bv{memory.tier.eternal}",
				MemoryNextThreshold: "$bv{memory.ui.next_threshold}",
				MemoryArchiveButton: "$bv{memory.ui.archive_button}",
				MemoryConfirmTitle: "$bv{memory.ui.confirm_title}",
				MemoryConfirmMessage: "$bv{memory.ui.confirm_message}",
				MemoryConfirmWarning: "$bv{memory.ui.confirm_warning}",
				MemoryResultTitle: "$bv{memory.ui.result_title}",
				MemoryBiographyTemplate: "$bv{memory.ui.biography_template}",
				MemoryLevel: "$bv{memory.ui.level}",
				MemoryDays: "$bv{memory.ui.days}",
				MemoryArchiveDay: "$bv{memory.ui.archive_day}",
				MemoryShopBuy: "$bv{memory.shop.ui.buy}",
				MemoryShopConfirmTitle: "$bv{memory.shop.ui.confirm_title}",
				MemoryShopConfirmMessage: "$bv{memory.shop.ui.confirm_message}",
				MemoryShopResultTitle: "$bv{memory.shop.ui.result_title}",
				MemoryShopEmpty: "$bv{memory.shop.ui.empty}"
			},
			Tabs: [
				{ ID: "summon", Title: "$bv{ui.hub.tab.gacha}", Body: "$bv{ui.hub.tab.gacha.body}" },
				{ ID: "chapters", Title: "$bv{chapter.ui.tab}", Body: "$bv{chapter.ui.intro}" },
				{ ID: "bounties", Title: "$bv{ui.hub.tab.bounties}", Body: "$bv{ui.hub.tab.bounties.body}" },
				{ ID: "memory_inscribe", Title: "$bv{ui.hub.tab.memory_inscribe}", Body: "$bv{ui.hub.tab.memory_inscribe.body}" },
				{ ID: "memory_shop", Title: "$bv{ui.hub.tab.memory_shop}", Body: "$bv{ui.hub.tab.memory_shop.body}" },
				{ ID: "memory_biographies", Title: "$bv{ui.hub.tab.memory_biographies}", Body: "$bv{ui.hub.tab.memory_biographies.body}" }
			]
		};
		this.mOverlay = null;
		this.mTitle = null;
		this.mBody = null;
		this.mTabsContainer = null;
		this.mCloseButton = null;
		this.mActiveTabID = null;
		this.mBackendHandle = null;
		this.mData = null;
		this.mSummonFilters = { Search: "", Role: "", Stage: "", Status: "", Tag: "", Sort: "" };
		this.mGuideText = {
			Search: "$bv{ui.hub.guide.ui.search}", Role: "$bv{ui.hub.guide.ui.role}", Stage: "$bv{ui.hub.guide.ui.stage}",
			Status: "$bv{ui.hub.guide.ui.status}", Tag: "$bv{ui.hub.guide.ui.tag}", Sort: "$bv{ui.hub.guide.ui.sort}",
			All: "$bv{ui.hub.guide.ui.all}", Reset: "$bv{ui.hub.guide.ui.reset}", Default: "$bv{ui.hub.guide.ui.default}",
			Unrecruited: "$bv{ui.hub.guide.ui.unrecruited}", Recruited: "$bv{ui.hub.guide.ui.recruited}",
			Available: "$bv{ui.hub.guide.ui.available}", Chapter: "$bv{ui.hub.guide.ui.chapter}",
			StartupSort: "$bv{ui.hub.guide.ui.startup_sort}", MatureSort: "$bv{ui.hub.guide.ui.mature_sort}",
			Count: "$bv{ui.hub.guide.ui.count}", Empty: "$bv{ui.hub.guide.ui.empty}", Recruit: "$bv{ui.hub.guide.ui.recruit}",
			Strength: "$bv{ui.hub.guide.ui.strength}", Startup: "$bv{ui.hub.guide.ui.startup}", Mature: "$bv{ui.hub.guide.ui.mature}",
			Pending: "$bv{ui.hub.guide.ui.pending}", Read: "$bv{ui.hub.guide.ui.read}", Features: "$bv{ui.hub.guide.ui.features}",
			Timing: "$bv{ui.hub.guide.ui.timing}", Early: "$bv{ui.hub.guide.ui.early}", Mid: "$bv{ui.hub.guide.ui.mid}",
			Late: "$bv{ui.hub.guide.ui.late}", Baseline: "$bv{ui.hub.guide.ui.baseline}"
		};
		this.mPopup = null;
		this.mFullscreenDetail = null;
		this.mTopbarOptionsModule = null;
		this.mHotkeyDown = false;
		this.mHotkeyHandlerRegistered = false;
		this.mWorldScreenHidden = false;
		this.mLifecycleGeneration = 0;
		this.mPendingChapterOpens = [];
		this.mChapterOpenInFlight = null;
		this.mBountyAccepting = false;
		this.mBountyClaiming = false;
		this.mSelectedMemoryActorID = null;
		this.mSelectedMemoryRecordID = null;
		this.mMemoryArchiving = false;
		this.mMemoryShopPurchasing = false;
	};

	BattleValkyriesHubModule.prototype.ensureDialog = function()
	{
		if (this.mOverlay !== null && this.mOverlay.parent().length > 0)
		{
			return this.mOverlay;
		}

		var self = this;
		var parent = $(".root-screen");
		if (parent.length === 0)
		{
			parent = $("body");
		}

		this.mOverlay = $('<div class="battle-valkyries-hub-overlay display-none"></div>');
		var dialog = $('<div class="battle-valkyries-hub-dialog ui-control"></div>');
		var header = $('<div class="battle-valkyries-hub-header"></div>');

		this.mTitle = $('<div class="battle-valkyries-hub-title title-font-big font-bold font-bottom-shadow font-color-title"></div>');
		this.mCloseButton = $('<div class="battle-valkyries-hub-close text-font-normal font-bold"></div>');
		this.mTabsContainer = $('<div class="battle-valkyries-hub-tabs"></div>');
		this.mBody = $('<div class="battle-valkyries-hub-body text-font-normal font-color-description"></div>');

		this.mCloseButton.on("click", function()
		{
			self.close();
		});

		this.mBody.on("wheel mousewheel DOMMouseScroll", function(_event)
		{
			self.handleBodyWheel(_event);
		});

		this.mOverlay.on("click", function(_event)
		{
			if (_event.target === self.mOverlay[0])
			{
				self.close();
			}
		});

		header.append(this.mTitle);
		var rosterButton = $('<button type="button" class="battle-valkyries-roster-hub-button"></button>').text("$bv{roster.title}").hide();
		rosterButton.on("click", function()
		{
			if (!self.mData || self.mData.RosterEnabled !== true) return;
			var handle = self.mBackendHandle;
			self.close();
			SQ.call(handle, "openBattleValkyrieRoster", null);
		});
		header.append(rosterButton);
		header.append(this.mCloseButton);
		dialog.append(header);
		dialog.append(this.mTabsContainer);
		dialog.append(this.mBody);
		this.mOverlay.append(dialog);
		parent.append(this.mOverlay);

		return this.mOverlay;
	};

	BattleValkyriesHubModule.prototype.handleBodyWheel = function(_event, _scrollArea)
	{
		var scrollArea = _scrollArea || this.mBody;
		if (scrollArea === null || scrollArea.length === 0)
		{
			return;
		}

		var element = scrollArea[0];
		if (element.scrollHeight <= element.clientHeight)
		{
			return;
		}

		var event = _event.originalEvent || _event;
		var delta = 0;

		if (event.deltaY !== undefined && event.deltaY !== 0)
		{
			delta = event.deltaY;
		}
		else if (event.wheelDelta !== undefined && event.wheelDelta !== 0)
		{
			delta = -event.wheelDelta;
		}
		else if (event.detail !== undefined && event.detail !== 0)
		{
			delta = event.detail * 40;
		}

		if (delta === 0)
		{
			return;
		}

		var maxScrollTop = element.scrollHeight - element.clientHeight;
		var direction = delta > 0 ? 1 : -1;
		var target = element.scrollTop + direction * 96;

		if (target < 0)
		{
			target = 0;
		}
		else if (target > maxScrollTop)
		{
			target = maxScrollTop;
		}

		_event.preventDefault();
		_event.stopPropagation();
		element.scrollTop = target;
	};

	BattleValkyriesHubModule.prototype.loadData = function(_backendHandle, _callback)
	{
		if (_backendHandle === null || _backendHandle === undefined)
		{
			_callback(this.mFallbackData);
			return;
		}

		var self = this;
		SQ.call(_backendHandle, "queryBattleValkyriesHubData", null, function(_data)
		{
			if (_data === null || _data === undefined || typeof _data !== "object")
			{
				_callback(self.mFallbackData);
				return;
			}

			var gacha = self.normalizeGachaData(_data);
			_callback({
				Title: _data.Title || self.mFallbackData.Title,
				Body: _data.Body || self.mFallbackData.Body,
				Close: _data.Close || self.mFallbackData.Close,
				ButtonTitle: _data.ButtonTitle || self.mFallbackData.ButtonTitle,
				SummonCost: typeof _data.SummonCost === "number" ? _data.SummonCost : self.mFallbackData.SummonCost,
				GachaModeEnabled: gacha.ModeEnabled,
				FreeValkyrieChoice: _data.FreeValkyrieChoice === true,
				RosterEnabled: _data.RosterEnabled === true,
				GachaCost: gacha.Cost,
				GachaProgress: gacha.Progress,
				GachaProgressMax: gacha.ProgressMax,
				GachaSelectedValkyrieID: gacha.SelectedID,
				GachaSelectedSkinID: gacha.SelectedSkinID,
				GachaSelectedValkyrieName: gacha.SelectedName,
				SummonSlots: self.normalizeSummonSlots(_data.SummonSlots),
				RecruitGuideCatalog: self.normalizeRecruitGuideCatalog(_data.RecruitGuideCatalog),
				BountyCards: self.normalizeBountyCards(_data.BountyCards),
				ChapterCards: Array.isArray(_data.ChapterCards) ? _data.ChapterCards : [],
				MemoryArchive: self.normalizeMemoryArchive(_data.MemoryArchive),
				MemoryShop: self.normalizeMemoryShop(_data.MemoryShop),
				ActiveContractType: _data.ActiveContractType || "",
				Messages: self.normalizeMessages(_data.Messages),
				Tabs: self.normalizeTabs(_data.Tabs)
			});
		});
	};

	BattleValkyriesHubModule.prototype.normalizeGachaData = function(_data)
	{
		if (_data === null || _data === undefined || typeof _data !== "object")
		{
			return {
				ModeEnabled: this.mFallbackData.GachaModeEnabled,
				Cost: this.mFallbackData.GachaCost,
				Progress: this.mFallbackData.GachaProgress,
				ProgressMax: this.mFallbackData.GachaProgressMax,
				SelectedID: "",
				SelectedSkinID: "",
				SelectedName: ""
			};
		}

		return {
			ModeEnabled: _data.GachaModeEnabled === true,
			Cost: typeof _data.GachaCost === "number" ? _data.GachaCost : this.mFallbackData.GachaCost,
			Progress: typeof _data.GachaProgress === "number" ? _data.GachaProgress : this.mFallbackData.GachaProgress,
			ProgressMax: typeof _data.GachaProgressMax === "number" ? _data.GachaProgressMax : this.mFallbackData.GachaProgressMax,
			SelectedID: _data.GachaSelectedValkyrieID || "",
			SelectedSkinID: _data.GachaSelectedSkinID || "",
			SelectedName: _data.GachaSelectedValkyrieName || ""
		};
	};

	BattleValkyriesHubModule.prototype.normalizeMessages = function(_messages)
	{
		var result = {};
		var fallback = this.mFallbackData.Messages;

		for (var key in fallback)
		{
			if (fallback.hasOwnProperty(key))
			{
				result[key] = fallback[key];
			}
		}

		if (_messages === null || _messages === undefined || typeof _messages !== "object")
		{
			return result;
		}

		for (var messageKey in _messages)
		{
			if (_messages.hasOwnProperty(messageKey) && _messages[messageKey] !== null && _messages[messageKey] !== undefined)
			{
				result[messageKey] = _messages[messageKey];
			}
		}

		return result;
	};

	BattleValkyriesHubModule.prototype.normalizeSummonSlots = function(_slots)
	{
		if (!jQuery.isArray(_slots))
		{
			return [];
		}

		var result = [];
		for (var i = 0; i < _slots.length; ++i)
		{
			var slot = _slots[i];
			if (slot === null || slot === undefined || typeof slot !== "object")
			{
				continue;
			}

			result.push({
				ID: slot.ID || ("slot_" + i),
				Name: slot.Name || "",
				Portrait: slot.Portrait || "",
				Background: slot.Background || "",
				RecruitGuide: this.normalizeRecruitGuide(slot.RecruitGuide),
				ChapterRecruitOnly: slot.ChapterRecruitOnly === true,
				IsPlaceholder: slot.IsPlaceholder === true,
				Detail: this.normalizeSummonDetail(slot.Detail),
				Status: slot.Status || "",
				State: slot.State || "locked",
				CanSummon: slot.CanSummon === true,
				CanGachaSelect: slot.CanGachaSelect === true,
				IsGachaSelected: slot.IsGachaSelected === true,
				GachaSelectedSkinID: slot.GachaSelectedSkinID || "",
				CanSetWorldLeader: slot.CanSetWorldLeader === true,
				IsWorldLeader: slot.IsWorldLeader === true,
				WorldLeaderSkinID: slot.WorldLeaderSkinID || ""
			});
		}

		return result;
	};

	BattleValkyriesHubModule.prototype.normalizeRecruitGuideCatalog = function(_catalog)
	{
		var catalog = _catalog && typeof _catalog === "object" ? _catalog : {};
		var options = function(_rows)
		{
			var result = [];
			if (jQuery.isArray(_rows)) for (var i = 0; i < _rows.length; ++i)
			{
				var row = _rows[i];
				if (row && typeof row.ID === "string" && typeof row.Name === "string") result.push({ ID: row.ID, Name: row.Name });
			}
			return result;
		};
		return { Roles: options(catalog.Roles), Stages: options(catalog.Stages), Tags: options(catalog.Tags), Basis: catalog.Basis || "", Notice: catalog.Notice || "" };
	};

	BattleValkyriesHubModule.prototype.normalizeRecruitGuide = function(_guide)
	{
		if (!_guide || typeof _guide !== "object" || !jQuery.isArray(_guide.RoleIDs)) return null;
		var priorities = {}, texts = {};
		var stages = ["early", "mid", "late"];
		for (var i = 0; i < stages.length; ++i)
		{
			var stage = stages[i];
			var rank = _guide.Priorities && _guide.Priorities[stage];
			priorities[stage] = typeof rank === "number" && rank >= 0 && rank <= 3 ? rank : 0;
			texts[stage] = _guide.PriorityText && typeof _guide.PriorityText[stage] === "string" ? _guide.PriorityText[stage] : "";
		}
		return {
			RoleIDs: _guide.RoleIDs.slice(0), RoleText: _guide.RoleText || "", StageID: _guide.StageID || "", StageText: _guide.StageText || "",
			InvestmentText: _guide.InvestmentText || "", Startup: _guide.Startup || "?", Mature: _guide.Mature || "?",
			StartupRank: typeof _guide.StartupRank === "number" ? _guide.StartupRank : 0,
			MatureRank: typeof _guide.MatureRank === "number" ? _guide.MatureRank : 0,
			Priorities: priorities, PriorityText: texts, TagIDs: jQuery.isArray(_guide.TagIDs) ? _guide.TagIDs.slice(0) : [],
			TagText: _guide.TagText || "", Summary: _guide.Summary || "", Analysis: _guide.Analysis || "", Version: _guide.Version || ""
		};
	};

	BattleValkyriesHubModule.prototype.filterSummonSlots = function(_slots)
	{
		var filters = this.mSummonFilters;
		var query = filters.Search.replace(/^\s+|\s+$/g, "").toLowerCase();
		var result = [];
		for (var i = 0; i < _slots.length; ++i)
		{
			var slot = _slots[i], guide = slot.RecruitGuide;
			if (slot.IsPlaceholder) continue;
			if (query && (slot.Name + " " + slot.ID).toLowerCase().indexOf(query) < 0) continue;
			if (filters.Role && (!guide || guide.RoleIDs.indexOf(filters.Role) < 0)) continue;
			if (filters.Stage && (!guide || guide.StageID !== filters.Stage)) continue;
			if (filters.Tag && (!guide || guide.TagIDs.indexOf(filters.Tag) < 0)) continue;
			if (filters.Status === "unrecruited" && slot.State === "summoned") continue;
			if (filters.Status === "recruited" && slot.State !== "summoned") continue;
			if (filters.Status === "available" && !slot.CanSummon) continue;
			if (filters.Status === "chapter" && !slot.ChapterRecruitOnly) continue;
			result.push({ Slot: slot, Index: i });
		}
		var score = function(entry)
		{
			var guide = entry.Slot.RecruitGuide;
			if (!guide) return -1;
			if (filters.Sort === "startup") return guide.StartupRank;
			if (filters.Sort === "mature") return guide.MatureRank;
			return guide.Priorities[filters.Sort] || 0;
		};
		if (filters.Sort) result.sort(function(a, b) { return score(b) - score(a) || a.Index - b.Index; });
		var slots = [];
		for (var j = 0; j < result.length; ++j) slots.push(result[j].Slot);
		return slots;
	};

	BattleValkyriesHubModule.prototype.renderSummonFilters = function(_grid, _count)
	{
		var self = this, text = this.mGuideText, filters = this.mSummonFilters;
		var catalog = this.normalizeRecruitGuideCatalog(this.mData !== null ? this.mData.RecruitGuideCatalog : null);
		var panel = $('<div class="battle-valkyries-summon-filters"></div>');
		var rowOne = $('<div class="battle-valkyries-summon-filter-row"></div>');
		var rowTwo = $('<div class="battle-valkyries-summon-filter-row"></div>');
		var update = function() { self.renderSummonGrid(_grid, _count); };
		var search = $('<input type="text" class="battle-valkyries-summon-search text-font-small"/>');
		search.attr("placeholder", text.Search).attr("aria-label", text.Search).val(filters.Search);
		search.on("input change keyup", function()
		{
			var value = $(this).val();
			if (filters.Search !== value) { filters.Search = value; update(); }
		});
		search.on("keydown", function(event) { event.stopPropagation(); });
		rowOne.append(search);
		var controls = [];
		var closeMenus = function() { for (var i = 0; i < controls.length; ++i) controls[i].Close(); };
		var select = function(_row, _key, _label, _options, _first)
		{
			// Coherent's native select popup is not usable in the game. Keep the
			// entire picker in the same DOM and use ordinary game-compatible buttons.
			var wrap = $('<div class="battle-valkyries-summon-filter text-font-small"></div>');
			wrap.append($('<span></span>').text(_label));
			var picker = $('<div class="battle-valkyries-summon-picker"></div>');
			var input = $('<button type="button" class="battle-valkyries-summon-picker-button text-font-small"></button>');
			var label = $('<span class="battle-valkyries-summon-picker-value"></span>');
			input.attr("role", "combobox").attr("aria-label", _label).attr("aria-haspopup", "listbox").attr("aria-expanded", "false");
			input.append(label).append($('<span class="battle-valkyries-summon-picker-arrow" aria-hidden="true"></span>').text("▾"));
			var menuID = "$bvvar{privateFolder}-summon-menu-" + _key;
			var menu = $('<div class="battle-valkyries-summon-picker-menu"></div>').attr("role", "listbox").attr("id", menuID).attr("aria-label", _label).hide();
			input.attr("aria-controls", menuID);
			var choices = [{ ID: "", Name: _first || text.All }].concat(_options);
			var close = function() { menu.hide(); picker.removeClass("is-open"); input.attr("aria-expanded", "false"); };
			var refresh = function()
			{
				var current = choices[0], found = false;
				for (var i = 0; i < choices.length; ++i) if (choices[i].ID === filters[_key]) { current = choices[i]; found = true; break; }
				if (!found) filters[_key] = "";
				label.text(current.Name); input.attr("title", _label + ": " + current.Name);
				menu.children().each(function() { $(this).attr("aria-selected", $(this).data("choice-id") === filters[_key] ? "true" : "false"); });
			};
			var open = function() { closeMenus(); menu.show(); picker.addClass("is-open"); input.attr("aria-expanded", "true"); };
			for (var i = 0; i < choices.length; ++i)
			{
				var option = $('<button type="button" class="battle-valkyries-summon-picker-option text-font-small"></button>');
				option.attr("role", "option").attr("tabindex", "-1").text(choices[i].Name).data("choice-id", choices[i].ID);
				option.on("click", function(event)
				{
					event.preventDefault(); event.stopPropagation(); filters[_key] = $(this).data("choice-id");
					refresh(); close(); update(); input.focus();
				});
				menu.append(option);
			}
			input.on("click", function(event)
			{
				event.preventDefault(); event.stopPropagation();
				if (picker.hasClass("is-open")) close(); else open();
			});
			input.on("keydown", function(event)
			{
				event.stopPropagation();
				if (event.which === 40 || event.which === 38)
				{
					event.preventDefault(); open(); menu.children().eq(event.which === 40 ? 0 : choices.length - 1).focus();
				}
				else if (event.which === 27) { event.preventDefault(); close(); }
			});
			menu.on("keydown", function(event)
			{
				event.stopPropagation();
				if (event.which === 27) { event.preventDefault(); close(); input.focus(); }
				else if (event.which === 40 || event.which === 38 || event.which === 36 || event.which === 35)
				{
					event.preventDefault();
					var index = menu.children().index(event.target);
					index = event.which === 36 ? 0 : event.which === 35 ? choices.length - 1 : Math.max(0, Math.min(choices.length - 1, index + (event.which === 40 ? 1 : -1)));
					menu.children().eq(index).focus();
				}
			});
			menu.on("wheel mousewheel DOMMouseScroll", function(event)
			{
				self.handleBodyWheel(event, menu); event.stopPropagation();
			});
			wrap.on("focusout", function()
			{
				setTimeout(function() { if (!jQuery.contains(wrap[0], document.activeElement)) close(); }, 0);
			});
			controls.push({ Close: close, Reset: refresh }); refresh();
			picker.append(input).append(menu); wrap.append(picker); _row.append(wrap);
		};
		select(rowOne, "Role", text.Role, catalog.Roles);
		select(rowOne, "Stage", text.Stage, catalog.Stages);
		select(rowTwo, "Status", text.Status, [
			{ ID: "unrecruited", Name: text.Unrecruited }, { ID: "recruited", Name: text.Recruited },
			{ ID: "available", Name: text.Available }, { ID: "chapter", Name: text.Chapter }
		]);
		select(rowTwo, "Tag", text.Tag, catalog.Tags);
		select(rowTwo, "Sort", text.Sort, [
			{ ID: "early", Name: text.Early }, { ID: "mid", Name: text.Mid }, { ID: "late", Name: text.Late },
			{ ID: "startup", Name: text.StartupSort }, { ID: "mature", Name: text.MatureSort }
		], text.Default);
		var reset = $('<button type="button" class="battle-valkyries-summon-reset text-font-small"></button>').text(text.Reset);
		reset.on("click", function()
		{
			for (var key in filters) if (filters.hasOwnProperty(key)) filters[key] = "";
			closeMenus(); search.val(""); for (var i = 0; i < controls.length; ++i) controls[i].Reset(); update();
		});
		rowTwo.append(reset); panel.append(rowOne).append(rowTwo);
		this.mBody.off("click.bvSummonFilters").on("click.bvSummonFilters", closeMenus);
		this.mBody.append(panel);
	};

	BattleValkyriesHubModule.prototype.recruitGuideMessage = function(_slot)
	{
		var g = _slot.RecruitGuide, t = this.mGuideText;
		if (!g) return t.Pending;
		return t.Role + ": " + g.RoleText + "\n" + t.Recruit + ": " + g.StageText + " / " + g.InvestmentText +
			"\n" + t.Strength + ": " + t.Startup + " " + g.Startup + " / " + t.Mature + " " + g.Mature +
			"\n" + t.Timing + ": " + t.Early + " " + g.PriorityText.early + " / " + t.Mid + " " + g.PriorityText.mid + " / " + t.Late + " " + g.PriorityText.late +
			"\n" + t.Features + ": " + g.TagText + "\n\n" + g.Analysis +
			(_slot.ChapterRecruitOnly ? "\n\n" + _slot.Status : "") + "\n\n" +
			this.normalizeRecruitGuideCatalog(this.mData !== null ? this.mData.RecruitGuideCatalog : null).Basis;
	};

	BattleValkyriesHubModule.prototype.showRecruitGuideMessage = function(_message, _title)
	{
		this.showMessage(_message, _title);
		this.mPopup.addClass("battle-valkyries-guide-popup");
	};

	BattleValkyriesHubModule.prototype.renderRecruitGuide = function(_slot)
	{
		var self = this, g = _slot.RecruitGuide, t = this.mGuideText;
		var panel = $('<div class="battle-valkyries-recruit-guide text-font-small"></div>');
		var line = function(_class, _text)
		{
			return $('<div class="battle-valkyries-recruit-line"></div>').addClass(_class).text(_text).attr("title", _text);
		};
		panel.append(line("recruit-role", t.Role + "  " + (g ? g.RoleText : t.Pending)));
		panel.append(line("recruit-stage", t.Recruit + "  " + (g ? g.StageText + " / " + g.InvestmentText : t.Pending)));
		panel.append(line("recruit-strength", t.Strength + "  " + (g ? t.Startup + " " + g.Startup + " / " + t.Mature + " " + g.Mature : t.Pending)));
		var summary = $('<button type="button" class="battle-valkyries-recruit-summary text-font-small"></button>');
		summary.text(g ? g.Summary : t.Pending).attr("title", g ? g.Analysis : t.Pending).attr("aria-label", t.Read + " " + _slot.Name);
		summary.prop("disabled", !g);
		summary.on("click", function(event)
		{
			event.preventDefault(); event.stopPropagation();
			self.showRecruitGuideMessage(self.recruitGuideMessage(_slot), _slot.Name + " / " + t.Read);
		});
		panel.append(summary);
		return panel;
	};

	BattleValkyriesHubModule.prototype.normalizeBountyCards = function(_cards)
	{
		if (!jQuery.isArray(_cards))
		{
			return [];
		}

		var result = [];
		for (var i = 0; i < _cards.length; ++i)
		{
			var card = _cards[i];
			if (card === null || card === undefined || typeof card !== "object" || !card.ID)
			{
				continue;
			}

			result.push({
				ID: card.ID,
				ValkyrieID: card.ValkyrieID || "",
				Name: card.Name || "",
				Poster: card.Poster || "",
				Stars: typeof card.Stars === "number" ? card.Stars : 0,
				Reward: typeof card.Reward === "number" ? card.Reward : 0,
				OwnedValkyrieCount: typeof card.OwnedValkyrieCount === "number" ? card.OwnedValkyrieCount : 0,
				EscortBudget: typeof card.EscortBudget === "number" ? card.EscortBudget : 0,
				FixedChampionCount: typeof card.FixedChampionCount === "number" ? card.FixedChampionCount : 0,
				EnemyTheme: card.EnemyTheme || "",
				CampSummary: card.CampSummary || "",
				ChampionPolicy: card.ChampionPolicy || "",
				State: card.State || "blocked",
				Status: card.Status || "",
				CanAccept: card.CanAccept === true,
				CanClaim: card.CanClaim === true,
				IsOwned: card.IsOwned === true,
				IsCompleted: card.IsCompleted === true,
				IsActive: card.IsActive === true
			});
		}

		return result;
	};

	BattleValkyriesHubModule.prototype.normalizeMemoryRewards = function(_rewards)
	{
		var source = _rewards !== null && _rewards !== undefined && typeof _rewards === "object" ? _rewards : {};
		return {
			Fragment: typeof source.Fragment === "number" ? source.Fragment : 0,
			Crystal: typeof source.Crystal === "number" ? source.Crystal : 0,
			Eternal: typeof source.Eternal === "number" ? source.Eternal : 0,
			Emblem: typeof source.Emblem === "number" ? source.Emblem : 0
		};
	};

	BattleValkyriesHubModule.prototype.normalizeMemoryStats = function(_stats)
	{
		if (!jQuery.isArray(_stats)) return [];
		var result = [];
		for (var i = 0; i < _stats.length; ++i)
		{
			var stat = _stats[i];
			if (stat === null || stat === undefined || typeof stat !== "object") continue;
			result.push({
				Key: stat.Key || ("stat_" + i),
				Label: stat.Label || "",
				Icon: stat.Icon || "",
				Value: typeof stat.Value === "number" ? stat.Value : 0,
				Tier: typeof stat.Tier === "number" ? stat.Tier : 0,
				NextThreshold: typeof stat.NextThreshold === "number" ? stat.NextThreshold : 0
			});
		}
		return result;
	};

	BattleValkyriesHubModule.prototype.normalizeMemoryEntry = function(_entry, _isCandidate)
	{
		if (_entry === null || _entry === undefined || typeof _entry !== "object") return null;
		return {
			ActorID: _isCandidate ? _entry.ActorID : null,
			RecordID: _entry.RecordID || "",
			Name: _entry.Name || "",
			Background: _entry.Background || "",
			Portrait: _entry.Portrait || "",
			Level: typeof _entry.Level === "number" ? _entry.Level : 1,
			CompanyDays: typeof _entry.CompanyDays === "number" ? _entry.CompanyDays : 0,
			ArchiveDay: typeof _entry.ArchiveDay === "number" ? _entry.ArchiveDay : 0,
			RankKey: _entry.RankKey || "ordinary",
			RankTitle: _entry.RankTitle || "",
			EliteCount: typeof _entry.EliteCount === "number" ? _entry.EliteCount : 0,
			LegendaryCount: typeof _entry.LegendaryCount === "number" ? _entry.LegendaryCount : 0,
			Stats: this.normalizeMemoryStats(_entry.Stats),
			Rewards: this.normalizeMemoryRewards(_entry.Rewards),
			CanArchive: _isCandidate && _entry.CanArchive === true
		};
	};

	BattleValkyriesHubModule.prototype.normalizeMemoryResources = function(_resources)
	{
		if (!jQuery.isArray(_resources)) return [];
		var result = [];
		for (var i = 0; i < _resources.length; ++i)
		{
			var resource = _resources[i];
			if (resource === null || resource === undefined || typeof resource !== "object") continue;
			result.push({
				Key: resource.Key || ("resource_" + i),
				Label: resource.Label || "",
				Amount: typeof resource.Amount === "number" ? resource.Amount : 0
			});
		}
		return result;
	};

	BattleValkyriesHubModule.prototype.normalizeMemoryArchive = function(_archive)
	{
		var source = _archive !== null && _archive !== undefined && typeof _archive === "object" ? _archive : {};
		var candidates = [];
		var records = [];
		var sourceCandidates = jQuery.isArray(source.Candidates) ? source.Candidates : [];
		var sourceRecords = jQuery.isArray(source.Records) ? source.Records : [];
		for (var i = 0; i < sourceCandidates.length; ++i)
		{
			var candidate = this.normalizeMemoryEntry(sourceCandidates[i], true);
			if (candidate !== null) candidates.push(candidate);
		}
		for (var j = 0; j < sourceRecords.length; ++j)
		{
			var record = this.normalizeMemoryEntry(sourceRecords[j], false);
			if (record !== null) records.push(record);
		}
		return { Resources: this.normalizeMemoryResources(source.Resources), Candidates: candidates, Records: records };
	};

	BattleValkyriesHubModule.prototype.normalizeMemoryShop = function(_shop)
	{
		var source = _shop !== null && _shop !== undefined && typeof _shop === "object" ? _shop : {};
		var products = [];
		var sourceProducts = jQuery.isArray(source.Products) ? source.Products : [];
		for (var i = 0; i < sourceProducts.length; ++i)
		{
			var product = sourceProducts[i];
			if (product === null || product === undefined || typeof product !== "object") continue;
			var costs = [];
			var sourceCosts = jQuery.isArray(product.Cost) ? product.Cost : [];
			for (var j = 0; j < sourceCosts.length; ++j)
			{
				var cost = sourceCosts[j];
				if (cost === null || cost === undefined || typeof cost !== "object") continue;
				costs.push({
					Key: cost.Key || "",
					Label: cost.Label || "",
					Required: typeof cost.Required === "number" ? cost.Required : 0,
					Owned: typeof cost.Owned === "number" ? cost.Owned : 0,
					IsMet: cost.IsMet === true
				});
			}
			products.push({
				ID: product.ID || ("product_" + i),
				Name: product.Name || "",
				Description: product.Description || "",
				EffectLabel: product.EffectLabel || "",
				Icon: product.Icon || "",
				Cost: costs,
				CanAfford: product.CanAfford === true,
				CanBuy: product.CanBuy === true,
				Status: product.Status || ""
			});
		}
		return { Resources: this.normalizeMemoryResources(source.Resources), Products: products };
	};

	BattleValkyriesHubModule.prototype.normalizeDetailEntry = function(_entry)
	{
		if (_entry === null || _entry === undefined || typeof _entry !== "object")
		{
			return null;
		}

		return {
			Label: _entry.Label || "",
			Icon: _entry.Icon || "",
			Name: _entry.Name || "",
			Description: _entry.Description || ""
		};
	};

	BattleValkyriesHubModule.prototype.normalizeDetailSkills = function(_detail)
	{
		var entries = [];
		var source = jQuery.isArray(_detail.Skills) ? _detail.Skills : [_detail.Passive, _detail.Active];
		for (var i = 0; i < source.length; ++i)
		{
			var entry = this.normalizeDetailEntry(source[i]);
			if (!entry) continue;
			entry.Key = source[i].Key || "";
			entry.Kind = source[i].Kind || "";
			entries.push(entry);
		}
		return entries;
	};

	BattleValkyriesHubModule.prototype.normalizeDetailMedia = function(_media)
	{
		if (!_media || typeof _media !== "object") return null;
		return {
			Poster: typeof _media.Poster === "string" ? _media.Poster : "",
			Video: typeof _media.Video === "string" ? _media.Video : "",
			PositionX: typeof _media.PositionX === "number" && isFinite(_media.PositionX) ? Math.max(0, Math.min(1, _media.PositionX)) : 0.5,
			PositionY: typeof _media.PositionY === "number" && isFinite(_media.PositionY) ? Math.max(0, Math.min(1, _media.PositionY)) : 0.5
		};
	};

	BattleValkyriesHubModule.prototype.normalizeBondStage = function(_stage)
	{
		if (!_stage || typeof _stage !== "object") return null;
		var state = _stage.State === "completed" || _stage.State === "challenge" || _stage.State === "story_pending" ? _stage.State : "locked";
		return {
			Value: typeof _stage.Value === "number" ? Math.max(0, Math.min(100, _stage.Value)) : 0,
			Name: _stage.Name || "",
			Title: _stage.Title || "",
			State: state,
			Reward: _stage.Reward || "",
			IntroImage: _stage.IntroImage || "",
			CGImage: _stage.CGImage || ""
		};
	};

	BattleValkyriesHubModule.prototype.normalizeBondDetail = function(_bond)
	{
		if (!_bond || typeof _bond !== "object") return null;
		var stages = [];
		if (jQuery.isArray(_bond.Stages))
		{
			for (var i = 0; i < _bond.Stages.length; ++i)
			{
				var stage = this.normalizeBondStage(_bond.Stages[i]);
				if (stage && stage.Value > 0) stages.push(stage);
			}
		}
		var max = typeof _bond.Max === "number" && _bond.Max > 0 ? _bond.Max : 100;
		return {
			Available: _bond.Available === true,
			Type: _bond.Type === "corruption" ? "corruption" : "bond",
			Value: typeof _bond.Value === "number" ? Math.max(0, Math.min(max, _bond.Value)) : 0,
			Max: max,
			CurrentStageValue: typeof _bond.CurrentStageValue === "number" ? _bond.CurrentStageValue : 0,
			ActiveStageValue: typeof _bond.ActiveStageValue === "number" ? _bond.ActiveStageValue : 0,
			CompletedCount: typeof _bond.CompletedCount === "number" ? Math.max(0, _bond.CompletedCount) : 0,
			UnlockedStoryCount: typeof _bond.UnlockedStoryCount === "number" ? Math.max(0, _bond.UnlockedStoryCount) : 0,
			Description: _bond.Description || "",
			Stages: stages
		};
	};

	BattleValkyriesHubModule.prototype.normalizeDetailStories = function(_stories)
	{
		if (!jQuery.isArray(_stories)) return [];
		var result = [];
		for (var i = 0; i < _stories.length; ++i)
		{
			var story = _stories[i];
			if (!story || typeof story !== "object" || !story.ID) continue;
			result.push({
				ID: story.ID,
				Type: story.Type || "story",
				Stage: typeof story.Stage === "number" ? story.Stage : 0,
				Chapter: story.Chapter || "",
				Title: story.Title || "",
				IntroImage: story.IntroImage || "",
				CGImage: story.CGImage || "",
				IntroText: story.IntroText || "",
				RevealText: story.RevealText || "",
				Unlocked: story.Unlocked === true
			});
		}
		return result;
	};

	BattleValkyriesHubModule.prototype.normalizeGoblinHuntDetail = function(_hunt)
	{
		if (!_hunt || typeof _hunt !== "object") return null;
		var breakdown = [];
		var milestones = [];
		if (jQuery.isArray(_hunt.Breakdown))
		{
			for (var i = 0; i < _hunt.Breakdown.length; ++i)
			{
				var row = _hunt.Breakdown[i];
				if (!row || typeof row !== "object") continue;
				breakdown.push({ Key: row.Key || "other", Name: row.Name || "", Points: typeof row.Points === "number" ? Math.max(0, row.Points) : 0, Kills: typeof row.Kills === "number" ? Math.max(0, row.Kills) : 0 });
			}
		}
		if (jQuery.isArray(_hunt.Milestones))
		{
			for (var j = 0; j < _hunt.Milestones.length; ++j)
			{
				var stage = _hunt.Milestones[j];
				if (!stage || typeof stage !== "object") continue;
				var tooltip = [];
				if (jQuery.isArray(stage.Tooltip))
				{
					for (var k = 0; k < stage.Tooltip.length; ++k)
					{
						var row = stage.Tooltip[k];
						if (row && typeof row === "object" && typeof row.Text === "string" && row.Text.length > 0) tooltip.push({ Text: row.Text });
					}
				}
				milestones.push({ Points: typeof stage.Points === "number" ? Math.max(0, stage.Points) : 0, Key: stage.Key || "", Kind: stage.Kind === "active" ? "active" : "passive", Name: stage.Name || "", Description: stage.Description || "", Tooltip: tooltip, Icon: stage.Icon || "", Unlocked: stage.Unlocked === true });
			}
		}
		return {
			Points: typeof _hunt.Points === "number" ? Math.max(0, _hunt.Points) : 0,
			PendingPoints: typeof _hunt.PendingPoints === "number" ? Math.max(0, _hunt.PendingPoints) : 0,
			DirectKills: typeof _hunt.DirectKills === "number" ? Math.max(0, _hunt.DirectKills) : 0,
			AssistConvictions: typeof _hunt.AssistConvictions === "number" ? Math.max(0, _hunt.AssistConvictions) : 0,
			Rank: typeof _hunt.Rank === "number" ? Math.max(0, _hunt.Rank) : 0,
			RankMax: typeof _hunt.RankMax === "number" ? Math.max(1, _hunt.RankMax) : 12,
			NextPoints: typeof _hunt.NextPoints === "number" ? Math.max(0, _hunt.NextPoints) : 25,
			RankDescription: _hunt.RankDescription || "",
			Breakdown: breakdown,
			Milestones: milestones
		};
	};

	BattleValkyriesHubModule.prototype.normalizeTheHertaResearch = function(_data)
	{
		if (!_data || typeof _data !== "object") return null;
		var items = [];
		var materials = [];
		var quotas = {};
		if (jQuery.isArray(_data.Items))
		{
			for (var i = 0; i < _data.Items.length; ++i)
			{
				var item = _data.Items[i];
				if (!item || typeof item !== "object" || !item.InstanceID || !item.Research || typeof item.Research !== "object") continue;
				var affixes = [];
				if (jQuery.isArray(item.Affixes))
				{
					for (var j = 0; j < item.Affixes.length; ++j)
					{
						var affix = item.Affixes[j];
						if (!affix || typeof affix !== "object") continue;
						affixes.push({ ID: affix.ID || "", Name: affix.Name || "", Tier: affix.Tier || "", TierName: affix.TierName || "", Color: affix.Color || "", Value: affix.Value || "", EffectText: affix.EffectText || "", Removable: affix.Removable === true });
					}
				}
				var research = item.Research;
				items.push({
					InstanceID: item.InstanceID,
					Name: item.Name || "",
					Icon: item.Icon || "",
					Part: item.Part || "",
					PartName: item.PartName || "",
					Rarity: item.Rarity || "",
					RarityName: item.RarityName || "",
					RarityColor: item.RarityColor || "",
					AffixCount: typeof item.AffixCount === "number" ? Math.max(0, item.AffixCount) : affixes.length,
					AffixMax: typeof item.AffixMax === "number" ? Math.max(0, item.AffixMax) : affixes.length,
					Locked: item.Locked === true,
					Affixes: affixes,
					Research: {
						NextRarity: research.NextRarity || "",
						NextRarityName: research.NextRarityName || "",
						NextRarityColor: research.NextRarityColor || "",
						NextAffixCount: typeof research.NextAffixCount === "number" ? Math.max(0, research.NextAffixCount) : 0,
						MaterialTier: research.MaterialTier || "",
						MaterialName: research.MaterialName || "",
						MaterialColor: research.MaterialColor || "",
						MaterialIcon: research.MaterialIcon || "",
						MaterialCost: typeof research.MaterialCost === "number" ? Math.max(0, research.MaterialCost) : 0,
						MoneyCost: typeof research.MoneyCost === "number" ? Math.max(0, research.MoneyCost) : 0,
						Quota: typeof research.Quota === "string" && research.Quota ? research.Quota : null
					}
				});
			}
		}
		if (jQuery.isArray(_data.Materials))
		{
			for (var k = 0; k < _data.Materials.length; ++k)
			{
				var material = _data.Materials[k];
				if (!material || typeof material !== "object" || !material.ID) continue;
				materials.push({ ID: material.ID, Name: material.Name || "", Color: material.Color || "", Icon: material.Icon || "", Count: typeof material.Count === "number" ? Math.max(0, material.Count) : 0 });
			}
		}
		var quotaIDs = ["purple_to_red", "red_to_prismatic"];
		for (var q = 0; q < quotaIDs.length; ++q)
		{
			var quotaID = quotaIDs[q];
			var quota = _data.Quotas && typeof _data.Quotas === "object" ? _data.Quotas[quotaID] : null;
			if (!quota || typeof quota !== "object") continue;
			quotas[quotaID] = { ID: quotaID, Charges: typeof quota.Charges === "number" ? Math.max(0, quota.Charges) : 0, Max: typeof quota.Max === "number" ? Math.max(0, quota.Max) : 0, Interval: typeof quota.Interval === "number" ? Math.max(0, quota.Interval) : 0, DaysRemaining: typeof quota.DaysRemaining === "number" ? Math.max(0, quota.DaysRemaining) : 0 };
		}
		return { Owned: _data.Owned === true || _data.Available === true, Available: _data.Available === true, EquipmentEnabled: _data.EquipmentEnabled === true, Items: items, Materials: materials, Money: typeof _data.Money === "number" ? Math.max(0, _data.Money) : 0, Quotas: quotas };
	};

	BattleValkyriesHubModule.prototype.normalizeLilySpirits = function(_data)
	{
		if (!_data || typeof _data !== "object") return null;
		var spirits = [];
		var loadout = [];
		if (jQuery.isArray(_data.Spirits))
		{
			for (var i = 0; i < _data.Spirits.length; ++i)
			{
				var spirit = _data.Spirits[i];
				if (!spirit || typeof spirit !== "object" || !spirit.Key) continue;
				spirits.push({
					Key: spirit.Key,
					SkillKey: spirit.SkillKey || "",
					Name: spirit.Name || "",
					Description: spirit.Description || "",
					Icon: spirit.Icon || "",
					Type: spirit.Type === "main" ? "main" : "sub",
					Unlock: typeof spirit.Unlock === "number" ? Math.max(0, spirit.Unlock) : 0,
					Unlocked: spirit.Unlocked === true,
					AP: typeof spirit.AP === "number" ? Math.max(0, spirit.AP) : 0,
					Fatigue: typeof spirit.Fatigue === "number" ? Math.max(0, spirit.Fatigue) : 0,
					MinRange: typeof spirit.MinRange === "number" ? Math.max(0, spirit.MinRange) : 0,
					MaxRange: typeof spirit.MaxRange === "number" ? Math.max(0, spirit.MaxRange) : 0
				});
			}
		}
		if (jQuery.isArray(_data.Loadout))
		{
			for (var j = 0; j < _data.Loadout.length && loadout.length < 6; ++j)
			{
				if (typeof _data.Loadout[j] === "string" && _data.Loadout[j]) loadout.push(_data.Loadout[j]);
			}
		}
		var next = _data.Next && typeof _data.Next === "object" ? _data.Next : null;
		return {
			Available: _data.Available === true,
			Editable: _data.Editable === true,
			Points: typeof _data.Points === "number" ? Math.max(0, _data.Points) : 0,
			PendingPoints: typeof _data.PendingPoints === "number" ? Math.max(0, _data.PendingPoints) : 0,
			MaxPoints: typeof _data.MaxPoints === "number" ? Math.max(0, _data.MaxPoints) : 310,
			Loadout: loadout,
			Spirits: spirits,
			Next: next ? {
				Key: next.Key || "",
				Name: next.Name || "",
				Unlock: typeof next.Unlock === "number" ? Math.max(0, next.Unlock) : 0,
				Remaining: typeof next.Remaining === "number" ? Math.max(0, next.Remaining) : 0
			} : null
		};
	};

	BattleValkyriesHubModule.prototype.normalizeStagePresentation = function(data)
	{
		if (!data || data.Type !== "olga_stages" || !jQuery.isArray(data.StageViews)) return null;
		var actual = data.ActualStage;
		if (typeof actual !== "number" || actual < 0 || actual > 5 || actual % 1 !== 0) return null;
		var views = [];
		for (var i = 0; i < 6; ++i)
		{
			var entry = data.StageViews[i];
			if (!entry || entry.Stage !== i) return null;
			var locked = entry.Locked !== false || i > actual;
			views.push({ Stage: i, Name: entry.Name || "", Locked: locked, UnlockHint: entry.UnlockHint || "",
				Description: locked ? "" : entry.Description || "", DetailMedia: locked ? null : this.normalizeDetailMedia(entry.DetailMedia) });
		}
		return { Type: data.Type, ActualStage: actual, StageViews: views };
	};
	BattleValkyriesHubModule.prototype.normalizeSummonDetail = function(_detail)
	{
		if (_detail === null || _detail === undefined || typeof _detail !== "object")
		{
			return null;
		}

		var labels = _detail.Labels !== null && _detail.Labels !== undefined && typeof _detail.Labels === "object" ? _detail.Labels : {};

		var skins = [];
		if (jQuery.isArray(_detail.Skins))
		{
			for (var i = 0; i < _detail.Skins.length; ++i)
			{
				var skin = _detail.Skins[i];
				if (skin === null || skin === undefined || typeof skin !== "object" || !skin.ID)
				{
					continue;
				}

				skins.push({
					ID: skin.ID,
					Name: skin.Name || "",
					Description: skin.Description || "",
					Locked: skin.Locked === true,
					UnlockHint: skin.UnlockHint || "",
					SummonPortrait: skin.SummonPortrait || "",
					SkinPortrait: skin.SkinPortrait || "",
					DetailMedia: this.normalizeDetailMedia(skin.DetailMedia),
					IsOriginal: skin.IsOriginal === true,
					IsActive: skin.IsActive === true,
					CanSetWorldLeader: skin.CanSetWorldLeader === true,
					IsWorldLeader: skin.IsWorldLeader === true
				});
			}
		}

		if (skins.length === 0)
		{
			skins.push({
				ID: "legacy",
				Name: "",
				Description: "",
				SummonPortrait: _detail.SummonPortrait || "",
				SkinPortrait: _detail.SkinPortrait || "",
				IsOriginal: true,
				IsActive: true,
				CanSetWorldLeader: false,
				IsWorldLeader: false
			});
		}

		return {
			Title: _detail.Title || "",
			Subtitle: _detail.Subtitle || "",
			ActiveSkinID: _detail.ActiveSkinID || skins[0].ID,
			StagePresentation: this.normalizeStagePresentation(_detail.StagePresentation),
			Skins: skins,
			SummonPortrait: _detail.SummonPortrait || "",
			SkinPortrait: _detail.SkinPortrait || "",
			Labels: {
				SummonPortrait: labels.SummonPortrait || "",
				SkinPortrait: labels.SkinPortrait || ""
			},
			Background: this.normalizeDetailEntry(_detail.Background),
			Trait: this.normalizeDetailEntry(_detail.Trait),
			Skills: this.normalizeDetailSkills(_detail),
			Alchemy: _detail.Alchemy && typeof _detail.Alchemy === "object" ? $.extend(true, {}, _detail.Alchemy) : null,
			Passive: this.normalizeDetailEntry(_detail.Passive),
			Active: this.normalizeDetailEntry(_detail.Active),
			GoblinHunt: this.normalizeGoblinHuntDetail(_detail.GoblinHunt),
			Research: this.normalizeTheHertaResearch(_detail.Research),
			LilySpirits: this.normalizeLilySpirits(_detail.LilySpirits),
			Workshop: _detail.Workshop && typeof _detail.Workshop === "object" ? _detail.Workshop : null,
			Bond: this.normalizeBondDetail(_detail.Bond),
			Stories: this.normalizeDetailStories(_detail.Stories)
		};
	};

	BattleValkyriesHubModule.prototype.normalizeTabs = function(_tabs)
	{
		if (!jQuery.isArray(_tabs) || _tabs.length === 0)
		{
			return this.mFallbackData.Tabs;
		}

		var result = [];
		for (var i = 0; i < _tabs.length; ++i)
		{
			var tab = _tabs[i];
			if (tab === null || tab === undefined || typeof tab !== "object")
			{
				continue;
			}

			result.push({
				ID: tab.ID || ("tab_" + i),
				Title: tab.Title || "",
				Body: tab.Body || ""
			});
		}

		return result.length > 0 ? result : this.mFallbackData.Tabs;
	};

	BattleValkyriesHubModule.prototype.renderTabs = function(_tabs)
	{
		var self = this;
		this.mTabsContainer.empty();

		for (var i = 0; i < _tabs.length; ++i)
		{
			var tab = _tabs[i];
			var button = $('<div class="battle-valkyries-hub-tab text-font-normal font-bold font-bottom-shadow"></div>');
			button.text(tab.Title);
			button.data("tab-id", tab.ID);
			button.on("click", function()
			{
				self.selectTab(_tabs, $(this).data("tab-id"));
			});
			this.mTabsContainer.append(button);
		}
	};

	BattleValkyriesHubModule.prototype.selectTab = function(_tabs, _tabID)
	{
		var selected = null;
		for (var i = 0; i < _tabs.length; ++i)
		{
			if (_tabs[i].ID === _tabID)
			{
				selected = _tabs[i];
				break;
			}
		}

		if (selected === null && _tabs.length > 0)
		{
			selected = _tabs[0];
		}

		if (selected === null)
		{
			this.mBody.text("");
			return;
		}

		this.mActiveTabID = selected.ID;
		this.mTabsContainer.find(".battle-valkyries-hub-tab").removeClass("is-selected");
		this.mTabsContainer.find('.battle-valkyries-hub-tab').each(function()
		{
			if ($(this).data("tab-id") === selected.ID)
			{
				$(this).addClass("is-selected");
			}
		});
		if (selected.ID === "summon")
		{
			this.renderSummonTab(selected);
		}
		else if (selected.ID === "chapters" && window[namespace + "ChapterCards"])
		{
			window[namespace + "ChapterCards"](this);
		}
		else if (selected.ID === "bounties")
		{
			this.renderBountyTab(selected);
		}
		else if (selected.ID === "memory_inscribe")
		{
			this.renderMemoryInscribeTab(selected);
		}
		else if (selected.ID === "memory_shop")
		{
			this.renderMemoryShopTab(selected);
		}
		else if (selected.ID === "memory_biographies")
		{
			this.renderMemoryBiographiesTab(selected);
		}
		else
		{
			this.mBody.text(selected.Body);
		}
	};

	BattleValkyriesHubModule.prototype.renderSummonTab = function(_tab)
	{
		this.mBody.empty();

		var intro = $('<div class="battle-valkyries-summon-intro"></div>');
		intro.text(_tab.Body);
		this.mBody.append(intro);

		if (this.mData !== null && this.mData.GachaModeEnabled === true)
		{
			this.mBody.append(this.renderGachaPanel());
		}

		var grid = $('<div class="battle-valkyries-summon-grid"></div>');
		var count = $('<div class="battle-valkyries-summon-count text-font-small"></div>');
		this.renderSummonFilters(grid, count);
		this.mBody.append(count);
		this.mBody.append(grid);
		this.renderSummonGrid(grid, count);
	};

	BattleValkyriesHubModule.prototype.renderSummonGrid = function(_grid, _count)
	{
		var self = this;
		var allSlots = this.mData !== null ? this.mData.SummonSlots || [] : [];
		var slots = this.filterSummonSlots(allSlots);
		var total = 0;
		for (var n = 0; n < allSlots.length; ++n) if (!allSlots[n].IsPlaceholder) ++total;
		_count.text(this.mGuideText.Count.replace("{shown}", slots.length).replace("{total}", total));
		_grid.empty();
		if (slots.length === 0) _grid.append($('<div class="battle-valkyries-summon-empty text-font-normal"></div>').text(this.mGuideText.Empty));

		for (var i = 0; i < slots.length; ++i)
		{
			var slot = slots[i];
			var card = $('<div class="battle-valkyries-summon-card"></div>');
			card.addClass("is-" + slot.State);
			if (slot.Detail !== null)
			{
				card.addClass("has-detail");
			}
			card.data("slot-id", slot.ID);
			if (slot.IsGachaSelected)
			{
				card.addClass("is-gacha-selected");
			}

			var portrait = $('<div class="battle-valkyries-summon-portrait"></div>');
			if (slot.Portrait !== "")
			{
				var image = $("<img/>");
				image.attr("src", Path.GFX + slot.Portrait);
				image.attr("alt", slot.Name);
				portrait.append(image);
			}

			var name = $('<div class="battle-valkyries-summon-name font-bold"></div>');
			name.text(slot.Name);

			card.append(portrait);
			card.append(name);
			card.append(this.renderRecruitGuide(slot));


			if (slot.State === "summoned")
			{
				var badge = $('<div class="battle-valkyries-summon-badge"></div>');
				var badgeImage = $("<img/>");
				badgeImage.attr("src", Path.GFX + this.mIconPath);
				badgeImage.attr("alt", slot.Status);
				badge.append(badgeImage);
				card.append(badge);
			}
			else if (slot.IsGachaSelected)
			{
				var selectedBadge = $('<div class="battle-valkyries-summon-select-badge text-font-small font-bold"></div>');
				selectedBadge.text((this.mData.Messages !== undefined ? this.mData.Messages.GachaSelectedButton : "") || "");
				card.append(selectedBadge);
			}

			if (slot.Detail !== null || slot.CanSummon || slot.CanGachaSelect || slot.State === "summoned")
			{
				card.on("click", function()
				{
					self.handleSummonCardClick($(this).data("slot-id"));
				});
			}

			_grid.append(card);
		}
	};

	BattleValkyriesHubModule.prototype.renderBountyTab = function(_tab)
	{
		var self = this;
		var cards = this.mData !== null && this.mData.BountyCards !== undefined ? this.mData.BountyCards : [];
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;
		this.mBody.empty();
		this.mBody.append($('<div class="battle-valkyries-bounty-intro"></div>').text(_tab.Body || ""));

		var grid = $('<div class="battle-valkyries-bounty-grid"></div>');
		for (var i = 0; i < cards.length; ++i)
		{
			var cardData = cards[i];
			var card = $('<button type="button" class="battle-valkyries-bounty-card"></button>');
			card.addClass("is-" + cardData.State);
			card.data("bounty-id", cardData.ID);
			var wanted = $('<div class="battle-valkyries-bounty-wanted text-font-small font-bold"></div>').text(messages.BountyWanted || "");
			var poster = $('<div class="battle-valkyries-bounty-poster"></div>');
			if (cardData.Poster !== "")
			{
				poster.append($("<img/>").attr("src", Path.GFX + cardData.Poster).attr("alt", cardData.Name));
			}
			var name = $('<div class="battle-valkyries-bounty-name text-font-normal font-bold"></div>').text(cardData.Name);
			var stars = $('<div class="battle-valkyries-bounty-stars text-font-normal"></div>').text(Array(cardData.Stars + 1).join("★"));
			var reward = $('<div class="battle-valkyries-bounty-line text-font-small"></div>').text((messages.BountyReward || "") + " " + cardData.Reward);
			var theme = $('<div class="battle-valkyries-bounty-line text-font-small"></div>').text(cardData.EnemyTheme);
			var composition = $('<div class="battle-valkyries-bounty-line text-font-small"></div>').text(cardData.CampSummary);
			var status = $('<div class="battle-valkyries-bounty-status text-font-small font-bold"></div>').text(cardData.Status || cardData.State);
			card.append(wanted).append(poster).append(name).append(stars).append(reward).append(theme).append(composition).append(status);
			card.on("click", function()
			{
				self.handleBountyCardClick($(this).data("bounty-id"));
			});
			grid.append(card);
		}

		this.mBody.append(grid);
	};

	BattleValkyriesHubModule.prototype.formatHubText = function(_template, _values)
	{
		var result = _template || "";
		for (var key in _values)
		{
			if (_values.hasOwnProperty(key)) result = result.split("{" + key + "}").join(String(_values[key]));
		}
		return result;
	};

	BattleValkyriesHubModule.prototype.getMemoryTierLabel = function(_tier)
	{
		var messages = this.mData !== null ? this.mData.Messages : this.mFallbackData.Messages;
		if (_tier >= 3) return messages.MemoryTierEternal;
		if (_tier === 2) return messages.MemoryTierCrystal;
		if (_tier === 1) return messages.MemoryTierFragment;
		return messages.MemoryTierNone;
	};

	BattleValkyriesHubModule.prototype.getMemoryResourceLabel = function(_key)
	{
		var resources = this.mData !== null ? this.mData.MemoryArchive.Resources : [];
		for (var i = 0; i < resources.length; ++i)
		{
			if (resources[i].Key === _key) return resources[i].Label;
		}
		return _key;
	};

	BattleValkyriesHubModule.prototype.createMemoryResourceBar = function()
	{
		var resources = this.mData !== null ? this.mData.MemoryArchive.Resources : [];
		var bar = $('<div class="battle-valkyries-memory-resource-bar"></div>');
		for (var i = 0; i < resources.length; ++i)
		{
			var resource = resources[i];
			var item = $('<div class="battle-valkyries-memory-resource"></div>').addClass("resource-" + String(resource.Key).toLowerCase());
			item.append($('<div class="battle-valkyries-memory-resource-mark font-bold"></div>').text(resource.Label ? resource.Label.charAt(0) : "记"));
			var text = $('<div class="battle-valkyries-memory-resource-text"></div>');
			text.append($('<div class="battle-valkyries-memory-resource-label text-font-small"></div>').text(resource.Label));
			text.append($('<div class="battle-valkyries-memory-resource-amount text-font-normal font-bold"></div>').text(resource.Amount));
			item.append(text);
			bar.append(item);
		}
		return bar;
	};

	BattleValkyriesHubModule.prototype.createMemoryPortrait = function(_entry, _small)
	{
		var wrap = $('<div class="battle-valkyries-memory-portrait"></div>');
		if (_small) wrap.addClass("is-small");
		if (_entry.Portrait)
		{
			var prefix = _entry.ActorID !== null && _entry.ActorID !== undefined && typeof Path.PROCEDURAL !== "undefined" ? Path.PROCEDURAL : Path.GFX;
			wrap.append($("<img/>").attr("src", prefix + _entry.Portrait).attr("alt", _entry.Name));
		}
		return wrap;
	};

	BattleValkyriesHubModule.prototype.createMemoryStats = function(_entry)
	{
		var messages = this.mData.Messages;
		var block = $('<div class="battle-valkyries-memory-stats"></div>');
		for (var i = 0; i < _entry.Stats.length; ++i)
		{
			var stat = _entry.Stats[i];
			var cell = $('<div class="battle-valkyries-memory-stat"></div>').addClass("tier-" + stat.Tier);
			var top = $('<div class="battle-valkyries-memory-stat-top"></div>');
			if (stat.Icon) top.append($("<img/>").attr("src", Path.GFX + stat.Icon));
			top.append($('<div class="battle-valkyries-memory-stat-label text-font-small"></div>').text(stat.Label));
			top.append($('<div class="battle-valkyries-memory-stat-value text-font-normal font-bold"></div>').text(stat.Value));
			cell.append(top);
			cell.append($('<div class="battle-valkyries-memory-stat-tier text-font-small font-bold"></div>').text(this.getMemoryTierLabel(stat.Tier)));
			if (stat.NextThreshold > 0)
			{
				cell.append($('<div class="battle-valkyries-memory-stat-next text-font-small"></div>').text(this.formatHubText(messages.MemoryNextThreshold, { value: stat.NextThreshold })));
			}
			block.append(cell);
		}
		return block;
	};

	BattleValkyriesHubModule.prototype.createMemoryRewards = function(_entry)
	{
		var rewards = $('<div class="battle-valkyries-memory-rewards"></div>');
		var keys = ["Fragment", "Crystal", "Eternal", "Emblem"];
		for (var i = 0; i < keys.length; ++i)
		{
			var amount = _entry.Rewards[keys[i]] || 0;
			if (amount <= 0) continue;
			rewards.append($('<div class="battle-valkyries-memory-reward text-font-small font-bold"></div>')
				.addClass("resource-" + keys[i].toLowerCase())
				.text(this.getMemoryResourceLabel(keys[i]) + " × " + amount));
		}
		return rewards;
	};

	BattleValkyriesHubModule.prototype.formatMemoryRewardsSummary = function(_rewards)
	{
		var parts = [];
		var keys = ["Fragment", "Crystal", "Eternal", "Emblem"];
		for (var i = 0; i < keys.length; ++i)
		{
			var amount = _rewards[keys[i]] || 0;
			if (amount > 0) parts.push(this.getMemoryResourceLabel(keys[i]) + " × " + amount);
		}
		return parts.join("，");
	};

	BattleValkyriesHubModule.prototype.findMemoryCandidate = function(_actorID)
	{
		var candidates = this.mData.MemoryArchive.Candidates;
		for (var i = 0; i < candidates.length; ++i)
		{
			if (String(candidates[i].ActorID) === String(_actorID)) return candidates[i];
		}
		return null;
	};

	BattleValkyriesHubModule.prototype.renderMemoryInscribeTab = function(_tab)
	{
		var self = this;
		var messages = this.mData.Messages;
		var candidates = this.mData.MemoryArchive.Candidates;
		if (this.findMemoryCandidate(this.mSelectedMemoryActorID) === null)
		{
			this.mSelectedMemoryActorID = candidates.length > 0 ? candidates[0].ActorID : null;
		}
		var selected = this.findMemoryCandidate(this.mSelectedMemoryActorID);
		this.mBody.empty();
		this.mBody.append(this.createMemoryResourceBar());
		this.mBody.append($('<div class="battle-valkyries-memory-intro text-font-normal"></div>').text(messages.MemoryIntro || _tab.Body || ""));
		var layout = $('<div class="battle-valkyries-memory-layout"></div>');
		var list = $('<div class="battle-valkyries-memory-list"></div>');
		var detail = $('<div class="battle-valkyries-memory-detail"></div>');
		if (candidates.length === 0) list.append($('<div class="battle-valkyries-memory-empty text-font-normal"></div>').text(messages.MemoryEmptyCandidates));
		for (var i = 0; i < candidates.length; ++i)
		{
			(function(_candidate)
			{
				var card = $('<button type="button" class="battle-valkyries-memory-card"></button>');
				if (selected !== null && String(selected.ActorID) === String(_candidate.ActorID)) card.addClass("is-selected");
				card.append(self.createMemoryPortrait(_candidate, true));
				var text = $('<div class="battle-valkyries-memory-card-text"></div>');
				text.append($('<div class="battle-valkyries-memory-card-name text-font-normal font-bold"></div>').text(_candidate.Name));
				text.append($('<div class="battle-valkyries-memory-card-background text-font-small"></div>').text(_candidate.Background));
				text.append($('<div class="battle-valkyries-memory-card-rank text-font-small font-bold"></div>').text(_candidate.RankTitle));
				card.append(text);
				card.on("click", function() { self.mSelectedMemoryActorID = _candidate.ActorID; self.renderMemoryInscribeTab(_tab); });
				list.append(card);
			})(candidates[i]);
		}
		if (selected === null)
		{
			detail.append($('<div class="battle-valkyries-memory-empty text-font-normal"></div>').text(messages.MemoryEmptyCandidates));
		}
		else
		{
			var header = $('<div class="battle-valkyries-memory-detail-header"></div>');
			header.append(this.createMemoryPortrait(selected, false));
			var identity = $('<div class="battle-valkyries-memory-identity"></div>');
			identity.append($('<div class="battle-valkyries-memory-name title-font-normal font-bold"></div>').text(selected.Name));
			identity.append($('<div class="battle-valkyries-memory-background text-font-normal"></div>').text(selected.Background));
			identity.append($('<div class="battle-valkyries-memory-rank text-font-normal font-bold"></div>').text(selected.RankTitle));
			identity.append($('<div class="battle-valkyries-memory-meta text-font-small"></div>').text(messages.MemoryLevel + " " + selected.Level + " / " + messages.MemoryDays + " " + selected.CompanyDays));
			header.append(identity);
			var action = $('<button type="button" class="battle-valkyries-memory-action text-font-normal font-bold"></button>').text(messages.MemoryArchiveButton);
			if (this.mMemoryArchiving || !selected.CanArchive) action.addClass("is-disabled").prop("disabled", true);
			else action.on("click", function() { self.showMemoryArchiveConfirm(selected); });
			header.append(action);
			detail.append(header);
			detail.append($('<div class="battle-valkyries-memory-section-title text-font-normal font-bold"></div>').text(messages.MemoryAttributes));
			detail.append(this.createMemoryStats(selected));
			detail.append($('<div class="battle-valkyries-memory-resonance text-font-small"></div>').text(messages.MemoryEliteCount + " " + selected.EliteCount + " / " + messages.MemoryLegendaryCount + " " + selected.LegendaryCount));
			detail.append($('<div class="battle-valkyries-memory-section-title text-font-normal font-bold"></div>').text(messages.MemoryRewards));
			detail.append(this.createMemoryRewards(selected));
		}
		layout.append(list).append(detail);
		this.mBody.append(layout);
	};

	BattleValkyriesHubModule.prototype.findMemoryRecord = function(_recordID)
	{
		var records = this.mData.MemoryArchive.Records;
		for (var i = 0; i < records.length; ++i)
		{
			if (records[i].RecordID === _recordID) return records[i];
		}
		return null;
	};

	BattleValkyriesHubModule.prototype.renderMemoryBiographiesTab = function(_tab)
	{
		var self = this;
		var messages = this.mData.Messages;
		var records = this.mData.MemoryArchive.Records;
		if (this.findMemoryRecord(this.mSelectedMemoryRecordID) === null)
		{
			this.mSelectedMemoryRecordID = records.length > 0 ? records[0].RecordID : null;
		}
		var selected = this.findMemoryRecord(this.mSelectedMemoryRecordID);
		this.mBody.empty();
		this.mBody.append(this.createMemoryResourceBar());
		this.mBody.append($('<div class="battle-valkyries-memory-intro text-font-normal"></div>').text(messages.MemoryBiographyIntro || _tab.Body || ""));
		var layout = $('<div class="battle-valkyries-memory-layout biography-layout"></div>');
		var list = $('<div class="battle-valkyries-memory-list"></div>');
		var detail = $('<div class="battle-valkyries-memory-detail biography-page"></div>');
		if (records.length === 0) list.append($('<div class="battle-valkyries-memory-empty text-font-normal"></div>').text(messages.MemoryEmptyRecords));
		for (var i = 0; i < records.length; ++i)
		{
			(function(_record)
			{
				var card = $('<button type="button" class="battle-valkyries-memory-card biography-card"></button>');
				if (selected !== null && selected.RecordID === _record.RecordID) card.addClass("is-selected");
				card.append(self.createMemoryPortrait(_record, true));
				var text = $('<div class="battle-valkyries-memory-card-text"></div>');
				text.append($('<div class="battle-valkyries-memory-card-name text-font-normal font-bold"></div>').text(_record.Name));
				text.append($('<div class="battle-valkyries-memory-card-rank text-font-small font-bold"></div>').text(_record.RankTitle));
				text.append($('<div class="battle-valkyries-memory-card-background text-font-small"></div>').text(messages.MemoryArchiveDay + " " + _record.ArchiveDay));
				card.append(text);
				card.on("click", function() { self.mSelectedMemoryRecordID = _record.RecordID; self.renderMemoryBiographiesTab(_tab); });
				list.append(card);
			})(records[i]);
		}
		if (selected === null)
		{
			detail.append($('<div class="battle-valkyries-memory-empty text-font-normal"></div>').text(messages.MemoryEmptyRecords));
		}
		else
		{
			var header = $('<div class="battle-valkyries-memory-detail-header"></div>');
			header.append(this.createMemoryPortrait(selected, false));
			var identity = $('<div class="battle-valkyries-memory-identity"></div>');
			identity.append($('<div class="battle-valkyries-memory-name title-font-normal font-bold"></div>').text(selected.Name));
			identity.append($('<div class="battle-valkyries-memory-background text-font-normal"></div>').text(selected.Background));
			identity.append($('<div class="battle-valkyries-memory-rank text-font-normal font-bold"></div>').text(selected.RankTitle));
			header.append(identity);
			detail.append(header);
			detail.append($('<div class="battle-valkyries-memory-biography-text text-font-normal"></div>').text(this.formatHubText(messages.MemoryBiographyTemplate, {
				name: selected.Name,
				background: selected.Background,
				level: selected.Level,
				company_days: selected.CompanyDays,
				archive_day: selected.ArchiveDay,
				rank: selected.RankTitle
			})));
			detail.append(this.createMemoryStats(selected));
			detail.append(this.createMemoryRewards(selected));
		}
		layout.append(list).append(detail);
		this.mBody.append(layout);
	};

	BattleValkyriesHubModule.prototype.showMemoryArchiveConfirm = function(_candidate)
	{
		var self = this;
		var messages = this.mData.Messages;
		var text = this.formatHubText(messages.MemoryConfirmMessage, {
			name: _candidate.Name,
			rank: _candidate.RankTitle,
			rewards: this.formatMemoryRewardsSummary(_candidate.Rewards)
		}) + "\n\n" + messages.MemoryConfirmWarning;
		this.showPopup(messages.MemoryConfirmTitle, text, [
			{ Label: messages.ConfirmYes, Callback: function() { self.performMemoryArchive(_candidate.ActorID); } },
			{ Label: messages.Cancel, Callback: null }
		]);
	};

	BattleValkyriesHubModule.prototype.performMemoryArchive = function(_actorID)
	{
		if (this.mMemoryArchiving || this.mBackendHandle === null || this.mBackendHandle === undefined) return;
		var self = this;
		var messages = this.mData.Messages;
		this.mMemoryArchiving = true;
		SQ.call(this.mBackendHandle, "archiveBattleValkyriesBrotherMemory", { ActorID: _actorID }, function(_result)
		{
			self.mMemoryArchiving = false;
			if (_result !== null && _result !== undefined && _result.Success === true) self.mSelectedMemoryActorID = null;
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);
				if (_result !== null && _result !== undefined && _result.Message) self.showMessage(_result.Message, messages.MemoryResultTitle);
			});
		});
	};

	BattleValkyriesHubModule.prototype.findMemoryShopProduct = function(_productID)
	{
		var products = this.mData.MemoryShop.Products;
		for (var i = 0; i < products.length; ++i)
		{
			if (products[i].ID === _productID) return products[i];
		}
		return null;
	};

	BattleValkyriesHubModule.prototype.createMemoryShopCosts = function(_product)
	{
		var costs = $('<div class="battle-valkyries-memory-shop-costs"></div>');
		for (var i = 0; i < _product.Cost.length; ++i)
		{
			var cost = _product.Cost[i];
			var chip = $('<div class="battle-valkyries-memory-shop-cost text-font-small font-bold"></div>').addClass("resource-" + String(cost.Key).toLowerCase());
			if (!cost.IsMet) chip.addClass("is-missing");
			chip.text(cost.Label + " × " + cost.Required);
			chip.attr("title", cost.Owned + " / " + cost.Required);
			costs.append(chip);
		}
		return costs;
	};

	BattleValkyriesHubModule.prototype.formatMemoryShopCostSummary = function(_product)
	{
		var parts = [];
		for (var i = 0; i < _product.Cost.length; ++i)
		{
			parts.push(_product.Cost[i].Label + " × " + _product.Cost[i].Required);
		}
		return parts.join("，");
	};

	BattleValkyriesHubModule.prototype.renderMemoryShopTab = function(_tab)
	{
		var self = this;
		var messages = this.mData.Messages;
		var products = this.mData.MemoryShop.Products;
		this.mBody.empty();
		this.mBody.append(this.createMemoryResourceBar());
		this.mBody.append($('<div class="battle-valkyries-memory-intro text-font-normal"></div>').text(_tab.Body || ""));
		var grid = $('<div class="battle-valkyries-memory-shop-grid"></div>');
		if (products.length === 0) grid.append($('<div class="battle-valkyries-memory-empty text-font-normal"></div>').text(messages.MemoryShopEmpty));
		for (var i = 0; i < products.length; ++i)
		{
			(function(_product)
			{
				var card = $('<div class="battle-valkyries-memory-shop-product"></div>');
				if (!_product.CanBuy) card.addClass("is-unavailable");
				var top = $('<div class="battle-valkyries-memory-shop-product-top"></div>');
				var icon = $('<div class="battle-valkyries-memory-shop-product-icon"></div>');
				if (_product.Icon) icon.append($("<img/>").attr("src", Path.GFX + _product.Icon).attr("alt", _product.Name));
				top.append(icon);
				var identity = $('<div class="battle-valkyries-memory-shop-product-identity"></div>');
				identity.append($('<div class="battle-valkyries-memory-shop-product-name text-font-normal font-bold"></div>').text(_product.Name));
				identity.append($('<div class="battle-valkyries-memory-shop-product-effect text-font-small font-bold"></div>').text(_product.EffectLabel));
				top.append(identity);
				card.append(top);
				card.append($('<div class="battle-valkyries-memory-shop-product-description text-font-small"></div>').text(_product.Description));
				card.append(self.createMemoryShopCosts(_product));
				card.append($('<div class="battle-valkyries-memory-shop-status text-font-small"></div>').text(_product.Status));
				var action = $('<button type="button" class="battle-valkyries-memory-shop-action text-font-normal font-bold"></button>').text(messages.MemoryShopBuy);
				if (self.mMemoryShopPurchasing || !_product.CanBuy) action.addClass("is-disabled").prop("disabled", true);
				else action.on("click", function() { self.showMemoryShopConfirm(_product); });
				card.append(action);
				grid.append(card);
			})(products[i]);
		}
		this.mBody.append(grid);
	};

	BattleValkyriesHubModule.prototype.showMemoryShopConfirm = function(_product)
	{
		var self = this;
		var messages = this.mData.Messages;
		var text = this.formatHubText(messages.MemoryShopConfirmMessage, {
			product: _product.Name,
			cost: this.formatMemoryShopCostSummary(_product)
		});
		this.showPopup(messages.MemoryShopConfirmTitle, text, [
			{ Label: messages.MemoryShopBuy, Callback: function() { self.performMemoryShopPurchase(_product.ID); } },
			{ Label: messages.Cancel, Callback: null }
		]);
	};

	BattleValkyriesHubModule.prototype.performMemoryShopPurchase = function(_productID)
	{
		if (this.mMemoryShopPurchasing || this.mBackendHandle === null || this.mBackendHandle === undefined) return;
		var self = this;
		var messages = this.mData.Messages;
		this.mMemoryShopPurchasing = true;
		SQ.call(this.mBackendHandle, "purchaseBattleValkyriesMemoryProduct", { ProductID: _productID }, function(_result)
		{
			self.mMemoryShopPurchasing = false;
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);
				if (_result !== null && _result !== undefined && _result.Message) self.showMessage(_result.Message, messages.MemoryShopResultTitle);
			});
		});
	};

	BattleValkyriesHubModule.prototype.findBountyCard = function(_bountyID)
	{
		var cards = this.mData !== null && this.mData.BountyCards !== undefined ? this.mData.BountyCards : [];
		for (var i = 0; i < cards.length; ++i)
		{
			if (cards[i].ID === _bountyID)
			{
				return cards[i];
			}
		}

		return null;
	};

	BattleValkyriesHubModule.prototype.handleBountyCardClick = function(_bountyID)
	{
		if (typeof console !== "undefined" && console.log)
		{
			console.log("[Battle Valkyries][BountyDebug] stage=ui.card.click bounty=" + _bountyID);
		}
		var card = this.findBountyCard(_bountyID);
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;
		if (card === null)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		if (card.CanAccept)
		{
			this.showBountyConfirm(card);
			return;
		}

		if (card.CanClaim)
		{
			this.showBountyClaimConfirm(card);
			return;
		}

		this.showMessage(card.Status || messages.Unavailable, messages.BountyConfirmTitle);
	};

	BattleValkyriesHubModule.prototype.showBountyConfirm = function(_card)
	{
		var self = this;
		if (typeof console !== "undefined" && console.log)
		{
			console.log("[Battle Valkyries][BountyDebug] stage=ui.confirm.show bounty=" + _card.ID);
		}
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;
		var message = messages.BountyConfirmMessage || "";
		message = message.replace("{name}", _card.Name).replace("{stars}", _card.Stars).replace("{owned}", _card.OwnedValkyrieCount).replace("{budget}", _card.EscortBudget).replace("{champions}", _card.FixedChampionCount).replace("{champion_policy}", _card.ChampionPolicy || "").replace("{reward}", _card.Reward).replace("{theme}", _card.EnemyTheme || "").replace("{composition}", _card.CampSummary || "");
		this.showPopup(messages.BountyConfirmTitle, message, [
			{ Label: messages.BountyAccept, Callback: function()
				{
					if (typeof console !== "undefined" && console.log)
					{
						console.log("[Battle Valkyries][BountyDebug] stage=ui.confirm.accept bounty=" + _card.ID);
					}
					self.performAcceptBounty(_card.ID);
				} },
			{ Label: messages.Cancel, Callback: null }
		]);
	};

	BattleValkyriesHubModule.prototype.performAcceptBounty = function(_bountyID)
	{
		if (typeof console !== "undefined" && console.log)
		{
			console.log("[Battle Valkyries][BountyDebug] stage=ui.sq.prepare bounty=" + _bountyID + " busy=" + this.mBountyAccepting + " backend=" + (this.mBackendHandle !== null));
		}
		if (this.mBountyAccepting || this.mBackendHandle === null)
		{
			return;
		}

		var self = this;
		this.mBountyAccepting = true;
		if (typeof console !== "undefined" && console.log)
		{
			console.log("[Battle Valkyries][BountyDebug] stage=ui.sq.call bounty=" + _bountyID);
		}
		SQ.call(this.mBackendHandle, "acceptBattleValkyrieBounty", _bountyID, function(_result)
		{
			if (typeof console !== "undefined" && console.log)
			{
				console.log("[Battle Valkyries][BountyDebug] stage=ui.sq.callback bounty=" + _bountyID + " result=" + JSON.stringify(_result));
			}
			self.mBountyAccepting = false;
			self.mActiveTabID = "bounties";
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);
				if (_result !== null && _result !== undefined && _result.Message !== undefined && _result.Message !== "")
				{
					self.showMessage(_result.Message, self.mData.Messages.BountyConfirmTitle);
				}
			});
		});
	};

	BattleValkyriesHubModule.prototype.showBountyClaimConfirm = function(_card)
	{
		var self = this;
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;
		var message = (messages.BountyClaimMessage || "").replace("{name}", _card.Name);
		this.showPopup(messages.BountyClaimTitle, message, [
			{ Label: messages.BountyClaimConfirm, Callback: function() { self.performClaimBountyRecruit(_card.ValkyrieID); } },
			{ Label: messages.Cancel, Callback: null }
		]);
	};

	BattleValkyriesHubModule.prototype.performClaimBountyRecruit = function(_valkyrieID)
	{
		if (this.mBountyClaiming || this.mBackendHandle === null)
		{
			return;
		}

		var self = this;
		this.mBountyClaiming = true;
		SQ.call(this.mBackendHandle, "claimBattleValkyrieBountyRecruit", _valkyrieID, function(_result)
		{
			self.mBountyClaiming = false;
			self.mActiveTabID = "bounties";
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);
				if (_result !== null && _result !== undefined && _result.Message !== undefined && _result.Message !== "")
				{
					self.showMessage(_result.Message, self.mData.Messages.BountyClaimTitle);
				}
			});
		});
	};

	BattleValkyriesHubModule.prototype.renderGachaPanel = function()
	{
		var self = this;
		var data = this.mData !== null ? this.mData : this.mFallbackData;
		var messages = data.Messages !== undefined ? data.Messages : this.mFallbackData.Messages;
		var progressMax = typeof data.GachaProgressMax === "number" && data.GachaProgressMax > 0 ? data.GachaProgressMax : 4;
		var progress = typeof data.GachaProgress === "number" ? data.GachaProgress : progressMax;
		if (progress < 0)
		{
			progress = 0;
		}
		if (progress > progressMax)
		{
			progress = progressMax;
		}
		var selectedName = data.GachaSelectedValkyrieName || messages.GachaSelectedNone || "";

		var panel = $('<div class="battle-valkyries-gacha-panel"></div>');
		var button = $('<button type="button" class="battle-valkyries-gacha-pull-button"></button>');
		var image = $("<img/>");
		image.attr("src", Path.GFX + "ui/valkyries/gacha_pull_button.png");
		image.attr("alt", messages.GachaPullButton || "");
		button.append(image);
		button.append($('<span class="battle-valkyries-gacha-pull-label text-font-normal font-bold"></span>').text(messages.GachaPullButton || ""));
		button.on("click", function(_event)
		{
			_event.preventDefault();
			_event.stopPropagation();
			self.tryPullGacha();
		});

		var info = $('<div class="battle-valkyries-gacha-info"></div>');
		var cost = $('<div class="battle-valkyries-gacha-cost text-font-small font-bold"></div>');
		cost.text((messages.GachaCost || "") + " " + data.GachaCost);

		var selected = $('<div class="battle-valkyries-gacha-selected text-font-small"></div>');
		selected.text((messages.GachaSelected || "") + " " + selectedName);

		var progressText = $('<div class="battle-valkyries-gacha-progress-text text-font-small"></div>');
		progressText.text((messages.GachaProgress || "") + " " + progress + "/" + progressMax);

		var progressCells = $('<div class="battle-valkyries-gacha-progress-cells"></div>');
		for (var i = 0; i < progressMax; ++i)
		{
			var progressCell = $('<div class="battle-valkyries-gacha-progress-cell"></div>');
			progressCell.addClass(i < progress ? "is-filled" : "is-empty");
			progressCells.append(progressCell);
		}

		info.append(cost);
		info.append(selected);
		info.append(progressText);
		info.append(progressCells);
		panel.append(button);
		panel.append(info);
		return panel;
	};

	BattleValkyriesHubModule.prototype.findSummonSlot = function(_slotID)
	{
		var slots = this.mData !== null && this.mData.SummonSlots !== undefined ? this.mData.SummonSlots : [];

		for (var i = 0; i < slots.length; ++i)
		{
			if (slots[i].ID === _slotID)
			{
				return slots[i];
			}
		}

		return null;
	};

	BattleValkyriesHubModule.prototype.handleSummonCardClick = function(_slotID)
	{
		var slot = this.findSummonSlot(_slotID);
		if (slot !== null && slot.Detail !== null && slot.Detail !== undefined)
		{
			this.showValkyrieDetail(slot);
			return;
		}

		this.trySummon(_slotID);
	};

	BattleValkyriesHubModule.prototype.closeFullscreenDetail = function()
	{
		if (this.mFullscreenDetail !== null)
		{
			this.mFullscreenDetail.suspend();
		}
	};

	BattleValkyriesHubModule.prototype.closePopup = function()
	{
		if (this.mPopup !== null)
		{
			this.mPopup.remove();
			this.mPopup = null;
		}
	};

	BattleValkyriesHubModule.prototype.showPopup = function(_title, _message, _buttons)
	{
		var self = this;
		var overlay = this.ensureDialog();
		this.closePopup();

		this.mPopup = $('<div class="battle-valkyries-popup-backdrop"></div>');
		var panel = $('<div class="battle-valkyries-popup-panel ui-control"></div>');
		var title = $('<div class="battle-valkyries-popup-title title-font-normal font-bold font-bottom-shadow font-color-title"></div>');
		var message = $('<div class="battle-valkyries-popup-message text-font-normal font-color-description"></div>');
		var actions = $('<div class="battle-valkyries-popup-actions"></div>');

		title.text(_title || "");
		message.text(_message || "");

		for (var i = 0; i < _buttons.length; ++i)
		{
			(function(_button)
			{
				var action = $('<button type="button" class="battle-valkyries-popup-action text-font-small font-bold"></button>');
				action.text(_button.Label);
				action.on("click", function(_event)
				{
					_event.preventDefault();
					_event.stopPropagation();
					self.closePopup();

					if (_button.Callback !== null && _button.Callback !== undefined)
					{
						_button.Callback();
					}
				});
				actions.append(action);
			})(_buttons[i]);
		}

		panel.append(title);
		panel.append(message);
		panel.append(actions);
		this.mPopup.append(panel);
		overlay.append(this.mPopup);
	};

	BattleValkyriesHubModule.prototype.showMessage = function(_message, _title)
	{
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;
		this.showPopup(_title || messages.ResultTitle, _message, [
			{ Label: messages.OK, Callback: null }
		]);
	};

	BattleValkyriesHubModule.prototype.createDetailSection = function(_entry, _extraClass)
	{
		if (_entry === null || _entry === undefined)
		{
			return null;
		}

		var section = $('<div class="battle-valkyries-detail-section"></div>');
		if (_extraClass !== null && _extraClass !== undefined && _extraClass !== "")
		{
			section.addClass(_extraClass);
		}

		var header = $('<div class="battle-valkyries-detail-section-header"></div>');

		if (_entry.Icon !== "")
		{
			var iconWrap = $('<div class="battle-valkyries-detail-section-icon"></div>');
			var icon = $("<img/>");
			icon.attr("src", Path.GFX + _entry.Icon);
			icon.attr("alt", _entry.Name);
			iconWrap.append(icon);
			header.append(iconWrap);
		}

		var titleWrap = $('<div class="battle-valkyries-detail-section-title-wrap"></div>');
		var label = $('<div class="battle-valkyries-detail-section-label text-font-small font-bold"></div>');
		var name = $('<div class="battle-valkyries-detail-section-name text-font-normal font-bold"></div>');
		label.text(_entry.Label || "");
		name.text(_entry.Name || "");
		titleWrap.append(label);
		titleWrap.append(name);
		header.append(titleWrap);

		var description = $('<div class="battle-valkyries-detail-section-description text-font-small"></div>');
		description.text(_entry.Description || "");

		section.append(header);
		section.append(description);
		return section;
	};

	BattleValkyriesHubModule.prototype.showValkyrieDetail = function(_slot)
	{
		if (!_slot || !_slot.Detail) return;
		this.closeFullscreenDetail();
		this.closePopup();
		if (this.mFullscreenDetail === null) this.mFullscreenDetail = new window[namespace + "FullscreenDetail"](this, _slot);
		else this.mFullscreenDetail.resume(_slot);
	};

	BattleValkyriesHubModule.prototype.showSummonConfirm = function(_slot, _skinID)
	{
		var self = this;
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;
		var cost = this.mData !== null && typeof this.mData.SummonCost === "number" ? this.mData.SummonCost : this.mFallbackData.SummonCost;
		var message = messages.ConfirmMessage || (messages.ConfirmPrefix + _slot.Name + messages.ConfirmSuffix);
		message = message.replace("{name}", _slot.Name).replace("{cost}", cost);

		this.showPopup(messages.ConfirmTitle, message, [
			{
				Label: messages.ConfirmYes,
				Callback: function()
				{
					self.performSummon(_slot.ID, _skinID);
				}
			},
			{ Label: messages.Cancel, Callback: null }
		]);
	};

	BattleValkyriesHubModule.prototype.performSummon = function(_slotID, _skinID)
	{
		var self = this;

		SQ.call(this.mBackendHandle, "summonBattleValkyrie", { ValkyrieID: _slotID, SkinID: _skinID || "" }, function(_result)
		{
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);

				if (_result !== null && _result !== undefined && _result.Success !== true && _result.Message !== undefined && _result.Message !== "")
				{
					self.showMessage(_result.Message);
				}
			});
		});
	};

	BattleValkyriesHubModule.prototype.performPullGacha = function()
	{
		if (this.mGachaPullBusy) return;
		this.mGachaPullBusy = true;
		var self = this;
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		SQ.call(this.mBackendHandle, "pullBattleValkyrieGacha", null, function(_result)
		{
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.mGachaPullBusy = false;
				self.applyData(_data);

				if (_result !== null && _result !== undefined && _result.Message !== undefined && _result.Message !== "")
				{
					self.showMessage(_result.Message, messages.GachaResultTitle);
				}
			});
		});
	};

	BattleValkyriesHubModule.prototype.performSelectGachaTarget = function(_slotID, _skinID)
	{
		var self = this;

		SQ.call(this.mBackendHandle, "selectBattleValkyrieGachaTarget", { ValkyrieID: _slotID, SkinID: _skinID || "" }, function(_result)
		{
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);

				if (_result !== null && _result !== undefined && _result.Message !== undefined && _result.Message !== "")
				{
					self.showMessage(_result.Message);
				}
			});
		});
	};

	BattleValkyriesHubModule.prototype.performSetWorldLeader = function(_slotID, _skinID)
	{
		var self = this;
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		SQ.call(this.mBackendHandle, "setBattleValkyriesWorldLeader", { ValkyrieID: _slotID, SkinID: _skinID || "" }, function(_result)
		{
			self.loadData(self.mBackendHandle, function(_data)
			{
				self.applyData(_data);
				if (_result !== null && _result !== undefined && _result.Success === true)
				{
					self.closePopup();
				}

				if (_result !== null && _result !== undefined && _result.Message !== undefined && _result.Message !== "")
				{
					self.showMessage(_result.Message, messages.LeaderResultTitle);
				}
			});
		});
	};

	BattleValkyriesHubModule.prototype.performGrantSkinItem = function(_slotID, _skinID)
	{
		var self = this;
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		SQ.call(this.mBackendHandle, "grantBattleValkyrieSkinItem", { ValkyrieID: _slotID, SkinID: _skinID || "" }, function(_result)
		{
			if (_result !== null && _result !== undefined && _result.Message !== undefined && _result.Message !== "")
			{
				self.showMessage(_result.Message, messages.SkinItemResultTitle);
			}
		});
	};

	BattleValkyriesHubModule.prototype.tryGrantSkinItem = function(_slotID, _skinID)
	{
		var slot = this.findSummonSlot(_slotID);
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		if (slot === null || slot.Detail === null || slot.Detail === undefined || this.mBackendHandle === null || this.mBackendHandle === undefined)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		this.performGrantSkinItem(_slotID, _skinID);
	};

	BattleValkyriesHubModule.prototype.trySetWorldLeader = function(_slotID, _skinID)
	{
		var slot = this.findSummonSlot(_slotID);
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		if (slot === null || this.mBackendHandle === null || this.mBackendHandle === undefined)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		var skin = null;
		if (slot.Detail !== null && slot.Detail !== undefined && jQuery.isArray(slot.Detail.Skins))
		{
			for (var i = 0; i < slot.Detail.Skins.length; ++i)
			{
				if (slot.Detail.Skins[i].ID === _skinID)
				{
					skin = slot.Detail.Skins[i];
					break;
				}
			}
		}

		var isWorldLeader = skin !== null ? skin.IsWorldLeader : (slot.IsWorldLeader && (slot.WorldLeaderSkinID === "" || slot.WorldLeaderSkinID === _skinID));
		var canSetWorldLeader = skin !== null ? skin.CanSetWorldLeader : slot.CanSetWorldLeader;

		if (isWorldLeader)
		{
			this.showMessage(messages.LeaderCurrentButton || slot.Status || messages.Unavailable, messages.LeaderResultTitle);
			return;
		}

		if (!canSetWorldLeader)
		{
			this.showMessage(slot.Status || messages.Unavailable, messages.LeaderResultTitle);
			return;
		}

		this.performSetWorldLeader(_slotID, _skinID);
	};

	BattleValkyriesHubModule.prototype.trySummon = function(_slotID, _skinID)
	{
		var slot = this.findSummonSlot(_slotID);
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		if (slot === null || this.mBackendHandle === null || this.mBackendHandle === undefined)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		if (!slot.CanSummon)
		{
			this.showMessage(slot.Status || messages.Unavailable);
			return;
		}

		this.showSummonConfirm(slot, _skinID);
	};

	BattleValkyriesHubModule.prototype.tryPullGacha = function()
	{
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		if (this.mData === null || this.mData.GachaModeEnabled !== true)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		if (this.mBackendHandle === null || this.mBackendHandle === undefined)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		this.performPullGacha();
	};

	BattleValkyriesHubModule.prototype.trySelectGachaTarget = function(_slotID, _skinID)
	{
		var slot = this.findSummonSlot(_slotID);
		var messages = this.mData !== null && this.mData.Messages !== undefined ? this.mData.Messages : this.mFallbackData.Messages;

		if (slot === null || this.mBackendHandle === null || this.mBackendHandle === undefined)
		{
			this.showMessage(messages.Unavailable);
			return;
		}

		if (this.mData === null || this.mData.GachaModeEnabled !== true || !slot.CanGachaSelect)
		{
			this.showMessage(slot.Status || messages.Unavailable);
			return;
		}

		this.performSelectGachaTarget(_slotID, _skinID);
	};

	BattleValkyriesHubModule.prototype.applyData = function(_data)
	{
		this.ensureDialog();
		this.mData = _data;
		this.mOverlay.find('.battle-valkyries-roster-hub-button').toggle(_data.RosterEnabled === true);
		this.mTitle.text(_data.Title);
		this.mCloseButton.text(_data.Close);
		this.renderTabs(_data.Tabs);
		this.selectTab(_data.Tabs, this.mActiveTabID || (_data.Tabs.length > 0 ? _data.Tabs[0].ID : null));
		if (this.mFullscreenDetail !== null)
		{
			var detailSlot = this.findSummonSlot(this.mFullscreenDetail.slot.ID);
			if (detailSlot && detailSlot.Detail)
			{
				this.mFullscreenDetail.refresh(detailSlot);
			}
			else
			{
				this.closeFullscreenDetail();
			}
		}
	};

	BattleValkyriesHubModule.prototype.open = function(_backendHandle)
	{
		if (this.mWorldScreenHidden) return;
		var self = this, generation = this.mLifecycleGeneration;
		this.mBackendHandle = _backendHandle;
		this.loadData(_backendHandle, function(_data)
		{
			if (generation !== self.mLifecycleGeneration || self.mWorldScreenHidden) return;
			self.applyData(_data);
			self.mOverlay.removeClass("display-none").addClass("display-block");
		});
	};

	BattleValkyriesHubModule.prototype.close = function()
	{
		this.mLifecycleGeneration++;
		this.mPendingChapterOpens = []; this.mChapterOpenInFlight = null;
		if (this.mChapterView) this.mChapterView.destroy(false);
		this.closeFullscreenDetail();
		if (this.mOverlay !== null)
		{
			this.closePopup();
			this.mOverlay.removeClass("display-block").addClass("display-none");
		}
	};

	BattleValkyriesHubModule.prototype.destroyDialog = function()
	{
		this.mLifecycleGeneration++;
		this.mPendingChapterOpens = []; this.mChapterOpenInFlight = null;
		if (this.mChapterView) this.mChapterView.destroy(false);
		if (this.mFullscreenDetail !== null)
		{
			this.mFullscreenDetail.destroy();
			this.mFullscreenDetail = null;
		}
		if (this.mOverlay !== null)
		{
			this.closePopup();
			this.mOverlay.remove();
			this.mOverlay = null;
			this.mTitle = null;
			this.mBody = null;
			this.mTabsContainer = null;
			this.mCloseButton = null;
			this.mActiveTabID = null;
			this.mBackendHandle = null;
			this.mData = null;
		}
	};

	BattleValkyriesHubModule.prototype.isTextInputEvent = function(_event)
	{
		var target = _event.target || _event.srcElement;
		if (target === null || target === undefined)
		{
			return false;
		}

		var tagName = target.tagName !== undefined ? target.tagName.toLowerCase() : "";
		return tagName === "input" || tagName === "textarea" || tagName === "select" || target.isContentEditable === true;
	};

	BattleValkyriesHubModule.prototype.isOpenHubHotkey = function(_event)
	{
		if (typeof MSU === "undefined" || MSU.Keybinds === undefined || MSU.Keybinds === null)
		{
			return false;
		}

		if (!(modID in MSU.Keybinds.KeybindsByMod) || !(openHubKeybindID in MSU.Keybinds.KeybindsByMod[modID]))
		{
			return false;
		}

		return MSU.Keybinds.isKeybindPressed(modID, openHubKeybindID, _event);
	};

	BattleValkyriesHubModule.prototype.openFromHotkey = function()
	{
		if (this.mTopbarOptionsModule === null ||
			this.mTopbarOptionsModule === undefined ||
			this.mTopbarOptionsModule.mContainer === null ||
			this.mTopbarOptionsModule.mContainer === undefined ||
			this.mTopbarOptionsModule.mContainer.length === 0 ||
			!this.mTopbarOptionsModule.mContainer.is(":visible") ||
			this.mTopbarOptionsModule.mSQHandle === null ||
			this.mTopbarOptionsModule.mSQHandle === undefined)
		{
			return false;
		}

		this.open(this.mTopbarOptionsModule.mSQHandle);
		return true;
	};

	BattleValkyriesHubModule.prototype.handleHotkeyDown = function(_event)
	{
		if (this.mHotkeyDown || this.isTextInputEvent(_event) || !this.isOpenHubHotkey(_event))
		{
			return;
		}

		if (this.openFromHotkey())
		{
			this.mHotkeyDown = true;
			_event.preventDefault();
			_event.stopPropagation();
		}
	};

	BattleValkyriesHubModule.prototype.handleHotkeyUp = function(_event)
	{
		this.mHotkeyDown = false;
	};

	BattleValkyriesHubModule.prototype.patchHotkey = function()
	{
		if (this.mHotkeyHandlerRegistered)
		{
			return true;
		}

		if (typeof MSU === "undefined" || MSU.Keybinds === undefined || MSU.Keybinds === null)
		{
			return false;
		}

		var self = this;
		document.addEventListener("keydown", function(_event)
		{
			self.handleHotkeyDown(_event);
		});
		document.addEventListener("keyup", function(_event)
		{
			self.handleHotkeyUp(_event);
		});

		this.mHotkeyHandlerRegistered = true;
		return true;
	};

	BattleValkyriesHubModule.prototype.addTopbarButton = function(_topbarOptionsModule)
	{
		if (_topbarOptionsModule === null || _topbarOptionsModule === undefined || _topbarOptionsModule.mContainer === null)
		{
			return;
		}

		this.mTopbarOptionsModule = _topbarOptionsModule;

		if (_topbarOptionsModule.mBattleValkyriesButton !== undefined &&
			_topbarOptionsModule.mBattleValkyriesButton !== null &&
			_topbarOptionsModule.mBattleValkyriesButton.parent().length > 0)
		{
			return;
		}

		var buttonContainer = _topbarOptionsModule.mContainer.find(".l-button-container:first");
		if (buttonContainer.length === 0)
		{
			return;
		}

		var self = this;
		_topbarOptionsModule.mBattleValkyriesButton = buttonContainer.createImageButton(Path.GFX + this.mIconPath, function()
		{
			self.open(_topbarOptionsModule.mSQHandle);
		}, "l-battle-valkyries-button l-image-button", 6);

		_topbarOptionsModule.mBattleValkyriesButton.attr("title", this.mFallbackData.ButtonTitle);

		if (_topbarOptionsModule.mQuitButton !== null &&
			_topbarOptionsModule.mQuitButton !== undefined &&
			_topbarOptionsModule.mQuitButton.length > 0)
		{
			_topbarOptionsModule.mBattleValkyriesButton.insertBefore(_topbarOptionsModule.mQuitButton);
		}
	};

	BattleValkyriesHubModule.prototype.patchTopbarOptions = function()
	{
		if (typeof WorldScreenTopbarOptionsModule === "undefined")
		{
			return false;
		}

		if (WorldScreenTopbarOptionsModule.prototype.BattleValkyriesHubPatched === true)
		{
			return true;
		}

		var self = this;
		var originalCreateDIV = WorldScreenTopbarOptionsModule.prototype.createDIV;
		var originalDestroyDIV = WorldScreenTopbarOptionsModule.prototype.destroyDIV;
		WorldScreenTopbarOptionsModule.prototype.showBattleValkyrieChapter = function(id) { self.queueChapterOpen(this.mSQHandle, id); };
		WorldScreenTopbarOptionsModule.prototype.showBattleValkyrieSummon = function()
		{
			self.mActiveTabID = "summon";
			self.open(this.mSQHandle);
		};

		WorldScreenTopbarOptionsModule.prototype.createDIV = function(_parentDiv)
		{
			originalCreateDIV.call(this, _parentDiv);
			self.addTopbarButton(this);
		};

		WorldScreenTopbarOptionsModule.prototype.destroyDIV = function()
		{
			if (self.mTopbarOptionsModule === this)
			{
				self.mTopbarOptionsModule = null;
			}
			originalDestroyDIV.call(this);
			this.mBattleValkyriesButton = null;
		};

		WorldScreenTopbarOptionsModule.prototype.BattleValkyriesHubPatched = true;
		return true;
	};

	BattleValkyriesHubModule.prototype.queueChapterOpen = function(handle, request)
	{
		var intent = { Handle: handle, ID: typeof request === "object" && request ? request.ID : request,
			OriginScene: request && request.OpenOriginScene, OpenWish: !!(request && request.OpenWish) };
		if (!intent.ID) return;
		var same = function(other) { return other && other.Handle === intent.Handle && other.ID === intent.ID && other.OriginScene === intent.OriginScene && other.OpenWish === intent.OpenWish; };
		if (same(this.mChapterOpenInFlight) || (this.mChapterView && same(this.mChapterView.openIntent))) return;
		for (var i = 0; i < this.mPendingChapterOpens.length; ++i) if (same(this.mPendingChapterOpens[i])) return;
		this.mPendingChapterOpens.push(intent);
		this.processPendingChapterOpen();
	};
	BattleValkyriesHubModule.prototype.processPendingChapterOpen = function()
	{
		if (this.mWorldScreenHidden || this.mChapterView || this.mChapterOpenInFlight || !this.mPendingChapterOpens.length) return;
		var self = this, generation = this.mLifecycleGeneration, intent = this.mPendingChapterOpens.shift();
		this.mChapterOpenInFlight = intent;
		this.mBackendHandle = intent.Handle;
		this.loadData(intent.Handle, function(data) {
			if (generation !== self.mLifecycleGeneration || self.mChapterOpenInFlight !== intent) return;
			self.mChapterOpenInFlight = null;
			// Another modal may have arrived while the authoritative query was pending.
			if (self.mWorldScreenHidden || self.mChapterView) { self.mPendingChapterOpens.unshift(intent); return; }
			self.applyData(data);
			self.mOverlay.removeClass("display-none").addClass("display-block");
			self.selectTab(data.Tabs, "chapters");
			for (var i = 0; i < data.ChapterCards.length; ++i) if (data.ChapterCards[i].ID === intent.ID && window[namespace + "ChapterView"]) {
				var view = new window[namespace + "ChapterView"](self, data.ChapterCards[i]);
				self.mChapterView = view; view.openIntent = intent; view.openWishOnRefresh = intent.OpenWish;
				if (intent.OriginScene && view.data.StoryOnly) view.showStory(intent.OriginScene === "first_contract" ? view.data.EndingScene : view.data.Opening);
				else if (!view.data.StoryOnly) view.request("refresh");
				break;
			}
			self.processPendingChapterOpen();
		});
	};
	BattleValkyriesHubModule.prototype.suspendForWorldScreen = function()
	{
		this.mWorldScreenHidden = true;
		if (this.mChapterView) this.mChapterView.suspend();
		this.closeFullscreenDetail(); this.closePopup();
		if (this.mOverlay) this.mOverlay.removeClass("display-block").addClass("display-none");
	};
	BattleValkyriesHubModule.prototype.resumeForWorldScreen = function()
	{
		this.mWorldScreenHidden = false;
		if (this.mChapterView && this.mChapterView.suspended) {
			if (this.mOverlay) this.mOverlay.removeClass("display-none").addClass("display-block");
			this.mChapterView.resume();
		}
		this.processPendingChapterOpen();
	};
	BattleValkyriesHubModule.prototype.patchWorldScreenLifecycle = function()
	{
		if (typeof WorldScreen === "undefined")
		{
			return false;
		}

		if (WorldScreen.prototype.BattleValkyriesHubLifecyclePatched === true)
		{
			return true;
		}

		var self = this;
		var originalHide = WorldScreen.prototype.hide;
		var originalShow = WorldScreen.prototype.show;
		var originalUnregister = WorldScreen.prototype.unregister;

		WorldScreen.prototype.hide = function(_immediately)
		{
			self.suspendForWorldScreen();
			return originalHide.apply(this, arguments);
		};
		WorldScreen.prototype.show = function(_immediately)
		{
			var result = originalShow.apply(this, arguments);
			self.resumeForWorldScreen();
			return result;
		};

		WorldScreen.prototype.unregister = function()
		{
			self.mWorldScreenHidden = true;
			self.destroyDialog();
			return originalUnregister.apply(this, arguments);
		};

		WorldScreen.prototype.BattleValkyriesHubLifecyclePatched = true;
		return true;
	};

	BattleValkyriesHubModule.prototype.patch = function()
	{
		return this.patchTopbarOptions() && this.patchWorldScreenLifecycle() && this.patchHotkey();
	};
	window[namespace + "Hub"] = window[namespace + "Hub"] || new BattleValkyriesHubModule();

	if (!window[namespace + "Hub"].patch())
	{
		$(document).ready(function()
		{
			window[namespace + "Hub"].patch();
		});
	}
})();
