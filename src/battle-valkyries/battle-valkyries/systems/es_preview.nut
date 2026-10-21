::$bvvar{namespace}.EsPreview <- {
 Current=null,Serial=0,Confirming=false,RefreshAt=0.0,
 function api(){return ::$bvvar{namespace};},
 function matches(skill){return skill!=null&&"BVSkillKey" in skill.m&&["es_mordred","es_galahad"].find(skill.m.BVSkillKey)!=null;},
 function data(a,skill,tile)
 {
  local f=this.api().Es,reason=f.reason(a,skill.m.BVSkillKey),route=null;
  if(reason==null&&!skill.onVerifyTarget(a.getTile(),tile))reason="$bv{es.preview.invalid}";
  if(reason==null&&!skill.isAffordableBasedOnAP())reason="$bv{es.preview.ap}";
  if(reason==null&&!skill.isAffordableBasedOnFatigue())reason="$bv{es.preview.fatigue}";
  if(tile.IsOccupiedByActor)route=f.path(a,tile.getEntity());
  local signature=tile.ID+":"+(tile.IsOccupiedByActor?tile.getEntity().getID():0)+":"+a.getActionPoints()+":"+a.getFatigue()+":"+f.state(a).Heat;
  if(route!=null)foreach(t in route)signature+=";"+t.ID;
  local d={Title=skill.getName(),Mode=false,Charged=false,
   Normal="$bv{es.preview.normal}",Charge="$bv{es.preview.charged}",
   Detail=::format("$bv{es.preview.route}",route==null?0:route.len()),
   Cost=::format("$bv{es.preview.cost}",skill.getActionPointCost(),skill.getFatigueCost(),skill.m.Spec.Heat),
   Reason=reason,CanConfirm=reason==null,Confirm="$bv{es.preview.confirm}",Cancel="$bv{es.preview.cancel}",Hint="$bv{es.preview.hint}"};
  d.Signature<-signature+d.Cost+d.Detail+d.Reason;return d;
 },
 function valid(state)
 {
  local p=this.Current;if(p==null||p.State!=state)return false;
  local a=this.api().readValkyrieCombatWeakRef(p.Actor);
  return this.api().Es.alive(a)&&!state.isBattleEnded()&&::Tactical.TurnSequenceBar.getActiveEntity()==a
   &&a.getTile().ID==p.Origin&&::Time.getRound()==p.Round&&state.m.SelectedSkillID==p.Skill.getID()
   &&a.getSkills().getSkillByID(p.Skill.getID())==p.Skill&&!a.getSkills().isBusy();
 },
 function draw(a,skill,tile){local h=::Tactical.getHighlighter();h.clear();h.highlightRangeOfSkill(skill,a);skill.onTargetSelected(tile);},
 function send(d){local p=this.Current;p.Revision++;p.Signature=d.Signature;delete d.Signature;d.Token<-p.Token;d.Revision<-p.Revision;p.Screen.m.JSHandle.asyncCall("showEsPreview",d);},
 function close(cancel=true)
 {
  local p=this.Current;if(p==null)return;this.Current=null;
  if(p.Screen!=null&&p.Screen.m.JSHandle!=null)p.Screen.m.JSHandle.asyncCall("hideEsPreview",p.Token);
  if(cancel){if(p.State.m.SelectedSkillID==p.Skill.getID())p.State.cancelEntitySkill(this.api().readValkyrieCombatWeakRef(p.Actor));}
 },
 function open(state,a,skill,tile)
 {
  if(!this.matches(skill))return false;
  if(this.Current!=null)return true;
  if(state.isInputLocked()||state.isBattleEnded()||!this.api().Es.alive(a)||a.getSkills().isBusy()||tile==null)return true;
  local screen=state.m.TacticalScreen;if(screen==null||screen.m.JSHandle==null)return true;
  this.Current={State=state,Screen=screen,Actor=this.api().makeValkyrieCombatWeakRef(a),Skill=skill,Tile=tile,
   Token=++this.Serial,Revision=0,Signature="",Origin=a.getTile().ID,Round=::Time.getRound()};
  this.draw(a,skill,tile);this.send(this.data(a,skill,tile));this.RefreshAt=0.0;return true;
 },
 function refresh(state)
 {
  if(this.Current==null)return;if(!this.valid(state)){this.close();return;}
  if(::Time.getRealTimeF()<this.RefreshAt)return;this.RefreshAt=::Time.getRealTimeF()+0.2;
  local p=this.Current,a=this.api().readValkyrieCombatWeakRef(p.Actor),d=this.data(a,p.Skill,p.Tile);
  if(d.Signature!=p.Signature){this.draw(a,p.Skill,p.Tile);this.send(d);}
 },
 function request(screen,request)
 {
  local p=this.Current;if(p==null||p.Screen!=screen||request==null||!("Token" in request)||request.Token!=p.Token)return false;
  if("Cancel" in request&&request.Cancel){this.close();return true;}
  if(!this.valid(p.State)||p.State.isInputLocked()){this.close();return false;}
  local a=this.api().readValkyrieCombatWeakRef(p.Actor);
  local d=this.data(a,p.Skill,p.Tile);
  if(!("Revision" in request)||request.Revision!=p.Revision||d.Signature!=p.Signature||!d.CanConfirm){this.draw(a,p.Skill,p.Tile);this.send(d);return false;}
  this.close(false);this.Confirming=true;
  try{p.State.executeEntitySkill(a,p.Tile);}
 catch(e){this.Confirming=false;p.State.cancelEntitySkill(a);throw e;}
  this.Confirming=false;return true;
 }
};
