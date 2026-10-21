this.es_azure_guardian_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function onCombatStarted(){::$bvvar{namespace}.Es.start(this.actor());},
 function onTurnStart(){::$bvvar{namespace}.Es.tick(this.actor());},
 function onDeath(fatality){::$bvvar{namespace}.Es.stop(this.actor());},
 function onCombatFinished(){::$bvvar{namespace}.Es.stop(this.actor());this.skill.onCombatFinished();},
 function getValkyrieAttackNullificationPolicy(skill,attacker){return ::$bvvar{namespace}.Es.guardPolicy(this.actor(),skill,attacker);},
 function consumeValkyrieAttackNullificationPolicy(token,context){if(token=="es_guard"&&context!=null)::$bvvar{namespace}.Es.counter(this.actor(),context.User);}
});
