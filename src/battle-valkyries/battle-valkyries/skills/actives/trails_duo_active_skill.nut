this.trails_duo_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={BVTrailsInnate=true,BVOrbalBow=false,BVRadiantAction=null,Spec=null},
 function create(){
  this.valkyrie_active_skill.create();this.m.IsUsingHitchance=true;this.m.IsShowingProjectile=false;
  this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;
  this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=4;
 }
 function onValkyrieSkillBound(d){
  this.m.Spec=d.Spec;local s=d.Spec;this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;
  this.m.MinRange=s.Min;this.m.MaxRange=s.Max;this.m.DirectDamageMult=s.Pierce;
  this.m.IsAttack=s.DamageMin>0;this.m.IsRanged=s.Mode!="scythe"&&s.Mode!="angel";
  this.m.IsWeaponSkill=s.Weapon!="";this.m.IsShieldRelevant=this.m.IsAttack&&!this.m.IsRanged;
  this.m.IsTargeted=s.Max>0;this.m.IsTargetingActor=(s.Radius==0&&s.Mode!="step")||s.Mode=="angel"||s.Mode=="gift";
  this.m.IsAOE=s.Radius>0;this.m.BVOrbalBow=s.Weapon=="alisa_orbal_bow";
 }
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
 function f(){return ::$bvvar{namespace}.TrailsDuo;}
 function isValkyrieWeaponSkillPolicyOptOut(){return true;}
 function friendly(){return this.m.Spec.Mode=="bless"||this.m.Spec.Mode=="gift";}
 function isUsable(){return this.f().available(this,this.actor())==null&&this.skill.isUsable();}
 function getAffectedTiles(tile){return this.m.Spec.Radius==0?[tile]:this.f().api().getValkyrieRadiusTiles(tile,this.m.Spec.Radius,true);}
 function targets(tile){
  local out=[],a=this.actor(),f=this.f();foreach(t in this.getAffectedTiles(tile))if(t.IsOccupiedByActor){
   local b=t.getEntity();if(this.friendly()?(a!=b&&f.combat().ally(a,b)):f.combat().enemy(a,b))out.push(b);
  };return out;
 }
 function onVerifyTarget(origin,tile){
  local a=this.actor(),f=this.f(),d=this.m.Spec;
  if(!f.alive(a)||origin==null||tile==null||!tile.IsVisibleForEntity)return false;
  local dist=origin.getDistanceTo(tile);
  if(dist<d.Min||dist>d.Max||::Math.abs(origin.Level-tile.Level)>4||!origin.hasLineOfSightTo(tile,d.Max))return false;
  if(d.Mode=="step")return tile.IsEmpty&&::Math.abs(origin.Level-tile.Level)<=1&&!a.getCurrentProperties().IsRooted;
  if(d.Mode=="angel"||this.friendly()){
   if(!tile.IsOccupiedByActor)return false;local b=tile.getEntity();
   if(this.friendly()?(a==b||!f.combat().ally(a,b)):!f.combat().enemy(a,b))return false;
  }
  return this.targets(tile).len()>0;
 }
 function onTargetSelected(tile){this.skill.onTargetSelected(tile);if(this.m.IsAOE)foreach(t in this.getAffectedTiles(tile))this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);}
 function getTooltip(){
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}];
  local reason=this.f().available(this,this.actor());if(reason!=null)out.push({id=4,type="text",icon="ui/icons/warning.png",text=reason});
  if(this.m.BVOrbalBow&&this.f().read(this.actor(),"radiance")>0)out.push({id=5,type="text",icon="skills/$bvvar{iconPrefix}/alisa_radiant_resonance.png",text="$bv{trails.radiance}: +25%, +10%"});return out;
 }
 function onUse(a,tile){
  local f=this.f(),d=this.m.Spec,key=this.m.BVSkillKey;
  if(f.available(this,a)!=null||!this.onVerifyTarget(a.getTile(),tile))return false;
  local context=f.action(a,this);
  if(context==null||context.IsFree||context.IsImplicit||context.Source!="managed_active"||f.read(a,"action."+key,"")==context.ActionToken)return false;
  if(d.Mode=="step"){
   a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);::Tactical.getNavigator().teleport(a,tile,null,null,false);
   if(!f.alive(a)||a.getTile().ID!=tile.ID)return false;
   f.ensure(a);f.write(a,"step.active",1);f.write(a,"step.until",f.read(a,"turns")+1);
  }
  f.write(a,"action."+key,context.ActionToken);f.write(a,"cd."+key,f.round()+d.Cooldown);
  f.api().playValkyrieSkillAudio(a,key);f.api().playValkyrieVisual(this,a,key+"_cast");
  if(d.Mode=="step"){f.refresh(a);return true;}
  local radiant=this.m.BVOrbalBow?f.beginBow(a,this):false,impact=false;
  try {
   foreach(b in this.targets(tile)){
    if(!f.alive(a))break;if(!f.alive(b))continue;
    if(this.friendly()){
     local changed=d.Mode=="bless"?f.bless(a,b):f.gift(a,b);
     if(changed)f.api().playValkyrieVisual(this,b,key);continue;
    }
    if(!f.combat().enemy(a,b))continue;
    local marks=f.marks(a,b),position=f.api().captureValkyrieSkillAudioPosition(b),targetTile=b.getTile();
    local hit=this.attackEntity(a,b,false);
    if(!hit)continue;
    // Capture the tile before damage; lethal hits must retain feedback without dereferencing a corpse tile.
    f.api().playValkyrieVisual(this,{getTile=function(){return targetTile;}},key);
    if(!impact&&position!=null){f.api().playValkyrieSkillAudio(a,key+"_impact",position);impact=true;}
    if(!f.alive(a))break;
    if(d.Mode=="scythe"||d.Mode=="angel"){
     local consumed=f.detonate(a,this,b,marks);
     if(key=="renne_death_scythe"&&consumed&&f.api().isActorDeadOrDying(b))f.recover(a,10);
    }
    if(!f.alive(b))continue;
    if(d.Mode=="mark")f.addMark(a,this,b);
    if(d.Mode=="burn")f.burn(a,b);
   }
   if(radiant&&d.Mode=="wings"&&f.alive(a))foreach(t in f.api().getValkyrieRadiusTiles(a.getTile(),3,true))
    if(t.IsOccupiedByActor){local b=t.getEntity();if(b!=a&&f.combat().ally(a,b))f.recover(b,12);}
  }catch(e){this.m.BVRadiantAction=null;throw e;}
  this.m.BVRadiantAction=null;f.refresh(a);return true;
 }
});
