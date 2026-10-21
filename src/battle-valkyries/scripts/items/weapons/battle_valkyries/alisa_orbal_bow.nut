this.alisa_orbal_bow <- this.inherit("scripts/items/weapons/weapon",{
 function create(){
  this.weapon.create();this.m.ID="$bvvar{modId}.weapon.alisa_orbal_bow";this.m.Name="$bv{trails.weapon.alisa_orbal_bow.name}";this.m.Description="$bv{trails.weapon.alisa_orbal_bow.description}";
  this.m.Icon="$bvvar{iconPrefix}/alisa_orbal_bow.png";this.m.IconLarge="$bvvar{iconPrefix}/alisa_orbal_bow_large.png";
  this.m.SlotType=this.Const.ItemSlot.Mainhand;this.m.BlockedSlotType=this.Const.ItemSlot.Offhand;
  this.m.ItemType=this.Const.Items.ItemType.Legendary|this.Const.Items.ItemType.Named|this.Const.Items.ItemType.Weapon|this.Const.Items.ItemType.RangedWeapon|this.Const.Items.ItemType.TwoHanded;
  this.m.IsDoubleGrippable=false;this.m.ShowArmamentIcon=false;this.m.AddGenericSkill=true;this.m.ShowQuiver=false;
  this.m.Categories="$bv{trails.weapon.bow_category}";this.m.Value=750;this.m.Condition=80.0;this.m.ConditionMax=80.0;this.m.StaminaModifier=-8;
  this.m.RegularDamage=40;this.m.RegularDamageMax=55;this.m.ArmorDamageMult=0.8;this.m.DirectDamageMult=0.2;this.m.RangeMin=1;this.m.RangeMax=6;
 },
 function onEquip(){this.weapon.onEquip();this.addSkill(this.new("scripts/skills/actives/battle_valkyries/alisa_orbal_shot"));}
});
