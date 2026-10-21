::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.onInit=@(__original) function(){::$bvvar{namespace}.HuTao.reset();return __original();};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.HuTao.reset();return __original();};
 q.setActionStateBySkill=@(__original) function(actor,skill){local r=__original(actor,skill);::$bvvar{namespace}.HuTao.previewSelection(this);return r;};
 q.updateCursorAndTooltip=@(__original) function(selected=false){local r=__original(selected);::$bvvar{namespace}.HuTao.previewSelection(this);return r;};
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){::$bvvar{namespace}.HuTao.reset();return __original(input);};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onTurnEnd=@(__original) function(){local normal=::$bvvar{namespace}.HuTao.normal(this),r=__original();if(normal&&::$bvvar{namespace}.HuTao.owns(this))::$bvvar{namespace}.HuTao.endTurn(this);return r;};
 q.retreat=@(__original) function(){if(::$bvvar{namespace}.HuTao.owns(this))::$bvvar{namespace}.HuTao.stop(this);return __original();};
 q.onRemovedFromMap=@(__original) function(){if(::$bvvar{namespace}.HuTao.owns(this))::$bvvar{namespace}.HuTao.stop(this);return __original();};
 q.onDamageReceived=@(__original) function(attacker,skill,hit)
 {
  local f=::$bvvar{namespace}.HuTao;
  if(!f.owns(this))return __original(attacker,skill,hit);
  if(f.protected(this))
  {
   hit.DamageRegular=0;hit.DamageArmor=0;hit.DamageFatigue=0;hit.DamageInflictedHitpoints=0;hit.DamageInflictedArmor=0;return 0;
  }
  local previous="BVHuTaoHit" in this.m?this.m.BVHuTaoHit:null;
  this.m.BVHuTaoHit <- {Hit=hit,Fatigue=this.getFatigue()};
  local ret=null;try{ret=__original(attacker,skill,hit);}
 catch(e){this.m.BVHuTaoHit=previous;throw e;}
  this.m.BVHuTaoHit=previous;return ret;
 };
});
::$bvvar{namespace}.MH.hook("scripts/items/item_container",function(q){
 q.onBeforeDamageReceived=@(__original) function(attacker,skill,hit,p)
 {
  local ret=__original(attacker,skill,hit,p),a=this.getActor(),f=::$bvvar{namespace}.HuTao,s=f.state(a);
  // The item boundary is after all defensive properties and before native armor
  // subtraction. Nullified attacks never reach this boundary with positive damage.
  if(!f.owns(a)||s==null||!s.Active||!s.Guard||s.GuardRound==::Time.getRound()||!f.enemy(a,attacker)||!f.api().isDirectAttack(skill))return ret;
  if(!f.qualifyingHit(skill,hit,p))return ret;
  s.Guard=false;s.GuardRound=::Time.getRound();p.DamageReceivedTotalMult*=0.10;f.visual(a.getTile(),"butterfly_guard");return ret;
 };
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q){
 q.onCombatFinished=@(__original) function()
 {
  local ret=__original();
  ::$bvvar{namespace}.HuTao.recoverAfterCombat(this.getActor());
  return ret;
 };
 q.update=@(__original) function()
 {
  local a=this.getActor(),f=::$bvvar{namespace}.HuTao,hp=f.owns(a)?a.getHitpoints():null;
  local ret=__original();
  // Vanilla rescales current HP when maximum HP changes. Personal growth and
  // re-equipping Homa must never manufacture healing.
  if(hp!=null&&!f.api().isActorDeadOrDying(a))a.setHitpoints(::Math.min(hp,a.getHitpointsMax()));
  return ret;
 };
 q.onDamageReceived=@(__original) function(attacker,hp,armor)
 {
  local a=this.getActor(),f=::$bvvar{namespace}.HuTao;
  if(a!=null&&"BVSurvivalFrame" in a.m&&a.m.BVSurvivalFrame!=null&&f.claimSurvival(a,hp,a.m.BVSurvivalFrame))
  {
   // Native HP subtraction still sees its lethal local value and clamps to 1.
   // Observers receive the actual HP lost; triggering-hit armor/fatigue is waived.
   hp=::Math.max(0,a.m.BVSurvivalFrame.BeforeHP-1);armor=0;
   if("BVHuTaoHit" in a.m&&a.m.BVHuTaoHit!=null)
   {
    local frame=a.m.BVHuTaoHit;frame.Hit.DamageArmor=0;frame.Hit.DamageInflictedArmor=0;frame.Hit.DamageInflictedHitpoints=hp;
    a.setFatigue(::Math.max(0,frame.Fatigue-(f.upgraded(a,100)?15:0)));
   }
  }
  return __original(attacker,hp,armor);
 };
 q.add=@(__original) function(skill,order=0)
 {
  local a=this.getActor(),f=::$bvvar{namespace}.HuTao;
  if(skill!=null&&f.owns(a))
  {
   local id=skill.getID(),root=["effects.net","effects.rooted","effects.web"].find(id)!=null;
   if(id=="actives.break_free"&&"BVHuTaoRootRejected" in a.m&&a.m.BVHuTaoRootRejected){a.m.BVHuTaoRootRejected=false;return;}
   if(root)a.m.BVHuTaoRootRejected<-false;
   if(f.Negatives.find(id)!=null&&::Math.rand(1,100)<=f.resistance(a))
   {
    if(root)a.m.BVHuTaoRootRejected=true;
    return;
   }
  }
  return __original(skill,order);
 };
});
// Native net/web skills schedule their sprites after add(). A resisted effect
// must not leave an orphan rooted sprite or escape button behind.
::$bvvar{namespace}.MH.hook("scripts/skills/actives/throw_net",function(q){
 q.onNetSpawn=@(__original) function(data){local a=data.TargetEntity;if(::$bvvar{namespace}.HuTao.owns(a)&&!a.getSkills().hasSkill("effects.net"))return;return __original(data);};
});
::$bvvar{namespace}.MH.hook("scripts/skills/actives/web_skill",function(q){
 q.onNetSpawn=@(__original) function(a){if(::$bvvar{namespace}.HuTao.owns(a)&&!a.getSkills().hasSkill("effects.web"))return;return __original(a);};
});
