this.renne_annihilation_scythe <- this.inherit("scripts/items/weapons/weapon",{
 function create(){
  this.weapon.create();this.m.ID="$bvvar{modId}.weapon.renne_annihilation_scythe";this.m.Name="$bv{trails.weapon.renne_annihilation_scythe.name}";this.m.Description="$bv{trails.weapon.renne_annihilation_scythe.description}";
  this.m.Icon="$bvvar{iconPrefix}/renne_annihilation_scythe.png";this.m.IconLarge="$bvvar{iconPrefix}/renne_annihilation_scythe_large.png";
  this.m.SlotType=this.Const.ItemSlot.Mainhand;this.m.BlockedSlotType=this.Const.ItemSlot.Offhand;
  this.m.ItemType=this.Const.Items.ItemType.Legendary|this.Const.Items.ItemType.Named|this.Const.Items.ItemType.Weapon|this.Const.Items.ItemType.MeleeWeapon|this.Const.Items.ItemType.TwoHanded;
  this.m.IsDoubleGrippable=false;this.m.ShowArmamentIcon=false;this.m.AddGenericSkill=true;this.m.ShowQuiver=false;
  this.m.Categories="$bv{trails.weapon.scythe_category}";this.m.Value=750;this.m.Condition=80.0;this.m.ConditionMax=80.0;this.m.StaminaModifier=-12;
  this.m.RegularDamage=55;this.m.RegularDamageMax=80;this.m.ArmorDamageMult=1.05;this.m.DirectDamageMult=0.3;this.m.RangeMin=1;this.m.RangeMax=2;
 },
 function onEquip(){this.weapon.onEquip();this.addSkill(this.new("scripts/skills/actives/strike_skill"));this.addSkill(this.new("scripts/skills/actives/reap_skill"));}
});
