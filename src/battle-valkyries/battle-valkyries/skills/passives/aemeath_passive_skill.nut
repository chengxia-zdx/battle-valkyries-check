this.aemeath_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 m={Form="ghost",Sync=0,Resonance=0,InCombat=false,StartRound=0,LastRecoveryRound=-1,Actions=null},
 function create(){this.valkyrie_passive_skill.create();this.m.Actions={};},
 function owner(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function f(){return ::$bvvar{namespace}.Aemeath;},
 function core(){return this.m.BVSkillKey=="aemeath_voyage";},
 function onCombatStarted(){
  if(!this.core()||!this.f().owns(this.owner()))return;
  this.m.Form="ghost";this.m.Sync=2;this.m.Resonance=0;this.m.InCombat=true;
  this.m.StartRound=::Math.max(1,this.f().round());this.m.LastRecoveryRound=this.m.StartRound;this.m.Actions={};
  ::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(this.owner());
 },
 function onTurnStart(){
  if(!this.core()||!this.m.InCombat||!this.f().alive(this.owner()))return;
  local r=this.f().round();if(r<=this.m.StartRound||r==this.m.LastRecoveryRound)return;
  this.m.LastRecoveryRound=r;this.m.Sync=::Math.min(6,this.m.Sync+1);this.f().refresh(this.owner());
 },
 function onValkyrieCombatEvent(e){
  if(!this.core()||!this.m.InCombat||e==null||!("Type" in e))return;
  local a=this.owner(),f=this.f(),token="ActionToken" in e?e.ActionToken:null;
  if(token==null)return;
  if(e.Type=="ActionResolved"){if(token in this.m.Actions)delete this.m.Actions[token];return;}
  if(e.Type=="ActionStarted"&&"Actor" in e&&f.id(e.Actor)==f.id(a)){
   local blocked=f.excluded(e.Source)||e.IsFree||e.IsImplicit;
   local snapshot={};foreach(b in f.enemies(a))snapshot[f.id(b)]<-{Fusion=f.count(b,"fusion"),Syntony=f.count(b,"syntony")};
   this.m.Actions[token]<-{Form=this.m.Form,Resonance=this.m.Resonance,Excluded=blocked,Gained=false,Marked={},BonusUsed={},Snapshot=snapshot,Paid=false};
   return;
  }
  if(e.Type!="DamageResolved"||!(token in this.m.Actions)||f.id(e.Attacker)!=f.id(a)||!f.alive(a))return;
  local action=this.m.Actions[token];
  if(action.Excluded||f.excluded(e.Source)||e.HitpointDamage+e.ArmorDamage<=0||e.Skill==null||!e.Skill.isAttack()||e.Victim==null||a.isAlliedWith(e.Victim))return;
  local custom="BVSkillKey" in e.Skill.m&&e.Skill.m.BVSkillKey!=null&&e.Skill.m.BVSkillKey.find("aemeath_")==0;
  if(!custom&&!::$bvvar{namespace}.isActiveWeaponAttack(e.Skill))return;
  if(!action.Gained){action.Gained=true;this.m.Sync=::Math.min(6,this.m.Sync+1);}
  local id=f.id(e.Victim);action.BonusUsed[id]<-true;
  if(!(id in action.Marked)&&!(custom&&e.Skill.m.BVSkillKey=="aemeath_ultimate")){
   action.Marked[id]<-true;f.add(a,e.Victim,action.Form=="ghost"?"syntony":"fusion",1);
  }
  a.setDirty(true);
 },
 function getTooltip(){
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
  local s=this.f().state(this.owner());
  if(s!=null)out.push({id=3,type="text",icon="ui/icons/special.png",text=(s.m.Form=="ghost"?"$bv{aemeath.ghost}":"$bv{aemeath.mech}")+" | $bv{aemeath.sync}: "+s.m.Sync+"/6 | $bv{aemeath.resonance}: "+s.m.Resonance+"/6"});return out;
 },
 function cleanup(){
  if(!this.core())return;
  local a=this.owner();if(a!=null&&::$bvvar{namespace}.getActorTemporaryValkyrieSkinID(a)=="aemeath_mech_skin")::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(a);
  this.m.Form="ghost";this.m.Sync=0;this.m.Resonance=0;this.m.InCombat=false;this.m.Actions={};
 },
 // Keep the temporary death brush available while the engine creates the corpse.
 function onDeath(type){if(this.core()){this.m.InCombat=false;this.m.Actions={};this.m.Sync=0;this.m.Resonance=0;}},
 function onRemoved(){this.cleanup();},
 function onCombatFinished(){this.cleanup();this.skill.onCombatFinished();}
});
