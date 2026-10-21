::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.showCharacterScreen=@(__original) function(_forced=false)
 {
  // Harmonics is a tactical actor, not a roster mercenary with inventory/perks.
  // Reject before vanilla pauses combat to open the character screen.
  if(::$bvvar{namespace}.Kanade.cloneActor(this.Tactical.TurnSequenceBar.getActiveEntity()))return;
  return __original(_forced);
 };
 q.onInit=@(__original) function(){::$bvvar{namespace}.Kanade.reset();::$bvvar{namespace}.KanadeMissions.reset();return __original();};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.KanadeMissions.finish();::$bvvar{namespace}.Kanade.reset();return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/character/character_screen",function(q){
 q.tactical_onQueryBrothersList=@(__original) function()
 {
  local entities=this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
  local k=::$bvvar{namespace}.Kanade,hasClone=false;
  if(entities!=null)foreach(a in entities)if(k.cloneActor(a)){hasClone=true;break;}
  if(!hasClone)return __original();
  // Do not mutate the faction list: clones must keep their own combat turns.
  local active=this.Tactical.TurnSequenceBar.getActiveEntity(),result=[];
  foreach(a in entities)if(!k.cloneActor(a))result.push(this.UIDataHelper.convertEntityToUIData(a,active));
  return result.len()>0?result:null;
 };
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/tactical_entity_manager",function(q){
 q.checkCombatFinished=@(__original) function(force=false)
 {
  local m=::$bvvar{namespace}.KanadeMissions;m.refresh();
  if(m.Battle!=null&&!m.Battle.Done&&!force)
  {
   local players=0;foreach(a in this.getInstancesOfFaction(::Const.Faction.Player))
    if(::$bvvar{namespace}.Kanade.alive(a)&&!::$bvvar{namespace}.Kanade.cloneActor(a)&&!("KanadeMissionUnit" in a.m))players++;
   if(players==0){this.setLastCombatResult(::Const.Tactical.CombatResult.PlayerDestroyed);return __original(true);}
   if(this.getHostilesNum()==0&&m.holdVictory())return;
  }
  return __original(force);
 };
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.Kanade.reset();::$bvvar{namespace}.KanadeMissions.reset();return __original(input);};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onTurnStart=@(__original) function(){::$bvvar{namespace}.KanadeMissions.tick();return __original();};
 q.retreat=@(__original) function(){if(::$bvvar{namespace}.Kanade.owns(this))::$bvvar{namespace}.Kanade.stop(this);return __original();};
});
