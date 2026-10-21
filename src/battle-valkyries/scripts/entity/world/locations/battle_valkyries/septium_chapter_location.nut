this.septium_chapter_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location",{
 function create(){this.yunki_chapter_location.create();this.m.TypeID="$bvvar{modId}.location.septium_workshop";this.m.CombatLocation.Template=[null,null];this.m.CombatLocation.ForceLineBattle=false;this.m.CombatLocation.AdditionalRadius=0;},
 function getChapterFactionType(){return this.Const.FactionType.Bandits;},
 function reinforceDefenders(){},
 function populateDefenders(){
  if(this.getFlags().get("BVSeptiumPopulated")==true)return;
  local id=this.getFlags().get("BVChapterID"),node=this.getFlags().get("BVChapterNode"),d=::$bvvar{namespace}.Chapters.definition(id);
  if(d==null || !(node in d.Nodes) || !d.Nodes[node].Battle)return;
  local tier=d.Nodes[node].Tier,counts=tier==1?[6,2,0,0]:tier==2?[8,2,0,0]:tier==3?[6,4,2,0]:[6,4,2,1];
  foreach(role,count in counts)for(local i=0;i<count;i++){
   local type=clone this.Const.World.Spawn.Troops[role==1?"BanditMarksman":"BanditRaider"];
   type.Script="scripts/entity/tactical/enemies/battle_valkyries/septium_"+["guard","ranger","relay","overseer"][role];
   this.Const.World.Common.addTroop(this,{Type=type},false,0);
  }
  this.getFlags().set("BVSeptiumPopulated",true);this.updateStrength();
 }
});
