// No additional scripts/skills/skill hook. Use existing managed action events.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
    q.onTurnStart=@(__original) function()
    {
        ::$bvvar{namespace}.TenkaGoken.turn(this);return __original();
    }
    q.onMovementFinish=@(__original) function(tile)
    {
        local result=__original(tile);::$bvvar{namespace}.TenkaGoken.moved(this);return result;
    }
    q.onRiposte=@(__original) function(info)
    {
        local f=::$bvvar{namespace}.TenkaGoken;
        if(!f.supported(this)||!f.armed(this))return __original(info);
        local s=f.state(this),token=s.VanillaToken;
        // Vanilla riposte is delayed. Reserve its hostile paid action at TargetResolved.
        if(s.Counters>=2||token==null||token in s.CounterActions||info==null||!info.TargetTile.IsOccupiedByActor
            ||info.TargetTile.getEntity()!=f.api().readValkyrieCombatWeakRef(s.VanillaTarget))return;
        s.CounterActions[token]<-true;s.Counters++;s.VanillaToken=null;
        return __original(info);
    }
    q.onDeath=@(__original) function(killer,skill,tile,fatality)
    {
        ::$bvvar{namespace}.TenkaGoken.clear(this);return __original(killer,skill,tile,fatality);
    }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player",function(q){
    q.onDeserialize=@(__original) function(input)
    {
        local result=__original(input);::$bvvar{namespace}.TenkaGoken.clear(this);
        ::$bvvar{namespace}.TenkaGoken.syncWeapon(this);return result;
    }
    q.onCombatStart=@(__original) function()
    {
        local f=::$bvvar{namespace}.TenkaGoken;f.clear(this);local result=__original();f.syncWeapon(this);return result;
    }
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q){
    q.buildPropertiesForUse=@(__original) function(skill,target=null)
    {
        local p=__original(skill,target);
        if(skill!=null&&"BVTenkaBear" in skill.m&&skill.m.BVTenkaBear)skill.finalizeProperties(p);
        return p;
    }
});
