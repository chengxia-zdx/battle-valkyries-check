this.kanade_tachibana_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function onCombatStarted(){::$bvvar{namespace}.Kanade.start(this.actor());},
 function onTurnStart(){::$bvvar{namespace}.Kanade.tick(this.actor());},
 function onTurnEnd(){::$bvvar{namespace}.Kanade.endTurn(this.actor());},
 function onDeath(fatality){::$bvvar{namespace}.Kanade.stop(this.actor());},
 function onCombatFinished(){::$bvvar{namespace}.Kanade.stop(this.actor());this.skill.onCombatFinished();},
 function onRemoved(){local f=::$bvvar{namespace}.Kanade,a=this.actor();if(!f.owns(a)&&!f.cloneActor(a))f.stop(a);},
 function onUpdate(p)
 {
  local f=::$bvvar{namespace}.Kanade,a=this.actor();if(!f.owns(a))return;
  p.MeleeDamageMult*=1.25;p.Initiative+=20;
  foreach(stage in [20,60,100])if(f.upgraded(a,stage))p.ActionPoints++;
  local s=f.state(a);if(s!=null&&s.Active&&s.Defense)p.MeleeDefense+=20;
  if(s!=null&&s.Active&&s.Distortion&&f.upgraded(a,60)){p.MeleeDefense+=20;p.DamageReceivedTotalMult*=0.75;}
 },
 function ignoresShieldFor(skill){return skill!=null&&"BVSkillKey" in skill.m&&skill.m.BVSkillKey=="kanade_hand_sonic_pierce";},
 function getValkyrieAttackNullificationPolicy(skill,attacker)
 {
  local f=::$bvvar{namespace}.Kanade,a=this.actor(),s=f.state(a);if(!f.alive(a)||!f.owns(a)||s==null||!s.Active)return null;
  if(s.Distortion&&f.projectile(skill))return {NullifyDirectAttack=true,ConsumeToken="distortion"};
  if(s.Defense&&s.Charges>0&&f.melee(skill))return {NullifyDirectAttack=true,ConsumeToken="delay"};
  return null;
 },
 function consumeValkyrieAttackNullificationPolicy(token,context)
 {
  local f=::$bvvar{namespace}.Kanade,a=this.actor(),s=f.state(a);if(s==null)return;
  if(token=="delay")s.Charges=::Math.max(0,s.Charges-1);if(f.alive(a))f.visual(a.getTile(),token=="delay"?"delay":"distortion");
  f.update(a);
 },
 function onValkyrieCombatEvent(e)
 {
  local f=::$bvvar{namespace}.Kanade,a=this.actor(),s=f.state(a);if(s==null||!s.Active||e==null)return;
  // ActionStarted is published by the shared commit adapter, before the first hit roll.
  if(e.Type=="ActionStarted"&&e.Actor==a&&!e.IsFree&&!e.IsImplicit&&!e.IsCounterOrAOO&&e.IsDirectAttack)
  {f.clearDistortion(a);}
 },
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];}
});
