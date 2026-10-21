this.tio_orbal_staff <- this.inherit("scripts/items/weapons/weapon",{
 function create(){
  this.weapon.create();this.m.ID="$bvvar{modId}.weapon.tio_orbal_staff";this.m.Name="$bv{orbment.staff.name}";this.m.Description="$bv{orbment.staff.description}";
  this.m.Icon="$bvvar{iconPrefix}/tio_orbal_staff.png";this.m.IconLarge="$bvvar{iconPrefix}/tio_orbal_staff_large.png";
  this.m.SlotType=this.Const.ItemSlot.Mainhand;this.m.BlockedSlotType=this.Const.ItemSlot.Offhand;
  this.m.ItemType=this.Const.Items.ItemType.Weapon|this.Const.Items.ItemType.RangedWeapon|this.Const.Items.ItemType.TwoHanded;
  this.m.IsDoubleGrippable=false;this.m.ShowArmamentIcon=false;this.m.AddGenericSkill=true;this.m.ShowQuiver=false;
  this.m.Value=450;this.m.Condition=80.0;this.m.ConditionMax=80.0;this.m.StaminaModifier=-8;
  this.m.RegularDamage=30;this.m.RegularDamageMax=45;this.m.ArmorDamageMult=0.8;this.m.DirectDamageMult=0.2;this.m.RangeMin=1;this.m.RangeMax=3;
 },
 function onEquip(){this.weapon.onEquip();this.addSkill(this.new("scripts/skills/actives/battle_valkyries/tio_orbal_shot"));}
});
