this.hu_tao_sanguine_rouge_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function onCombatStarted(){::$bvvar{namespace}.HuTao.start(this.actor());},
 function onTurnStart(){::$bvvar{namespace}.HuTao.tick(this.actor());},
 function onDeath(f){::$bvvar{namespace}.HuTao.stop(this.actor());},
 function onCombatFinished()
 {
  local f=::$bvvar{namespace}.HuTao,a=this.actor();f.stop(a);this.skill.onCombatFinished();
  // The container is still iterating skills here. Heal only after its final
  // update, when all battle-end effects and injury penalties have settled.
  if(f.owns(a)&&!f.api().isActorDeadOrDying(a))a.m.BVHuTaoRecoveryPending <- true;
 },
 function onUpdate(p)
 {
  local f=::$bvvar{namespace}.HuTao,a=this.actor();if(!f.owns(a))return;
  // HitpointsMult receives the additive percentage. Flat equipment/growth HP is
  // applied before the engine computes getHitpointsMax, irrespective of order.
  p.HitpointsMult+=0.25;f.api().HuTaoEquipment.properties(a,p);
  foreach(n in [20,60,100])if(f.upgraded(a,n))p.ActionPoints++;
  if(f.reborn(a)){p.MeleeDefense+=25;p.RangedDefense+=25;p.MeleeSkill+=20;p.Bravery+=30;}
 },
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];}
});
