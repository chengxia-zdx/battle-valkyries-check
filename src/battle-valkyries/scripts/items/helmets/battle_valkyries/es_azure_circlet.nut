this.es_azure_circlet <- this.inherit("scripts/items/helmets/helmet", {
 m = { EsOwner = "" },
 function create()
 {
  this.helmet.create();
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.m.ID = "$bvvar{modId}.helmet.es_azure_circlet";
  this.m.Name = "$bv{es.helmet.name}";
  this.m.Description = "$bv{es.helmet.description}";
  this.m.Value = 4000;
  this.m.Condition = 240.0; this.m.ConditionMax = 240.0;
  this.m.StaminaModifier = -4; this.m.Vision = 0;
  this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
  this.m.Variant = 84; this.updateVariant();
 },
 function updateVariant()
 {
  this.helmet.updateVariant();
  this.m.Icon = "$bvvar{iconPrefix}/es_azure_circlet.png";
  this.m.IconLarge = "$bvvar{iconPrefix}/es_azure_circlet.png";
 },
 function onSerialize(out)
 {
  this.helmet.onSerialize(out); out.writeU8(1); out.writeString(this.m.EsOwner);
 },
 function onDeserialize(input)
 {
  this.helmet.onDeserialize(input);
  local version = input.readU8();
  if(version != 1)throw "[Battle Valkyries] Unsupported Es circlet schema: " + version;
  this.m.EsOwner = input.readString(); this.updateVariant();
 }
});
