::$bvvar{namespace}.MH.hook("scripts/scenarios/scenario_manager", function(q) {
	q.create = @(__original) function() {
		__original();
		if (this.getScenario(::$bvvar{namespace}.ForeignBanner.OriginID) != null) return;
		local scenario = this.new("scripts/scenarios/world/battle_valkyries_foreign_banner_scenario");
		if (scenario.isValid()) { this.m.Scenarios.push(scenario); this.m.Scenarios.sort(this.onOrderCompare); }
	};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/world/modules/topbar/world_screen_topbar_options_module", function(q) {
	q.showBattleValkyrieSummon <- function() { this.m.JSHandle.asyncCall("showBattleValkyrieSummon", null); };
	q.queryBattleValkyriesHubData = @(__original) function() {
		local dto = __original(), origin = ::$bvvar{namespace}.ForeignBanner;
		local story = origin.dto(); if (story != null) dto.ChapterCards.insert(0, story);
		dto.FreeValkyrieChoice <- origin.active();
		if (dto.FreeValkyrieChoice) {
			dto.GachaProgress = dto.GachaProgressMax;
			dto.Messages.GachaPullButton = "$bv{origin.foreign_banner.pact.button}";
			dto.Messages.SummonButton = "$bv{origin.foreign_banner.pact.button}";
		}
		return dto;
	};
	q.requestBattleValkyrieChapter = @(__original) function(request) {
		if (typeof request == "table" && "ID" in request && request.ID == ::$bvvar{namespace}.ForeignBanner.ID)
			return ::$bvvar{namespace}.ForeignBanner.request(request);
		return __original(request);
	};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/character/character_screen", function(q) {
	foreach (name in ["general_onEquipStashItem", "general_onDropStashItemIntoBag"]) {
		q[name] = @(__original) function(data) {
			local found = this.helper_queryStashItemData(data);
			if (!("error" in found) && found.sourceItem.getID() == ::$bvvar{namespace}.ForeignBanner.ItemID
				&& ::$bvvar{namespace}.ForeignBanner.safeWorld()) {
				found.sourceItem.onUse(found.inventory.getActor());
				return this.UIDataHelper.convertStashAndEntityToUIData(found.entity, null, false, this.m.InventoryFilter);
			}
			return __original(data);
		};
	}
	q.general_onDestroyStashItem = @(__original) function(data) {
		local found = this.helper_queryStashItemData(data);
		if (!("error" in found) && found.sourceItem.getID() == ::$bvvar{namespace}.ForeignBanner.ItemID) return null;
		return __original(data);
	};
});
