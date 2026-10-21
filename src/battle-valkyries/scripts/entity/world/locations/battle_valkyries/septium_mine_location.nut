this.septium_mine_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/septium_chapter_location",{
 function create(){this.septium_chapter_location.create();this.m.TypeID="$bvvar{modId}.location.septium_mine";},
 function configure(){this.yunki_chapter_location.configure();local d=::$bvvar{namespace}.SeptiumMine.difficulty(this.getFlags().get("BVSeptiumMineDifficulty"));if(d!=null)this.m.Name=d.Name;},
 function populateDefenders(){
  if(this.getFlags().get("BVSeptiumPopulated")==true)return;
  local d=::$bvvar{namespace}.SeptiumMine.difficulty(this.getFlags().get("BVSeptiumMineDifficulty"));if(d==null)return;
  for(local i=0;i<d.Count;i++){
   local role=d.Tier==3&&i==0?"overseer":i%4==0?"relay":i%3==0||d.Element=="space"&&i%2==0?"ranger":"guard";
   local type=clone this.Const.World.Spawn.Troops[role=="ranger"?"BanditMarksman":"BanditRaider"];
   type.Script="scripts/entity/tactical/enemies/battle_valkyries/septium_"+role;
   this.Const.World.Common.addTroop(this,{Type=type},false,0);
  }
  this.getFlags().set("BVSeptiumPopulated",true);this.updateStrength();
 },
 function onEnter(){
  local f=::$bvvar{namespace}.SeptiumMine;
  if(f.read("active")!=1 || this.getID()!=f.read("node_id",-1) || this.getFlags().get("BVChapterCycle")!=f.cycle() || !f.unlocked())return false;
  return this.yunki_chapter_location.onEnter();
 },
 function onBeforeCombatStarted(){if(!::$bvvar{namespace}.SeptiumMine.enter(this))return;this.yunki_chapter_location.onBeforeCombatStarted();}
});
