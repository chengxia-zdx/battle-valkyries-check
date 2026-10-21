// Actor-owned, battle-scoped ledger. Rebinding a managed skill never refills it.
::$bvvar{namespace}.HuTao <- {
 Owners=[], Epoch=0,
 Negatives=["effects.stunned","effects.dazed","effects.net","effects.rooted","effects.web","effects.disarmed","effects.goblin_poison","effects.spider_poison","effects.poison","effects.bleeding","effects.overwhelmed","effects.distracted"],
 function api(){return ::$bvvar{namespace};},
 function owns(a){return a!=null&&a.isPlayerControlled()&&this.api().getActorValkyrieID(a)=="hu_tao";},
 function alive(a){return a!=null&&!this.api().isActorDeadOrDying(a)&&a.isPlacedOnMap();},
 function able(a){return this.owns(a)&&this.api().EightValkyries.able(a);},
 function normal(a){return this.api().EightValkyries.normal(a);},
 function enemy(a,b){return this.alive(a)&&this.alive(b)&&!a.isAlliedWith(b)&&b.isAttackable();},
 function state(a){return a!=null&&"BVHuTaoState" in a.m?a.m.BVHuTaoState:null;},
 function upgraded(a,n){local t=a==null?null:a.getSkills().getSkillByID(this.api().HuTaoBondTraitID);return this.owns(a)&&t!=null&&t.hasTriggeredStage(n);},
 function low(a){return a.getHitpoints()*2<=a.getHitpointsMax();},
 function dance(a){local s=this.state(a);return s!=null&&s.Active&&s.DanceUntil>=s.Turn&&s.DanceUntil>0;},
 function protected(a){local s=this.state(a);return s!=null&&s.Active&&s.InvulnerableUntil>0&&s.Ended<s.InvulnerableUntil;},
 function reborn(a){local s=this.state(a);return s!=null&&s.Active&&s.BuffUntil>0&&s.Ended<s.BuffUntil;},
 function update(a){if(a!=null&&!this.api().isActorDeadOrDying(a)){a.getSkills().update();a.setDirty(true);}},
 function weapon(a){if(a==null)return null;local w=a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);return w!=null&&w.getCondition()>0&&this.api().BlackBeast.weaponCategory(w,"polearm")?w:null;},
 function start(a)
 {
  if(!this.owns(a)||!this.alive(a))return;
  if(this.state(a)!=null)return;
  a.m.BVHuTaoState <- {Active=true,Turn=0,Ended=0,LastRound=-1,DanceUntil=0,SnapshotHP=0,ERound=-1,DashRound=-1,Dashes=0,Guard=false,GuardRound=-1,QReady=0,DeathUsed=false,InvulnerableUntil=0,BuffUntil=0,Actions={},Move=null,Marks=[]};
  this.Owners.push(this.api().makeValkyrieCombatWeakRef(a));
  this.feedback(a);
 },
 function feedback(a)
 {
  foreach(key in ["paramita_papilio","butterfly_guard","lingering_fragrance"])
   if(!a.getSkills().hasSkill("$bvvar{modId}.effect.hu_tao_"+key))
   {local e=::new("$bvvar{privateFolder}/skills/effects/hu_tao_state_effect");e.configure(key);a.getSkills().add(e);}
 },
 function tick(a)
 {
  local s=this.state(a);if(s==null||!s.Active||!this.alive(a)||!this.normal(a)||s.LastRound==::Time.getRound())return;
  s.LastRound=::Time.getRound();s.Turn++;s.Guard=false;s.Actions={};
  if(this.dance(a))a.setFatigue(::Math.max(0,a.getFatigue()-(this.upgraded(a,40)?8:5)));
  this.feedback(a);this.update(a);
 },
 function endTurn(a)
 {
  local s=this.state(a);if(s==null||!s.Active||!this.normal(a))return;
  s.Ended=s.Turn;if(s.DanceUntil<=s.Ended)s.DanceUntil=0;this.update(a);
 },
 function reason(a,key)
 {
  local s=this.state(a);if(!this.able(a)||s==null||!s.Active||!this.normal(a))return "$bv{hu_tao.unavailable}";
  if(s.Move!=null||this.api().isValkyrieMovementBusy(a.getSkills()))return "$bv{hu_tao.moving}";
  if(key=="guide_to_afterlife")return a.getHitpoints()<=1?"$bv{hu_tao.one_hp}":s.ERound==::Time.getRound()?"$bv{hu_tao.e_used}":null;
  if(key=="spirit_soother")return s.Turn<s.QReady?"$bv{hu_tao.q_cooldown}":null;
  if(this.weapon(a)==null||a.getSkills().hasSkill("effects.disarmed"))return "$bv{hu_tao.weapon_required}";
  if(key=="wangsheng_dash")
  {
   if(a.getCurrentProperties().IsRooted)return "$bv{hu_tao.rooted}";
   if(s.DashRound==::Time.getRound()&&s.Dashes>=2)return "$bv{hu_tao.dash_used}";
  }
  return null;
 },
 function activate(a)
 {
  local s=this.state(a);a.setHitpoints(::Math.max(1,a.getHitpoints()-::Math.ceil(a.getHitpoints()*0.30)));
  s.ERound=::Time.getRound();s.SnapshotHP=a.getHitpointsMax();s.DanceUntil=s.Turn+1;
  this.visual(a.getTile(),"dash_departure");this.update(a);
 },
 function resistance(a)
 {
  local n=this.reborn(a)?80:this.dance(a)?50:0;
  if(n>0&&this.api().HuTaoEquipment.personal(a,"hexagram_hat")!=null&&this.upgraded(a,60))n+=10;
  return n;
 },
 function cleanse(a)
 {
  foreach(id in this.Negatives)a.getSkills().removeByID(id);
  this.update(a);
  if(!a.getCurrentProperties().IsRooted)
  {
   a.getSkills().removeByID("actives.break_free");
   foreach(key in ["status_rooted","status_rooted_back"])if("hasSprite" in a&&a.hasSprite(key))a.getSprite(key).Visible=false;
  }
 },
 // Predict only whether the native armor/HP result is nonzero. The native actor
 // still owns the actual reduction and delivery; see native boundary fixtures.
 function qualifyingHit(skill,h,p)
 {
  local mult=p.DamageReceivedTotalMult*(skill.isRanged()?p.DamageReceivedRangedMult:p.DamageReceivedMeleeMult);
  local regular=(h.DamageRegular-p.DamageRegularReduction)*p.DamageReceivedRegularMult*mult;
  local damageArmor=(h.DamageArmor-p.DamageArmorReduction)*p.DamageReceivedArmorMult*mult;
  local armor=h.DamageDirect<1?p.Armor[h.BodyPart]*p.ArmorMult[h.BodyPart]:0;
  local absorbed=h.DamageDirect<1?::Math.min(armor,damageArmor):0;armor-=absorbed;
  if(absorbed>0)return true;
  local hp=::Math.maxf(0,regular*h.DamageDirect*p.DamageReceivedDirectMult-armor*::Const.Combat.ArmorDirectDamageMitigationMult);
  if(armor<=0||h.DamageDirect>=1)hp+=::Math.maxf(0,regular*::Math.maxf(0,1-h.DamageDirect*p.DamageReceivedDirectMult)-absorbed);
  return ::Math.max(::Math.round(hp*h.BodyDamageMult),::Math.min(::Math.round(h.DamageMinimum),::Math.round(h.DamageMinimum*p.DamageReceivedTotalMult)))>0;
 },
 function hasSurvival(a){local s=this.state(a);return this.owns(a)&&s!=null&&s.Active&&!s.DeathUsed;},
 function claimSurvival(a,hp,frame)
 {
  if(!this.hasSurvival(a)||frame.Triggered||!frame.CouldDie||hp<frame.BeforeHP||hp<=0)return false;
  local s=this.state(a);s.DeathUsed=true;s.InvulnerableUntil=s.Turn+1;s.BuffUntil=s.Turn+2;
  frame.Triggered=true;frame.Kind="hu_tao_lingering_fragrance";frame.RestoreHP=1;frame.OwnerRef=this.api().makeValkyrieCombatWeakRef(a);
  a.setIsAbleToDie(false);this.cleanse(a);
  if(this.upgraded(a,100)){s.QReady=0;a.setFatigue(::Math.max(0,a.getFatigue()-15));}
  this.visual(a.getTile(),"lingering_fragrance");return true;
 },
 function snapshot(a,key)
 {
  local dance=this.dance(a),s=this.state(a),low=this.low(a),h=a.getHitpointsMax();
  return {Key=key,Dance=dance,Low=low,HP=h,Flat=dance?::Math.min(80,s.SnapshotHP*0.20):0,
   Hit=(key=="spirit_soother"?20:10)+(dance?::Math.min(20,::Math.floor(s.SnapshotHP*0.06)):0),
   DirectMult=dance?(this.upgraded(a,80)?1.25:1.15):1.0,FireMult=low?1.33:1.0,
   WeaponMult=key=="basic_thrust"?0.85:dance&&this.upgraded(a,80)?1.10:1.0,
   QMin=this.upgraded(a,80)?150:120,QMax=this.upgraded(a,80)?190:160,
   Blossom=::Math.min(60,(8+h*(this.upgraded(a,60)?0.08:0.06))*(low?1.33:1.0))};
 },
 function mark(a,b,snap)
 {
  if(!this.enemy(a,b)||!snap.Dance||b.getCurrentProperties().IsImmuneToFire||!this.api().EightValkyries.debuffable(b))return;
  local id="$bvvar{modId}.effect.hu_tao_blood_blossom",e=b.getSkills().getSkillByID(id);
  if(e==null){e=::new("$bvvar{privateFolder}/skills/effects/hu_tao_blood_blossom_effect");b.getSkills().add(e);}
  e.m.Owner=this.api().makeValkyrieCombatWeakRef(a);e.m.Damage=snap.Blossom;e.m.Remaining=2;
  local s=this.state(a);if(s.Marks.find(e)==null)s.Marks.push(e);
 },
 function areaTiles(a)
 {
  local origin=a.getTile(),queue=[origin],seen={},out=[];seen[origin.ID]<-true;
  for(local i=0;i<queue.len();i++)for(local d=0;d<6;d++)if(queue[i].hasNextTile(d))
  {
   local t=queue[i].getNextTile(d);if(t.ID in seen||origin.getDistanceTo(t)>2)continue;
   seen[t.ID]<-true;queue.push(t);
   if(t.IsVisibleForEntity&&origin.hasLineOfSightTo(t,2))out.push(t);
  }
  return out;
 },
 function area(a)
 {
  local out=[];foreach(t in this.areaTiles(a))
   if(t.IsOccupiedByActor&&this.enemy(a,t.getEntity())&&!t.getEntity().isHiddenToPlayer())out.push(t.getEntity());
  return out;
 },
 function previewSelection(state)
 {
  if(state.m.CurrentActionState!=::Const.Tactical.ActionState.SkillSelected)return;
  local a=::Tactical.TurnSequenceBar.getActiveEntity();if(!this.able(a))return;
  local skill=a.getSkills().getSkillByID(state.m.SelectedSkillID);
  if(skill!=null&&skill.getID()==this.api().getValkyrieSkillRuntimeID("hu_tao_spirit_soother"))skill.previewArea();
 },
 function heal(a,count,snap)
 {
  if(count<=0||!this.alive(a))return;
  local ratio=::Math.min(snap.Low?0.40:0.35,(snap.Low?0.20:0.15)+0.05*(count-1));
  a.setHitpoints(::Math.min(a.getHitpointsMax(),a.getHitpoints()+::Math.floor(snap.HP*ratio)));this.update(a);
 },
 function path(a,target)
 {
  if(!this.able(a)||target==null||!target.IsEmpty||!target.IsVisibleForEntity||a.getCurrentProperties().IsRooted)return null;
  local origin=a.getTile(),limit=this.dance(a)?4:3;
  for(local d=0;d<6;d++)
  {
   local from=origin,out=[];
   for(local n=0;n<limit&&from.hasNextTile(d);n++)
   {
    local t=from.getNextTile(d);
    // The second LOS argument is the sight distance, not a height tolerance.
    if(!t.IsVisibleForEntity||::Math.abs(from.Level-t.Level)>1||(!t.IsEmpty&&!t.IsOccupiedByActor)||!origin.hasLineOfSightTo(t,limit))break;
    out.push(t);if(t.ID==target.ID)return out;from=t;
   }
  }
  return null;
 },
 function move(a,path,skill,snap,context)
 {
  local s=this.state(a),j={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Path=clone path,Index=0,Hold=null,Done=false,Skill=skill,Snapshot=snap,Context=context,Continuation=null,Epoch=this.Epoch,Step=null,Seen={}};
  local service=this;j.Hold=this.api().beginValkyrieMovement(a,function(){service.finishMove(j);});if(j.Hold==null)return false;
  s.Move=j;j.Continuation=this.api().reserveValkyrieActionContinuation(context,"hu-tao-dash");
  try{this.nextStep(a,j);}
 catch(e){this.finishMove(j);throw e;}
 return true;
 },
 function finishMove(j)
 {
  if(j==null||j.Done)return;j.Done=true;j.Step=null;if(j.State.Move==j)j.State.Move=null;
  this.api().endValkyrieMovement(j.Hold);if(j.Continuation!=null)this.api().releaseValkyrieActionContinuation(j.Context,j.Continuation);
 },
 function nextStep(a,j)
 {
  if(j.Done||j.Epoch!=this.Epoch||!this.able(a)||!j.State.Active||this.state(a)!=j.State||a.getCurrentProperties().IsRooted||this.weapon(a)==null){this.finishMove(j);return;}
  local from=a.getTile(),landing=null,nextIndex=j.Index;
  // Occupied intermediate tiles are crossed as a single movement segment; never
  // teleport onto an actor. Resolve each encountered enemy once before landing.
  while(nextIndex<j.Path.len())
  {
   local t=j.Path[nextIndex];
   if(!t.IsVisibleForEntity||::Math.abs(from.Level-t.Level)>1||(!t.IsEmpty&&!t.IsOccupiedByActor)){this.finishMove(j);return;}
   if(t.IsEmpty){landing=t;nextIndex++;break;}
   nextIndex++;from=t;
  }
  if(landing==null){this.finishMove(j);return;}
  local entered=this.api().enterValkyrieActionDispatch(j.Context);
  if(!entered){this.finishMove(j);return;}
  try
  {
   for(local i=j.Index;i<nextIndex;i++)
   {
    local t=j.Path[i];if(!this.able(a)||this.weapon(a)==null||a.getCurrentProperties().IsRooted)break;
    if(t.IsOccupiedByActor)
    {
     // Native teleport applies entry hazards to empty landing tiles. Apply the
     // same callback explicitly for occupied tiles crossed without landing.
     if(t.Properties.Effect!=null&&t.Properties.Effect.IsAppliedOnEnter&&t.Properties.Effect.Callback!=null)t.Properties.Effect.Callback(t,a);
     if(!this.able(a)||a.getCurrentProperties().IsRooted)break;
     local b=t.getEntity();if(this.enemy(a,b)&&!(b.getID() in j.Seen)){j.Seen[b.getID()]<-true;j.Skill.strike(a,b,j.Snapshot);}
    }
   }
  }
  catch(e){if(entered)this.api().leaveValkyrieActionDispatch(j.Context);this.finishMove(j);throw e;}
  if(entered)this.api().leaveValkyrieActionDispatch(j.Context);
  if(!this.able(a)||!landing.IsEmpty||this.weapon(a)==null||a.getCurrentProperties().IsRooted){this.finishMove(j);return;}
  local step={Job=j,Tile=landing,Index=nextIndex,Queued=false};j.Step=step;
  ::Time.scheduleEvent(::TimeUnit.Virtual,1800,function(s){if(!s.Job.Done&&s.Job.Step==s)::$bvvar{namespace}.HuTao.finishMove(s.Job);},step);
  this.trail(a.getTile(),landing,j.Path,j.Index,nextIndex);this.visual(a.getTile(),"dash_departure");a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
  ::Tactical.getNavigator().teleport(a,landing,this.arrival.bindenv(this),step,false,3.0);
 },
 function arrival(a,step){if(step.Job.Done||step.Job.Step!=step||step.Queued)return;step.Queued=true;this.api().queueValkyrieMovementArrival(step.Job.Hold,this.arrived.bindenv(this),step);},
 function arrived(a,step)
 {
  local j=step.Job;if(j.Done||j.Step!=step)return;
  try
  {
   if(!this.alive(a)||a!=this.api().readValkyrieCombatWeakRef(j.Actor)||a.getTile().ID!=step.Tile.ID){this.finishMove(j);return;}
   j.Index=step.Index;j.Step=null;
   if(j.Index>=j.Path.len())
   {
    if(j.Snapshot.Dance&&j.State.GuardRound!=::Time.getRound()){j.State.Guard=true;this.visual(a.getTile(),"butterfly_guard");}
    this.finishMove(j);this.update(a);
   }
   else this.nextStep(a,j);
  }
  catch(e){this.finishMove(j);throw e;}
 },
 function recoverAfterCombat(a)
 {
  if(a==null||!("BVHuTaoRecoveryPending" in a.m)||!a.m.BVHuTaoRecoveryPending)return false;
  a.m.BVHuTaoRecoveryPending=false;
  // Map placement is no longer meaningful at world settlement. Identity and
  // actual survival still are: this must never revive a dead/dying actor.
  if(!this.owns(a)||this.api().isActorDeadOrDying(a))return false;
  a.getSkills().removeByType(::Const.SkillType.Injury|::Const.SkillType.PermanentInjury);
  this.cleanse(a);
  // A camp may have just unlocked an equipment tier before the roster settles.
  // Apply that entitlement now so recovery uses the final maximum, even before
  // the bond reward notification is delivered later in world settlement.
  this.api().HuTaoEquipment.sync(a);
  if(this.api().isActorDeadOrDying(a))return false;
  a.setFatigue(0);a.setHitpoints(a.getHitpointsMax());
  a.resetBloodied(false);a.updateInjuryVisuals(false);a.setDirty(true);
  return true;
 },
 function stop(a)
 {
  local s=this.state(a);if(s==null)return;s.Active=false;s.Guard=false;s.DanceUntil=0;
  if(s.Move!=null)this.finishMove(s.Move);
  foreach(e in s.Marks)if(e!=null&&e.getContainer()!=null&&this.api().readValkyrieCombatWeakRef(e.m.Owner)==a)e.removeSelf();s.Marks=[];
 },
 function reset(){this.Epoch++;foreach(ref in this.Owners){local a=this.api().readValkyrieCombatWeakRef(ref);if(a!=null){this.stop(a);a.m.BVHuTaoState=null;}}
 this.Owners=[];},
 function trail(from,to,path,start,finish)
 {
  // Sprite effects have no rotation API. Native particles support fixed degrees,
  // allowing the right-facing master to follow the actual six-direction segment.
  try
  {
   local angle=::atan2(to.Pos.Y-from.Pos.Y,to.Pos.X-from.Pos.X)*180.0/3.141592653589793;
   local stages=[
    {LifeTimeMin=0.04,LifeTimeMax=0.04,ColorMin=::createColor("ffffff00"),ColorMax=::createColor("ffffff00"),ScaleMin=0.55,ScaleMax=0.55,RotationMin=angle,RotationMax=angle,VelocityMin=0,VelocityMax=0,DirectionMin=::createVec(0,0),DirectionMax=::createVec(0,0),SpawnOffsetMin=::createVec(0,0),SpawnOffsetMax=::createVec(0,0)},
    {LifeTimeMin=0.16,LifeTimeMax=0.16,ColorMin=::createColor("ffffffff"),ColorMax=::createColor("ffffffff"),ScaleMin=0.65,ScaleMax=0.65,RotationMin=angle,RotationMax=angle,VelocityMin=0,VelocityMax=0},
    {LifeTimeMin=0.16,LifeTimeMax=0.16,ColorMin=::createColor("ffffff00"),ColorMax=::createColor("ffffff00"),ScaleMin=0.70,ScaleMax=0.70,RotationMin=angle,RotationMax=angle,VelocityMin=0,VelocityMax=0}
   ];
   for(local i=start;i<finish;i++)if(path[i].IsVisibleForPlayer)::Tactical.spawnParticleEffect(false,["effect_bv_hu_tao_dash_trail"],path[i],(i-start)*0.04,1,1,600,stages,::createVec(0,8));
  }
  catch(e){::logWarning("[Battle Valkyries] Hu Tao dash trail: "+e);}
 },
 function visual(t,cue){if(t==null)return;local anchor={isAlive=function(){return true;},isDying=function(){return false;},isPlacedOnMap=function(){return true;},getTile=function(){return t;}};this.api().playValkyrieVisual(this,anchor,"hu_tao_"+cue);}
};

