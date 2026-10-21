// Identity is durable; all combat budgets stay on the actor, never on a skill.
::$bvvar{namespace}.TenkaGoken <- {
    function api() { return ::$bvvar{namespace}; }
    function round() { return ::Time.getRound(); }
    function alive(a) { return a != null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap(); }
    function owner(a) { return a == null ? null : this.api().getActorValkyrieID(a); }
    function supported(a) { local id = this.owner(a); return a != null && a.isPlayerControlled() && id != null && id in this.api().TenkaGokenWeapons; }
    function weapon(a) { return a == null ? null : a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand); }
    function armed(a)
    {
        local w = this.weapon(a);
        if (w == null || w.getCondition() <= 0 || !w.isItemType(::Const.Items.ItemType.MeleeWeapon)) return false;
        local sword="BVTenkaSword" in w.m&&w.m.BVTenkaSword;
        if(!sword)
        {
            local categories=w.m.Categories.tolower();
            sword=categories.find("sword")!=null||categories.find("剑")!=null||categories.find("劍")!=null;
        }
        if(!sword)return false;
        local p = a.getCurrentProperties();
        return p.IsAbleToUseWeaponSkills && a.getItems().getItemAtSlot(::Const.ItemSlot.Offhand) == null;
    }
    function able(a) { return this.alive(a) && a.isPlayerControlled() && a.getMoraleState() != ::Const.MoraleState.Fleeing && a.getCurrentProperties().IsAbleToUseSkills && !a.getCurrentProperties().IsStunned && this.armed(a); }
    function enemy(a,b,range=1) { return this.api().isEligibleValkyrieEnemyTarget(a,b,range,true) && ::Math.abs(a.getTile().Level-b.getTile().Level)<=1 && a.getTile().hasLineOfSightTo(b.getTile(),range); }
    function paid(e) { return e != null && "IsImplicit" in e && !e.IsImplicit && this.api().EightValkyries.paid(e); }
    function state(a)
    {
        if (a == null) return null;
        if (!("BVTenkaState" in a.m) || a.m.BVTenkaState == null)
            a.m.BVTenkaState <- { Round=-1, Starts=0, StartRound=-1, Cooldowns={}, Actions={}, CounterActions={}, Counters=0,
                Recovery=false, Parried=false, Footwork=false, First=false, Breath=false, BreathEnd=0,
                Chain=0, ChainTarget=null, ChainMode=null, ChainEnd=0, Observed=null, ObserveEnd=0,
                GuardUntil=0, MoveUntil=0, MoonUntil=0, WeaponGuardUntil=0, WeaponGuardSpent=false, FlowerUntil=0, InterceptTarget=null, InterceptUntil=0, RoseTarget=null, RoseRound=-1, LungeDiscount=false,
                LeapDiscount=false, CounterRefund=false, Moving=null, VanillaToken=null, VanillaTarget=null };
        local s=a.m.BVTenkaState;
        if (s.Round!=this.round())
        {
            s.Round=this.round();s.Actions={};s.CounterActions={};s.Counters=0;s.Recovery=false;s.Parried=false;
            s.Footwork=false;s.First=false;s.CounterRefund=false;s.LungeDiscount=false;s.LeapDiscount=false;s.VanillaToken=null;s.VanillaTarget=null;
        }
        return s;
    }
    function ends(a) { return "BVEightNormalEnds" in a.m ? a.m.BVEightNormalEnds : 0; }
    function turn(a)
    {
        local s=this.state(a);
        if (!this.api().EightValkyries.normal(a) || s.StartRound==this.round()) return;
        s.StartRound=this.round();s.Starts++;
        if (s.Breath && this.ends(a)>=s.BreathEnd) s.Breath=false;
        if (this.ends(a)>=s.ChainEnd) { s.Chain=0;s.ChainMode=null;s.ChainTarget=null; }
        if (this.ends(a)>=s.ObserveEnd) s.Observed=null;
    }
    function clear(a)
    {
        if (a==null || !("BVTenkaState" in a.m) || a.m.BVTenkaState==null) return;
        local s=a.m.BVTenkaState;
        if (s.Moving!=null) this.finishMove(s.Moving,false);
        a.m.BVTenkaState=null;
    }
    function ready(a,key) { local s=this.state(a);return !(key in s.Cooldowns)||s.Cooldowns[key]<=this.round(); }
    function isOwner(a,d) { return this.supported(a)&&this.owner(a)==d.Owner; }
    function validWeaponSkill(a,d)
    {
        local w=this.weapon(a);
        return w!=null&&w.getID()=="$bvvar{modId}.weapon."+this.api().TenkaGokenWeapons[d.Owner].Key;
    }
    function refund(a,n) { if (this.alive(a)) a.setFatigue(::Math.max(0,a.getFatigue()-n)); }
    function moved(a)
    {
        if (!this.supported(a)||!this.armed(a)) return;
        local s=this.state(a);s.MoveUntil=s.Starts+1;
        a.getSkills().update();a.setDirty(true);
    }
    function singlePaidAttack(e)
    {
        if (!this.paid(e)||!("Skill" in e)||e.Skill==null||!e.Skill.isAttack()||e.Skill.isRanged()) return false;
        try { if (e.Skill.m.IsAOE) return false; } catch(ex) {}
        return true;
    }
    function beginSword(a,mode,target,multi=false)
    {
        local s=this.state(a), id=this.owner(a), bonus=0.0;
        if (!this.supported(a)||multi) return bonus;
        if (id=="onigawara_rin"&&s.Breath&&this.ends(a)<s.BreathEnd)
        { bonus+=0.25;s.Breath=false;if(this.validWeaponSkill(a,{Owner=id}))this.refund(a,4); }
        if (id=="inaba_tsukuyo"&&!s.First) { s.First=true;bonus+=0.35; }
        return bonus;
    }
    function observe(a,b)
    {
        if (!this.supported(a)||b==null) return;
        local s=this.state(a);s.Observed=this.api().makeValkyrieCombatWeakRef(b);s.ObserveEnd=this.ends(a)+2;
    }
    function chain(a,mode,b)
    {
        if (this.owner(a)!="tamaba_satori"||b==null) return;
        local s=this.state(a), same=this.api().readValkyrieCombatWeakRef(s.ChainTarget)==b;
        // A legally executed different paid technique counts even when it misses.
        s.Chain = same && s.ChainMode!=mode ? ::Math.min(2,s.Chain+1) : 1;
        s.ChainMode=mode;s.ChainTarget=this.api().makeValkyrieCombatWeakRef(b);s.ChainEnd=this.ends(a)+2;
        this.observe(a,b);
    }
    function hitRecovery(a,hit)
    {
        if (!hit||!this.supported(a)) return;
        local s=this.state(a);if(s.Recovery)return;s.Recovery=true;this.refund(a,6);
    }
    function coordinated(a,b)
    {
        if(this.owner(a)!="hanasaka_warabi"||!this.alive(b)||b.isAlliedWith(a))return false;
        foreach(ally in ::World.getPlayerRoster().getAll())
            if(ally!=a&&this.alive(ally)&&ally.isAlliedWith(a)&&ally.getTile().getDistanceTo(b.getTile())==1)return true;
        return false;
    }
    function strike(a,skill,b,d,bonus=0.0,token=null,half=null,source="followup")
    {
        if(!this.able(a)||!this.enemy(a,b))return {Applied=false,Hit=false};
        local mult=d.D+bonus+(this.coordinated(a,b)?0.15:0.0);
        local s=this.state(a), accuracy=d.Hit;
        if(source!="riposte"&&(!("Art" in d)||d.Art!="intercept")&&this.validWeaponSkill(a,{Owner="tamaba_satori"})&&this.ends(a)<s.InterceptUntil&&this.api().readValkyrieCombatWeakRef(s.InterceptTarget)==b)
        { accuracy+=10;s.InterceptTarget=null; }
        if(source!="riposte"&&this.owner(a)=="kikakujo_mary"&&s.RoseRound==this.round()&&this.api().readValkyrieCombatWeakRef(s.RoseTarget)==b)
        { accuracy+=8;s.RoseTarget=null; }
        return this.api().applyValkyrieWeaponAttack(a,skill,b,{
            WeaponDamageMult=mult,ArmorDamageMult=mult*d.A,DirectDamageAdd=d.Pierce,DirectDamageCap=0.75,
            HitChance=accuracy,ShieldDefenseScale=(half==null?d.HalfShield:half)?0.5:1.0,
            ParentActionToken=token,Source=source });
    }
    function effect(source,target,kind,amount=0)
    {
        local id="$bvvar{modId}.effects.tenka."+kind+"."+source.getID();
        local e=target.getSkills().getSkillByID(id);
        if(e==null){e=::new("$bvvar{privateFolder}/skills/effects/tenka_goken_effect");e.m.ID=id;target.getSkills().add(e);}
        e.m.Source=this.api().makeValkyrieCombatWeakRef(source);e.m.Kind=kind;e.m.Amount=amount;
        e.m.Until=this.state(source).Starts+1;e.m.TargetStarts=this.state(target).Starts+1;
        // If its normal turn is already active, expire after the next one.
        local active="BVEightNormalActive" in target.m&&target.m.BVEightNormalActive;
        e.m.TargetEnd=this.ends(target)+(active?2:1);
        target.getSkills().update();target.setDirty(true);
    }
    function counter(a,passive,e)
    {
        if(e.Type!="TargetResolved"||e.Target!=a||e.Hit||!this.able(a)||!this.singlePaidAttack(e)||!this.enemy(a,e.Attacker))return;
        local s=this.state(a),id=this.owner(a);
        if(s.Counters>=2||e.ActionToken in s.CounterActions)return;
        if(a.getSkills().hasSkill("effects.riposte"))
        {s.VanillaToken=e.ActionToken;s.VanillaTarget=this.api().makeValkyrieCombatWeakRef(e.Attacker);return;}
        if(id=="tamaba_satori"||id=="hanasaka_warabi")return;
        local full=s.Starts<s.GuardUntil,shortGuard=id=="inaba_tsukuyo"&&s.Starts<s.MoonUntil;
        if(!full&&!shortGuard)return;
        local fatigue=id=="kikakujo_mary"?5:6;
        if(a.getFatigue()+fatigue>a.getFatigueMax())return;
        s.CounterActions[e.ActionToken]<-true;s.Counters++;if(!full)s.MoonUntil=0;
        a.setFatigue(a.getFatigue()+fatigue);
        local d={D=shortGuard&&!full?0.8:(id=="kikakujo_mary"?0.9:1.1),A=1.0,Hit=id=="onigawara_rin"?0:10,Pierce=0.0,HalfShield=false};
        local result=this.strike(a,passive,e.Attacker,d,0,e.ActionToken,null,"riposte");
        if(full&&id=="inaba_tsukuyo"&&result.Hit&&!s.CounterRefund&&this.alive(a)&&this.validWeaponSkill(a,{Owner=id}))
        {s.CounterRefund=true;this.refund(a,4);}
    }
    function approach(a,b)
    {
        if(!this.alive(b))return null;local best=null;
        for(local i=0;i<6;i++)if(b.getTile().hasNextTile(i))
        {
            local dest=b.getTile().getNextTile(i);
            if(::Math.abs(dest.Level-b.getTile().Level)>1)continue;
            local p=this.api().EightValkyries.path(a,dest,3);
            if(p!=null&&(best==null||p.len()<best.len()))best=p;
        }
        return best;
    }
    function move(a,path,done=null,data=null,provoke=false,ignore=null)
    {
        local s=this.state(a);if(!this.able(a)||path==null||path.len()==0||s.Moving!=null)return false;
        local tag={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Path=clone path,Index=0,Done=done,Data=data,
            Provoke=provoke,Ignore=ignore,Finished=false,Old=null,Hold=null};
        local service=this;
        tag.Hold=this.api().beginValkyrieMovement(a,function(){service.finishMove(tag,false);});
        if(tag.Hold==null)return false;
        s.Moving=tag;
        try{this.moveNext(tag);}catch(ex){this.finishMove(tag,false);throw ex;}
        return true;
    }
    function finishMove(tag,success)
    {
        if(tag.Finished)return;tag.Finished=true;
        local a=this.api().readValkyrieCombatWeakRef(tag.Actor),error=null;
        try{if(success&&this.able(a)&&tag.Done!=null)tag.Done(a,tag.Data);}catch(ex){error=ex;}
        tag.State.Moving=null;tag.Done=null;tag.Data=null;
        this.api().endValkyrieMovement(tag.Hold);
        if(this.alive(a))this.moved(a);
        if(error!=null)throw error;
    }
    function moveNext(tag)
    {
        local a=this.api().readValkyrieCombatWeakRef(tag.Actor);
        if(tag.Finished)return;
        if(!this.able(a)||this.state(a)!=tag.State||a.getCurrentProperties().IsRooted){this.finishMove(tag,false);return;}
        if(tag.Index>=tag.Path.len()){this.finishMove(tag,true);return;}
        local origin=a.getTile(),dest=tag.Path[tag.Index];
        if(!dest.IsEmpty||!dest.IsVisibleForEntity||origin.getDistanceTo(dest)!=1||::Math.abs(origin.Level-dest.Level)>1){this.finishMove(tag,false);return;}
        if(tag.Provoke)
            for(local i=0;i<6;i++)if(origin.hasNextTile(i)&&origin.getNextTile(i).IsOccupiedByActor)
            {
                local foe=origin.getNextTile(i).getEntity();
                if(this.alive(foe)&&!foe.isAlliedWith(a)&&foe!=this.api().readValkyrieCombatWeakRef(tag.Ignore)&&foe.hasZoneOfControl())
                    if(foe.onAttackOfOpportunity(a,false)||!this.able(a)){this.finishMove(tag,false);return;}
            }
        // Native tile handles are not stable object identities; compare map IDs.
        if(!this.able(a)||a.getCurrentProperties().IsRooted||a.getTile().ID!=origin.ID||!dest.IsEmpty){this.finishMove(tag,false);return;}
        tag.Old=origin;a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
        local step={Move=tag,Index=tag.Index,Tile=dest,Returning=false,Queued=false};
        ::Tactical.getNavigator().teleport(a,dest,this.arrived.bindenv(this),step,false);
    }
    function arrived(a,step)
    {
        local tag=step.Move;
        if(tag.Finished||tag.Index!=step.Index||step.Queued)return;
        step.Queued=true;
        // The native navigator still owns the trip during its arrival callback.
        this.api().queueValkyrieMovementArrival(tag.Hold,this.resolveArrival.bindenv(this),step);
    }
    function resolveArrival(a,step)
    {
        local tag=step.Move;
        if(tag.Finished||tag.Index!=step.Index)return;
        try
        {
            if(step.Returning||a!=this.api().readValkyrieCombatWeakRef(tag.Actor)||!this.able(a)
                ||this.state(a)!=tag.State||a.getCurrentProperties().IsRooted||a.getTile().ID!=step.Tile.ID)
            {this.finishMove(tag,false);return;}
            local dest=a.getTile();
            // Match vanilla Lunge: every entered tile tests hostile spearwalls.
            for(local i=0;i<6;i++)if(dest.hasNextTile(i)&&dest.getNextTile(i).IsOccupiedByActor)
            {
                local foe=dest.getNextTile(i).getEntity();
                if(!this.alive(foe)||foe.isAlliedWith(a)||foe.getCurrentProperties().IsStunned)continue;
                if(foe.onMovementInZoneOfControl(a,true)&&foe.onAttackOfOpportunity(a,true))
                {
                    if(this.alive(a)&&tag.Old.IsEmpty&&::Math.abs(tag.Old.Level-dest.Level)<=1)
                    {
                        local back={Move=tag,Index=tag.Index,Tile=tag.Old,Returning=true,Queued=false};
                        ::Tactical.getNavigator().teleport(a,tag.Old,this.arrived.bindenv(this),back,false);
                        return;
                    }
                    this.finishMove(tag,false);return;
                }
                if(!this.able(a)||a.getCurrentProperties().IsRooted){this.finishMove(tag,false);return;}
            }
            tag.Index++;this.moved(a);this.moveNext(tag);
        }
        catch(ex){this.finishMove(tag,false);throw ex;}
    }
    function arc(a,tile,count)
    {
        local out=[],origin=a.getTile(),direction=origin.getDirectionTo(tile);
        for(local i=0;i<count;i++)if(origin.hasNextTile((direction+i)%6))out.push(origin.getNextTile((direction+i)%6));
        return out;
    }
    function syncWeapon(a)
    {
        if(a==null||!a.isPlayerControlled())return;
        local w=this.weapon(a);
        foreach(id,d in this.api().TenkaGokenWeapons)
        {
            local token="$bvvar{modId}.owner.tenka."+d.Key;
            foreach(key in [id+"_weapon",d.Secondary])
            {
            if(w!=null&&w.getID()=="$bvvar{modId}.weapon."+d.Key)
            {
                local result=this.api().attachTransientSkill(a,key,token);
                if(!result.Success)throw "[Battle Valkyries] Cannot attach sword technique: "+key+" "+result.Code;
            }
            else this.api().detachTransientSkill(a,key,token);
            }
        }
    }
};
