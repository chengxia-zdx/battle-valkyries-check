this.ryza_core_crystal <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
 function onCombatStarted() { ::$bvvar{namespace}.Ryza.start(this.actor()); }
 function onTurnStart() { ::$bvvar{namespace}.Ryza.turn(this.actor()); }
 function onCombatFinished() { local a = this.actor(); if (a != null) a.m.BVRyza <- null; }
 function onDeath(fatality) { local actor = this.actor(); if (actor != null) actor.m.BVRyza <- null; }
 function getTooltip()
 {
  local out = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }], s = ::$bvvar{namespace}.Ryza.state(this.actor());
  if (s != null) out.push({ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{ryza.cc}" + s.CC + " / 6" });
  return out;
 }
});
