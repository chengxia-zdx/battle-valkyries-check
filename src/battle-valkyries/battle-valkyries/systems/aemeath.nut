// Aemeath's temporary combat state lives on the managed Voyage Together skill.
::$bvvar{namespace}.Aemeath <- {
 api=function(){return ::$bvvar{namespace};},
 alive=function(a){return a!=null&&!this.api().isActorDeadOrDying(a)&&a.isPlacedOnMap();},
 owns=function(a){return a!=null&&this.api().getActorValkyrieID(a)=="aemeath"&&a.isPlayerControlled();},
 enemy=function(a,b){return this.alive(b)&&a!=null&&!a.isAlliedWith(b)&&b.isAttackable();},
 id=function(a){return a==null?"":a.getID().tostring();},
 state=function(a){return a==null?null:a.getSkills().getSkillByID(this.api().getValkyrieSkillRuntimeID("aemeath_voyage"));},
 round=function(){return ::Time.getRound();},
 weapon=function(a){local w=a==null?null:a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);return w!=null&&w.isItemType(::Const.Items.ItemType.MeleeWeapon)?w:null;},
 refresh=function(a){if(a==null)return;a.getSkills().update();a.setDirty(true);},
 mark=function(a,kind){return a==null?null:a.getSkills().getSkillByID("$bvvar{modId}.effects.aemeath_"+kind);},
 count=function(a,kind,source=null){local e=this.mark(a,kind);return e==null?0:e.count(source);},
 add=function(source,target,kind,n){
  if(!this.enemy(source,target)||n<=0)return 0;
  local e=this.mark(target,kind);
  if(e==null){e=::new("$bvvar{privateFolder}/skills/effects/aemeath_mark_effect");e.configure(kind);target.getSkills().add(e);}
  return e.add(source,n);
 },
 consume=function(target,kind){local e=this.mark(target,kind);return e!=null&&e.consume();},
 enemies=function(a){local out=[];foreach(group in ::Tactical.Entities.getAllInstances())foreach(b in group)if(this.enemy(a,b))out.push(b);return out;},
 excluded=function(source){return source=="aoo"||source=="riposte"||source=="counter"||source=="followup"||source=="fixed"||source=="fixed_damage"||source=="damage_over_time";},
 action=function(a,skill){return this.api().getCurrentValkyrieActionContext(a,skill);},
 record=function(a,skill){local s=this.state(a),c=this.action(a,skill);return s==null||c==null||!(c.ActionToken in s.m.Actions)?null:s.m.Actions[c.ActionToken];},
 available=function(skill,a){
  local s=this.state(a),d=skill.m.Spec;
  if(!this.owns(a)||!this.alive(a)||s==null||!s.m.InCombat)return "$bv{aemeath.combat_required}";
  if(this.weapon(a)==null)return "$bv{aemeath.weapon_required}";
  if(d.Form!="any"&&d.Form!=s.m.Form)return "$bv{aemeath.form_required}";
  if(s.m.Sync<d.Sync||s.m.Resonance<d.Resonance)return "$bv{aemeath.resource_required}";
  return null;
 },
 visual=function(context,target,key,options=null){return this.api().playValkyrieVisual(context,target,"aemeath_"+key,options);},
 sound=function(a,key,pos=null){return this.api().playValkyrieSkillAudio(a,"aemeath_"+key,pos);},
 changeForm=function(a,form,gain=true){
  local s=this.state(a);if(!this.alive(a)||s==null||s.m.Form==form)return false;
  local applied=form=="mech"?this.api().setActorTemporaryValkyrieSkin(a,"aemeath_mech_skin"):this.api().clearActorTemporaryValkyrieSkin(a);
  if(applied==false)return false;
  s.m.Form=form;
  local before=s.m.Resonance;if(gain)s.m.Resonance=::Math.min(6,before+1);
  this.visual(s,a,form=="mech"?"transform_mech":"transform_ghost");
  this.visual(s,a,form=="mech"?"mech_ring":"ghost_ring");
  this.sound(a,form=="mech"?"transform_mech":"transform_ghost");
  if(gain&&before<4&&s.m.Resonance>=4){this.visual(s,a,"ready");this.sound(a,"ready");}
  this.refresh(a);return true;
 },
 // Stable target ordering is also used by the selection preview.
 targets=function(skill,tile){
  local a=skill.getContainer().getActor(),d=skill.m.Spec,out=[];
  if(tile==null||!tile.IsOccupiedByActor)return out;
  local primary=tile.getEntity();if(!this.enemy(a,primary))return out;out.push(primary);
  if(d.Targets==1)return out;
  local extra=[];
  foreach(t in this.api().getValkyrieRadiusTiles(tile,1,false)){
   if(!t.IsOccupiedByActor||!t.IsVisibleForEntity)continue;local b=t.getEntity();
   if(b==primary||!this.enemy(a,b))continue;
   // The ultimate's secondary radius is centered on the primary, independent of caster range.
   if(skill.m.BVSkillKey!="aemeath_ultimate"&&a.getTile().getDistanceTo(t)>d.Range)continue;
   if(::Math.abs(a.getTile().Level-t.Level)>4||!a.getTile().hasLineOfSightTo(t,d.Range+1))continue;
   extra.push(b);
  }
  extra.sort(function(x,y){local dx=a.getTile().getDistanceTo(x.getTile()),dy=a.getTile().getDistanceTo(y.getTile());return dx==dy?(x.getID()<y.getID()?-1:1):(dx<dy?-1:1);});
  foreach(b in extra){if(out.len()>=d.Targets)break;out.push(b);}
 return out;
 },
 totalMarks=function(a){local n=0;foreach(b in this.enemies(a))n+=this.count(b,"syntony",a)+this.count(b,"fusion",a);return ::Math.min(20,n);}
};

