// Runtime field state is rebuilt per battle. Only harvest timestamps and pending
// provisions persist, in actor/world flags; no skill or terrain sprite is saved.
::$bvvar{namespace}.Shu <- {
 Owners = [], Decals = {}, Signature = null,
 function api() { return ::$bvvar{namespace}; },
 function round() { return ::Time.getRound(); },
 function alive(a) { return a != null && !this.api().isActorDeadOrDying(a); },
 function placed(a) { return this.alive(a) && a.isPlacedOnMap(); },
 function owner(a) { return this.alive(a) && a.isPlayerControlled() && this.api().getActorValkyrieID(a) == "shu"; },
 function ally(a, b) { return this.placed(a) && this.placed(b) && (a == b || this.api().isEligibleRosterAlly(a, b)); },
 function ref(a) { return this.api().makeValkyrieCombatWeakRef(a); },
 function read(a) { return this.api().readValkyrieCombatWeakRef(a); },
 function state(a) { return a != null && "BVShuState" in a.m ? a.m.BVShuState : null; },
 function allies()
 {
  local out = [];
  if (::World.getPlayerRoster() == null) return out;
  foreach (a in ::World.getPlayerRoster().getAll()) if (this.placed(a) && a.isPlayerControlled()) out.push(a);
  return out;
 },
 function start(a)
 {
  if (!this.owner(a)) return;
  local s = this.state(a);
  if (s != null && s.Active) return;
  if (this.liveOwners().len() == 0)
   foreach (b in this.allies()) b.m.BVShuRegenRound <- -999;
  a.m.BVShuState <- { Active = true, FirstHitRound = -999, AidRound = -999, GuardUntil = -999, Seeds = {}, Cooldowns = {} };
  this.Owners.push(this.ref(a));
  this.Signature = null;
  this.refresh();
 },
 function liveOwners()
 {
  local out = [];
  foreach (r in this.Owners)
  {
   local a = this.read(r), s = this.state(a);
   if (this.owner(a) && this.placed(a) && s != null && s.Active) out.push(a);
  }
  return out;
 },
 function onSeed(a, tile)
 {
  local s = this.state(a);
  if (s == null || !s.Active || tile == null) return false;
  if (a.getTile().getDistanceTo(tile) <= 1) return true;
  return tile.ID in s.Seeds && this.round() < s.Seeds[tile.ID].Until;
 },
 function protection(a)
 {
  local value = 0.0;
  if (!this.placed(a)) return value;
  foreach (o in this.liveOwners())
  {
   if (!this.ally(o, a)) continue;
   local s = this.state(o), near = o.getTile().getDistanceTo(a.getTile()) <= 1;
   if (this.onSeed(o, a.getTile())) value = ::Math.maxf(value, 0.15);
   if (near && this.round() < s.GuardUntil) value = ::Math.maxf(value, 0.25);
  }
  return value;
 },
 function seededTiles()
 {
  local result = {};
  foreach (o in this.liveOwners())
  {
   foreach (t in this.api().getValkyrieRadiusTiles(o.getTile(), 1, true)) result[t.ID] <- t;
   local s = this.state(o), expired = [];
   foreach (id, seed in s.Seeds)
   {
    if (this.round() >= seed.Until) expired.push(id);
    else result[id] <- seed.Tile;
   }
   foreach (id in expired) delete s.Seeds[id];
  }
  return result;
 },
 function hideDecal(d) { if (d != null) { d.Visible = false; d.Alpha = 0; } },
 function refresh()
 {
  local wanted = this.seededTiles();
  foreach (id, rec in this.Decals) if (!(id in wanted)) this.hideDecal(rec.Sprite);
  foreach (id, tile in wanted)
  {
   if (!(id in this.Decals))
   {
    // Own the returned sprite, never clear shared DetailFlag groups or change
    // Tile.Type/Properties.Effect. Fire, corpses and pathfinding stay native.
    try
    {
     local sprite = tile.spawnDetail("effect_bv_shu_rice_tile", 0, false, false);
     this.Decals[id] <- { Sprite = sprite };
    }
    catch (e) { ::logWarning("[Battle Valkyries] Shu field draw failed: " + e); }
   }
   if (id in this.Decals && this.Decals[id].Sprite != null)
   {
    this.Decals[id].Sprite.Visible = true;
    this.Decals[id].Sprite.Alpha = 185;
   }
  }
  foreach (a in this.allies())
  {
   local e = a.getSkills().getSkillByID("$bvvar{modId}.effects.shu_field");
   if (wanted.len() > 0 && e == null)
   {
    e = ::new("$bvvar{privateFolder}/skills/effects/shu_field_effect");
    a.getSkills().add(e);
   }
   if (wanted.len() == 0 && e != null) e.removeSelf();
   a.getSkills().update();
   a.setDirty(true);
  }
 },
 function updateField()
 {
  if (this.Owners.len() == 0) return;
  local signature = "" + this.round();
  foreach (o in this.liveOwners()) signature += ":" + o.getID() + "@" + o.getTile().ID;
  if (signature == this.Signature) return;
  this.Signature = signature;
  this.refresh();
 },
 function move() { if (this.Owners.len() > 0) { this.Signature = null; this.updateField(); } },
 function stop(a)
 {
  local s = this.state(a);
  if (s != null) { s.Active = false; s.Seeds = {}; }
  this.move();
 },
 function reset()
 {
  // Loading or initializing a map must not touch sprites from an old map.
  this.Owners = []; this.Decals = {}; this.Signature = null;
  if (::World.getPlayerRoster() == null) return;
  foreach (a in ::World.getPlayerRoster().getAll())
  {
   a.m.BVShuState <- null; a.m.BVShuRegenRound <- -999;
  }
 },
 function clear()
 {
  foreach (r in this.Owners) { local a = this.read(r), s = this.state(a); if (s != null) s.Active = false; }
  foreach (id, rec in this.Decals) this.hideDecal(rec.Sprite);
  this.Owners = []; this.Decals = {}; this.Signature = null;
  foreach (a in this.allies())
  {
   a.m.BVShuRegenRound <- -999;
   a.getSkills().removeByID("$bvvar{modId}.effects.shu_field");
   a.getSkills().update();
  }
 },
 function visual(a, theme) { this.api().playValkyrieVisual(this, a, theme); },
 function sound(a, cue) { this.api().playValkyrieSkillAudio(a, cue); },
 function heal(a, amount, visible = true)
 {
  if (!this.placed(a)) return false;
  local old = a.getHitpoints();
  a.setHitpoints(::Math.min(a.getHitpointsMax(), old + ::Math.floor(amount)));
  if (a.getHitpoints() <= old) return false;
  a.setDirty(true);
  if (visible) this.visual(a, "shu_heal");
  return true;
 },
 function tick(a)
 {
  if (!this.placed(a) || this.Owners.len() == 0 || !this.api().EightValkyries.normal(a)) return;
  local round = this.round();
  // Waiting, resumed turns and bonus actions must not repeat either heal.
  if ("BVShuRegenRound" in a.m && a.m.BVShuRegenRound == round) return;
  a.m.BVShuRegenRound <- round;
  if (this.protection(a) > 0) this.heal(a, 6 + a.getHitpointsMax() * 0.04);
  if (!this.owner(a)) return;
  local s = this.state(a);
  if (s == null || !s.Active || s.AidRound == round) return;
  s.AidRound = round;
  local target = null, ratio = 2.0;
  foreach (b in this.allies())
  {
   if (!this.ally(a, b) || !this.onSeed(a, b.getTile())) continue;
   local r = b.getHitpoints().tofloat() / ::Math.max(1, b.getHitpointsMax());
   if (r <= 0.5 && r < ratio) { target = b; ratio = r; }
  }
  if (target != null && this.heal(target, 18 + target.getHitpointsMax() * 0.08)) this.sound(a, "shu_nurture");
 },
 function ready(a, key)
 {
  local s = this.state(a);
  return this.owner(a) && this.placed(a) && s != null && s.Active && (!(key in s.Cooldowns) || this.round() >= s.Cooldowns[key]);
 },
 function cast(a, key, target, spec)
 {
  if (!this.ready(a, key)) return false;
  local s = this.state(a);
  if (key == "shu_nurture")
  {
   if (!this.ally(a, target)) return false;
   this.heal(target, spec.Heal + target.getHitpointsMax() * spec.HealPercent);
   local tile = target.getTile();
   s.Seeds[tile.ID] <- { Tile = tile, Until = this.round() + spec.SeedRounds };
   this.sound(a, "shu_nurture");
  }
  else
  {
   s.GuardUntil = this.round() + spec.Duration;
   foreach (b in this.allies())
    if (this.ally(a, b) && a.getTile().getDistanceTo(b.getTile()) <= 1)
     this.heal(b, spec.Heal + b.getHitpointsMax() * spec.HealPercent);
   this.visual(a, "shu_guard");
   this.sound(a, "shu_granary");
  }
  s.Cooldowns[key] <- this.round() + spec.Cooldown;
  this.refresh();
  return true;
 },
 function dailyYield()
 {
  local roster = ::World.getPlayerRoster().getAll(), count = 0;
  foreach (a in roster) if (this.alive(a)) ++count;
  local terrain = ::Const.World.TerrainFoodConsumption[::World.State.getPlayer().getTile().Type];
  local demand = ::World.Assets.getDailyFoodCost() * terrain * ::World.Assets.m.FoodConsumptionMult * ::Const.World.Assets.FoodConsumptionMult;
  return ::Math.max(150, ::Math.ceil(demand * 50.0 / ::Math.max(1, count)).tointeger());
 },
 function flushHarvest()
 {
  local flags = ::World.Flags, key = "$bvvar{modId}.ShuPendingRice";
  local pending = flags.getAsInt(key);
  if (pending <= 0) return;
  local stash = ::World.Assets.getStash();
  if (stash.getNumberOfEmptySlots() <= 0) return;
  local item = ::new("scripts/items/supplies/battle_valkyries/shu_rice_item");
  item.setAmount(pending);
  item.m.BestBefore = ::Time.getVirtualTimeF() + 10 * ::World.getTime().SecondsPerDay;
  if (stash.add(item) == null) return;
  flags.set(key, 0);
  ::World.Assets.updateFood();
 },
 function updateWorld()
 {
  if (::World.State == null || ::World.State.getPlayer() == null || ::World.getPlayerRoster() == null) return;
  local now = ::Time.getVirtualTimeF(), day = ::World.getTime().SecondsPerDay;
  if (day <= 0) return;
  foreach (a in ::World.getPlayerRoster().getAll())
  {
   if (!this.owner(a)) continue; // Includes front line and all reserve positions.
   local f = a.getFlags(), stampKey = "$bvvar{modId}.ShuHarvestStamp", initKey = "$bvvar{modId}.ShuHarvestJoined";
   local joined = f.get(initKey) == true, stamp = joined ? f.get(stampKey) : now;
   if (stamp == null || stamp > now) { stamp = now; f.set(stampKey, now); }
   local days = ::Math.max(0, ::Math.floor((now - stamp) / day).tointeger());
   local amount = !joined ? 150 : days * this.dailyYield();
   if (amount > 0)
   {
    local pendingKey = "$bvvar{modId}.ShuPendingRice";
    ::World.Flags.set(pendingKey, ::World.Flags.getAsInt(pendingKey) + amount);
    f.set(initKey, true);
    f.set(stampKey, !joined ? now : stamp + days * day);
   }
  }
  // Mature grain waits safely in the saved ledger when the stash is full.
  this.flushHarvest();
 }
};
