this.grail_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", {
 function create() { this.yunki_chapter_location.create(); this.m.TypeID="$bvvar{modId}.location.grail_chapter"; },
 function reinforceDefenders() {},
 function addGrail(script,name,count) {
  local troop=clone this.Const.World.Spawn.Troops.SkeletonHeavy;troop.Script="scripts/entity/tactical/enemies/battle_valkyries/"+script;troop.Variant=0;
  for(local i=0;i<count;++i) this.Const.World.Common.addTroop(this,{Type=troop},false,0).Name=name;
 },
 function populateDefenders() {
  if(this.m.Troops.len()>0 || this.data()==null || !this.data().Battle)return;
  if(this.node()=="stage2") {
   for(local i=0;i<6;++i)this.Const.World.Common.addTroop(this,{Type=this.Const.World.Spawn.Troops.BanditRaider},false,0);
   for(local i=0;i<3;++i)this.Const.World.Common.addTroop(this,{Type=this.Const.World.Spawn.Troops.BanditMarksman},false,0);
   this.addExpandedDefenders("brigands_t4",2);
  } else if(this.node()=="stage4") {
   for(local i=0;i<5;++i)this.Const.World.Common.addTroop(this,{Type=this.Const.World.Spawn.Troops.SkeletonMedium},false,0);
   this.addGrail("grail_wishforged_guard","$bv{chapter.grail.enemy.guard}",3);this.addExpandedDefenders("ancients_t4",2);
  } else if(this.node()=="stage6") {
   this.addGrail("grail_wishforged_guard","$bv{chapter.grail.enemy.guard}",6);this.addExpandedDefenders("ancients_t4",3);this.addExpandedDefenders("ancients_t5",1);
  } else if(this.node()=="stage8") {
   this.addGrail("grail_wish_executor","$bv{chapter.grail.enemy.executor}",1);this.addGrail("grail_wishforged_guard","$bv{chapter.grail.enemy.guard}",5);this.addExpandedDefenders("ancients_t4",2);
  }
  this.updateStrength();
 }
});
