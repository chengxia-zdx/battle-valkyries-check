this.tio_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();}
 function getTooltip(){return this.skill.getTooltip();}
 function onUpdate(p)
 {
  local a=this.getContainer().getActor();if(::$bvvar{namespace}.getActorValkyrieID(a)!="tio")return;
  if(this.m.BVSkillKey=="tio_aion_sense"){p.RangedSkill+=10;p.RangedDefense+=10;return;}
  local e=::$bvvar{namespace}.Orbments.total(a);p.MeleeDefense+=e.earth;p.RangedDefense+=e.space;
  p.Initiative+=e.wind*2;p.Stamina+=e.time*2;p.Bravery+=e.mirage*2;
 }
});

