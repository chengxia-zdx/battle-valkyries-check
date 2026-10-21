this.ryza_pet_attack <- this.inherit("scripts/skills/skill", {
 m = { Species = "", Stats = null, Segment = 1.0, Counter = false },
 function create()
 {
  this.m.ID = "$bvvar{modId}.actives.ryza_pet_attack"; this.m.Name = "$bv{ryza.pet.attack}"; this.m.Description = "$bv{ryza.pet.attack.description}";
  this.m.Icon = "skills/$bvvar{iconPrefix}/ryza_pulse.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/ryza_pulse_sw.png";
  this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted; this.m.IsSerialized = false;
  this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = true; this.m.IsStacking = false;
  this.m.IsUsingHitchance = true; this.m.IsWeaponSkill = false; this.m.IsDoingAttackMove = false; this.m.IsShowingProjectile = false;
  this.m.ActionPointCost = 5; this.m.FatigueCost = 10; this.m.MinRange = 1; this.m.MaxRange = 1; this.m.DirectDamageMult = 0.15;
 }
 function configure(species, stats)
 {
  this.m.Species = species; this.m.Stats = stats; this.m.MaxRange = stats.Range; this.m.IsRanged = stats.Range > 1;
  this.m.ActionPointCost = species == "cerberus" || species == "blood_wolf" ? 6 : 5;
  this.m.SoundOnUse = ["sounds/skills/ryza/ryza_" + (stats.Range > 1 ? "pet_wing" : "pet_strike") + "_01.wav"];
 }
 function onVerifyTarget(origin, tile)
 {
  local a = this.getContainer().getActor();
  return tile != null && tile.IsOccupiedByActor && ::$bvvar{namespace}.EightValkyries.enemy(a, tile.getEntity(), this.m.MaxRange) && origin.getDistanceTo(tile) >= 1;
 }
 function onAnySkillUsed(skill, target, p)
 {
  if (skill != this || this.m.Stats == null) return;
  local s = this.m.Stats, mult = this.m.Segment;
  if (this.m.Species == "blood_wolf" && target != null && target.getHitpoints() < target.getHitpointsMax() * 0.5) mult *= 1.25;
  p.DamageRegularMin = ::Math.floor(s.Min * mult); p.DamageRegularMax = ::Math.floor(s.Max * mult); p.DamageRegularMult = 1.0; p.DamageArmorMult = s.Armor / 100.0;
  if (this.m.IsRanged && target != null && this.getContainer().getActor().getTile().getDistanceTo(target.getTile()) == 1) p.RangedSkill -= 20;
 }
 function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", text = this.getCostString() }]; }
 function onBeforeTargetHit(skill, target, hit)
 {
  if (skill == this && ::$bvvar{namespace}.EightValkyries.alive(target)) ::$bvvar{namespace}.playValkyrieVisual(this, target, this.m.IsRanged ? "ryza_pulse" : "ryza_pet_hit");
 }
 function hit(a, b)
 {
  local bv = ::$bvvar{namespace};
  if (!bv.EightValkyries.enemy(a, b, this.m.MaxRange)) return false;
  local hit = this.attackEntity(a, b, false);
  if (!hit || !bv.EightValkyries.alive(b)) return hit;
  if (!this.m.Counter && (this.m.Species == "frost_wolf" || this.m.Species == "mane_tusk") && a.m.ProcRound != ::Time.getRound()) { a.m.ProcRound = ::Time.getRound(); bv.Ryza.frost(b); }
  if (this.m.Species == "nightwing" && bv.EightValkyries.debuffable(b))
  {
   local e = b.getSkills().getSkillByID("$bvvar{modId}.effects.ryza_pet_mark");
   if (e == null) { e = this.new("$bvvar{privateFolder}/skills/effects/ryza_pet_mark"); b.getSkills().add(e); }
   e.m.UntilStart = bv.FiveValkyries.clock(b).Starts + 1; b.getSkills().update();
  }
  return hit;
 }
 function onUse(a, tile)
 {
  if (!this.onVerifyTarget(a.getTile(), tile)) return false;
  local count = this.m.Species == "cerberus" || this.m.Species == "blood_wolf" ? 3 : 1, b = tile.getEntity();
  this.m.Segment = count == 1 ? 1.0 : (this.m.Species == "cerberus" ? 0.4 : 0.35);
  try { for (local n = 0; n < count; n++) { if (!::$bvvar{namespace}.EightValkyries.enemy(a, b, this.m.MaxRange)) break; this.hit(a, b); } }
  catch (e) { this.m.Segment = 1.0; throw e; }
  this.m.Segment = 1.0; return true;
 }
 function counter(a, b)
 {
  if (this.m.Counter) return;
  this.m.Counter = true; this.m.Segment = 0.5;
  try { this.hit(a, b); } catch (e) { this.m.Counter = false; this.m.Segment = 1.0; throw e; }
  this.m.Counter = false; this.m.Segment = 1.0;
 }
});
