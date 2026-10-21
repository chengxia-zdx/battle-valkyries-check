local f=::$bvvar{namespace}.Orbments;
f.stash <- function() { return ::World.Assets.getStash(); };
f.safe <- function()
{
 try { return ::World!=null && ::World.Assets!=null && !::Tactical.isActive(); } catch(e) { return false; }
};
f.error <- function(code) { return {Success=false,Code=code,Message=code in this.api().OrbmentErrors?this.api().OrbmentErrors[code]:this.api().OrbmentErrors.invalid}; };
f.find <- function(instance)
{
 foreach(it in this.stash().getItems())if(it!=null && it.getInstanceID()==instance && "BVOrbment" in it.m && it.m.BVOrbment)return it;
 return null;
};
f.signature <- function()
{
 local rows=[];foreach(it in this.stash().getItems())if(it!=null)rows.push(it.getInstanceID().tostring());rows.sort();
 return this.join(rows);
};
f.balance <- function() { local k="$bvvar{modId}.orbment.sand";return ::World.Flags.has(k)?::World.Flags.get(k):0; };
f.setBalance <- function(value) { ::World.Flags.set("$bvvar{modId}.orbment.sand",value); };
f.quartz <- function(code) { return ::new("scripts/items/misc/battle_valkyries/orbment_quartz_item").configure(code); };
f.inventory <- function()
{
 local out={};foreach(it in this.stash().getItems())if(it!=null && "BVOrbQuartz" in it.m && it.m.BVOrbQuartz) {
  local code=it.code();if(!(code in out))out[code]<-[];out[code].push(it);
 }
 return out;
};
f.countSlots <- function(c) { local out={};foreach(code in c.Slots)if(code!=""){if(!(code in out))out[code]<-0;out[code]++;}
 return out; };
