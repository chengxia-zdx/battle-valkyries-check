this.the_herta_starweave_mantle <- this.inherit("scripts/items/armor/armor", {
 function create()
 {
  this.armor.create();
  this.m.ID = "$bvvar{modId}.armor.the_herta_starweave_mantle";
  this.m.Name = "$bv{item.the_herta_starweave_mantle.name}";
  this.m.Description = "$bv{item.the_herta_starweave_mantle.description}";
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.m.Condition = 300.0; this.m.ConditionMax = 300.0;
  this.m.StaminaModifier = -10; this.m.Value = 7000;
  this.m.IsUnique = true; this.m.IsDroppedAsLoot = false; this.m.ShowOnCharacter = false;
  this.m.Variant = 80; this.updateVariant();
 }
 function updateVariant()
 {
  this.armor.updateVariant();
  this.m.Icon = "$bvvar{iconPrefix}/the_herta_starweave_mantle.png";
  this.m.IconLarge = "$bvvar{iconPrefix}/the_herta_starweave_mantle_large.png";
 }
});
