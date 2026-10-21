// Lifecycle, aura and defensive boundaries. Attacks reuse the existing shared adapter.
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
    q.cancelEntitySkill=@(__original) function(a)
    {
        if(a!=null)foreach(key in ["celestine_gate","chloe_dual"]){local skill=::$bvvar{namespace}.getRuntimeSkillByKey(a,key);if(skill!=null)skill.cancelGate();}
        return __original(a);
    }
    q.setActionStateBySkill=@(__original) function(a,selected)
    {
        if(a!=null)foreach(key in ["celestine_gate","chloe_dual"]){local skill=::$bvvar{namespace}.getRuntimeSkillByKey(a,key);if(skill!=null && skill!=selected)skill.cancelGate();}
        return __original(a,selected);
    }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
    q.onRemovedFromMap=@(__original) function()
    {
        local result=__original(),f=::$bvvar{namespace}.BlackBeast;
        this.m.BVBlackBeastFeedbackFinished<-true;f.syncFeedback(this);f.refreshAuraIfChanged(this);return result;
    }
    q.onMovementFinish=@(__original) function(tile)
    {
        local result=__original(tile);
        this.getSkills().update();this.setDirty(true);return result;
    }
    q.onDeath=@(__original) function(killer,skill,tile,fatality)
    {
        local result=__original(killer,skill,tile,fatality),f=::$bvvar{namespace}.BlackBeast;
        this.m.BVBlackBeastFeedbackFinished<-true;f.syncFeedback(this);f.refreshAuraIfChanged(this);return result;
    }
    q.onTurnStart=@(__original) function()
    {
        local result=__original();::$bvvar{namespace}.BlackBeast.normalStart(this);return result;
    }
    q.onTurnEnd=@(__original) function()
    {
        local f=::$bvvar{namespace}.BlackBeast,before=f.clock(this).Ends,result=__original();
        if(f.clock(this).Ends>before)f.normalEnd(this);return result;
    }
    q.onDamageReceived=@(__original) function(attacker,skill,hit)
    {
        local f=::$bvvar{namespace}.BlackBeast;
        if(f.alive(this) && f.getEffect(this,"protect")!=null)
        {
            foreach(k in ["DamageRegular","DamageArmor","DamageMinimum","DamageInflictedHitpoints","DamageInflictedArmor"])if(k in hit)hit[k]=0;
            return 0;
        }
        return __original(attacker,skill,hit);
    }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player",function(q){
    q.onCombatStart=@(__original) function()
    {
        this.m.BVBlackBeastRevived<-false;this.m.BVPrimAuraRound<--1;this.m.BVBlackBeastFeedbackFinished<-false;return __original();
    }
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q){
    q.add=@(__original) function(skill,order=0)
    {
        local f=::$bvvar{namespace}.BlackBeast,a=this.getActor();
        if(skill!=null && f.maiaControlImmune(a))
            foreach(id in ["effects.stunned","effects.dazed","effects.staggered","$bvvar{modId}.effects.black_beast_stun","$bvvar{modId}.effects.black_beast_daze","$bvvar{modId}.effects.black_beast_stagger"])
                if(skill.m.ID==id)return;
        return __original(skill,order);
    }
    q.update=@(__original) function()
    {
        local nested=this.m.IsUpdating,result=__original(),a=this.getActor(),f=::$bvvar{namespace}.BlackBeast;
        if(!nested)
        {
            if(f.alive(a))f.auraProperties(a,a.getCurrentProperties());
            f.syncFeedback(a);
            f.refreshAuraIfChanged(a);
        }
        return result;
    }
    q.buildPropertiesForBeingHit=@(__original) function(attacker,skill,hit)
    {
        local p=__original(attacker,skill,hit);::$bvvar{namespace}.BlackBeast.auraDamage(this.getActor(),skill,p);return p;
    }
});
::$bvvar{namespace}.MH.hook("scripts/items/shields/shield",function(q){
    q.applyShieldDamage=@(__original) function(damage,playHitSound=true)
    {
        local a=this.getContainer()==null?null:this.getContainer().getActor(),f=::$bvvar{namespace}.BlackBeast;
        if(f.supported(a) && f.owner(a)=="maia") {if(f.stage(a)>=3)return;if(f.stage(a)>=1)damage*=0.5;}
        return __original(damage,playHitSound);
    }
});
::$bvvar{namespace}.MH.hook("scripts/items/weapons/weapon",function(q){
    q.getShieldDamage=@(__original) function()
    {
        local value=__original(),a=this.getContainer()==null?null:this.getContainer().getActor(),f=::$bvvar{namespace}.BlackBeast;
        return f.supported(a) && f.owner(a)=="luu_luu" && f.armed(a)?value*2:value;
    }
});
