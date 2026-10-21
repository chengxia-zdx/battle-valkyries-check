this.rachel_nago_parasol <- this.inherit("scripts/items/weapons/weapon", {
 m={RachelOwner=""},
 function create()
 {
  this.weapon.create();this.m.ID="$bvvar{modId}.weapon.rachel_nago_parasol";
  this.m.Name="$bv{rachel.equipment.parasol.name}";this.m.Description="$bv{rachel.equipment.parasol.description}";
  this.m.Categories="$bv{rachel.equipment.parasol.category}";
  this.m.SlotType=this.Const.ItemSlot.Mainhand;this.m.BlockedSlotType=this.Const.ItemSlot.Offhand;
  this.m.ItemType=this.Const.Items.ItemType.Weapon|this.Const.Items.ItemType.MeleeWeapon|this.Const.Items.ItemType.TwoHanded|this.Const.Items.ItemType.Legendary;
  this.m.Value=6000;this.m.Condition=100.0;this.m.ConditionMax=100.0;this.m.StaminaModifier=-4;
  this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.AddGenericSkill=true;
  this.updateVariant();
 },
 function updateVariant()
 {
  this.m.Icon="$bvvar{iconPrefix}/rachel_nago_parasol.png";this.m.IconLarge="$bvvar{iconPrefix}/rachel_nago_parasol_large.png";
  this.m.ShowArmamentIcon=true;this.m.ArmamentIcon="icon_bv_rachel_nago_parasol";
 },
 function onEquip(){this.weapon.onEquip();::$bvvar{namespace}.RachelEquipment.sync(this.getContainer().getActor());},
 function onUnequip()
 {
  local a=this.getContainer().getActor(),e=::$bvvar{namespace}.RachelEquipment;
  ::$bvvar{namespace}.detachTransientSkill(a,e.SkillKey,e.SkillOwner);e.clearGuard(a);this.weapon.onUnequip();
 },
 function onUpdateProperties(p)
 {
  this.weapon.onUpdateProperties(p);
  if(::$bvvar{namespace}.Rachel.owns(this.getContainer().getActor()))
  {
   p.FatigueRecoveryRate+=3;p.MeleeDefense+=20;p.RangedDefense+=30;
  }
 },
 function onSerialize(out){this.weapon.onSerialize(out);out.writeU8(1);out.writeString(this.m.RachelOwner);},
 function onDeserialize(input)
 {
  this.weapon.onDeserialize(input);local version=input.readU8();
  if(version!=1)throw "[Battle Valkyries] Unsupported Rachel parasol schema: "+version;
  this.m.RachelOwner=input.readString();this.updateVariant();
 }
});
