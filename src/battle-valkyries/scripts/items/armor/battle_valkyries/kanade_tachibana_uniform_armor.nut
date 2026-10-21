this.kanade_tachibana_uniform_armor <- this.inherit("scripts/items/armor/armor", {
 m={KanadeTier=0,KanadeOwner="",KanadeStage=20,KanadeKey="uniform_armor"},
 function create()
 {
  this.armor.create();this.m.ID="$bvvar{modId}.armor.kanade_tachibana_uniform_armor";this.m.Name="$bv{kanade.item.uniform_armor.name}";this.m.Description="$bv{kanade.item.uniform_armor.description}";
  this.m.Value=3000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.AddGenericSkill=true;
  this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Condition=280.0;this.m.ConditionMax=280.0;this.m.StaminaModifier=-8;
  this.m.Variant=80;this.updateVariant();
  this.m.Icon="$bvvar{iconPrefix}/kanade_tachibana_uniform_armor.png";this.m.IconLarge="$bvvar{iconPrefix}/kanade_tachibana_uniform_armor_large.png";
 },
 function updateVariant(){this.armor.updateVariant();this.m.Icon="$bvvar{iconPrefix}/kanade_tachibana_uniform_armor.png";this.m.IconLarge="$bvvar{iconPrefix}/kanade_tachibana_uniform_armor_large.png";},
 function upgradeKanade(up=true)
 {
  local old=this.m.ConditionMax,condition=this.m.Condition;
  this.m.KanadeTier=up?1:0;this.m.ConditionMax=up?360.0:280.0;
  this.m.Condition=::Math.min(this.m.ConditionMax,condition+(this.m.ConditionMax-old));
  
 },
 function onUpdateProperties(p){this.armor.onUpdateProperties(p);p.MeleeDefense+=5;},
 function onSerialize(out){this.armor.onSerialize(out);out.writeU8(1);out.writeU8(this.m.KanadeTier);out.writeString(this.m.KanadeOwner);},
 function onDeserialize(input)
 {
  this.armor.onDeserialize(input);local version=input.readU8();if(version!=1)throw "Unsupported Kanade equipment schema";
  local tier=input.readU8(),condition=this.m.Condition;this.m.KanadeOwner=input.readString();this.upgradeKanade(tier>0);this.m.Condition=::Math.min(condition,this.m.ConditionMax);
 }
});
