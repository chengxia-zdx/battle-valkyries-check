// Battle-local UI session. A preview never calls skill.use or creates an action token.
::$bvvar{namespace}.KanadeRotationPreview <- {
 Current=null,Serial=0,Confirming=false,RefreshAt=0.0,
 function api(){return ::$bvvar{namespace};},
 function matches(skill){return skill!=null&&"BVSkillKey" in skill.m&&skill.m.BVSkillKey=="kanade_sonic_rotation";},
 function data(a,skill)
 {
  local f=this.api().Kanade,targets=skill.targets(a,a.getTile()),clones=f.liveClones(a),potential=0,signature="";
  foreach(b in targets)signature+=b.getID()+":"+b.getTile().ID+":"+b.getHitpoints()+";";
  foreach(c in clones)
  {
   local s=f.state(c),eligible=f.able(c)&&s!=null&&s.AssistRound!=::Time.getRound()
    &&c.getSkills().getSkillByID(this.api().getValkyrieSkillRuntimeID("kanade_hand_sonic_slash"))!=null;
   signature+="c"+c.getID()+":"+c.getTile().ID+":"+eligible+";";
   if(!eligible)continue;
   foreach(b in targets)if(f.enemy(c,b)&&c.getTile().getDistanceTo(b.getTile())==1){potential++;break;}
  }
  local actorState=f.state(a),remaining=::Math.max(0,2-(actorState==null?0:actorState.Rotation)),reason=skill.rotationReason();
  local d={Title="$bv{kanade.rotation.preview_title}",Range="$bv{kanade.rotation.range}",
   Targets=::format("$bv{kanade.rotation.targets}",targets.len()),
   Clones=clones.len()==0?"$bv{kanade.rotation.no_clones}": ::format("$bv{kanade.rotation.clones}",clones.len(),potential),
   Assist="$bv{kanade.rotation.assist_note}",
   Cost=::format("$bv{kanade.rotation.cost}",skill.getActionPointCost(),skill.getFatigueCost(),skill.m.Spec.Cooldown),
   Remaining=::format("$bv{kanade.rotation.uses}",remaining,::Math.max(0,remaining-1)),
   Reason=reason,CanConfirm=reason==null,Confirm="$bv{kanade.rotation.confirm}",Cancel="$bv{kanade.rotation.cancel}",Hint="$bv{kanade.rotation.cancel_hint}"};
  d.Signature<-signature+d.Cost+d.Remaining+d.Reason+":"+a.getActionPoints()+":"+a.getFatigue();
  return d;
 },
 function valid(state)
 {
  local p=this.Current;if(p==null||p.State!=state)return false;
  local a=this.api().readValkyrieCombatWeakRef(p.Actor);
  return this.api().Kanade.alive(a)&&a.isPlayerControlled()&&!state.isBattleEnded()
   &&::Tactical.TurnSequenceBar.getActiveEntity()==a&&a.getTile().ID==p.Origin&&::Time.getRound()==p.Round
   &&state.m.SelectedSkillID==p.Skill.getID()&&a.getSkills().getSkillByID(p.Skill.getID())==p.Skill
   &&!a.getSkills().isBusy();
 },
 function draw(a,skill)
 {
  local h=::Tactical.getHighlighter();h.clear();
  // Native range shading includes empty cells; MaxLevelDifference does not clip cliffs.
  h.highlightRangeOfSkill(skill,a);
  foreach(b in skill.targets(a,a.getTile()))
  {local t=b.getTile();h.addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);}
 },
 function send(d)
 {
  local p=this.Current;p.Revision++;p.Signature=d.Signature;delete d.Signature;
  d.Token<-p.Token;d.Revision<-p.Revision;
  p.Screen.m.JSHandle.asyncCall("showKanadeRotationPreview",d);
 },
 function close(cancelSelection=true)
 {
  local p=this.Current;if(p==null)return;
  this.Current=null;
  if(p.Screen!=null&&p.Screen.m.JSHandle!=null)p.Screen.m.JSHandle.asyncCall("hideKanadeRotationPreview",p.Token);
  if(cancelSelection&&p.State.m.SelectedSkillID==p.Skill.getID())
   p.State.cancelEntitySkill(this.api().readValkyrieCombatWeakRef(p.Actor));
 },
 function open(state,a,skill)
 {
  if(!this.matches(skill))return false;
  if(this.Current!=null&&this.Current.Skill==skill){this.close();return true;}
  this.close();
  if(state.isInputLocked()||state.isBattleEnded()||!this.api().Kanade.alive(a)||!a.isPlayerControlled()
   ||a.getSkills().isBusy()||::Tactical.TurnSequenceBar.getActiveEntity()!=a)return true;
  local screen=state.m.TacticalScreen;
  if(screen==null||screen.m.JSHandle==null)return true;
  state.cancelCurrentAction();
  state.m.SelectedSkillID=skill.getID();state.m.CurrentActionState=::Const.Tactical.ActionState.SkillSelected;
  this.Current={State=state,Screen=screen,Actor=this.api().makeValkyrieCombatWeakRef(a),Skill=skill,
   Token=++this.Serial,Revision=0,Signature="",Origin=a.getTile().ID,Round=::Time.getRound()};
  ::Tactical.TurnSequenceBar.selectSkillById(skill.getID(),true);
  ::Tactical.TurnSequenceBar.setActiveEntityCostsPreview({ActionPoints=skill.getActionPointCost(),Fatigue=skill.getFatigueCost(),SkillID=skill.getID()});
  this.draw(a,skill);this.send(this.data(a,skill));this.RefreshAt=0.0;
  return true;
 },
 function refresh(state)
 {
  if(this.Current==null)return;
  if(!this.valid(state)){this.close();return;}
  if(::Time.getRealTimeF()<this.RefreshAt)return;
  this.RefreshAt=::Time.getRealTimeF()+0.2;
  local p=this.Current,a=this.api().readValkyrieCombatWeakRef(p.Actor),d=this.data(a,p.Skill);
  if(d.Signature!=p.Signature){this.draw(a,p.Skill);this.send(d);}
 },
 function request(screen,request)
 {
  local p=this.Current;
  if(p==null||p.Screen!=screen||request==null||!("Token" in request)||request.Token!=p.Token)return false;
  if("Cancel" in request&&request.Cancel){this.close();return true;}
  if(!this.valid(p.State)||p.State.isInputLocked()){this.close();return false;}
  local a=this.api().readValkyrieCombatWeakRef(p.Actor),d=this.data(a,p.Skill);
  if(!("Revision" in request)||request.Revision!=p.Revision||d.Signature!=p.Signature||!d.CanConfirm)
  {this.draw(a,p.Skill);this.send(d);return false;}
  // Consume the UI token before entering the existing paid skill pipeline.
  this.close(false);this.Confirming=true;
  try{p.State.executeEntitySkill(a,a.getTile());}
  catch(e){this.Confirming=false;p.State.cancelEntitySkill(a);throw e;}
  this.Confirming=false;return true;
 }
};
