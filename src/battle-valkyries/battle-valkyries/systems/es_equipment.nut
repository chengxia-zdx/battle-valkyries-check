::$bvvar{namespace}.EsEquipment <- {
 Items = {
  murakumo = { Script="scripts/items/weapons/battle_valkyries/es_murakumo", ID="$bvvar{modId}.weapon.es_murakumo", Flag="BVEsWeaponGranted", Stage=0, Price=3000, Option="$bv{es.replace.buy}" },
  guardian_uniform = { Script="scripts/items/armor/battle_valkyries/es_guardian_uniform", ID="$bvvar{modId}.armor.es_guardian_uniform", Flag="BVEsGuardianUniformGranted", Stage=40, Price=3000, Option="$bv{es.replace.uniform}" },
  azure_circlet = { Script="scripts/items/helmets/battle_valkyries/es_azure_circlet", ID="$bvvar{modId}.helmet.es_azure_circlet", Flag="BVEsAzureCircletGranted", Stage=60, Price=2000, Option="$bv{es.replace.circlet}" }
 },
 function ownerKey(a)
 {
  local key=::$bvvar{namespace}.getActorFlagString(a,"BVEsEquipmentOwner");
  if(key==null){key="es:"+a.getID();a.getFlags().set("BVEsEquipmentOwner",key);}
 return key;
 },
 function allItems(a)
 {
  local out=[];foreach(i in a.getItems().getAllItems())if(i!=null)out.push(i);
  if(!("World" in getroottable())||::World==null||::World.Assets==null)return out;
  foreach(b in ::World.getPlayerRoster().getAll())foreach(i in b.getItems().getAllItems())if(i!=null&&out.find(i)==null)out.push(i);
  foreach(i in ::World.Assets.getStash().getItems())if(i!=null)out.push(i);return out;
 },
 function exists(a, itemKey="murakumo"){local key=this.ownerKey(a);foreach(i in this.allItems(a))if("EsOwner" in i.m&&i.m.EsOwner==key&&i.getID()==this.Items[itemKey].ID)return true;return false;},
 function create(a, itemKey="murakumo"){local item=::new(this.Items[itemKey].Script);item.m.EsOwner=this.ownerKey(a);return item;},
 function equipStarter(a){if(!a.getItems().equip(this.create(a)))throw "[Battle Valkyries] Es starter weapon equip failed";a.getFlags().set("BVEsWeaponGranted",true);},
 function eligible(a, itemKey)
 {
  if(!::$bvvar{namespace}.Es.owns(a)||!(itemKey in this.Items))return false;
  local stage=this.Items[itemKey].Stage;
  if(stage==0)return true;
  local trait=::$bvvar{namespace}.EsBond.ensureTrait(a);
  return trait!=null&&trait.hasTriggeredStage(stage);
 },
 function grant(a, itemKey="murakumo")
 {
  if(!this.eligible(a,itemKey))return false;
  local flag=this.Items[itemKey].Flag;
  if(a.getFlags().get(flag)==true)return true;
  if(this.exists(a,itemKey)){a.getFlags().set(flag,true);return true;}
  if(!("World" in getroottable())||::World==null||::World.Assets==null)return false;
  local stash=::World.Assets.getStash();if(!stash.isResizable()&&stash.getNumberOfEmptySlots()==0)return false;
  if(stash.add(this.create(a,itemKey))==null)return false;a.getFlags().set(flag,true);return true;
 },
 function missing(a,itemKey="murakumo"){return a!=null&&this.eligible(a,itemKey)&&a.getFlags().get(this.Items[itemKey].Flag)==true&&!this.exists(a,itemKey);},
 function missingKeys(a)
 {
  local result=[];
  foreach(key in ["murakumo","guardian_uniform","azure_circlet"])if(this.missing(a,key))result.push(key);
  return result;
 },
 function replaceMissing(a,itemKey="murakumo")
 {
  if(!::$bvvar{namespace}.Es.owns(a)||a.isPlacedOnMap()||!this.missing(a,itemKey))return false;
  local price=this.Items[itemKey].Price;
  if(::World.Assets.getMoney()<price)return false;
  local stash=::World.Assets.getStash();if(!stash.isResizable()&&stash.getNumberOfEmptySlots()==0)return false;
  local item=this.create(a,itemKey),money=::World.Assets.getMoney();if(stash.add(item)==null)return false;
  try{::World.Assets.setMoney(money-price);}
 catch(e){stash.remove(item);throw e;}
 return true;
 }
};
