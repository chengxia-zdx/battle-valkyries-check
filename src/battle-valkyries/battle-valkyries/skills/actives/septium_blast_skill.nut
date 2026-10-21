this.septium_blast_skill <- this.inherit("scripts/skills/skill",{
 function create(){
  this.m.ID="$bvvar{modId}.enemy_skill.septium_blast";this.m.Name="$bv{orbment.enemy.charging}";
  this.m.Type=this.Const.SkillType.Active;this.m.IsSerialized=false;this.m.IsHidden=true;this.m.IsActive=true;
  this.m.IsAttack=true;this.m.IsRanged=true;this.m.IsWeaponSkill=false;this.m.IsUsingHitchance=true;this.m.IsShieldRelevant=false;this.m.IsShowingProjectile=false;this.m.DirectDamageMult=0.2;
 },
 function onAnySkillUsed(skill,target,p){if(skill!=this)return;p.DamageRegularMin=40;p.DamageRegularMax=60;p.DamageArmorMult=1.0;p.RangedSkill=80;},
 function blast(tile){
  local a=this.getContainer().getActor();
  foreach(t in ::$bvvar{namespace}.getValkyrieRadiusTiles(tile,1,true)){
   if(::$bvvar{namespace}.isActorDeadOrDying(a))break;
   if(!t.IsOccupiedByActor)continue;local b=t.getEntity();
   if(a.isAlliedWith(b) || ::$bvvar{namespace}.isActorDeadOrDying(b))continue;
   ::$bvvar{namespace}.playValkyrieVisual(this,b,"orbment_flame_gale");this.attackEntity(a,b,false);
  }
 }
});
