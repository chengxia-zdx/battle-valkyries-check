this.hu_tao_staff_of_homa <- this.inherit("scripts/items/weapons/pike", {
 m={HuTaoOwner="",HuTaoTier=0},
 function create()
 {
  this.pike.create();this.m.ID="$bvvar{modId}.weapon.hu_tao_staff_of_homa";this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Name="$bv{hu_tao.staff_of_homa.name}";this.m.Description="$bv{hu_tao.staff_of_homa.description}";this.m.Value=6000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;
  this.m.Condition=120.0;this.m.ConditionMax=120.0;this.m.StaminaModifier=-8;
  this.m.RegularDamage=85;this.m.RegularDamageMax=105;this.m.ArmorDamageMult=1.25;this.m.DirectDamageMult=0.35;this.m.IsDoubleGrippable=false;this.m.Categories="$bv{hu_tao.weapon.categories}";
  if("WeaponType" in ::Const.Items)this.m.WeaponType=::Const.Items.WeaponType.Polearm;
  this.updateVariant();
 },
 function updateVariant(){this.m.Icon="$bvvar{iconPrefix}/hu_tao_staff_of_homa.png";this.m.IconLarge="$bvvar{iconPrefix}/hu_tao_staff_of_homa.png";this.m.ShowArmamentIcon=true;this.m.ArmamentIcon="icon_bv_hu_tao_staff_of_homa";},
 function onEquip(){this.weapon.onEquip();},
 function setHuTaoTier(tier,repairDelta=true)
 {
  tier=::Math.max(this.m.HuTaoTier,::Math.min(2,tier));local before=this.m.ConditionMax;
  this.m.HuTaoTier=tier;this.m.ConditionMax=[120, 120, 150][tier].tofloat();
  if(repairDelta)this.m.Condition=::Math.min(this.m.ConditionMax,this.m.Condition+this.m.ConditionMax-before);
  this.m.RegularDamage=tier>=2?105:85;this.m.RegularDamageMax=tier>=2?125:105;
 },
 function onSerialize(out){this.weapon.onSerialize(out);out.writeU8(1);out.writeString(this.m.HuTaoOwner);out.writeU8(this.m.HuTaoTier);out.writeF32(this.m.Condition);},
 function onDeserialize(input)
 {
  this.weapon.onDeserialize(input);local version=input.readU8();if(version!=1)throw "[Battle Valkyries] Unsupported Hu Tao equipment schema: "+version;
  this.m.HuTaoOwner=input.readString();this.setHuTaoTier(input.readU8(),false);this.m.Condition=::Math.minf(this.m.ConditionMax,input.readF32());this.updateVariant();
 }
});
