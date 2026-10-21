::$bvvar{namespace}.HuTaoEquipment <- {
 Items={
  staff_of_homa={Script="scripts/items/weapons/battle_valkyries/hu_tao_staff_of_homa",ID="$bvvar{modId}.weapon.hu_tao_staff_of_homa",Flag="BVHuTaoHomaGranted",Option="$bv{hu_tao.replace.homa}"},
  ceremonial_coat={Script="scripts/items/armor/battle_valkyries/hu_tao_ceremonial_coat",ID="$bvvar{modId}.armor.hu_tao_ceremonial_coat",Flag="BVHuTaoCoatGranted",Option="$bv{hu_tao.replace.coat}"},
  hexagram_hat={Script="scripts/items/helmets/battle_valkyries/hu_tao_hexagram_hat",ID="$bvvar{modId}.helmet.hu_tao_hexagram_hat",Flag="BVHuTaoHatGranted",Option="$bv{hu_tao.replace.hat}"}
 },
 function ownerKey(a){local k=::$bvvar{namespace}.getActorFlagString(a,"BVHuTaoEquipmentOwner");if(k==null){k="hu_tao:"+a.getID();a.getFlags().set("BVHuTaoEquipmentOwner",k);}
 return k;},
 function personal(a,key)
 {
  if(!::$bvvar{namespace}.HuTao.owns(a))return null;
  local slot=key=="staff_of_homa"?::Const.ItemSlot.Mainhand:(key=="ceremonial_coat"?::Const.ItemSlot.Body: ::Const.ItemSlot.Head),w=a.getItems().getItemAtSlot(slot);
  return w!=null&&w.getID()==this.Items[key].ID&&w.getCondition()>0&&w.m.HuTaoOwner==this.ownerKey(a)?w:null;
 },
 function tier(a,key){local f=::$bvvar{namespace}.HuTao;return f.upgraded(a,80)?2:key=="ceremonial_coat"&&f.upgraded(a,40)||key=="hexagram_hat"&&f.upgraded(a,60)?1:0;},
 function cap(a){local n=20;foreach(stage in [20,40,60,80])if(::$bvvar{namespace}.HuTao.upgraded(a,stage))n+=10;return n;},
 function growth(a){local n=a.getFlags().get("BVHuTaoHomaGrowth");return typeof n=="integer"?::Math.min(60,::Math.max(0,n)):0;},
 function properties(a,p)
 {
  local w=this.personal(a,"staff_of_homa"),coat=this.personal(a,"ceremonial_coat"),hat=this.personal(a,"hexagram_hat");
  if(w!=null){p.Hitpoints+=this.growth(a);p.HitpointsMult+=w.m.HuTaoTier>=2?0.15:0.10;}
  if(coat!=null&&coat.m.HuTaoTier>=1){p.Hitpoints+=coat.m.HuTaoTier>=2?20:10;p.MeleeDefense+=5;p.FatigueReceivedPerHitMult*=coat.m.HuTaoTier>=2?0.50:0.75;}
  if(hat!=null){p.Bravery+=hat.m.HuTaoTier>=1?15:5;p.RangedDefense+=hat.m.HuTaoTier>=2?8:hat.m.HuTaoTier>=1?5:0;}
 },
 function allItems(a)
 {
  local out=[];foreach(i in a.getItems().getAllItems())if(i!=null)out.push(i);
  if(!("World" in getroottable())||::World==null||::World.Assets==null)return out;
  foreach(b in ::World.getPlayerRoster().getAll())foreach(i in b.getItems().getAllItems())if(i!=null&&out.find(i)==null)out.push(i);
  foreach(i in ::World.Assets.getStash().getItems())if(i!=null&&out.find(i)==null)out.push(i);return out;
 },
 function exists(a,key){local owner=this.ownerKey(a);foreach(i in this.allItems(a))if(i.getID()==this.Items[key].ID&&"HuTaoOwner" in i.m&&i.m.HuTaoOwner==owner)return true;return false;},
 function create(a,key){local i=::new(this.Items[key].Script);i.m.HuTaoOwner=this.ownerKey(a);i.setHuTaoTier(this.tier(a,key));return i;},
 function equipStarter(a){foreach(key,d in this.Items){if(!a.getItems().equip(this.create(a,key)))throw "[Battle Valkyries] Hu Tao starter equipment failed: "+key;a.getFlags().set(d.Flag,true);}},
 function sync(a)
 {
  local owner=this.ownerKey(a);foreach(i in this.allItems(a))if("HuTaoOwner" in i.m&&i.m.HuTaoOwner==owner)
   foreach(key,d in this.Items)if(i.getID()==d.ID)i.setHuTaoTier(this.tier(a,key));
  ::$bvvar{namespace}.HuTao.update(a);
 },
 function grant(a,key)
 {
  if(!::$bvvar{namespace}.HuTao.owns(a))return false;local d=this.Items[key];
  if(a.getFlags().get(d.Flag)==true)return true;
  if(this.exists(a,key)){a.getFlags().set(d.Flag,true);return true;}
  local stash=::World.Assets.getStash();if(!stash.isResizable()&&stash.getNumberOfEmptySlots()==0)return false;
  if(stash.add(this.create(a,key))==null)return false;a.getFlags().set(d.Flag,true);return true;
 },
 function missingKeys(a){local out=[];foreach(key,d in this.Items)if(a.getFlags().get(d.Flag)==true&&!this.exists(a,key))out.push(key);return out;},
 function replaceMissing(a,key)
 {
  if(!::$bvvar{namespace}.HuTao.owns(a)||a.isPlacedOnMap()||!(key in this.Items)||this.missingKeys(a).find(key)==null)return false;
  local stash=::World.Assets.getStash(),money=::World.Assets.getMoney();if(money<3000||!stash.isResizable()&&stash.getNumberOfEmptySlots()==0)return false;
  local item=this.create(a,key);if(stash.add(item)==null)return false;
  try{::World.Assets.setMoney(money-3000);}
 catch(e){stash.remove(item);throw e;}
 return true;
 },
 function start(a){a.getFlags().set("BVHuTaoStartedWithHoma",this.personal(a,"staff_of_homa")!=null);},
 function victory(a,id)
 {
  local flags=a.getFlags();if(flags.get("BVHuTaoGrowthCombatID")==id)return;
  flags.set("BVHuTaoGrowthCombatID",id);
  if(flags.get("BVHuTaoStartedWithHoma")==true&&this.personal(a,"staff_of_homa")!=null)
   flags.set("BVHuTaoHomaGrowth",::Math.min(this.cap(a),this.growth(a)+2));
  flags.set("BVHuTaoStartedWithHoma",false);this.sync(a);
 }
};
