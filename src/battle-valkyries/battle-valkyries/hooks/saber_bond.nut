local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
	::$bvvar{namespace}.SaberBond.ensureTrait(actor);
	return originalSync(actor, reason);
};
::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.SaberBondTraitID,
	function() { return ::$bvvar{namespace}.SaberBond.checkEvent(); });
::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function() { __original(); this.addSpecialEvent("event.battle_valkyries_saber_bond"); }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.SaberBond.startCombat(this);
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		// Award before native ironman autosave. The actor ledger makes the later flush idempotent.
		::$bvvar{namespace}.SaberBond.awardCombatBond(::$bvvar{namespace}.SaberBond.combatID() + 1);
		// Native code then increments LastCombatID, settles locations and saves durable reward entitlements.
		local result = __original();
		::$bvvar{namespace}.SaberBond.finishCombat();
		return result;
	}
});
::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(item)
	{
		if (item != null && item.getID() == "$bvvar{modId}.weapon.saber_oath_excalibur"
			&& ::$bvvar{namespace}.getActorValkyrieID(this.getActor()) != "saber") return false;
		return __original(item);
	}
});
