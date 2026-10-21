this.grail_wish_claim_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 function create() { this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.grail_wish_claim";this.m.Name="$bv{chapter.grail.enemy.claim}";this.m.Description="$bv{chapter.grail.enemy.claim.desc}";this.m.Icon="skills/$bvvar{iconPrefix}/wish_claim.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/wish_claim_sw.png"; },
 function onUpdate(p) { p.MeleeSkill+=15; },
 function onBeforeDamageReceived(attacker,skill,hit,p) { if(skill!=null && skill.isAttack())p.DamageReceivedTotalMult*=0.8; }
});
