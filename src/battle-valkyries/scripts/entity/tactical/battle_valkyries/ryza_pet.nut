this.ryza_pet <- this.inherit("scripts/entity/tactical/wardog", {
 m = { Species = "bone_mastiff", Tier = 1, PetStats = null, LastTurn = -1, CounterRound = -1, ProcRound = -1, LeapRound = -99 },
 function create() { this.wardog.create(); this.m.XP = 0; }
 function onInit()
 {
  this.wardog.onInit(); this.getSkills().removeByID("actives.wardog_bite");
  this.getSkills().add(this.new("scripts/skills/actives/battle_valkyries/ryza_pet_attack"));
  this.getSkills().add(this.new("$bvvar{privateFolder}/skills/effects/ryza_pet_passive"));
  this.applyAppearance();
 }
 function configure(item)
 {
  this.setItem(item); this.m.Species = item.m.Species; this.m.Tier = item.m.Tier; this.setName(item.getName());
  local s = ::$bvvar{namespace}.RyzaAlchemy.stats(item); this.m.PetStats = s;
  local b = this.m.BaseProperties; b.ActionPoints = 9; b.Hitpoints = s.HP; b.Stamina = s.Stamina; b.Bravery = s.Bravery;
  b.MeleeSkill = s.MeleeSkill; b.RangedSkill = s.RangedSkill; b.MeleeDefense = s.MeleeDefense; b.RangedDefense = s.RangedDefense;
  b.Initiative = s.Initiative;
  b.Armor = [::Math.floor(s.Body * item.m.Body), ::Math.floor(s.Head * item.m.Head)]; b.ArmorMax = [s.Body,s.Head];
  b.DamageRegularMin = 0; b.DamageRegularMax = 0; b.DamageArmorMult = 1.0;
  this.m.Hitpoints = ::Math.max(1, ::Math.floor(s.HP * item.m.HP)); this.m.ActionPoints = 9; this.m.CurrentProperties = clone b;
  local attack = this.getSkills().getSkillByID("$bvvar{modId}.actives.ryza_pet_attack"); attack.configure(::$bvvar{namespace}.RyzaAlchemy.family(this.m.Species), s);
  this.m.AIAgent = this.new("scripts/ai/tactical/agents/battle_valkyries/ryza_pet_agent"); this.m.AIAgent.setActor(this); this.m.AIAgent.configure();
  if (::$bvvar{namespace}.RyzaAlchemy.family(this.m.Species) == "griffin") this.getSkills().add(this.new("scripts/skills/actives/battle_valkyries/ryza_pet_leap"));
  this.getSkills().update(); this.applyAppearance();
 }
 function setVariant(v) { this.applyAppearance(); }
 function applyAppearance()
 {
  if (!this.hasSprite("body")) return;
  local brush = "bust_bv_ryza_pet_" + this.m.Species;
  this.getItems().getAppearance().Body = brush;
  local body = this.getSprite("body"); body.setBrush(brush); body.Visible = true; body.Alpha = 255;
  body.setHorizontalFlipping(!this.isAlliedWithPlayer()); this.Tactical.addResource(body.getBrush().TextureName);
  foreach (id in ["head","armor","helmet","injury","closed_eyes"]) if (this.hasSprite(id)) { this.getSprite(id).Visible = false; this.getSprite(id).Alpha = 0; }
  this.setDirty(true);
 }
 function onAppearanceChanged(a, dirty = true) { this.actor.onAppearanceChanged(a, false); this.applyAppearance(); }
 function onPlacedOnMap() { this.actor.onPlacedOnMap(); this.applyAppearance(); }
 function onFactionChanged() { this.wardog.onFactionChanged(); this.applyAppearance(); }
 function loadResources() { this.actor.loadResources(); this.applyAppearance(); }
 function onDamageReceived(attacker, skill, hit)
 {
  // Native skill-container callbacks run BEFORE HP is deducted. Counter only
  // after the actor has resolved damage/death, so lethal hits cannot retaliate.
  local result = this.actor.onDamageReceived(attacker, skill, hit), bv = ::$bvvar{namespace};
  if (this.m.Species == "iron_cerberus" && this.m.CounterRound != ::Time.getRound() && skill != null && !skill.isRanged() && hit.DamageInflictedHitpoints + hit.DamageInflictedArmor > 0 && bv.EightValkyries.enemy(this, attacker, 1) && !this.getCurrentProperties().IsStunned && this.getCurrentProperties().IsAbleToUseSkills && this.getMoraleState() != ::Const.MoraleState.Fleeing)
  {
   this.m.CounterRound = ::Time.getRound(); local bite = this.getSkills().getSkillByID("$bvvar{modId}.actives.ryza_pet_attack");
   if (bite != null) bite.counter(this, attacker);
  }
  if (bv.EightValkyries.alive(this) && this.m.Item != null && !this.m.Item.isNull()) this.m.Item.snapshot();
  return result;
 }
 function onDeath(killer, skill, tile, fatality)
 {
  if (tile != null) { local decal = tile.spawnDetail("bust_bv_ryza_pet_" + this.m.Species + "_dead", this.Const.Tactical.DetailFlag.Corpse, false); decal.setBrightness(0.85); this.spawnTerrainDropdownEffect(tile); }
  if (this.m.Item != null && !this.m.Item.isNull()) this.m.Item.injured();
  this.m.Item = null;
  local corpse = this.generateCorpse(tile, fatality, killer);
  if (tile == null) this.Tactical.Entities.addUnplacedCorpse(corpse);
  else { tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(tile); }
  this.actor.onDeath(killer, skill, tile, fatality);
 }
});
