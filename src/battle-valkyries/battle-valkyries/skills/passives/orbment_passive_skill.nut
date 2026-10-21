this.orbment_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function create(){this.valkyrie_passive_skill.create();}
 function onValkyrieSkillBound(d){this.m.IsHidden=this.m.BVSkillKey=="orbment_socket_bonus";}
 function getTooltip(){return this.skill.getTooltip();}
 function onUpdate(p)
 {
  if(this.m.BVSkillKey!="orbment_socket_bonus")return;
  local a=this.getContainer().getActor(),b=::$bvvar{namespace}.Orbments.bonuses(a);
  if("Recovery" in b)p.FatigueRecoveryRate+=b.Recovery;
  if("FatigueMult" in b)foreach(skill in a.getSkills().m.Skills)
   if(skill!=null && !skill.isGarbage() && skill.isActive())p.SkillCostAdjustments.push({ID=skill.getID(),FatigueMultAdjust=b.FatigueMult});
  foreach(k in ["Hitpoints","Bravery","Stamina","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"])if(k in b)p[k]+=b[k];
 }
 function onBeforeDamageReceived(a,skill,hit,p)
 {
  if(this.m.BVSkillKey!="orbment_socket_bonus" || !::$bvvar{namespace}.isDirectAttack(skill))return;
  local b=::$bvvar{namespace}.Orbments.bonuses(this.getContainer().getActor());if("Reduction" in b)p.DamageReceivedRegularMult*=b.Reduction;
 }
 function onTargetKilled(target,skill){
  if(this.m.BVSkillKey!="orbment_socket_bonus")return;
  local a=this.getContainer().getActor(),f=::$bvvar{namespace}.OrbalCombat,b=::$bvvar{namespace}.Orbments.bonuses(a);
  if(target!=null && !a.isAlliedWith(target) && "KillRecovery" in b && f.read(a,"kill_round",-1)!=f.round())
  {f.write(a,"kill_round",f.round());f.recover(a,b.KillRecovery);}
 }
});
