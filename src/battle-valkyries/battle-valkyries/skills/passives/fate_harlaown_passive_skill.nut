this.fate_harlaown_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function onCombatStarted(){::$bvvar{namespace}.FateHarlaown.start(this.actor());},
 function onTurnStart(){::$bvvar{namespace}.FateHarlaown.tick(this.actor());},
 function onTurnEnd(){::$bvvar{namespace}.FateHarlaown.endTurn(this.actor());},
 function onDeath(fatality){::$bvvar{namespace}.FateHarlaown.stop(this.actor());},
 function onCombatFinished(){::$bvvar{namespace}.FateHarlaown.stop(this.actor());this.skill.onCombatFinished();},
 function onRemoved()
 {
  local f=::$bvvar{namespace}.FateHarlaown,a=this.actor(),s=f.state(a);
  if(s!=null&&s.Move!=null)f.finishMove(s.Move);
  // Rebuilding a managed instance must not refill once-per-battle state.
  if(!f.owns(a))f.stop(a);
 },
 function onUpdate(p)
 {
  local f=::$bvvar{namespace}.FateHarlaown,a=this.actor();if(!f.owns(a))return;
  p.Initiative+=15;
  if(f.form(a)){p.Initiative+=25;p.DamageReceivedTotalMult*=1.25;}
 },
 function getTooltip()
 {
  local f=::$bvvar{namespace}.FateHarlaown,s=f.state(this.actor());
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
  if(s!=null&&s.Active){out.push({id=3,type="text",icon="ui/icons/special.png",text=s.Charged?"$bv{fate.charged}":"$bv{fate.steps}"+s.Steps+"/2"});
   if(s.Form)out.push({id=4,type="text",icon="ui/tooltips/warning.png",text="$bv{fate.form_active}"});}
  return out;
 }
});
