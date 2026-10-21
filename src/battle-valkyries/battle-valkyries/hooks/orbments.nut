// Native tag_collection.get() returns false for missing flags. Only explicit
// mine enemy roles may restore this runtime effect; repair earlier leaked copies.
local syncSeptiumProtocol = function(actor, restore = false) {
 if(actor==null || actor.getSkills()==null)return;
 local skills=actor.getSkills(),role=actor.getFlags().get("BVSeptiumRole");
 local valid=!actor.isPlayerControlled() && ["guard","ranger","relay","overseer"].find(role)!=null;
 local protocol=skills.getSkillByID("$bvvar{modId}.effects.septium_protocol");
 if(!valid) {
  if(protocol!=null) {
   protocol.removeSelf();skills.update();actor.setDirty(true);
  }
  return;
 }
 if(!restore)return;
 if(protocol==null)skills.add(::new("$bvvar{privateFolder}/skills/effects/septium_protocol_effect"));
 if(role=="overseer" && skills.getSkillByID("$bvvar{modId}.enemy_skill.septium_blast")==null)
  skills.add(::new("$bvvar{privateFolder}/skills/actives/septium_blast_skill"));
};

// Equipment ownership rebuilds from the actual accessory after the ordinary identity repair.
local bv=::$bvvar{namespace},originalSync=bv.syncActorSkills;
bv.syncActorSkills=function(actor,context=null) {
 syncSeptiumProtocol(actor);
 local result=originalSync.call(this,actor,context),it=this.Orbments.item(actor);
 if(it!=null)this.Orbments.attach(actor,it);return result;
};
bv.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onTurnStart=@(__original) function(){
  syncSeptiumProtocol(this);
  local f=::$bvvar{namespace}.OrbalCombat;f.startTurn(this);this.getSkills().update();return __original();
 };
 q.onTurnEnd=@(__original) function(){
  local f=::$bvvar{namespace}.OrbalCombat,c=::$bvvar{namespace}.FiveValkyries.clock(this),normal=c.Active&&!c.Extra&&f.normal(this);
  local result=__original();if(normal)f.endTurn(this);return result;
 };
 q.onDeserialize=@(__original) function(input){
  __original(input);local f=::$bvvar{namespace}.OrbalCombat;
  syncSeptiumProtocol(this,true);
  foreach(k in ["analysis","chill","zero","guard","boost","disrupt","veil","bulwark","haste"])
   if(f.read(this,k+".count")>0){f.ensure(this);break;}
 };
});
bv.MH.hook("scripts/entity/tactical/player",function(q){
 q.onCombatStart=@(__original) function(){syncSeptiumProtocol(this);::$bvvar{namespace}.OrbalCombat.reset(this);return __original();};
 q.onDeserialize=@(__original) function(input){__original(input);local it=::$bvvar{namespace}.Orbments.item(this);if(it!=null)::$bvvar{namespace}.Orbments.attach(this,it);};
});
bv.MH.hook("scripts/ui/screens/character/character_screen",function(q){
 q.onOrbmentRequest <- function(data){
  local f=::$bvvar{namespace}.Orbments;
  if(typeof data=="table" && "Action" in data && data.Action=="probe"){
   local it="Instance" in data?f.find(data.Instance):null;if(it==null)return {Handled=false};
   local result=f.open(data.Instance);result.Handled<-true;return result;
  }
  local result=f.request(data);
  if(result.Success && ["save","upgrade","recycle","close"].find(data.Action)!=null)this.loadStashList();
  return result;
 };
});

local originalRecruit=bv.createValkyrieRosterActor;
bv.createValkyrieRosterActor=function(id,context,options=null){
 local result=originalRecruit.call(this,id,context,options);
 if(result.Success && "Actor" in result && result.Actor!=null)try {this.Orbments.trailsAward(result.Actor);}catch(e){::logWarning("[Battle Valkyries] Trails orbment pending: "+e);}
 return result;
};

bv.MH.hook("scripts/states/world_state",function(q){
 q.getLocalCombatProperties=@(__original) function(pos,ignoreNoEnemies=false){
  local result=__original(pos,ignoreNoEnemies);
  if(result!=null)foreach(party in result.Parties)if(party!=null && party.isLocation()){
   local id=party.getFlags().get("BVChapterID");
   if(id=="septium_workshop")result.BVSeptiumElement<-"earth";
   if(id=="septium_mine"){
    local d=::$bvvar{namespace}.SeptiumMine.difficulty(party.getFlags().get("BVSeptiumMineDifficulty"));
    if(d!=null)result.BVSeptiumElement<-d.Element;
   }
  }
  return result;
 };
});
