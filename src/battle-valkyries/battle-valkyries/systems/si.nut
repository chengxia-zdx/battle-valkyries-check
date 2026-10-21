// Battle-only state. Actor identity remains exclusively in the identity flag.
::$bvvar{namespace}.Si <- {
 Owners=[], Epoch=0,
 function api(){return ::$bvvar{namespace};},
 function round(){return ::Time.getRound();},
 function ref(v){return this.api().makeValkyrieCombatWeakRef(v);},
 function read(v){return this.api().readValkyrieCombatWeakRef(v);},
 function alive(a){return a!=null&&!this.api().isActorDeadOrDying(a)&&a.isPlacedOnMap();},
 function owner(a){return this.alive(a)&&a.isPlayerControlled()&&this.api().getActorValkyrieID(a)=="si";},
 function ally(a,b){return this.alive(a)&&this.alive(b)&&(a==b||this.api().isEligibleRosterAlly(a,b));},
 function enemy(a,b){return this.alive(a)&&this.alive(b)&&!a.isAlliedWith(b)&&b.isAttackable();},
 function able(a){return this.owner(a)&&this.api().EightValkyries.able(a);},
 function state(a){return a!=null&&"BVSiState" in a.m?a.m.BVSiState:null;},
 function start(a)
 {
  if(!this.owner(a))return;
  local s=this.state(a);if(s!=null&&s.Active)return;
  a.m.BVSiState<-{Active=true,Ink=2,Turn=0,LastRound=-999,GainRound=-999,Cooldowns={},Marks=[],Effects=[],Pending={},Completed={},CompletedRound=-999};
  this.Owners.push(this.ref(a));
 },
 function update(a){if(this.alive(a)){a.getSkills().update();a.setDirty(true);}},
 function gain(a,n)
 {
  local s=this.state(a);if(s==null||!s.Active)return;
  local old=s.Ink;s.Ink=::Math.min(6,::Math.max(0,old+n));
  if(old<5&&s.Ink>=5&&this.owner(a)){this.visual(a,a.getTile(),"si_ready");this.sound(a,"si_ready");}
  this.update(a);
 },
 function tick(a)
 {
  local s=this.state(a);
  if(!this.owner(a)||s==null||!s.Active||!this.api().EightValkyries.normal(a)||s.LastRound==this.round())return;
  s.LastRound=this.round();s.Turn++;this.prune(a);this.gain(a,1);
 },
 function cooldown(a,k){local s=this.state(a);return s!=null&&k in s.Cooldowns?::Math.max(0,s.Cooldowns[k]-this.round()):0;},
 function ready(a,k,d)
 {
  local s=this.state(a);return this.able(a)&&s!=null&&s.Active&&s.Ink>=d.Ink&&this.cooldown(a,k)==0;
 },
 function spend(a,k,d){local s=this.state(a);s.Ink-=d.Ink;s.Cooldowns[k]<-this.round()+d.Cooldown;},
 function hide(sprite){if(sprite!=null){try{sprite.Visible=false;sprite.Alpha=0;}
catch(e){}}},
 function removeMark(rec)
 {
  this.hide(rec.Decal);rec.Decal=null;
  local e=this.read(rec.Effect);if(e!=null)e.removeSelf();
 },
 function marks(a)
 {
  local s=this.state(a),out=[];if(s==null||!s.Active)return out;
  foreach(m in s.Marks)if(this.enemy(a,this.read(m.Target))&&s.Turn<m.Until)out.push(m);
  return out;
 },
 function marked(a,b)
 {
  foreach(m in this.marks(a))if(this.read(m.Target)==b)return true;return false;
 },
 function effect(a,b,kind,turns)
 {
  local id="$bvvar{modId}.effects.si_"+kind+"_"+a.getID(),e=b.getSkills().getSkillByID(id);
  if(e==null){e=::new("$bvvar{privateFolder}/skills/effects/si_effect");e.configure(a,kind,id);b.getSkills().add(e);this.state(a).Effects.push(this.ref(e));}
  e.m.Until=this.state(a).Turn+turns;return e;
 },
 function mark(a,b)
 {
  if(!this.owner(a)||!this.enemy(a,b))return false;
  this.prune(a);local s=this.state(a),rec=null;
  foreach(m in s.Marks)if(this.read(m.Target)==b){rec=m;break;}
  if(rec==null)
  {
   if(s.Marks.len()>=3){this.removeMark(s.Marks[0]);s.Marks.remove(0);}
   rec={Target=this.ref(b),ID=b.getID(),Until=s.Turn+2,Effect=null,Decal=null,TileID=null};s.Marks.push(rec);
  }
  rec.Until=s.Turn+2;local e=this.effect(a,b,"mark",2);rec.Effect=this.ref(e);
  this.visual(a,b.getTile(),"si_mark_apply");this.update(b);this.refreshMark(a,rec);return true;
 },
 function clearMarks(a)
 {
  local s=this.state(a);if(s==null)return;foreach(m in s.Marks)this.removeMark(m);s.Marks=[];
 },
 function refreshMark(a,m)
 {
  local b=this.read(m.Target);if(!this.enemy(a,b))return;
  local tile=b.getTile();if(m.TileID==tile.ID&&m.Decal!=null)return;
  this.hide(m.Decal);m.Decal=null;m.TileID=tile.ID;
  try{m.Decal=tile.spawnDetail("effect_bv_si_ink_seal",0,false,false);m.Decal.Alpha=165;}
  catch(e){::logWarning("[Battle Valkyries] Si ink seal: "+e);}
 },
 function prune(a)
 {
  local s=this.state(a);if(s==null||!s.Active)return;
  for(local i=s.Marks.len()-1;i>=0;i--)
  {
   local m=s.Marks[i];if(!this.enemy(a,this.read(m.Target))||s.Turn>=m.Until){this.removeMark(m);s.Marks.remove(i);}
   else this.refreshMark(a,m);
  }
  for(local i=s.Effects.len()-1;i>=0;i--)
  {
   local e=this.read(s.Effects[i]);
   if(e==null||e.isGarbage()){s.Effects.remove(i);continue;}
   if(!e.valid()){local b=e.getContainer()==null?null:e.getContainer().getActor();e.removeSelf();this.update(b);s.Effects.remove(i);}
  }
 },
 function refresh()
 {
  for(local i=this.Owners.len()-1;i>=0;i--)
  {
   local a=this.read(this.Owners[i]),s=this.state(a);
   if(!this.owner(a)||s==null||!s.Active){this.stop(a);this.Owners.remove(i);}
else this.prune(a);
  }
 },
 function stop(a)
 {
  local s=this.state(a);if(s==null)return;
  s.Active=false;this.clearMarks(a);
  foreach(r in s.Effects){local e=this.read(r);if(e!=null){local b=e.getContainer()==null?null:e.getContainer().getActor();e.removeSelf();this.update(b);}}
  s.Effects=[];s.Pending={};s.Ink=0;
 },
 function reset(touchSprites=true)
 {
  this.Epoch++;
  foreach(r in this.Owners)
  {
   local a=this.read(r);if(a==null)continue;
   if(touchSprites)this.stop(a);a.m.BVSiState<-null;
  }
  this.Owners=[];
 },
 function sound(a,cue,pos=null){this.api().playValkyrieSkillAudio(a,cue,pos);},
 // Delay cosmetics only. No delayed callback owns combat damage or costs.
 function visual(a,tile,theme,delay=0,opts=null)
 {
  if(tile==null)return;
  if(delay<=0)
  {
   // The shared renderer validates actor-like targets. This is a captured tile,
   // not the hit actor (which may already have detached after a lethal hit).
   local anchor={isAlive=function(){return true;},isDying=function(){return false;},isPlacedOnMap=function(){return true;},getTile=function(){return tile;}};
   this.api().playValkyrieVisual(this,anchor,theme,opts);return;
  }
  local tag={Epoch=this.Epoch,Owner=this.ref(a),Tile=tile,Theme=theme,Options=opts};
  ::Time.scheduleEvent(::TimeUnit.Virtual,delay,function(t){local f=::$bvvar{namespace}.Si,a=f.read(t.Owner);if(f.Epoch!=t.Epoch||!f.owner(a))return;f.visual(a,t.Tile,t.Theme,0,t.Options);},tag);
 },
 function link(a,from,to)
 {
  if(from==null||to==null||from.ID==to.ID)return;
  local at=from;
  for(local i=0;i<12&&at.ID!=to.ID;i++)
  {
   local next=null,best=at.getDistanceTo(to);
   for(local d=0;d<6;d++)if(at.hasNextTile(d)){local t=at.getNextTile(d),dist=t.getDistanceTo(to);if(dist<best){best=dist;next=t;}}
   if(next==null)break;at=next;this.visual(a,at,"si_ink_transfer",i*45);
  }
 },
 function nearbyEnemies(a,b)
 {
  local out=[b],rest=[];
  foreach(t in this.api().getValkyrieRadiusTiles(b.getTile(),1,true))if(t.IsOccupiedByActor)
  {
   local c=t.getEntity();if(c!=b&&this.enemy(a,c))rest.push(c);
  }
  rest.sort(function(x,y){if(x.getHitpoints()!=y.getHitpoints())return y.getHitpoints()-x.getHitpoints();return x.getID()-y.getID();});
  foreach(c in rest)if(out.len()<3)out.push(c);return out;
 },
 function landscape(a,b)
 {
  local list=this.nearbyEnemies(a,b);this.clearMarks(a);
  this.visual(a,a.getTile(),"si_scroll_cast");this.sound(a,"si_scroll_open");
  foreach(c in list)this.mark(a,c);
  for(local i=1;i<list.len();i++)this.link(a,list[0].getTile(),list[i].getTile());
  local p=b.getCurrentProperties();
  if(!p.IsImmuneToRoot&&!("IsImmuneToDebuffs" in p&&p.IsImmuneToDebuffs))
  {
   local e=this.effect(a,b,"root",999);e.m.TargetEnd=("BVEightNormalEnds" in b.m?b.m.BVEightNormalEnds:0)+1;
   this.visual(a,b.getTile(),"si_root");this.sound(a,"si_mark",this.api().captureValkyrieSkillAudioPosition(b));this.update(b);
  }
 },
 function sanctuary(a,b)
 {
  this.visual(a,a.getTile(),"si_cast");this.visual(a,b.getTile(),"si_lotus_pool");this.sound(a,"si_lotus_open");
  foreach(c in ::World.getPlayerRoster().getAll())if(this.ally(a,c)&&c.getTile().getDistanceTo(b.getTile())<=1)
  {
   local e=this.effect(a,c,"ward",2);e.m.Amount=40;
   this.visual(a,c.getTile(),"si_lotus_dome",100);this.update(c);
  }
 },
 function afterglow(a)
 {
  foreach(c in ::World.getPlayerRoster().getAll())if(this.ally(a,c)&&a.getTile().getDistanceTo(c.getTile())<=3)
  {
   local e=this.effect(a,c,"echo",1);e.m.ActionToken=null;e.m.Consumed=false;
   this.visual(a,c.getTile(),"si_afterglow",250);this.update(c);
  }
 },
 function direct(event)
 {
  return event.Skill!=null&&this.api().isDirectAttack(event.Skill)
   &&!this.api().isValkyrieFollowup(event)&&!this.api().isCounterOrAOO(event)
   &&event.Skill.getID()!="$bvvar{modId}.skill.si_dragon";
 },
 function combat(a,skill,event)
 {
  local s=this.state(a);if(!this.owner(a)||s==null||!s.Active||!("ActionToken" in event)||event.ActionToken==null)return;
  local token=event.ActionToken;
  // Buff consumption is tied to a root attack action, including all its segments.
  if(event.Type=="ActionStarted"||event.Type=="ActionResolved")
  {
   foreach(r in s.Effects)
   {
    local e=this.read(r);if(e==null||e.isGarbage()||e.m.SiKind!="echo"||!e.valid())continue;
    local b=e.getContainer().getActor();
    if(event.Type=="ActionStarted"&&event.Actor==b&&event.IsDirectAttack&&!this.api().isValkyrieFollowup(event)&&!this.api().isCounterOrAOO(event)&&e.m.ActionToken==null&&!e.m.Consumed)e.m.ActionToken=token;
    if(event.Type=="ActionResolved"&&e.m.ActionToken==token){e.m.Consumed=true;e.removeSelf();this.update(b);}
   }
  }
  if(!this.direct(event))return;
  if(event.Type=="ActionStarted")
  {
   if(!this.ally(a,event.Actor)||token in s.Pending)return;
   if(s.CompletedRound!=this.round()){s.Completed={};s.CompletedRound=this.round();}
   if(token in s.Completed)return;
   local ids={};foreach(m in this.marks(a))ids[m.ID]<-true;
   s.Pending[token]<-{Marked=ids,Hit={},Damage=0,Attempts={},Origin=null,Attacker=this.ref(event.Actor)};
  }
  if(!(token in s.Pending))return;
  local rec=s.Pending[token];
  if(event.Type=="TargetResolved")
  {
   if(event.AttemptToken in rec.Attempts)return;rec.Attempts[event.AttemptToken]<-true;
   if(event.Hit)rec.Hit[event.TargetID]<-true;
   if(event.Hit&&event.TargetID in rec.Marked&&event.HitpointDamage>0)
   {
    rec.Damage+=event.HitpointDamage;
    if(event.Target!=null&&event.Target.isPlacedOnMap())rec.Origin=event.Target.getTile();
   }
  }
  if(event.Type!="ActionResolved")return;
  delete s.Pending[token];s.Completed[token]<-true;
  if(!event.UseResult||rec.Damage<=0)return;
  local attacker=this.read(rec.Attacker);
  if(attacker!=a&&this.ally(a,attacker)&&s.GainRound!=this.round()){s.GainRound=this.round();this.gain(a,1);}
  local damage=::Math.min(40,::Math.floor(rec.Damage*0.30).tointeger()),played=false;
  if(damage<=0)return;
  foreach(m in this.marks(a))
  {
   if(!this.owner(a))break;
   local b=this.read(m.Target);if(!(m.ID in rec.Marked)||m.ID in rec.Hit||!this.enemy(a,b))continue;
   local tile=b.getTile(),pos=this.api().captureValkyrieSkillAudioPosition(b);
   if(rec.Origin!=null)this.link(a,rec.Origin,tile);
   this.visual(a,tile,"si_soul_impact");
   this.api().applyValkyrieFixedHitpointDamage(a,skill,b,damage,{Source="si_ink_echo",ParentActionToken=token});
   if(!played){this.sound(a,"si_soul",pos);played=true;}
  }
  this.prune(a);
 }
};
