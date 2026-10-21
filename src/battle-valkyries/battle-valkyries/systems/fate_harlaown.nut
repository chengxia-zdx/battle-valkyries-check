// Battle-only actor state survives managed-skill repair, but never supplies identity.
::$bvvar{namespace}.FateHarlaown <- {
 Owners=[], Epoch=0, FormOwner="fate_harlaown.sonic",
 function api(){return ::$bvvar{namespace};},
 function alive(a){return a!=null&&!this.api().isActorDeadOrDying(a)&&a.isPlacedOnMap();},
 function owns(a){return a!=null&&a.isPlayerControlled()&&this.api().getActorValkyrieID(a)=="fate_harlaown";},
 function able(a){return this.owns(a)&&this.api().EightValkyries.able(a);},
 function enemy(a,b){return this.alive(a)&&this.alive(b)&&!a.isAlliedWith(b)&&b.isAttackable();},
 function state(a){return a!=null&&"BVFateState" in a.m?a.m.BVFateState:null;},
 function normal(a){return this.api().EightValkyries.normal(a);},
 function update(a){if(this.alive(a)){a.getSkills().update();a.setDirty(true);}},
 function start(a)
 {
  if(!this.owns(a)||!this.alive(a))return;
  local s=this.state(a);if(s!=null&&s.Active)return;
  a.m.BVFateState<-{Active=true,Turn=0,LastRound=-1,LastEnd=-1,Steps=0,Gained=false,Charged=false,
   Used=false,Form=false,FormUntil=0,Cooldowns={},Actions={},Move=null,Walk=null};
  this.Owners.push(this.api().makeValkyrieCombatWeakRef(a));
 },
 function tick(a)
 {
  local s=this.state(a),round=::Time.getRound();
  if(!this.owns(a)||s==null||!s.Active||!this.normal(a)||s.LastRound==round)return;
  s.LastRound=round;s.Turn++;s.Steps=0;s.Gained=false;s.Charged=false;s.Actions={};s.Walk=null;
  foreach(k,v in s.Cooldowns)s.Cooldowns[k]=::Math.max(0,v-1);
  this.update(a);
 },
 function endTurn(a)
 {
  local s=this.state(a);if(s==null||!s.Active||!this.normal(a)||s.LastEnd==s.Turn)return;
  s.LastEnd=s.Turn;s.Charged=false;s.Walk=null;
  if(s.Move!=null)this.finishMove(s.Move);
  if(s.Form&&s.Turn>=s.FormUntil)this.endForm(a);
 },
 function moved(a,n=1)
 {
  local s=this.state(a);if(!this.able(a)||s==null||!s.Active||!this.normal(a)||s.LastEnd==s.Turn)return;
  s.Steps+=n;
  if(s.Steps>=2&&!s.Gained){s.Gained=true;s.Charged=true;this.visual(a,a.getTile(),"ready");this.update(a);}
 },
 function form(a){local s=this.state(a);return this.owns(a)&&s!=null&&s.Active&&s.Form;},
 function beginForm(a)
 {
  local s=this.state(a);if(!this.able(a)||s==null||!s.Active||s.Used)return false;
  foreach(key in ["fate_blade","fate_zanber"])
  {
   local r=this.api().attachTransientSkill(a,key,this.FormOwner);
   if(!r.Success){this.endForm(a);return false;}
  }
  s.Used=true;s.Form=true;s.FormUntil=s.Turn+1;
  this.visual(a,a.getTile(),"transform");this.visual(a,a.getTile(),"cast");this.update(a);return true;
 },
 function endForm(a)
 {
  local s=this.state(a);if(s!=null)s.Form=false;
  if(a==null)return;
  foreach(key in ["fate_blade","fate_zanber"])
  {
   local r=this.api().detachTransientSkill(a,key,this.FormOwner);
   if(!r.Success&&r.Code!="owner_not_found")::logWarning("[Battle Valkyries] Fate form cleanup: "+r.Code);
  }
  this.update(a);
 },
 function stop(a)
 {
  local s=this.state(a);if(s==null)return;
  if(s.Move!=null)this.finishMove(s.Move);
  s.Active=false;s.Charged=false;s.Walk=null;s.Actions={};this.endForm(a);
 },
 function reset()
 {
  this.Epoch++;
  foreach(ref in this.Owners){local a=this.api().readValkyrieCombatWeakRef(ref);if(a!=null){this.stop(a);a.m.BVFateState=null;}}
  this.Owners=[];
 },
 function cooldown(a,key){local s=this.state(a);return s!=null&&key in s.Cooldowns?s.Cooldowns[key]:0;},
 function reason(a,key)
 {
  local s=this.state(a);
  if(!this.able(a)||s==null||!s.Active)return "$bv{fate.unavailable}";
  if(s.Move!=null||this.api().isValkyrieMovementBusy(a.getSkills()))return "$bv{fate.moving}";
  if(this.cooldown(a,key)>0)return "$bv{fate.cooling}";
  if(key=="fate_move"&&a.getCurrentProperties().IsRooted)return "$bv{fate.rooted}";
  if(key=="fate_lancer"&&a.getTile().getZoneOfControlCountOtherThan(a.getAlliedFactions())>0)return "$bv{fate.engaged}";
  if(key=="fate_form"&&s.Used)return "$bv{fate.used}";
  if(key=="fate_scythe"&&s.Form||((key=="fate_blade"||key=="fate_zanber")&&!s.Form))return "$bv{fate.form_required}";
  return null;
 },
 // BFS limits actual steps, not only the straight-line radius. IsEmpty excludes props and units.
 function passable(from,t)
 {
  return from!=null&&t!=null&&t.IsEmpty&&t.IsVisibleForEntity&&from.getDistanceTo(t)==1&&::Math.abs(from.Level-t.Level)<=1;
 },
 function path(a,dest)
 {
  if(!this.able(a)||dest==null||!dest.IsEmpty||!dest.IsVisibleForEntity||a.getCurrentProperties().IsRooted)return null;
  local start=a.getTile();if(start.ID==dest.ID||start.getDistanceTo(dest)>3)return null;
  local queue=[{Tile=start,Path=[]}],seen={};seen[start.ID]<-true;
  for(local i=0;i<queue.len();i++)
  {
   local node=queue[i];if(node.Path.len()>=3)continue;
   for(local d=0;d<6;d++)if(node.Tile.hasNextTile(d))
   {
    local t=node.Tile.getNextTile(d);if(t.ID in seen||!this.passable(node.Tile,t))continue;
    seen[t.ID]<-true;local route=clone node.Path;route.push(t);
    if(t.ID==dest.ID)return route;queue.push({Tile=t,Path=route});
   }
  }
  return null;
 },
 function beginMove(a,route)
 {
  local s=this.state(a);if(!this.able(a)||s==null||s.Move!=null||route==null||route.len()==0||!this.passable(a.getTile(),route[0]))return false;
  local tag={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Path=clone route,Index=0,Hold=null,Done=false,Step=null,Epoch=this.Epoch,Turn=s.Turn};
  local service=this;tag.Hold=this.api().beginValkyrieMovement(a,function(){service.finishMove(tag);});
  if(tag.Hold==null)return false;
  s.Move=tag;s.Walk=null;
  try{if(!this.nextStep(a,tag)){this.finishMove(tag);return false;}}
  catch(e){this.finishMove(tag);throw e;}
  s.Cooldowns.fate_move<-2;return true;
 },
 function finishMove(tag)
 {
  if(tag==null||tag.Done)return;
  tag.Done=true;tag.Step=null;
  if(tag.State.Move==tag)tag.State.Move=null;
  this.api().endValkyrieMovement(tag.Hold);
 },
 function validMove(a,tag)
 {
  return !tag.Done&&tag.Epoch==this.Epoch&&this.able(a)&&this.state(a)==tag.State&&tag.State.Active
   &&tag.State.Turn==tag.Turn&&tag.State.LastEnd!=tag.State.Turn&&tag.State.Move==tag&&!a.getCurrentProperties().IsRooted;
 },
 function nextStep(a,tag)
 {
  if(!this.validMove(a,tag)){this.finishMove(tag);return false;}
  if(tag.Index>=tag.Path.len()){this.visual(a,a.getTile(),"arrival");this.finishMove(tag);return true;}
  local from=a.getTile(),to=tag.Path[tag.Index];
  if(!this.passable(from,to)){this.finishMove(tag);return false;}
  local step={Move=tag,Index=tag.Index,Tile=to,Queued=false};tag.Step=step;
  // Each trip owns a watchdog even if the native navigator never calls arrival.
  ::Time.scheduleEvent(::TimeUnit.Virtual,1800,function(t){local f=::$bvvar{namespace}.FateHarlaown;if(!t.Move.Done&&t.Move.Step==t)f.finishMove(t.Move);},step);
  this.visual(a,from,"afterimage");
  a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
  ::Tactical.getNavigator().teleport(a,to,this.arrival.bindenv(this),step,false,3.0);
  return true;
 },
 function arrival(a,step)
 {
  local tag=step.Move;
  if(tag.Done||tag.Step!=step||step.Queued||tag.Index!=step.Index)return;
  step.Queued=true;this.api().queueValkyrieMovementArrival(tag.Hold,this.arrived.bindenv(this),step);
 },
 function arrived(a,step)
 {
  local tag=step.Move;
  if(tag.Done||tag.Step!=step||tag.Index!=step.Index)return;
  try
  {
   if(!this.validMove(a,tag)||a!=this.api().readValkyrieCombatWeakRef(tag.Actor)||a.getTile().ID!=step.Tile.ID){this.finishMove(tag);return;}
   tag.Step=null;tag.Index++;this.moved(a);this.nextStep(a,tag);
  }
  catch(e){this.finishMove(tag);throw e;}
 },
 // The same ray supplies targeting preview and damage; allies and obstacles stop it.
 function ray(a,target)
 {
  local out=[];if(!this.alive(a)||target==null)return out;
  local origin=a.getTile();if(origin.ID==target.ID||origin.getDistanceTo(target)>3)return out;
  local direction=origin.getDirectionTo(target),at=origin,contains=false;
  for(local i=0;i<3;i++)
  {
   if(!at.hasNextTile(direction))break;
   local t=at.getNextTile(direction);
   if(!t.IsVisibleForEntity||::Math.abs(t.Level-at.Level)>1||!origin.hasLineOfSightTo(t,3))break;
   if(t.IsOccupiedByActor)
   {
    local occupant=t.getEntity();
    // Lethal hits may leave a dying entity on its tile until its animation ends.
    // It must not stop this already committed cleave from reaching later tiles.
    if(occupant==null||(!this.api().isActorDeadOrDying(occupant)&&!this.enemy(a,occupant)))break;
   }
   else if(!t.IsEmpty)break;
   out.push(t);if(t.ID==target.ID)contains=true;at=t;
  }
  return contains?out:[];
 },
 function visual(a,tile,cue,delay=0)
 {
  local s=this.state(a);if(tile==null||s==null||!s.Active)return;
  if(delay>0)
  {
   local t={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Tile=tile,Cue=cue,Epoch=this.Epoch};
   try{::Time.scheduleEvent(::TimeUnit.Virtual,delay,function(t){local f=::$bvvar{namespace}.FateHarlaown,a=f.api().readValkyrieCombatWeakRef(t.Actor);if(f.Epoch==t.Epoch&&f.state(a)==t.State&&t.State.Active&&f.alive(a))f.visual(a,t.Tile,t.Cue);},t);}catch(e){}
   return;
  }
  local anchor={isAlive=function(){return true;},isDying=function(){return false;},isPlacedOnMap=function(){return true;},getTile=function(){return tile;}};
  this.api().playValkyrieVisual(this,anchor,"fate_"+cue);
 }
};

// Finalize after equipment callbacks so Bardiche's fixed base cannot inherit a held weapon.
::$bvvar{namespace}.finalizeFateProperties <- function(a,skill,target,p)
{
 local f=::$bvvar{namespace}.FateHarlaown;
 if(!f.owns(a)||skill==null)return p;
 // Runtime keys live in the parent m table; `in` ignores inherited slots.
 local key=null;try{key=skill.getBattleValkyriesSkillKey();}catch(e){return p;}
 if(key==null||key.find("fate_")!=0||skill.m.Spec==null||!skill.m.Spec.Attack)return p;
 local d=skill.m.Spec,s=f.state(a),boost=skill.m.Boost==null?(s!=null&&s.Charged):skill.m.Boost;
 p.DamageRegularMin=d.Low;p.DamageRegularMax=d.High;p.DamageArmorMult=d.Armor;
 p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
 p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
 if(d.Ranged)p.RangedSkill+=d.Hit+(boost?10:0);else p.MeleeSkill+=d.Hit+(boost?10:0);
 if(boost)p.DamageTotalMult*=1.20;
 return p;
};