f.open <- function(instance)
{
 if(!this.safe() || this.Busy)return this.error("unavailable");
 local it=this.find(instance);if(it==null)return this.error("missing");
 this.Session={UID=this.uid(it),Instance=instance,Revision=this.revision(it),Inventory=this.signature()};
 return this.dto(it,this.readItem(it));
};
f.current <- function(data)
{
 if(!this.safe() || this.Session==null || typeof data!="table" || !("UID" in data) || !("Revision" in data))return null;
 local it=this.find(this.Session.Instance);
 if(it==null || this.uid(it)!=data.UID || data.UID!=this.Session.UID || data.Revision!=this.Session.Revision
  || this.revision(it)!=data.Revision || this.signature()!=this.Session.Inventory)return null;
 return it;
};
f.dto <- function(it,c)
{
 local shape=this.api().OrbmentForms[it.form()],calc=this.calculate(it.form(),c),inventory=this.inventory(),available={},rows=[],skills=[];
 foreach(code,items in inventory)available[code]<-items.len();
 foreach(code,n in this.countSlots(this.readItem(it))){if(!(code in available))available[code]<-0;available[code]+=n;}
 foreach(code,n in this.countSlots(c)){if(!(code in available))available[code]<-0;available[code]-=n;}
 foreach(key in this.api().OrbmentGemOrder)for(local rank=1;rank<=2;rank++) {
  local g=this.api().OrbmentGems[key];
  local code=key+":"+rank;
  rows.push({Code=code,Key=key,Rank=rank,Name=g.Name+(rank==1?" I":" II"),Icon="ui/items/"+g.Icon,Count=code in available?available[code]:0,
   Elements=rank==1?g.Elements1:g.Elements2,Bonus=this.api().OrbmentBonusNames[g.Bonus],Percent=["Damage","Pierce","Reduction"].find(g.Bonus)!=null,Value=rank==1?g.Value1:g.Value2});
 }
 local cost=0;
 foreach(key in this.api().OrbmentRecipeOrder) {
  local r=this.api().OrbmentRecipes[key];
  local missing=[];foreach(line in calc.Lines){local need={};foreach(k,v in r.Requirements)if(line[k]<v)need[k]<-v-line[k];missing.push(need);}
  local selected=(r.Kind=="active"?c.Active:c.Passive).find(key)!=null;if(selected && r.Kind=="passive")cost+=r.Cost;
  skills.push({Key=key,Name=r.Name,Description=r.Description,Icon="skills/$bvvar{iconPrefix}/"+key+".png",Kind=r.Kind,Cost=r.Cost,
   Unlocked=key in calc.Unlocked,Selected=selected,Missing=missing});
 }
 return {Success=true,UID=this.uid(it),Instance=it.getInstanceID(),Revision=this.revision(it),Form=it.form(),Name=shape.Name,
  Lines=shape.Lines,LineTotals=calc.Lines,Total=calc.Total,Bonuses=calc.Bonus,Config=this.copy(c),Gems=rows,Skills=skills,
  ActiveSlots=shape.ActiveSlots,PassiveCapacity=shape.PassiveCapacity,PassiveUsed=cost,Sand=this.balance(),Money=::World.Assets.getMoney(),
  UpgradeUnlocked=this.api().Chapters.completed("septium_workshop")>=8,Elements=this.api().OrbmentElementNames,ElementOrder=this.api().OrbmentElements,
  Labels=this.api().OrbmentLabels,Templates=this.templates(),CanSave=this.validConfig(it.form(),c)};
};
f.preview <- function(data)
{
 local it=this.current(data);if(it==null)return this.error("stale");
 if(!("Config" in data))return this.error("config");
 local c=data.Config;
 // A socket edit may invalidate prepared skills; prune only those, never invent selections.
 if(typeof c!="table" || !("Slots" in c) || !("Active" in c) || !("Passive" in c) || typeof c.Slots!="array" || c.Slots.len()!=7 || typeof c.Active!="array" || typeof c.Passive!="array")return this.error("config");
 local slotsOnly=this.blank();slotsOnly.Slots=clone c.Slots;
 if(!this.validConfig(it.form(),slotsOnly))return this.error("config");
 local unlocked=this.calculate(it.form(),slotsOnly).Unlocked;c=this.copy(c);
 foreach(kind in ["Active","Passive"])for(local i=c[kind].len()-1;i>=0;i--)if(!(c[kind][i] in unlocked))c[kind].remove(i);
 if(!this.validConfig(it.form(),c))return this.error("config");
 local result=this.dto(it,c);foreach(g in result.Gems)if(g.Count<0)result.CanSave=false;
 return result;
};
// The stash and configuration commit together; failed inserts restore their exact slots.
f.exchange <- function(it,c,remove,add,crowns=0,sand=0)
{
 if(this.Busy)return this.error("stale");
 local stash=this.stash(),space=stash.getNumberOfEmptySlots()+remove.len()-add.len();
 if(!stash.isResizable() && space<0)return this.error("space");
 if(::World.Assets.getMoney()<crowns || this.balance()<sand)return this.error("funds");
 local old=this.readItem(it),revision=this.revision(it),money=::World.Assets.getMoney(),balance=this.balance(),removed=[],added=[],snapshot=clone stash.getItems();
 // All output objects exist before any input is consumed.
 this.Busy=true;
 try {
  foreach(obj in remove) {
   local idx=stash.getItems().find(obj);if(idx==null)throw "Stale input";
   if(stash.remove(obj)==null)throw "Cannot remove input";removed.push({Item=obj,Index=idx});
  }
  foreach(obj in add) {local index=stash.add(obj);if(index==null)throw "Cannot insert output";added.push(obj);}
  if(c!=null)this.writeItem(it,c);
  ::World.Assets.setMoney(money-crowns);this.setBalance(balance-sand);
  it.getFlags().set("BVOrbRevision",revision+1);
 } catch(e) {
  foreach(obj in added)stash.remove(obj);
  local items=stash.getItems();items.clear();items.extend(snapshot);
  this.writeItem(it,old);it.getFlags().set("BVOrbRevision",revision);
  ::World.Assets.setMoney(money);this.setBalance(balance);this.Busy=false;
  ::logError("[Battle Valkyries] Orbment transaction rolled back: "+e);return this.error("unavailable");
 }
 this.Busy=false;this.Session.Revision=this.revision(it);this.Session.Inventory=this.signature();
 try {::World.State.updateTopbarAssets();}catch(e){}
 return this.dto(it,this.readItem(it));
};
f.save <- function(data)
{
 local it=this.current(data);if(it==null)return this.error("stale");
 if(!("Config" in data) || !this.validConfig(it.form(),data.Config))return this.error("config");
 local before=this.countSlots(this.readItem(it)),after=this.countSlots(data.Config),inv=this.inventory(),remove=[],add=[],codes={};
 foreach(code,n in before)codes[code]<-true;foreach(code,n in after)codes[code]<-true;
 foreach(code,unused in codes) {
  local difference=(code in after?after[code]:0)-(code in before?before[code]:0);
  if(difference>0){if(!(code in inv) || inv[code].len()<difference)return this.error("quartz");for(local i=0;i<difference;i++)remove.push(inv[code][i]);}
  else for(local i=0;i< -difference;i++)add.push(this.quartz(code));
 }
 return this.exchange(it,data.Config,remove,add);
};
f.processGem <- function(data)
{
 local it=this.current(data);if(it==null)return this.error("stale");
 if(this.api().Chapters.completed("septium_workshop")<8)return this.error("locked");
 if(!("Code" in data))return this.error("invalid");
 local g=this.gem(data.Code),inv=this.inventory();if(g==null || !(data.Code in inv))return this.error("quartz");
 if(data.Action=="upgrade") {
  if(g.Rank!=1 || inv[data.Code].len()<2)return this.error("quartz");
  return this.exchange(it,null,[inv[data.Code][0],inv[data.Code][1]],[this.quartz(g.Key+":2")],300,10);
 }
 if(data.Action=="recycle")return this.exchange(it,null,[inv[data.Code][0]],[],0,g.Rank==1?-2:-6);
 return this.error("invalid");
};
f.templates <- function()
{
 local rows=[];
 for(local i=0;i<8;i++) {
  local prefix="$bvvar{modId}.orbment.template."+i+".";
  if(!::World.Flags.has(prefix+"form"))continue;
  local c=this.blank();for(local s=0;s<7;s++)c.Slots[s]=::World.Flags.get(prefix+"slot"+s);
  c.Active=split(::World.Flags.get(prefix+"active"),",");c.Passive=split(::World.Flags.get(prefix+"passive"),",");
  rows.push({Index=i,Name=::World.Flags.get(prefix+"name"),Form=::World.Flags.get(prefix+"form"),Config=c});
 }
 return rows;
};
f.saveTemplate <- function(data)
{
 local it=this.current(data);if(it==null)return this.error("stale");
 if(!("Index" in data) || typeof data.Index!="integer" || data.Index<0 || data.Index>=8 || !("Name" in data)
  || typeof data.Name!="string" || data.Name.len()==0 || data.Name.len()>80 || !("Config" in data) || !this.validConfig(it.form(),data.Config))return this.error("config");
 local prefix="$bvvar{modId}.orbment.template."+data.Index+".",c=data.Config,flags=::World.Flags;
 flags.set(prefix+"name",data.Name);for(local i=0;i<7;i++)flags.set(prefix+"slot"+i,c.Slots[i]);
 flags.set(prefix+"active",this.join(c.Active));flags.set(prefix+"passive",this.join(c.Passive));flags.set(prefix+"form",it.form());
 return this.dto(it,c);
};
f.request <- function(data)
{
 if(typeof data!="table" || !("Action" in data) || this.Busy)return this.error("invalid");
 if(data.Action=="close"){this.Session=null;return {Success=true};}
 if(data.Action=="open" && "Instance" in data)return this.open(data.Instance);
 if(data.Action=="preview")return this.preview(data);
 if(data.Action=="save")return this.save(data);
 if(data.Action=="template")return this.saveTemplate(data);
 if(data.Action=="upgrade" || data.Action=="recycle")return this.processGem(data);
 return this.error("invalid");
};

