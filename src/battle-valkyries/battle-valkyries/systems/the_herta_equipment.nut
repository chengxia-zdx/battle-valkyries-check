// Starting set receipts live on the actor. Never replace worn gear during migration.
::$bvvar{namespace}.HertaEquipment <- {
 Items = [
  {Key="staff",Script="scripts/items/weapons/battle_valkyries/the_herta_unending_inquiry",ID="$bvvar{modId}.weapon.the_herta_unending_inquiry",Stage=20},
  {Key="sword",Script="scripts/items/weapons/battle_valkyries/the_herta_answer_foreordained",ID="$bvvar{modId}.weapon.the_herta_answer_foreordained",Stage=60},
  {Key="armor",Script="scripts/items/armor/battle_valkyries/the_herta_starweave_mantle",ID="$bvvar{modId}.armor.the_herta_starweave_mantle",Stage=40},
  {Key="helmet",Script="scripts/items/helmets/battle_valkyries/the_herta_astrolabe_crown",ID="$bvvar{modId}.helmet.the_herta_astrolabe_crown",Stage=80}
 ],
 function flag(d){return "BVHertaStartingEquipment."+d.Key;},
 function equipStarter(a)
 {
  if(::$bvvar{namespace}.getActorValkyrieID(a)!="the_herta")return;
  foreach(d in this.Items)
  {
   if(a.getFlags().get(this.flag(d))==true)continue;
   local item=::new(d.Script);
   local ok=d.Key=="sword"?a.getItems().addToBag(item):a.getItems().equip(item);
   // This runs inside recruit's transaction: a failure removes the new actor
   // and its equipment, without leaving rewards in the company stash.
   if(!ok)throw "[Battle Valkyries] Herta starting equipment failed: "+d.Key;
   a.getFlags().set(this.flag(d),true);
  }
  a.getFlags().set("BVHertaStartingEquipmentMigrated",true);
 },
 function legacyReceived(t,d)
 {
  if(t==null)return false;
  if(d.Key=="armor")return t.m.ArmorClaimed;
  if(d.Key=="helmet")return t.m.HelmetClaimed;
  return t.hasStage(t.m.ClaimedStages,d.Stage);
 },
 function backfill()
 {
  if(!("World" in getroottable())||::World==null||::World.Assets==null)return;
  local roster=::World.getPlayerRoster(),stash=::World.Assets.getStash();
  if(roster==null||stash==null)return;
  local all=clone stash.getItems();
  foreach(a in roster.getAll())foreach(item in a.getItems().getAllItems())if(item!=null)all.push(item);
  foreach(a in roster.getAll())
  {
   if(::$bvvar{namespace}.getActorValkyrieID(a)!="the_herta"||::$bvvar{namespace}.isActorDeadOrDying(a))continue;
   local t=a.getSkills().getSkillByID(::$bvvar{namespace}.HertaBondTraitID);
   if(a.getFlags().get("BVHertaStartingEquipmentMigrated")!=true)
   {
    foreach(d in this.Items)if(this.legacyReceived(t,d))a.getFlags().set(this.flag(d),true);
    // Freeze legacy interpretation before any new perk stage is marked claimed.
    a.getFlags().set("BVHertaStartingEquipmentMigrated",true);
   }
   foreach(d in this.Items)
   {
    local flag=this.flag(d);
    if(a.getFlags().get(flag)==true)continue;
    local exists=false;foreach(item in all)if(item!=null&&item.getID()==d.ID){exists=true;break;}
    if(exists){a.getFlags().set(flag,true);continue;}
    if(!stash.isResizable()&&stash.getNumberOfEmptySlots()<=0)continue;
    local item=::new(d.Script);if(stash.add(item)==null)continue;
    all.push(item);a.getFlags().set(flag,true);
   }
  }
 }
};
