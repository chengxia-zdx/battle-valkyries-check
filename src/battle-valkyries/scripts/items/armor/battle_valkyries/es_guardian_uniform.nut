this.es_guardian_uniform <- this.inherit("scripts/items/armor/armor", {
 m = { EsOwner = "" },
 function create()
 {
  this.armor.create();
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.m.ID = "$bvvar{modId}.armor.es_guardian_uniform";
  this.m.Name = "$bv{es.armor.name}";
  this.m.Description = "$bv{es.armor.description}";
  this.m.Value = 6000;
  this.m.Condition = 300.0; this.m.ConditionMax = 300.0;
  this.m.StaminaModifier = -8;
  this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
  this.m.Variant = 80; this.updateVariant();
 },
 function updateVariant()
 {
  this.armor.updateVariant();
  this.m.Icon = "$bvvar{iconPrefix}/es_guardian_uniform.png";
  this.m.IconLarge = "$bvvar{iconPrefix}/es_guardian_uniform_large.png";
 },
 function onSerialize(out)
 {
  this.armor.onSerialize(out); out.writeU8(1); out.writeString(this.m.EsOwner);
 },
 function onDeserialize(input)
 {
  this.armor.onDeserialize(input);
  local version = input.readU8();
  if(version != 1)throw "[Battle Valkyries] Unsupported Es uniform schema: " + version;
  this.m.EsOwner = input.readString(); this.updateVariant();
 }
});
