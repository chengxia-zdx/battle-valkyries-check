this.the_herta_astrolabe_crown <- this.inherit("scripts/items/helmets/helmet", {
 function create()
 {
  this.helmet.create();
  this.m.ID = "$bvvar{modId}.helmet.the_herta_astrolabe_crown";
  this.m.Name = "$bv{item.the_herta_astrolabe_crown.name}";
  this.m.Description = "$bv{item.the_herta_astrolabe_crown.description}";
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.m.Condition = 240.0; this.m.ConditionMax = 240.0;
  this.m.StaminaModifier = -5; this.m.Vision = 0; this.m.Value = 5000;
  this.m.IsUnique = true; this.m.IsDroppedAsLoot = false; this.m.ShowOnCharacter = false;
  this.m.Variant = 84; this.updateVariant();
 }
 function updateVariant()
 {
  this.helmet.updateVariant();
  this.m.Icon = "$bvvar{iconPrefix}/the_herta_astrolabe_crown.png";
  this.m.IconLarge = "$bvvar{iconPrefix}/the_herta_astrolabe_crown.png";
 }
});
