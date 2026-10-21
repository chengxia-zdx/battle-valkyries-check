// One authored start and one consumable entitlement. No chapter progression or combat hooks.
::$bvvar{namespace}.ForeignBanner <- {
	ID = "foreign_banner", OriginID = "scenario.battle_valkyries_foreign_banner",
	ItemID = "$bvvar{modId}.item.guiding_pact", Busy = false,
	read = function(key, fallback = false) {
		return ::$bvvar{namespace}.getGachaWorldFlag("BattleValkyries.ForeignBanner." + key, fallback);
	},
	write = function(key, value) {
		return ::$bvvar{namespace}.setGachaWorldFlag("BattleValkyries.ForeignBanner." + key, value);
	},
	isOrigin = function() {
		if (::World == null || ::World.Assets == null) return false;
		local origin = ::World.Assets.getOrigin();
		return origin != null && origin.getID() == this.OriginID;
	},
	safeWorld = function() {
		return ::World != null && ::World.Assets != null && ::World.State != null
			&& (!("Tactical" in getroottable()) || ::Tactical == null || !::Tactical.isActive());
	},
	item = function() {
		if (::World == null || ::World.Assets == null) return null;
		foreach (entry in ::World.Assets.getStash().getItems())
			if (entry != null && entry.getID() == this.ItemID) return entry;
		return null;
	},
	active = function() { return !this.read("pact_used") && this.read("pact_active") && this.item() != null; },
	activate = function() {
		if (!this.safeWorld() || this.read("pact_used") || this.item() == null) return false;
		return this.write("pact_active", true);
	},
	grant = function(context) {
		if (this.read("pact_issued")) return;
		local stash = ::World.Assets.getStash();
		if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) return;
		local entry = ::$bvvar{namespace}.createValkyrieScriptObject(context, null, "scripts/items/misc/battle_valkyries/guiding_pact_item");
		if (entry == null || entry.getID() != this.ItemID) throw "Guiding pact initialization failed";
		try { if (stash.add(entry) != null) this.write("pact_issued", true); }
		catch (e) {
			foreach (stored in stash.getItems()) if (stored == entry) { this.write("pact_issued", true); return; }
			throw e;
		}
	},
	redeem = function(identity, context, skin = null) {
		local api = ::$bvvar{namespace};
		if (this.Busy || !this.safeWorld() || !this.active()) return api.createValkyrieResult(false, "$bv{origin.foreign_banner.pact.unavailable}", "unavailable");
		if (identity == null || identity == "") return api.createValkyrieResult(false, "$bv{ui.hub.gacha.error.need_selection}", "need_selection");
		this.Busy = true;
		local result = null;
		try {
			// The normal constructor owns identity, equipment, skin eligibility and rollback.
			result = api.summonValkyrieInternal(identity, context, 0, skin);
			if (result.Success) {
				// Commit before cleanup: even a failed item removal cannot grant a second actor.
				this.write("pact_used", true); this.write("pact_active", false);
				api.setValkyrieGachaProgress(0);
				api.setValkyrieGachaGuaranteeCount(api.getValkyrieGachaGuaranteeCount() + 1);
				api.clearSelectedGachaValkyrie();
				local entry = this.item();
				if (entry != null) {
					try { ::World.Assets.getStash().remove(entry); }
					catch (e) { ::logWarning("[Battle Valkyries] Consumed guiding pact cleanup deferred: " + e); }
				}
			}
		} catch (e) { this.Busy = false; throw e; }
		this.Busy = false; return result;
	},
	scene = function(key = "opening") {
		local definition = ::$bvvar{namespace}.ForeignBannerStory;
		if (!(key in definition.Scenes)) return null;
		local source = definition.Scenes[key], lines = [];
		foreach (line in source.Lines) {
			local copy = clone line;
			copy.Name <- definition.SpeakerNames[line.Speaker];
			lines.push(copy);
		}
		return { ID = "foreign_banner_" + key, Title = source.Title, Background = source.Background,
			Actors = clone definition.PortraitOrder, Portraits = clone definition.Portraits, Lines = lines, Video = "" };
	},
	dto = function() {
		if (!this.isOrigin()) return null;
		local d = ::$bvvar{namespace}.ForeignBannerStory, gallery = [];
		foreach (cg in d.Gallery) gallery.push({ ID = cg.ID, Stage = 0, Unlocked = true, Title = cg.Title, Caption = cg.Caption, Image = cg.Image });
		return { ID = this.ID, Name = d.Name, Description = d.Description, Poster = d.Poster,
			StoryOnly = true, Started = true, Finished = true, Completed = 1, Total = 1,
			Opening = this.scene(), Gallery = gallery, Stages = [],
			NextSteps = this.read("first_contract") ? "$bv{origin.foreign_banner.next_free}" : "$bv{origin.foreign_banner.next_contract}",
			PactHint = !this.read("pact_used") && this.item() != null ? "$bv{origin.foreign_banner.next_pact}" : "",
			Ending = "$bv{origin.foreign_banner.replay_hint}",
			EndingScene = this.read("first_contract") ? this.scene("first_contract") : null,
			EndingReplayLabel = "$bv{origin.foreign_banner.first_contract.title}" };
	},
	request = function(request) {
		if (typeof request != "table" || !this.isOrigin() || !("Action" in request) || request.Action != "refresh")
			return { Success = false, Message = "$bv{chapter.error.unavailable}" };
		return { Success = true, Chapter = this.dto() };
	}
};

local gachaCost = ::$bvvar{namespace}.getValkyrieGachaCost;
::$bvvar{namespace}.getValkyrieGachaCost = function() {
	return this.ForeignBanner.active() ? 0 : gachaCost.call(this);
};
local summonCost = ::$bvvar{namespace}.getValkyrieSummonCost;
::$bvvar{namespace}.getValkyrieSummonCost = function() {
	return this.ForeignBanner.active() ? 0 : summonCost.call(this);
};
local pull = ::$bvvar{namespace}.pullGachaValkyrie;
::$bvvar{namespace}.pullGachaValkyrie = function(context) {
	if (this.getSettingValue("GachaMode") && this.ForeignBanner.active())
		return this.ForeignBanner.redeem(this.getSelectedGachaValkyrieID(), context, this.getSelectedGachaSkinID());
	return pull.call(this, context);
};
local summon = ::$bvvar{namespace}.summonValkyrie;
::$bvvar{namespace}.summonValkyrie = function(identity, context, skin = null) {
	if (!this.getSettingValue("GachaMode") && this.ForeignBanner.active()) return this.ForeignBanner.redeem(identity, context, skin);
	return summon.call(this, identity, context, skin);
};
