this.es_murakumo <- this.inherit("scripts/items/weapons/greatsword", {
 m={EsOwner=""},
 function create()
 {
  this.greatsword.create();this.m.ID="$bvvar{modId}.weapon.es_murakumo";
  this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
  this.m.Name="$bv{es.weapon.name}";this.m.Description="$bv{es.weapon.description}";
  this.m.Value=6000;this.m.Condition=120.0;this.m.ConditionMax=120.0;this.m.StaminaModifier=-8;
  this.m.RegularDamage=85;this.m.RegularDamageMax=105;this.m.ArmorDamageMult=1.3;this.m.DirectDamageMult=0.25;
  this.m.Categories="$bv{item.saber_oath_excalibur.categories}";
  if("WeaponType" in ::Const.Items)this.m.WeaponType=::Const.Items.WeaponType.Sword;
  // generic_item carries weapon stats; it is passive and creates no attack button.
  this.m.IsUnique=true;this.m.AddGenericSkill=true;this.updateVariant();
 },
 function updateVariant(){this.m.Icon="$bvvar{iconPrefix}/es_murakumo.png";this.m.IconLarge="$bvvar{iconPrefix}/es_murakumo_large.png";this.m.ShowArmamentIcon=true;this.m.ArmamentIcon="icon_bv_es_murakumo";},
 // Use the weapon base to retain native appearance/equipment hooks without greatsword buttons.
 function onEquip(){this.weapon.onEquip();},
 function getEsCrestBonus(){return 0.5;},
 function onSerialize(out){this.weapon.onSerialize(out);out.writeString(this.m.EsOwner);},
 function onDeserialize(input){this.weapon.onDeserialize(input);this.m.EsOwner=input.readString();this.updateVariant();}
});
