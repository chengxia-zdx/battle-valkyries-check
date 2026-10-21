this.orbment_quartz_item <- this.inherit("scripts/items/item", {
 m = { BVOrbQuartz = true },
 function create()
 {
  this.item.create();this.m.SlotType=this.Const.ItemSlot.None;this.m.ItemType=this.Const.Items.ItemType.Crafting;
  this.m.IsAllowedInBag=false;this.m.IsDroppedAsLoot=true;this.m.Value=200;this.refresh();
 }
 function code() { return this.getFlags().has("BVQuartz")?this.getFlags().get("BVQuartz"):"rockheart:1"; }
 function configure(code)
 {
  if(::$bvvar{namespace}.Orbments.gem(code)==null)throw "Invalid quartz";
  this.getFlags().set("BVQuartz",code);this.refresh();return this;
 }
 function refresh()
 {
  local g=::$bvvar{namespace}.Orbments.gem(this.code());
  this.m.ID="$bvvar{modId}.quartz."+g.Key+"."+g.Rank;this.m.Name=g.Data.Name+(g.Rank==1?" I":" II");
  this.m.Icon=g.Data.Icon;this.m.IconLarge=g.Data.Icon;this.m.Value=g.Rank==1?200:700;
  this.m.Description="$bv{orbment.quartz.description}";
 }
 function getTooltip()
 {
  local out=this.item.getTooltip(),f=::$bvvar{namespace}.Orbments,g=f.gem(this.code());
  foreach(k,v in f.elements(g))out.push({id=70+out.len(),type="text",text=f.api().OrbmentElementNames[k]+" +"+v});
  local value=g.Rank==1?g.Data.Value1:g.Data.Value2,percent=["Damage","Pierce","Reduction"].find(g.Data.Bonus)!=null;
  out.push({id=90,type="text",text=f.api().OrbmentBonusNames[g.Data.Bonus]+" +"+(percent?::Math.round(value*100)+"%":value.tostring())});
  return out;
 }
 function onDeserialize(input) { this.item.onDeserialize(input);this.refresh(); }
});

