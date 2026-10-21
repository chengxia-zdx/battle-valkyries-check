this.tenka_goken_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
    m={Spec=null},
    function create(){this.valkyrie_passive_skill.create();}
    function onValkyrieSkillBound(d){this.m.Spec=d.Spec;}
    // Native containers return WeakTableRef; combat events carry actor tables.
    function actor(){return this.getContainer()==null ? null : ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.getContainer().getActor());}
    function f(){return ::$bvvar{namespace}.TenkaGoken;}
    function basic(skill)
    {
        if(skill==null||!skill.isAttack()||skill.isRanged()||!skill.m.IsWeaponSkill)return false;
        return ["actives.slash","actives.overhead_strike"].find(skill.getID())!=null;
    }
    function previewBonus(target=null)
    {
        local f=this.f(),a=this.actor(),s=f.state(a),id=f.owner(a),c=f.api().getCurrentValkyrieActionContext(a);
        local bonus=0.0;
        if(c!=null&&"BVTenkaBonus" in c)bonus=c.BVTenkaBonus;
        else
        {
            if(id=="onigawara_rin"&&s.Breath&&f.ends(a)<s.BreathEnd)bonus+=0.25;
            if(id=="inaba_tsukuyo"&&!s.First)bonus+=0.35;
        }
        if(f.coordinated(a,target))bonus+=0.15;
        return bonus;
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}],a=this.actor(),f=this.f();
        if(a!=null)
        {
            local s=f.state(a);
            out.push({id=3,type="text",icon="ui/icons/special.png",text="$bv{tenka.status}"+s.Chain+" / 2, "+s.Counters+" / 2"});
            if(!f.armed(a))out.push({id=4,type="text",icon="ui/icons/warning.png",text="$bv{tenka.unarmed}"});
        }
        return out;
    }
    function onUpdate(p)
    {
        local a=this.actor(),f=this.f();if(!f.supported(a)||!f.armed(a))return;
        if(this.m.Spec.Mode=="mastery"){p.IsSpecializedInSwords=true;return;}
        local id=f.owner(a),s=f.state(a);
        p.MeleeDefense+=id=="inaba_tsukuyo"?12:10;
        p.FatigueRecoveryRate+=id=="onigawara_rin"?5:3;
        if(id=="kikakujo_mary")p.Initiative+=15;
        if((id=="kikakujo_mary"||id=="hanasaka_warabi")&&s.Starts<s.MoveUntil){p.MeleeDefense+=10;p.RangedDefense+=10;}
        if(s.Starts<s.GuardUntil)p.MeleeDefense+=id=="kikakujo_mary"?8:12;
        if(id=="onigawara_rin"&&s.Breath&&f.ends(a)<s.BreathEnd)p.MeleeDefense+=6;
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        if(this.m.Spec.Mode!="tactics")return;
        local a=this.actor(),f=this.f();if(!f.able(a)||skill==null||!skill.isAttack()||attacker==null||attacker.isAlliedWith(a))return;
        local attempt=f.api().findValkyrieTargetAttempt(attacker,skill,a);
        if(attempt==null||!f.paid(attempt.Context))return;
        local s=f.state(a);if(s.Parried)return;
        s.Parried=true;hit.BVTenkaProtected<-true;p.DamageReceivedTotalMult*=f.owner(a)=="onigawara_rin"?0.60:0.75;
    }
    function onBeingAttacked(attacker,skill,p)
    {
        local f=this.f(),a=this.actor();
        if(this.m.Spec.Mode=="tactics"&&f.owner(a)=="tamaba_satori"&&f.armed(a))
        {
            local s=f.state(a);
            if(f.ends(a)<s.ObserveEnd&&f.api().readValkyrieCombatWeakRef(s.Observed)==attacker)p.MeleeDefense+=10;
        }
    }
    function getValkyrieWeaponSkillPolicy(skill)
    {
        local f=this.f(),a=this.actor();
        if(this.m.Spec.Mode!="mastery"||!f.supported(a)||!f.armed(a)||!this.basic(skill))return null;
        local two=f.weapon(a).isItemType(::Const.Items.ItemType.TwoHanded),targetCost=two?4:3;
        local discount=f.owner(a)=="hanasaka_warabi"&&f.state(a).LeapDiscount&&f.validWeaponSkill(a,{Owner=f.owner(a)})?-4:0;
        return {Token="tenka_basic",APDelta=targetCost-skill.m.ActionPointCost,MinimumAPCost=targetCost,FatigueDelta=discount,
            TargetWeaponDamageMultiplier=function(target){return 1.0+this.previewBonus(target);}.bindenv(this)};
    }
    function commitValkyrieWeaponSkillPolicy(token,c)
    {
        if(token!="tenka_basic"||!this.f().paid(c)||"BVTenkaBonus" in c)return;
        c.BVTenkaBonus<-this.f().beginSword(this.actor(),"basic",null);
        this.f().state(this.actor()).LeapDiscount=false;
    }
    function onAnySkillUsed(skill,target,p)
    {
        local f=this.f(),a=this.actor();
        if(this.m.Spec.Mode!="mastery"||!f.supported(a)||!f.armed(a)||!this.basic(skill))return;
        local c=f.api().getCurrentValkyrieActionContext(a,skill),s=f.state(a);
        if((c==null||f.paid(c))&&f.owner(a)=="kikakujo_mary"&&s.RoseRound==f.round()&&f.api().readValkyrieCombatWeakRef(s.RoseTarget)==target)p.MeleeSkill+=8;
        if((c==null||f.paid(c))&&f.validWeaponSkill(a,{Owner="tamaba_satori"})&&f.ends(a)<s.InterceptUntil&&f.api().readValkyrieCombatWeakRef(s.InterceptTarget)==target)p.MeleeSkill+=10;
        p.DamageArmorMult*=1.0+this.previewBonus(target);
        if(skill.getID()=="actives.overhead_strike"&&f.validWeaponSkill(a,{Owner=f.owner(a)}))
        {p.DamageRegularMin-=20;p.DamageRegularMax-=20;}
        local direct=p.DamageDirectMult*(skill.m.DirectDamageMult+p.DamageDirectAdd+p.DamageDirectMeleeAdd);
        if(direct>0.75&&p.DamageDirectMult>0)p.DamageDirectAdd-=(direct-0.75)/p.DamageDirectMult;
    }
    function onValkyrieCombatEvent(e)
    {
        if(this.m.Spec.Mode!="mastery")return;
        local f=this.f(),a=this.actor();if(!f.supported(a))return;
        f.counter(a,this,e);
        if(e.Type!="TargetResolved"||e.Attacker!=a||!f.singlePaidAttack(e)||!this.basic(e.Skill)||!f.armed(a))return;
        local s=f.state(a);if(e.ActionToken in s.Actions)return;s.Actions[e.ActionToken]<-true;
        if(f.owner(a)=="kikakujo_mary"&&s.RoseRound==f.round()&&f.api().readValkyrieCombatWeakRef(s.RoseTarget)==e.Target)s.RoseTarget=null;
        if(f.api().readValkyrieCombatWeakRef(s.InterceptTarget)==e.Target)s.InterceptTarget=null;
        f.hitRecovery(a,e.Hit);f.observe(a,e.Target);f.chain(a,e.Skill.getID(),e.Target);
    }
    function onCombatStarted(){if(this.m.Spec.Mode=="mastery")this.f().clear(this.actor());}
    function onCombatFinished(){if(this.m.Spec.Mode=="mastery")this.f().clear(this.actor());this.skill.onCombatFinished();}
    function onDeath(fatality){this.f().clear(this.actor());}
});
