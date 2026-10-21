this.grail_oath_ring <- this.inherit("scripts/items/accessory/accessory", {
 m = { BVGrailPiece = "grail_oath_ring" },
 function create() {
  this.accessory.create(); this.m.ID="$bvvar{modId}.item.grail_oath_ring";
  this.m.Name="$bv{chapter.grail.gear.grail_oath_ring}";this.m.Description="$bv{chapter.grail.wish.valor.desc}";
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=true;this.m.StaminaModifier=20;this.m.Value=15000;
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.updateVariant();
 },
 function updateVariant() {
  this.m.Icon="$bvvar{iconPrefix}/grail_oath_ring.png";
 },
 function onUpdateProperties(p) { this.accessory.onUpdateProperties(p); p.Stamina += 20; }
});
