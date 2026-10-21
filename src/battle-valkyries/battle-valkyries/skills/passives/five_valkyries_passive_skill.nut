this.five_valkyries_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
    m={OwnerID=null},
    function create(){this.valkyrie_passive_skill.create();}
    function onValkyrieSkillBound(d){this.m.OwnerID=d.Spec.Owner;}
    function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
    function getTooltip()
    {
        local f=::$bvvar{namespace}.FiveValkyries,s=f.state(this.actor());
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
        if(s!=null&&s.Cap>0)out.push({id=3,type="text",icon="ui/icons/special.png",text="$bv{five.resource}"+s.Resource+" / "+s.Cap});return out;
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        if(this.m.OwnerID=="yakumo_yukari"&&skill!=null&&skill.isAttack()&&skill.isRanged())p.DamageReceivedTotalMult*=0.7;
    }
    function onValkyrieCombatEvent(event)
    {
        local f=::$bvvar{namespace}.FiveValkyries,a=this.actor();if(!f.alive(a)||!f.paid(event))return;
        if(this.m.OwnerID=="cirno"&&event.Type=="TargetResolved"&&event.Hit&&event.Skill!=null&&event.Skill.isAttack()&&event.Attacker!=a&&f.ally(a,event.Attacker,false))
        {
            local e=f.findEffect(event.Target,"freeze");
            if(e!=null&&e.source()==a&&!e.m.Shattered){e.m.Shattered=true;f.fixed(a,this,event.Target,80,"cirno_perfect_freeze");}
        }
        if(this.m.OwnerID=="tohsaka_rin"&&event.Type=="ActionResolved"&&event.UseResult&&event.Actor!=a&&f.ally(a,event.Actor,false)&&a.getTile().getDistanceTo(event.Actor.getTile())<=4&&"PaidAP" in event&&event.PaidAP>=3)
        {
            local s=f.state(a);
            if(event.ActionToken in s.Actions)return;
            s.Actions[event.ActionToken]<-true;f.gain(a,"team",1,3);
        }
    }
    function onCombatStarted(){local a=this.actor();if(a!=null){local f=::$bvvar{namespace}.FiveValkyries;f.cancelRush(a);a.m.BVFiveState<-null;local s=f.state(a);if(s!=null)s.Participated=true;}}
    function onCombatFinished(){::$bvvar{namespace}.FiveValkyries.clear(this.actor());this.skill.onCombatFinished();}
    function onDeath(fatality){::$bvvar{namespace}.FiveValkyries.clear(this.actor());}
});
