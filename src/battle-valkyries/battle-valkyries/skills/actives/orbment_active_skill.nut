this.orbment_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={BVOrbalSpell=true,Spec=null},
 function create()
 {
  this.valkyrie_active_skill.create();this.m.IsWeaponSkill=false;this.m.IsRanged=true;this.m.IsUsingHitchance=true;
  this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;this.m.IsShieldRelevant=false;
  this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=4;
 }
 function onValkyrieSkillBound(d)
 {
  this.m.Spec=d.Spec;local s=d.Spec;this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;
  this.m.MinRange=s.Min;this.m.MaxRange=s.Max;this.m.DirectDamageMult=s.Pierce;
  this.m.IsAttack=s.DamageMin>0 || s.Mode=="weapon" || s.Mode=="disrupt" || s.Mode=="veil";
  this.m.IsRanged=s.Mode!="weapon";this.m.IsWeaponSkill=s.Mode=="weapon";this.m.IsShieldRelevant=s.Mode=="weapon";
  this.m.IsTargeted=s.Max>0;this.m.IsTargetingActor=s.Radius==0 && !s.Line && s.Mode!="warp";this.m.IsAOE=s.Radius>0 || s.Line;
 }
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
 function f(){return ::$bvvar{namespace}.OrbalCombat;}
 function isValkyrieWeaponSkillPolicyOptOut(){return this.m.Spec.Mode!="weapon";}
 function onUpdate(p)
 {
  if(this.m.Spec.Mode!="weapon")return;
  local a=this.actor(),w=a==null?null:a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
  this.m.MinRange=w==null?1:w.getRangeMin();this.m.MaxRange=w==null?1:w.getRangeMax();
  this.m.DirectDamageMult=w==null?0.0:w.m.DirectDamageMult;
 }
 function isUsable(){return this.f().available(this,this.actor())==null && this.skill.isUsable();}
 function friendly(){return ["heal","cleanse","boost","guard","bulwark","haste","zero"].find(this.m.Spec.Mode)!=null;}
 function getAffectedTiles(tile)
 {
  local d=this.m.Spec;
  if(d.Line)return this.f().line(this.actor(),tile,d.Max);
  return d.Radius==0?[tile]:this.f().api().getValkyrieRadiusTiles(tile,d.Radius,true);
 }
 function targets(tile)
 {
  local out=[],a=this.actor(),f=this.f();
  foreach(t in this.getAffectedTiles(tile))if(t.IsOccupiedByActor) {
   local b=t.getEntity();if(this.friendly()?f.ally(a,b):f.enemy(a,b))out.push(b);
  }
  return out;
 }
 function onVerifyTarget(origin,tile)
 {
  local a=this.actor(),f=this.f(),d=this.m.Spec;
  if(!f.alive(a) || origin==null || tile==null || !tile.IsVisibleForEntity)return false;
  local n=origin.getDistanceTo(tile);
  if(n<this.m.MinRange || n>this.m.MaxRange || ::Math.abs(origin.Level-tile.Level)>4)return false;
  if(!origin.hasLineOfSightTo(tile,this.m.MaxRange))return false;
  if(d.Mode=="warp")return tile.IsEmpty && ::Math.abs(origin.Level-tile.Level)<=1 && !a.getCurrentProperties().IsRooted;
  if(d.Line) {
   local line=f.line(a,tile,d.Max),found=false;foreach(t in line)if(t.ID==tile.ID)found=true;
   if(!found)return false;
  }
  local targets=this.targets(tile);if(targets.len()==0)return false;
  if(d.Mode=="haste")return f.read(targets[0],"haste.used")==0;
  return true;
 }
 function onTargetSelected(tile)
 {
  this.skill.onTargetSelected(tile);
  if(this.m.IsAOE)foreach(t in this.getAffectedTiles(tile))this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 }
 function getTooltip()
 {
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}],a=this.actor(),d=this.m.Spec;
  local reason=this.f().available(this,a);if(reason!=null)out.push({id=4,type="text",icon="ui/icons/warning.png",text=reason});
  if(d.Limit>0 && a!=null)out.push({id=5,type="text",text="$bv{orbment.uses} "+this.f().read(a,"uses."+this.m.BVSkillKey)+"/"+d.Limit});
  if(this.m.IsAttack && a!=null && this.getContainer()!=null) {
   local p=this.getContainer().buildPropertiesForUse(this,null);
   if("BVOrbalPenetration" in p)out.push({id=6,type="text",text="$bv{orbment.penetration} "+::Math.round(p.BVOrbalPenetration*100)+"% | $bv{orbment.overflow} "+::Math.round(::Math.maxf(0.0,p.BVOrbalPenetration-1.0)*100)+"%"});
  }
  return out;
 }
 function onUse(a,tile)
 {
  local f=this.f(),d=this.m.Spec,key=this.m.BVSkillKey;
  if(f.available(this,a)!=null || !this.onVerifyTarget(a.getTile(),tile))return false;
  local context=f.api().getCurrentValkyrieActionContext(a,this);
  if(context==null || context.IsFree || context.IsImplicit || context.Source!="managed_active")return false;
  if(f.read(a,"last_action."+key,"")==context.ActionToken)return false;
  f.write(a,"last_action."+key,context.ActionToken);
  f.write(a,"cd."+key,f.round()+d.Cooldown);f.write(a,"uses."+key,f.read(a,"uses."+key)+1);
  f.presentation(this,a,key);
  if(d.Mode=="warp") {
   f.api().playValkyrieVisual(this,a,key);a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
   ::Tactical.getNavigator().teleport(a,tile,null,null,false);return true;
  }
  foreach(b in this.targets(tile)) {
   if(!f.alive(a))break;if(!f.alive(b))continue;
   if(this.friendly()) {
    if(!f.ally(a,b))continue;
    local changed=true;
    if(d.Mode=="heal" || d.Mode=="cleanse") {local before=b.getHitpoints();f.heal(a,b,d.Mode=="heal"?25:20);changed=b.getHitpoints()>before;if(d.Mode=="cleanse"){local cleaned=f.cleanse(b);changed=changed||cleaned;}}
    else if(d.Mode=="zero")f.apply(b,"zero",2,3);
    else if(d.Mode=="haste") {if(f.read(b,"haste.used")!=0)continue;f.write(b,"haste.used",1);f.apply(b,"haste",1);}
    else {f.apply(b,d.Mode,1);if(d.Mode=="boost")f.recover(b,10);}
    if("TrailsDuo" in f.api())f.api().TrailsDuo.support(a,b,changed);
    f.api().playValkyrieVisual(this,b,key);continue;
   }
   if(!f.enemy(a,b))continue;
   if(d.Mode=="analyze") {f.apply(b,"analysis",1,3);f.api().playValkyrieVisual(this,b,key);continue;}
   // Visual is emitted while the target tile still exists, including lethal hits.
   f.api().playValkyrieVisual(this,b,key);
   local hit=this.attackEntity(a,b,false);
   if(hit && "TrailsDuo" in f.api())f.api().TrailsDuo.addMark(a,this,b);
   if(!hit || !f.alive(b))continue;
   if(d.Mode=="frost") {
    local p=b.getCurrentProperties();
    if(!("IsImmuneToFreeze" in p && p.IsImmuneToFreeze) && !("IsImmuneToCold" in p && p.IsImmuneToCold))f.apply(b,"chill",1,2);
   }
   if(d.Mode=="disrupt" || d.Mode=="veil")if(f.api().FiveValkyries.canDebuff(b))f.apply(b,d.Mode,1);
  }
  if(f.alive(a)){a.getSkills().update();a.setDirty(true);}
  return true;
 }
});

