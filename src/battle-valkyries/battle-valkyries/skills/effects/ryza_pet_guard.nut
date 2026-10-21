this.ryza_pet_guard <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m = { Source = null, UntilStart = 0 },
 function create()
 {
  this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.ryza_pet_guard"; this.m.Name = "$bv{ryza.pet.guard}"; this.m.Description = "$bv{ryza.pet.guard.description}";
  this.m.Icon = "skills/$bvvar{iconPrefix}/ryza_core_crystal.png"; this.m.IconMini = "status_effect_34_mini"; this.m.IsStacking = false;
 }
 function valid()
 {
  local bv = ::$bvvar{namespace}, a = bv.readValkyrieCombatWeakRef(this.m.Source);
  return bv.EightValkyries.alive(a) && bv.FiveValkyries.clock(a).Starts < this.m.UntilStart;
 }
 function onUpdate(p) { if (!this.valid()) { this.removeSelf(); return; }
 p.MeleeDefense += 10; p.RangedDefense += 10; p.Bravery += 10; }
 function onCombatFinished() { this.removeSelf(); }
});
