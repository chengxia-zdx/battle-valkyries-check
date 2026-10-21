this.kanade_tachibana_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,Committed=false,Executing=false,Assisting=false},
 function f(){return ::$bvvar{namespace}.Kanade;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function create()
 {
  this.valkyrie_active_skill.create();this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;
  this.m.IsVisibleTileNeeded=true;this.m.MaxLevelDifference=1;this.m.MaxRangeBonus=0;
 },
 function onValkyrieSkillBound(d)
 {
  this.m.Spec=clone d.Spec;local s=this.m.Spec,k=this.m.BVSkillKey;
  this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.Attack&&k!="kanade_sonic_rotation"?1:0;this.m.MaxRange=s.Range;
  this.m.IsAttack=s.Attack;this.m.IsWeaponSkill=s.Attack;this.m.IsRanged=false;this.m.IsShieldRelevant=s.Attack&&k!="kanade_hand_sonic_pierce";
  this.m.IsTargeted=["kanade_absorb","kanade_howling"].find(k)==null;
  if(k=="kanade_sonic_rotation")this.m.MaxLevelDifference=999;
  this.m.IsTargetingActor=["kanade_hand_sonic_slash","kanade_hand_sonic_pierce","kanade_distortion"].find(k)!=null;
  this.m.IsUsingHitchance=s.Attack;this.m.DirectDamageMult=s.Pierce;
 },
 function onAfterUpdate(p){if(this.m.BVSkillKey=="kanade_delay")this.m.MaxRange=this.f().range(this.actor());},
 function isValkyrieWeaponSkillPolicyOptOut(){return this.f().cloneActor(this.actor());},
 function isHidden(){return this.m.IsHidden||this.m.BVSkillKey=="kanade_absorb"&&this.f().liveClones(this.actor()).len()==0;},
 function isUsable(){return !this.m.Executing&&this.f().reason(this.actor(),this.m.BVSkillKey)==null&&this.skill.isUsable();},
 // The same geometry and target predicate drive preview, validation and every hit.
 function rotationTiles(a)
 {
  local origin=a.getTile(),queue=[origin],seen={},out=[];seen[origin.ID]<-true;
  for(local i=0;i<queue.len();i++)for(local d=0;d<6;d++)if(queue[i].hasNextTile(d))
  {
   local t=queue[i].getNextTile(d);if(t.ID in seen||origin.getDistanceTo(t)>this.m.Spec.Range)continue;
   seen[t.ID]<-true;queue.push(t);out.push(t);
  }
  return out;
 },
 function rotationTarget(a,b)
 {
  return this.f().enemy(a,b)&&b.getTile().IsVisibleForEntity&&!b.isHiddenToPlayer()
   &&a.getTile().getDistanceTo(b.getTile())<=this.m.Spec.Range;
 },
 function rotationReason()
 {
  local a=this.actor(),f=this.f(),reason=f.reason(a,this.m.BVSkillKey);
  if(reason!=null)return reason=="$bv{kanade.cooling}"? ::format("$bv{kanade.rotation.cooldown_remaining}",f.cooldown(a,this.m.BVSkillKey)):reason;
  if(!this.isUsable())return "$bv{kanade.unavailable}";
  if(!this.isAffordableBasedOnAP())return "$bv{kanade.rotation.ap_required}";
  if(!this.isAffordableBasedOnFatigue())return "$bv{kanade.rotation.fatigue_required}";
  if(this.targets(a,a.getTile()).len()==0)return "$bv{kanade.rotation.no_targets}";
  return null;
 },
 function targets(a,tile)
 {
  local k=this.m.BVSkillKey,out=[],origin=a.getTile();
  if(k=="kanade_sonic_rotation")
  {
   foreach(t in this.rotationTiles(a))if(t.IsOccupiedByActor&&this.rotationTarget(a,t.getEntity()))out.push(t.getEntity());
  }
  else if(k=="kanade_hand_sonic_sweep")
  {
   local dir=tile==null?0:origin.getDirectionTo(tile);
   for(local d=0;d<6;d++)if(origin.hasNextTile(d)&&(d==dir||d==(dir+1)%6||d==(dir+5)%6))
   {local t=origin.getNextTile(d);if(t.IsVisibleForEntity&&t.IsOccupiedByActor&&::Math.abs(t.Level-origin.Level)<=1&&this.f().enemy(a,t.getEntity()))out.push(t.getEntity());}
  }
  else if(tile!=null&&tile.IsOccupiedByActor&&this.f().enemy(a,tile.getEntity()))out.push(tile.getEntity());
  return out;
 },
 function onVerifyTarget(origin,tile)
 {
  local f=this.f(),a=this.actor(),k=this.m.BVSkillKey;if(!f.able(a)||origin==null)return false;
  if(k=="kanade_absorb"||k=="kanade_howling")return true;
  if(k=="kanade_sonic_rotation")return tile!=null&&tile.ID==origin.ID&&this.targets(a,origin).len()>0;
  if(tile==null||!tile.IsVisibleForEntity)return false;
  if(k=="kanade_delay")return tile.ID==origin.ID?!f.extraDelay(a):f.path(a,tile)!=null;
  if(k=="kanade_harmonics")return tile.IsEmpty&&f.passable(origin,tile)&&f.weaponUsable(a);
  if(k=="kanade_distortion")return tile.ID==origin.ID||(f.gear(a,"uniform_armor",true)!=null&&tile.IsOccupiedByActor&&f.alive(tile.getEntity())&&a.isAlliedWith(tile.getEntity())&&origin.getDistanceTo(tile)==1);
  return origin.getDistanceTo(tile)==1&&::Math.abs(origin.Level-tile.Level)<=1&&this.targets(a,tile).len()>0;
 },
 function onTargetSelected(tile)
 {
  this.skill.onTargetSelected(tile);local f=this.f(),a=this.actor(),k=this.m.BVSkillKey,tiles=[];
  if(k=="kanade_delay"){local route=f.path(a,tile);if(route!=null)tiles=route;}
  if(k=="kanade_harmonics"){tiles=f.spawnTiles(a,tile);local cap=f.gear(a,"unsent_thanks",true)!=null?3:2;if(tiles.len()>cap)tiles.resize(cap);}
  if(k=="kanade_hand_sonic_sweep"||k=="kanade_sonic_rotation")foreach(b in this.targets(a,tile))tiles.push(b.getTile());
  foreach(t in tiles)::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 },
 function use(tile,free=false)
 {
  local a=this.actor();if(a==null||!this.isUsable())return false;
  local ap=a.getActionPoints(),fatigue=a.getFatigue();this.m.Committed=false;
  try{local result=this.skill.use(tile,free);if(!result&&!this.m.Committed&&!free){a.setActionPoints(ap);a.setFatigue(fatigue);}
 return result;}
  catch(e){if(!this.m.Committed&&!free&&this.f().alive(a)){a.setActionPoints(ap);a.setFatigue(fatigue);}
 throw e;}
 },
 function onUse(a,tile)
 {
  local f=this.f(),k=this.m.BVSkillKey,s=f.state(a),d=this.m.Spec;
  if(this.m.Executing||f.reason(a,k)!=null||!this.onVerifyTarget(a.getTile(),tile))return false;
  local c=f.api().getCurrentValkyrieActionContext(a,this);
  if(c==null||c.IsFree||c.IsImplicit||c.Source!="managed_active"||c.ActionToken in s.Actions)return false;
  if(k=="kanade_delay"){if(!f.delay(a,tile))return false;}
  else if(k=="kanade_harmonics"){if(!f.summon(a,tile))return false;}
  else if(k=="kanade_absorb"){if(!f.absorb(a))return false;}
  this.m.Committed=true;s.Actions[c.ActionToken]<-true;
  s.Cooldowns[k]<-::Time.getRound()+(k=="kanade_howling"&&f.gear(a,"unsent_thanks",true)!=null?2:d.Cooldown);
  if(k=="kanade_distortion")f.distortion(a,tile);
  if(k=="kanade_howling")f.howl(a);
  if(!d.Attack){f.update(a);return true;}
  f.clearDistortion(a);this.m.Executing=true;
  if(k=="kanade_sonic_rotation"){s.Rotation++;f.visual(a.getTile(),"sonic_rotation");}
  local targets=this.targets(a,tile),hitTargets=[];
  try
  {
   foreach(b in targets)
   {
    if(!f.able(a)||!f.weaponUsable(a))break;
    if(k=="kanade_sonic_rotation"?!this.rotationTarget(a,b):(!f.enemy(a,b)||a.getTile().getDistanceTo(b.getTile())!=1))continue;
    f.visual(b.getTile(),k=="kanade_hand_sonic_pierce"?"blade_pierce":"blade_arc");
    local hit=this.attackEntity(a,b,false);if(hit)hitTargets.push(f.api().makeValkyrieCombatWeakRef(b));
    if(hit&&!f.cloneActor(a)&&f.upgraded(a,80)&&f.api().isActorDeadOrDying(b))s.KillRound=::Time.getRound();
   }
   if(k=="kanade_sonic_rotation"&&f.able(a))this.assists(a,hitTargets);
  }
  catch(e){this.m.Executing=false;throw e;}
  this.m.Executing=false;f.update(a);return true;
 },
 function assists(a,targets)
 {
  local f=this.f();foreach(cloneActor in f.liveClones(a))
  {
   if(!f.able(a))break;local state=f.state(cloneActor);
   if(!f.able(cloneActor)||state==null||state.AssistRound==::Time.getRound())continue;
   local eligible=[];foreach(ref in targets){local b=f.api().readValkyrieCombatWeakRef(ref);if(f.enemy(cloneActor,b)&&cloneActor.getTile().getDistanceTo(b.getTile())==1)eligible.push(b);}
   eligible.sort(function(x,y){if(x.getHitpoints()!=y.getHitpoints())return x.getHitpoints()<y.getHitpoints()?-1:1;return x.getID()<y.getID()?-1:1;});
   if(eligible.len()==0)continue;
   local slash=cloneActor.getSkills().getSkillByID(f.api().getValkyrieSkillRuntimeID("kanade_hand_sonic_slash"));if(slash==null)continue;
   state.AssistRound=::Time.getRound();slash.m.Assisting=true;
   local source=f.api().pushValkyrieCombatSource("followup",cloneActor);
   try{slash.attackEntity(cloneActor,eligible[0],false);}
 catch(e){slash.m.Assisting=false;f.api().popValkyrieCombatSource(source);throw e;}
   slash.m.Assisting=false;f.api().popValkyrieCombatSource(source);
  }
 },
 function getTooltip()
 {
  local f=this.f(),a=this.actor(),out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},
   {id=4,type="text",icon="ui/icons/initiative.png",text="$bv{kanade.cooldown}"+f.cooldown(a,this.m.BVSkillKey)}];
  if(this.m.BVSkillKey=="kanade_harmonics"&&f.alive(a))out.push({id=5,type="text",icon="ui/icons/special.png",text="$bv{kanade.spawn_count}"+::Math.min(f.spawnTiles(a,null).len(),f.gear(a,"unsent_thanks",true)!=null?3:2)});
  if(this.m.BVSkillKey=="kanade_sonic_rotation")out.push({id=7,type="text",icon="ui/icons/special.png",text=::format("$bv{kanade.rotation.remaining}",::Math.max(0,2-(f.state(a)==null?0:f.state(a).Rotation)))});
  local reason=this.m.BVSkillKey=="kanade_sonic_rotation"?this.rotationReason():f.reason(a,this.m.BVSkillKey);if(reason!=null)out.push({id=6,type="text",icon="ui/tooltips/warning.png",text=reason});return out;
 },
 function onRemoved(){local s=this.f().state(this.actor());if(this.m.BVSkillKey=="kanade_delay"&&s!=null&&s.Move!=null)this.f().finishMove(s.Move);}
});
