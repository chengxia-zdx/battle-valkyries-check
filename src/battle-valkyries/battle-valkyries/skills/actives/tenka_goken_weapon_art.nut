this.tenka_goken_weapon_art <- this.inherit("$bvvar{privateFolder}/skills/actives/tenka_goken_active_skill", {
    function onVerifyTarget(origin,tile)
    {
        if(!this.tenka_goken_active_skill.onVerifyTarget(origin,tile))return false;
        if(this.m.Spec.Art=="step")return origin.getDistanceTo(tile)<=(this.f().isOwner(this.actor(),this.m.Spec)?3:2);
        return true;
    }
    function onUse(a,tile)
    {
        local f=this.f(),d=this.m.Spec,s=f.state(a),c=f.api().getCurrentValkyrieActionContext(a,this);
        if(this.unavailable()!=null||!this.onVerifyTarget(a.getTile(),tile)||!f.paid(c)||c.ActionToken in s.Actions)return false;
        s.Actions[c.ActionToken]<-true;s.Cooldowns[this.m.BVSkillKey]<-f.round()+d.CD;
        if(d.Art=="guard"){s.WeaponGuardUntil=s.Starts+1;s.WeaponGuardSpent=false;}
        else if(d.Art=="step")
        {
            s.Footwork=true;
            return f.move(a,f.api().EightValkyries.path(a,tile,f.isOwner(a,d)?3:2),this.onFlowerStepArrived.bindenv(this));
        }
        else if(d.Art=="advance")
        {
            s.Footwork=true;local data={Target=f.api().makeValkyrieCombatWeakRef(tile.getEntity()),Token=c.ActionToken};
            return f.move(a,f.approach(a,tile.getEntity()),this.onApproachArrived.bindenv(this),data);
        }
        else this.attack(a,tile.getEntity(),c.ActionToken);
        if(f.alive(a)){a.getSkills().update();a.setDirty(true);}
        return true;
    }
    function onFlowerStepArrived(a,data)
    {
        if(!this.canResolveMovement(a))return;
        local s=this.f().state(a);s.FlowerUntil=s.Starts+1;
        a.getSkills().update();
    }
    function attack(a,b,token)
    {
        local f=this.f();if(!f.able(a)||!f.enemy(a,b))return;
        local d=clone this.m.Spec,owner=f.isOwner(a,d),s=f.state(a);
        if(owner&&d.Art=="advance")d.D=1.20;
        if(owner&&d.Art=="flash")d.Pierce=0.15;
        local r=f.strike(a,this,b,d,f.beginSword(a,d.Art,b),token);
        if(!f.alive(a))return;
        if(owner&&r.Hit&&d.Art=="advance")f.refund(a,4);
        if(owner&&r.Hit&&d.Art=="intercept"&&f.alive(b)){s.InterceptTarget=f.api().makeValkyrieCombatWeakRef(b);s.InterceptUntil=f.ends(a)+2;}
        f.hitRecovery(a,r.Hit);f.observe(a,b);f.chain(a,d.Art,b);
    }
    function onUpdate(p)
    {
        local a=this.actor(),f=this.f(),d=this.m.Spec;
        if(a==null||!f.armed(a)||!f.validWeaponSkill(a,d))return;
        local s=f.state(a),owner=f.isOwner(a,d);
        if(d.Art=="guard"&&s.Starts<s.WeaponGuardUntil)
        {
            // Only top up the same actor's existing breathing/guard defenses.
            local existing=owner?((s.Starts<s.GuardUntil?12:0)+(s.Breath&&f.ends(a)<s.BreathEnd?6:0)):0;
            p.MeleeDefense+=::Math.max(0,(owner?14:10)-existing);
        }
        if(d.Art=="step"&&s.Starts<s.FlowerUntil&&!(owner&&s.Starts<s.MoveUntil)){p.MeleeDefense+=owner?10:6;p.RangedDefense+=owner?10:6;}
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        local f=this.f(),a=this.actor();if(this.m.Spec.Art!="guard"||!f.able(a)||!f.validWeaponSkill(a,this.m.Spec)||attacker==null||attacker.isAlliedWith(a)||skill==null||skill.isRanged()||!skill.isAttack()||skill.m.IsAOE)return;
        local s=f.state(a),attempt=f.api().findValkyrieTargetAttempt(attacker,skill,a);
        if(s.Starts>=s.WeaponGuardUntil||s.WeaponGuardSpent||attempt==null||!f.paid(attempt.Context))return;
        // A stronger character protection takes priority and does not spend this stance.
        if(f.supported(a)&&(!s.Parried||("BVTenkaProtected" in hit&&hit.BVTenkaProtected)))return;
        s.WeaponGuardSpent=true;p.DamageReceivedTotalMult*=0.80;
    }
});
