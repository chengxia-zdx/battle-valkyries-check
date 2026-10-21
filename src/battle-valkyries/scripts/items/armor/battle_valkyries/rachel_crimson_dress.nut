this.rachel_crimson_dress <- this.inherit("scripts/items/armor/armor", {
 m={RachelOwner=""},
 function create()
 {
  this.armor.create();this.m.ID="$bvvar{modId}.armor.rachel_crimson_dress";
  this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Name="$bv{rachel.equipment.dress.name}";this.m.Description="$bv{rachel.equipment.dress.description}";
  this.m.Value=6000;this.m.Condition=260.0;this.m.ConditionMax=260.0;this.m.StaminaModifier=-8;
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.ShowOnCharacter=false;this.updateVariant();
 },
 function updateVariant()
 {
  this.m.Icon="$bvvar{iconPrefix}/rachel_crimson_dress.png";
  this.m.IconLarge="$bvvar{iconPrefix}/rachel_crimson_dress_large.png";
 },
 function onUpdateProperties(p)
 {
  this.armor.onUpdateProperties(p);
  if(::$bvvar{namespace}.Rachel.owns(this.getContainer().getActor()))p.Hitpoints+=10;
 },
 function onSerialize(out){this.armor.onSerialize(out);out.writeU8(1);out.writeString(this.m.RachelOwner);},
 function onDeserialize(input)
 {
  this.armor.onDeserialize(input);local version=input.readU8();
  if(version!=1)throw "[Battle Valkyries] Unsupported Rachel dress schema: "+version;
  this.m.RachelOwner=input.readString();this.updateVariant();
 }
});
