::$bvvar{namespace}.MH.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar",function(q){
 q.convertEntityToUIData=@(__original) function(entity,isLastEntity=false){
  local data=__original(entity,isLastEntity);
  data.BVRachel <- !data.isEnemy&&!data.isHiddenToPlayer?::$bvvar{namespace}.Rachel.hud(entity):null;
  return data;
 };
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.onInit=@(__original) function(){::$bvvar{namespace}.Rachel.reset();return __original();};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.Rachel.reset();return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.Rachel.reset();return __original(input);};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.retreat=@(__original) function(){if(::$bvvar{namespace}.Rachel.owns(this))::$bvvar{namespace}.Rachel.stop(this);return __original();};
 // removeFromMap is native; Modern Hooks wraps the script lifecycle callback.
 q.onRemovedFromMap=@(__original) function(){if(::$bvvar{namespace}.Rachel.owns(this))::$bvvar{namespace}.Rachel.stop(this);return __original();};
 q.onTurnStart=@(__original) function(){local r=__original();::$bvvar{namespace}.Rachel.fieldEvent(this);return r;};
 q.onMovementStep=@(__original) function(tile,level){local r=__original(tile,level);if(r)::$bvvar{namespace}.Rachel.fieldEvent(this,tile);return r;};
 q.onMovementFinish=@(__original) function(tile){local r=__original(tile);::$bvvar{namespace}.Rachel.fieldEvent(this);return r;};
});
