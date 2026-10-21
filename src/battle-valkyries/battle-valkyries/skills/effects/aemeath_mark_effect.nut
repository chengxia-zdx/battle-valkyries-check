this.aemeath_mark_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Kind="syntony",Sources=null,LastTickRound=-1},
 function create(){this.valkyrie_effect_skill.create();this.m.Sources=[];this.m.IsStacking=false;this.m.IsAttack=false;this.configure("syntony");},
 function configure(kind){
  this.m.Kind=kind;this.m.ID="$bvvar{modId}.effects.aemeath_"+kind;
  this.m.Name=kind=="syntony"?"$bv{aemeath.syntony}":"$bv{aemeath.fusion}";
  this.m.Description=kind=="syntony"?"$bv{aemeath.syntony.description}":"$bv{aemeath.fusion.description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/aemeath_"+kind+".png";this.m.IconMini="";
 },
 function count(source=null){local n=0;foreach(entry in this.m.Sources)if(source==null||entry.ID==source.getID())n+=entry.Count;return n;},
 function add(source,n){
  n=::Math.min(n,6-this.count());if(n<=0)return 0;
  foreach(entry in this.m.Sources)if(entry.ID==source.getID()){entry.Count+=n;this.getContainer().update();return n;}
  this.m.Sources.push({ID=source.getID(),Ref=::$bvvar{namespace}.makeValkyrieCombatWeakRef(source),Count=n});this.getContainer().update();return n;
 },
 function consume(){
  foreach(entry in this.m.Sources)if(entry.Count>0){entry.Count--;if(this.count()==0)this.removeSelf();this.getContainer().update();return true;}
 return false;
 },
 function onUpdate(p){if(this.m.Kind=="syntony")p.DamageReceivedArmorMult*=1.0+this.count()*0.1;},
 function onAnySkillUsed(used,target,p){
  if(this.m.Kind!="syntony"||used==null||!used.isAttack()||target==null)return;
  local f=::$bvvar{namespace}.Aemeath,s=f.state(target),a=this.getContainer().getActor();
  if(!f.owns(target)||s==null||!s.m.InCombat||s.m.Form!="ghost"||a.isAlliedWith(target))return;
  local penalty=::Math.min(30,this.count()*10);if(used.isRanged())p.RangedSkill-=penalty;else p.MeleeSkill-=penalty;
 },
 function onTurnStart(){
  local f=::$bvvar{namespace}.Aemeath,r=f.round(),target=this.getContainer().getActor();
  if(this.m.Kind!="fusion"||this.count()==0||this.m.LastTickRound==r||!f.alive(target))return;
  this.m.LastTickRound=r;
  local properties=target.getCurrentProperties();
  if(properties.IsImmuneToFire)return;
  local amount=this.count()*5*::Math.max(0.0,properties.DamageReceivedFireMult);
  if(amount<=0)return;
  local source=null;
  foreach(entry in this.m.Sources)if(entry.Count>0){source=::$bvvar{namespace}.readValkyrieCombatWeakRef(entry.Ref);if(source!=null)break;}
  // Environmental fallback retains the mark when its original actor reference expires.
  if(source==null)source=target;
  local tile=target.getTile(),pos=::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target);
  local result=::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(source,this,target,amount,{ActionToken=null,AttemptToken=null});
  if(result.HitpointDamage>0){f.visual(this,{getTile=function(){return tile;}},"fusion_tick");if(f.owns(source))f.sound(source,"fusion_tick",pos);}
 },
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text="$bv{aemeath.stacks}: "+this.count()+"/6"}];},
 function onCombatFinished(){this.m.Sources=[];this.removeSelf();this.skill.onCombatFinished();}
});
