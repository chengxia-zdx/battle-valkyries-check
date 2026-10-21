this.orbment_item <- this.inherit("scripts/items/accessory/accessory", {
 m = { BVOrbment = true },
 function create()
 {
  this.accessory.create();this.m.IsChangeableInBattle=false;this.m.ID="$bvvar{modId}.accessory.orbment";
  this.m.Description="$bv{orbment.item.description}";this.m.Value=3500;
  this.m.IsAllowedInBag=true;this.m.ShowOnCharacter=false;this.m.AddGenericSkill=false;this.m.IsDroppedAsLoot=true;
  this.refresh();
 }
 function form() { return this.getFlags().has("BVOrbForm")?this.getFlags().get("BVOrbForm"):"starrail"; }
 function configure(form)
 {
  if(!(form in ::$bvvar{namespace}.OrbmentForms))throw "Unknown orbment form";
  this.getFlags().set("BVOrbForm",form);this.refresh();return this;
 }
 function refresh()
 {
  local d=::$bvvar{namespace}.OrbmentForms[this.form()];
  this.m.Name=d.Name;this.m.Icon=d.Icon;this.m.IconLarge=d.Icon;
 }
 function getTooltip()
 {
  local out=this.accessory.getTooltip(),f=::$bvvar{namespace}.Orbments,c=f.readItem(this),d=f.api().OrbmentForms[this.form()];
  out.push({id=66,type="text",icon="ui/icons/special.png",text="$bv{orbment.item.configure}"});
  out.push({id=67,type="text",icon="ui/icons/special.png",text="$bv{orbment.ui.active} "+c.Active.len()+"/"+d.ActiveSlots+" | $bv{orbment.ui.capacity} "+d.PassiveCapacity});
  foreach(key in c.Active)out.push({id=70+out.len(),type="text",text=f.api().OrbmentRecipes[key].Name});
  foreach(key in c.Passive)out.push({id=70+out.len(),type="text",text=f.api().OrbmentRecipes[key].Name});
  return out;
 }
 function onEquip()
 {
  this.accessory.onEquip();local a=this.getContainer().getActor();::$bvvar{namespace}.Orbments.attach(a,this);
 }
 function onUnequip()
 {
  local c=this.getContainer();if(c!=null)::$bvvar{namespace}.Orbments.detach(c.getActor(),this);this.accessory.onUnequip();
 }
 function onDeserialize(input) { this.accessory.onDeserialize(input);this.refresh(); }
});

