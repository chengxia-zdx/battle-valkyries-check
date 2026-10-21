this.kanade_tachibana_feather_hairpiece <- this.inherit("scripts/items/helmets/helmet", {
 m={KanadeTier=0,KanadeOwner="",KanadeStage=60,KanadeKey="feather_hairpiece"},
 function create()
 {
  this.helmet.create();this.m.ID="$bvvar{modId}.helmet.kanade_tachibana_feather_hairpiece";this.m.Name="$bv{kanade.item.feather_hairpiece.name}";this.m.Description="$bv{kanade.item.feather_hairpiece.description}";
  this.m.Value=3000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.AddGenericSkill=true;
  this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Condition=220.0;this.m.ConditionMax=220.0;this.m.StaminaModifier=-3;
  this.m.Variant=84;this.updateVariant();
  this.m.Icon="$bvvar{iconPrefix}/kanade_tachibana_feather_hairpiece.png";this.m.IconLarge="$bvvar{iconPrefix}/kanade_tachibana_feather_hairpiece.png";
 },
 function updateVariant(){this.helmet.updateVariant();this.m.Icon="$bvvar{iconPrefix}/kanade_tachibana_feather_hairpiece.png";this.m.IconLarge="$bvvar{iconPrefix}/kanade_tachibana_feather_hairpiece.png";},
 function upgradeKanade(up=true)
 {
  local old=this.m.ConditionMax,condition=this.m.Condition;
  this.m.KanadeTier=up?1:0;this.m.ConditionMax=up?280.0:220.0;
  this.m.Condition=::Math.min(this.m.ConditionMax,condition+(this.m.ConditionMax-old));
  
 },
 function onUpdateProperties(p){this.helmet.onUpdateProperties(p);p.Bravery+=10;if(this.m.KanadeTier>0)p.Initiative+=10;},
 function onSerialize(out){this.helmet.onSerialize(out);out.writeU8(1);out.writeU8(this.m.KanadeTier);out.writeString(this.m.KanadeOwner);},
 function onDeserialize(input)
 {
  this.helmet.onDeserialize(input);local version=input.readU8();if(version!=1)throw "Unsupported Kanade equipment schema";
  local tier=input.readU8(),condition=this.m.Condition;this.m.KanadeOwner=input.readString();this.upgradeKanade(tier>0);this.m.Condition=::Math.min(condition,this.m.ConditionMax);
 }
});
