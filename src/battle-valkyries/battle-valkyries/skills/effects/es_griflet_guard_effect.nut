this.es_griflet_guard_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 function create()
 {
  this.valkyrie_effect_skill.create();
  this.m.ID="$bvvar{modId}.effect.es_griflet_guard";
  this.m.Name="$bv{es.griflet.name}";
  this.m.Icon="skills/$bvvar{iconPrefix}/es_griflet.png";
  this.m.IconMini="status_effect_34_mini";
  this.m.IsHidden=false;this.m.IsStacking=false;
 },
 function state(){return ::$bvvar{namespace}.Es.state(this.getContainer()==null?null:this.getContainer().getActor());},
 function isHidden(){local s=this.state();return s==null||!s.Active||!s.Guard;},
 function getTooltip()
 {
  if(this.isHidden())return [];
  return [{id=1,type="title",text=this.getName()},
   {id=2,type="description",text=this.state().GuardEnhanced?"$bv{es.state.guard_enhanced}":"$bv{es.state.guard}"}];
 }
});
