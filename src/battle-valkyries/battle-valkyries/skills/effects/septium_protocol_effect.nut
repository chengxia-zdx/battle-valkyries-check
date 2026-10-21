this.septium_protocol_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill",{
 m={MarkedTiles=[]},
 function create(){
  this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.septium_protocol";
  this.m.Name="$bv{orbment.enemy.status}";this.m.Description="$bv{orbment.enemy.status_description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/orbment_space_barrier.png";
 },
 function actor(){return this.getContainer().getActor();},
 function element(){return this.actor().getFlags().get("BVSeptiumElement");},
 function restoreWarning(){
  local a=this.actor(),f=a.getFlags();
  if(this.m.MarkedTiles.len()>0 || !a.isPlacedOnMap() || !f.has("BVSeptiumBlastRound") || f.get("BVSeptiumBlastRound")<=0)return;
  local tile=::Tactical.getTileSquare(f.get("BVSeptiumBlastX"),f.get("BVSeptiumBlastY")),owner=a.getID().tostring();
  foreach(t in ::$bvvar{namespace}.getValkyrieRadiusTiles(tile,1,true)){
   if(!("BVSeptiumWarnings" in t.Properties)){
    t.Properties.BVSeptiumWarnings <- {};
    t.Properties.BVSeptiumPreviousImpact <- t.Properties.IsMarkedForImpact;
   }
   local first=!(owner in t.Properties.BVSeptiumWarnings);
   t.Properties.BVSeptiumWarnings[owner] <- true;t.Properties.IsMarkedForImpact=true;
   if(first && t.Properties.BVSeptiumWarnings.len()==1)t.spawnDetail("mortar_target_02",::Const.Tactical.DetailFlag.SpecialOverlay,false,true);
   this.m.MarkedTiles.push(t);
  }
 },
 function clearWarning(){
  local owner=this.actor().getID().tostring();
  foreach(t in this.m.MarkedTiles){
   if(!("BVSeptiumWarnings" in t.Properties))continue;
   if(owner in t.Properties.BVSeptiumWarnings)delete t.Properties.BVSeptiumWarnings[owner];
   if(t.Properties.BVSeptiumWarnings.len()==0){
    t.Properties.IsMarkedForImpact=t.Properties.BVSeptiumPreviousImpact;
    if(!t.Properties.IsMarkedForImpact)t.clear(::Const.Tactical.DetailFlag.SpecialOverlay);
    delete t.Properties.BVSeptiumWarnings;delete t.Properties.BVSeptiumPreviousImpact;
   }
  }
  this.m.MarkedTiles.clear();
 },
 function onDeath(fatality){this.clearWarning();this.actor().getFlags().set("BVSeptiumBlastRound",0);},
 function onResumeTurn(){this.restoreWarning();},
 function allies(){
  local a=this.actor(),out=[];
  foreach(group in ::Tactical.Entities.getAllInstances())foreach(b in group)
   if(b!=null && a.isAlliedWith(b) && !::$bvvar{namespace}.isActorDeadOrDying(b) && b.isPlacedOnMap())out.push(b);
  return out;
 },
 function enemies(){
  local a=this.actor(),out=[];
  foreach(group in ::Tactical.Entities.getAllInstances())foreach(b in group)
   if(b!=null && !a.isAlliedWith(b) && b.isPlayerControlled() && !::$bvvar{namespace}.isActorDeadOrDying(b) && b.isPlacedOnMap())out.push(b);
  return out;
 },
 function onUpdate(p){
  this.restoreWarning();
  local e=this.element();
  if(e=="earth"){p.MeleeDefense+=10;p.RangedDefense+=10;}
  if(e=="fire")p.DamageTotalMult*=1.2;
  if(e=="wind"){p.Initiative+=30;p.MovementAPCostAdditional-=1;}
  if(e=="space")p.RangedSkill+=15;
  if(e=="time")p.Initiative+=15;
  p.IsImmuneToBleeding=true;p.IsImmuneToPoison=true;p.IsAffectedByNight=false;
 },
 function onBeforeDamageReceived(attacker,skill,hit,p){
  if(!::$bvvar{namespace}.isDirectAttack(skill))return;
  if(this.element()=="earth")p.DamageReceivedRegularMult*=0.85;
  if(this.actor().getFlags().get("BVSeptiumRole")=="overseer")foreach(b in this.allies())
   if(b.getFlags().get("BVSeptiumRole")=="relay")p.DamageReceivedRegularMult*=0.8;
 },
 function onTurnStart(){
  local a=this.actor(),f=a.getFlags(),round=::Time.getRound();
  if(!::$bvvar{namespace}.FiveValkyries.normal(a) || (f.has("BVSeptiumRound") && f.get("BVSeptiumRound")==round))return;
  f.set("BVSeptiumRound",round);
  if(f.get("BVSeptiumRole")=="relay"){
   if(this.element()=="water")foreach(b in this.allies())if(a.getTile().getDistanceTo(b.getTile())<=3)b.setHitpoints(::Math.min(b.getHitpointsMax(),b.getHitpoints()+12));
   if(this.element()=="time" || this.element()=="mirage")foreach(b in this.enemies())if(a.getTile().getDistanceTo(b.getTile())<=3)
    ::$bvvar{namespace}.OrbalCombat.apply(b,this.element()=="time"?"chill":"disrupt",1,this.element()=="time"?2:0);
  }
  if(f.get("BVSeptiumRole")!="overseer")return;
  if(f.has("BVSeptiumBlastRound") && f.get("BVSeptiumBlastRound")>0 && round>=f.get("BVSeptiumBlastRound")){
   local tile=::Tactical.getTileSquare(f.get("BVSeptiumBlastX"),f.get("BVSeptiumBlastY"));
   local skill=a.getSkills().getSkillByID("$bvvar{modId}.enemy_skill.septium_blast");
   this.clearWarning();f.set("BVSeptiumBlastRound",0);if(skill!=null)skill.blast(tile);a.setActionPoints(0);return;
  }
  local target=null,distance=99;
  foreach(b in this.enemies()){local n=a.getTile().getDistanceTo(b.getTile());if(n<distance&&n<=6){target=b;distance=n;}}
  if(target==null)return;
  local tile=target.getTile();f.set("BVSeptiumBlastX",tile.SquareCoords.X);f.set("BVSeptiumBlastY",tile.SquareCoords.Y);f.set("BVSeptiumBlastRound",round+1);
  this.restoreWarning();
  ::$bvvar{namespace}.playValkyrieVisual(this,target,"orbment_flame_gale");
  ::Tactical.EventLog.log("$bv{orbment.enemy.charging}");a.setActionPoints(0);
 }
});
