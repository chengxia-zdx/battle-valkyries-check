this.ryza_unleash_pet <- this.inherit("scripts/skills/skill", {
 function create()
 {
  this.m.ID = "$bvvar{modId}.actives.ryza_unleash_pet"; this.m.Name = "$bv{ryza.pet.unleash}"; this.m.Description = "$bv{ryza.pet.unleash.description}";
  this.m.Icon = "skills/$bvvar{iconPrefix}/ryza_core_crystal.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/ryza_core_crystal_sw.png";
  this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
  this.m.IsSerialized = false; this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = false; this.m.IsTargetingActor = false;
  this.m.ActionPointCost = 3; this.m.FatigueCost = 15; this.m.MinRange = 1; this.m.MaxRange = 1;
 }
 function isUsable() { return this.m.Item != null && this.m.Item.ready() && this.skill.isUsable(); }
 function onVerifyTarget(origin, target) { return target != null && target.IsEmpty && ::Math.abs(origin.Level - target.Level) <= 1 && this.skill.onVerifyTarget(origin, target); }
 function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", text = this.getCostString() }]; }
 function onUse(a, tile)
 {
  if (!this.m.Item.ready() || !this.onVerifyTarget(a.getTile(), tile)) return false;
  local pet = this.Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/ryza_pet", tile.Coords.X, tile.Coords.Y);
  pet.setFaction(this.Const.Faction.PlayerAnimals); pet.configure(this.m.Item);
  this.m.Item.m.Entity = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(pet); this.m.Item.m.Used = true;
  return true;
 }
});
