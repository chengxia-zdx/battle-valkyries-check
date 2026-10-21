// Shared EightValkyries post-armor shield handling recognizes Kind=shield,
// Amount, source() and valid(); Si does not add another damage or skill hook.
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.onInit=@(__original) function(){::$bvvar{namespace}.Si.reset(false);return __original();};
 q.onUpdate=@(__original) function(){local r=__original();::$bvvar{namespace}.Si.refresh();return r;};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.Si.reset();return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.Si.reset(false);return __original(input);};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onMovementFinish=@(__original) function(tile){local r=__original(tile);::$bvvar{namespace}.Si.refresh();return r;};
 q.onTurnEnd=@(__original) function(){local r=__original();::$bvvar{namespace}.Si.refresh();return r;};
 q.onDeath=@(__original) function(killer,skill,tile,fatality){::$bvvar{namespace}.Si.stop(this);local r=__original(killer,skill,tile,fatality);::$bvvar{namespace}.Si.refresh();return r;};
});
