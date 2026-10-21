// Presentation only. The equipment controller owns protection and its expiration.
this.rachel_alucard_parasol_guard_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create()
 {
  this.valkyrie_passive_skill.create();
  this.m.IconMini="status_effect_03_mini";
  this.m.IsRemovedAfterBattle=true;
 },
 function isHidden()
 {
  local a=this.getContainer()==null?null:this.getContainer().getActor();
  local s=::$bvvar{namespace}.Rachel.state(a);
  return s==null||!s.Active||!s.ParasolGuard;
 },
 function getTooltip()
 {
  return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
 }
});
