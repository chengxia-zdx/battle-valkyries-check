::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onRoundStart=@(__original) function(){local r=__original();::$bvvar{namespace}.HuTaoChallenge.round();return r;};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/tactical_entity_manager",function(q){
 q.checkCombatFinished=@(__original) function(force=false){if(::$bvvar{namespace}.HuTaoChallenge.holdVictory(force))return;return __original(force);};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/tooltip/tooltip_events",function(q){
 q.tactical_queryTileTooltipData=@(__original) function()
 {
  local result=__original(),extra=::$bvvar{namespace}.HuTaoChallenge.tileInfo(::Tactical.State.getLastTileHovered());
  if(extra.len()>0){if(result==null)result=[];result.extend(extra);}
  return result;
 };
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.HuTaoChallenge.end();return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onCombatFinished=@(__original) function(){local r=__original();::$bvvar{namespace}.HuTaoChallenge.Battle=null;return r;};
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.HuTaoChallenge.Battle=null;return __original(input);};
 q.combat_dialog_module_onCancelPressed=@(__original) function(){::$bvvar{namespace}.HuTaoChallenge.Battle=null;return __original();};
});
