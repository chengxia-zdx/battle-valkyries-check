this.rachel_alucard_mastery_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function onCombatStarted(){::$bvvar{namespace}.Rachel.start(this.actor());},
 function onUpdate(p){if(::$bvvar{namespace}.Rachel.stage(this.actor())>=2)p.FatigueRecoveryRate+=5;},
 function onBeforeDamageReceived(attacker,skill,hit,p){::$bvvar{namespace}.RachelEquipment.beforeDamage(this.actor(),attacker,skill,hit,p);},
 function onTurnStart(){::$bvvar{namespace}.Rachel.tick(this.actor());},
 function onTurnEnd(){::$bvvar{namespace}.Rachel.end(this.actor());},
 function onValkyrieCombatEvent(e){::$bvvar{namespace}.Rachel.onEvent(this.actor(),e);},
 function onDeath(fatality){::$bvvar{namespace}.Rachel.stop(this.actor());},
 function onCombatFinished(){::$bvvar{namespace}.Rachel.stop(this.actor());this.skill.onCombatFinished();},
 function getTooltip(){local f=::$bvvar{namespace}.Rachel,s=f.state(this.actor()),t=f.tuning(this.actor());return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=::format("$bv{rachel.tip.mastery}",t.WindRecovery,t.OpeningHeat)},{id=3,type="text",icon="ui/icons/special.png",text=::format("$bv{rachel.status}",s==null?0:s.Wind,s==null?0:s.Heat,s==null?0:s.Rods.len())}];}
});
