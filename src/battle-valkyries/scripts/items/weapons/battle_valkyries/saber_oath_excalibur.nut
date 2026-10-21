this.saber_oath_excalibur <- this.inherit("scripts/items/weapons/greatsword", {
 function create()
 {
  this.greatsword.create();
  this.m.ID="$bvvar{modId}.weapon.saber_oath_excalibur";
  this.m.Name="$bv{item.saber_oath_excalibur.name}";
  this.m.Description="$bv{item.saber_oath_excalibur.description}";
  this.m.Categories="$bv{item.saber_oath_excalibur.categories}";
  this.updateVariant();
  this.m.Value=6000; this.m.Condition=120.0; this.m.ConditionMax=120.0;
  this.m.StaminaModifier=-12; this.m.RegularDamage=80; this.m.RegularDamageMax=100;
  this.m.ArmorDamageMult=1.3; this.m.DirectDamageMult=0.25;
  this.m.IsUnique=true;
 }
 function updateVariant()
 {
  // Native item deserialization calls this after reading Variant. Keep the
  // signature visuals instead of inheriting Legends' greatsword variants.
  this.m.Icon="$bvvar{iconPrefix}/saber_oath_excalibur.png";
  this.m.IconLarge="$bvvar{iconPrefix}/saber_oath_excalibur_large.png";
  this.m.ShowArmamentIcon=true;
  this.m.ArmamentIcon="icon_bv_saber_oath_excalibur";
 }
 function getTooltip()
 {
  local ret=this.greatsword.getTooltip();
  ret.push({id=90,type="text",icon="ui/icons/special.png",text="$bv{item.saber_oath_excalibur.rules}"});
  return ret;
 }
});
