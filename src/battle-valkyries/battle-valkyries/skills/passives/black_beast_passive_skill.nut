this.black_beast_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
    m = { OwnerID = null },
    function create() { this.valkyrie_passive_skill.create(); }
    function onValkyrieSkillBound(d) { this.m.OwnerID = d.Spec.Owner; }
    function f() { return ::$bvvar{namespace}.BlackBeast; }
    function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
    function valid() { return this.f().supported(this.actor()) && this.f().owner(this.actor()) == this.m.OwnerID; }
    function special(skill) { return skill != null && "BVBlackBeastActive" in skill.m && skill.m.BVBlackBeastActive; }
    function getDescription()
    {
        if (this.valid() && this.m.OwnerID == "maia")
        {
            local f=this.f(),a=this.actor(),n=f.stage(a),v=f.maiaProtection(a);
            return ::format("$bv{black_beast.feedback.maia_passive}",n>=3?"2.5":"2",v.SelfReduction,v.Radius,v.Defense,v.Reduction,v.WallReduction,n>=5?25:(n>=1?15:0))
                +(n>=3?"$bv{black_beast.feedback.shield_full}":(n>=1?"$bv{black_beast.feedback.shield_half}":""))
                +(n>=5?"$bv{black_beast.feedback.maia_ally_immunity}":"");
        }
        return this.m.Description;
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
        if(this.valid() && this.m.OwnerID=="alicia") out.push({id=3,type="text",icon="ui/icons/special.png",text="$bv{black_beast.sword_stacks}"+this.f().state(this.actor()).Stacks});
        return out;
    }
    function onUpdate(p)
    {
        if(!this.valid()) return;
        local f=this.f(),a=this.actor(),n=f.stage(a),id=this.m.OwnerID,s=f.state(a);
        p.ActionPoints += id=="celestine" ? n : [0,1,1,2,2,3][n];
        if(id=="luu_luu" && n>=3) p.Stamina+=20;
        if(id=="alicia" && f.armed(a)) { p.MeleeSkill+=5*s.Stacks; p.MeleeDefense+=5*s.Stacks; }
        if(id=="claudia" && f.armed(a) && a.getArmor(::Const.BodyPart.Body)>0) p.IsImmuneToKnockBackAndGrab=true;
        if(id=="maia" && f.shield(a)!=null)
        {
            local shield=f.shield(a),factor=n>=3?2.5:2.0;
            // Only the shield's own defense component is increased.
            p.MeleeDefense+=::Math.floor(shield.getMeleeDefense()*(factor-1));
            p.RangedDefense+=::Math.floor(shield.getRangedDefense()*(factor-1));
            p.IsImmuneToKnockBackAndGrab=true;
            if(n>=3) { p.IsImmuneToStun=true; p.IsImmuneToDaze=true; }
        }
        if(f.guard(a))
        {
            if(id=="chloe") { local fortress=n>=3; p.MeleeDefense+=fortress?40:30; if(fortress) {p.RangedDefense+=40;p.IsImmuneToKnockBackAndGrab=true;} }
            if(id=="alicia") p.MeleeDefense+=20;
            if(id=="maia" && f.shield(a)!=null) {p.MeleeDefense+=30;p.RangedDefense+=30;}
        }
    }
    function getValkyrieWeaponSkillPolicy(skill)
    {
        local f=this.f(),a=this.actor();
        if(!this.valid() || !f.armed(a) || !f.directWeapon(skill) || this.special(skill)) return null;
        local id=this.m.OwnerID,n=f.stage(a),s=f.state(a),p={Token="black_beast_native",APDelta=0,FatigueDelta=0,MinimumAPCost=1};
        if(id=="alicia" || id=="prim") p.APDelta=-1;
        if(id=="prim") p.FatigueDelta=-5;
        if(id=="chloe" && s.PursuitRound==f.round()) {p.Token="black_beast_pursuit";p.APDelta=n>=1?-2:-1;p.FatigueDelta=n>=1?-12:-8;}
        return p;
    }
    function commitValkyrieWeaponSkillPolicy(token,context)
    {
        if(token!="black_beast_pursuit" || !this.f().paid(context)) return;
        local s=this.f().state(this.actor());s.PursuitRound=-1;s.PursuitAction=context.ActionToken;
    }
    function ignoresShieldFor(skill)
    {
        local f=this.f(),a=this.actor();if(!this.valid() || !f.armed(a) || !f.directWeapon(skill)) return false;
        return this.m.OwnerID=="alicia" && f.stage(a)>=1;
    }
    function ignoresShieldAgainst(skill,target)
    {
        local f=this.f(),a=this.actor();
        return this.valid() && this.m.OwnerID=="kaguya" && f.armed(a) && f.directWeapon(skill) && f.alive(target) && a.getTile().getDistanceTo(target.getTile())==2;
    }
    function onAnySkillUsed(skill,target,p)
    {
        local f=this.f(),a=this.actor();if(!this.valid() || !f.armed(a) || !f.directWeapon(skill) || this.special(skill)) return;
        local id=this.m.OwnerID,n=f.stage(a),s=f.state(a),bonus=0.0,pen=0.0,hit=0;
        if(id=="chloe") {hit=n>=5?25:15;bonus=n>=5?1.0:0.5;pen=n>=5?0.5:0.3;local c=f.api().getCurrentValkyrieActionContext(a,skill);if(n>=1 && c!=null && s.PursuitAction==c.ActionToken) bonus+=0.3;}
        if(id=="alicia") {hit=10;pen=0.25;if(n>=3)p.DamageTotalMult*=1.0+0.05*s.Stacks;}
        if(id=="claudia") {hit=15;p.DamageArmorMult+=0.5;pen=0.15;if(n>=3 && target!=null && target.getArmor(::Const.BodyPart.Head)<=0 && target.getArmor(::Const.BodyPart.Body)<=0)bonus=0.5;}
        if(id=="kaguya") {hit=20;if(target!=null && a.getTile().getDistanceTo(target.getTile())==2) {bonus=0.5;pen=0.3;}}
        if(id=="prim") hit=10+::Math.floor(0.2*a.getCurrentProperties().getBravery());
        if(id=="luu_luu") {hit=15;bonus=0.25;pen=0.2;}
        p.MeleeSkill+=hit;p.DamageRegularMult+=bonus;p.DamageDirectMeleeAdd+=pen;
    }
    function onBeingAttacked(attacker,skill,p)
    {
        local f=this.f(),a=this.actor();if(!this.valid() || this.m.OwnerID!="celestine" || !f.api().isDirectAttack(skill)) return;
        local attempt=f.api().findValkyrieTargetAttempt(attacker,skill,a);if(attempt==null) return;
        local s=f.state(a);if(s.DivineRound!=f.round()) {s.DivineRound=f.round();s.DivineToken=attempt.Context.ActionToken;}
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        local f=this.f(),a=this.actor();if(!this.valid()) return;
        local n=f.stage(a),id=this.m.OwnerID,s=f.state(a),direct=skill!=null && f.api().isDirectAttack(skill);
        if(id=="claudia" && a.getArmor(::Const.BodyPart.Body)>0 && f.armed(a)) p.DamageReceivedArmorMult*=0.8;
        
        if(direct && id=="chloe" && n>=3 && f.guard(a)) p.DamageReceivedTotalMult*=0.7;
        if(direct && id=="celestine")
        {
            local attempt=f.api().findValkyrieTargetAttempt(attacker,skill,a);
            if(attempt!=null)
            {
                if(s.DivineRound!=f.round()){s.DivineRound=f.round();s.DivineToken=attempt.Context.ActionToken;}
                if(s.DivineToken==attempt.Context.ActionToken) p.DamageReceivedTotalMult*=0.5;
            }
        }
    }
    function onMissed(attacker,skill)
    {
        local f=this.f(),a=this.actor();if(!this.valid() || this.m.OwnerID!="alicia" || !f.able(a) || !f.armed(a) || !f.guard(a) || !f.enemy(a,attacker,1)) return;
        local s=f.state(a),p=a.getCurrentProperties();
        if(s.Countering || p.IsRooted || !p.IsAbleToUseWeaponSkills || skill==null || skill.isRanged() || !skill.isAttack() || skill.m.IsAOE) return;
        local c=f.api().getCurrentValkyrieActionContext(attacker,skill);if(!f.paid(c)) return;
        s.Countering=true; local result=null;
        try {result=f.api().applyValkyrieWeaponAttack(a,this,attacker,{WeaponDamageMult=f.stage(a)>=4?1.5:1.0,DirectDamageOverride=::Math.min(1.0,f.weapon(a).m.DirectDamageMult+0.25),HitChance=0,IgnoreDistance=true,ParentActionToken=c.ActionToken,Source="counter"});}
        catch(e){s.Countering=false;throw e;}
        s.Countering=false;
        if(result!=null && result.Hit) f.addStacks(a,1);
        if(f.alive(a) && s.CounterRefund<30) {local amount=::Math.min(5,30-s.CounterRefund);s.CounterRefund+=amount;f.refund(a,amount);}
    }
    function onValkyrieCombatEvent(e)
    {
        local f=this.f(),a=this.actor();if(!this.valid() || (e.Type!="TargetResolved" && e.Type!="DamageResolved") || e.Attacker!=a || e.Skill==null)return;
        if(e.Type=="DamageResolved" && this.m.OwnerID=="claudia" && f.armed(a) && f.directWeapon(e.Skill) && f.paid(f.api().getCurrentValkyrieActionContext(a,e.Skill)))
        {
            if(e.Before.HeadArmor>0 && e.After.HeadArmor<=0 || e.Before.BodyArmor>0 && e.After.BodyArmor<=0)f.refund(a,12,"armor_break");
            return;
        }
        if(e.Type!="TargetResolved" || !e.Hit || ("Nullified" in e && e.Nullified) || !f.paid(e)) return;
        local id=this.m.OwnerID,n=f.stage(a),s=f.state(a),b=e.Target;
        if(!f.armed(a)) return;
        if(id=="alicia" && e.Skill.isAttack())
        {
            if(!(e.ActionToken in s.HitActions)) {s.HitActions[e.ActionToken]<-true;f.addStacks(a,1);if(n>=4 && !("extra_stack" in s.Refunds)){s.Refunds.extra_stack<-true;f.addStacks(a,1);}}
            if(n>=1 && f.alive(b)) f.effect(b,"exposed",a);
        }
        if(id=="claudia" && f.directWeapon(e.Skill) && f.alive(b)) f.shatter(a,b);
        if(id=="kaguya" && f.directWeapon(e.Skill) && f.alive(b)) f.seal(a,b);
        if(id=="luu_luu" && f.directWeapon(e.Skill) && e.Skill.getID()!="actives.split_shield" && s.PressureAction==e.ActionToken && b!=null)s.PressureTargets[b.getID()]<-true;
    }
    function onTurnStart() { this.f().normalStart(this.actor()); }
    function onCombatStarted() { this.f().startCombat(this.actor()); }
    function onCombatFinished() { this.f().finishCombat(this.actor()); this.skill.onCombatFinished(); }
    function onDeath(fatality) { this.f().finishCombat(this.actor()); }
});
