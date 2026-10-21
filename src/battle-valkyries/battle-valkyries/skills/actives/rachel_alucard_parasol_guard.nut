this.rachel_alucard_parasol_guard <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function create()
 {
  this.valkyrie_active_skill.create();
  this.m.ActionPointCost=2;this.m.FatigueCost=6;this.m.MinRange=0;this.m.MaxRange=0;
  this.m.IsTargeted=false;this.m.IsAttack=false;this.m.IsWeaponSkill=false;
  this.m.IsUsingHitchance=false;this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;
  this.m.Order=::$bvvar{namespace}.getValkyrieActiveSkillOrder()+12;
 },
 function isUsable(){return ::$bvvar{namespace}.RachelEquipment.ready(this.actor())&&this.skill.isUsable();},
 function onVerifyTarget(origin,tile){return origin!=null&&(tile==null||origin.ID==tile.ID);},
 function onUse(a,tile)
 {
  local bv=::$bvvar{namespace},c=bv.getCurrentValkyrieActionContext(a,this);
  if(c==null||c.IsFree||c.IsImplicit||c.Source!="managed_active")return false;
  return bv.RachelEquipment.protect(a);
 },
 function getTooltip()
 {
  local s=::$bvvar{namespace}.Rachel.state(this.actor());
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
   {id=3,type="text",icon="ui/icons/action_points.png",text="$bv{rachel.equipment.guard.cost}"}];
  if(s!=null&&s.ParasolGuard)out.push({id=4,type="text",icon="ui/icons/special.png",text="$bv{rachel.equipment.guard.active}"});
  else if(s!=null&&s.Turn<s.ParasolReady)out.push({id=5,type="text",icon="ui/icons/turns.png",text=::format("$bv{rachel.equipment.guard.cooldown}",s.ParasolReady-s.Turn)});
  return out;
 }
});
