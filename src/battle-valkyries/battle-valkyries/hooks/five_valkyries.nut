// Actor turn/AP bookkeeping extends the existing shared action route; no extra skill hook.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
    q.setActionPoints=@(__original) function(value)
    {
        local before=this.getActionPoints(),result=__original(value);
        local context=::$bvvar{namespace}.getCurrentValkyrieActionContext(this);
        if(context!=null&&!context.IsFree&&!context.IsImplicit&&::$bvvar{namespace}.FiveValkyries.paid(context))
        {
            if(!("PaidAP" in context))context.PaidAP<-0;
            context.PaidAP+=::Math.max(0,before-this.getActionPoints());
        }
        return result;
    }
    q.onTurnStart=@(__original) function()
    {
        local f=::$bvvar{namespace}.FiveValkyries,c=f.clock(this),fresh=f.normal(this)&&c.Round!=f.round();
        c.Extra=!f.normal(this);
        if(fresh){c.Round=f.round();c.Starts++;c.Active=true;}
        local result=__original();
        if(fresh&&f.alive(this))
        {
            local loss=0,stopped=false;
            foreach(e in clone this.getSkills().m.Skills)
            {
                if(e==null||!("BVFiveEffect" in e.m)||e.isGarbage())continue;
                if(!e.valid()){e.removeSelf();continue;}
                if(c.Starts>=e.m.TargetStart&&!e.m.Consumed)
                {
                    if(e.m.Kind=="slow"){loss=::Math.max(loss,e.m.Amount);e.m.Consumed=true;}
                    if(e.m.Kind=="freeze"||e.m.Kind=="stop"){stopped=true;e.m.Consumed=true;}
                }
            }
            this.setActionPoints(stopped ? 0 : ::Math.max(0,this.getActionPoints()-loss));
            f.turn(this);c.Snapshot=f.snapshot(this);this.getSkills().update();this.setDirty(true);
        }
        return result;
    }
    q.onTurnResumed=@(__original) function()
    {::$bvvar{namespace}.FiveValkyries.clock(this).Extra=!::$bvvar{namespace}.FiveValkyries.normal(this);return __original();}
    q.onTurnEnd=@(__original) function()
    {
        local f=::$bvvar{namespace}.FiveValkyries,c=f.clock(this),normalEnd=c.Active&&!c.Extra&&f.normal(this);
        if(normalEnd){c.Ends++;c.Active=false;}
        local result=__original();
        if(normalEnd)
        {
            foreach(e in clone this.getSkills().m.Skills)
            {
                if(e==null||!("BVFiveEffect" in e.m)||e.isGarbage())continue;
                if(!e.valid()){e.removeSelf();continue;}
                if(e.m.Kind=="burn"&&f.alive(this)){e.m.Ticks--;f.fixed(e.source(),e,this,20,"shana_nietono_no_shana");if(e.m.Ticks<=0)e.removeSelf();}
                else if((e.m.Kind=="slow"||e.m.Kind=="stop"||e.m.Kind=="freeze")&&e.m.Consumed)
                {if(e.m.Kind=="freeze")c.FreezeResistUntil=f.round()+3;e.removeSelf();}
                else if(e.m.Kind=="seal"&&c.Starts>=e.m.TargetStart)e.removeSelf();
            }
            if(f.alive(this)){this.getSkills().update();this.setDirty(true);}
        }
        return result;
    }
    q.onDeath=@(__original) function(killer,skill,tile,fatality)
    {
        ::$bvvar{namespace}.FiveValkyries.killed(this,killer,skill);
        return __original(killer,skill,tile,fatality);
    }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player",function(q){
    q.onCombatStart=@(__original) function()
    {
        ::$bvvar{namespace}.FiveValkyries.cancelRush(this);
        this.m.BVFiveClock<-null;this.m.BVFiveState<-null;return __original();
    }
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
    q.onBattleEnded=@(__original) function()
    {
        if(!this.m.IsExitingToMenu)
        {
            local result=::Tactical.Entities.getCombatResult();
            ::$bvvar{namespace}.FiveValkyries.finish(result==::Const.Tactical.CombatResult.EnemyDestroyed||result==::Const.Tactical.CombatResult.EnemyRetreated);
        }
        return __original();
    }
});
