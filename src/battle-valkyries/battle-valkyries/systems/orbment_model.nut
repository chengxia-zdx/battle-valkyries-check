// Pure circuit rules. Central sockets contribute to every line, but physical bonuses once.
::$bvvar{namespace}.Orbments <- {
 Busy = false, Session = null,
 function api() { return ::$bvvar{namespace}; },
 function blank() { return { Schema = 1, Slots = ["","","","","","",""], Active = [], Passive = [] }; },
 function copy(c) { return { Schema=1, Slots=clone c.Slots, Active=clone c.Active, Passive=clone c.Passive }; },
 function gem(code)
 {
  if (typeof code != "string") return null;
  local p = split(code, ":");
  if (p.len()!=2 || !(p[0] in this.api().OrbmentGems) || (p[1]!="1" && p[1]!="2")) return null;
  return {Key=p[0], Rank=p[1].tointeger(), Data=this.api().OrbmentGems[p[0]]};
 },
 function emptyElements() { local e={}; foreach(k in this.api().OrbmentElements)e[k]<-0;return e; },
 function addElements(dst, src) { foreach(k,v in src) dst[k]+=v; },
 function elements(g) { return g.Rank==1?g.Data.Elements1:g.Data.Elements2; },
 function validConfig(form,c)
 {
  if (!(form in this.api().OrbmentForms) || typeof c!="table" || !("Slots" in c) || !("Active" in c) || !("Passive" in c)) return false;
  if(typeof c.Slots!="array" || c.Slots.len()!=7 || typeof c.Active!="array" || typeof c.Passive!="array")return false;
  local counts={};
  foreach(code in c.Slots) {
   if(code=="")continue;local g=this.gem(code);if(g==null)return false;
   if(!(g.Key in counts))counts[g.Key]<-0;counts[g.Key]++;if(counts[g.Key]>2)return false;
  }
  local calc=this.calculate(form,c), seen={}, cost=0, shape=this.api().OrbmentForms[form];
  if(c.Active.len()>shape.ActiveSlots)return false;
  foreach(kind in ["Active","Passive"])foreach(key in c[kind]) {
   if(typeof key!="string" || key in seen || !(key in calc.Unlocked))return false;
   local r=this.api().OrbmentRecipes[key];
   if(r.Kind!=(kind=="Active"?"active":"passive"))return false;
   seen[key]<-true;if(kind=="Passive")cost+=r.Cost;
  }
  return cost<=shape.PassiveCapacity;
 },
 function calculate(form,c)
 {
  local lines=[],total=this.emptyElements(),unlocked={},bonus={};
  foreach(code in c.Slots) {
   local g=this.gem(code);if(g==null)continue;this.addElements(total,this.elements(g));
   local key=g.Data.Bonus,v=g.Rank==1?g.Data.Value1:g.Data.Value2;
   if(key=="Reduction") { if(!(key in bonus))bonus[key]<-1.0;bonus[key]*=1.0-v; }
   else { if(!(key in bonus))bonus[key]<-0;bonus[key]+=v; }
  }
  foreach(indices in this.api().OrbmentForms[form].Lines) {
   local e=this.emptyElements();
   foreach(i in indices){local g=this.gem(c.Slots[i]);if(g!=null)this.addElements(e,this.elements(g));}
   lines.push(e);
  }
  foreach(key,r in this.api().OrbmentRecipes)foreach(e in lines) {
   local ok=true;foreach(k,v in r.Requirements)if(e[k]<v)ok=false;
   if(ok)unlocked[key]<-true;
  }
  return {Lines=lines,Total=total,Unlocked=unlocked,Bonus=bonus};
 },
 function readItem(item)
 {
  local f=item.getFlags(),c=this.blank();
  for(local i=0;i<7;i++)if(f.has("BVOrbSlot"+i))c.Slots[i]=f.get("BVOrbSlot"+i);
  if(f.has("BVOrbActive"))c.Active=split(f.get("BVOrbActive"),",");
  if(f.has("BVOrbPassive"))c.Passive=split(f.get("BVOrbPassive"),",");
  return c;
 },
 function join(a) { local s="";foreach(i,v in a){if(i>0)s+=",";s+=v;}
 return s; },
 function writeItem(item,c)
 {
  if(!this.validConfig(item.form(),c))throw "Invalid orbment configuration";
  local f=item.getFlags();f.set("BVOrbSchema",1);
  for(local i=0;i<7;i++)f.set("BVOrbSlot"+i,c.Slots[i]);
  f.set("BVOrbActive",this.join(c.Active));f.set("BVOrbPassive",this.join(c.Passive));
 },
 function uid(item)
 {
  local f=item.getFlags();if(f.has("BVOrbUID"))return f.get("BVOrbUID");
  local key="$bvvar{modId}.orbment.serial",n=::World.Flags.has(key)?::World.Flags.get(key):0;
  n++;::World.Flags.set(key,n);local id="orbment:"+n;f.set("BVOrbUID",id);return id;
 },
 function revision(item) { return item.getFlags().has("BVOrbRevision")?item.getFlags().get("BVOrbRevision"):0; },
 function item(a)
 {
  if(a==null || a.getItems()==null)return null;local it=a.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
  return it!=null && "BVOrbment" in it.m && it.m.BVOrbment?it:null;
 },
 function total(a) { local it=this.item(a);return it==null?this.emptyElements():this.calculate(it.form(),this.readItem(it)).Total; },
 function bonuses(a)
 {
  local it=this.item(a);if(it==null)return {};
  local c=this.readItem(it),b=this.calculate(it.form(),c).Bonus;
  foreach(key in c.Passive)if(key in this.api().OrbmentRecipes)foreach(k,v in this.api().OrbmentRecipes[key].Bonus) {
   if(k=="Reduction"){if(!(k in b))b[k]<-1.0;b[k]*=1.0-v;}
   else if(k=="FatigueMult"){if(!(k in b))b[k]<-1.0;b[k]*=v;}
   else {if(!(k in b))b[k]<-0;b[k]+=v;}
  }
  return b;
 },
 function attach(a,it)
 {
  if(a==null || this.item(a)!=it)return;
  local c=this.readItem(it),keys=["orbment_socket_bonus"],owner=this.uid(it);
  keys.extend(c.Active);keys.extend(c.Passive);
  local attached=[];
  foreach(key in keys) {
   local result=this.api().attachTransientSkill(a,key,owner);
   if(!result.Success){foreach(k in attached)this.api().detachTransientSkill(a,k,owner);throw "Orbment attach: "+result.Code;}
   if(result.Code!="already_attached")attached.push(key);
  }
 },
 function detach(a,it)
 {
  if(a==null)return;local c=this.readItem(it),keys=["orbment_socket_bonus"],owner=this.uid(it);
  keys.extend(c.Active);keys.extend(c.Passive);
  foreach(key in keys){local r=this.api().detachTransientSkill(a,key,owner);if(!r.Success && r.Code!="owner_not_found")this.api().logValkyrieSkillFailure(a,key,r.Code,"orbment.detach");}
 }
};

