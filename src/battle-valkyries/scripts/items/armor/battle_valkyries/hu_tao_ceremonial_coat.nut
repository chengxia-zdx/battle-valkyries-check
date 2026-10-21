this.hu_tao_ceremonial_coat <- this.inherit("scripts/items/armor/armor", {
 m={HuTaoOwner="",HuTaoTier=0},
 function create()
 {
  this.armor.create();this.m.ID="$bvvar{modId}.armor.hu_tao_ceremonial_coat";this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Name="$bv{hu_tao.ceremonial_coat.name}";this.m.Description="$bv{hu_tao.ceremonial_coat.description}";this.m.Value=6000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;
  this.m.Condition=120.0;this.m.ConditionMax=120.0;this.m.StaminaModifier=-8;
  this.m.Variant=80;
  this.updateVariant();
 },
 function updateVariant(){this.armor.updateVariant();this.m.Icon="$bvvar{iconPrefix}/hu_tao_ceremonial_coat.png";this.m.IconLarge="$bvvar{iconPrefix}/hu_tao_ceremonial_coat_large.png";},
 function setHuTaoTier(tier,repairDelta=true)
 {
  tier=::Math.max(this.m.HuTaoTier,::Math.min(2,tier));local before=this.m.ConditionMax;
  this.m.HuTaoTier=tier;this.m.ConditionMax=[120, 260, 320][tier].tofloat();
  if(this.m.Upgrade!=null){this.m.ConditionMax+=this.m.Upgrade.m.ConditionModifier;this.m.Upgrade.m.PreviousCondition=[120,260,320][tier];}
  if(repairDelta)this.m.Condition=::Math.min(this.m.ConditionMax,this.m.Condition+this.m.ConditionMax-before);
 },
 function onSerialize(out){this.armor.onSerialize(out);out.writeU8(1);out.writeString(this.m.HuTaoOwner);out.writeU8(this.m.HuTaoTier);out.writeF32(this.m.Condition);},
 function onDeserialize(input)
 {
  this.armor.onDeserialize(input);local version=input.readU8();if(version!=1)throw "[Battle Valkyries] Unsupported Hu Tao equipment schema: "+version;
  this.m.HuTaoOwner=input.readString();this.setHuTaoTier(input.readU8(),false);this.m.Condition=::Math.minf(this.m.ConditionMax,input.readF32());this.updateVariant();
 }
});
