this.si_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 m={},
 function create(){this.valkyrie_passive_skill.create();},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function onCombatStarted(){::$bvvar{namespace}.Si.start(this.actor());},
 function onTurnStart(){::$bvvar{namespace}.Si.tick(this.actor());},
 function onDeath(fatality){::$bvvar{namespace}.Si.stop(this.actor());},
 function onCombatFinished(){::$bvvar{namespace}.Si.stop(this.actor());this.skill.onCombatFinished();},
 function onValkyrieCombatEvent(event){::$bvvar{namespace}.Si.combat(this.actor(),this,event);},
 function getTooltip()
 {
  local s=::$bvvar{namespace}.Si.state(this.actor());
  return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
   {id=3,type="text",icon="ui/icons/special.png",text="$bv{si.ink}"+(s==null?0:s.Ink)+" / 6"},
   {id=4,type="text",icon="ui/icons/vision.png",text="$bv{si.mark_count}"+::$bvvar{namespace}.Si.marks(this.actor()).len()+" / 3"}];
 }
});
