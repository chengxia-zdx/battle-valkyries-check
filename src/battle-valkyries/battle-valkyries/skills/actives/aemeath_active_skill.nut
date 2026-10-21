this.aemeath_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,AttackMult=null,UltimateMarks=null,WeaponRoll=null},
 function create(){
  this.valkyrie_active_skill.create();this.m.IsAttack=true;this.m.IsRanged=false;this.m.IsWeaponSkill=true;
  this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsUsingHitchance=true;this.m.IsShieldRelevant=true;
  this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;
  this.m.MaxRangeBonus=0;this.m.MinRange=1;this.m.MaxLevelDifference=4;
 },
 function onValkyrieSkillBound(d){this.m.Spec=d.Spec;this.m.ActionPointCost=d.Spec.AP;this.m.FatigueCost=d.Spec.Fatigue;this.m.MaxRange=d.Spec.Range;this.m.IsAOE=d.Spec.Targets>1;},
 function f(){return ::$bvvar{namespace}.Aemeath;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function isValkyrieWeaponSkillPolicyOptOut(){return true;},
 // Preserve native getItem(): character UI requires the WeakTableRef made by setItem.
 function onAfterUpdate(p){local w=this.f().weapon(this.actor());this.setItem(w);this.m.DirectDamageMult=w==null?0:w.m.DirectDamageMult;},
 function isUsable(){return this.f().available(this,this.actor())==null&&this.skill.isUsable();},
 function onVerifyTarget(origin,tile){
  if(origin==null||tile==null||!tile.IsVisibleForEntity||!tile.IsOccupiedByActor)return false;
  local d=origin.getDistanceTo(tile);return d>=1&&d<=this.m.Spec.Range&&::Math.abs(origin.Level-tile.Level)<=4&&origin.hasLineOfSightTo(tile,this.m.Spec.Range)&&this.f().enemy(this.actor(),tile.getEntity());
 },
 function onTargetSelected(tile){this.skill.onTargetSelected(tile);if(this.m.IsAOE)foreach(b in this.f().targets(this,tile)){local t=b.getTile();::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);}},
 function getTooltip(){
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}];
  local f=this.f(),s=f.state(this.actor()),reason=f.available(this,this.actor());
  if(s!=null)out.push({id=4,type="text",icon="ui/icons/special.png",text="$bv{aemeath.sync}: "+s.m.Sync+"/6 | $bv{aemeath.resonance}: "+s.m.Resonance+"/6"});
  if(reason!=null)out.push({id=5,type="text",icon="ui/tooltips/warning.png",text=reason});return out;
 },
 function strike(a,b,mult){
  local f=this.f();if(!f.alive(a)||!f.enemy(a,b))return false;
  this.m.AttackMult=mult;
  local before=::$bvvar{namespace}.getValkyrieDamageSnapshot(b);
  this.attackEntity(a,b,false);
  local delta=::$bvvar{namespace}.getValkyrieDamageDelta(b,before);return delta.Hitpoints+delta.Armor>0;
 },
 function onUse(a,tile){
  local f=this.f(),d=this.m.Spec,key=this.m.BVSkillKey;
  if(f.available(this,a)!=null||!this.onVerifyTarget(a.getTile(),tile))return false;
  local context=f.action(a,this),s=f.state(a);
  if(context==null||context.IsFree||context.IsImplicit||context.Source!="managed_active")return false;
  local targets=f.targets(this,tile);if(targets.len()==0)return false;
  // Native use has paid AP, but ActionStarted is normally deferred until the
  // first attack. Commit now to snapshot form/resources before spending them.
  f.api().commitValkyrieAction(context);
  local action=f.record(a,this);if(action==null||action.Paid)return false;
  action.Paid=true;s.m.Sync-=d.Sync;s.m.Resonance-=d.Resonance;
  this.m.DirectDamageMult=f.weapon(a).m.DirectDamageMult;
  this.m.UltimateMarks=key=="aemeath_ultimate"?f.totalMarks(a):null;
  this.m.WeaponRoll=key=="aemeath_ultimate"?::Math.rand(::Math.floor(a.getCurrentProperties().DamageRegularMin).tointeger(),::Math.floor(a.getCurrentProperties().DamageRegularMax).tointeger()):null;
  local cue=key.slice(8),impactPlayed=false;
  f.sound(a,cue);f.visual(this,a,cue+"_cast");
  try{
   foreach(index,b in targets){
    if(!f.alive(a))break;if(!f.enemy(a,b))continue;
    local id=f.id(b),snapshot=id in action.Snapshot?action.Snapshot[id]:{Syntony=0,Fusion=0};
    local targetTile=b.getTile(),pos=::$bvvar{namespace}.captureValkyrieSkillAudioPosition(b),anchor={getTile=function(){return targetTile;}};
    f.visual(this,anchor,"lock");
    local mult=key=="aemeath_ultimate"&&index>0?1.25:d.Mult;
    if(!this.strike(a,b,mult))continue;
    f.visual(this,anchor,cue+"_hit");
    if(!impactPlayed){f.sound(a,cue+"_impact",pos);impactPlayed=true;}
    if(!f.alive(a)||!f.enemy(a,b))continue;
    if(key=="aemeath_starlight")f.add(a,b,"syntony",2);
    if(key=="aemeath_armament")f.add(a,b,"fusion",1);
    if(key=="aemeath_melody")f.add(a,b,"fusion",2);
    if(key=="aemeath_dawn")f.add(a,b,"syntony",1);
    local follow=key=="aemeath_starlight"&&snapshot.Fusion>0?"fusion":(key=="aemeath_melody"&&snapshot.Syntony>0?"syntony":null);
    if(follow!=null&&f.consume(b,follow)){
     f.visual(this,anchor,"followup");
     if(this.strike(a,b,d.Mult))f.visual(this,anchor,follow=="fusion"?"fusion_tick":"resonance_hit");
    }
   }
   if(f.alive(a)){
    if(key=="aemeath_armament")f.changeForm(a,"mech");
    else if(key=="aemeath_dawn")f.changeForm(a,"ghost");
    else if(key=="aemeath_ultimate")f.changeForm(a,"ghost",false);
   }
  }catch(e){this.m.AttackMult=null;this.m.WeaponRoll=null;this.m.UltimateMarks=null;throw e;}
  this.m.AttackMult=null;this.m.WeaponRoll=null;this.m.UltimateMarks=null;f.refresh(a);return true;
 }
});
