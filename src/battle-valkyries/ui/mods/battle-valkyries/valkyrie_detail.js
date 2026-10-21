(function()
{
	"use strict";
	var namespace = "$bvvar{namespace}";
	var corruptionCopy = {
		bond: "$bv{olga.corruption.ui.label}",
		bondCurrent: "$bv{olga.corruption.ui.current}",
		bondUnavailable: "$bv{olga.corruption.ui.unavailable}",
		bondUnavailableDescription: "$bv{olga.corruption.ui.unavailable_description}",
		bondAllComplete: "$bv{olga.corruption.ui.complete}",
		storyTypeBond: "$bv{olga.corruption.ui.story}"
	};
	function narrativeCopy(detail, key)
	{
		return detail.Bond && detail.Bond.Type === "corruption" && corruptionCopy[key] ? corruptionCopy[key] : copy[key];
	}
	var copy = {
		back: "$bv{ui.hub.fullscreen.back}",
		dossier: "$bv{ui.hub.fullscreen.dossier}",
		background: "$bv{ui.hub.fullscreen.background}",
		trait: "$bv{ui.hub.fullscreen.trait}",
		skills: "$bv{ui.hub.fullscreen.skills}",
		profile: "$bv{ui.hub.fullscreen.profile}",
		hunt: "$bv{ui.hub.fullscreen.hunt}",
		bond: "$bv{ui.hub.fullscreen.bond}",
		story: "$bv{ui.hub.fullscreen.story}",
		research: "$bv{research.the_herta.tab}",
		researchTitle: "$bv{research.the_herta.title}",
		researchDescription: "$bv{research.the_herta.description}",
		researchRequiresSummon: "$bv{research.the_herta.requires_summon}",
		researchUnavailable: "$bv{research.the_herta.unavailable}",
		researchEmpty: "$bv{research.the_herta.empty}",
		researchInventory: "$bv{research.the_herta.inventory}",
		researchSelectedSample: "$bv{research.the_herta.selected_sample}",
		researchChooseSample: "$bv{research.the_herta.choose_sample}",
		researchChangeSample: "$bv{research.the_herta.change_sample}",
		researchPickerTitle: "$bv{research.the_herta.picker.title}",
		researchPickerHint: "$bv{research.the_herta.picker.hint}",
		researchPickerCount: "$bv{research.the_herta.picker.count}",
		researchPickerClose: "$bv{research.the_herta.picker.close}",
		researchPickerConfirm: "$bv{research.the_herta.picker.confirm}",
		researchFilterAll: "$bv{research.the_herta.filter.all}",
		researchFilterWeapon: "$bv{research.the_herta.filter.weapon}",
		researchFilterHelmet: "$bv{research.the_herta.filter.helmet}",
		researchFilterArmor: "$bv{research.the_herta.filter.armor}",
		researchFilterShield: "$bv{research.the_herta.filter.shield}",
		researchFilterRarity: "$bv{research.the_herta.filter.rarity}",
		researchAffixes: "$bv{research.the_herta.affixes}",
		researchNoAffixes: "$bv{research.the_herta.no_affixes}",
		researchTarget: "$bv{research.the_herta.target}",
		researchCost: "$bv{research.the_herta.cost}",
		researchMoney: "$bv{research.the_herta.money}",
		researchRetain: "$bv{research.the_herta.mode.retain}",
		researchRetainDescription: "$bv{research.the_herta.mode.retain_description}",
		researchReroll: "$bv{research.the_herta.mode.reroll}",
		researchRerollDescription: "$bv{research.the_herta.mode.reroll_description}",
		researchUpgrade: "$bv{research.the_herta.upgrade}",
		researchConfirmTitle: "$bv{research.the_herta.confirm_title}",
		researchConfirm: "$bv{research.the_herta.confirm}",
		researchResultTitle: "$bv{research.the_herta.result_title}",
		researchQuotaPurple: "$bv{research.the_herta.quota.purple}",
		researchQuotaPrismatic: "$bv{research.the_herta.quota.prismatic}",
		researchQuotaReady: "$bv{research.the_herta.quota.ready}",
		researchQuotaDays: "$bv{research.the_herta.quota.days}",
		researchReady: "$bv{research.the_herta.ready}",
		researchNeedQuota: "$bv{research.the_herta.need_quota}",
		researchNeedMaterials: "$bv{research.the_herta.need_materials}",
		researchNeedMoney: "$bv{research.the_herta.need_money}",
		spirits: "$bv{lily.spirits.tab}",
		spiritsTitle: "$bv{lily.spirits.title}",
		spiritsPoints: "$bv{lily.spirits.points}",
		spiritsPending: "$bv{lily.spirits.pending}",
		spiritsNext: "$bv{lily.spirits.next}",
		spiritsComplete: "$bv{lily.spirits.complete}",
		spiritsLoadout: "$bv{lily.spirits.loadout}",
		spiritsCollection: "$bv{lily.spirits.collection}",
		spiritsAll: "$bv{lily.spirits.filter.all}",
		spiritsMain: "$bv{lily.spirits.filter.main}",
		spiritsSub: "$bv{lily.spirits.filter.sub}",
		spiritsEmpty: "$bv{lily.spirits.empty}",
		spiritsEmptyWarning: "$bv{lily.spirits.empty_warning}",
		spiritsLocked: "$bv{lily.spirits.locked}",
		spiritsEquipped: "$bv{lily.spirits.equipped}",
		spiritsEquip: "$bv{lily.spirits.equip}",
		spiritsInspect: "$bv{lily.spirits.inspect}",
		spiritsFull: "$bv{lily.spirits.full}",
		spiritsRemove: "$bv{lily.spirits.remove}",
		spiritsMoveLeft: "$bv{lily.spirits.move_left}",
		spiritsMoveRight: "$bv{lily.spirits.move_right}",
		spiritsSave: "$bv{lily.spirits.save}",
		spiritsReset: "$bv{lily.spirits.reset}",
		spiritsUnsaved: "$bv{lily.spirits.unsaved}",
		spiritsSavedState: "$bv{lily.spirits.saved_state}",
		spiritsReadOnly: "$bv{lily.spirits.read_only}",
		spiritsCost: "$bv{lily.spirits.cost}",
		spiritsRange: "$bv{lily.spirits.range}",
		spiritsMainLabel: "$bv{lily.spirits.main}",
		spiritsSubLabel: "$bv{lily.spirits.sub}",
		spiritsManage: "$bv{lily.spirits.manage}",
		spiritsManagerHint: "$bv{lily.spirits.manager_hint}",
		spiritsClose: "$bv{lily.spirits.close}",
		bondCurrent: "$bv{ui.hub.fullscreen.bond_current}",
		bondUnavailable: "$bv{ui.hub.fullscreen.bond_unavailable}",
		bondUnavailableDescription: "$bv{ui.hub.fullscreen.bond_unavailable_description}",
		bondCompleted: "$bv{ui.hub.fullscreen.bond_completed}",
		bondChallenge: "$bv{ui.hub.fullscreen.bond_challenge}",
		bondStoryPending: "$bv{ui.hub.fullscreen.bond_story_pending}",
		bondLocked: "$bv{ui.hub.fullscreen.bond_locked}",
		bondReward: "$bv{ui.hub.fullscreen.bond_reward}",
		bondAllComplete: "$bv{ui.hub.fullscreen.bond_all_complete}",
		storyArchive: "$bv{ui.hub.fullscreen.story_archive}",
		storyUnlocked: "$bv{ui.hub.fullscreen.story_unlocked}",
		storyEmpty: "$bv{ui.hub.fullscreen.story_empty}",
		storyLocked: "$bv{ui.hub.fullscreen.story_locked}",
		storyOpen: "$bv{ui.hub.fullscreen.story_open}",
		storyTypeBond: "$bv{ui.hub.fullscreen.story_type_bond}",
		storyIntro: "$bv{ui.hub.fullscreen.story_intro}",
		storyReveal: "$bv{ui.hub.fullscreen.story_reveal}",
		storyPrevious: "$bv{ui.hub.fullscreen.story_previous}",
		storyNext: "$bv{ui.hub.fullscreen.story_next}",
		storyClose: "$bv{ui.hub.fullscreen.story_close}",
		skins: "$bv{ui.hub.fullscreen.skins}",
		skinSelect: "$bv{ui.hub.fullscreen.skin_select}",
		currentSkin: "$bv{ui.hub.fullscreen.current_skin}",
		previewOnly: "$bv{ui.hub.fullscreen.preview_only}",
		gallery: "$bv{ui.hub.fullscreen.gallery}",
		showUI: "$bv{ui.hub.fullscreen.show_ui}",
		retry: "$bv{ui.hub.fullscreen.retry}",
		mediaFailed: "$bv{ui.hub.fullscreen.media_failed}",
		unsupported: "$bv{ui.hub.fullscreen.unsupported}",
		loading: "$bv{ui.hub.fullscreen.loading}",
		static: "$bv{ui.hub.fullscreen.static}",
		pending: "$bv{ui.hub.fullscreen.pending}",
		failed: "$bv{ui.hub.fullscreen.failed}"
		,huntPoints: "$bv{ui.hub.fullscreen.hunt_points}"
		,huntPending: "$bv{ui.hub.fullscreen.hunt_pending}"
		,huntDirect: "$bv{ui.hub.fullscreen.hunt_direct}"
		,huntAssists: "$bv{ui.hub.fullscreen.hunt_assists}"
		,huntRank: "$bv{ui.hub.fullscreen.hunt_rank}"
		,huntNext: "$bv{ui.hub.fullscreen.hunt_next}"
		,huntMax: "$bv{ui.hub.fullscreen.hunt_max}"
		,huntBreakdown: "$bv{ui.hub.fullscreen.hunt_breakdown}"
		,huntRecordButton: "$bv{ui.hub.fullscreen.hunt_record_button}"
		,huntRecordClose: "$bv{ui.hub.fullscreen.hunt_record_close}"
		,huntViewDetails: "$bv{ui.hub.fullscreen.hunt_view_details}"
		,huntMilestones: "$bv{ui.hub.fullscreen.hunt_milestones}"
		,huntPassive: "$bv{ui.hub.fullscreen.hunt_passive}"
		,huntActive: "$bv{ui.hub.fullscreen.hunt_active}"
		,huntUnlocked: "$bv{ui.hub.fullscreen.hunt_unlocked}"
		,huntLocked: "$bv{ui.hub.fullscreen.hunt_locked}"
		,huntPointValue: "$bv{ui.hub.fullscreen.hunt_point_value}"
	};
	function el(tag, className, text)
	{
		var node = $("<" + tag + "/>").addClass(className);
		if (text !== undefined) node.text(text);
		return node;
	}
	function button(className, text, callback)
	{
		return el("button", className + " text-font-normal", text).attr("type", "button").on("click", function(event)
		{
			event.preventDefault();
			event.stopPropagation();
			if (!this.disabled) callback();
		});
	}
	function disabled(node, value)
	{
		node.prop("disabled", value).attr("aria-disabled", value ? "true" : "false");
	}

	function DetailMediaPool()
	{
		this.host = el("div", "bv-detail-video-pool").attr("aria-hidden", "true");
		this.slots = {};
		this.activeSlot = null;
		this.owner = null;
		this.pending = null;
		this.requestToken = 0;
		this.loadTimer = null;
		this.progressTimer = null;
		this.auditTimer = null;
		this.auditToken = 0;
		this.releaseTimer = null;
		this.releaseToken = 0;
		this.attached = false;
	}

	function getDetailMediaPool()
	{
		var key = namespace + "DetailMediaPool";
		if (!window[key]) window[key] = new DetailMediaPool();
		return window[key];
	}

	// Separate presentation state: previewing a skin never changes actor identity or the gacha target.
	function FullscreenDetail(hub, slot)
	{
		this.hub = hub;
		this.slot = slot;
		this.skinID = slot.State !== "summoned" && slot.IsGachaSelected && slot.GachaSelectedSkinID ? slot.GachaSelectedSkinID : slot.Detail.ActiveSkinID;
		this.tabID = "profile";
		this.previewStage = null;
		this.actualStage = null;
		this.bondStageValue = 0;
		this.story = null;
		this.storyPage = 0;
		this.huntRecordOpen = false;
		this.huntRecordTrigger = null;
		this.huntSkill = null;
		this.huntSkillTrigger = null;
		this.researchItemID = null;
		this.researchMode = "retain";
		this.researchPickerOpen = false;
		this.researchPickerTrigger = null;
		this.researchInspectID = null;
		this.researchPartFilter = "all";
		this.researchRarityFilter = "all";
		this.lilySpiritFilter = "all";
		this.lilySpiritDraft = null;
		this.lilySpiritSavedLoadout = null;
		this.lilySpiritInspectKey = null;
		this.lilySpiritManagerOpen = false;
		this.lilySpiritManagerTrigger = null;
		this.gallery = false;
		this.busy = false;
		this.active = false;
		if(this.ryzaWorkshop)this.ryzaWorkshop.close(false);
		this.disposed = false;
		this.video = null;
		this.videoSource = null;
		this.mediaKey = null;
		this.mediaPool = getDetailMediaPool();
		this.previousFocus = document.activeElement;
		this.build();
		this.resume(slot);
	}

	FullscreenDetail.prototype.build = function()
	{
		var self = this;
		// Choose one event family so a wheel notch cannot be applied twice.
		var wheelType = "onwheel" in document ? "wheel" : ("onmousewheel" in document ? "mousewheel" : "DOMMouseScroll");
		// Use the game's font classes: Chinese packs replace these embedded fonts.
		this.root = el("div", "bv-detail ui-control text-font-normal").attr({ role: "dialog", "aria-modal": "true", "aria-label": this.slot.Name });
		this.stage = el("div", "bv-detail-stage").attr("aria-hidden", "true");
		this.poster = el("img", "bv-detail-poster").attr("alt", "");
		this.stage.append(this.poster);
		this.root.append(this.stage).append(el("div", "bv-detail-shade"));
		var header = el("div", "bv-detail-header");
		this.back = button("bv-detail-button bv-detail-back", copy.back, function() { self.hub.closeFullscreenDetail(); });
		header.append(this.back);
		var controls = el("div", "bv-detail-controls");
		this.mediaStatus = el("span", "bv-detail-media-status").attr({ role: "status", "aria-live": "polite" });
		this.retryButton = button("bv-detail-button bv-detail-retry", copy.retry, function() { self.retryMedia(); }).hide();
		this.galleryButton = button("bv-detail-button", copy.gallery, function() { self.setGallery(!self.gallery); });
		controls.append(this.mediaStatus).append(this.retryButton).append(this.galleryButton);
		header.append(controls);
		this.root.append(header);

		this.panel = el("div", "bv-detail-dossier");
		var heading = el("div", "bv-detail-heading");
		this.subtitle = el("div", "bv-detail-eyebrow", copy.dossier);
		this.title = el("h1", "bv-detail-name title-font-big");
		this.status = el("div", "bv-detail-status");
		heading.append(this.subtitle).append(this.title).append(this.status);
		this.panel.append(heading);
		// Skin is the scene-level selector; the tabs below only navigate character information.
		this.skinSelector = el("div", "bv-detail-skin-selector");
		var selectionHeading = el("div", "bv-detail-skin-selection-heading");
		this.skinLabel = el("div", "bv-detail-eyebrow", copy.skinSelect);
		selectionHeading.append(this.skinLabel).append(el("div", "bv-detail-preview-hint", copy.previewOnly));
		this.skinTabs = el("div", "bv-detail-skin-tabs").attr({ role: "group", "aria-label": copy.skinSelect });
		this.skinSelector.append(selectionHeading).append(this.skinTabs);
		this.panel.append(this.skinSelector);
		this.tabs = el("div", "bv-detail-tabs").attr("role", "tablist");
		this.tabButtons = {};
		this.tabMeta = {};
		var tabIDs = ["profile", "workshop", "spirits", "hunt", "bond", "story", "research"];
		for (var i = 0; i < tabIDs.length; ++i)
		{
			(function(id)
			{
				var tab = button("bv-detail-tab", "", function() { self.selectTab(id); });
				tab.append(el("span", "bv-detail-tab-label", id === "alchemy" ? "$bv{ryza.alchemy.tab}" : (id === "workshop" ? "$bv{five.workshop}" : copy[id])));
				var meta = el("span", "bv-detail-tab-meta").hide();
				tab.append(meta);
				tab.attr({ role: "tab", id: namespace + "-detail-tab-" + id, "aria-controls": namespace + "-detail-content" });
				tab.on("keydown", function(event)
				{
					var available = [];
					for (var tabIndex = 0; tabIndex < tabIDs.length; ++tabIndex) if (self.tabButtons[tabIDs[tabIndex]].is(":visible")) available.push(tabIDs[tabIndex]);
					var index = available.indexOf(id);
					if (event.which !== 37 && event.which !== 39) return;
					event.preventDefault();
					var next = available[(index + (event.which === 39 ? 1 : available.length - 1)) % available.length];
					self.selectTab(next);
					self.tabButtons[next][0].focus();
				});
				self.tabButtons[id] = tab;
				self.tabMeta[id] = meta;
				self.tabs.append(tab);
			})(tabIDs[i]);
		}
		this.content = el("div", "bv-detail-content").attr({ id: namespace + "-detail-content", role: "tabpanel", tabindex: "0" });
		this.content.on(wheelType, function(event) { self.hub.handleBodyWheel(event, self.content); });
		this.panel.append(this.tabs).append(this.content);
		this.actions = el("div", "bv-detail-actions");
		this.primary = button("bv-detail-button bv-detail-primary", "", function() { self.primaryAction(); });
		this.leader = button("bv-detail-button bv-detail-leader", "", function() { self.performAction("setBattleValkyriesWorldLeader", self.messages().LeaderResultTitle); });
		this.skinItem = button("bv-detail-button bv-detail-skin-item", "", function() { self.performAction("grantBattleValkyrieSkinItem", self.messages().SkinItemResultTitle); });
		this.actions.append(this.primary).append(this.leader);

		this.skinDock = el("div", "bv-detail-skin-dock");
		this.preview = el("img", "bv-detail-preview");
		this.previewFrame = el("div", "bv-detail-preview-frame").append(this.preview);
		var skinInfo = el("div", "bv-detail-skin-info");
		var skinHeading = el("div", "bv-detail-skin-heading");
		skinHeading.append(el("div", "bv-detail-eyebrow", copy.skins)).append(this.skinItem);
		skinInfo.append(skinHeading);
		this.skinName = el("div", "bv-detail-current-skin-name");
		this.skinDescription = el("div", "bv-detail-skin-description").attr("tabindex", "0");
		skinInfo.append(this.skinName).append(this.skinDescription);
		this.skinDock.append(this.previewFrame).append(skinInfo);
		this.panel.append(this.skinDock).append(this.actions);
		this.root.append(this.panel);
		this.stageRail = el("div", "bv-detail-stage-rail").attr("aria-label", "$bv{olga.stage.track}").hide();
		this.stageState = el("div", "bv-detail-stage-state").attr("aria-live", "polite");
		this.stageButtons = el("div", "bv-detail-stage-buttons");
		this.stageRail.append(this.stageState).append(this.stageButtons);
		this.root.append(this.stageRail);

		this.storyReader = el("div", "bv-detail-story-reader").attr({ role: "dialog", "aria-modal": "true", "aria-label": copy.storyArchive }).hide();
		var readerBackdrop = el("div", "bv-detail-story-reader-backdrop");
		var readerPanel = el("div", "bv-detail-story-reader-panel");
		var readerHeader = el("div", "bv-detail-story-reader-header");
		this.storyReaderMeta = el("div", "bv-detail-eyebrow");
		this.storyReaderTitle = el("h2", "bv-detail-story-reader-title");
		this.storyClose = button("bv-detail-button bv-detail-story-reader-close", copy.storyClose, function() { self.closeStory(); });
		readerHeader.append(el("div", "bv-detail-story-reader-heading").append(this.storyReaderMeta).append(this.storyReaderTitle)).append(this.storyClose);
		this.storyReaderImage = el("img", "bv-detail-story-reader-image");
		this.storyReaderPage = el("div", "bv-detail-story-reader-page");
		this.storyReaderText = el("div", "bv-detail-story-reader-text").attr("tabindex", "0");
		this.storyReaderText.on(wheelType, function(event) { self.hub.handleBodyWheel(event, self.storyReaderText); });
		var readerBody = el("div", "bv-detail-story-reader-body");
		var readerCopy = el("div", "bv-detail-story-reader-copy").append(this.storyReaderPage).append(this.storyReaderText);
		readerBody.append(this.storyReaderImage).append(readerCopy);
		var readerFooter = el("div", "bv-detail-story-reader-actions");
		this.storyPrevious = button("bv-detail-button", copy.storyPrevious, function() { self.setStoryPage(0); });
		this.storyNext = button("bv-detail-button bv-detail-primary", copy.storyNext, function() { self.setStoryPage(1); });
		readerFooter.append(this.storyPrevious).append(this.storyNext);
		readerPanel.append(readerHeader).append(readerBody).append(readerFooter);
		this.storyReader.append(readerBackdrop).append(readerPanel);
		this.root.append(this.storyReader);

		this.huntRecordOverlay = el("div", "bv-detail-hunt-record-overlay").attr({ role: "dialog", "aria-modal": "true", "aria-label": copy.huntBreakdown }).hide();
		var huntRecordBackdrop = el("div", "bv-detail-hunt-record-backdrop").on("click", function() { self.closeHuntRecord(); });
		var huntRecordPanel = el("div", "bv-detail-hunt-record-panel");
		var huntRecordHeader = el("div", "bv-detail-hunt-record-header");
		this.huntRecordTitle = el("h2", "bv-detail-hunt-record-title", copy.huntBreakdown);
		this.huntRecordClose = button("bv-detail-button bv-detail-hunt-record-close", copy.huntRecordClose, function() { self.closeHuntRecord(); });
		huntRecordHeader.append(this.huntRecordTitle).append(this.huntRecordClose);
		this.huntRecordBody = el("div", "bv-detail-hunt-record-body").attr("tabindex", "0");
		huntRecordPanel.append(huntRecordHeader).append(this.huntRecordBody);
		this.huntRecordOverlay.append(huntRecordBackdrop).append(huntRecordPanel);
		this.root.append(this.huntRecordOverlay);

		this.huntSkillOverlay = el("div", "bv-detail-hunt-skill-overlay").attr({ role: "dialog", "aria-modal": "true" }).hide();
		var huntSkillBackdrop = el("div", "bv-detail-hunt-skill-backdrop").on("click", function() { self.closeHuntSkill(); });
		var huntSkillPanel = el("div", "bv-detail-hunt-skill-panel");
		var huntSkillHeader = el("div", "bv-detail-hunt-skill-header");
		this.huntSkillIcon = el("img", "bv-detail-hunt-skill-icon");
		var huntSkillHeading = el("div", "bv-detail-hunt-skill-heading");
		this.huntSkillMeta = el("div", "bv-detail-hunt-skill-meta");
		this.huntSkillTitle = el("h2", "bv-detail-hunt-skill-title");
		huntSkillHeading.append(this.huntSkillMeta).append(this.huntSkillTitle);
		this.huntSkillClose = button("bv-detail-button bv-detail-hunt-skill-close", copy.huntRecordClose, function() { self.closeHuntSkill(); });
		huntSkillHeader.append(this.huntSkillIcon).append(huntSkillHeading).append(this.huntSkillClose);
		this.huntSkillDescription = el("div", "bv-detail-hunt-skill-description");
		this.huntSkillEffects = el("div", "bv-detail-hunt-skill-effects").attr("tabindex", "0");
		huntSkillPanel.append(huntSkillHeader).append(this.huntSkillDescription).append(this.huntSkillEffects);
		this.huntSkillOverlay.append(huntSkillBackdrop).append(huntSkillPanel);
		this.root.append(this.huntSkillOverlay);

		this.researchPickerOverlay = el("div", "bv-detail-research-picker-overlay").attr({ role: "dialog", "aria-modal": "true", "aria-label": copy.researchPickerTitle }).hide();
		var researchPickerBackdrop = el("div", "bv-detail-research-picker-backdrop").on("click", function() { self.closeResearchPicker(); });
		this.researchPickerPanel = el("div", "bv-detail-research-picker-panel");
		var researchPickerHeader = el("div", "bv-detail-research-picker-header");
		var researchPickerHeading = el("div", "bv-detail-research-picker-heading");
		researchPickerHeading.append(el("div", "bv-detail-eyebrow", copy.researchPickerHint)).append(el("h2", "bv-detail-research-picker-title", copy.researchPickerTitle));
		this.researchPickerCount = el("div", "bv-detail-research-picker-count");
		this.researchPickerClose = button("bv-detail-button bv-detail-research-picker-close", copy.researchPickerClose, function() { self.closeResearchPicker(); });
		researchPickerHeader.append(researchPickerHeading).append(this.researchPickerCount).append(this.researchPickerClose);
		this.researchPickerBody = el("div", "bv-detail-research-picker-body");
		this.researchPickerPanel.append(researchPickerHeader).append(this.researchPickerBody);
		this.researchPickerOverlay.append(researchPickerBackdrop).append(this.researchPickerPanel);
		this.root.append(this.researchPickerOverlay);

		this.lilySpiritManagerOverlay = el("div", "bv-detail-spirit-manager-overlay").attr({ role: "dialog", "aria-modal": "true", "aria-label": copy.spiritsManage }).hide();
		var lilySpiritManagerBackdrop = el("div", "bv-detail-spirit-manager-backdrop").on("click", function() { self.closeLilySpiritManager(); });
		this.lilySpiritManagerPanel = el("div", "bv-detail-spirit-manager-panel");
		var lilySpiritManagerHeader = el("div", "bv-detail-spirit-manager-header");
		var lilySpiritManagerHeading = el("div", "bv-detail-spirit-manager-heading");
		lilySpiritManagerHeading.append(el("div", "bv-detail-eyebrow", copy.spiritsTitle)).append(el("h2", "bv-detail-spirit-manager-title", copy.spiritsManage)).append(el("div", "bv-detail-spirit-manager-hint", copy.spiritsManagerHint));
		this.lilySpiritManagerClose = button("bv-detail-button bv-detail-spirit-manager-close", copy.spiritsClose, function() { self.closeLilySpiritManager(); });
		lilySpiritManagerHeader.append(lilySpiritManagerHeading).append(this.lilySpiritManagerClose);
		this.lilySpiritManagerBody = el("div", "bv-detail-spirit-manager-body");
		this.lilySpiritManagerPanel.append(lilySpiritManagerHeader).append(this.lilySpiritManagerBody);
		this.lilySpiritManagerOverlay.append(lilySpiritManagerBackdrop).append(this.lilySpiritManagerPanel);
		this.root.append(this.lilySpiritManagerOverlay);
		this.hub.ensureDialog().addClass("has-fullscreen-detail").append(this.root);
		this.poster.on("load.bvDetail", function() { self.resizeMedia(); });
		this.resizeHandler = function() { self.resizeMedia(); };
		window.addEventListener("resize", this.resizeHandler);
		this.visibilityHandler = function()
		{
			if (!self.active) return;
			if (document.hidden) self.mediaPool.suspend(self);
			else self.mediaPool.resume(self);
		};
		document.addEventListener("visibilitychange", this.visibilityHandler);
		this.keyHandler = function(event) { self.handleKey(event); };
		document.addEventListener("keydown", this.keyHandler, true);
	};

	FullscreenDetail.prototype.messages = function()
	{
		return this.hub.mData && this.hub.mData.Messages ? this.hub.mData.Messages : this.hub.mFallbackData.Messages;
	};
	FullscreenDetail.prototype.refresh = function(slot)
	{
		if (this.disposed) return;
		this.closeHuntRecord(false);
		this.closeHuntSkill(false);
		this.closeResearchPicker(false);
		this.closeLilySpiritManager(false);
		this.slot = slot;
		var detail = slot.Detail;
		this.title.text(detail.Title || slot.Name);
		this.root.attr("aria-label", detail.Title || slot.Name);
		this.status.text(slot.Status || "");
		this.tabButtons.hunt.toggle(!!detail.GoblinHunt);
		this.tabButtons.research.toggle(!!detail.Research);

		this.tabButtons.spirits.toggle(!!detail.LilySpirits);
		this.tabButtons.workshop.toggle(!!detail.Workshop);
		if (detail.Workshop) { this.tabButtons.workshop.find(".bv-detail-tab-label").text(detail.Workshop.Title); this.tabMeta.workshop.text(detail.Workshop.Points + "/" + detail.Workshop.MaxPoints).show(); }
		else this.tabMeta.workshop.hide();
		this.tabButtons.bond.toggle(this.isTabAvailable("bond"));
		this.tabButtons.bond.find(".bv-detail-tab-label").text(narrativeCopy(detail, "bond"));
		this.tabButtons.story.toggle(this.isTabAvailable("story"));
		if (!this.isTabAvailable(this.tabID)) this.tabID = "profile";
		if (!detail.LilySpirits && this.tabID === "spirits") this.tabID = "profile";
		if (detail.LilySpirits)
		{
			this.tabMeta.spirits.text(detail.LilySpirits.Points + "/" + detail.LilySpirits.MaxPoints).show();
			if (!this.lilySpiritDraft)
			{
				this.lilySpiritDraft = detail.LilySpirits.Loadout.slice(0);
				this.lilySpiritSavedLoadout = detail.LilySpirits.Loadout.slice(0);
			}
		}
		else this.tabMeta.spirits.hide();
		if (!detail.Research && this.tabID === "research") this.tabID = "profile";
		if (detail.GoblinHunt)
		{
			this.tabMeta.hunt.text(detail.GoblinHunt.Points).show();
		}
		else
		{
			this.tabMeta.hunt.hide();
			if (this.tabID === "hunt") this.tabID = "profile";
		}
		if (detail.Bond)
		{
			this.tabMeta.bond.text(detail.Bond.Value + "/" + detail.Bond.Max).show();
			this.tabMeta.story.text(detail.Bond.UnlockedStoryCount).show();
			if (!this.bondStageValue) this.bondStageValue = detail.Bond.ActiveStageValue;
		}
		else
		{
			this.tabMeta.bond.hide();
			this.tabMeta.story.hide();
		}
		var self = this;
		var singleSkin = detail.Skins.length === 1;
		this.skinSelector.toggleClass("is-single", singleSkin);
		this.skinLabel.text(singleSkin ? copy.currentSkin : copy.skinSelect);
		this.skinTabs.empty();
		var selected = detail.Skins[0];
		for (var i = 0; i < detail.Skins.length; ++i)
		{
			(function(skin)
			{
				if (skin.ID === self.skinID) selected = skin;
				var name = skin.Name || skin.ID;
				var tab = singleSkin ? el("div", "bv-detail-skin-tab is-static") : button("bv-detail-skin-tab", "", function() { self.selectSkin(skin); });
				tab.attr({ "data-skin-id": skin.ID, title: name });
				if (!singleSkin) tab.attr("aria-label", name).on("keydown", function(event)
				{
					if (self.busy || (event.which !== 37 && event.which !== 39)) return;
					event.preventDefault();
					var index = $(this).index();
					var next = (index + (event.which === 39 ? 1 : detail.Skins.length - 1)) % detail.Skins.length;
					self.selectSkin(detail.Skins[next]);
					self.skinTabs.children().eq(next).focus();
				});
				var thumbnail = skin.SummonPortrait || skin.SkinPortrait;
				if (thumbnail)
				{
					var frame = el("span", "bv-detail-skin-thumb").attr("aria-hidden", "true");
					frame.append(el("img", "").attr({ src: Path.GFX + thumbnail, alt: "" }).one("error", function() { frame.hide(); }));
					tab.append(frame);
				}
				tab.append(el("span", "bv-detail-skin-choice-name", name));
				self.skinTabs.append(tab);
			})(detail.Skins[i]);
		}
		this.renderStageRail();
		this.selectSkin(selected);
		this.selectTab(this.tabID, true);
	};
	FullscreenDetail.prototype.renderStageRail = function()
	{
		var data = this.slot.Detail.StagePresentation, self = this;
		this.stageRail.toggle(!!data);
		this.root.toggleClass("has-stage-rail", !!data);
		if (!data) { this.previewStage = null; this.actualStage = null; return; }
		if (this.actualStage !== data.ActualStage || this.previewStage === null || !data.StageViews[this.previewStage] || data.StageViews[this.previewStage].Locked)
			this.previewStage = data.ActualStage;
		this.actualStage = data.ActualStage;
		var view = data.StageViews[this.previewStage];
		this.stageState.text("$bv{olga.stage.actual}" + data.StageViews[data.ActualStage].Name + (this.previewStage === data.ActualStage ? "" : " / $bv{olga.stage.preview}" + view.Name));
		this.stageRail.attr("title", view.Description || "");
		this.stageButtons.empty();
		for (var i = 0; i < data.StageViews.length; ++i)
		{
			(function(entry)
			{
				var choice = button("bv-detail-button bv-detail-stage-choice", entry.Name, function() { self.selectStage(entry.Stage); });
				choice.attr({ "data-stage": entry.Stage, "aria-pressed": entry.Stage === self.previewStage ? "true" : "false", title: entry.Locked ? entry.UnlockHint : entry.Description });
				choice.toggleClass("is-selected", entry.Stage === self.previewStage);
				disabled(choice, entry.Locked);
				self.stageButtons.append(choice);
			})(data.StageViews[i]);
		}
		var back = button("bv-detail-button bv-detail-stage-return", "$bv{olga.stage.return}", function() { self.selectStage(self.slot.Detail.StagePresentation.ActualStage); });
		disabled(back, this.previewStage === data.ActualStage);
		this.stageButtons.append(back);
	};
	FullscreenDetail.prototype.selectStage = function(value)
	{
		var data = this.slot.Detail.StagePresentation;
		if (this.disposed || this.busy || !data || typeof value !== "number" || value % 1 !== 0 || value < 0 || value > data.ActualStage) return;
		var view = data.StageViews[value];
		if (!view || view.Locked || !view.DetailMedia) return;
		this.previewStage = value;
		this.renderStageRail();
		this.stageButtons.children().eq(value)[0].focus();
		if (this.active) this.setMedia(this.skin);
	};
	FullscreenDetail.prototype.selectSkin = function(skin)
	{
		if (this.disposed || this.busy) return;
		this.skin = skin;
		this.skinID = skin.ID;
		var rail = this.skinTabs[0];
		this.skinTabs.children().each(function()
		{
			var selected = $(this).attr("data-skin-id") === skin.ID;
			$(this).toggleClass("is-selected", selected);
			if (this.tagName === "BUTTON") $(this).attr("aria-pressed", selected ? "true" : "false");
			// Keep an initially selected/off-screen skin visible without scrolling the dossier.
			if (selected && rail.clientWidth > 0)
			{
				if (this.offsetLeft < rail.scrollLeft) rail.scrollLeft = this.offsetLeft;
				else if (this.offsetLeft + this.offsetWidth > rail.scrollLeft + rail.clientWidth) rail.scrollLeft = this.offsetLeft + this.offsetWidth - rail.clientWidth;
			}
		});
		this.preview.attr({ src: Path.GFX + skin.SkinPortrait, alt: this.slot.Detail.Labels.SkinPortrait || skin.Name });
		this.preview.toggle(!!skin.SkinPortrait);
		this.previewFrame.toggle(!!skin.SkinPortrait);
		this.skinName.text(skin.Name || skin.ID).attr("title", skin.Name || skin.ID);
		this.skinDescription.text(skin.Description || "");
		this.updateActions();
		if (this.active) this.setMedia(skin);
	};
	FullscreenDetail.prototype.isTabAvailable = function(id)
	{
		var detail = this.slot.Detail;
		if (id === "profile") return true;
		if (id === "workshop") return !!detail.Workshop;
		if (id === "alchemy") return false;
		if (id === "spirits") return !!detail.LilySpirits;
		if (id === "hunt") return !!detail.GoblinHunt;
		if (id === "research") return !!detail.Research;
		// Recruitment affects access, not whether authored narrative content exists.
		if (id === "bond") return !!detail.Bond && detail.Bond.Stages.length > 0;
		if (id === "story") return !!detail.Stories && detail.Stories.length > 0;
		return false;
	};
	FullscreenDetail.prototype.selectTab = function(id, preserveScroll)
	{
		if (!this.isTabAvailable(id)) id = "profile";
		this.closeHuntRecord(false);
		this.closeHuntSkill(false);
		this.closeResearchPicker(false);
		this.closeLilySpiritManager(false);
		var scroll = preserveScroll ? this.content.scrollTop() : 0;
		this.tabID = id;
		for (var key in this.tabButtons)
		{
			var selected = key === id;
			this.tabButtons[key].toggleClass("is-selected", selected).attr({ "aria-selected": selected ? "true" : "false", tabindex: selected ? "0" : "-1" });
		}
		this.content.empty().attr("aria-labelledby", namespace + "-detail-tab-" + id);

		if (id === "hunt") this.renderHunt();
		else if (id === "workshop") this.renderFiveWorkshop();

		else if (id === "spirits") this.renderLilySpirits();
		else if (id === "bond") this.renderBond();
		else if (id === "story") this.renderStories();
		else if (id === "research") this.renderResearch();
		else this.renderProfile();
		this.content.scrollTop(scroll);
	};


	FullscreenDetail.prototype.openRyzaWorkshop = function()
 { if(!this.slot.Detail.Alchemy)return; if(this.ryzaWorkshop)this.ryzaWorkshop.close(); this.ryzaWorkshop=new window[namespace+"RyzaWorkshop"](this); };
	FullscreenDetail.prototype.renderFiveWorkshop = function()
	{
		var self = this, data = this.slot.Detail.Workshop;
		if (!data) return;
		if (!this.fiveDraft || this.fiveDraftID !== data.ValkyrieID) { this.fiveDraftID = data.ValkyrieID; this.fiveDraft = data.Loadout.slice(0); }
		this.content.empty();
		var panel = el("div", "bv-five-workshop" + (data.ValkyrieID === "tokisaki_kurumi" ? " is-clock" : ""));
		panel.append(el("h2", "bv-detail-section-title", data.Title)).append(el("p", "bv-five-description", data.Description));
		panel.append(el("div", "bv-five-progress", "$bv{five.progress}" + " " + data.Points + " / " + data.MaxPoints));
		var slots = el("div", "bv-five-slots").attr("aria-label", "$bv{five.slots}");
		for (var i = 0; i < data.Slots; i++) (function(index) {
			var key = self.fiveDraft[index], option = null;
			for (var j = 0; j < data.Options.length; j++) if (data.Options[j].Key === key) option = data.Options[j];
			var slot = button("bv-five-slot", "", function() { self.fiveDraft.splice(index, 1); self.renderFiveWorkshop(); });
			if (option) slot.append(el("img", "").attr({src:Path.GFX + option.Icon,alt:""}));
			slot.append(el("span", "", option ? option.Name : String(index + 1)));
			disabled(slot, self.busy || !data.Editable || !option); slots.append(slot);
		})(i);
		panel.append(slots);
		var options = el("div", "bv-five-options");
		for (var n = 0; n < data.Options.length; n++) (function(option) {
			var equipped = self.fiveDraft.indexOf(option.Key) >= 0;
			var card = button("bv-five-option" + (equipped ? " is-equipped" : "") + (!option.Unlocked ? " is-locked" : ""), "", function() {
				var index = self.fiveDraft.indexOf(option.Key);
				if (index >= 0) self.fiveDraft.splice(index, 1); else if (self.fiveDraft.length < data.Slots) self.fiveDraft.push(option.Key);
				self.renderFiveWorkshop();
			});
			card.attr({"aria-pressed":equipped ? "true" : "false", title:option.Description});
			card.append(el("img", "").attr({src:Path.GFX + option.Icon,alt:""})).append(el("strong", "", option.Name));
			card.append(el("span", "bv-five-option-description", option.Description));
			card.append(el("span", "bv-five-option-status", option.Unlocked ? (equipped ? "$bv{five.selected}" : "") : "$bv{five.locked_option}" + option.Unlock));
			disabled(card, self.busy || !data.Editable || !option.Unlocked || (!equipped && self.fiveDraft.length >= data.Slots)); options.append(card);
		})(data.Options[n]);
		panel.append(options);
		var actions = el("div", "bv-five-actions");
		var reset = button("bv-detail-button", "$bv{five.reset}", function() { self.fiveDraft = data.Loadout.slice(0); self.renderFiveWorkshop(); });
		var save = button("bv-detail-button", "$bv{five.save}", function() { self.saveFiveWorkshop(); });
		var dirty = this.fiveDraft.join("|") !== data.Loadout.join("|");
		disabled(reset, this.busy || !data.Editable || !dirty); disabled(save, this.busy || !data.Editable || !dirty || this.fiveDraft.length !== data.Slots);
		actions.append(reset).append(save);panel.append(actions);
		if (!data.Editable) panel.append(el("p", "bv-detail-spirit-warning", "$bv{five.locked}"));
		this.content.append(panel);
	};
	FullscreenDetail.prototype.saveFiveWorkshop = function()
	{
		var self = this, hub = this.hub, data = this.slot.Detail.Workshop;
		if (this.busy || !data || !data.Editable || this.fiveDraft.length !== data.Slots || hub.mBackendHandle === null || hub.mBackendHandle === undefined) return;
		this.busy = true; this.renderFiveWorkshop();
		try {
			SQ.call(hub.mBackendHandle, "saveFiveValkyrieLoadout", {ValkyrieID:data.ValkyrieID,Loadout:this.fiveDraft.slice(0)}, function(result) {
				if (self.disposed) return;
				self.busy = false;
				if (!self.slot || self.slot.ID !== data.ValkyrieID) return;
				if (result && result.Success === true && result.Workshop) { self.slot.Detail.Workshop = result.Workshop; self.fiveDraft = result.Workshop.Loadout.slice(0); }
				if (self.tabID === "workshop") self.renderFiveWorkshop();
				hub.showMessage(result && result.Message ? result.Message : copy.failed, data.Title);
			});
		} catch (error) { this.busy = false; this.renderFiveWorkshop(); hub.showMessage(copy.failed, data.Title); }
	};

	FullscreenDetail.prototype.findLilySpirit = function(key)
	{
		var data = this.slot.Detail.LilySpirits;
		if (!data) return null;
		for (var i = 0; i < data.Spirits.length; ++i) if (data.Spirits[i].Key === key) return data.Spirits[i];
		return null;
	};
	FullscreenDetail.prototype.isLilySpiritDraftDirty = function()
	{
		if (!this.lilySpiritDraft || !this.lilySpiritSavedLoadout) return false;
		return this.lilySpiritDraft.join("|") !== this.lilySpiritSavedLoadout.join("|");
	};
	FullscreenDetail.prototype.toggleLilySpirit = function(key)
	{
		var data = this.slot.Detail.LilySpirits;
		var spirit = this.findLilySpirit(key);
		if (!data || !data.Editable || !spirit || !spirit.Unlocked) return;
		var index = this.lilySpiritDraft.indexOf(key);
		if (index >= 0) this.lilySpiritDraft.splice(index, 1);
		else if (this.lilySpiritDraft.length < 6) this.lilySpiritDraft.push(key);
		this.lilySpiritInspectKey = key;
		this.renderLilySpiritManager();
	};
	FullscreenDetail.prototype.resetLilySpiritLoadout = function()
	{
		if (!this.lilySpiritSavedLoadout) return;
		this.lilySpiritDraft = this.lilySpiritSavedLoadout.slice(0);
		this.renderLilySpiritManager();
	};
	FullscreenDetail.prototype.ensureLilySpiritDraft = function()
	{
		var data = this.slot.Detail.LilySpirits;
		if (!data || this.lilySpiritDraft) return;
		this.lilySpiritDraft = data.Loadout.slice(0);
		this.lilySpiritSavedLoadout = data.Loadout.slice(0);
	};
	FullscreenDetail.prototype.buildLilySpiritLoadout = function(interactive)
	{
		var self = this, data = this.slot.Detail.LilySpirits;
		var loadout = el("div", "bv-detail-spirit-loadout" + (interactive ? " is-editable" : " is-overview"));
		for (var slotIndex = 0; slotIndex < 6; ++slotIndex)
		{
			(function(index)
			{
				var key = self.lilySpiritDraft[index], spirit = key ? self.findLilySpirit(key) : null;
				var slot = el("div", "bv-detail-spirit-slot" + (spirit ? " is-filled" : " is-empty"));
				slot.append(el("span", "bv-detail-spirit-slot-index", String(index + 1)));
				if (!spirit) slot.append(el("span", "bv-detail-spirit-slot-empty", copy.spiritsEmpty));
				else
				{
					var select = button("bv-detail-spirit-slot-select", "", function()
					{
						self.lilySpiritInspectKey = spirit.Key;
						if (interactive) self.renderLilySpiritManager();
						else self.openLilySpiritManager(select, spirit.Key);
					});
					select.attr("title", (interactive ? copy.spiritsInspect : copy.spiritsManage) + " / " + spirit.Name);
					select.append(el("img", "bv-detail-spirit-slot-icon").attr({ src: Path.GFX + spirit.Icon, alt: "" }));
					select.append(el("span", "bv-detail-spirit-slot-copy").append(el("span", "bv-detail-spirit-slot-name", spirit.Name)).append(el("small", "", spirit.Type === "main" ? copy.spiritsMainLabel : copy.spiritsSubLabel)));
					slot.append(select);
					if (interactive)
					{
						var controls = el("span", "bv-detail-spirit-slot-controls");
						var left = button("bv-detail-spirit-mini", "‹", function() { if (index > 0) { var value = self.lilySpiritDraft[index - 1]; self.lilySpiritDraft[index - 1] = self.lilySpiritDraft[index]; self.lilySpiritDraft[index] = value; self.renderLilySpiritManager(); } });
						var right = button("bv-detail-spirit-mini", "›", function() { if (index < self.lilySpiritDraft.length - 1) { var value = self.lilySpiritDraft[index + 1]; self.lilySpiritDraft[index + 1] = self.lilySpiritDraft[index]; self.lilySpiritDraft[index] = value; self.renderLilySpiritManager(); } });
						var remove = button("bv-detail-spirit-mini is-remove", "×", function() { self.lilySpiritDraft.splice(index, 1); self.renderLilySpiritManager(); });
						left.attr("title", copy.spiritsMoveLeft); right.attr("title", copy.spiritsMoveRight); remove.attr("title", copy.spiritsRemove);
						disabled(left, !data.Editable || index === 0); disabled(right, !data.Editable || index === self.lilySpiritDraft.length - 1); disabled(remove, !data.Editable);
						controls.append(left).append(right).append(remove); slot.append(controls);
					}
				}
				loadout.append(slot);
			})(slotIndex);
		}
		return loadout;
	};
	FullscreenDetail.prototype.renderLilySpirits = function()
	{
		var self = this, data = this.slot.Detail.LilySpirits;
		if (!data) return;
		this.ensureLilySpiritDraft();
		var summary = el("div", "bv-detail-spirit-summary");
		summary.append(el("div", "bv-detail-spirit-score").append(el("div", "bv-detail-eyebrow", copy.spiritsPoints)).append(el("strong", "", data.Points + (data.PendingPoints ? "  +" + data.PendingPoints + " " + copy.spiritsPending : ""))));
		var nextText = data.Next ? copy.spiritsNext + " / " + data.Next.Name + " / " + data.Next.Remaining : copy.spiritsComplete;
		summary.append(el("div", "bv-detail-spirit-next", nextText));
		this.content.append(el("div", "bv-detail-spirit-heading").append(el("div", "bv-detail-eyebrow", copy.spiritsTitle))).append(summary);
		var progress = el("div", "bv-detail-spirit-progress").append(el("div", "bv-detail-spirit-progress-value").css("width", Math.max(0, Math.min(100, data.Points / data.MaxPoints * 100)) + "%"));
		this.content.append(progress).append(el("div", "bv-detail-spirit-label", copy.spiritsLoadout)).append(this.buildLilySpiritLoadout(false));
		if (this.lilySpiritDraft.length < 6) this.content.append(el("div", "bv-detail-spirit-warning", copy.spiritsEmptyWarning));
		var dirty = this.isLilySpiritDraftDirty(), state = data.Editable ? (dirty ? copy.spiritsUnsaved : copy.spiritsSavedState) : copy.spiritsReadOnly;
		var manage = button("bv-detail-button bv-detail-primary bv-detail-spirit-manage", copy.spiritsManage, function() { self.openLilySpiritManager(manage); });
		manage.attr({ "aria-haspopup": "dialog", "aria-expanded": "false" });
		this.content.append(el("div", "bv-detail-spirit-overview-actions" + (dirty ? " is-dirty" : "")).append(el("span", "bv-detail-spirit-save-state", state)).append(manage));
	};
	FullscreenDetail.prototype.openLilySpiritManager = function(trigger, inspectKey)
	{
		if (!this.slot.Detail.LilySpirits || this.disposed) return;
		this.ensureLilySpiritDraft();
		if (inspectKey) this.lilySpiritInspectKey = inspectKey;
		this.lilySpiritManagerOpen = true;
		this.lilySpiritManagerTrigger = trigger && trigger[0] ? trigger[0] : document.activeElement;
		if (trigger && trigger.attr) trigger.attr("aria-expanded", "true");
		this.renderLilySpiritManager();
		this.lilySpiritManagerOverlay.addClass("is-visible").show();
		this.lilySpiritManagerClose[0].focus();
	};
	FullscreenDetail.prototype.closeLilySpiritManager = function(restoreFocus)
	{
		if (!this.lilySpiritManagerOpen) return;
		this.lilySpiritManagerOpen = false;
		this.lilySpiritManagerOverlay.removeClass("is-visible").hide();
		if (this.tabID === "spirits") { this.content.empty(); this.renderLilySpirits(); }
		if (restoreFocus !== false && this.lilySpiritManagerTrigger && document.documentElement.contains(this.lilySpiritManagerTrigger)) this.lilySpiritManagerTrigger.focus();
		this.lilySpiritManagerTrigger = null;
	};
	FullscreenDetail.prototype.renderLilySpiritManager = function()
	{
		if (!this.lilySpiritManagerOpen || !this.lilySpiritManagerBody) return;
		var self = this, data = this.slot.Detail.LilySpirits;
		this.ensureLilySpiritDraft();
		this.lilySpiritManagerBody.empty().append(el("div", "bv-detail-spirit-label", copy.spiritsLoadout)).append(this.buildLilySpiritLoadout(true));
		if (this.lilySpiritDraft.length < 6) this.lilySpiritManagerBody.append(el("div", "bv-detail-spirit-warning", copy.spiritsEmptyWarning));
		var toolbar = el("div", "bv-detail-spirit-toolbar").append(el("div", "bv-detail-spirit-label", copy.spiritsCollection));
		var filters = el("div", "bv-detail-spirit-filters");
		[["all", copy.spiritsAll], ["main", copy.spiritsMain], ["sub", copy.spiritsSub]].forEach(function(entry)
		{
			var filter = button("bv-detail-spirit-filter" + (self.lilySpiritFilter === entry[0] ? " is-selected" : ""), entry[1], function() { self.lilySpiritFilter = entry[0]; self.renderLilySpiritManager(); });
			filters.append(filter);
		});
		toolbar.append(filters);
		var workspace = el("div", "bv-detail-spirit-manager-workspace"), collection = el("div", "bv-detail-spirit-manager-collection"), grid = el("div", "bv-detail-spirit-grid"), inspector = el("div", "bv-detail-spirit-inspector");
		var inspected = this.findLilySpirit(this.lilySpiritInspectKey) || data.Spirits[0];
		for (var i = 0; i < data.Spirits.length; ++i)
		{
			(function(spirit)
			{
				if (self.lilySpiritFilter !== "all" && spirit.Type !== self.lilySpiritFilter) return;
				var equipped = self.lilySpiritDraft.indexOf(spirit.Key) >= 0, selected = inspected && inspected.Key === spirit.Key;
				var card = button("bv-detail-spirit-card" + (spirit.Unlocked ? " is-unlocked" : " is-locked") + (equipped ? " is-equipped" : "") + (selected ? " is-selected" : ""), "", function() { self.lilySpiritInspectKey = spirit.Key; self.renderLilySpiritManager(); });
				card.attr({ title: copy.spiritsInspect + " / " + spirit.Description, "aria-pressed": selected ? "true" : "false" });
				card.append(el("img", "bv-detail-spirit-card-icon").attr({ src: Path.GFX + spirit.Icon, alt: "" }));
				card.append(el("span", "bv-detail-spirit-card-copy").append(el("strong", "", spirit.Name)).append(el("small", "", spirit.Type === "main" ? copy.spiritsMainLabel : copy.spiritsSubLabel)));
				card.append(el("span", "bv-detail-spirit-card-state", spirit.Unlocked ? (equipped ? copy.spiritsEquipped : copy.spiritsInspect) : (copy.spiritsLocked + " " + spirit.Unlock)));
				grid.append(card);
			})(data.Spirits[i]);
		}
		this.updateLilySpiritInspector(inspector, inspected);
		collection.append(toolbar).append(grid); workspace.append(collection).append(inspector); this.lilySpiritManagerBody.append(workspace);
		var dirty = this.isLilySpiritDraftDirty(), state = data.Editable ? (dirty ? copy.spiritsUnsaved : copy.spiritsSavedState) : copy.spiritsReadOnly;
		var footer = el("div", "bv-detail-spirit-footer" + (dirty ? " is-dirty" : ""));
		var reset = button("bv-detail-button bv-detail-spirit-reset", copy.spiritsReset, function() { self.resetLilySpiritLoadout(); }); disabled(reset, this.busy || !data.Editable || !dirty);
		var save = button("bv-detail-button bv-detail-primary bv-detail-spirit-save", copy.spiritsSave, function() { self.saveLilySpiritLoadout(); }); disabled(save, this.busy || !data.Editable || !dirty);
		footer.append(el("span", "bv-detail-spirit-save-state", state)).append(reset).append(save); this.lilySpiritManagerBody.append(footer);
	};
	FullscreenDetail.prototype.updateLilySpiritInspector = function(panel, spirit)
	{
		if (!panel || !spirit) return; panel.empty();
		var self=this,data=this.slot.Detail.LilySpirits,equipped=this.lilySpiritDraft.indexOf(spirit.Key)>=0,full=this.lilySpiritDraft.length>=6;
		panel.append(el("div","bv-detail-spirit-inspector-head").append(el("img","bv-detail-spirit-inspector-icon").attr({src:Path.GFX+spirit.Icon,alt:""})).append(el("div","").append(el("div","bv-detail-eyebrow",spirit.Type==="main"?copy.spiritsMainLabel:copy.spiritsSubLabel)).append(el("h3","",spirit.Name))));
		panel.append(el("div","bv-detail-spirit-inspector-stats",copy.spiritsCost+" "+spirit.AP+" AP / "+spirit.Fatigue+" / "+copy.spiritsRange+" "+spirit.MinRange+"–"+spirit.MaxRange));
		panel.append(el("div","bv-detail-spirit-inspector-description",spirit.Description));
		var actionText=!spirit.Unlocked?copy.spiritsLocked+" "+spirit.Unlock:(equipped?copy.spiritsRemove:(full?copy.spiritsFull:copy.spiritsEquip));
		var action=button("bv-detail-button bv-detail-spirit-inspector-action"+(equipped?" is-remove":""),actionText,function(){self.toggleLilySpirit(spirit.Key);});
		disabled(action,!data.Editable||!spirit.Unlocked||(!equipped&&full));panel.append(action);
	};
	FullscreenDetail.prototype.renderLilySpiritsIntoCurrentTab = function(){if(this.tabID!=="spirits")return;this.content.empty();this.renderLilySpirits();};
	FullscreenDetail.prototype.saveLilySpiritLoadout = function()
	{
		if (this.busy || !this.isLilySpiritDraftDirty() || this.hub.mBackendHandle === null || this.hub.mBackendHandle === undefined) return;
		var self = this, hub = this.hub, submitted = this.lilySpiritDraft.slice(0);
		this.busy = true;
		this.renderLilySpiritManager();
		try
		{
			SQ.call(hub.mBackendHandle, "saveLilySpiritLoadout", { Loadout: submitted }, function(result)
			{
				hub.loadData(hub.mBackendHandle, function(data)
				{
					if (self.disposed) return;
					self.busy = false;
					if (!result || result.Success !== false)
					{
						self.lilySpiritDraft = submitted.slice(0);
						self.lilySpiritSavedLoadout = submitted.slice(0);
					}
					hub.applyData(data);
					if (self.disposed) return;
					hub.showMessage(result && result.Message ? result.Message : copy.failed, copy.spiritsTitle);
				});
			});
		}
		catch (error)
		{
			this.busy = false;
			this.renderLilySpiritManager();
			hub.showMessage(copy.failed, copy.spiritsTitle);
		}
	};

	FullscreenDetail.prototype.renderResearch = function()
	{
		var self = this;
		var research = this.slot.Detail.Research;
		if (!research) return;
		var heading = el("div", "bv-detail-research-heading");
		heading.append(el("div", "bv-detail-research-heading-copy").append(el("div", "bv-detail-eyebrow", copy.researchTitle)).append(el("div", "bv-detail-research-description", copy.researchDescription)));
		this.content.append(heading);
		if (research.Owned === false)
		{
			this.content.append(el("div", "bv-detail-empty-state bv-detail-research-locked").append(el("div", "bv-detail-empty-symbol", "◇")).append(el("h2", "bv-detail-empty-title", copy.research)).append(el("div", "bv-detail-empty-description", copy.researchRequiresSummon)));
			return;
		}
		if (!research.EquipmentEnabled)
		{
			this.content.append(el("div", "bv-detail-empty-state bv-detail-research-locked").append(el("div", "bv-detail-empty-symbol", "◇")).append(el("h2", "bv-detail-empty-title", copy.research)).append(el("div", "bv-detail-empty-description", copy.researchUnavailable)));
			return;
		}
		var quotas = el("div", "bv-detail-research-quotas");
		function quotaCard(id, label)
		{
			var quota = research.Quotas && research.Quotas[id];
			if (!quota) return;
			var status = quota.Charges >= quota.Max ? copy.researchQuotaReady : copy.researchQuotaDays.replace("{days}", quota.DaysRemaining);
			quotas.append(el("div", "bv-detail-research-quota").append(el("span", "", label)).append(el("strong", "", quota.Charges + " / " + quota.Max)).append(el("small", "", status)));
		}
		quotaCard("purple_to_red", copy.researchQuotaPurple);
		quotaCard("red_to_prismatic", copy.researchQuotaPrismatic);
		heading.append(quotas);
		if (!research.Available)
		{
			this.content.append(el("div", "bv-detail-research-empty", copy.researchUnavailable));
			return;
		}
		if (!research.Items || !research.Items.length)
		{
			this.content.append(el("div", "bv-detail-research-empty", copy.researchEmpty));
			return;
		}
		var selected = this.findResearchItem(this.researchItemID);
		var sample = button("bv-detail-research-sample" + (selected ? " is-filled is-rarity-" + selected.Rarity : " is-empty"), "", function() { self.openResearchPicker(sample); });
		sample.attr({ "aria-haspopup": "dialog", "aria-expanded": "false" });
		if (selected)
		{
			var sampleIcon = el("span", "bv-detail-research-sample-icon");
			if (selected.Icon) sampleIcon.append(el("img", "").attr({ src: Path.ITEMS + selected.Icon, alt: "" }));
			var sampleCopy = el("span", "bv-detail-research-sample-copy");
			sampleCopy.append(el("small", "", copy.researchSelectedSample)).append(el("strong", "", selected.Name)).append(el("span", "", selected.RarityName + " / " + selected.PartName));
			var sampleRoute = el("span", "bv-detail-research-sample-route").append(el("span", "", selected.RarityName)).append(el("b", "", "→")).append(el("strong", "", selected.Research.NextRarityName).css("color", selected.Research.NextRarityColor));
			sample.append(sampleIcon).append(sampleCopy).append(sampleRoute).append(el("span", "bv-detail-research-sample-action", copy.researchChangeSample));
		}
		else
		{
			sample.append(el("span", "bv-detail-research-sample-empty-symbol", "+")).append(el("span", "bv-detail-research-sample-copy").append(el("small", "", copy.researchSelectedSample)).append(el("strong", "", copy.researchChooseSample)).append(el("span", "", copy.researchPickerHint))).append(el("span", "bv-detail-research-sample-action", copy.researchChooseSample));
		}
		this.content.append(sample);
		if (!selected) return;
		var workspace = el("div", "bv-detail-research-workspace");
		var affixPanel = el("div", "bv-detail-research-affixes").append(el("div", "bv-detail-research-label", copy.researchAffixes));
		if (!selected.Affixes.length) affixPanel.append(el("div", "bv-detail-research-empty", copy.researchNoAffixes));
		for (var i = 0; i < selected.Affixes.length; ++i)
		{
			var affix = selected.Affixes[i];
			affixPanel.append(el("div", "bv-detail-research-affix").css("border-left-color", affix.Color).append(el("strong", "", affix.Name)).append(el("span", "", affix.EffectText || affix.Value)));
		}
		var plan = el("div", "bv-detail-research-plan");
		plan.append(el("div", "bv-detail-research-plan-heading").append(el("span", "bv-detail-research-label", copy.researchTarget)).append(el("div", "bv-detail-research-target").append(el("span", "", selected.RarityName)).append(el("b", "", "→")).append(el("strong", "", selected.Research.NextRarityName).css("color", selected.Research.NextRarityColor))));
		var materialCount = 0;
		for (var materialIndex = 0; materialIndex < research.Materials.length; ++materialIndex) if (research.Materials[materialIndex].ID === selected.Research.MaterialTier) materialCount = research.Materials[materialIndex].Count;
		var costs = el("div", "bv-detail-research-costs");
		var materialCost = el("div", "bv-detail-research-cost-chip" + (materialCount < selected.Research.MaterialCost ? " is-missing" : ""));
		if (selected.Research.MaterialIcon) materialCost.append(el("img", "").attr({ src: Path.ITEMS + selected.Research.MaterialIcon, alt: "" }));
		materialCost.append(el("span", "", selected.Research.MaterialName)).append(el("strong", "", materialCount + " / " + selected.Research.MaterialCost));
		var moneyCost = el("div", "bv-detail-research-cost-chip" + (research.Money < selected.Research.MoneyCost ? " is-missing" : ""));
		moneyCost.append(el("span", "", copy.researchMoney)).append(el("strong", "", research.Money + " / " + selected.Research.MoneyCost));
		costs.append(materialCost).append(moneyCost);
		plan.append(el("div", "bv-detail-research-cost-label", copy.researchCost)).append(costs);
		var modes = el("div", "bv-detail-research-modes");
		function modeButton(id, title, description)
		{
			var choice = button("bv-detail-research-mode" + (self.researchMode === id ? " is-selected" : ""), "", function(){ self.researchMode=id; self.renderResearchIntoCurrentTab(); });
			choice.append(el("strong", "", title)).append(el("span", "", description)); modes.append(choice);
		}
		modeButton("retain", copy.researchRetain, copy.researchRetainDescription);
		modeButton("reroll", copy.researchReroll, copy.researchRerollDescription);
		plan.append(modes);
		var quota = selected.Research.Quota && research.Quotas ? research.Quotas[selected.Research.Quota] : null;
		var canQuota = !quota || quota.Charges > 0;
		var canAfford = materialCount >= selected.Research.MaterialCost && research.Money >= selected.Research.MoneyCost;
		var readiness = !canQuota ? copy.researchNeedQuota : (materialCount < selected.Research.MaterialCost ? copy.researchNeedMaterials : (research.Money < selected.Research.MoneyCost ? copy.researchNeedMoney : copy.researchReady));
		var upgrade = button("bv-detail-button bv-detail-primary bv-detail-research-upgrade", copy.researchUpgrade, function(){ self.confirmResearchUpgrade(selected); });
		disabled(upgrade, this.busy || selected.Locked || !canQuota || !canAfford);
		plan.append(el("div", "bv-detail-research-action-row").append(el("span", "bv-detail-research-readiness" + (canQuota && canAfford ? " is-ready" : ""), readiness)).append(upgrade));
		workspace.append(affixPanel).append(plan);
		this.content.append(workspace);
	};

	FullscreenDetail.prototype.findResearchItem = function(instanceID)
	{
		var research = this.slot && this.slot.Detail ? this.slot.Detail.Research : null;
		if (!research || !research.Items || !instanceID) return null;
		for (var i = 0; i < research.Items.length; ++i) if (research.Items[i].InstanceID === instanceID) return research.Items[i];
		return null;
	};

	FullscreenDetail.prototype.getFilteredResearchItems = function()
	{
		var research = this.slot && this.slot.Detail ? this.slot.Detail.Research : null;
		var result = [];
		if (!research || !research.Items) return result;
		for (var i = 0; i < research.Items.length; ++i)
		{
			var item = research.Items[i];
			if (this.researchPartFilter !== "all" && item.Part !== this.researchPartFilter) continue;
			if (this.researchRarityFilter !== "all" && item.Rarity !== this.researchRarityFilter) continue;
			result.push(item);
		}
		return result;
	};

	FullscreenDetail.prototype.openResearchPicker = function(trigger)
	{
		var research = this.slot && this.slot.Detail ? this.slot.Detail.Research : null;
		if (this.disposed || !research || !research.Available || !research.Items || !research.Items.length) return;
		this.researchPickerOpen = true;
		this.researchPickerTrigger = trigger || null;
		this.researchInspectID = this.findResearchItem(this.researchItemID) ? this.researchItemID : research.Items[0].InstanceID;
		if (this.researchPickerTrigger) this.researchPickerTrigger.attr("aria-expanded", "true");
		this.renderResearchPicker();
		this.researchPickerOverlay.show().addClass("is-visible");
		this.researchPickerClose[0].focus();
	};

	FullscreenDetail.prototype.closeResearchPicker = function(restoreFocus)
	{
		if (!this.researchPickerOpen) return;
		this.researchPickerOpen = false;
		this.researchPickerOverlay.removeClass("is-visible").hide();
		if (this.researchPickerTrigger) this.researchPickerTrigger.attr("aria-expanded", "false");
		if (restoreFocus !== false && this.researchPickerTrigger) this.researchPickerTrigger[0].focus();
		this.researchPickerTrigger = null;
	};

	FullscreenDetail.prototype.renderResearchPicker = function()
	{
		if (!this.researchPickerOpen) return;
		var self = this;
		var research = this.slot.Detail.Research;
		var filtered = this.getFilteredResearchItems();
		var inspected = null;
		for (var inspectedIndex = 0; inspectedIndex < filtered.length; ++inspectedIndex)
		{
			if (filtered[inspectedIndex].InstanceID === this.researchInspectID) { inspected = filtered[inspectedIndex]; break; }
		}
		if (!inspected && filtered.length) { inspected = filtered[0]; this.researchInspectID = inspected.InstanceID; }
		this.researchPickerCount.text(copy.researchPickerCount.replace("{shown}", filtered.length).replace("{total}", research.Items.length));
		this.researchPickerBody.empty();
		var inventory = el("div", "bv-detail-research-picker-inventory");
		var filterStack = el("div", "bv-detail-research-picker-filters");
		var partRow = el("div", "bv-detail-research-filter-row");
		var partFilters = [{ ID: "all", Label: copy.researchFilterAll }, { ID: "weapon", Label: copy.researchFilterWeapon }, { ID: "helmet", Label: copy.researchFilterHelmet }, { ID: "armor", Label: copy.researchFilterArmor }, { ID: "shield", Label: copy.researchFilterShield }];
		for (var p = 0; p < partFilters.length; ++p)
		{
			(function(filter)
			{
				var filterButton = button("bv-detail-research-filter" + (self.researchPartFilter === filter.ID ? " is-selected" : ""), filter.Label, function() { self.researchPartFilter = filter.ID; self.renderResearchPicker(); });
				partRow.append(filterButton);
			})(partFilters[p]);
		}
		var rarityRow = el("div", "bv-detail-research-filter-row is-rarity").append(el("span", "bv-detail-research-filter-label", copy.researchFilterRarity));
		var rarityFilters = [{ ID: "all", Label: copy.researchFilterAll, Color: "#d8d0bd" }, { ID: "white", Label: "I", Color: "#d8d0bd" }, { ID: "green", Label: "II", Color: "#54d676" }, { ID: "blue", Label: "III", Color: "#58a6ff" }, { ID: "purple", Label: "IV", Color: "#b987eb" }, { ID: "red", Label: "V", Color: "#dc6767" }];
		for (var r = 0; r < rarityFilters.length; ++r)
		{
			(function(filter)
			{
				var rarityButton = button("bv-detail-research-filter is-rarity" + (self.researchRarityFilter === filter.ID ? " is-selected" : ""), filter.Label, function() { self.researchRarityFilter = filter.ID; self.renderResearchPicker(); });
				rarityButton.css("color", filter.Color);
				rarityRow.append(rarityButton);
			})(rarityFilters[r]);
		}
		filterStack.append(partRow).append(rarityRow);
		inventory.append(filterStack);
		var grid = el("div", "bv-detail-research-picker-grid").attr("tabindex", "0");
		for (var i = 0; i < filtered.length; ++i)
		{
			(function(item)
			{
				var card = button("bv-detail-research-picker-item is-rarity-" + item.Rarity + (item.InstanceID === self.researchInspectID ? " is-selected" : ""), "", function() { self.researchInspectID = item.InstanceID; self.renderResearchPicker(); });
				card.attr({ title: item.Name, "aria-label": item.Name + " / " + item.RarityName + " / " + item.PartName });
				var icon = el("span", "bv-detail-research-picker-item-icon");
				if (item.Icon) icon.append(el("img", "").attr({ src: Path.ITEMS + item.Icon, alt: "" }));
				card.append(icon).append(el("span", "bv-detail-research-picker-item-name", item.Name)).append(el("span", "bv-detail-research-picker-item-meta", item.RarityName + " / " + item.PartName));
				grid.append(card);
			})(filtered[i]);
		}
		if (!filtered.length) grid.append(el("div", "bv-detail-research-picker-empty", copy.researchEmpty));
		inventory.append(grid);
		var preview = el("div", "bv-detail-research-picker-preview");
		if (inspected)
		{
			var hero = el("div", "bv-detail-research-picker-hero");
			var heroIcon = el("div", "bv-detail-research-picker-hero-icon is-rarity-" + inspected.Rarity);
			if (inspected.Icon) heroIcon.append(el("img", "").attr({ src: Path.ITEMS + inspected.Icon, alt: "" }));
			var heroCopy = el("div", "bv-detail-research-picker-hero-copy").append(el("div", "bv-detail-eyebrow", copy.researchSelectedSample)).append(el("h3", "", inspected.Name)).append(el("div", "", inspected.RarityName + " / " + inspected.PartName));
			hero.append(heroIcon).append(heroCopy);
			preview.append(hero);
			preview.append(el("div", "bv-detail-research-picker-route").append(el("span", "", inspected.RarityName)).append(el("b", "", "→")).append(el("strong", "", inspected.Research.NextRarityName).css("color", inspected.Research.NextRarityColor)));
			preview.append(el("div", "bv-detail-research-label", copy.researchAffixes));
			var affixList = el("div", "bv-detail-research-picker-affixes").attr("tabindex", "0");
			if (!inspected.Affixes.length) affixList.append(el("div", "bv-detail-research-empty", copy.researchNoAffixes));
			for (var a = 0; a < inspected.Affixes.length; ++a)
			{
				var affix = inspected.Affixes[a];
				affixList.append(el("div", "bv-detail-research-affix").css("border-left-color", affix.Color).append(el("strong", "", affix.Name)).append(el("span", "", affix.EffectText || affix.Value)));
			}
			preview.append(affixList);
			var choose = button("bv-detail-button bv-detail-research-picker-confirm", copy.researchPickerConfirm, function() { self.researchItemID = inspected.InstanceID; self.closeResearchPicker(); self.renderResearchIntoCurrentTab(); });
			preview.append(choose);
		}
		this.researchPickerBody.append(inventory).append(preview);
	};
	FullscreenDetail.prototype.renderResearchIntoCurrentTab = function()
	{
		if (this.tabID !== "research") return; this.content.empty(); this.renderResearch();
	};
	FullscreenDetail.prototype.confirmResearchUpgrade = function(item)
	{
		if (this.busy || !item) return;
		var self=this, mode=this.researchMode, message=copy.researchConfirm.replace("{item}",item.Name).replace("{rarity}",item.Research.NextRarityName).replace("{mode}",mode==="retain"?copy.researchRetain:copy.researchReroll);
		this.hub.showPopup(copy.researchConfirmTitle,message,[{Label:this.messages().ConfirmYes,Callback:function(){self.performResearchUpgrade(item.InstanceID,mode);}},{Label:this.messages().Cancel,Callback:null}]);
	};
	FullscreenDetail.prototype.performResearchUpgrade = function(instanceID, mode)
	{
		if(this.disposed||this.busy||this.hub.mBackendHandle===null||this.hub.mBackendHandle===undefined)return;
		var self=this,hub=this.hub;this.busy=true;this.updateActions();
		try{SQ.call(hub.mBackendHandle,"upgradeTheHertaEquipment",{InstanceID:instanceID,Mode:mode},function(result){hub.loadData(hub.mBackendHandle,function(data){if(self.disposed)return;self.busy=false;hub.applyData(data);if(self.disposed)return;hub.showMessage(result&&result.Message?result.Message:copy.failed,copy.researchResultTitle);});});}
		catch(error){this.busy=false;this.updateActions();hub.showMessage(copy.failed,copy.researchResultTitle);}
	};

	FullscreenDetail.prototype.renderHunt = function()
	{
		var self = this, hunt = this.slot.Detail.GoblinHunt;
		if (!hunt) return;
		var summary = el("div", "bv-detail-hunt-summary");
		var pointValue = String(hunt.Points);
		if (hunt.PendingPoints > 0) pointValue += "  +" + hunt.PendingPoints + " " + copy.huntPending;
		summary.append(el("div", "bv-detail-hunt-score").append(el("div", "bv-detail-eyebrow", copy.huntPoints)).append(el("div", "bv-detail-hunt-score-value", pointValue)));
		summary.append(el("div", "bv-detail-hunt-stat").append(el("span", "", copy.huntRank)).append(el("strong", "", hunt.Rank + " / " + hunt.RankMax)));
		summary.append(el("div", "bv-detail-hunt-stat").append(el("span", "", copy.huntDirect)).append(el("strong", "", hunt.DirectKills)));
		summary.append(el("div", "bv-detail-hunt-stat").append(el("span", "", copy.huntAssists)).append(el("strong", "", hunt.AssistConvictions)));
		this.content.append(summary);
		var progressMax = hunt.Rank >= hunt.RankMax ? hunt.Points : hunt.NextPoints;
		var progressMin = hunt.Rank >= hunt.RankMax ? 0 : hunt.Rank * 25;
		var progressValue = hunt.Rank >= hunt.RankMax ? 100 : Math.max(0, Math.min(100, (hunt.Points - progressMin) / Math.max(1, progressMax - progressMin) * 100));
		var progressHeading = el("div", "bv-detail-hunt-progress-heading", hunt.Rank >= hunt.RankMax ? copy.huntMax : copy.huntNext + " " + hunt.NextPoints);
		this.content.append(progressHeading).append(el("div", "bv-detail-hunt-progress").append(el("div", "bv-detail-hunt-progress-value").css("width", progressValue + "%")));
		this.content.append(el("div", "bv-detail-hunt-rank-description", hunt.RankDescription));

		var totalKills = hunt.DirectKills + hunt.AssistConvictions;
		this.huntRecordTrigger = button("bv-detail-button bv-detail-hunt-record-button", copy.huntRecordButton, function() { self.openHuntRecord(hunt); });
		this.huntRecordTrigger.attr({ "aria-haspopup": "dialog", "aria-expanded": "false" }).append(el("span", "bv-detail-hunt-record-count", totalKills));
		this.content.append(el("div", "bv-detail-hunt-record-action").append(this.huntRecordTrigger));

		this.content.append(el("div", "bv-detail-hunt-heading", copy.huntMilestones));
		var milestones = el("div", "bv-detail-hunt-milestones");
		for (var j = 0; j < hunt.Milestones.length; ++j)
		{
			(function(stage)
			{
				var card = button("bv-detail-hunt-milestone " + (stage.Unlocked ? "is-unlocked" : "is-locked"), "", function() { self.openHuntSkill(stage, card); });
				card.attr({ "aria-label": stage.Name + " / " + copy.huntViewDetails, "aria-haspopup": "dialog" });
				card.append(el("img", "bv-detail-hunt-milestone-icon").attr({ src: Path.GFX + stage.Icon, alt: "" }));
				var body = el("div", "bv-detail-hunt-milestone-body");
				body.append(el("div", "bv-detail-hunt-milestone-meta", stage.Points + " / " + (stage.Kind === "active" ? copy.huntActive : copy.huntPassive) + " / " + (stage.Unlocked ? copy.huntUnlocked : copy.huntLocked)));
				body.append(el("div", "bv-detail-hunt-milestone-name", stage.Name));
				body.append(el("div", "bv-detail-hunt-milestone-description", stage.Description));
				body.append(el("div", "bv-detail-hunt-milestone-action", copy.huntViewDetails));
				card.append(body);
				milestones.append(card);
			})(hunt.Milestones[j]);
		}
		this.content.append(milestones);
	};

	FullscreenDetail.prototype.openHuntRecord = function(hunt)
	{
		if (!hunt || this.disposed) return;
		this.huntRecordBody.empty();
		for (var i = 0; i < hunt.Breakdown.length; ++i)
		{
			var entry = hunt.Breakdown[i];
			this.huntRecordBody.append(el("div", "bv-detail-hunt-breakdown-row").append(el("span", "", entry.Name)).append(el("span", "", "+" + entry.Points + " " + copy.huntPointValue)).append(el("strong", "", "× " + entry.Kills)));
		}
		this.huntRecordOpen = true;
		if (this.huntRecordTrigger) this.huntRecordTrigger.attr("aria-expanded", "true");
		this.huntRecordOverlay.show().addClass("is-visible");
		this.huntRecordBody.scrollTop(0);
		this.huntRecordClose[0].focus();
	};

	FullscreenDetail.prototype.closeHuntRecord = function(restoreFocus)
	{
		if (!this.huntRecordOpen) return;
		this.huntRecordOpen = false;
		this.huntRecordOverlay.removeClass("is-visible").hide();
		if (this.huntRecordTrigger) this.huntRecordTrigger.attr("aria-expanded", "false");
		if (restoreFocus !== false && this.huntRecordTrigger) this.huntRecordTrigger[0].focus();
	};

	FullscreenDetail.prototype.openHuntSkill = function(stage, trigger)
	{
		if (!stage || this.disposed) return;
		this.huntSkill = stage;
		this.huntSkillTrigger = trigger || null;
		this.huntSkillOverlay.attr("aria-label", stage.Name);
		this.huntSkillIcon.attr({ src: Path.GFX + stage.Icon, alt: "" });
		this.huntSkillMeta.text(stage.Points + " / " + (stage.Kind === "active" ? copy.huntActive : copy.huntPassive) + " / " + (stage.Unlocked ? copy.huntUnlocked : copy.huntLocked));
		this.huntSkillTitle.text(stage.Name);
		this.huntSkillDescription.text(stage.Description);
		this.huntSkillEffects.empty();
		var tooltip = stage.Tooltip || [];
		for (var i = 0; i < tooltip.length; ++i)
		{
			this.huntSkillEffects.append(el("div", "bv-detail-hunt-skill-effect").append(el("span", "bv-detail-hunt-skill-effect-mark", "◆")).append(el("span", "", tooltip[i].Text)));
		}
		this.huntSkillOverlay.show().addClass("is-visible");
		this.huntSkillEffects.scrollTop(0);
		this.huntSkillClose[0].focus();
	};

	FullscreenDetail.prototype.closeHuntSkill = function(restoreFocus)
	{
		if (!this.huntSkill) return;
		this.huntSkill = null;
		this.huntSkillOverlay.removeClass("is-visible").hide();
		if (restoreFocus !== false && this.huntSkillTrigger) this.huntSkillTrigger[0].focus();
		this.huntSkillTrigger = null;
	};

	FullscreenDetail.prototype.renderProfile = function()
	{
		var detail = this.slot.Detail;
		var self=this;
  if(detail.Alchemy) this.content.append(button("bv-detail-button bv-ryza-open", "$bv{ryza.ext.open}", function(){self.openRyzaWorkshop();}));
  var entries = [detail.Background, detail.Trait].concat(detail.Skills || []);
		for (var i = 0; i < entries.length; ++i)
		{
			var section = this.hub.createDetailSection(entries[i], "bv-detail-section");
			if (section)
			{
				this.content.append(section);
			}
		}
	};

	FullscreenDetail.prototype.getBondStateCopy = function(state)
	{
		if (state === "completed") return copy.bondCompleted;
		if (state === "challenge") return copy.bondChallenge;
		if (state === "story_pending") return copy.bondStoryPending;
		return copy.bondLocked;
	};

	FullscreenDetail.prototype.findBondStage = function(value)
	{
		var bond = this.slot.Detail.Bond;
		if (!bond) return null;
		for (var i = 0; i < bond.Stages.length; ++i) if (bond.Stages[i].Value === value) return bond.Stages[i];
		return bond.Stages.length ? bond.Stages[0] : null;
	};

	FullscreenDetail.prototype.selectBondStage = function(value)
	{
		this.bondStageValue = value;
		this.renderBond();
	};

	FullscreenDetail.prototype.renderBond = function()
	{
		var self = this;
		var bond = this.slot.Detail.Bond;
		this.content.empty();
		if (!bond || !bond.Available)
		{
			this.content.append(el("div", "bv-detail-empty-state")
				.append(el("div", "bv-detail-empty-symbol", "◇"))
				.append(el("h2", "bv-detail-empty-title", narrativeCopy(this.slot.Detail, "bondUnavailable")))
				.append(el("div", "bv-detail-empty-description", narrativeCopy(this.slot.Detail, "bondUnavailableDescription"))));
			return;
		}

		var heading = el("div", "bv-detail-bond-heading");
		var headingText = el("div", "bv-detail-bond-heading-text").append(el("div", "bv-detail-eyebrow", narrativeCopy(this.slot.Detail, "bondCurrent")));
		var currentStage = this.findBondStage(bond.CurrentStageValue);
		headingText.append(el("h2", "bv-detail-bond-title", currentStage ? currentStage.Name : copy.bondStoryPending));
		heading.append(headingText).append(el("div", "bv-detail-bond-value", bond.Value + " / " + bond.Max));
		this.content.append(heading);
		var progress = el("div", "bv-detail-bond-progress").attr({ role: "progressbar", "aria-label": narrativeCopy(this.slot.Detail, "bondCurrent"), "aria-valuemin": "0", "aria-valuemax": bond.Max, "aria-valuenow": bond.Value });
		progress.append(el("div", "bv-detail-bond-progress-value").css("width", Math.max(0, Math.min(100, bond.Value / bond.Max * 100)) + "%"));
		this.content.append(progress);

		var timeline = el("div", "bv-detail-bond-timeline").attr("aria-label", narrativeCopy(this.slot.Detail, "bond"));
		for (var i = 0; i < bond.Stages.length; ++i)
		{
			(function(stage)
			{
				var stageButton = button("bv-detail-bond-stage is-" + stage.State, "", function() { self.selectBondStage(stage.Value); });
				stageButton.toggleClass("is-selected", stage.Value === self.bondStageValue).attr("aria-pressed", stage.Value === self.bondStageValue ? "true" : "false");
				stageButton.append(el("span", "bv-detail-bond-node", stage.State === "completed" ? "✓" : String(stage.Value)));
				stageButton.append(el("span", "bv-detail-bond-stage-name", stage.Name));
				timeline.append(stageButton);
			})(bond.Stages[i]);
		}
		this.content.append(timeline);

		var selected = this.findBondStage(this.bondStageValue || bond.ActiveStageValue);
		if (!selected) return;
		this.bondStageValue = selected.Value;
		var detail = el("div", "bv-detail-bond-stage-detail is-" + selected.State);
		var imagePath = selected.State === "locked" ? selected.IntroImage : (selected.CGImage || selected.IntroImage);
		if (imagePath) detail.append(el("img", "bv-detail-bond-stage-image").attr({ src: Path.GFX + imagePath, alt: selected.Title }));
		var body = el("div", "bv-detail-bond-stage-body");
		body.append(el("div", "bv-detail-bond-stage-status", this.getBondStateCopy(selected.State)));
		body.append(el("h3", "bv-detail-bond-stage-title", selected.Title));
		body.append(el("div", "bv-detail-bond-stage-caption", selected.Value + " / " + bond.Max + " / " + selected.Name));
		body.append(el("div", "bv-detail-bond-reward-label", copy.bondReward));
		body.append(el("div", "bv-detail-bond-reward", selected.Reward));
		detail.append(body);
		this.content.append(detail);
		if (bond.CompletedCount === bond.Stages.length) this.content.append(el("div", "bv-detail-bond-complete", narrativeCopy(this.slot.Detail, "bondAllComplete")));
	};

	FullscreenDetail.prototype.renderStories = function()
	{
		var self = this;
		var stories = this.slot.Detail.Stories || [];
		var unlocked = 0;
		for (var i = 0; i < stories.length; ++i) if (stories[i].Unlocked) unlocked += 1;
		var heading = el("div", "bv-detail-story-heading");
		heading.append(el("div", "bv-detail-eyebrow", copy.storyArchive));
		heading.append(el("div", "bv-detail-story-count", copy.storyUnlocked + " " + unlocked + " / " + stories.length));
		this.content.append(heading);
		if (!stories.length)
		{
			this.content.append(el("div", "bv-detail-empty-state").append(el("div", "bv-detail-empty-description", copy.storyEmpty)));
			return;
		}

		var list = el("div", "bv-detail-story-list");
		for (var storyIndex = 0; storyIndex < stories.length; ++storyIndex)
		{
			(function(story)
			{
				var item = story.Unlocked ? button("bv-detail-story-card", "", function() { self.openStory(story); }) : el("div", "bv-detail-story-card is-locked");
				if (story.Unlocked && (story.CGImage || story.IntroImage)) item.append(el("img", "bv-detail-story-card-image").attr({ src: Path.GFX + (story.CGImage || story.IntroImage), alt: story.Title }));
				else item.append(el("div", "bv-detail-story-card-placeholder", "◇"));
				var body = el("div", "bv-detail-story-card-body");
				body.append(el("div", "bv-detail-story-card-meta", narrativeCopy(self.slot.Detail, "storyTypeBond") + " / " + story.Stage));
				body.append(el("div", "bv-detail-story-card-title", story.Unlocked ? story.Title : copy.storyLocked));
				body.append(el("div", "bv-detail-story-card-action", story.Unlocked ? copy.storyOpen : story.Chapter));
				item.append(body);
				list.append(item);
			})(stories[storyIndex]);
		}
		this.content.append(list);
	};

	FullscreenDetail.prototype.formatStoryText = function(text)
	{
		return String(text || "").replace(/%SPEECH_ON%/g, "“").replace(/%SPEECH_OFF%/g, "”")
			.replace(/\[p\]/gi, "").replace(/\[\/p\]/gi, "\n\n").replace(/\[br\s*\/?\]/gi, "\n").trim();
	};

	FullscreenDetail.prototype.openStory = function(story)
	{
		if (!story || !story.Unlocked) return;
		this.story = story;
		this.storyPage = 0;
		this.storyReader.show().addClass("is-visible");
		this.setStoryPage(0);
		this.storyClose[0].focus();
	};

	FullscreenDetail.prototype.closeStory = function()
	{
		if (!this.story) return;
		this.story = null;
		this.storyReader.removeClass("is-visible").hide();
		if (this.tabButtons.story) this.tabButtons.story[0].focus();
	};

	FullscreenDetail.prototype.setStoryPage = function(page)
	{
		if (!this.story) return;
		this.storyPage = page === 1 ? 1 : 0;
		var second = this.storyPage === 1;
		this.storyReaderMeta.text(narrativeCopy(this.slot.Detail, "storyTypeBond") + " / " + this.story.Chapter);
		this.storyReaderTitle.text(this.story.Title);
		this.storyReaderPage.text(second ? copy.storyReveal : copy.storyIntro);
		this.storyReaderText.text(this.formatStoryText(second ? this.story.RevealText : this.story.IntroText));
		this.storyReaderImage.attr({ src: Path.GFX + (second ? (this.story.CGImage || this.story.IntroImage) : (this.story.IntroImage || this.story.CGImage)), alt: this.story.Title });
		this.storyPrevious.toggle(second).prop("disabled", !second);
		this.storyNext.toggle(!second).prop("disabled", second);
		this.storyReaderText.scrollTop(0);
	};
	FullscreenDetail.prototype.updateActions = function()
	{
		var messages = this.messages();
		var slot = this.slot;
		var isGacha = this.hub.mData && this.hub.mData.GachaModeEnabled === true;
		var selected = slot.IsGachaSelected && slot.GachaSelectedSkinID === this.skinID;
		var unavailable = this.busy || this.skin.Locked === true || this.hub.mBackendHandle === null || this.hub.mBackendHandle === undefined;
		this.primary.toggle(slot.State !== "summoned");
		this.primary.text(this.busy ? copy.pending : (isGacha ? (selected ? messages.GachaSelectedButton : messages.GachaSelectButton) : messages.SummonButton));
		disabled(this.primary, unavailable || (isGacha ? !slot.CanGachaSelect || selected : !slot.CanSummon));
		this.leader.text(this.skin.IsWorldLeader ? messages.LeaderCurrentButton : messages.LeaderSetButton);
		disabled(this.leader, unavailable || !this.skin.CanSetWorldLeader || this.skin.IsWorldLeader);
		this.skinItem.text(this.skin.Locked ? this.skin.UnlockHint : messages.SkinItemButton);
		disabled(this.skinItem, unavailable);
		this.skinTabs.children().prop("disabled", this.busy);
	};
	FullscreenDetail.prototype.primaryAction = function()
	{
		if (this.busy) return;
		if (this.hub.mData.GachaModeEnabled)
		{
			this.performAction("selectBattleValkyrieGachaTarget", this.messages().ResultTitle);
			return;
		}
		var self = this;
		var messages = this.messages();
		var skinID = this.skinID;
		var message = messages.ConfirmMessage || (messages.ConfirmPrefix + this.slot.Name + messages.ConfirmSuffix);
		message = message.replace("{name}", this.slot.Name).replace("{cost}", this.hub.mData.SummonCost);
		this.hub.showPopup(messages.ConfirmTitle, message, [
			{ Label: messages.ConfirmYes, Callback: function() { self.performAction("summonBattleValkyrie", messages.ResultTitle, skinID); } },
			{ Label: messages.Cancel, Callback: null }
		]);
		this.hub.mPopup.find("button").first().focus();
	};
	FullscreenDetail.prototype.performAction = function(method, title, skinID)
	{
		if (this.disposed || this.busy) return;
		var self = this;
		var hub = this.hub;
		if (hub.mBackendHandle === null || hub.mBackendHandle === undefined) return;
		this.busy = true;
		this.updateActions();
		try
		{
			SQ.call(hub.mBackendHandle, method, { ValkyrieID: this.slot.ID, SkinID: skinID || this.skinID }, function(result)
			{
				if (self.disposed) return;
				hub.loadData(hub.mBackendHandle, function(data)
				{
					if (self.disposed) return;
					self.busy = false;
					hub.applyData(data);
					if (self.disposed) return;
					var message = result && result.Message ? result.Message : (!result || result.Success !== true ? copy.failed : "");
					if (message)
					{
						hub.showMessage(message, title);
						hub.mPopup.find("button").first().focus();
					}
				});
			});
		}
		catch (error)
		{
			this.busy = false;
			this.updateActions();
			hub.showMessage(copy.failed, title);
		}
	};

	FullscreenDetail.prototype.setGallery = function(value)
	{
		this.gallery = value;
		this.root.toggleClass("is-gallery", value);
		this.galleryButton.text(value ? copy.showUI : copy.gallery).attr("aria-pressed", value ? "true" : "false");
	};
	FullscreenDetail.prototype.handleKey = function(event)
	{
		if (!this.active) return;
		if (event.keyCode === 27)
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			if (this.hub.mPopup) { this.hub.closePopup(); this.back[0].focus(); }
			else if (this.ryzaWorkshop) this.ryzaWorkshop.close();
			else if (this.lilySpiritManagerOpen) this.closeLilySpiritManager();
			else if (this.researchPickerOpen) this.closeResearchPicker();
			else if (this.huntSkill) this.closeHuntSkill();
			else if (this.huntRecordOpen) this.closeHuntRecord();
			else if (this.story) this.closeStory();
			else if (this.gallery) this.setGallery(false);
			else this.hub.closeFullscreenDetail();
		}
		else if (event.keyCode === 9)
		{
			var scope = this.hub.mPopup || (this.ryzaWorkshop ? (this.ryzaWorkshop.confirm || this.ryzaWorkshop.root) : null) || (this.lilySpiritManagerOpen ? this.lilySpiritManagerOverlay : (this.researchPickerOpen ? this.researchPickerOverlay : (this.huntSkill ? this.huntSkillOverlay : (this.huntRecordOpen ? this.huntRecordOverlay : (this.story ? this.storyReader : this.root)))));
			var items = scope.find("button:visible:enabled, select:visible:enabled, input:visible:enabled, [tabindex='0']:visible");
			if (!items.length) return;
			var index = items.index(document.activeElement);
			if (index < 0 || (!event.shiftKey && index === items.length - 1) || (event.shiftKey && index === 0))
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				items[event.shiftKey ? items.length - 1 : 0].focus();
			}
		}
	};

	FullscreenDetail.prototype.debugMedia = function(stage, extra, once)
	{
		// Diagnostic failures must never interrupt UI actions or video cleanup.
		try
		{
			if (!this.hub || this.hub.mBackendHandle === null || this.hub.mBackendHandle === undefined || typeof SQ === "undefined") return;
			if (!this.mediaDebugSeen) this.mediaDebugSeen = {};
			if (once && this.mediaDebugSeen[stage]) return;
			if ((this.mediaDebugCount || 0) >= 50) return;
			this.mediaDebugSeen[stage] = true;
			this.mediaDebugCount = (this.mediaDebugCount || 0) + 1;
			var video = this.video ? this.video[0] : null;
			var src = video ? (video.currentSrc || video.src || (this.videoSource ? this.videoSource.attr("src") : "") || "") : "";
			var info = "attempt=" + (this.mediaAttempt || 0) + " elapsedMs=" + (this.mediaStarted ? new Date().getTime() - this.mediaStarted : 0)
				+ " transport=session-registry-v11-unload hidden=" + !!document.hidden;
			if (video) info += " ready=" + video.readyState + " network=" + video.networkState + " error=" + (video.error ? video.error.code : 0)
				+ " paused=" + video.paused + " time=" + video.currentTime + " size=" + video.videoWidth + "x" + video.videoHeight
				+ " srcKind=" + (src.indexOf("data:") === 0 ? "data" : (src ? "url" : "empty")) + " srcLength=" + src.length;
			// Never log a data URI, response body, cookies or full exception messages.
			if (extra) info += " " + String(extra).replace(/data:[^\s]+/g, "[media-data]").slice(0, 400);
			SQ.call(this.hub.mBackendHandle, "logBattleValkyrieDetailMedia", {
				ValkyrieID: this.slot.ID, SkinID: this.skinID, Stage: stage, Details: info
			}, function() {});
		}
		catch (ignore) {}
	};

	DetailMediaPool.prototype.clearTimers = function()
	{
		if (this.loadTimer !== null) window.clearTimeout(this.loadTimer);
		this.loadTimer = null;
		if (this.progressTimer !== null) window.clearTimeout(this.progressTimer);
		this.progressTimer = null;
	};
	DetailMediaPool.prototype.mount = function(owner)
	{
		var node = this.host[0];
		if (!this.attached || !node.parentNode)
		{
			owner.hub.mOverlay.before(this.host);
			this.attached = true;
		}
		this.owner = owner;
	};
	DetailMediaPool.prototype.setSurfaceParked = function(parked)
	{
		// Move only the full-sized host. Keep decoder sources, video dimensions,
		// DOM ancestry and opacity-based video hiding unchanged for GT 1.11.
		this.host.toggleClass("is-surface-parked", parked);
		this.surfaceParked = parked;
	};
	DetailMediaPool.prototype.cancelAudit = function()
	{
		this.auditToken = (this.auditToken || 0) + 1;
		if (this.auditTimer !== null && this.auditTimer !== undefined) window.clearTimeout(this.auditTimer);
		this.auditTimer = null;
	};
	DetailMediaPool.prototype.auditClosed = function(owner, reason)
	{
		// Three bounded, read-only samples. Diagnostics must never resume/pause a
		// decoder or keep polling while the player uses another screen.
		this.cancelAudit();
		var self = this, token = this.auditToken, started = new Date().getTime();
		var previous = [], previousTimes = [], sampleIndex = 0;
		var sample = function(expectedMs)
		{
			if (self.auditToken !== token) return;
			self.auditTimer = null;
			try
			{
				var nodes = self.host[0].getElementsByTagName("video");
				var tracked = 0, failed = 0, pauseErrors = 0, playing = 0, advanced = 0, states = [];
				for (var key in self.slots) if (Object.prototype.hasOwnProperty.call(self.slots, key))
				{
					tracked += 1;
					if (self.slots[key].failed) failed += 1;
					pauseErrors += self.slots[key].pauseErrors || 0;
				}
				for (var i = 0; i < nodes.length; i++)
				{
					var node = nodes[i], time = Number(node.currentTime) || 0;
					var moved = previous[i] === node && Math.abs(time - previousTimes[i]) > 0.01;
					if (!node.paused && !node.ended) playing += 1;
					if (moved) advanced += 1;
					// Indices refer to DOM creation order, including failed retry nodes.
					if (i < 12) states.push(i + ":" + (node.paused ? "P" : "R") + (moved ? "+" : "=") + time.toFixed(2));
					previous[i] = node;
					previousTimes[i] = time;
				}
				var outsidePlaying = 0;
				var all = document.getElementsByTagName("video");
				for (var j = 0; j < all.length; j++)
					if (!self.host[0].contains(all[j]) && !all[j].paused && !all[j].ended) outsidePlaying += 1;
				owner.debugMedia("registry.audit", "reason=" + reason + " sample=" + sampleIndex
					+ " ageMs=" + (new Date().getTime() - started) + " expectedMs=" + expectedMs
					+ " nodes=" + nodes.length + " tracked=" + tracked + " orphan=" + (nodes.length - tracked)
					+ " failed=" + failed + " pauseErrors=" + pauseErrors + " playing=" + playing
					+ " advanced=" + advanced + " outsidePlaying=" + outsidePlaying
					+ " pending=" + !!self.pending + " parked=" + !!self.surfaceParked + " states=" + states.join(","));
			}
			catch (ignore)
			{
				// Report unsupported probes without exposing native exception text.
				try { owner.debugMedia("registry.audit-error", "sample=" + sampleIndex); } catch (ignored) {}
			}
			sampleIndex += 1;
			if (sampleIndex < 3)
			{
				var due = sampleIndex === 1 ? 300 : 1200;
				self.auditTimer = window.setTimeout(function() { sample(due); }, Math.max(0, due - (new Date().getTime() - started)));
			}
		};
		sample(0);
	};
	DetailMediaPool.prototype.hideSlot = function(slot)
	{
		if (!slot) return;
		slot.video.removeClass("is-ready").addClass("is-player-hidden");
		try { slot.video[0].pause(); } catch (ignore) { slot.pauseErrors = (slot.pauseErrors || 0) + 1; }
	};
	DetailMediaPool.prototype.cancelRelease = function()
	{
		this.releaseToken = (this.releaseToken || 0) + 1;
		if (this.releaseTimer !== null && this.releaseTimer !== undefined) window.clearTimeout(this.releaseTimer);
		this.releaseTimer = null;
	};
	DetailMediaPool.prototype.scheduleRelease = function(owner)
	{
		this.cancelRelease();
		var self = this, token = this.releaseToken;
		// Include failed retries no longer reachable through the current slot map.
		var pausedNodes = this.host[0].getElementsByTagName("video");
		for (var p = 0; p < pausedNodes.length; ++p)
			try { pausedNodes[p].pause(); } catch (ignored) {}
		// GT 1.11 previously crashed on synchronous visible-player teardown. First
		// pause/park, wait for the close audits, then unload without reusing any
		// retired decoder. Reopening before this timer fires cancels retirement.
		this.releaseTimer = window.setTimeout(function()
		{
			if (self.releaseToken !== token || self.pending || !self.surfaceParked) return;
			self.releaseTimer = null;
			var live = self.host[0].getElementsByTagName("video"), nodes = [];
			for (var i = 0; i < live.length; ++i) nodes.push(live[i]);
			self.slots = {};
			self.activeSlot = null;
			owner.video = null;
			owner.videoSource = null;
			owner.debugMedia("registry.unload-start", "nodes=" + nodes.length);
			for (var j = 0; j < nodes.length; ++j)
			{
				var node = nodes[j];
				if (node.bvDetailRetired) continue;
				node.bvDetailRetired = true;
				try
				{
					var video = $(node);
					node.pause();
					video.off(".bvDetailRegistry");
					video.children("source").off(".bvDetailRegistry").remove();
					node.loop = false;
					node.preload = "none";
					node.removeAttribute("src");
					// Empty-source load aborts fetching and resets the media resource.
					// This node will never receive another source or play request.
					node.load();
				}
				catch (error) { owner.debugMedia("registry.unload-error", "node=" + j); }
			}
			// Remove only confirmed empty nodes, in a later task after texture reset.
			// Bounded probes also report engines which refuse to unload a resource.
			var attempt = 0;
			var collect = function()
			{
				var retained = 0, removed = 0;
				for (var k = 0; k < nodes.length; ++k)
				{
					var retired = nodes[k];
					try
					{
						if (!retired || !retired.parentNode) continue;
						if (retired.readyState === 0 && retired.paused)
						{
							$(retired).remove();
							nodes[k] = null;
							removed += 1;
						}
						else retained += 1;
					}
					catch (ignored) { retained += 1; }
				}
				owner.debugMedia("registry.unload-check", "attempt=" + attempt + " removed=" + removed + " retained=" + retained);
				attempt += 1;
				if (retained && attempt < 3) window.setTimeout(collect, 400);
			};
			window.setTimeout(collect, 200);
		}, 1300);
	};
	DetailMediaPool.prototype.hideActive = function(owner)
	{
		this.hideSlot(this.activeSlot);
		if (owner && owner.root) owner.root.removeClass("is-video-ready");
	};
	DetailMediaPool.prototype.cancelPending = function()
	{
		// play() precedes commit(): a pending slot can already be decoding while
		// still transparent. Invalidate its callbacks before pausing it.
		var request = this.pending;
		this.pending = null;
		this.clearTimers();
		if (request) this.hideSlot(request.slot);
	};
	DetailMediaPool.prototype.isCurrent = function(slot, token)
	{
		return !!(this.pending && this.pending.slot === slot && this.pending.token === token && this.owner === this.pending.owner);
	};
	DetailMediaPool.prototype.createSlot = function(request)
	{
		var self = this;
		var video = el("video", "bv-detail-video is-player-hidden").attr({ preload: "auto", muted: "muted", playsinline: "playsinline", "aria-hidden": "true" });
		var source = el("source", "bv-detail-video-source").attr({ type: "video/webm", src: Path.GFX + request.media.Video + ".dds" });
		video[0].muted = request.media.Muted !== false;
		if (!video[0].muted) video.removeAttr("muted");
		video[0].loop = request.media.Loop !== false;
		video.append(source);
		var slot = { key: request.key, video: video, source: source, ready: false, failed: false };
		request.slot = slot;
		this.slots[request.key] = slot;
		this.host.append(video);
		request.owner.video = video;
		request.owner.videoSource = source;
		video.on("ended.bvDetailRegistry", function() {
			if (self.owner === request.owner && request.owner.active && typeof request.owner.onMediaEnded === "function") request.owner.onMediaEnded();
		});
		request.owner.debugMedia("registry.create", "key=" + request.key + " url=" + source.attr("src"));
		video.on("loadedmetadata.bvDetailRegistry", function()
		{
			if (self.pending && self.owner && self.pending.slot === slot) self.owner.debugMedia("registry.metadata", "key=" + slot.key + " size=" + video[0].videoWidth + "x" + video[0].videoHeight, true);
		});
		video.one("loadeddata.bvDetailRegistry", function()
		{
			if (video[0].readyState < 2 || video[0].videoWidth <= 0 || video[0].videoHeight <= 0) return;
			slot.ready = true;
			if (self.pending && self.owner && self.pending.slot === slot)
			{
				self.owner.debugMedia("registry.loaded", "key=" + slot.key);
				self.beginPlayback(slot, self.pending.token);
			}
		});
		video.on("playing.bvDetailRegistry", function()
		{
			if (self.pending && self.owner && self.isCurrent(slot, self.pending.token)) self.owner.debugMedia("registry.playing", "key=" + slot.key, true);
		});
		video.on("error.bvDetailRegistry", function() { if (self.pending && self.pending.slot === slot) self.failPending("decode", self.pending.token); });
		source.on("error.bvDetailRegistry", function() { if (self.pending && self.pending.slot === slot) self.failPending("source-error", self.pending.token); });
		if (typeof video[0].canPlayType !== "function" || !video[0].canPlayType('video/webm; codecs="vp8"'))
		{
			this.failPending("unsupported", request.token);
			return;
		}
		try { video[0].load(); }
		catch (error) { this.failPending("source-exception", request.token); }
	};
	DetailMediaPool.prototype.beginPlayback = function(slot, token)
	{
		var self = this;
		if (!this.isCurrent(slot, token) || document.hidden || !this.owner.active) return;
		var video = slot.video[0];
		this.pending.progressStarted = new Date().getTime();
		this.pending.progressPosition = video.currentTime || 0;
		try
		{
			var result = video.play();
			if (result && typeof result.then === "function") result.then(null, function() { self.failPending("play-rejected", token); });
		}
		catch (error) { this.failPending("play-exception", token); return; }
		this.progressTimer = window.setTimeout(function() { self.checkProgress(slot, token); }, 80);
	};
	DetailMediaPool.prototype.checkProgress = function(slot, token)
	{
		var self = this;
		if (!this.isCurrent(slot, token)) return;
		var request = this.pending;
		var video = slot.video[0];
		var advanced = Math.abs((video.currentTime || 0) - request.progressPosition) > 0.01;
		if (advanced && video.readyState >= 2 && video.videoWidth > 0 && video.videoHeight > 0)
		{
			this.commit(slot, token);
			return;
		}
		if (new Date().getTime() - request.progressStarted >= 2500)
		{
			this.failPending("playback-stalled", token);
			return;
		}
		this.progressTimer = window.setTimeout(function() { self.checkProgress(slot, token); }, 80);
	};
	DetailMediaPool.prototype.commit = function(slot, token)
	{
		if (!this.isCurrent(slot, token)) return;
		var owner = this.pending.owner;
		var key = this.pending.key;
		if (this.activeSlot && this.activeSlot !== slot) this.hideSlot(this.activeSlot);
		this.activeSlot = slot;
		this.pending = null;
		this.clearTimers();
		owner.video = slot.video;
		owner.videoSource = slot.source;
		owner.resizeMedia();
		slot.video.removeClass("is-player-hidden").addClass("is-ready");
		owner.root.addClass("is-video-ready");
		owner.mediaStatus.text("");
		owner.retryButton.hide().removeAttr("title");
		owner.debugMedia("registry.commit", "key=" + key);
	};
	DetailMediaPool.prototype.failPending = function(reason, token)
	{
		if (!this.pending || (token !== undefined && this.pending.token !== token)) return;
		var owner = this.pending.owner;
		var slot = this.pending.slot;
		if (slot) { slot.failed = true; this.hideSlot(slot); }
		this.pending = null;
		this.clearTimers();
		if (owner && owner.root) owner.root.removeClass("is-video-ready");
		if (owner && !owner.disposed) owner.failMedia(reason || "decode", true);
	};
	DetailMediaPool.prototype.request = function(owner, skin)
	{
		this.cancelRelease();
		this.cancelAudit();
		var self = this;
		var media = skin.DetailMedia || {};
		var key = skin.ID + "|" + media.Video;
		this.mount(owner);
		this.requestToken += 1;
		this.cancelPending();
		this.hideActive(owner);
		this.setSurfaceParked(false);
		var request = { owner: owner, skin: skin, media: media, key: key, token: this.requestToken, slot: null, progressStarted: 0, progressPosition: 0 };
		this.pending = request;
		this.loadTimer = window.setTimeout(function() { self.failPending("timeout", request.token); }, 8000);
		var slot = this.slots[key];
		if (slot && slot.failed) slot = null;
		if (!slot)
		{
			this.createSlot(request);
			return;
		}
		request.slot = slot;
		owner.video = slot.video;
		owner.videoSource = slot.source;
		owner.debugMedia("registry.reuse", "key=" + key);
		if (slot.ready) this.beginPlayback(slot, request.token);
	};
	DetailMediaPool.prototype.showStatic = function(owner)
	{
		this.requestToken += 1;
		this.cancelPending();
		this.hideActive(owner);
		this.activeSlot = null;
		owner.video = null;
		owner.videoSource = null;
		this.setSurfaceParked(true);
		this.auditClosed(owner, "static");
		this.scheduleRelease(owner);
	};
	DetailMediaPool.prototype.suspend = function(owner)
	{
		if (this.owner !== owner) return;
		owner.debugMedia("registry.suspend");
		this.requestToken += 1;
		this.cancelPending();
		this.hideActive(owner);
		owner.video = null;
		owner.videoSource = null;
		this.setSurfaceParked(true);
		this.auditClosed(owner, "suspend");
		this.scheduleRelease(owner);
	};
	DetailMediaPool.prototype.resume = function(owner)
	{
		if (owner.skin && owner.media && owner.media.Video) this.request(owner, owner.skin);
	};
	DetailMediaPool.prototype.park = function(owner)
	{
		this.suspend(owner);
		this.owner = null;
	};

	FullscreenDetail.prototype.failMedia = function(reason, fromPool)
	{
		this.debugMedia("failure", "reason=" + (reason || "decode"));
		var errorCode = this.video && this.video[0].error ? this.video[0].error.code : 0;
		this.video = null;
		this.videoSource = null;
		var message = reason === "unsupported" ? copy.unsupported : copy.mediaFailed;
		this.mediaStatus.text(message);
		this.retryButton.show().text(copy.retry).attr("title", message);
		if (window.console && window.console.warn) window.console.warn("[Battle Valkyries] Detail video unavailable: skin=" + this.skinID + ", reason=" + (reason || "decode") + ", code=" + errorCode + ", source=" + (this.media ? this.media.Video : ""));
	};
	FullscreenDetail.prototype.setMedia = function(skin)
	{
		var presentation = this.slot.Detail.StagePresentation;
		if (presentation)
		{
			var view = presentation.StageViews[this.previewStage === null ? presentation.ActualStage : this.previewStage];
			if (view && !view.Locked && view.DetailMedia)
				skin = { ID: "olga-stage-" + view.Stage + "-v1", DetailMedia: view.DetailMedia, SummonPortrait: this.slot.Detail.SummonPortrait };
		}
		var media = skin.DetailMedia || {};
		var key = skin.ID + "|" + (media.Video || "") + "|" + (media.Poster || skin.SummonPortrait);
		this.media = media;
		this.mediaKey = skin.ID + "|" + (media.Video || "");
		this.mediaAttempt = (this.mediaAttempt || 0) + 1;
		this.mediaStarted = new Date().getTime();
		this.mediaDebugSeen = {};
		this.mediaDebugCount = 0;
		this.stage.toggleClass("is-card-fallback", !media.Poster);
		this.poster.off("error.bvDetail");
		var self = this;
		this.poster.one("error.bvDetail", function() { self.stage.addClass("is-card-fallback"); self.poster.attr("src", Path.GFX + skin.SummonPortrait); });
		this.poster.attr("src", Path.GFX + (media.Poster || skin.SummonPortrait));
		this.mediaStatus.text(media.Video ? copy.loading : copy.static);
		this.retryButton.hide().removeAttr("title");
		this.resizeMedia();
		if (!media.Video) { this.mediaPool.showStatic(this); return; }
		this.debugMedia("pool.request", "key=" + key + " file=" + media.Video);
		this.mediaPool.request(this, skin);
	};
	FullscreenDetail.prototype.playMedia = function()
	{
		this.mediaPool.resume(this);
	};
	FullscreenDetail.prototype.releaseMedia = function()
	{
		this.mediaPool.suspend(this);
	};
	FullscreenDetail.prototype.retryMedia = function()
	{
		if (this.disposed || this.video || !this.media || !this.media.Video) return;
		this.debugMedia("button.retry");
		this.mediaKey = null;
		this.setMedia(this.skin);
	};
	FullscreenDetail.prototype.resizeMedia = function()
	{
		var w = this.stage.width(), h = this.stage.height();
		var media = this.media || {};
		var positionX = typeof media.PositionX === "number" ? media.PositionX : 0.35;
		var positionY = typeof media.PositionY === "number" ? media.PositionY : 0.3;
		var cover = function(node, width, height)
		{
			if (!width || !height) return;
			var scale = Math.max(w / width, h / height);
			node.css({ width: width * scale, height: height * scale, left: (w - width * scale) * positionX, top: (h - height * scale) * positionY });
		};
		if (!this.stage.hasClass("is-card-fallback")) cover(this.poster, this.poster[0].naturalWidth, this.poster[0].naturalHeight);
		else this.poster.removeAttr("style");
		if (this.video) cover(this.video, this.video[0].videoWidth || 1280, this.video[0].videoHeight || 720);
	};
	FullscreenDetail.prototype.resume = function(slot)
	{
		if (this.disposed) return;
		this.previewStage = null;
		this.previousFocus = document.activeElement;
		this.active = true;
		this.root.show();
		this.hub.ensureDialog().addClass("has-fullscreen-detail");
		this.mediaPool.mount(this);
		this.refresh(slot);
		this.back[0].focus();
	};
	FullscreenDetail.prototype.suspend = function()
	{
		if (this.disposed || !this.active) return;
		this.active = false;
		if(this.ryzaWorkshop)this.ryzaWorkshop.close(false);
		this.closeHuntRecord(false);
		this.closeHuntSkill(false);
		this.closeResearchPicker(false);
		this.closeLilySpiritManager(false);
		this.story = null;
		this.storyReader.removeClass("is-visible").hide();
		this.mediaPool.suspend(this);
		this.hub.closePopup();
		this.hub.mOverlay.removeClass("has-fullscreen-detail");
		this.root.hide();
		if (this.previousFocus && document.documentElement.contains(this.previousFocus)) this.previousFocus.focus();
	};
	FullscreenDetail.prototype.destroy = function()
	{
		if (this.disposed) return;
		this.disposed = true;
		this.active = false;
		if(this.ryzaWorkshop)this.ryzaWorkshop.close(false);
		this.mediaPool.park(this);
		this.closeResearchPicker(false);
		this.closeLilySpiritManager(false);
		window.removeEventListener("resize", this.resizeHandler);
		document.removeEventListener("visibilitychange", this.visibilityHandler);
		document.removeEventListener("keydown", this.keyHandler, true);
		this.hub.closePopup();
		this.hub.mOverlay.removeClass("has-fullscreen-detail");
		this.root.remove();
	};
	window[namespace + "DetailMediaPoolClass"] = DetailMediaPool;
	window[namespace + "FullscreenDetail"] = FullscreenDetail;
})();
