// Combat state is owned by the actor; managed-skill reconstruction never refills Heat.
::$bvvar{namespace}.Es <- {
 Owners=[],Epoch=0,
 function api(){return ::$bvvar{namespace};},
 function owns(a){return a!=null&&a.isPlayerControlled()&&this.api().getActorValkyrieID(a)=="es";},
 function alive(a){return a!=null&&!this.api().isActorDeadOrDying(a)&&a.isPlacedOnMap();},
 function able(a){return this.owns(a)&&this.api().EightValkyries.able(a)&&!a.getSkills().hasSkill("effects.disarmed");},
 function enemy(a,b){return this.alive(a)&&this.alive(b)&&!a.isAlliedWith(b)&&b.isAttackable();},
 function state(a){return a!=null&&"BVEsState" in a.m?a.m.BVEsState:null;},
 function entitled(a,stage){local t=a==null?null:a.getSkills().getSkillByID(this.api().EsBondTraitID);return this.owns(a)&&(stage==0||t!=null&&t.hasTriggeredStage(stage));},
 function weapon(a){if(a==null||a.getItems()==null)return null;local w=a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);return w!=null&&w.getID()=="$bvvar{modId}.weapon.es_murakumo"?w:null;},
 function weaponUsable(a){local w=this.weapon(a);return w!=null&&w.getCondition()>0;},
 function update(a){if(this.alive(a)){a.getSkills().update();a.setDirty(true);}},
 function start(a)
 {
  if(!this.owns(a)||!this.alive(a))return;
  local s=this.state(a);
  if(s!=null){s.Active=true;this.feedback(a);return;} // Revivals retain the cleared 0 Heat ledger.
  a.m.BVEsState <- {Active=true,Heat=20,Turn=0,LastRound=-1,Guard=false,GuardEnhanced=false,GuardRound=-1,
   Bors=false,PercivalUntil=0,Actions={},Batches=[],Move=null,NextBatch=1};
  this.Owners.push(this.api().makeValkyrieCombatWeakRef(a));this.feedback(a);
 },
 function feedback(a)
 {
  if(a.getSkills().getSkillByID("$bvvar{modId}.effect.es_state")==null)a.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/es_state_effect"));
  if(a.getSkills().getSkillByID("$bvvar{modId}.effect.es_griflet_guard")==null)a.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/es_griflet_guard_effect"));
 },
 function gain(a,n){local s=this.state(a);if(s!=null&&s.Active&&this.alive(a))s.Heat=::Math.min(100,::Math.max(0,s.Heat+n));this.update(a);},
 function enhanced(a){local s=this.state(a);return s!=null&&s.PercivalUntil>s.Turn;},
 function takeEnhancement(a)
 {
  if(this.enhanced(a))return true;local s=this.state(a);if(s.Bors){s.Bors=false;return true;}
 return false;
 },
 function reason(a,key)
 {
  local s=this.state(a),d=this.api().ValkyrieSkillCatalog[key].Spec;
  if(!this.able(a)||s==null||!s.Active)return "$bv{es.unavailable}";
  if(!this.entitled(a,d.Stage))return "$bv{es.locked}";
  if(!this.weaponUsable(a))return "$bv{es.weapon_required}";
  if(s.Move!=null||this.api().isValkyrieMovementBusy(a.getSkills()))return "$bv{es.moving}";
  if(s.Heat<d.Heat)return ::format("$bv{es.heat_required}",d.Heat);
  if(d.Key=="bors"&&(s.Bors||this.enhanced(a)))return "$bv{es.bors_active}";
  if(d.Key=="percival"&&this.enhanced(a))return "$bv{es.percival_active}";
  if(d.Key=="griflet"&&s.GuardRound==::Time.getRound())return "$bv{es.guard_used}";
  return null;
 },
 function tick(a)
 {
  local s=this.state(a),r=::Time.getRound();
  if(s==null||!s.Active||!this.alive(a)||!this.api().EightValkyries.normal(a)||s.LastRound==r)return;
  s.LastRound=r;s.Turn++;s.Guard=false;s.GuardEnhanced=false;s.Actions={};
  if(s.PercivalUntil<=s.Turn)s.PercivalUntil=0;
  // Detach the due queue before resolving: callbacks cannot join this resolution pass.
  local due=s.Batches;s.Batches=[];local presented={},burstPlayed=false,tiers={},ultimateVisible=false;
  // Choose the strongest due presentation before damage callbacks; queue order
  // must not let an ordinary crest hide Artorius, or a hidden one boost the camera.
  foreach(batch in due)
  {
   if(batch.Due>s.Turn)continue;
   local ultimate=batch.Source=="es_artorius";
   foreach(t in batch.Tiles)
   {
    if(!(t.ID in tiers))tiers[t.ID]<-ultimate;
    else if(ultimate)tiers[t.ID]=true;
    if(ultimate&&t.IsVisibleForPlayer)ultimateVisible=true;
   }
  }
  foreach(batch in due)
  {
   if(batch.Due>s.Turn&&this.alive(a)){s.Batches.push(batch);continue;}
   this.clearMarks(batch);
   if(!this.alive(a)||!s.Active)continue;
   local hit=false,seen={};
   foreach(t in batch.Tiles)
   {
    if(!this.alive(a)||!s.Active)break;
    // Detonation belongs to the tile, even when empty or the attack misses.
    // Merge presentation only; independent batches still resolve their own hits.
    if(!(t.ID in presented)){presented[t.ID]<-true;this.visual(t,tiers[t.ID]?"crest_ultimate":"crest_burst");}
    if(!burstPlayed&&t.IsVisibleForPlayer){burstPlayed=true;this.burstFeedback(a,t,ultimateVisible);}
    if(!t.IsOccupiedByActor)continue;local b=t.getEntity();
    if(!this.enemy(a,b)||b.getID() in seen)continue;
    seen[b.getID()]<-true;
    if(this.extra(a,b,batch.Properties,false))hit=true;
   }
   if(hit&&batch.Source!="es_artorius")this.gain(a,5);
  }
  if(this.alive(a)){a.setFatigue(::Math.max(0,a.getFatigue()-5));this.update(a);}
 },
 function burstFeedback(a,t,ultimate=false)
 {
  // One report / camera impulse per resolution pass, including stacked crests.
  // Presentation failures must never interrupt damage or the remaining batches.
  try{this.api().playValkyrieSkillAudio(a,ultimate?"es_crest_ultimate":"es_crest_burst",{Pos=::createVec(t.Pos.X,t.Pos.Y)});}catch(e){}
  try{::Tactical.getCamera().quake(::createVec(0,-1.0),ultimate?6.0:4.0,ultimate?0.16:0.12,ultimate?0.35:0.28);}catch(e){}
 },
 function auxiliary(a,counter=false)
 {
  local skill=::new("$bvvar{privateFolder}/skills/actives/es_followup_skill");skill.setContainer(a.getSkills());
  skill.m.EsCounter=counter;skill.m.Spec={Damage=counter?1.1:1.5,Armor=1.3,Pierce=0.25,Hit=counter?15:10,Head=false};return skill;
 },
 function snapshot(a,mult)
 {
  local skill=this.auxiliary(a);skill.m.Spec.Damage=mult;
  local p=a.getSkills().buildPropertiesForUse(skill,null);
  local copy=clone p;
  foreach(k,v in p)if(typeof v=="array"||typeof v=="table")copy[k]=clone v;
  return copy;
 },
 function extra(a,b,snapshot,counter=false)
 {
  if(!this.enemy(a,b)||counter&&(!this.able(a)||!this.weaponUsable(a)||a.getTile().getDistanceTo(b.getTile())!=1))return false;
  local skill=this.auxiliary(a,counter);skill.m.EsSnapshot=snapshot;
  local source=this.api().pushValkyrieCombatSource("followup",a),hit=false;
  try{hit=skill.attackEntity(a,b,false);}
  catch(e){this.api().popValkyrieCombatSource(source);throw e;}
  this.api().popValkyrieCombatSource(source);return hit;
 },
 function crestMultiplier(a,spec,enhanced=false)
 {
  local rules=this.api().EsCrestRules,w=this.weapon(a),bonus=0.0;
  if(w!=null&&w.getCondition()>0&&"getEsCrestBonus" in w)bonus=w.getEsCrestBonus();
  return spec.CrestPower*(rules.Base+bonus+(enhanced?rules.Enhancement:0.0));
 },
 function plantSkill(a,tiles,spec,enhanced=false)
 {
  this.plant(a,tiles,this.crestMultiplier(a,spec,enhanced),"es_"+spec.Key,spec.CrestRadius);
 },
 function crestArea(centers,radius=1)
 {
  local out=[],seen={};
  foreach(center in centers)
  {
   if(center==null)continue;
   local tiles=[center],visited={};visited[center.ID]<-true;
   for(local step=0,start=0;step<radius;step++)
   {
    local end=tiles.len();
    for(local i=start;i<end;i++)for(local d=0;d<6;d++)if(tiles[i].hasNextTile(d))
    {local next=tiles[i].getNextTile(d);if(!(next.ID in visited)){visited[next.ID]<-true;tiles.push(next);}}
    start=end;
   }
   foreach(t in tiles)if(t!=null&&!(t.ID in seen)){seen[t.ID]<-true;out.push(t);}
  }
  return out;
 },
 function plant(a,tiles,mult,source,radius=1)
 {
  local s=this.state(a);if(s==null||!s.Active||!this.alive(a))return;
  // Freeze one union per cast for warnings, AI and damage, including the wider finisher.
  local unique=this.crestArea(tiles,radius);
  if(unique.len()==0)return;
  local batch={ID=s.NextBatch++,Due=s.Turn+1,Tiles=unique,Properties=this.snapshot(a,mult),Source=source,Marks=[]};
  foreach(t in unique)
  {
   // Keep a handle for this batch only. Never modify SpecialOverlay or IsMarkedForImpact.
   local mark=t.spawnDetail("effect_bv_es_crest_pending",::Const.Tactical.DetailFlag.None,false,true);
   if(mark!=null)batch.Marks.push(mark);
  }
  s.Batches.push(batch);this.update(a);
 },
 function clearMarks(batch){foreach(mark in batch.Marks)if(mark!=null){mark.Visible=false;mark.Alpha=0;}
 batch.Marks=[];},
 function danger(tile,entity)
 {
  foreach(ref in this.Owners)
  {
   local a=this.api().readValkyrieCombatWeakRef(ref),s=this.state(a);
   if(!this.alive(a)||s==null||!s.Active||entity==null||a.isAlliedWith(entity))continue;
   foreach(batch in s.Batches)foreach(t in batch.Tiles)if(t.ID==tile.ID)return true;
  }
  return false;
 },
 function damageRange(p)
 {
  local mult=p.DamageTotalMult*p.MeleeDamageMult;
  return {Min=::Math.floor(::Math.floor(p.DamageRegularMin*p.DamageRegularMult)*mult).tointeger(),
   Max=::Math.floor(::Math.floor(p.DamageRegularMax*p.DamageRegularMult)*mult).tointeger()};
 },
 function tileInfo(tile)
 {
  local out=[];
  foreach(ref in this.Owners)
  {
   local a=this.api().readValkyrieCombatWeakRef(ref),s=this.state(a);if(!this.alive(a)||s==null||!s.Active)continue;
   local count=0,totalMin=0,totalMax=0,details="";
   foreach(batch in s.Batches)foreach(t in batch.Tiles)if(t.ID==tile.ID)
   {
    local damage=this.damageRange(batch.Properties),catalog=this.api().ValkyrieSkillCatalog;
    local name=batch.Source in catalog?catalog[batch.Source].Name:"$bv{es.crest.name}";
    count++;totalMin+=damage.Min;totalMax+=damage.Max;
    details+="\n"+::format("$bv{es.crest.tile_entry}",name,damage.Min,damage.Max);break;
   }
   if(count>0)out.push({id=800+out.len(),type="text",icon="skills/$bvvar{iconPrefix}/es_crest_arts.png",text=::format("$bv{es.crest.tile}",a.getName(),count,totalMin,totalMax)+details});
  }
  return out;
 },
 function guardPolicy(a,skill,attacker)
 {
  local s=this.state(a);if(s==null||!s.Active||!s.Guard||!this.enemy(a,attacker)||a.getTile().getDistanceTo(attacker.getTile())!=1)return null;
  if(skill==null||("EsAuxiliary" in skill.m&&skill.m.EsAuxiliary)||!this.api().isDirectAttack(skill)||!this.api().isActiveWeaponAttack(skill)||skill.isRanged())return null;
  local c=this.api().getCurrentValkyrieActionContext(attacker,skill);
  if(c!=null&&(this.api().isCounterOrAOO(c)||this.api().isValkyrieFollowup(c)))return null;
  return {NullifyDirectAttack=true,ConsumeToken="es_guard"};
 },
 function counter(a,attacker)
 {
  local s=this.state(a);if(s==null||!s.Active||!s.Guard)return;
  local enhanced=s.GuardEnhanced;s.Guard=false;s.GuardEnhanced=false;this.gain(a,15);this.visual(a.getTile(),"griflet_guard");
  // Defer outside the incoming damage/nullification stack. Revalidate both actors.
  local job={Actor=this.api().makeValkyrieCombatWeakRef(a),Target=this.api().makeValkyrieCombatWeakRef(attacker),Enhanced=enhanced,Epoch=this.Epoch,State=s};
  ::Time.scheduleEvent(::TimeUnit.Virtual,1,function(j){
   local f=::$bvvar{namespace}.Es,a=f.api().readValkyrieCombatWeakRef(j.Actor),b=f.api().readValkyrieCombatWeakRef(j.Target);
   if(j.Epoch!=f.Epoch||f.state(a)!=j.State||!j.State.Active||!f.able(a)||!f.weaponUsable(a)||!f.enemy(a,b)||a.getTile().getDistanceTo(b.getTile())!=1)return;
   local t=b.getTile();f.extra(a,b,null,true);f.plantSkill(a,[t],f.api().ValkyrieSkillCatalog.es_griflet.Spec,j.Enhanced);
  },job);
 },
 function passable(from,t){return t!=null&&t.IsEmpty&&t.IsVisibleForEntity&&from.getDistanceTo(t)==1&&::Math.abs(from.Level-t.Level)<=1;},
 function path(a,target)
 {
  if(!this.able(a)||!this.enemy(a,target))return null;
  local origin=a.getTile(),dest=target.getTile();
  if(origin.getDistanceTo(dest)==1)return ::Math.abs(origin.Level-dest.Level)<=1?[]:null;
  if(origin.getDistanceTo(dest)>3||a.getCurrentProperties().IsRooted)return null;
  local queue=[{Tile=origin,Path=[]}],seen={};seen[origin.ID]<-true;
  for(local i=0;i<queue.len();i++)
  {
   local n=queue[i];if(n.Path.len()>=2)continue;
   for(local d=0;d<6;d++)if(n.Tile.hasNextTile(d))
   {
    local t=n.Tile.getNextTile(d);if(t.ID in seen||!this.passable(n.Tile,t))continue;
    seen[t.ID]<-true;local p=clone n.Path;p.push(t);
    if(t.getDistanceTo(dest)==1&&::Math.abs(t.Level-dest.Level)<=1)return p;
    queue.push({Tile=t,Path=p});
   }
  }
  return null;
 },
 function move(a,route,skill,target,enhanced,context)
 {
  local s=this.state(a),job={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Path=clone route,Index=0,Hold=null,Done=false,
   Skill=skill,Target=this.api().makeValkyrieCombatWeakRef(target),Enhanced=enhanced,Context=context,Continuation=null,Epoch=this.Epoch,Step=null,Traversed=[]};
  local service=this;job.Hold=this.api().beginValkyrieMovement(a,function(){service.finishMove(job);});
  if(job.Hold==null)return false;s.Move=job;job.Continuation=this.api().reserveValkyrieActionContinuation(context,"es-advance");
  try{this.nextStep(a,job);}
 catch(e){this.finishMove(job);throw e;}
 return true;
 },
 function finishMove(j){if(j==null||j.Done)return;j.Done=true;j.Step=null;if(j.State.Move==j)j.State.Move=null;this.api().endValkyrieMovement(j.Hold);if(j.Continuation!=null)this.api().releaseValkyrieActionContinuation(j.Context,j.Continuation);},
 function nextStep(a,j)
 {
  if(j.Done||j.Epoch!=this.Epoch||!this.able(a)||!j.State.Active||this.state(a)!=j.State||a.getCurrentProperties().IsRooted){this.finishMove(j);return;}
  if(j.Index>=j.Path.len())
  {
   local b=this.api().readValkyrieCombatWeakRef(j.Target),entered=this.api().enterValkyrieActionDispatch(j.Context);
   try{if(entered)j.Skill.strike(a,b,j.Enhanced,j.Traversed,j.Context);}
   catch(e){if(entered)this.api().leaveValkyrieActionDispatch(j.Context);this.finishMove(j);throw e;}
   if(entered)this.api().leaveValkyrieActionDispatch(j.Context);this.finishMove(j);return;
  }
  local to=j.Path[j.Index];if(!this.passable(a.getTile(),to)){this.finishMove(j);return;}
  local step={Job=j,Tile=to,Queued=false};j.Step=step;
  ::Time.scheduleEvent(::TimeUnit.Virtual,1800,function(s){if(!s.Job.Done&&s.Job.Step==s)::$bvvar{namespace}.Es.finishMove(s.Job);},step);
  this.visual(a.getTile(),"mordred_trail");a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
  ::Tactical.getNavigator().teleport(a,to,this.arrival.bindenv(this),step,false,3.0);
 },
 function arrival(a,step){if(step.Job.Done||step.Job.Step!=step||step.Queued)return;step.Queued=true;this.api().queueValkyrieMovementArrival(step.Job.Hold,this.arrived.bindenv(this),step);},
 function arrived(a,step)
 {
  local j=step.Job;if(j.Done||j.Step!=step)return;
  try{if(!this.alive(a)||a!=this.api().readValkyrieCombatWeakRef(j.Actor)||a.getTile().ID!=step.Tile.ID){this.finishMove(j);return;}
   j.Traversed.push(step.Tile);j.Index++;j.Step=null;this.nextStep(a,j);
  }
 catch(e){this.finishMove(j);throw e;}
 },
 function stop(a)
 {
  local s=this.state(a);if(s==null)return;s.Active=false;s.Heat=0;s.Guard=false;s.Bors=false;s.PercivalUntil=0;
  if(s.Move!=null)this.finishMove(s.Move);foreach(b in s.Batches)this.clearMarks(b);s.Batches=[];
 },
 function reset(){this.Epoch++;foreach(ref in this.Owners){local a=this.api().readValkyrieCombatWeakRef(ref);if(a!=null){this.stop(a);a.m.BVEsState=null;}}
 this.Owners=[];},
 function visual(t,cue){if(t==null)return;local anchor={isAlive=function(){return true;},isDying=function(){return false;},isPlacedOnMap=function(){return true;},getTile=function(){return t;}};this.api().playValkyrieVisual(this,anchor,"es_"+cue);}
};

::$bvvar{namespace}.finalizeEsProperties <- function(a,skill,target,p)
{
 if(!::$bvvar{namespace}.Es.owns(a)||skill==null||!("EsAttack" in skill.m)||!skill.m.EsAttack)return p;
 if("EsSnapshot" in skill.m&&skill.m.EsSnapshot!=null)return clone skill.m.EsSnapshot;
 local d=skill.m.Spec,mult=d.Damage;
 if(d.Head){p.HitChance=clone p.HitChance;p.HitChance[::Const.BodyPart.Head]=100;p.HitChance[::Const.BodyPart.Body]=0;}
 if("Segment" in skill.m&&skill.m.Segment==2)mult*=2.0;
 p.DamageTotalMult*=mult;p.DamageArmorMult=d.Armor;
 p.MeleeSkill+=d.Hit;
 p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
 skill.m.DirectDamageMult=d.Pierce;
 p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
 return p;
};
