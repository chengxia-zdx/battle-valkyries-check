::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player",function(q){
    q.onCombatStart=@(__original) function()
    {
        ::$bvvar{namespace}.TenkaFestival.enroll(this);
        return __original();
    }
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
    q.onBattleEnded=@(__original) function()
    {
        local b=::$bvvar{namespace}.TenkaFestival.context();
        if(b!=null)
        {
            local r=::Tactical.Entities.getCombatResult();
            b.Won=r==::Const.Tactical.CombatResult.EnemyDestroyed||r==::Const.Tactical.CombatResult.EnemyRetreated;
        }
        return __original();
    }
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state",function(q){
    q.getLocalCombatProperties=@(__original) function(pos,ignoreNoEnemies=false)
    {
        local result=__original(pos,ignoreNoEnemies);
        if(::$bvvar{namespace}.TenkaFestival.context()!=null){result.IsLootingProhibited=true;result.IsFleeingProhibited=false;}
        return result;
    }
    q.combat_dialog_module_onCancelPressed=@(__original) function()
    {
        if(::$bvvar{namespace}.TenkaFestival.context()!=null){::$bvvar{namespace}.Chapters.Battle=null;}
        return __original();
    }
});
