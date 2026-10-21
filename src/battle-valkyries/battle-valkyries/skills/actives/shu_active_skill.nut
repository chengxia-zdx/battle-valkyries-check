this.shu_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m = { Spec = null },
 function create()
 {
  this.valkyrie_active_skill.create();
  this.m.IsAttack = false; this.m.IsWeaponSkill = false; this.m.IsUsingHitchance = false;
  this.m.IsDoingAttackMove = false; this.m.IsIgnoredAsAOO = true; this.m.IsShieldRelevant = false;
  this.m.IsVisibleTileNeeded = true; this.m.MaxLevelDifference = 4; this.m.MaxRangeBonus = 0;
 },
 function onValkyrieSkillBound(d)
 {
  this.m.Spec = clone d.Spec; this.m.ActionPointCost = d.Spec.AP; this.m.FatigueCost = d.Spec.Fatigue;
  this.m.MinRange = 0; this.m.MaxRange = this.m.BVSkillKey == "shu_nurture" ? d.Spec.Range : 0;
  this.m.IsTargeted = this.m.BVSkillKey == "shu_nurture"; this.m.IsTargetingActor = true;
 },
 function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); },
 function isUsable() { return ::$bvvar{namespace}.Shu.ready(this.actor(), this.m.BVSkillKey) && this.skill.isUsable(); },
 function onVerifyTarget(origin, tile)
 {
  local a = this.actor(), f = ::$bvvar{namespace}.Shu;
  if (!f.placed(a) || tile == null || !tile.IsOccupiedByActor) return false;
  if (this.m.BVSkillKey == "shu_granary") return tile.ID == origin.ID;
  local b = tile.getEntity();
  return f.ally(a, b)
   && origin.getDistanceTo(tile) <= this.m.Spec.Range && tile.IsVisibleForEntity
   && ::Math.abs(origin.Level - tile.Level) <= 4 && origin.hasLineOfSightTo(tile, this.m.Spec.Range);
 },
 function getAffectedTiles(tile)
 {
  return this.m.BVSkillKey == "shu_granary" ? ::$bvvar{namespace}.getValkyrieRadiusTiles(this.actor().getTile(), 1, true) : [tile];
 },
 function getTooltip()
 {
  local f = ::$bvvar{namespace}.Shu, s = f.state(this.actor()), remaining = 0;
  if (s != null && this.m.BVSkillKey in s.Cooldowns) remaining = ::Math.max(0, s.Cooldowns[this.m.BVSkillKey] - f.round());
  local out = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
   { id = 3, type = "text", text = this.getCostString() }, { id = 4, type = "text", icon = "ui/icons/time.png", text = "$bv{shu.cooldown}" + remaining },
   { id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{shu.heal_formula}" + this.m.Spec.Heal + " + " + ::Math.round(this.m.Spec.HealPercent * 100) + "%" }];
  if (remaining > 0) out.push({ id = 6, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{shu.cooldown.unavailable}" });
  return out;
 },
 function onUse(user, tile)
 {
  if (!this.onVerifyTarget(user.getTile(), tile)) return false;
  return ::$bvvar{namespace}.Shu.cast(user, this.m.BVSkillKey, tile.getEntity(), this.m.Spec);
 }
});
