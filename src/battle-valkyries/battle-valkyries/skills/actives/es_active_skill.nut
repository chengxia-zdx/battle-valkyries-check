this.es_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,EsAttack=false,Segment=1,Committed=false,Executing=false},
 function f(){return ::$bvvar{namespace}.Es;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function create(){this.valkyrie_active_skill.create();this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;this.m.MaxRangeBonus=0;this.m.IsVisibleTileNeeded=true;},
 function onValkyrieSkillBound(d)
 {
  this.m.Spec=clone d.Spec;local s=this.m.Spec;
  this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.Min;this.m.MaxRange=s.Range;this.m.MaxLevelDifference=s.Key=="breunor"?2:(s.Key=="mordred"||s.Key=="galahad"?3:1);
  this.m.EsAttack=s.Attack;this.m.IsAttack=s.Attack;this.m.IsWeaponSkill=s.Attack;this.m.IsRanged=false;this.m.IsShieldRelevant=s.Attack;
  this.m.IsTargeted=s.Attack;this.m.IsTargetingActor=s.Attack;this.m.IsUsingHitchance=s.Attack;this.m.DirectDamageMult=s.Pierce;
  this.m.SoundOnUse <- s.Attack?["sounds/combat/overhead_strike_01.wav","sounds/combat/overhead_strike_02.wav","sounds/combat/overhead_strike_03.wav"]:[];
 },
 function isUsable(){return !this.m.Executing&&this.f().reason(this.actor(),this.m.BVSkillKey)==null&&this.skill.isUsable();},
 function onVerifyTarget(origin,tile)
 {
  local f=this.f(),a=this.actor(),s=this.m.Spec;
  if(!f.able(a)||origin==null)return false;if(!s.Attack)return true;
  if(tile==null||!tile.IsVisibleForEntity||!tile.IsOccupiedByActor||!f.enemy(a,tile.getEntity())||tile.getEntity().isHiddenToPlayer())return false;
  if(s.Key=="mordred"||s.Key=="galahad")return f.path(a,tile.getEntity())!=null;
  local distance=origin.getDistanceTo(tile);
  return distance>=s.Min&&distance<=s.Range&&::Math.abs(origin.Level-tile.Level)<=this.m.MaxLevelDifference&&(s.Key!="breunor"||origin.hasLineOfSightTo(tile,2));
 },
 function area(a,tile)
 {
  local out=[],origin=a.getTile(),dir=origin.getDirectionTo(tile);
  foreach(d in [dir,(dir+1)%6,(dir+5)%6])if(origin.hasNextTile(d))
  {local t=origin.getNextTile(d);if(t.IsVisibleForEntity&&::Math.abs(t.Level-origin.Level)<=1)out.push(t);}
  return out;
 },
 function onTargetSelected(tile)
 {
  this.skill.onTargetSelected(tile);local a=this.actor(),out=[];if(tile==null||!this.m.Spec.Attack)return;
  if(this.m.Spec.Key=="mordred"||this.m.Spec.Key=="galahad")
  {if(tile!=null&&tile.IsOccupiedByActor){local path=this.f().path(a,tile.getEntity());if(path!=null)out=path;}}
  else if(this.m.Spec.Key=="artorius")out=this.area(a,tile);
  if(tile!=null)out.push(tile);
  out=this.f().crestArea(out,this.m.Spec.CrestRadius);
  foreach(t in out)::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 },
 function use(tile,free=false)
 {
  local a=this.actor();if(a==null||free||!this.isUsable()||!this.isAffordable()||!this.onVerifyTarget(a.getTile(),tile))return false;
  local ap=a.getActionPoints(),fatigue=a.getFatigue();this.m.Committed=false;
  try{local result=this.skill.use(tile,false);if(!result&&!this.m.Committed){a.setActionPoints(ap);a.setFatigue(fatigue);}
 return result;}
  catch(e){if(!this.m.Committed&&this.f().alive(a)){a.setActionPoints(ap);a.setFatigue(fatigue);}
 throw e;}
 },
 function onUse(a,tile)
 {
  local f=this.f(),d=this.m.Spec,s=f.state(a),api=f.api();
  if(this.m.Executing||f.reason(a,this.m.BVSkillKey)!=null||!this.onVerifyTarget(a.getTile(),tile))return false;
  local c=api.getCurrentValkyrieActionContext(a,this);
  if(c==null||c.IsFree||c.IsImplicit||c.Source!="managed_active"||c.ActionToken in s.Actions)return false;
  local route=null,b=d.Attack?tile.getEntity():null;
  if(d.Key=="mordred"||d.Key=="galahad"){route=f.path(a,b);if(route==null)return false;}
  this.m.Committed=true;s.Actions[c.ActionToken]<-true;s.Heat-=d.Heat;
  local enhanced=d.CrestPower>0?f.takeEnhancement(a):false;
  if(d.Key=="bors"){s.Bors=true;f.visual(a.getTile(),"bors_charge");}
  if(d.Key=="percival"){s.PercivalUntil=s.Turn+2;f.visual(a.getTile(),"percival_aura");}
  if(d.Key=="griflet"){s.Guard=true;s.GuardEnhanced=enhanced;s.GuardRound=::Time.getRound();f.visual(a.getTile(),"griflet_guard");}
  if(d.Attack)
  {
   if(route!=null&&route.len()>0)f.move(a,route,this,b,enhanced,c);
   else if(d.Key=="artorius")
   {
    local centers=this.area(a,tile),targets=[],attacked=false;
    foreach(t in centers)if(t.IsOccupiedByActor&&f.enemy(a,t.getEntity()))targets.push(api.makeValkyrieCombatWeakRef(t.getEntity()));
    foreach(ref in targets){if(!f.able(a)||!f.weaponUsable(a))break;if(this.strike(a,api.readValkyrieCombatWeakRef(ref),enhanced,[],c,true))attacked=true;}
    if(attacked)f.plantSkill(a,centers,d,enhanced);
   }
   else this.strike(a,b,enhanced,[],c);
  }
  f.update(a);return true;
 },
 function strike(a,b,enhanced,traversed,context,deferCrest=false)
 {
  local f=this.f(),d=this.m.Spec;
  if(!f.able(a)||!f.weaponUsable(a)||!f.enemy(a,b))return false;
  local distance=a.getTile().getDistanceTo(b.getTile());
  if(d.Key=="breunor"?!this.onVerifyTarget(a.getTile(),b.getTile()):(distance!=1||::Math.abs(a.getTile().Level-b.getTile().Level)>1))return false;
  local targetTile=b.getTile(),tiles=clone traversed;tiles.push(targetTile);
  local cue=d.Key=="breunor"?"breunor_wave":d.Key=="galahad"?"galahad_thrust":["gawain","gawain_charged"].find(d.Key)!=null?"gawain_impact":d.Key=="artorius"?"artorius_slash":"blade_arc";
  this.m.Executing=true;this.m.Segment=1;f.visual(targetTile,cue);
  try
  {
   local hit=this.attackEntity(a,b,false);
   if(d.Heat==0)f.gain(a,15);
   if(!deferCrest)f.plantSkill(a,tiles,d,enhanced);
   if(hit&&(d.Key=="galahad"||d.Key=="artorius")&&f.able(a)&&f.weaponUsable(a)&&f.enemy(a,b)&&b.getTile().ID==targetTile.ID&&a.getTile().getDistanceTo(targetTile)==1)
   {this.m.Segment=2;this.attackEntity(a,b,false);}
  }
  catch(e){this.m.Executing=false;this.m.Segment=1;throw e;}
  this.m.Executing=false;this.m.Segment=1;return true;
 },
 function getTooltip()
 {
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},
   {id=4,type="text",icon="ui/icons/special.png",text=::format("$bv{es.heat_cost}",this.m.Spec.Heat)}];
  local f=this.f(),a=this.actor(),state=f.state(a),d=this.m.Spec;
  if(a!=null&&d.CrestPower>0)
  {
   local mult=f.crestMultiplier(a,d,state!=null&&(state.Bors||f.enhanced(a))),damage=f.damageRange(f.snapshot(a,mult));
   out.push({id=6,type="text",icon="ui/icons/regular_damage.png",text=::format("$bv{es.crest.tooltip}",damage.Min,damage.Max,mult*100.0)});
  }
  local reason=f.reason(a,this.m.BVSkillKey);if(reason!=null)out.push({id=5,type="text",icon="ui/tooltips/warning.png",text=reason});return out;
 }
});
