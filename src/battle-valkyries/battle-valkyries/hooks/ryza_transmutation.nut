// Movement is charged once at the native per-tile boundary. No attack hook.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
 q.onMovementStep = @(__original) function(tile, level)
 {
  local s=this.getSkills().getSkillByID("$bvvar{modId}.trait.ryza_augmentation"), rebate=0;
  if(s!=null && s.m.InCombat && !s.m.Moved && s.has("stride") && !this.getCurrentProperties().IsStunned && !this.getCurrentProperties().IsRooted)
  {
   local p=this.getCurrentProperties(),cost=::Math.max(1,(this.m.ActionPointCosts[tile.Type]+p.MovementAPCostAdditional)*p.MovementAPCostMult)+(level!=0?this.m.LevelActionPointCost:0);
   if(cost>1)rebate=1;
  }
  this.m.ActionPoints+=rebate;local result=false;
  try {result=__original(tile,level);} catch(e){this.m.ActionPoints-=rebate;throw e;}
  if(!result)this.m.ActionPoints-=rebate;
  if(result && s!=null){s.m.MoveUndo={Tile=tile,Rebate=rebate,WasMoved=s.m.Moved};s.m.Moved=true;this.getSkills().update();}
  return result;
 }
 q.onMovementUndo = @(__original) function(tile, level)
 {
  local result=__original(tile,level),s=this.getSkills().getSkillByID("$bvvar{modId}.trait.ryza_augmentation");
  if(s!=null && s.m.MoveUndo!=null && s.m.MoveUndo.Tile==tile)
  {this.m.ActionPoints-=s.m.MoveUndo.Rebate;s.m.Moved=s.m.MoveUndo.WasMoved;s.m.MoveUndo=null;this.getSkills().update();}
  return result;
 }
 q.getActionPointCosts = @(__original) function()
 {
  local costs=__original(),s=this.getSkills().getSkillByID("$bvvar{modId}.trait.ryza_augmentation");
  if(s!=null && s.m.InCombat && !s.m.Moved && s.has("stride")){costs=clone costs;foreach(i,c in costs)costs[i]=::Math.max(1,c-1);}
  return costs;
 }
});
::$bvvar{namespace}.MH.hook("scripts/skills/special/night_effect", function(q) {
 q.onUpdate = @(__original) function(p)
 {
  local f=::$bvvar{namespace}.RyzaTransmutation,a=this.getContainer().getActor();
  if(!f.has(a,"night"))return __original(p);
  local vision=p.Vision,ranged=p.RangedSkillMult;__original(p);p.Vision=vision;p.RangedSkillMult=ranged;
 }
});
::$bvvar{namespace}.MH.hook("scripts/skills/effects/stunned_effect", function(q) {
 q.onAdded = @(__original) function()
 {
  local a=this.getContainer().getActor(),f=::$bvvar{namespace}.RyzaTransmutation;
  if(!f.has(a,"nerve"))return __original();
  local p=a.getCurrentProperties();if(p.IsImmuneToStun || ::Math.rand(1,100)<=50){this.m.IsGarbage=true;return;}
  // Merge the vanilla 33/50% resistances into this single 50% roll.
  local any=p.IsResistantToAnyStatuses,physical=p.IsResistantToPhysicalStatuses;
  p.IsResistantToAnyStatuses=false;p.IsResistantToPhysicalStatuses=false;
  try {__original();}catch(e){p.IsResistantToAnyStatuses=any;p.IsResistantToPhysicalStatuses=physical;throw e;}
  p.IsResistantToAnyStatuses=any;p.IsResistantToPhysicalStatuses=physical;
 }
});