// Run after ordinary item/perk modifiers, through the existing container adapter.
::$bvvar{namespace}.finalizeAemeathProperties <- function(a,used,target,p){
 local f=::$bvvar{namespace}.Aemeath;if(!f.owns(a)||used==null||!used.isAttack())return p;
 local s=f.state(a);if(s==null||!s.m.InCombat)return p;
 local action=f.record(a,used),form=action==null?s.m.Form:action.Form;
 local resonance=action==null?s.m.Resonance:action.Resonance;
 local key="BVSkillKey" in used.m?used.m.BVSkillKey:null;
 local custom=key!=null&&key.find("aemeath_")==0&&"Spec" in used.m&&used.m.Spec!=null;
 if(form=="ghost"&&f.count(target,"syntony")>0){if(used.isRanged())p.RangedSkill+=20;else p.MeleeSkill+=20;}
 p.DamageDirectAdd+=resonance*0.05;
 local flat=0.0,targetID=f.id(target);
 local permitted=action!=null&&!action.Excluded&&!(targetID in action.BonusUsed);
 if(form=="mech"&&key!="aemeath_ultimate"&&(action==null||permitted)){
  local stacks=action!=null&&targetID in action.Snapshot?action.Snapshot[targetID].Fusion:f.count(target,"fusion");flat=stacks*5.0;
 }
 if(custom){
  local mult=used.m.AttackMult==null?used.m.Spec.Mult:used.m.AttackMult;
  if(key=="aemeath_ultimate"){
   local n=used.m.UltimateMarks==null?f.totalMarks(a):used.m.UltimateMarks;
   local w=used.m.WeaponRoll;
   if(w!=null){p.DamageRegularMin=w;p.DamageRegularMax=w;}
   flat=n*(mult==2.5?10.0:5.0);
  }
  p.DamageRegularMin=::Math.floor(p.DamageRegularMin*mult+flat);
  p.DamageRegularMax=::Math.floor(p.DamageRegularMax*mult+flat);
 }else{p.DamageRegularMin+=flat;p.DamageRegularMax+=flat;}
 return p;
};
