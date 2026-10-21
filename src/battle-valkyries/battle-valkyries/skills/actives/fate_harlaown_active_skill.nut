this.fate_harlaown_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,Boost=null,Committed=false,Executing=false},
 function f(){return ::$bvvar{namespace}.FateHarlaown;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function create()
 {
  this.valkyrie_active_skill.create();this.m.IsWeaponSkill=false;this.m.IsShowingProjectile=false;
  this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;
  this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=4;
 },
 function onValkyrieSkillBound(d)
 {
  this.m.Spec=clone d.Spec;local s=this.m.Spec;
  this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.Min;this.m.MaxRange=s.Range;
  this.m.IsAttack=s.Attack;this.m.IsRanged=s.Ranged;this.m.IsTargeted=this.m.BVSkillKey!="fate_form";
  this.m.IsTargetingActor=s.Attack&&this.m.BVSkillKey!="fate_zanber";
  this.m.IsUsingHitchance=s.Attack;this.m.IsShieldRelevant=s.Attack;this.m.DirectDamageMult=s.Pierce;
 },
 function isValkyrieWeaponSkillPolicyOptOut(){return true;},
 function onAfterUpdate(p){this.m.ActionPointCost=this.m.BVSkillKey=="fate_move"&&this.f().form(this.actor())?1:this.m.Spec.AP;},
 function isHidden(){return this.m.BVSkillKey=="fate_scythe"&&this.f().form(this.actor());},
 function isUsable(){return !this.m.Executing&&this.f().reason(this.actor(),this.m.BVSkillKey)==null&&this.skill.isUsable();},
 function onVerifyTarget(origin,tile)
 {
  local f=this.f(),a=this.actor(),d=this.m.Spec,k=this.m.BVSkillKey;
  if(!f.able(a)||origin==null)return false;
  if(k=="fate_form")return true;
  if(tile==null||!tile.IsVisibleForEntity)return false;
  if(k=="fate_move")return f.path(a,tile)!=null;
  if(k=="fate_zanber")
  {
   foreach(t in f.ray(a,tile))if(t.IsOccupiedByActor&&f.enemy(a,t.getEntity()))return true;
   return false;
  }
  local distance=origin.getDistanceTo(tile);
  return tile.IsOccupiedByActor&&distance>=d.Min&&distance<=d.Range&&::Math.abs(origin.Level-tile.Level)<=4
   &&origin.hasLineOfSightTo(tile,d.Range)&&f.enemy(a,tile.getEntity());
 },
 function onTargetSelected(tile)
 {
  this.skill.onTargetSelected(tile);local tiles=[];
  if(this.m.BVSkillKey=="fate_move"){local path=this.f().path(this.actor(),tile);if(path!=null)tiles=path;}
  else if(this.m.BVSkillKey=="fate_zanber")tiles=this.f().ray(this.actor(),tile);
  foreach(t in tiles)::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 },
 // Vanilla charges before onUse. A rejected commit must restore exactly that snapshot.
 function use(tile,free=false)
 {
  local a=this.actor();if(a==null||!this.isUsable())return false;
  local ap=a.getActionPoints(),fatigue=a.getFatigue();this.m.Committed=false;
  try
  {
   local result=this.skill.use(tile,free);
   if(!result&&!this.m.Committed&&!free){a.setActionPoints(ap);a.setFatigue(fatigue);}
   return result;
  }
  catch(e)
  {
   if(!this.m.Committed&&!free&&this.f().alive(a)){a.setActionPoints(ap);a.setFatigue(fatigue);}
   throw e;
  }
 },
 function onUse(a,tile)
 {
  local f=this.f(),key=this.m.BVSkillKey,s=f.state(a),d=this.m.Spec;
  if(this.m.Executing||f.reason(a,key)!=null||!this.onVerifyTarget(a.getTile(),tile))return false;
  local c=f.api().getCurrentValkyrieActionContext(a,this);
  if(c==null||c.IsFree||c.IsImplicit||c.Source!="managed_active"||c.ActionToken in s.Actions)return false;
  if(key=="fate_move")
  {
   local route=f.path(a,tile);if(route==null||!f.beginMove(a,route))return false;
   this.m.Committed=true;s.Actions[c.ActionToken]<-true;return true;
  }
  if(key=="fate_form")
  {
   if(!f.beginForm(a))return false;
   this.m.Committed=true;s.Actions[c.ActionToken]<-true;return true;
  }
  local targets=[];
  if(key=="fate_zanber")foreach(t in f.ray(a,tile)){if(t.IsOccupiedByActor)targets.push({Actor=f.api().makeValkyrieCombatWeakRef(t.getEntity()),Tile=t});}
  else targets.push({Actor=f.api().makeValkyrieCombatWeakRef(tile.getEntity()),Tile=tile});
  if(targets.len()==0)return false;
  this.m.Committed=true;this.m.Executing=true;s.Actions[c.ActionToken]<-true;
  this.m.Boost=s.Charged;s.Charged=false;s.Cooldowns[key]<-d.Cooldown;
  f.visual(a,a.getTile(),"cast");
  try
  {
   foreach(index,rec in targets)
   {
    if(!f.able(a))break;
    local b=f.api().readValkyrieCombatWeakRef(rec.Actor);
    if(!f.enemy(a,b)||b.getTile().ID!=rec.Tile.ID)continue;
    // Rebuild the ray after each hit: a new friendly blocker must stop the finisher.
    if(key=="fate_zanber")
    {
     local reachable=false;foreach(t in f.ray(a,rec.Tile))if(t.ID==rec.Tile.ID)reachable=true;
     if(!reachable)break;
    }
    for(local n=0;n<d.Strikes;n++)
    {
     if(!f.able(a)||!f.enemy(a,b)||b.getTile().ID!=rec.Tile.ID||a.getTile().getDistanceTo(rec.Tile)>d.Range)break;
     if(!a.getTile().hasLineOfSightTo(rec.Tile,d.Range))break;
     local cue=key=="fate_scythe"?"slash":(key=="fate_blade"?"twin":(key=="fate_lancer"?"lance":"zanber"));
     // Capture the tile before lethal damage. Only cosmetics are delayed, never attacks.
     f.visual(a,rec.Tile,cue,n*100+index*75);
     local hit=this.attackEntity(a,b,false);
     if(hit)f.visual(a,rec.Tile,"impact",n*100+index*75+50);
    }
   }
  }
  catch(e){this.m.Boost=null;this.m.Executing=false;if(key=="fate_zanber")f.endForm(a);throw e;}
  this.m.Boost=null;this.m.Executing=false;if(key=="fate_zanber")f.endForm(a);f.update(a);return true;
 },
 function getTooltip()
 {
  local f=this.f(),a=this.actor(),s=f.state(a),reason=f.reason(a,this.m.BVSkillKey);
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
   {id=3,type="text",text=this.getCostString()},
   {id=4,type="text",icon="ui/icons/action_points.png",text="$bv{fate.cooldown}"+f.cooldown(a,this.m.BVSkillKey)}];
  if(s!=null&&s.Charged)out.push({id=5,type="text",icon="ui/icons/special.png",text="$bv{fate.charged}"});
  if(reason!=null)out.push({id=6,type="text",icon="ui/tooltips/warning.png",text=reason});return out;
 },
 function onRemoved(){local f=this.f(),s=f.state(this.actor());if(this.m.BVSkillKey=="fate_move"&&s!=null&&s.Move!=null)f.finishMove(s.Move);}
});
