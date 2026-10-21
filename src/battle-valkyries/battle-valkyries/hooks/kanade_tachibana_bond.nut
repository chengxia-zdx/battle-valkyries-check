local originalGrant=::$bvvar{namespace}.grantActorValkyrieSkinTrait;
::$bvvar{namespace}.grantActorValkyrieSkinTrait=function(actor,id,context=null,skin=null)
{
 local result=originalGrant(actor,id,context,skin);
 if(result&&id=="kanade_tachibana"&&::$bvvar{namespace}.getActorValkyrieID(actor)==id&&!::$bvvar{namespace}.Kanade.AutoChangingSkin)
  actor.getFlags().set("BVKanadeManualSkin",true);
 return result;
};
local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
 local trait=::$bvvar{namespace}.KanadeBond.ensureTrait(actor);
	local result=originalSync(actor, reason);
 if(result.Success&&::$bvvar{namespace}.getActorValkyrieID(actor)=="kanade_tachibana"&&::$bvvar{namespace}.hasKanadeBondUpgrade(actor,100))::$bvvar{namespace}.attachTransientSkill(actor,"kanade_sonic_rotation","kanade.bond.100");
 if(result.Success&&trait!=null&&reason=="player.onDeserialize")::$bvvar{namespace}.KanadeBond.deliverRewards(trait);
 return result;
};
::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.KanadeBondTraitID,
	function() { return ::$bvvar{namespace}.KanadeBond.checkEvent(); });
::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function() { __original(); this.addSpecialEvent("event.battle_valkyries_kanade_tachibana_bond"); }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.KanadeBond.startCombat(this);
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.getLocalCombatProperties = @(__original) function(pos, ignoreNoEnemies = false)
	{
		local result = __original(pos, ignoreNoEnemies);
		if (result != null) foreach (party in result.Parties)
		{
			local stage = ::$bvvar{namespace}.KanadeBond.campStage(party);
			if (stage == null) continue;
			result.TerrainTemplate = stage.TerrainTemplate;
			break;
		}
		return result;
	};
	q.onCombatFinished = @(__original) function()
	{
		// Award before native ironman autosave. The actor ledger makes the later flush idempotent.
		::$bvvar{namespace}.KanadeBond.awardCombatBond(::$bvvar{namespace}.KanadeBond.combatID() + 1);
		// Native code then increments LastCombatID, settles locations and saves durable reward entitlements.
		local result = __original();
		::$bvvar{namespace}.KanadeBond.finishCombat();
		return result;
	}
});
::$bvvar{namespace}.MH.hook("scripts/items/item_container",function(q){
 q.equip=@(__original) function(item)
 {
  if(item!=null&&"KanadeKey" in item.m&&::$bvvar{namespace}.getActorValkyrieID(this.getActor())!="kanade_tachibana")return false;
  return __original(item);
 };
});
