this.kanade_tachibana_hand_sonic <- this.inherit("scripts/items/weapons/weapon", {
 m={KanadeTier=0,KanadeOwner="",KanadeStage=80,KanadeKey="hand_sonic"},
 function create()
 {
  this.weapon.create();this.m.ID="$bvvar{modId}.weapon.kanade_tachibana_hand_sonic";this.m.Name="$bv{kanade.item.hand_sonic.name}";this.m.Description="$bv{kanade.item.hand_sonic.description}";
  this.m.Value=3000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.AddGenericSkill=true;
  this.m.Condition=120.0;this.m.ConditionMax=120.0;this.m.StaminaModifier=-6;
  this.m.Categories="$bv{kanade.weapon.category}";this.m.SlotType=this.Const.ItemSlot.Mainhand;this.m.BlockedSlotType=this.Const.ItemSlot.Offhand;
  this.m.ItemType=this.Const.Items.ItemType.Legendary|this.Const.Items.ItemType.Named|this.Const.Items.ItemType.Weapon|this.Const.Items.ItemType.MeleeWeapon|this.Const.Items.ItemType.TwoHanded;
  if("WeaponType" in this.Const.Items && "Sword" in this.Const.Items.WeaponType)
  {
   // MSU lazily infers types from category text; finalize that before assigning the explicit type.
   if("setWeaponType" in this)this.setWeaponType(this.Const.Items.WeaponType.Sword,false);
   else this.m.WeaponType <- this.Const.Items.WeaponType.Sword;
  }
  this.m.ShowQuiver=false;this.m.RangeMin=1;this.m.RangeMax=1;this.m.RangeIdeal=1;
  this.m.RegularDamage=85;this.m.RegularDamageMax=105;this.m.ArmorDamageMult=1.30;this.m.DirectDamageMult=0.35;
  this.updateVariant();
 },
 function updateVariant()
 {
  // Native deserialization also restores these derived visuals for existing items.
  this.m.Icon="$bvvar{iconPrefix}/kanade_tachibana_hand_sonic.png";this.m.IconLarge="$bvvar{iconPrefix}/kanade_tachibana_hand_sonic_large.png";
  this.m.ShowArmamentIcon=true;this.m.ArmamentIcon="icon_bv_kanade_hand_sonic";
 },
 function upgradeKanade(up=true)
 {
  local old=this.m.ConditionMax,condition=this.m.Condition;
  this.m.KanadeTier=up?1:0;this.m.ConditionMax=up?150.0:120.0;
  this.m.Condition=::Math.min(this.m.ConditionMax,condition+(this.m.ConditionMax-old));
  if(up){this.m.RegularDamage=105;this.m.RegularDamageMax=125;}
 else{this.m.RegularDamage=85;this.m.RegularDamageMax=105;}
 },
 function onUpdateProperties(p){this.weapon.onUpdateProperties(p);},
 function onSerialize(out){this.weapon.onSerialize(out);out.writeU8(1);out.writeU8(this.m.KanadeTier);out.writeString(this.m.KanadeOwner);},
 function onDeserialize(input)
 {
  this.weapon.onDeserialize(input);local version=input.readU8();if(version!=1)throw "Unsupported Kanade equipment schema";
  local tier=input.readU8(),condition=this.m.Condition;this.m.KanadeOwner=input.readString();this.upgradeKanade(tier>0);this.m.Condition=::Math.min(condition,this.m.ConditionMax);
 }
});
