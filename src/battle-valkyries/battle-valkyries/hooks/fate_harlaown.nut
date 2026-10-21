::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onMovementStep=@(__original) function(tile,level)
 {
  local f=::$bvvar{namespace}.FateHarlaown,s=f.state(this),from=this.getTile(),ap=this.getActionPoints();
  // Continuous native walking may only call onMovementFinish at the last tile.
  if(s!=null&&s.Walk!=null)
  {
   local previous=s.Walk;s.Walk=null;
   if(s.Move==null&&s.Turn==previous.Turn&&from.ID==previous.Tile)f.moved(this);
  }
  local result=__original(tile,level);
  if(result&&s!=null&&s.Active&&s.Move==null&&this.getActionPoints()<ap&&from.getDistanceTo(tile)==1)
   s.Walk={Tile=tile.ID,Turn=s.Turn};
  return result;
 };
 q.onMovementFinish=@(__original) function(tile)
 {
  local result=__original(tile),f=::$bvvar{namespace}.FateHarlaown,s=f.state(this);
  if(s!=null&&s.Walk!=null)
  {
   local walk=s.Walk;s.Walk=null;
   if(s.Move==null&&s.Turn==walk.Turn&&tile.ID==walk.Tile&&this.getTile().ID==tile.ID)f.moved(this);
  }
  return result;
 };
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.onInit=@(__original) function(){::$bvvar{namespace}.FateHarlaown.reset();return __original();};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.FateHarlaown.reset();return __original();};
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.FateHarlaown.reset();return __original(input);};
});
