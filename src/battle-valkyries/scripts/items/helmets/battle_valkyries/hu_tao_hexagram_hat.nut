this.hu_tao_hexagram_hat <- this.inherit("scripts/items/helmets/helmet", {
 m={HuTaoOwner="",HuTaoTier=0},
 function create()
 {
  this.helmet.create();this.m.ID="$bvvar{modId}.helmet.hu_tao_hexagram_hat";this.m.ItemType=this.m.ItemType|this.Const.Items.ItemType.Legendary;
  this.m.Name="$bv{hu_tao.hexagram_hat.name}";this.m.Description="$bv{hu_tao.hexagram_hat.description}";this.m.Value=6000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;
  this.m.Condition=80.0;this.m.ConditionMax=80.0;this.m.StaminaModifier=-3;
  this.m.Variant=84;
  this.updateVariant();
 },
 function updateVariant(){this.helmet.updateVariant();this.m.Icon="$bvvar{iconPrefix}/hu_tao_hexagram_hat.png";this.m.IconLarge="$bvvar{iconPrefix}/hu_tao_hexagram_hat.png";},
 function setHuTaoTier(tier,repairDelta=true)
 {
  tier=::Math.max(this.m.HuTaoTier,::Math.min(2,tier));local before=this.m.ConditionMax;
  this.m.HuTaoTier=tier;this.m.ConditionMax=[80, 220, 280][tier].tofloat();
  if(repairDelta)this.m.Condition=::Math.min(this.m.ConditionMax,this.m.Condition+this.m.ConditionMax-before);
 },
 function onSerialize(out){this.helmet.onSerialize(out);out.writeU8(1);out.writeString(this.m.HuTaoOwner);out.writeU8(this.m.HuTaoTier);out.writeF32(this.m.Condition);},
 function onDeserialize(input)
 {
  this.helmet.onDeserialize(input);local version=input.readU8();if(version!=1)throw "[Battle Valkyries] Unsupported Hu Tao equipment schema: "+version;
  this.m.HuTaoOwner=input.readString();this.setHuTaoTier(input.readU8(),false);this.m.Condition=::Math.minf(this.m.ConditionMax,input.readF32());this.updateVariant();
 }
});
