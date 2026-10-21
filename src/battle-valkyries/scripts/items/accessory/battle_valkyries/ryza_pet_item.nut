// Public path and schema are save contracts. Never serialize tactical entities.
this.ryza_pet_item <- this.inherit("scripts/items/accessory/accessory", {
 m = { Species = "bone_mastiff", Tier = 1, Rank = 0, Focus = "", PetName = "", HP = 1.0, Body = 1.0, Head = 1.0, InjuredUntil = 0.0, LastDay = 0.0, Entity = null, Used = false, Inherited = null, DonorName = "" },
 function f() { return ::$bvvar{namespace}.RyzaAlchemy; }
 function create()
 {
  this.accessory.create(); this.m.Inherited = {}; this.m.ID = "$bvvar{modId}.accessory.ryza_pet";
  this.m.SlotType = this.Const.ItemSlot.Accessory; this.m.IsDroppedAsLoot = true; this.m.ShowOnCharacter = false;
  this.m.IsChangeableInBattle = false; this.m.Value = 800; this.updateIcon();
 }
 function configure(species, tier, name = "")
 {
  this.m.Species = species; this.m.Tier = tier; this.m.PetName = name; this.m.LastDay = this.f().day(); this.m.Value = 500 * tier * tier;
  this.updateIcon(); return this;
 }
 function updateIcon() { this.m.Icon = "$bvvar{iconPrefix}/ryza_pets/" + this.m.Species + ".png"; this.m.IconLarge = this.m.Icon; }
 function getName() { return (this.m.PetName == "" ? this.f().definition(this).Name : this.m.PetName + " — " + this.f().definition(this).Name) + " [T" + this.m.Tier + "]"; }
 function getDescription() { return this.f().definition(this).Description + "\n$bv{ryza.pet.rules}" + (this.m.DonorName==""?"":"\n$bv{ryza.ext.inherited_from}"+this.m.DonorName); }
 function isAllowedInBag() { return false; }
 function ready() { this.refreshRecovery(); return !this.m.Used && this.m.InjuredUntil <= this.f().day() && this.m.HP > 0; }
 function refreshRecovery()
 {
  local day = this.f().day();
  if (day <= this.m.LastDay) return;
  local from = ::Math.maxf(this.m.LastDay, this.m.InjuredUntil);
  if (day >= this.m.InjuredUntil && this.m.HP <= 0) this.m.HP = 0.25;
  if (day > from) this.m.HP = ::Math.minf(1.0, this.m.HP + (day - from) * 0.15);
  this.m.LastDay = day;
 }
 function snapshot()
 {
  local a = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Entity);
  if (a == null || ::$bvvar{namespace}.isActorDeadOrDying(a)) return;
  local stats = this.f().stats(this);
  this.m.HP = ::Math.maxf(0.0, ::Math.minf(1.0, a.getHitpoints().tofloat() / stats.HP));
  this.m.Body = ::Math.maxf(0.0, ::Math.minf(1.0, a.m.BaseProperties.Armor[0].tofloat() / stats.Body));
  this.m.Head = ::Math.maxf(0.0, ::Math.minf(1.0, a.m.BaseProperties.Armor[1].tofloat() / stats.Head));
  this.m.LastDay = this.f().day();
 }
 function injured()
 {
  this.m.HP = 0.0; this.m.Body = 0.0; this.m.Head = 0.0;
  this.m.InjuredUntil = this.f().day() + (this.m.Tier == 4 ? 5 : (this.m.Tier == 3 ? 3 : 2));
  this.m.LastDay = this.f().day(); this.m.Entity = null; this.m.Used = true;
 }
 function onEquip()
 {
  this.accessory.onEquip(); local s = this.new("scripts/skills/actives/battle_valkyries/ryza_unleash_pet"); s.setItem(this); this.addSkill(s);
 }
 function onCombatFinished() { this.snapshot(); this.m.Entity = null; this.m.Used = false; }
 function getTooltip()
 {
  this.refreshRecovery(); local s = this.f().stats(this), d = this.f().definition(this);
  return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
   { id = 3, type = "text", icon = "ui/icons/special.png", text = d.RoleName + " | $bv{ryza.pet.training}" + this.m.Rank + "/2" },
   { id = 4, type = "text", icon = "ui/icons/health.png", text = "$bv{ryza.pet.hp}" + ::Math.floor(s.HP * this.m.HP) + "/" + s.HP },
   { id = 5, type = "text", icon = "ui/icons/armor_body.png", text = "$bv{ryza.pet.armor}" + ::Math.floor(s.Body * this.m.Body) + "/" + s.Body + " | " + ::Math.floor(s.Head * this.m.Head) + "/" + s.Head },
   { id = 6, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{ryza.pet.damage}" + s.Min + "–" + s.Max + " | " + s.Armor + "% | $bv{ryza.pet.range}" + s.Range },
   { id = 7, type = "text", icon = "ui/icons/special.png", text = this.m.Used ? "$bv{ryza.pet.used}" : (this.m.InjuredUntil > this.f().day() ? "$bv{ryza.pet.injured}" + ::Math.ceil(this.m.InjuredUntil - this.f().day()) : "$bv{ryza.pet.ready}") }];
 }
 function onSerialize(out)
 {
  this.snapshot(); this.accessory.onSerialize(out); out.writeU8(2); out.writeString(this.m.Species); out.writeU8(this.m.Tier);
  out.writeU8(this.m.Rank); out.writeString(this.m.Focus); out.writeString(this.m.PetName);
  out.writeF32(this.m.HP); out.writeF32(this.m.Body); out.writeF32(this.m.Head); out.writeF32(this.m.InjuredUntil); out.writeF32(this.m.LastDay);
  out.writeString(this.m.DonorName); foreach(k in ::$bvvar{namespace}.RyzaInheritanceKeys) out.writeU8(k in this.m.Inherited ? this.m.Inherited[k] : 0);
 }
 function onDeserialize(input)
 {
  this.accessory.onDeserialize(input); local version = input.readU8(); if (version != 1 && version != 2) throw "[Battle Valkyries] Unsupported Ryza pet schema: " + version;
  this.m.Species = input.readString(); this.m.Tier = input.readU8(); this.m.Rank = input.readU8(); this.m.Focus = input.readString(); this.m.PetName = input.readString();
  this.m.HP = input.readF32(); this.m.Body = input.readF32(); this.m.Head = input.readF32(); this.m.InjuredUntil = input.readF32(); this.m.LastDay = input.readF32();
  this.m.Inherited={}; this.m.DonorName=""; if(version>=2) { this.m.DonorName=input.readString(); foreach(k in ::$bvvar{namespace}.RyzaInheritanceKeys) {local v=input.readU8(); if(v>0)this.m.Inherited[k]<-v;} }
  if (!(this.m.Species in ::$bvvar{namespace}.RyzaPets) || this.m.Tier < 1 || this.m.Tier > 4 || this.m.Rank > 2) throw "[Battle Valkyries] Invalid Ryza pet save";
  this.m.Entity = null; this.m.Used = false; this.updateIcon(); this.m.Value = 500 * this.m.Tier * this.m.Tier;
 }
});
