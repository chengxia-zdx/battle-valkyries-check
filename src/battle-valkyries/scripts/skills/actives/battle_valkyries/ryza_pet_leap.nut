this.ryza_pet_leap <- this.inherit("scripts/skills/skill", {
 function create()
 {
  this.m.ID = "$bvvar{modId}.actives.ryza_pet_leap"; this.m.Name = "$bv{ryza.pet.leap}"; this.m.Description = "$bv{ryza.pet.leap.description}";
  this.m.Icon = "skills/$bvvar{iconPrefix}/ryza_pulse.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/ryza_pulse_sw.png";
  this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.NonTargeted; this.m.IsSerialized = false;
  this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = false; this.m.IsTargetingActor = false;
  this.m.ActionPointCost = 4; this.m.FatigueCost = 15; this.m.MinRange = 2; this.m.MaxRange = 3;
  this.m.SoundOnUse = ["sounds/skills/ryza/ryza_pet_wing_01.wav"];
 }
 function isUsable()
 {
  local a = this.getContainer().getActor();
  return this.skill.isUsable() && !a.getCurrentProperties().IsRooted && a.m.LeapRound + 2 <= ::Time.getRound();
 }
 function onVerifyTarget(origin, tile)
 {
  if (origin == null || tile == null || !tile.IsEmpty || !tile.IsVisibleForEntity || ::Math.abs(origin.Level - tile.Level) > 1) return false;
  local dist = origin.getDistanceTo(tile); return dist >= 2 && dist <= 3 && origin.hasLineOfSightTo(tile, 3);
 }
 function onUse(a, tile)
 {
  if (a.getCurrentProperties().IsRooted || a.m.LeapRound + 2 > ::Time.getRound() || !this.onVerifyTarget(a.getTile(), tile)) return false;
  a.m.LeapRound = ::Time.getRound(); a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
  this.Tactical.getNavigator().teleport(a, tile, null, null, false);
  return true;
 }
});
