this.trails_duo_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();}
 function getTooltip(){return this.skill.getTooltip();}
 function onUpdate(p){
  if(this.m.BVSkillKey!="renne_genius_executor")return;
  local a=this.getContainer().getActor(),bv=::$bvvar{namespace};
  if(!bv.TrailsDuo.owns(a,"renne")||bv.Orbments.item(a)==null)return;
  foreach(s in a.getSkills().m.Skills)if(s!=null&&!s.isGarbage()&&s.isActive()&&"BVSkillKey" in s.m&&s.m.BVSkillKey.find("orbment_")==0)
   p.SkillCostAdjustments.push({ID=s.getID(),FatigueMultAdjust=0.85});
 }
});
