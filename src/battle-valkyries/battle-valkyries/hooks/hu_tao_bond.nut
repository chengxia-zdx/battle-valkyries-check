local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
 local trait=::$bvvar{namespace}.HuTaoBond.ensureTrait(actor);
	local result=originalSync(actor, reason);
 if(result.Success&&trait!=null&&reason=="player.onDeserialize")::$bvvar{namespace}.HuTaoBond.deliverRewards(trait);
 return result;
};
::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.HuTaoBondTraitID,
	function() { return ::$bvvar{namespace}.HuTaoBond.checkEvent(); });
::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function() { __original(); this.addSpecialEvent("event.battle_valkyries_hu_tao_bond"); }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.HuTaoBond.startCombat(this);
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.getLocalCombatProperties = @(__original) function(pos, ignoreNoEnemies = false)
	{
		local result = __original(pos, ignoreNoEnemies);
		if (result != null) foreach (party in result.Parties)
		{
			local stage = ::$bvvar{namespace}.HuTaoBond.campStage(party);
			if (stage == null) continue;
			result.TerrainTemplate = stage.TerrainTemplate;
			break;
		}
		return result;
	};
	q.onCombatFinished = @(__original) function()
	{
		// Award before native ironman autosave. The actor ledger makes the later flush idempotent.
		::$bvvar{namespace}.HuTaoBond.awardCombatBond(::$bvvar{namespace}.HuTaoBond.combatID() + 1);
		// Native code then increments LastCombatID, settles locations and saves durable reward entitlements.
		local result = __original();
		::$bvvar{namespace}.HuTaoBond.finishCombat();
		return result;
	}
});
