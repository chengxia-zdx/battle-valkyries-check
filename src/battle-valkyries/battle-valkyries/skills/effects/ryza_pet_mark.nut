this.ryza_pet_mark <- this.inherit("$bvvar{privateFolder}/skills/effects/ryza_frost_effect", {
 function create()
 {
  this.ryza_frost_effect.create(); this.m.ID = "$bvvar{modId}.effects.ryza_pet_mark"; this.m.Name = "$bv{ryza.pet.mark}";
  this.m.Description = "$bv{ryza.pet.mark.description}"; this.m.Icon = "skills/$bvvar{iconPrefix}/ryza_pulse.png";
 }
 function onUpdate(p) { p.MeleeDefense -= 10; p.RangedDefense -= 10; }
});
