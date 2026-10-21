this.hu_tao_state_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Key=""},
 function create(){this.valkyrie_effect_skill.create();this.m.IsSerialized=false;this.m.IsRemovedAfterBattle=true;this.m.IconMini="status_effect_34_mini";},
 function configure(key)
 {
  this.m.Key=key;this.m.ID="$bvvar{modId}.effect.hu_tao_"+key;
  local text={paramita_papilio=["$bv{hu_tao.paramita_papilio.name}","$bv{hu_tao.paramita_papilio.description}"],butterfly_guard=["$bv{hu_tao.butterfly_guard.name}","$bv{hu_tao.butterfly_guard.description}"],lingering_fragrance=["$bv{hu_tao.lingering_fragrance.name}","$bv{hu_tao.lingering_fragrance.description}"]};
  this.m.Name=text[key][0];this.m.Description=text[key][1];this.m.Icon="skills/$bvvar{iconPrefix}/hu_tao_"+key+".png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_"+key+"_sw.png";
 },
 function isHidden()
 {
  local a=this.getContainer()==null?null:this.getContainer().getActor(),f=::$bvvar{namespace}.HuTao,s=f.state(a);
  if(s==null||!s.Active)return true;
  return this.m.Key=="paramita_papilio"?!f.dance(a):this.m.Key=="butterfly_guard"?!s.Guard:!f.reborn(a);
 },
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];}
});
