this.hu_tao_unbind_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 function create()
 {
  this.valkyrie_active_skill.create();this.m.ActionPointCost=2;this.m.FatigueCost=0;this.m.MinRange=1;this.m.MaxRange=1;this.m.MaxLevelDifference=1;
  this.m.IsTargeted=true;this.m.IsTargetingActor=false;this.m.IsAttack=false;this.m.IsVisibleTileNeeded=true;
 },
 function onVerifyTarget(origin,tile){return tile!=null&&origin.getDistanceTo(tile)==1&&::Math.abs(origin.Level-tile.Level)<=1&&::$bvvar{namespace}.HuTaoChallenge.node(tile)!=null;},
 function onUse(a,tile){return ::$bvvar{namespace}.HuTaoChallenge.release(a,tile);},
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.HuTaoChallenge.progress()}];}
});
