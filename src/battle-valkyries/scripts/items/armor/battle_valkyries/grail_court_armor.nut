this.grail_court_armor <- this.inherit("scripts/items/armor/armor", {
 m = { BVGrailPiece = "grail_court_armor" },
 function create() {
  this.armor.create(); this.m.ID="$bvvar{modId}.item.grail_court_armor";
  this.m.Name="$bv{chapter.grail.gear.grail_court_armor}";this.m.Description="$bv{chapter.grail.wish.valor.desc}";
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=true;this.m.ShowOnCharacter=true;this.m.Condition=450.0;this.m.ConditionMax=450.0;this.m.StaminaModifier=-6;this.m.Value=30000;
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.updateVariant();
 },
 function updateVariant() {
  this.m.Icon="$bvvar{iconPrefix}/grail_court_armor.png";
  this.m.IconLarge="$bvvar{iconPrefix}/grail_court_armor_large.png";
  this.m.Sprite="bust_bv_grail_court_body";this.m.SpriteDamaged="bust_bv_grail_court_body_damaged";this.m.SpriteCorpse="bust_bv_grail_court_body_dead";
 },
 function onUpdateProperties(p) { this.armor.onUpdateProperties(p); p.Hitpoints += 25; },
});
