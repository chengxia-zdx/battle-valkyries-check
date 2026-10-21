// World-map alchemy extension. All eligibility, preview values and costs are authoritative.
::$bvvar{namespace}.RyzaTransmutation <- {
 function api() { return ::$bvvar{namespace}; },
 function al() { return this.api().RyzaAlchemy; },
 function now() { return ::Time.getVirtualTimeF() / ::World.getTime().SecondsPerDay; },
 function flag(key) { return "$bvvar{modId}.ryza.augment." + key; },
 function has(a, key) { return a != null && a.getFlags().get(this.flag(key)) == true; },
 function keys(a) { local out=[]; foreach(k in this.api().RyzaAugmentOrder) if(this.has(a,k)) out.push(k); return out; },
 function remaining(a)
 {
  // Native flags return false when absent; only a numeric cutoff is a cooldown.
  local v=a.getFlags().get(this.flag("until"));
  if(typeof v!="integer" && typeof v!="float") return 0.0;
  return ::Math.maxf(0.0,v-this.now());
 },
 function actor(id) { if(typeof id!="integer") return null; foreach(a in ::World.getPlayerRoster().getAll()) if(a.getID()==id) return a; return null; },
 function reason(a, donor=false)
 {
  if(a==null || !("getLevel" in a) || this.api().isActorDeadOrDying(a) || a.isPlacedOnMap()) return "$bv{ryza.ext.unavailable}";
  if(("isGuest" in a && a.isGuest()) || a.getFlags().get("IsPlayerCharacter")==true || ("isDismissable" in a && !a.isDismissable()) || ("isDismissible" in a && !a.isDismissible())) return "$bv{ryza.ext.protected}";
  if(donor && this.api().getActorValkyrieID(a)!=null) return "$bv{ryza.ext.protected}";
  return "";
 },
 function intrinsic(a)
 {
  local p=a.getBaseProperties().getClone();
  // Native character traits have stable trait.* IDs. Never run perks, potions,
  // injuries, equipment or our aggregate trait on the donor-property copy.
  foreach(s in a.getSkills().getAllSkillsOfType(::Const.SkillType.Trait))
  { local id=s.getID(); if(id.len()>6 && id.slice(0,6)=="trait." && id!="trait.player") s.onUpdate(p); }
  return { HP=p.Hitpoints,Stamina=p.Stamina,Bravery=p.Bravery,Initiative=p.Initiative,MeleeSkill=p.MeleeSkill,RangedSkill=p.RangedSkill,MeleeDefense=p.MeleeDefense,RangedDefense=p.RangedDefense };
 },
 function inheritance(a, d)
 {
  local values=this.intrinsic(a), bonus={}, rows=[];
  foreach(k in d.Inherits)
  {
   local bands=this.api().RyzaInheritanceBands[k], value=values[k], gain=bands[0][1], next=null;
   foreach(b in bands) { if(value>=b[0]) gain=b[1]; else { next=b; break; } }
   bonus[k] <- gain; rows.push({Key=k,Name=this.api().RyzaInheritanceNames[k],Value=value,Bonus=gain,Next=next==null?null:next[0],NextBonus=next==null?null:next[1]});
  }
  return {Bonus=bonus,Rows=rows};
 },
 function gear(a)
 {
  local out=[]; foreach(slot,items in a.getItems().getData()) foreach(index,i in items)
   if(i!=null && i!=-1) out.push({Item=i,Slot=slot,Index=index,Equipped=i.isEquipped()});
  return out;
 },
 function traitRecipes()
 {
  local out=[]; foreach(k in this.api().RyzaAugmentOrder)
  {
   local d=this.api().RyzaAugments[k], r=clone d; r.Materials=[]; foreach(m in d.Materials) r.Materials.push(clone m);
   r.ID="augment_"+k; r.Key<-k; r.Kind<-"augment"; r.Role<-d.Core?"core":"trait"; r.RoleName<-d.Core?"$bv{ryza.ext.core}":"$bv{ryza.ext.augments}";
   r.Route<-"augment"; r.Slots<-[{Species=d.Species,Tier=d.Tier,Name=this.api().RyzaPets[d.Species].Name+" T"+d.Tier}];
   r.Icon<-"ui/items/$bvvar{iconPrefix}/ryza_pets/"+d.Species+".png"; out.push(r);
  }
  return out;
 },
 function traitReason(a, r)
 {
  local reason=this.reason(a); if(reason!="") return reason;
  if(this.has(a,r.Key)) return "$bv{ryza.ext.owned}";
  if(this.remaining(a)>0) return "$bv{ryza.ext.cooldown}"+::Math.ceil(this.remaining(a)*24)+" $bv{ryza.ext.hours}";
  local keys=this.keys(a); if(keys.len()>=6) return "$bv{ryza.ext.full}";
  if(r.Core) foreach(k in keys) if(this.api().RyzaAugments[k].Core) return "$bv{ryza.ext.core_full}";
  return "";
 },
 function augmentDTO(data)
 {
  data.Brothers <- []; data.TraitRecipes <- this.traitRecipes(); local counts={};
  foreach(i in ::World.Assets.getStash().getItems()) if(i!=null) { local id=i.getID(); counts[id]<-(id in counts?counts[id]:0)+1; }
  foreach(r in data.TraitRecipes)
  {
   local ready=data.Editable && data.Money>=r.Cost, found=false;
   foreach(i in data.Items) if(i.Available && i.Species==r.Species && i.Tier==r.Tier) found=true;
   r.Slots[0].Available<-found; if(!found) ready=false;
   foreach(m in r.Materials) { local d=this.api().RyzaMaterials[m.Key]; m.Name<-d.Name; m.Icon<-d.Icon; m.Have<-d.ID in counts?counts[d.ID]:0; if(m.Have<m.Count) ready=false; }
   r.Ready<-ready;
  }
  foreach(a in ::World.getPlayerRoster().getAll())
  {
   if(!("getLevel" in a)) continue;
   local reason=this.reason(a), donorReason=this.reason(a,true), owned=[], choices={}, inherits={};
   foreach(k in this.keys(a)) { local d=this.api().RyzaAugments[k]; owned.push({ID=k,Name=d.Name,Description=d.Description,Core=d.Core,Icon="ui/items/$bvvar{iconPrefix}/ryza_pets/"+d.Species+".png"}); }
   foreach(r in data.TraitRecipes) choices[r.ID]<-this.traitReason(a,r);
   if(donorReason=="") foreach(id in this.api().RyzaFusionOrder) inherits[id]<-this.inheritance(a,this.api().RyzaPets[id]);
   local returned=[]; if(donorReason=="") foreach(g in this.gear(a)) returned.push(g.Item.getName());
   data.Brothers.push({ID=a.getID(),Name=a.getName(),Portrait=("getImagePath" in a?a.getImagePath():""),Level=a.getLevel(),Available=reason=="",Reason=reason,DonorAvailable=donorReason=="",DonorReason=donorReason,Traits=owned,RemainingHours=::Math.ceil(this.remaining(a)*24),Choices=choices,Inheritance=inherits,Gear=returned});
  }
  foreach(r in data.Recipes) if("Brother" in r && r.Brother)
  {
   r.Candidates <- []; local any=false;
   foreach(a in data.Brothers) if(a.DonorAvailable) { any=true; local inherit=a.Inheritance[r.Species], sample=this.sample(r,null,inherit.Bonus); r.Candidates.push({ID=a.ID,Name=a.Name,Level=a.Level,Rows=inherit.Rows,Stats=this.al().stats(sample)}); }
   if(!any) r.Ready=false;
  }
  return data;
 },
 function prepare(p, request)
 {
  if(!p.Success) return p;
  local r=p.Recipe; p.Actor<-null; p.Gear<-[]; p.Bonus<-{}; p.Rows<-[]; p.DonorName<-"";
  if("Kind" in r && r.Kind=="augment")
  {
   local a="Actor" in request?this.actor(request.Actor):null, reason=this.traitReason(a,r); if(reason!="") return this.al().fail(reason);
   p.Actor=a; p.Signature+="|recipient:"+a.getID()+":"+a.getName()+":"+a.getLevel();
   foreach(k in this.keys(a)) p.Signature+=":"+k;
  }
  else if("Brother" in r && r.Brother)
  {
   local a="Actor" in request?this.actor(request.Actor):null, reason=this.reason(a,true); if(reason!="") return this.al().fail(reason);
   local inherit=this.inheritance(a,this.api().RyzaPets[r.Species]); p.Actor=a; p.Bonus=inherit.Bonus; p.Rows=inherit.Rows; p.DonorName=a.getName(); p.Gear=this.gear(a);
   p.Signature+="|donor:"+a.getID()+":"+a.getName()+":"+a.getLevel();
   foreach(row in p.Rows) p.Signature+="|"+row.Key+":"+row.Value+":"+row.Bonus;
   foreach(g in p.Gear) p.Signature+="|gear:"+g.Item.getInstanceID()+":"+g.Slot+":"+g.Index+":"+g.Item.getName();
   if(::World.Assets.getStash().getNumberOfEmptySlots()+p.Consumed.len()<p.Gear.len()+1) return this.al().fail("$bv{ryza.ext.space}");
  }
  else if(this.al().custom(p.Main))
  { p.Bonus=clone p.Main.m.Inherited; p.DonorName=p.Main.m.DonorName; }
  if(this.al().custom(p.Main)) { p.Signature+="|"+p.Main.m.DonorName; foreach(k in this.api().RyzaInheritanceKeys) if(k in p.Main.m.Inherited) p.Signature+="|"+k+":"+p.Main.m.Inherited[k]; }
  return p;
 },
 function sample(r, main=null, bonus=null)
 {
  local custom=this.al().custom(main);
  return {m={Species=r.Species,Tier=r.Tier,Focus=custom?main.m.Focus:"",Rank=custom?main.m.Rank:0,Inherited=bonus==null?{}:bonus}};
 },
 function preview(p, token)
 {
  local r=p.Recipe, trait="Kind" in r && r.Kind=="augment", materials=[], gear=[];
  foreach(m in r.Materials) materials.push(this.api().RyzaMaterials[m.Key].Name+" ×"+m.Count);
  foreach(g in p.Gear) gear.push(g.Item.getName());
  return {Success=true,Token=token,Kind=trait?"augment":"pet",Name=r.Name+(trait?"":" T"+r.Tier),Cost=r.Cost,Names=p.Names,Materials=materials,
   Stats=trait?null:this.al().stats(this.sample(r,p.Main,p.Bonus)),Message=trait?"$bv{ryza.ext.trait_confirm}":"$bv{ryza.alchemy.confirm}",ActorName=p.Actor==null?"":p.Actor.getName(),ActorLevel=p.Actor==null?0:p.Actor.getLevel(),ActorPortrait=p.Actor!=null && "getImagePath" in p.Actor?p.Actor.getImagePath():"",
   ConsumeBrother=!trait && p.Actor!=null,ReturnedGear=gear,Inheritance=p.Rows,Description=r.Description,Days=trait?r.Days:0};
 },
 function commit(p)
 {
  local al=this.al(), r=p.Recipe, trait="Kind" in r && r.Kind=="augment", result=null, effect=null, a=p.Actor;
  // Build the output before any mutation.
  if(!trait)
  {
   result=::new("scripts/items/accessory/battle_valkyries/ryza_pet_item"); local main=p.Main;
   result.configure(r.Species,r.Tier,al.custom(main)?main.m.PetName:main.getName());
   if(al.custom(main)) {result.m.Rank=main.m.Rank;result.m.Focus=main.m.Focus;result.m.HP=main.m.HP;result.m.Body=main.m.Body;result.m.Head=main.m.Head;}
   result.m.Inherited=clone p.Bonus; result.m.DonorName=p.DonorName;
  }
  else if(!a.getSkills().hasSkill("$bvvar{modId}.trait.ryza_augmentation")) effect=::new("scripts/skills/traits/battle_valkyries/ryza_augmentation_trait");
  local stash=::World.Assets.getStash(), removed=[], moved=[], output=false, money=::World.Assets.getMoney(), oldUntil=trait?a.getFlags().get(this.flag("until")):null;
  local oldHP=trait?a.getHitpoints():0, potionFlags=[];
  if(!trait && a!=null)foreach(id,key in this.api().RyzaNativePotionFlags)if(a.getSkills().hasSkill(id))potionFlags.push({Key=key,Value=::World.Statistics.getFlags().get(key)});
  al.Busy=true;
  try
  {
   foreach(i in p.Consumed) {local got=stash.remove(i.getInstanceID());if(got==null) throw "ingredient disappeared";removed.push(got);}
   foreach(g in p.Gear)
   {
    local c=a.getItems(); local detached=g.Equipped?c.unequip(g.Item):c.removeFromBag(g.Item); if(detached==false)throw "gear detach failed"; moved.push(g);
    if(stash.add(g.Item)==null) throw "gear return failed";
   }
   if(!trait) {if(stash.add(result)==null) throw "output stash full";output=true;}
   else
   {
    a.getFlags().set(this.flag(r.Key),true);a.getFlags().set(this.flag("until"),this.now()+r.Days);
    if(effect!=null)a.getSkills().add(effect);a.getSkills().update();
    if(!a.getSkills().hasSkill("$bvvar{modId}.trait.ryza_augmentation"))throw "trait attach failed";
   }
   ::World.Assets.addMoney(-r.Cost);
   foreach(f in potionFlags)::World.Statistics.getFlags().set(f.Key,false);
   // Irreversible roster removal is LAST, after every fallible inventory operation.
   if(!trait && a!=null) ::World.getPlayerRoster().remove(a);
  }
  catch(e)
  {
   if(output)stash.remove(result.getInstanceID());
   foreach(f in potionFlags)::World.Statistics.getFlags().set(f.Key,f.Value);
   if(trait) {a.getFlags().set(this.flag(r.Key),false);a.getFlags().set(this.flag("until"),oldUntil==null?0.0:oldUntil);if(effect!=null)a.getSkills().removeByID("$bvvar{modId}.trait.ryza_augmentation");a.getSkills().update();a.setHitpoints(oldHP);}
   foreach(g in moved) {stash.remove(g.Item.getInstanceID());if(g.Equipped)a.getItems().equip(g.Item);else a.getItems().addToBag(g.Item,g.Index);}
   foreach(i in removed)stash.add(i);::World.Assets.addMoney(money-::World.Assets.getMoney());al.Busy=false;
   ::logWarning("[Battle Valkyries] Ryza transmutation rolled back: "+e);return al.fail("$bv{ryza.alchemy.failed}");
  }
  al.Busy=false;
  return {Success=true,Message=(trait?"$bv{ryza.ext.trait_success}":"$bv{ryza.alchemy.success}")+(trait?r.Name:result.getName()),ItemID=trait?null:result.getInstanceID()};
 }
};
