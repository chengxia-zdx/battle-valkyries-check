::$bvvar{namespace}.RyzaAlchemy <- {
 Pending = null, Serial = 0, Busy = false,
 function api() { return ::$bvvar{namespace}; },
 function day() { return ::World == null ? 0.0 : ::World.getTime().Days.tofloat(); },
 function custom(i) { return i != null && i.getID() == "$bvvar{modId}.accessory.ryza_pet"; },
 function family(id) { local d=this.api().RyzaPets[id]; return "Parent" in d ? d.Parent : id; },
 function definition(i) { return this.api().RyzaPets[i.m.Species]; },
 function type(i)
 {
  if (this.custom(i)) return i.m.Species;
  if (i == null) return null;
  local id = i.getID();
  if (id == "accessory.wardog" || id == "accessory.armored_wardog" || id == "accessory.heavily_armored_wardog" || id == "accessory.legend_wardog" || id == "accessory.legend_armored_wardog" || id == "accessory.legend_heavily_armored_wardog") return "wardog";
  if (id == "accessory.warhound" || id == "accessory.armored_warhound" || id == "accessory.heavily_armored_warhound" || id == "accessory.legend_warhound" || id == "accessory.legend_armored_warhound" || id == "accessory.legend_heavily_armored_warhound") return "warhound";
  if (id == "accessory.warwolf" || id == "accessory.legend_warwolf") return "wolf";
  if (id == "accessory.falcon") return "falcon";
  return null;
 },
 function stats(i)
 {
  local s = clone this.definition(i).Stats, tier = i.m.Tier, scale = [0.0,0.45,0.62,0.80,1.0][tier];
  foreach (key in ["HP","Body","Head","Min","Max"]) s[key] = ::Math.floor(s[key] * scale).tointeger();
  s.Attack -= (4 - tier) * 7; s.Defense -= (4 - tier) * 3;
  if (i.m.Focus == "vitality") { s.HP += ::Math.floor(s.HP * 0.05 * i.m.Rank).tointeger(); s.Defense += i.m.Rank * 2; }
  if (i.m.Focus == "precision") { s.Attack += i.m.Rank * 3; s.Min += i.m.Rank * 2; s.Max += i.m.Rank * 2; }
  s.Stamina <- 150; s.Bravery <- 90; s.Initiative <- this.definition(i).Role == "pursuit" ? 140 : 90;
  s.MeleeSkill <- s.Attack; s.RangedSkill <- s.Attack; s.MeleeDefense <- s.Defense; s.RangedDefense <- s.Defense;
  if("Inherited" in i.m && i.m.Inherited!=null) foreach(k,v in i.m.Inherited) if(k in s) s[k]+=v;
  s.Attack = s.Range>1 ? s.RangedSkill : s.MeleeSkill; s.Defense = s.MeleeDefense;
  return s;
 },
 function editable()
 {
  local a = this.api().findValkyrieInRoster("ryza");
  return a != null && !this.api().isActorDeadOrDying(a) && !a.isPlacedOnMap() && ::World.State != null;
 },
 function baseName(id)
 {
  local names = { wardog = "$bv{ryza.base.wardog}", warhound = "$bv{ryza.base.warhound}", wolf = "$bv{ryza.base.wolf}", falcon = "$bv{ryza.base.falcon}" };
  return id in names ? names[id] : this.api().RyzaPets[id].Name;
 },
 function recipes()
 {
  local out = [];
  foreach (id in this.api().RyzaPetOrder)
  {
   local d = this.api().RyzaPets[id];
   local fusion = "Parent" in d;
   for (local tier = fusion ? 3 : 1; tier <= 4; tier++)
   {
    local slots = [];
    if (fusion && tier == 3) slots.push({Species=d.Parent,Tier=2,Name=this.api().RyzaPets[d.Parent].Name+" T2"});
    else if (tier == 1) foreach (basis in d.Bases) slots.push({ Species = basis, Tier = 0, Name = this.baseName(basis) });
    else slots.push({ Species = id, Tier = tier - 1, Name = d.Name + " T" + (tier - 1) });
    local mats = [{ Key = d.Material, Count = tier == 1 ? 1 : tier }];
    if (tier == 2) mats.push({ Key = "unhold_hide", Count = 1 });
    if (tier == 3) mats.push({ Key = "unhold_heart", Count = 1 });
    if (tier == 4) { mats.push({ Key = "lindwurm_bones", Count = 2 }); mats.push({ Key = "lindwurm_scales", Count = 2 }); }
    if(fusion) { mats=[]; if(tier==3) foreach(m in d.FusionMaterials)mats.push(clone m); else mats=[{Key="unhold_heart",Count=2},{Key="lindwurm_bones",Count=2},{Key="lindwurm_scales",Count=2}]; }
    // Combine duplicate materials so count/consumption agree.
    local combined = []; foreach (m in mats) { local match = null; foreach (c in combined) if (c.Key == m.Key) match = c; if (match != null) match.Count += m.Count; else combined.push(clone m); }
    out.push({ ID = id + "_t" + tier, Species = id, Tier = tier, Name = d.Name, Role = d.Role, RoleName = d.RoleName, Description = d.Description,
     Brother = fusion && tier == 3, Fusion = fusion, Route = fusion && tier == 3 ? "brother" : tier > 1 ? "upgrade" : (d.Bases.len() == 1 ? "single" : (d.Bases.len() == 3 ? "triple" : "fusion")),
     Slots = slots, Materials = combined, Cost = fusion ? (tier==3?5000:10000) : tier == 1 ? (d.Bases.len() == 1 ? 600 : 800) : [0,0,1000,3000,8000][tier],
     Icon = "ui/items/$bvvar{iconPrefix}/ryza_pets/" + id + ".png" });
   }
  }
  return out;
 },
 function eligible(i) { return this.type(i) != null && (!this.custom(i) || i.ready()); },
 function itemDTO(i, equipped = false)
 {
  if (this.custom(i)) i.refreshRecovery();
  return { ID = i.getInstanceID(), Species = this.type(i), Tier = this.custom(i) ? i.m.Tier : 0, Name = i.getName(), Icon = "ui/items/" + i.getIcon(),
   Available = !equipped && this.eligible(i), Reason = equipped ? "$bv{ryza.alchemy.unequip}" : (this.eligible(i) ? "" : "$bv{ryza.alchemy.recover}"),
   DonorName = this.custom(i) ? i.m.DonorName : "", Inherited = this.custom(i) ? i.m.Inherited : {}, Rank = this.custom(i) ? i.m.Rank : 0, Focus = this.custom(i) ? i.m.Focus : "", Stats = this.custom(i) ? this.stats(i) : null,
   Health = this.custom(i) ? ::Math.floor(i.m.HP * 100) : 100, Body = this.custom(i) ? ::Math.floor(i.m.Body * 100) : 100, Head = this.custom(i) ? ::Math.floor(i.m.Head * 100) : 100,
   Days = this.custom(i) ? ::Math.max(0, ::Math.ceil(i.m.InjuredUntil - this.day())) : 0,
   RepairCost = this.custom(i) ? 150 * i.m.Tier : 0, TrainingCost = this.custom(i) ? 500 * (i.m.Rank + 1) * i.m.Tier : 0, ResetCost = 1000 };
 },
 function dto()
 {
  local items = [], counts = {}, recipes = this.recipes(), stash = ::World.Assets.getStash();
  foreach (i in stash.getItems())
  {
   if (i == null) continue;
   local id = i.getID(); counts[id] <- (id in counts ? counts[id] : 0) + 1;
   if (this.type(i) != null) items.push(this.itemDTO(i));
  }
  foreach (a in ::World.getPlayerRoster().getAll())
  { local i = a.getItems().getItemAtSlot(::Const.ItemSlot.Accessory); if (this.type(i) != null) items.push(this.itemDTO(i, true)); }
  local money = ::World.Assets.getMoney();
  foreach (r in recipes)
  {
   local ready = this.editable() && money >= r.Cost, used = {};
   foreach (s in r.Slots)
   {
    local found = false; foreach (i in items) if (i.Available && i.Species == s.Species && i.Tier == s.Tier && !(i.ID in used)) { used[i.ID] <- true; found = true; break; }
    s.Available <- found; if (!found) ready = false;
   }
   foreach (m in r.Materials)
   {
    local d = this.api().RyzaMaterials[m.Key]; m.Name <- d.Name; m.Icon <- d.Icon; m.Have <- d.ID in counts ? counts[d.ID] : 0;
    if (m.Have < m.Count) ready = false;
   }
   r.Ready <- ready;
   local sample = { m = { Species = r.Species, Tier = r.Tier, Focus = "", Rank = 0 } }; r.Stats <- this.stats(sample);
  }
  local dto = { Editable = this.editable(), Money = money, Items = items, Recipes = recipes, Description = "$bv{ryza.alchemy.description}" };
  return "RyzaTransmutation" in this.api() ? this.api().RyzaTransmutation.augmentDTO(dto) : dto;
 },
 function fail(message) { return { Success = false, Message = message }; },
 function plan(request)
 {
  if (!this.editable()) return this.fail("$bv{ryza.alchemy.locked}");
  if (typeof request != "table" || !("Recipe" in request) || typeof request.Recipe != "string" || !("Pets" in request) || typeof request.Pets != "array") return this.fail("$bv{ryza.alchemy.invalid}");
  local recipe = null, candidates = "Kind" in request && request.Kind=="augment" ? this.api().RyzaTransmutation.traitRecipes() : this.recipes(); foreach (r in candidates) if (r.ID == request.Recipe) recipe = r;
  if (recipe == null || request.Pets.len() != recipe.Slots.len()) return this.fail("$bv{ryza.alchemy.invalid}");
  local stash = ::World.Assets.getStash(), consumed = [], seen = {}, signature = recipe.ID + "|", names = [], main = null;
  foreach (index, id in request.Pets)
  {
   // Native item instance IDs are opaque hash strings, including negative hashes.
   if (typeof id != "string" || id.len() == 0) return this.fail("$bv{ryza.alchemy.invalid}");
   if (id in seen) return this.fail("$bv{ryza.alchemy.select_pets}");
   seen[id] <- true; local rec = stash.getItemByInstanceID(id), slot = recipe.Slots[index];
   if (rec == null || rec.item == null) return this.fail("$bv{ryza.alchemy.changed}");
   local i = rec.item;
   if (!this.eligible(i) || this.type(i) != slot.Species || (this.custom(i) ? i.m.Tier : 0) != slot.Tier) return this.fail("$bv{ryza.alchemy.invalid_pet}");
   if (index == 0) main = i;
   names.push(i.getName()); consumed.push(i); signature += id + ":" + i.getName() + "|";
   if (this.custom(i)) signature += i.m.HP + ":" + i.m.Body + ":" + i.m.Head + ":" + i.m.Rank + ":" + i.m.Focus + "|";
  }
  foreach (m in recipe.Materials)
  {
   local need = m.Count, material = this.api().RyzaMaterials[m.Key];
   foreach (i in stash.getItems()) if (i != null && i.getID() == material.ID && !(i.getInstanceID() in seen) && need > 0)
   { consumed.push(i); seen[i.getInstanceID()] <- true; signature += i.getInstanceID() + "|"; need--; }
   if (need > 0) return this.fail("$bv{ryza.alchemy.missing}" + material.Name + " ×" + need);
  }
  if (::World.Assets.getMoney() < recipe.Cost) return this.fail("$bv{ryza.alchemy.money}");
  signature += recipe.Cost;
  local p={ Success = true, Recipe = recipe, Main = main, Consumed = consumed, Names = names, Signature = signature };
  return this.api().RyzaTransmutation.prepare(p,request);
 },
 function preview(request)
 {
  local p = this.plan(request); this.Pending = null; if (!p.Success) return p;
  this.Serial++; local token = this.Serial.tostring(); this.Pending = { Token = token, Signature = p.Signature };
  return this.api().RyzaTransmutation.preview(p,token);
 },
 function craft(request)
 {
  if (this.Busy || typeof request != "table" || !("Token" in request) || this.Pending == null || request.Token != this.Pending.Token) return this.fail("$bv{ryza.alchemy.changed}");
  local pending = this.Pending; this.Pending = null; local p = this.plan(request);
  if (!p.Success) return p;
  if (pending.Signature != p.Signature) return this.fail("$bv{ryza.alchemy.changed}");
  if(p.Actor!=null && !("Kind" in p.Recipe) && (!("Acknowledge" in request) || request.Acknowledge!=true)) return this.fail("$bv{ryza.ext.irreversible}");
  return this.api().RyzaTransmutation.commit(p);
 },
 function maintain(request)
 {
  if (this.Busy || !this.editable() || typeof request != "table" || !("ID" in request) || typeof request.ID != "string" || request.ID.len() == 0 || !("Action" in request) || !("Rank" in request)) return this.fail("$bv{ryza.alchemy.invalid}");
  local rec = ::World.Assets.getStash().getItemByInstanceID(request.ID);
  if (rec == null || !this.custom(rec.item)) return this.fail("$bv{ryza.alchemy.changed}");
  local i = rec.item; i.refreshRecovery();
  if (i.m.Used || i.m.InjuredUntil > this.day()) return this.fail("$bv{ryza.alchemy.recover}");
  if (i.m.Rank != request.Rank) return this.fail("$bv{ryza.alchemy.changed}");
  local cost = 0, action = request.Action;
  if (action == "repair") { if (i.m.HP >= 1.0 && i.m.Body >= 1.0 && i.m.Head >= 1.0) return this.fail("$bv{ryza.alchemy.full}"); cost = 150 * i.m.Tier; }
  else if (action == "vitality" || action == "precision") { if (i.m.Rank >= 2 || (i.m.Focus != "" && i.m.Focus != action)) return this.fail("$bv{ryza.alchemy.training_locked}"); cost = 500 * (i.m.Rank + 1) * i.m.Tier; }
  else if (action == "reset") { if (i.m.Rank == 0) return this.fail("$bv{ryza.alchemy.training_locked}"); cost = 1000; }
  else return this.fail("$bv{ryza.alchemy.invalid}");
  if (::World.Assets.getMoney() < cost) return this.fail("$bv{ryza.alchemy.money}");
  ::World.Assets.addMoney(-cost);
  if (action == "repair") { i.m.HP = 1.0; i.m.Body = 1.0; i.m.Head = 1.0; }
  else if (action == "reset") { i.m.Rank = 0; i.m.Focus = ""; }
  else { i.m.Rank++; i.m.Focus = action; }
  this.Pending = null; return { Success = true, Message = "$bv{ryza.alchemy.maintained}" };
 }
};
