// Battle state belongs to the actor, never to a replaceable managed skill instance.
::$bvvar{namespace}.Kanade <- {
 Owners=[],Epoch=0,AutoChangingSkin=false,
 Equipment=[{Key="hand_sonic",Slot="Mainhand",Path="weapons",Stage=80,LegacyStage=40},{Key="feather_hairpiece",Slot="Head",Path="helmets",Stage=60,LegacyStage=20},{Key="uniform_armor",Slot="Body",Path="armor",Stage=20,LegacyStage=60},{Key="unsent_thanks",Slot="Accessory",Path="accessory",Stage=40,LegacyStage=80}],
 function api(){return ::$bvvar{namespace};},
 function alive(a){return a!=null&&!this.api().isActorDeadOrDying(a)&&a.isPlacedOnMap();},
 function owns(a){return a!=null&&a.isPlayerControlled()&&this.api().getActorValkyrieID(a)=="kanade_tachibana";},
 function cloneActor(a){return a!=null&&"KanadeClone" in a.m&&a.m.KanadeClone;},
 function owner(a){return this.cloneActor(a)?this.api().readValkyrieCombatWeakRef(a.m.KanadeOwnerRef):a;},
 function able(a){return (this.owns(a)||this.cloneActor(a)&&this.owns(this.owner(a))&&this.alive(this.owner(a)))&&this.api().EightValkyries.able(a);},
 function enemy(a,b){return this.alive(a)&&this.alive(b)&&!a.isAlliedWith(b)&&b.isAttackable();},
 function state(a){return a!=null&&"BVKanadeState" in a.m?a.m.BVKanadeState:null;},
 function upgraded(a,stage){return this.api().hasKanadeBondUpgrade(a,stage);},
 function gear(a,key,up=false)
 {
  if(a==null||a.getItems()==null)return null;
  foreach(row in this.Equipment)if(row.Key==key)
  {
   local i=a.getItems().getItemAtSlot(::Const.ItemSlot[row.Slot]);
   if(i!=null&&"KanadeKey" in i.m&&i.m.KanadeKey==key&&(!up||i.m.KanadeTier>0))return i;
  }
  return null;
 },
 function weapon(a){if(this.cloneActor(a))return a.m.KanadeWeapon;return this.gear(a,"hand_sonic");},
 function weaponUsable(a){local w=this.weapon(a);return w!=null&&(this.cloneActor(a)||w.getCondition()>0);},
 function ownerKey(a){local f=a.getFlags(),key=f.get("BVKanadeEquipmentOwner");if(key==null){key="kanade:"+a.getID();f.set("BVKanadeEquipmentOwner",key);}
 return key;},
 function equipmentGrantFlag(key){return "BVKanadeEquipmentGranted."+key;},
 function equipmentUpgradeFlag(key){return "BVKanadeEquipmentUpgraded."+key;},
 function equipmentUpgraded(a,row){return this.upgraded(a,row.Stage)||a.getFlags().get(this.equipmentUpgradeFlag(row.Key))==true;},
 function equipStarter(a)
 {
  local item=::new("scripts/items/weapons/battle_valkyries/kanade_tachibana_hand_sonic");
  item.m.KanadeOwner=this.ownerKey(a);
  if(!a.getItems().equip(item))throw "Kanade starter equip failed: hand_sonic";
  a.getFlags().set(this.equipmentGrantFlag("hand_sonic"),true);
  a.getFlags().set("BVKanadeEquipmentOrder",2);
 },
 function migrateEquipment(a,trait)
 {
  local flags=a.getFlags();if(flags.get("BVKanadeEquipmentOrder")==2)return;
  local origin=this.ownerKey(a),items=this.allItems(a);
  foreach(row in this.Equipment)
  {
   if(trait.hasClaimedStage(row.LegacyStage))flags.set(this.equipmentGrantFlag(row.Key),true);
   if(trait.hasTriggeredStage(row.LegacyStage))flags.set(this.equipmentUpgradeFlag(row.Key),true);
   foreach(i in items)if("KanadeOwner" in i.m&&i.m.KanadeOwner==origin&&i.m.KanadeKey==row.Key)
   {
    flags.set(this.equipmentGrantFlag(row.Key),true);
    if(i.m.KanadeTier>0)flags.set(this.equipmentUpgradeFlag(row.Key),true);
   }
  }
  // A previously claimed stage may now grant a different item. Keep that new reward pending.
  foreach(row in this.Equipment)if(row.Key!="hand_sonic"&&trait.hasTriggeredStage(row.Stage)&&flags.get(this.equipmentGrantFlag(row.Key))!=true)
  {
   trait.removeStage(trait.m.ClaimedStages,row.Stage);
   trait.addStage(trait.m.NoticeStages,row.Stage);
  }
  flags.set("BVKanadeEquipmentOrder",2);
 },
 function grantStageEquipment(a,stage)
 {
  if(!this.owns(a)||(stage!=0&&!this.upgraded(a,stage)))return false;
  foreach(row in this.Equipment)if(row.Stage==stage||stage==0&&row.Key=="hand_sonic")
  {
   local flags=a.getFlags(),flag=this.equipmentGrantFlag(row.Key);
   if(flags.get(flag)==true)return true;
   local origin=this.ownerKey(a);
   foreach(i in this.allItems(a))if("KanadeOwner" in i.m&&i.m.KanadeOwner==origin&&i.m.KanadeKey==row.Key)
   {
    if(i.m.KanadeTier==0&&this.equipmentUpgraded(a,row))i.upgradeKanade();
    flags.set(flag,true);return true;
   }
   if(!("World" in getroottable())||::World==null||::World.Assets==null)return false;
   local stash=::World.Assets.getStash();
   if(!stash.isResizable()&&stash.getNumberOfEmptySlots()==0)return false;
   local item=::new("scripts/items/"+row.Path+"/battle_valkyries/kanade_tachibana_"+row.Key);
   item.m.KanadeOwner=origin;if(this.equipmentUpgraded(a,row))item.upgradeKanade();
   if(stash.add(item)==null)return false;
   flags.set(flag,true);return true;
  }
  return true;
 },
 function allItems(actor=null)
 {
  local out=[];
  // During player.onDeserialize the actor may not yet be in the world roster.
  if(actor!=null)foreach(i in actor.getItems().getAllItems())if(i!=null)out.push(i);
  if(!("World" in getroottable())||::World==null||::World.Assets==null)return out;
  foreach(a in ::World.getPlayerRoster().getAll())foreach(i in a.getItems().getAllItems())if(i!=null&&out.find(i)==null)out.push(i);
  foreach(i in ::World.Assets.getStash().getItems())if(i!=null)out.push(i);
  return out;
 },
 function upgradeEquipment(a)
 {
  local ownerKey=this.ownerKey(a);
  local items=this.allItems(a);
  foreach(row in this.Equipment)if(this.equipmentUpgraded(a,row))
  {
   a.getFlags().set(this.equipmentUpgradeFlag(row.Key),true);
   foreach(i in items)if("KanadeOwner" in i.m&&i.m.KanadeOwner==ownerKey&&i.m.KanadeKey==row.Key&&i.m.KanadeTier==0)i.upgradeKanade();
  }
  a.getSkills().update();
 },
 function missingEquipment(a)
 {
  local out=[],items=this.allItems(a),origin=this.ownerKey(a);
  foreach(row in this.Equipment){if(a.getFlags().get(this.equipmentGrantFlag(row.Key))!=true)continue;
   local found=false;foreach(i in items)if("KanadeOwner" in i.m&&i.m.KanadeOwner==origin&&i.m.KanadeKey==row.Key){found=true;break;}
   if(!found)out.push(row.Key);}
  return out;
 },
 function replaceMissing(a,key)
 {
  if(!this.owns(a)||a.isPlacedOnMap()||::World.Assets.getMoney()<3000)return false;
  local row=null;foreach(r in this.Equipment)if(r.Key==key)row=r;if(row==null)return false;
  if(a.getFlags().get(this.equipmentGrantFlag(key))!=true)return false;
  local ownerKey=this.ownerKey(a);foreach(i in this.allItems(a))if("KanadeOwner" in i.m&&i.m.KanadeOwner==ownerKey&&i.m.KanadeKey==key)return false;
  local stash=::World.Assets.getStash();if(!stash.isResizable()&&stash.getNumberOfEmptySlots()==0)return false;
  local item=::new("scripts/items/"+row.Path+"/battle_valkyries/kanade_tachibana_"+key);item.m.KanadeOwner=ownerKey;
  if(this.equipmentUpgraded(a,row))item.upgradeKanade();
  local money=::World.Assets.getMoney();if(stash.add(item)==null)return false;
  try{::World.Assets.setMoney(money-3000);}
 catch(e){stash.remove(item);throw e;}
  return true;
 },
 function start(a)
 {
  if(!(this.owns(a)||this.cloneActor(a))||!this.alive(a))return;
  this.ensureFeedback(a);
  local s=this.state(a);if(s!=null&&s.Active)return;
  a.m.BVKanadeState<-{Active=true,Turn=0,LastRound=-1,LastEnd=-1,StartRound=::Time.getRound(),Cooldowns={},Actions={},Move=null,
   PrimaryRound=-1,ExtraRound=-1,KillRound=-1,Defense=false,Charges=0,Distortion=false,Ally=null,AllyCharge=false,Clones=[],Rotation=0,AssistRound=-1};
  this.Owners.push(this.api().makeValkyrieCombatWeakRef(a));
  if(!this.cloneActor(a))this.visual(a.getTile(),"overdrive");
 },
 function ensureFeedback(a)
 {
  if(!this.owns(a))return;
  foreach(kind in ["distortion","delay","harmonics","extra_delay"])
   if(a.getSkills().getSkillByID("$bvvar{modId}.effect.kanade_state_"+kind)==null)
   {
    local effect=::new("$bvvar{privateFolder}/skills/effects/kanade_tachibana_state_effect");
    effect.configure(kind);a.getSkills().add(effect);
   }
 },
 function clearDistortion(a)
 {
  local s=this.state(a);if(s==null)return;
  local ally=this.api().readValkyrieCombatWeakRef(s.Ally);
  s.Distortion=false;s.AllyCharge=false;s.Ally=null;
  this.update(a);this.update(ally);
 },
 function tick(a)
 {
  local s=this.state(a),r=::Time.getRound();if(s==null||!s.Active||!this.api().EightValkyries.normal(a)||s.LastRound==r)return;
  s.LastRound=r;s.Turn++;s.Defense=false;s.Charges=0;this.clearDistortion(a);s.Actions={};
  if(!this.cloneActor(a))
  {
   foreach(c in this.liveClones(a))if(s.Turn>=c.m.KanadeExpire)this.dismiss(c,true);
   if(r>s.StartRound)a.setFatigue(::Math.max(0,a.getFatigue()-(this.upgraded(a,40)?12:8)));
  }
  this.update(a);
 },
 function endTurn(a){local s=this.state(a);if(s==null||!this.api().EightValkyries.normal(a))return;s.LastEnd=s.Turn;if(s.Move!=null)this.finishMove(s.Move);},
 function stop(a)
 {
  local s=this.state(a);if(s==null)return;
  if(s.Move!=null)this.finishMove(s.Move);s.Active=false;s.Defense=false;this.clearDistortion(a);
  foreach(c in this.liveClones(a))this.dismiss(c,false);s.Clones=[];
 },
 function reset()
 {
  this.Epoch++;local owners=clone this.Owners;
  foreach(ref in owners){local a=this.api().readValkyrieCombatWeakRef(ref);if(a!=null){if(this.cloneActor(a))this.dismiss(a,false);else this.stop(a);a.m.BVKanadeState=null;}}
  this.Owners=[];
 },
 function update(a){if(this.alive(a)){a.getSkills().update();a.setDirty(true);}},
 function cooldown(a,key){local s=this.state(a);return s!=null&&key in s.Cooldowns?::Math.max(0,s.Cooldowns[key]-::Time.getRound()):0;},
 function extraDelay(a){local s=this.state(a),r=::Time.getRound();return s!=null&&!this.cloneActor(a)&&this.upgraded(a,80)&&s.PrimaryRound==r&&s.KillRound==r&&s.ExtraRound!=r;},
 function range(a){return this.cloneActor(a)||this.extraDelay(a)?3:(this.upgraded(a,60)?6:4);},
 function reason(a,key)
 {
  local s=this.state(a);if(!this.able(a)||s==null||!s.Active)return "$bv{kanade.unavailable}";
  if(s.Move!=null||this.api().isValkyrieMovementBusy(a.getSkills()))return "$bv{kanade.moving}";
  if(this.cooldown(a,key)>0)return "$bv{kanade.cooling}";
  if((key.find("kanade_hand_sonic_")==0||key=="kanade_sonic_rotation"||key=="kanade_harmonics")&&!this.weaponUsable(a))return "$bv{kanade.weapon_required}";
  if(key=="kanade_delay"&&s.PrimaryRound==::Time.getRound()&&!this.extraDelay(a))return "$bv{kanade.used}";
  if(key=="kanade_harmonics"&&this.liveClones(a).len()>0)return "$bv{kanade.clones_active}";
  if(key=="kanade_absorb"&&this.liveClones(a).len()==0)return "$bv{kanade.no_clones}";
  if(key=="kanade_sonic_rotation"&&!this.upgraded(a,100))return "$bv{kanade.rotation_locked}";
  if(key=="kanade_sonic_rotation"&&s.Rotation>=2)return "$bv{kanade.rotation.exhausted}";
  if(this.cloneActor(a)&&["kanade_hand_sonic_slash","kanade_hand_sonic_pierce","kanade_hand_sonic_sweep","kanade_delay"].find(key)==null)return "$bv{kanade.unavailable}";
  return null;
 },
 function passable(from,t){return from!=null&&t!=null&&(t.IsEmpty||t.IsOccupiedByActor)&&t.IsVisibleForEntity&&from.getDistanceTo(t)==1&&::Math.abs(from.Level-t.Level)<=1;},
 function path(a,dest)
 {
  if(!this.able(a)||dest==null||!dest.IsEmpty||!dest.IsVisibleForEntity||a.getCurrentProperties().IsRooted)return null;
  local start=a.getTile(),max=this.range(a);if(start.ID==dest.ID||start.getDistanceTo(dest)>max)return null;
  local queue=[{Tile=start,Path=[]}],seen={};seen[start.ID]<-true;
  for(local i=0;i<queue.len();i++)
  {
   local node=queue[i];if(node.Path.len()>=max)continue;
   for(local d=0;d<6;d++)if(node.Tile.hasNextTile(d))
   {
    local t=node.Tile.getNextTile(d);if(t.ID in seen||!this.passable(node.Tile,t))continue;
    seen[t.ID]<-true;local route=clone node.Path;route.push(t);if(t.ID==dest.ID)return route;queue.push({Tile=t,Path=route});
   }
  }
  return null;
 },
 function beginMove(a,route)
 {
  local s=this.state(a);if(!this.able(a)||s==null||s.Move!=null||route==null||route.len()==0)return false;
  local tag={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Path=clone route,Index=0,Hold=null,Done=false,Started=false,Step=null,Epoch=this.Epoch,Turn=s.Turn};
  local service=this;tag.Hold=this.api().beginValkyrieMovement(a,function(){service.finishMove(tag);});if(tag.Hold==null)return false;s.Move=tag;
  try{if(!this.nextStep(a,tag)){this.finishMove(tag);return tag.Started;}}
 catch(e){this.finishMove(tag);throw e;}
  return true;
 },
 function finishMove(tag){if(tag==null||tag.Done)return;tag.Done=true;tag.Step=null;if(tag.State.Move==tag)tag.State.Move=null;this.api().endValkyrieMovement(tag.Hold);},
 function validMove(a,tag){return !tag.Done&&tag.Epoch==this.Epoch&&this.able(a)&&this.state(a)==tag.State&&tag.State.Active&&tag.State.Turn==tag.Turn&&tag.State.LastEnd!=tag.State.Turn&&tag.State.Move==tag&&!a.getCurrentProperties().IsRooted;},
 function nextStep(a,tag)
 {
  if(!this.validMove(a,tag)){this.finishMove(tag);return false;}
  if(tag.Index>=tag.Path.len()){this.visual(a.getTile(),"delay");this.finishMove(tag);return true;}
  local from=a.getTile(),index=tag.Index;
  // Occupied cells may be crossed, never used as landing cells. Their hazards still apply.
  while(index<tag.Path.len())
  {
   local to=tag.Path[index];if(!this.passable(from,to)){this.finishMove(tag);return false;}
   if(to.IsEmpty)break;tag.Started=true;
   if(to.Properties.Effect!=null&&to.Properties.Effect.IsAppliedOnEnter&&to.Properties.Effect.Callback!=null)to.Properties.Effect.Callback(to,a);
   if(!this.validMove(a,tag)){this.finishMove(tag);return false;}
 from=to;index++;
  }
  if(index>=tag.Path.len()){this.finishMove(tag);return false;}
  local to=tag.Path[index],step={Move=tag,Index=index,Tile=to,Queued=false};tag.Step=step;
  ::Time.scheduleEvent(::TimeUnit.Virtual,1800,function(t){if(!t.Move.Done&&t.Move.Step==t)::$bvvar{namespace}.Kanade.finishMove(t.Move);},step);
  tag.Started=true;this.visual(a.getTile(),"delay");a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
  ::Tactical.getNavigator().teleport(a,to,this.arrival.bindenv(this),step,false,3.0);return true;
 },
 function arrival(a,step){if(step.Move.Done||step.Move.Step!=step||step.Queued)return;step.Queued=true;this.api().queueValkyrieMovementArrival(step.Move.Hold,this.arrived.bindenv(this),step);},
 function arrived(a,step)
 {
  local tag=step.Move;if(tag.Done||tag.Step!=step)return;
  try{if(!this.validMove(a,tag)||a!=this.api().readValkyrieCombatWeakRef(tag.Actor)||a.getTile().ID!=step.Tile.ID){this.finishMove(tag);return;}
 tag.Step=null;tag.Index=step.Index+1;this.nextStep(a,tag);}
  catch(e){this.finishMove(tag);throw e;}
 },
 function delay(a,tile)
 {
  local s=this.state(a),extra=this.extraDelay(a),self=tile==null||tile.ID==a.getTile().ID;
  if(extra&&self)return false;
  if(!self){local route=this.path(a,tile);if(route==null||!this.beginMove(a,route))return false;}
  if(extra)s.ExtraRound=::Time.getRound();else
  {
   s.PrimaryRound=::Time.getRound();if(!this.cloneActor(a)){s.Defense=true;s.Charges=this.gear(a,"feather_hairpiece",true)!=null?3:2;}
  }
  this.update(a);return true;
 },
 function spawnTiles(a,first)
 {
  local out=[];if(first!=null&&first.IsEmpty&&first.IsVisibleForEntity&&this.passable(a.getTile(),first))out.push(first);
  for(local d=0;d<6;d++)if(a.getTile().hasNextTile(d)){local t=a.getTile().getNextTile(d);if(t.IsEmpty&&this.passable(a.getTile(),t)&&out.find(t)==null)out.push(t);}
  return out;
 },
 function liveClones(a)
 {
  local out=[],s=this.state(a);if(s==null)return out;
  foreach(ref in s.Clones){local c=this.api().readValkyrieCombatWeakRef(ref);if(this.alive(c))out.push(c);}
  out.sort(function(x,y){return x.getID()<y.getID()?-1:(x.getID()>y.getID()?1:0);});return out;
 },
 function summon(a,tile)
 {
  local spots=this.spawnTiles(a,tile),s=this.state(a);if(spots.len()==0||this.liveClones(a).len()>0||!this.weaponUsable(a))return false;
  local cap=this.gear(a,"unsent_thanks",true)!=null?3:2,created=[];
  try{for(local i=0;i<::Math.min(cap,spots.len());i++)
  {
   local t=spots[i],c=::Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/kanade_tachibana_clone",t.Coords.X,t.Coords.Y);
   if(c==null)throw "Harmonics spawn failed";created.push(c);c.configure(a,s.Turn+2);s.Clones.push(this.api().makeValkyrieCombatWeakRef(c));this.visual(t,"harmonics");
  }}
 catch(e){foreach(c in created)this.dismiss(c,false);::logWarning("[Battle Valkyries] "+e);return false;}
  return created.len()>0;
 },
 function dismiss(c,refund)
 {
  if(c==null||!this.cloneActor(c)||c.m.KanadeDismissed)return;
  local live=this.alive(c),a=this.owner(c);c.m.KanadeDismissed=true;
  if(refund&&live&&this.alive(a)&&this.owns(a))a.setFatigue(::Math.max(0,a.getFatigue()-(this.upgraded(a,80)?12:8)));
  if(live)this.visual(c.getTile(),"harmonics");this.stop(c);c.m.IsAlive=false;c.m.IsDying=true;c.m.IsTurnDone=true;c.removeFromMap();this.update(a);
 },
 function absorb(a){local clones=this.liveClones(a);foreach(c in clones)this.dismiss(c,true);this.state(a).Clones=[];this.update(a);return clones.len()>0;},
 function distortion(a,tile)
 {
  local s=this.state(a);s.Distortion=true;s.AllyCharge=false;s.Ally=null;
  if(tile!=null&&tile.IsOccupiedByActor&&tile.getEntity()!=a&&this.gear(a,"uniform_armor",true)!=null)
  {
   local ally=tile.getEntity();s.Ally=this.api().makeValkyrieCombatWeakRef(ally);s.AllyCharge=true;
   local effect=::new("$bvvar{privateFolder}/skills/effects/kanade_tachibana_guard_effect");effect.m.Owner=this.api().makeValkyrieCombatWeakRef(a);ally.getSkills().add(effect);
  }
  this.visual(a.getTile(),"distortion");
 },
 function projectile(skill)
 {
  if(skill==null||!this.api().isDirectAttack(skill)||!skill.isRanged()||!skill.m.IsShowingProjectile)return false;
  return this.api().isActiveWeaponAttack(skill)&&skill.m.IsTargetingActor;
 },
 function melee(skill){return skill!=null&&this.api().isDirectAttack(skill)&&!skill.isRanged()&&skill.m.IsTargetingActor;},
 function howl(a)
 {
  foreach(b in ::Tactical.Entities.getAllInstancesAsArray())
  {
   if(!this.enemy(a,b)||a.getTile().getDistanceTo(b.getTile())>2||!a.getTile().hasLineOfSightTo(b.getTile(),2)||!this.api().EightValkyries.debuffable(b))continue;
   if(b.getFlags().get("IsImmuneToSound")==true||("IsImmuneToSound" in b.getCurrentProperties()&&b.getCurrentProperties().IsImmuneToSound))continue;
   local chance=::Math.max(5,::Math.min(95,a.getCurrentProperties().getMeleeSkill()+20-b.getCurrentProperties().getMeleeDefense()));
   this.visual(b.getTile(),"howling");if(::Math.rand(1,100)>chance)continue;
   if(!b.getCurrentProperties().IsImmuneToStun)b.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/kanade_tachibana_stunned_effect"));
   else if(!b.getSkills().hasSkill("$bvvar{modId}.effect.kanade_howling"))b.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/kanade_tachibana_howling_effect"));
  }
 },
 function visual(tile,cue)
 {
  if(tile==null)return;local anchor={isAlive=function(){return true;},isDying=function(){return false;},isPlacedOnMap=function(){return true;},getTile=function(){return tile;}};
  this.api().playValkyrieVisual(this,anchor,"kanade_"+cue);
 }
};

::$bvvar{namespace}.finalizeKanadeProperties <- function(a,skill,target,p)
{
 local k=::$bvvar{namespace}.Kanade;if(a==null||skill==null||!("BVSkillKey" in skill.m)||skill.m.BVSkillKey==null||skill.m.BVSkillKey.find("kanade_")!=0||!("Spec" in skill.m)||skill.m.Spec==null||!skill.m.Spec.Attack)return p;
 if(!(k.owns(a)||k.cloneActor(a)))return p;
 local d=skill.m.Spec,up=k.cloneActor(a)?a.m.KanadePierceUpgrade:k.gear(a,"hand_sonic",true)!=null;
 p.DamageTotalMult*=d.Damage;p.DamageArmorMult=skill.m.BVSkillKey=="kanade_hand_sonic_pierce"&&up?2.20:d.Armor;
 p.MeleeSkill+=d.Hit;skill.m.DirectDamageMult=skill.m.BVSkillKey=="kanade_hand_sonic_pierce"&&up?0.55:d.Pierce;
 if(k.cloneActor(a)&&skill.m.Assisting)p.DamageTotalMult/=d.Damage;
 return p;
};
