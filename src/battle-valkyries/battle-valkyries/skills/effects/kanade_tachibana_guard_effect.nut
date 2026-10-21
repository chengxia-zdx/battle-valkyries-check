this.kanade_tachibana_guard_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Owner=null},
 function create(){this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effect.kanade_guard";this.m.Name="$bv{kanade.state.guard.name}";this.m.Description="$bv{kanade.state.guard.description}";this.m.Icon="skills/$bvvar{iconPrefix}/kanade_tachibana_distortion.png";this.m.IconMini="status_effect_03_mini";this.m.IsHidden=false;this.m.IsStacking=false;},
 function valid()
 {
  local f=::$bvvar{namespace}.Kanade,a=f.api().readValkyrieCombatWeakRef(this.m.Owner),b=this.getContainer()==null?null:this.getContainer().getActor(),s=f.state(a);
  return f.alive(a)&&f.alive(b)&&s!=null&&s.Active&&s.Distortion&&s.AllyCharge&&f.api().readValkyrieCombatWeakRef(s.Ally)==b&&a.getTile().getDistanceTo(b.getTile())==1;
 },
 function getValkyrieAttackNullificationPolicy(skill,attacker){return this.valid()&&::$bvvar{namespace}.Kanade.projectile(skill)?{NullifyDirectAttack=true,ConsumeToken="ally"}:null;},
 function consumeValkyrieAttackNullificationPolicy(token,context){local f=::$bvvar{namespace}.Kanade,a=f.api().readValkyrieCombatWeakRef(this.m.Owner),s=f.state(a);if(s!=null)s.AllyCharge=false;this.removeSelf();f.update(this.getContainer().getActor());},
 function isHidden(){return !this.valid();},
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.valid()?this.getDescription():"$bv{kanade.state.inactive}"}];},
 function onTurnStart(){if(!this.valid())this.removeSelf();}
});
