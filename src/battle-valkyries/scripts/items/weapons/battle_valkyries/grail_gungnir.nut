this.grail_gungnir <- this.inherit("scripts/items/weapons/weapon", {
 m = { BVGrailPiece = "grail_gungnir" },
 function create() {
  this.weapon.create(); this.m.ID="$bvvar{modId}.item.grail_gungnir";
  this.m.Name="$bv{chapter.grail.gear.grail_gungnir}";this.m.Description="$bv{chapter.grail.wish.valor.desc}";
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=true;this.m.SlotType=this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType=this.Const.ItemSlot.Offhand; this.m.Categories="$bv{chapter.grail.combat.weapon.category}"; this.m.ItemType=this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Legendary; this.m.Condition=160.0;this.m.ConditionMax=160.0;this.m.StaminaModifier=-12;this.m.Value=50000;this.m.RegularDamage=140;this.m.RegularDamageMax=170;this.m.ArmorDamageMult=2.0;this.m.DirectDamageMult=0.5;this.m.AdditionalAccuracy=20;this.m.RangeMin=1;this.m.RangeMax=2;this.m.RangeIdeal=2;this.m.ShowArmamentIcon=true;this.m.ArmamentIcon="icon_bv_grail_gungnir";
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.updateVariant();
 },
 function updateVariant() {
  this.m.Icon="$bvvar{iconPrefix}/grail_gungnir.png";
  this.m.IconLarge="$bvvar{iconPrefix}/grail_gungnir_large.png";
 },
});
