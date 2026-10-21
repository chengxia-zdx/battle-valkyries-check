this.saber_mana_release_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 function create()
 {
  this.valkyrie_active_skill.create();
  this.m.IsTargeted=false; this.m.IsTargetingActor=false;
  this.m.IsAttack=false; this.m.IsWeaponSkill=false;
  this.m.ActionPointCost=0; this.m.FatigueCost=0;
 }
 function getOwner() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
 function getUses()
 {
  local actor=this.getOwner(); if (actor==null) return 2;
  local uses=actor.getFlags().get("BVSaberManaReleaseUses");
  return typeof uses=="integer" ? uses : 0;
 }
 function eligible()
 {
  local actor=this.getOwner();
  return actor!=null && !::$bvvar{namespace}.isActorDeadOrDying(actor) && actor.isPlacedOnMap()
   && ::$bvvar{namespace}.hasSaberBondUpgrade(actor,100)
   && actor.getFlags().get("BVSaberBondInCombat")==true && this.getUses()<2;
 }
 function isUsable() { return this.skill.isUsable() && this.eligible(); }
 function getTooltip()
 {
  local ret=this.getDefaultTooltip();
  ret.push({id=20,type="text",icon="ui/icons/fatigue.png",text="$bv{skill.saber_mana_release.rules}"});
  ret.push({id=21,type="text",icon="ui/icons/special.png",text="$bv{skill.saber_mana_release.remaining}"+(2-this.getUses())+" / 2"});
  if (!this.eligible()) ret.push({id=22,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.saber_mana_release.unavailable}"});
  return ret;
 }
 function onUse(user,tile)
 {
  // Revalidate entitlement and battle ledger, never AP/fatigue already paid by skill.use.
  if (user!=this.getOwner() || !this.eligible()) return false;
  local passive=this.getContainer().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("saber_invisible_air"));
  if (passive==null || passive.ensureManaEffect()==null) return false;
  user.getFlags().set("BVSaberManaReleaseUses",this.getUses()+1);
  passive.addMana(4);
  ::$bvvar{namespace}.playValkyrieVisual(this,user,"saber_mana_release_ring");
  ::$bvvar{namespace}.playValkyrieVisual(this,user,"saber_mana_release_burst");
  // Full mana is allowed: an intentional use still spends one charge. Never reset Excalibur Uses.
  return true;
 }
});
