// Actor lifecycle only; attack properties use the existing shared container route.
local bv=::$bvvar{namespace};
bv.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onTurnStart=@(__original) function(){local result=__original();::$bvvar{namespace}.TrailsDuo.startTurn(this);return result;};
 q.onTurnEnd=@(__original) function(){
  // This persisted normal-turn flag also works when a mid-turn save is reloaded.
  local bv=::$bvvar{namespace},normal=bv.TrailsDuo.read(this,"turn_active")>0&&bv.FiveValkyries.normal(this);
  local result=__original();if(normal)bv.TrailsDuo.endTurn(this);return result;
 };
 q.onDeserialize=@(__original) function(input){__original(input);::$bvvar{namespace}.TrailsDuo.restore(this);};
});
bv.MH.hook("scripts/entity/tactical/player",function(q){
 q.onCombatStart=@(__original) function(){::$bvvar{namespace}.TrailsDuo.reset(this);return __original();};
 q.onCombatFinished=@(__original) function(){local result=__original();::$bvvar{namespace}.TrailsDuo.reset(this);return result;};
});
