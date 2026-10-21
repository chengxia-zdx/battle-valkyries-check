// Internal attack segment, never an extra toolbar button or a serialized skill.
this.es_followup_skill <- this.inherit("scripts/skills/skill", {
 m={EsAttack=true,EsAuxiliary=true,EsCounter=false,EsSnapshot=null,Spec=null},
 function create()
 {
  this.m.ID="$bvvar{modId}.active.es_followup";this.m.Name="$bv{es.crest.name}";
  this.m.IsSerialized=false;this.m.IsHidden=true;this.m.IsActive=true;this.m.IsAttack=true;this.m.IsWeaponSkill=true;
  this.m.IsRanged=false;this.m.IsUsingHitchance=true;this.m.IsShieldRelevant=true;this.m.IsTargetingActor=true;
  this.m.IsDoingAttackMove=false;this.m.IsShowingProjectile=false;this.m.IsIgnoredAsAOO=true;this.m.DirectDamageMult=0.25;
  this.m.MinRange=0;this.m.MaxRange=999;this.m.MaxLevelDifference=999;
 },
 function isValkyrieWeaponSkillPolicyOptOut(){return true;}
});
