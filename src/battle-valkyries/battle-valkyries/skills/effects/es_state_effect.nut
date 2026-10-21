this.es_state_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 function create()
 {
  this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effect.es_state";this.m.Name="$bv{es.heat.name}";
  this.m.Icon="skills/$bvvar{iconPrefix}/es_heat.png";this.m.IconMini="status_effect_34_mini";this.m.IsSerialized=false;
 },
 function state(){return ::$bvvar{namespace}.Es.state(this.getContainer()==null?null:this.getContainer().getActor());},
 function isHidden(){local s=this.state();return s==null||!s.Active;},
 function getTooltip()
 {
  local s=this.state();if(s==null)return [];local out=[{id=1,type="title",text=this.getName()+" "+s.Heat+" / 100"},{id=2,type="description",text="$bv{es.heat.description}"}];
  if(s.Bors)out.push({id=3,type="text",icon="skills/$bvvar{iconPrefix}/es_bors.png",text="$bv{es.state.bors}"});
  if(s.Guard)out.push({id=4,type="text",icon="skills/$bvvar{iconPrefix}/es_griflet.png",text=s.GuardEnhanced?"$bv{es.state.guard_enhanced}":"$bv{es.state.guard}"});
  if(s.PercivalUntil>s.Turn)out.push({id=5,type="text",icon="skills/$bvvar{iconPrefix}/es_percival.png",text=::format("$bv{es.state.percival}",s.PercivalUntil-s.Turn)});
  out.push({id=6,type="text",icon="skills/$bvvar{iconPrefix}/es_crest_arts.png",text=::format("$bv{es.state.crests}",s.Batches.len())});return out;
 }
});
