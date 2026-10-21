local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
	::$bvvar{namespace}.HertaBond.ensureTrait(actor);
	local result = originalSync(actor, reason);
    if (result.Success) ::$bvvar{namespace}.HertaCombat.syncWeapon(actor);
    return result;
};
::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.HertaBondTraitID,
	function() { return ::$bvvar{namespace}.HertaBond.checkEvent(); });
::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function() { __original(); this.addSpecialEvent("event.battle_valkyries_the_herta_bond"); }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.HertaBond.startCombat(this);
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
    q.onDeserialize = @(__original) function(input) { local r=__original(input); ::$bvvar{namespace}.HertaEquipment.backfill(); return r; };
    q.onShow = @(__original) function() { local r=__original(); ::$bvvar{namespace}.HertaEquipment.backfill(); return r; };
	q.onCombatFinished = @(__original) function()
	{
		// Award before native ironman autosave. The actor ledger makes the later flush idempotent.
		::$bvvar{namespace}.HertaBond.awardCombatBond(::$bvvar{namespace}.HertaBond.combatID() + 1);
		// Native code then increments LastCombatID, settles locations and saves durable reward entitlements.
		local result = __original();
		::$bvvar{namespace}.HertaBond.finishCombat();
		return result;
	}
});
::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(item)
	{
		if (item != null && (["$bvvar{modId}.weapon.the_herta_answer_foreordained", "$bvvar{modId}.weapon.the_herta_unending_inquiry",
            "$bvvar{modId}.armor.the_herta_starweave_mantle", "$bvvar{modId}.helmet.the_herta_astrolabe_crown"].find(item.getID()) != null)
			&& ::$bvvar{namespace}.getActorValkyrieID(this.getActor()) != "the_herta") return false;
		return __original(item);
	}
});
