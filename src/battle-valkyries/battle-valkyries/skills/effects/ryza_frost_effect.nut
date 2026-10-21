this.ryza_frost_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m = { UntilStart = 0 },
 function create()
 {
  this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.ryza_frost";
  this.m.Name = "$bv{ryza.frost.name}"; this.m.Description = "$bv{ryza.frost.description}";
  this.m.Icon = "skills/$bvvar{iconPrefix}/ryza_frost.png"; this.m.IconMini = "status_effect_34_mini";
  this.m.IsStacking = false;
 }
 function onUpdate(p) { p.Initiative -= 30; p.MovementAPCostAdditional += 1; }
 function onTurnEnd()
 {
  local a = this.getContainer().getActor(), f = ::$bvvar{namespace}.FiveValkyries;
  if (f.normal(a) && !f.clock(a).Extra && f.clock(a).Starts >= this.m.UntilStart) this.removeSelf();
 }
 function onCombatFinished() { this.removeSelf(); }
});
