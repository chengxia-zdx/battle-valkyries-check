this.grail_court_helmet <- this.inherit("scripts/items/helmets/helmet", {
 m = { BVGrailPiece = "grail_court_helmet" },
 function create() {
  this.helmet.create(); this.m.ID="$bvvar{modId}.item.grail_court_helmet";
  this.m.Name="$bv{chapter.grail.gear.grail_court_helmet}";this.m.Description="$bv{chapter.grail.wish.valor.desc}";
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=true;this.m.ShowOnCharacter=true;this.m.HideHair=true;this.m.Condition=400.0;this.m.ConditionMax=400.0;this.m.StaminaModifier=-4;this.m.Vision=0;this.m.Value=25000;
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.updateVariant();
 },
 function updateVariant() {
  this.m.Icon="$bvvar{iconPrefix}/grail_court_helmet.png";
  this.m.Sprite="bust_bv_grail_court_helmet";this.m.SpriteDamaged="bust_bv_grail_court_helmet_damaged";this.m.SpriteCorpse="bust_bv_grail_court_helmet_dead";
 },
 function onUpdateProperties(p) { this.helmet.onUpdateProperties(p); p.Bravery += 20; },
});
