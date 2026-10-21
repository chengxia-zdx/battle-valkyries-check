this.tio_orbal_shot <- this.inherit("scripts/skills/skill",{
 function create(){
  this.m.ID="$bvvar{modId}.actives.tio_orbal_shot";this.m.Name="$bv{orbment.staff.attack}";this.m.Description="$bv{orbment.staff.attack_description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/tio_orbal_pulse.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/tio_orbal_pulse_sw.png";
  this.m.Type=this.Const.SkillType.Active;this.m.Order=this.Const.SkillOrder.OffensiveTargeted;this.m.IsActive=true;this.m.IsSerialized=false;
  this.m.IsAttack=true;this.m.IsRanged=true;this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsUsingHitchance=true;
  this.m.IsWeaponSkill=true;this.m.IsShowingProjectile=false;this.m.IsShieldRelevant=false;this.m.IsIgnoredAsAOO=true;
  this.m.ActionPointCost=4;this.m.FatigueCost=8;this.m.MinRange=1;this.m.MaxRange=3;this.m.DirectDamageMult=0.2;this.m.MaxLevelDifference=4;
 },
 function getTooltip(){return this.getDefaultTooltip();},
 function onUse(a,tile){
  if(tile==null || !tile.IsOccupiedByActor)return false;local b=tile.getEntity();
  if(a.isAlliedWith(b) || ::$bvvar{namespace}.isActorDeadOrDying(b))return false;
  ::$bvvar{namespace}.playValkyrieVisual(this,b,"tio_orbal_pulse");
  ::$bvvar{namespace}.playValkyrieSkillAudio(a,"tio_orbal_pulse");
  return this.attackEntity(a,b,false);
 }
});
