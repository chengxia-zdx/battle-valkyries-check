local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
	::$bvvar{namespace}.YeShunguangBond.ensureTrait(actor);
	return originalSync(actor, reason);
};
::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.YeShunguangBondTraitID,
	function() { return ::$bvvar{namespace}.YeShunguangBond.checkEvent(); });
::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function() { __original(); this.addSpecialEvent("event.battle_valkyries_ye_shunguang_bond"); }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.YeShunguangBond.startCombat(this);
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		// Award before native ironman autosave. The actor ledger makes the later flush idempotent.
		::$bvvar{namespace}.YeShunguangBond.awardCombatBond(::$bvvar{namespace}.YeShunguangBond.combatID() + 1);
		// Native code then increments LastCombatID, settles locations and saves durable reward entitlements.
		local result = __original();
		::$bvvar{namespace}.YeShunguangBond.finishCombat();
		return result;
	}
});
::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(item)
	{
		if (item != null && (item.getID() == "$bvvar{modId}.helmet.ye_shunguang_heartbound_circlet"
			|| item.getID() == "$bvvar{modId}.armor.ye_shunguang_homeward_vestment")
			&& ::$bvvar{namespace}.getActorValkyrieID(this.getActor()) != "ye_shunguang") return false;
		return __original(item);
	}
});
