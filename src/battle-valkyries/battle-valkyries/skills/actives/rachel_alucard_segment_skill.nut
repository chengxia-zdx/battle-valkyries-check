// Internal native attack segment. Never saved or exposed as a toolbar action.
this.rachel_alucard_segment_skill <- this.inherit("scripts/skills/skill", {
 m={RachelDamage=0,RachelKind="melee",BVSkillKey=null},
 function create(){this.m.ID="$bvvar{modId}.active.rachel_segment";this.m.Name="$bv{rachel.name}";this.m.IsSerialized=false;this.m.IsHidden=true;this.m.IsActive=true;this.m.IsAttack=true;this.m.IsWeaponSkill=false;this.m.IsUsingHitchance=true;this.m.IsTargetingActor=true;this.m.IsDoingAttackMove=false;this.m.IsShowingProjectile=false;this.m.IsIgnoredAsAOO=true;this.m.MinRange=0;this.m.MaxRange=999;this.m.MaxLevelDifference=999;},
 function isValkyrieWeaponSkillPolicyOptOut(){return true;}
});
