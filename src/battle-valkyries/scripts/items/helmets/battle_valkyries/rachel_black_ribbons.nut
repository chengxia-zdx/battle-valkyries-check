this.rachel_black_ribbons <- this.inherit("scripts/items/helmets/helmet", {
 m={RachelOwner=""},
 function create()
 {
  this.helmet.create();this.m.ID="$bvvar{modId}.helmet.rachel_black_ribbons";
  this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Name="$bv{rachel.equipment.ribbons.name}";this.m.Description="$bv{rachel.equipment.ribbons.description}";
  this.m.Value=4000;this.m.Condition=200.0;this.m.ConditionMax=200.0;this.m.StaminaModifier=-4;this.m.Vision=0;
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.ShowOnCharacter=false;this.updateVariant();
 },
 function updateVariant(){this.m.Icon="$bvvar{iconPrefix}/rachel_black_ribbons.png";this.m.IconLarge=this.m.Icon;},
 function onUpdateProperties(p)
 {
  this.helmet.onUpdateProperties(p);
  if(::$bvvar{namespace}.Rachel.owns(this.getContainer().getActor())){p.Bravery+=10;p.Initiative+=10;}
 },
 function onSerialize(out){this.helmet.onSerialize(out);out.writeU8(1);out.writeString(this.m.RachelOwner);},
 function onDeserialize(input)
 {
  this.helmet.onDeserialize(input);local version=input.readU8();
  if(version!=1)throw "[Battle Valkyries] Unsupported Rachel ribbons schema: "+version;
  this.m.RachelOwner=input.readString();this.updateVariant();
 }
});
