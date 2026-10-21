this.kanade_tachibana_stunned_effect <- this.inherit("scripts/skills/effects/stunned_effect", {
 function create(){this.stunned_effect.create();this.m.IsSerialized=false;},
 function isBattleValkyriesManagedCombatEffect(){return true;},
 function onOtherActorTooltip(tooltip,target){},
 function getValkyrieAttackNullificationPolicy(skill,attacker){return null;},
 function getValkyrieAttackDefensePolicy(skill){return null;},
 function getValkyrieWeaponSkillPolicy(skill){return null;},
 function removeSelf(){this.m.IsGarbage=true;},
 function onTurnEnd(){if(::$bvvar{namespace}.EightValkyries.normal(this.getContainer().getActor()))this.stunned_effect.onTurnEnd();},
 function onCombatFinished(){this.removeSelf();}
});
