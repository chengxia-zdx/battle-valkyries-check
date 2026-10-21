this.ryza_pet_aid_lock <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m = { Round = -1 },
 function create() { this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.ryza_pet_aid_lock"; this.m.IsHidden = true; }
 function onCombatFinished() { this.removeSelf(); }
});
