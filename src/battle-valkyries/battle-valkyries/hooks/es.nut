::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.onInit=@(__original) function(){::$bvvar{namespace}.Es.reset();return __original();};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.Es.reset();return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.Es.reset();return __original(input);};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.retreat=@(__original) function(){if(::$bvvar{namespace}.Es.owns(this))::$bvvar{namespace}.Es.stop(this);return __original();};
 // removeFromMap is native; Modern Hooks wraps the script lifecycle callback.
 q.onRemovedFromMap=@(__original) function(){if(::$bvvar{namespace}.Es.owns(this))::$bvvar{namespace}.Es.stop(this);return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/ai/tactical/behavior",function(q){
 q.hasNegativeTileEffect=@(__original) function(tile,entity){return __original(tile,entity)||::$bvvar{namespace}.Es.danger(tile,entity);};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/tooltip/tooltip_events",function(q){
 q.tactical_queryTileTooltipData=@(__original) function()
 {
  local ret=__original(),tile=::Tactical.State.getLastTileHovered();if(tile==null)return ret;
  local extra=::$bvvar{namespace}.Es.tileInfo(tile);if(extra.len()>0){if(ret==null)ret=[];ret.extend(extra);}
 return ret;
 };
});
::$bvvar{namespace}.MH.hook("scripts/items/item_container",function(q){
 q.onDamageDealt=@(__original) function(target,skill,info)
 {
  if(skill!=null&&"EsAuxiliary" in skill.m&&skill.m.EsAuxiliary&&!skill.m.EsCounter)return;
  return __original(target,skill,info);
 };
});
// Native callbacks can launch perks independently of the shared combat event bus.
// Keep damage/kill attribution in the actor pipeline, suppress attacker proc chains only.
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q){
 q.onTargetHit=@(__original) function(skill,target,part,hp,armor)
 {
  if(skill!=null&&"EsAuxiliary" in skill.m&&skill.m.EsAuxiliary)
  {::$bvvar{namespace}.markValkyrieLegacyTargetResult(skill,target,true,part,hp,armor);return;}
  return __original(skill,target,part,hp,armor);
 };
 q.onTargetMissed=@(__original) function(skill,target)
 {
  if(skill!=null&&"EsAuxiliary" in skill.m&&skill.m.EsAuxiliary){::$bvvar{namespace}.markValkyrieLegacyTargetResult(skill,target,false);return;}
  return __original(skill,target);
 };
 q.onBeforeTargetHit=@(__original) function(skill,target,info)
 {
  if(skill!=null&&"EsAuxiliary" in skill.m&&skill.m.EsAuxiliary)return;
  return __original(skill,target,info);
 };
 q.onTargetKilled=@(__original) function(target,skill)
 {
  if(skill!=null&&"EsAuxiliary" in skill.m&&skill.m.EsAuxiliary)return;
  return __original(target,skill);
 };
});
