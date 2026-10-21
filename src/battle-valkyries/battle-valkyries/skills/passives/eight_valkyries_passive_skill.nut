this.eight_valkyries_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
    m={ OwnerID=null },
    function ev(){return ::$bvvar{namespace}.EightValkyries;}
    function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
    function create(){this.valkyrie_passive_skill.create();}
    function onValkyrieSkillBound(d){this.m.OwnerID=d.Spec.Owner;}
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}],s=this.ev().state(this.actor());
        if(s!=null&&s.Cap>0)out.push({id=3,type="text",icon="ui/icons/special.png",text="$bv{eight.state}"+s.Resource+" / "+s.Cap});return out;
    }
    function onUpdate(p)
    {
        local a=this.actor();if(!this.ev().supported(a))return;
        switch(this.m.OwnerID)
        {
        case "misono_mika":p.DamageReceivedTotalMult*=0.8;break;
        case "shizuna":p.MeleeDefense+=10;break;
        case "argente":p.MeleeDefense+=15;p.RangedDefense+=15;p.DamageReceivedTotalMult*=0.75;break;
        case "sekka":p.MeleeDefense+=10;p.RangedDefense+=10;local s=this.ev().state(a);if(s!=null&&s.Resource==9)p.Initiative+=30;break;
        }
    }
    function onBeingAttacked(attacker,skill,p)
    {
        local s=this.ev().state(this.actor());
        if(s!=null&&s.ID=="shizuna"&&s.Turn<s.StudyUntil&&::$bvvar{namespace}.readValkyrieCombatWeakRef(s.Study)==attacker&&skill!=null&&!skill.isRanged())p.MeleeDefense+=25;
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        local e=this.ev(),a=this.actor(),s=e.state(a);if(s==null||skill==null||!skill.isAttack())return;
        if(s.ID=="shizuna"&&!skill.isRanged()&&s.Turn<s.StudyUntil&&::$bvvar{namespace}.readValkyrieCombatWeakRef(s.Study)==attacker)p.DamageReceivedTotalMult*=0.8;
        if(s.ID=="xin"&&s.Turn<s.WardUntil&&attacker!=null&&!attacker.isAlliedWith(a))
        {
            local attempt=::$bvvar{namespace}.findValkyrieTargetAttempt(attacker,skill,a);
            if(attempt!=null)
            {
                local token=attempt.Context.ActionToken;
                if(s.WardToken==null)s.WardToken=token;
                if(s.WardToken==token)p.DamageReceivedTotalMult*=0.7;
            }
        }
    }
    function onMissed(attacker,skill)
    {
        local e=this.ev(),a=this.actor(),s=e.state(a);
        if(s==null||s.ID!="shizuna"||skill==null||skill.isRanged()||s.Turn>=s.StudyUntil||::$bvvar{namespace}.readValkyrieCombatWeakRef(s.Study)!=attacker||!e.able(a))return;
        local context=::$bvvar{namespace}.getCurrentValkyrieActionContext(attacker,skill);
        if(!e.paid(context))return;
        e.gainOnce(a,"read",1);
        if(s.Counters>0||!e.armed(a,"shizuna")||!a.getCurrentProperties().IsAbleToUseWeaponSkills||!e.enemy(a,attacker,1))return;
        s.Counters++;e.feedback(a,a,"shizuna_observing_eye","cast");
        local w=e.weapon(a),result=::$bvvar{namespace}.applyValkyrieWeaponAttack(a,this,attacker,{WeaponDamageMult=1.25,ArmorDamageMult=1.5/::Math.max(0.01,w.m.ArmorDamageMult),DirectDamageOverride=w.m.DirectDamageMult,HitChance=20,IgnoreDistance=true,ParentActionToken=context.ActionToken,Source="followup"});
        if(result.Hit&&e.alive(attacker))e.feedback(a,attacker,"shizuna_observing_eye","impact");
    }
    function onValkyrieCombatEvent(event)
    {
        local e=this.ev(),a=this.actor(),s=e.state(a);if(s==null||!e.paid(event))return;
        if(s.ID=="xin"&&event.Type=="ActionStarted"&&event.Actor!=a&&e.ally(a,event.Actor,false)&&event.Skill!=null&&event.Skill.isAttack())
            s.PrimaryTargets[event.ActionToken]<-::$bvvar{namespace}.makeValkyrieCombatWeakRef(event.Target);
        if(event.Type=="TargetResolved")
        {
            if(!event.Hit||event.Skill==null||!event.Skill.isAttack())return;
            if(s.ID=="shizuna"&&event.Attacker==a&&!event.Skill.isRanged())e.gainOnce(a,"hit",1);
            if(s.ID!="xin"||event.Attacker==a||!e.ally(a,event.Attacker,false)||a.getTile().getDistanceTo(event.Attacker.getTile())>5||event.HitpointDamage+event.ArmorDamage<=0)return;
            if(!(event.ActionToken in s.Pending))
            {
                local target=event.ActionToken in s.PrimaryTargets ? s.PrimaryTargets[event.ActionToken] : ::$bvvar{namespace}.makeValkyrieCombatWeakRef(event.Target);
                s.Pending[event.ActionToken]<-{Actor=::$bvvar{namespace}.makeValkyrieCombatWeakRef(event.Attacker),Target=target,Ranged=event.Skill.isRanged()};
            }
        }
        if(event.Type=="ActionResolved"&&event.ActionToken in s.PrimaryTargets)delete s.PrimaryTargets[event.ActionToken];
        if(event.Type=="ActionResolved"&&s.ID=="xin"&&event.ActionToken in s.Pending)
        {
            local rec=s.Pending[event.ActionToken];delete s.Pending[event.ActionToken];
            local previous=s.Previous;s.Previous=rec;
            local ally=::$bvvar{namespace}.readValkyrieCombatWeakRef(rec.Actor),target=::$bvvar{namespace}.readValkyrieCombatWeakRef(rec.Target);
            if(previous==null||!e.able(a)||!e.ally(a,ally,false)||a.getTile().getDistanceTo(ally.getTile())>5||s.Resource<=0||!e.enemy(a,target,6))return;
            local other=::$bvvar{namespace}.readValkyrieCombatWeakRef(previous.Actor);
            if(other==ally||other==null||previous.Ranged==rec.Ranged)return;
            local enhanced=e.fieldContains(a,ally)&&e.fieldContains(a,other),cap=enhanced?3:2;
            if(s.Reflections>=cap)return;
            local attack=::$bvvar{namespace}.getRuntimeSkillByKey(a,"xin_worldly_form");if(attack==null)return;
            s.Reflections++;e.resource(a,-1);e.feedback(a,a,"xin_myriad_reflections","cast");
            attack.freeStrike(a,target,65,0.25,1.5,0.4,enhanced?1.5:1.0,event.ActionToken);
        }
    }
    function onTurnStart(){this.ev().turn(this.actor());}
    function onTurnEnd(){local s=this.ev().state(this.actor());if(s!=null)s.Retreat=false;}
    function onCombatStarted(){local a=this.actor();this.ev().cancelMove(a);if(a!=null){a.m.BVEightState<-null;this.ev().state(a);}}
    function onCombatFinished(){local a=this.actor();this.ev().cancelMove(a);this.ev().clearEffects(a);if(a!=null)a.m.BVEightState<-null;this.skill.onCombatFinished();}
    function onDeath(fatality){local a=this.actor();this.ev().cancelMove(a);this.ev().clearEffects(a);if(a!=null)a.m.BVEightState<-null;}
});