::$bvvar{namespace}.finalizeHuTaoProperties <- function(a,skill,target,p)
{
 if(!this.HuTao.owns(a)||skill==null||!("HuTaoAttack" in skill.m)||!skill.m.HuTaoAttack)return p;
 local d=skill.m.Snapshot==null?this.HuTao.snapshot(a,skill.m.Spec.Key):skill.m.Snapshot;
 local fire=d.Key=="spirit_soother"||d.Dance;
 if(d.Key=="spirit_soother")
 {
  p.DamageRegularMin=d.QMin+::Math.min(100,d.HP*0.25);p.DamageRegularMax=d.QMax+::Math.min(100,d.HP*0.25);
  p.DamageTotalMult*=d.Low?1.20:1.0;p.DamageArmorMult=1.0;
 }
 else
 {
  p.DamageRegularMin=p.DamageRegularMin*d.WeaponMult+d.Flat;p.DamageRegularMax=p.DamageRegularMax*d.WeaponMult+d.Flat;
  p.DamageArmorMult=d.Key=="basic_thrust"?1.0:1.25;
 }
 p.DamageTotalMult*=d.DirectMult*(fire?d.FireMult:1.0);p.MeleeSkill+=d.Hit;
 if(fire&&target!=null&&target.getCurrentProperties().IsImmuneToFire)p.DamageTotalMult=0;
 p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
 p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
 skill.m.DirectDamageMult=d.Key=="basic_thrust"?0.25:0.35;return p;
};
