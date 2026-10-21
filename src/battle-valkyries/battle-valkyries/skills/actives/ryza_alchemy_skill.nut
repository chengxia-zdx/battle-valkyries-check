this.ryza_alchemy_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m = { BVRyzaSpell = true, Spec = null },
 function create()
 {
  this.valkyrie_active_skill.create();
  this.m.IsWeaponSkill = false; this.m.IsRanged = true; this.m.IsUsingHitchance = true;
  this.m.IsShowingProjectile = false; this.m.IsDoingAttackMove = false; this.m.IsShieldRelevant = false;
  this.m.IsIgnoredAsAOO = true; this.m.IsVisibleTileNeeded = true; this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 4;
 }
 function onValkyrieSkillBound(d)
 {
  this.m.Spec = d.Spec; local s = this.m.Spec;
  this.m.ActionPointCost = s.AP; this.m.FatigueCost = s.Fatigue; this.m.MinRange = s.Min; this.m.MaxRange = s.Max;
  this.m.DirectDamageMult = s.Pierce; this.m.IsAttack = s.DamageMin > 0;
  this.m.IsTargeted = true; this.m.IsTargetingActor = s.Radius == 0; this.m.IsAOE = s.Radius > 0;
 }
 function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
 function f() { return ::$bvvar{namespace}.Ryza; }
 function isValkyrieWeaponSkillPolicyOptOut() { return true; }
 function unavailable()
 {
  local a = this.actor(), f = this.f(), s = f.state(a), d = this.m.Spec;
  if (!f.owner(a) || s == null || !f.api().EightValkyries.able(a)) return "$bv{ryza.unavailable}";
  if (s.CC < d.CC) return "$bv{ryza.need_cc}";
  if (this.m.BVSkillKey in s.Cooldowns && s.Cooldowns[this.m.BVSkillKey] > s.Turn) return "$bv{ryza.cooldown}" + (s.Cooldowns[this.m.BVSkillKey] - s.Turn);
  if (d.Mode == "flame" && s.FlameRound == ::Time.getRound()) return "$bv{ryza.round_used}";
  return null;
 }
 function isUsable() { return this.unavailable() == null && this.skill.isUsable(); }
 function onVerifyTarget(origin, tile)
 {
  local a = this.actor(), d = this.m.Spec, f = this.f();
  if (!f.alive(a) || origin == null || tile == null || !tile.IsVisibleForEntity) return false;
  local range = origin.getDistanceTo(tile);
  if (range < d.Min || range > d.Max || ::Math.abs(origin.Level - tile.Level) > 4 || !origin.hasLineOfSightTo(tile, d.Max)) return false;
  if (d.Mode == "elixir") return tile.IsOccupiedByActor && f.healable(a, tile.getEntity());
  if (d.Radius > 0) return this.targets(tile).len() > 0;
  return tile.IsOccupiedByActor && f.api().EightValkyries.enemy(a, tile.getEntity(), d.Max);
 }
 function getAffectedTiles(tile) { return this.m.Spec.Radius == 0 ? [tile] : this.f().api().getValkyrieRadiusTiles(tile, this.m.Spec.Radius, true); }
 function targets(tile)
 {
  local out = [], a = this.actor();
  foreach (b in this.f().api().getValkyrieEnemyTargetsOnTiles(a, this.getAffectedTiles(tile)))
   if (this.f().api().EightValkyries.enemy(a, b, this.m.Spec.Max + this.m.Spec.Radius)) out.push(b);
  return out;
 }
 function onTargetSelected(tile)
 {
  this.skill.onTargetSelected(tile);
  if (this.m.Spec.Radius > 0) foreach (t in this.getAffectedTiles(tile)) this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
 }
 function finalizeSpellProperties(p)
 {
  local d = this.m.Spec;
  p.DamageRegularMin = d.DamageMin; p.DamageRegularMax = d.DamageMax; p.DamageRegularMult = 1.0; p.DamageArmorMult = d.Armor;
  p.DamageDirectMult = 1.0; p.DamageDirectAdd = 0.0; p.DamageDirectMeleeAdd = 0.0; p.DamageDirectRangedAdd = 0.0;
  p.DamageAdditionalWithEachTile = 0; p.HitChanceAdditionalWithEachTile = 0;
  p.HitChance[::Const.BodyPart.Head] = 0; p.HitChance[::Const.BodyPart.Body] = 100;
  p.HitChanceMult[::Const.BodyPart.Head] = 1.0; p.HitChanceMult[::Const.BodyPart.Body] = 1.0;
 }
 function onBeforeTargetHit(skill, target, hit)
 {
  if (skill == this && this.f().alive(target)) this.f().api().playValkyrieVisual(this, target, "ryza_" + this.m.Spec.Mode);
 }
 function getTooltip()
 {
  local out = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", text = this.getCostString() }];
  local s = this.f().state(this.actor());
  out.push({ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{ryza.cc}" + (s == null ? 3 : s.CC) + " / 6 | $bv{ryza.cost}" + this.m.Spec.CC });
  local reason = this.unavailable(); if (reason != null) out.push({ id = 5, type = "text", icon = "ui/icons/warning.png", text = reason });
  return out;
 }
 function onUse(a, tile)
 {
  local f = this.f(), bv = f.api(), s = f.state(a), d = this.m.Spec, c = bv.getCurrentValkyrieActionContext(a, this);
  if (this.unavailable() != null || !this.onVerifyTarget(a.getTile(), tile) || c == null || c.IsFree || c.IsImplicit || c.Source != "managed_active" || s.LastAction == c.ActionToken) return false;
  s.LastAction = c.ActionToken; s.CC -= d.CC; s.Cooldowns[this.m.BVSkillKey] <- s.Turn + d.Cooldown;
  if (d.Mode == "flame") s.FlameRound = ::Time.getRound();
  bv.playValkyrieSkillAudio(a, this.m.BVSkillKey); bv.playValkyrieVisual(this, a, "ryza_cast");
  if (d.Mode == "elixir") { f.heal(tile.getEntity()); bv.playValkyrieVisual(this, tile.getEntity(), "ryza_elixir"); return true; }
  foreach (b in this.targets(tile))
  {
   if (!f.alive(a)) break;
   if (!f.api().EightValkyries.enemy(a, b, d.Max + d.Radius)) continue;
   local hit = this.attackEntity(a, b, false);
   if (!hit) continue;
   if (d.Mode == "pulse" && s.PulseRound != ::Time.getRound()) { s.PulseRound = ::Time.getRound(); s.CC = ::Math.min(6, s.CC + 1); }
   if (d.Mode == "frost") f.frost(b);
  }
  if (f.alive(a)) { a.getSkills().update(); a.setDirty(true); }
  return true;
 }
});
