this.kanade_tachibana_unsent_thanks <- this.inherit("scripts/items/accessory/accessory", {
 m={KanadeTier=0,KanadeOwner="",KanadeStage=40,KanadeKey="unsent_thanks"},
 function create()
 {
  this.accessory.create();this.m.ID="$bvvar{modId}.accessory.kanade_tachibana_unsent_thanks";this.m.Name="$bv{kanade.item.unsent_thanks.name}";this.m.Description="$bv{kanade.item.unsent_thanks.description}";
  this.m.Value=3000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.AddGenericSkill=true;
  this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Condition=1.0;this.m.ConditionMax=1.0;this.m.StaminaModifier=0;
  this.m.ShowOnCharacter=false;this.m.IsAllowedInBag=true;this.m.IsChangeableInBattle=false;
  this.m.Icon="$bvvar{iconPrefix}/kanade_tachibana_unsent_thanks.png";this.m.IconLarge="$bvvar{iconPrefix}/kanade_tachibana_unsent_thanks.png";
 },
 
 function upgradeKanade(up=true)
 {
  local old=this.m.ConditionMax,condition=this.m.Condition;
  this.m.KanadeTier=up?1:0;this.m.ConditionMax=up?1.0:1.0;
  this.m.Condition=::Math.min(this.m.ConditionMax,condition+(this.m.ConditionMax-old));
  
 },
 function onUpdateProperties(p){this.accessory.onUpdateProperties(p);p.Hitpoints+=this.m.KanadeTier>0?30:20;p.Bravery+=10;},
 function onSerialize(out){this.accessory.onSerialize(out);out.writeU8(1);out.writeU8(this.m.KanadeTier);out.writeString(this.m.KanadeOwner);},
 function onDeserialize(input)
 {
  this.accessory.onDeserialize(input);local version=input.readU8();if(version!=1)throw "Unsupported Kanade equipment schema";
  local tier=input.readU8(),condition=this.m.Condition;this.m.KanadeOwner=input.readString();this.upgradeKanade(tier>0);this.m.Condition=::Math.min(condition,this.m.ConditionMax);
 }
});
