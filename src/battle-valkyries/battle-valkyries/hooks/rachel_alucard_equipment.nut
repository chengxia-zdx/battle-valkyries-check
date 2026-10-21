local previous=::$bvvar{namespace}.syncActorSkills;
// Direct skin changes also need to clear the rear parasol when weapons are hidden.
local previousSkin=::$bvvar{namespace}.applySkinToActor;
::$bvvar{namespace}.applySkinToActor=function(actor,setDirty=true)
{
 local result=previousSkin(actor,setDirty);
 if(actor!=null)::$bvvar{namespace}.RachelEquipment.syncAppearance(actor);
 return result;
};
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
 q.onAppearanceChanged=@(__original) function(appearance,setDirty=true){local r=__original(appearance,setDirty);::$bvvar{namespace}.RachelEquipment.syncAppearance(this);return r;};
 q.onFactionChanged=@(__original) function(){local r=__original();::$bvvar{namespace}.RachelEquipment.syncAppearance(this);return r;};
 // Follow native lowering/raising without starting a permanent render callback.
 q.onRender=@(__original) function(){local r=__original();::$bvvar{namespace}.RachelEquipment.syncAppearance(this);return r;};
 q.resetRenderEffects=@(__original) function(){local r=__original();::$bvvar{namespace}.RachelEquipment.syncAppearance(this);return r;};
 q.onDeath=@(__original) function(killer,skill,tile,fatalityType){::$bvvar{namespace}.RachelEquipment.hideAppearance(this);return __original(killer,skill,tile,fatalityType);};
 q.onRemovedFromMap=@(__original) function(){::$bvvar{namespace}.RachelEquipment.hideAppearance(this);return __original();};
});
::$bvvar{namespace}.syncActorSkills=function(actor,reason="unknown")
{
 local result=previous(actor,reason);
 if(result.Success)::$bvvar{namespace}.RachelEquipment.sync(actor);
 return result;
};
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
 q.onDeserialize=@(__original) function(input){local r=__original(input);::$bvvar{namespace}.RachelEquipment.backfill();return r;};
 q.onShow=@(__original) function(){local r=__original();::$bvvar{namespace}.RachelEquipment.backfill();return r;};
});
