// Durable progress/loadouts use actor flags. Battle state survives managed-skill repair only.
::$bvvar{namespace}.FiveValkyries <- {
    function join(values,separator){local out="";foreach(i,v in values)out+=(i==0?"":separator)+v;return out;}
    function api(){return ::$bvvar{namespace};}
    function shared(){return this.api().EightValkyries;}
    function alive(a){return this.shared().alive(a);}
    function able(a){return this.shared().able(a);}
    function owner(a){return this.shared().owner(a);}
    function normal(a){return this.shared().normal(a);}
    function round(){return ::Time.getRound();}
    function paid(e){return this.shared().paid(e);}
    function ally(a,b,self=true){return this.shared().ally(a,b,self);}
    function enemy(a,b,r){return this.shared().enemy(a,b,r);}
    function enemies(a,t,r,range,limit,primary=null){return this.shared().enemies(a,t,r,range,limit,primary);}
    function allies(a,t,r,self=true){return this.shared().allies(a,t,r,self);}
    function supported(a){local id=this.owner(a);return a!=null&&a.isPlayerControlled()&&id!=null&&id in this.api().FiveDefinitions;}
    function progress(a)
    {
        if(a==null)return 0;
        local v=a.getFlags().get("$bvvar{modId}.five.progress");
        return typeof v=="integer"?::Math.max(0,::Math.min(180,v)):0;
    }
    function loadout(a,id=null)
    {
        if(id==null)id=this.owner(a);
        if(id==null||!(id in this.api().FiveDefinitions))return [];
        local d=this.api().FiveDefinitions[id],points=this.progress(a),result=[],raw=a==null?null:a.getFlags().get("$bvvar{modId}.five.loadout"),keys=[];
        if(typeof raw=="string")keys=::split(raw,"|");
        foreach(k in keys)foreach(o in d.Options)if(o.Key==k&&points>=o.Unlock&&result.find(k)==null&&result.len()<d.Slots)result.push(k);
        foreach(o in d.Options)if(result.len()<d.Slots&&points>=o.Unlock&&result.find(o.Key)==null)result.push(o.Key);
        return result;
    }
    function entitled(a,d)
    {
        if(!this.supported(a)||this.owner(a)!=d.FiveOwner)return false;
        if(d.Kind=="passive")return true;
        local points=this.progress(a),options=this.api().FiveDefinitions[d.FiveOwner].Options;
        foreach(o in options)if(o.Icon==d.Icon)return points>=o.Unlock&&this.loadout(a).find(o.Key)!=null;
        return d.Icon!="tohsaka_rin_double_formula"||points>=100;
    }
    function state(a)
    {
        if(!this.supported(a))return null;
        if(!("BVFiveState" in a.m)||a.m.BVFiveState==null)
        {
            local id=this.owner(a),d=this.api().FiveDefinitions[id],load=this.loadout(a);
            a.m.BVFiveState <- {ID=id,Resource=d.Start,Cap=d.Cap,Round=-1,Gains={},Cooldowns={},Turn=0,LastTurn=-1,
                Primary=load.len()>0?load[0]:null,Secondary=load.len()>1?load[1]:null,Loadout=load,UsedGems={},BattleGems={},
                Shadows=0,ShadowUntil=0,ReplayUsed=false,Wings=false,Rush=null,Gap=null,Snapshot=null,Effects=[],Marks={},Kills={},Actions={},Pending=0,Finalized=false,Participated=false};
        }
        local s=a.m.BVFiveState;
        if(s.Round!=this.round()){s.Round=this.round();s.Gains={};s.Actions={};}
        return s;
    }
    function resource(a,n){local s=this.state(a);if(s!=null)s.Resource=::Math.max(0,::Math.min(s.Cap,s.Resource+n));}
    function gain(a,key,n,limit=1)
    {
        local s=this.state(a);if(s==null)return false;local used=key in s.Gains?s.Gains[key]:0;
        if(used>=limit)return false;s.Gains[key]<-used+1;this.resource(a,n);return true;
    }
    function ready(a,key){local s=this.state(a);return s!=null&&(!(key in s.Cooldowns)||s.Turn>=s.Cooldowns[key]);}
    function snapshot(a){return {HP=a.getHitpoints(),Fatigue=a.getFatigue(),AP=a.getActionPoints(),Tile=a.getTile()};}
    function turn(a)
    {
        local s=this.state(a);if(s==null||!this.normal(a)||s.LastTurn==this.round())return;
        s.LastTurn=this.round();s.Turn++;s.Participated=true;s.Wings=false;s.Gap=null;
        if(s.Turn>1&&(s.ID=="tohsaka_rin"||s.ID=="tokisaki_kurumi"))this.resource(a,2);
        if(s.Turn>=s.ShadowUntil)s.Shadows=0;
        local remaining=[];
        foreach(ref in s.Effects)
        {
            local effect=this.api().readValkyrieCombatWeakRef(ref);if(effect==null||effect.isGarbage())continue;
            if(!effect.valid())
            {
                local container=effect.getContainer();effect.removeSelf();
                if(container!=null){container.update();container.getActor().setDirty(true);}
            }
            else remaining.push(ref);
        }
        s.Effects=remaining;
        s.Snapshot=this.snapshot(a);
    }
    function clock(a)
    {
        if(!("BVFiveClock" in a.m)||a.m.BVFiveClock==null)a.m.BVFiveClock<-{Round=-1,Starts=0,Ends=0,Active=false,Extra=false,Snapshot=null,FreezeResistUntil=-1};
        return a.m.BVFiveClock;
    }
    function canDebuff(a){return this.shared().debuffable(a);}
    function canStop(a)
    {
        if(!this.alive(a)||!this.canDebuff(a))return false;
        local p=a.getCurrentProperties();return !("IsImmuneToStun" in p)||!p.IsImmuneToStun;
    }
    function effect(a,source,kind,amount=0,defense=0)
    {
        if(!this.alive(a)||!this.alive(source))return null;
        local id="$bvvar{modId}.effects.five_"+kind+(kind=="shield"?"_"+source.getID():"");
        local e=a.getSkills().getSkillByID(id);
        if(e==null){e=::new("$bvvar{privateFolder}/skills/effects/five_valkyries_effect");e.configure(source,kind,id);a.getSkills().add(e);}
        else e.m.Source=this.api().makeValkyrieCombatWeakRef(source);
        local s=this.state(source);
        if(s!=null)
        {
            local found=false;
            foreach(ref in s.Effects)if(this.api().readValkyrieCombatWeakRef(ref)==e){found=true;break;}
            if(!found)s.Effects.push(this.api().makeValkyrieCombatWeakRef(e));
        }
        e.m.Amount=::Math.max(e.m.Amount,amount);e.m.Defense=::Math.max(e.m.Defense,defense);
        e.m.SourceTurn=s==null?0:s.Turn+1;e.m.TargetStart=this.clock(a).Starts+1;e.m.TargetEnd=this.clock(a).Ends+(kind=="burn"?2:1);e.m.AppliedRound=this.round();
        if(kind=="burn")e.m.Ticks=2;
        a.getSkills().update();a.setDirty(true);return e;
    }
    function shield(a,source,amount,defense=0)
    {
        local e=this.effect(a,source,"shield",amount,defense);
        if(e!=null)e.m.Amount=amount;return e;
    }
    function findEffect(a,kind)
    {
        if(a==null)return null;local e=a.getSkills().getSkillByID("$bvvar{modId}.effects.five_"+kind);
        return e!=null&&!e.isGarbage()&&e.valid()?e:null;
    }
    function control(a,source,kind,amount=0)
    {
        if(!this.canDebuff(a)||(kind=="stop"&&!this.canStop(a)))return false;
        this.effect(a,source,kind,amount);return true;
    }
    function fixed(a,skill,b,n,key)
    {
        if(!this.alive(a)||!this.alive(b)||b.isAlliedWith(a))return false;
        local tile=b.getTile(),position=this.api().captureValkyrieSkillAudioPosition(b),token=this.api().pushValkyrieCombatSource("followup",a,{Skill=skill}),result=null;
        try{result=this.api().applyValkyrieFixedHitpointDamage(a,skill,b,n);}
        catch(ex){this.api().popValkyrieCombatSource(token);throw ex;}
        this.api().popValkyrieCombatSource(token);
        if(result.Applied)this.feedback(a,{getTile=function(){return tile;}},key,"impact",true,position);
        return result.Applied;
    }
    function chill(a,skill,b,n)
    {
        if(!this.alive(b)||this.findEffect(b,"freeze")!=null)return;
        local e=this.findEffect(b,"chill"),total=(e==null?0:e.m.Amount)+n;
        if(total<3){e=this.effect(b,a,"chill",total);e.m.Amount=total;return;}
        if(e!=null)e.removeSelf();
        if(!this.canStop(b)){this.fixed(a,skill,b,100,"cirno_perfect_freeze");return;}
        if(this.round()<this.clock(b).FreezeResistUntil)return;
        this.effect(b,a,"freeze");this.feedback(a,b,"cirno_perfect_freeze","apply");
    }
    function burn(a,b){if(this.alive(b)&&this.canDebuff(b))this.effect(b,a,"burn",20);}
    function move(a,dest)
    {
        if(!this.alive(a)||dest==null||!dest.IsEmpty||!dest.IsVisibleForEntity||a.getCurrentProperties().IsRooted)return false;
        a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);::Tactical.getNavigator().teleport(a,dest,null,null,false);return a.getTile().ID==dest.ID;
    }
    function rush(a,dest)
    {
        local s=this.state(a);if(s==null||s.ID!="shana"||s.Rush!=null||!this.able(a))return false;
        local path=this.shared().path(a,dest,3);if(path==null||!dest.IsVisibleForEntity)return false;
        local tag={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Turn=s.Turn,Path=path,Index=0,Finished=false,Hold=null};
        local service=this;
        tag.Hold=this.api().beginValkyrieMovement(a,function(){service.finishRush(tag,false);});
        if(tag.Hold==null)return false;
        s.Rush=tag;
        try{this.rushNext(a,tag);}
        catch(ex){this.finishRush(tag,false);throw ex;}
        return true;
    }
    function finishRush(tag,completed)
    {
        if(tag.Finished)return;
        tag.Finished=true;tag.State.Rush=null;
        local a=this.api().readValkyrieCombatWeakRef(tag.Actor);
        if(completed)tag.State.Wings=true;
        // Release the paid action exactly once, including interruption and stale callbacks.
        this.api().endValkyrieMovement(tag.Hold);
    }
    function cancelRush(a)
    {
        if(a!=null&&"BVFiveState" in a.m&&a.m.BVFiveState!=null&&a.m.BVFiveState.Rush!=null)
            this.finishRush(a.m.BVFiveState.Rush,false);
    }
    function rushNext(a,tag)
    {
        if(tag.Finished)return;
        if(!this.able(a)||!this.supported(a)||a.m.BVFiveState!=tag.State||tag.State.Turn!=tag.Turn||a.getCurrentProperties().IsRooted)
        {this.finishRush(tag,false);return;}
        if(tag.Index>=tag.Path.len()){this.finishRush(tag,true);return;}
        local origin=a.getTile(),t=tag.Path[tag.Index];
        if(!t.IsEmpty||!t.IsVisibleForEntity||origin.getDistanceTo(t)!=1||::Math.abs(origin.Level-t.Level)>1)
        {this.finishRush(tag,false);return;}
        // Navigator.teleport is asynchronous. Queue the next tile only after this arrival.
        local step={Rush=tag,Index=tag.Index,Tile=t};
        a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
        ::Tactical.getNavigator().teleport(a,t,this.onRushStep.bindenv(this),step,false);
    }
    function onRushStep(a,step)
    {
        local tag=step.Rush;
        if(tag.Finished||tag.Index!=step.Index||("Queued" in step&&step.Queued))return;
        step.Queued<-true;
        this.api().queueValkyrieMovementArrival(tag.Hold,this.onRushArrived.bindenv(this),step);
    }
    function onRushArrived(a,step)
    {
        local tag=step.Rush;
        if(tag.Finished||tag.Index!=step.Index)return;
        try
        {
            if(!this.api().sameValkyrieCombatObject(tag.Actor,a)||!this.alive(a)||a.getTile().ID!=step.Tile.ID)
            {this.finishRush(tag,false);return;}
            tag.Index++;this.rushNext(a,tag);
        }
        catch(ex){this.finishRush(tag,false);throw ex;}
    }
    function rewind(a,snapshot,position=false)
    {
        if(!this.alive(a)||snapshot==null)return false;
        a.setHitpoints(::Math.min(a.getHitpointsMax(),::Math.max(a.getHitpoints(),snapshot.HP)));
        a.setFatigue(::Math.min(a.getFatigue(),snapshot.Fatigue));
        if(position){if(snapshot.Tile!=null&&snapshot.Tile.IsEmpty)this.move(a,snapshot.Tile);a.setActionPoints(::Math.min(a.getActionPointsMax(),snapshot.AP));}
        a.setDirty(true);return true;
    }
    function line(a,tile)
    {
        local out=[],origin=a.getTile(),dir=origin.getDirectionTo(tile),current=origin;
        for(local n=0;n<6;n++){if(!current.hasNextTile(dir))break;current=current.getNextTile(dir);if(!current.IsVisibleForEntity||!origin.hasLineOfSightTo(current,6))break;out.push(current);}
        return out;
    }
    function feedback(a,target,key,event="cast",sound=true,position=null)
    {
        this.api().playValkyrieVisual(a,target,"five_"+key+"_"+event);
        if(sound)this.api().playValkyrieSkillAudio(a,"five_"+key+"_"+event,position==null?this.api().captureValkyrieSkillAudioPosition(target):position);
    }
    function mark(a,b){if(this.alive(b))this.state(a).Marks[b.getID()]<-true;}
    function eligibleKill(b)
    {
        if(b==null)return false;
        try{if("isSummoned" in b&&b.isSummoned())return false;foreach(k in ["IsSummoned","IsIllusion","BattleValkyriesDebugSpawn"])if(b.getFlags().has(k)&&b.getFlags().get(k))return false;}
catch(ex){}
        return true;
    }
    function elite(b)
    {
        if(b==null)return false;
        try{if(b.getSkills().hasSkill("racial.champion"))return true;if("isChampion" in b&&b.isChampion())return true;}
catch(ex){}
        try{return b.getXPValue()>=400;}
catch(ex){return false;}
    }
    function killed(victim,killer,killingSkill=null)
    {
        if(killer==null||victim==null||killer.isAlliedWith(victim))return;
        local context=this.api().getCurrentValkyrieActionContext(killer);
        local source=this.api().getCurrentValkyrieCombatSource(killer,killingSkill);
        local paidKill=this.paid(context)&&(source==null||source.Source!="followup");
        foreach(a in ::World.getPlayerRoster().getAll())
        {
            if(!this.alive(a)||!this.supported(a)||!a.isAlliedWith(killer))continue;
            local s=this.state(a),id=victim.getID();if(id in s.Kills)continue;s.Kills[id]<-true;
            if(s.ID=="tokisaki_kurumi"&&(killer==a||id in s.Marks))
            {if(paidKill)this.gain(a,"kill",2,2);if(this.eligibleKill(victim))s.Pending=::Math.min(14,s.Pending+(this.elite(victim)?3:1));}
            if(s.ID=="tohsaka_rin"&&killer==a&&this.eligibleKill(victim)&&this.elite(victim))s.Pending=::Math.min(10,s.Pending+4);
            if(s.ID=="shana"&&this.findEffect(victim,"burn")!=null&&(killingSkill==null||killingSkill.getID()!=this.api().getValkyrieSkillRuntimeID("shana_heavenly_flame")))this.gain(a,"burn_kill",1);
        }
    }
    function finish(victory)
    {
        foreach(a in ::World.getPlayerRoster().getAll())
        {
            if(!("BVFiveState" in a.m)||a.m.BVFiveState==null)continue;local s=a.m.BVFiveState;
            if(s.Finalized)continue;s.Finalized=true;
            if(victory&&s.Participated&&!this.api().isActorDeadOrDying(a)&&(s.ID=="tokisaki_kurumi"||s.ID=="tohsaka_rin"))
            {
                local amount=s.ID=="tokisaki_kurumi"?6+s.Pending:10+s.Pending+2*s.BattleGems.len();
                a.getFlags().set("$bvvar{modId}.five.progress",::Math.min(180,this.progress(a)+::Math.min(20,amount)));
            }
        }
    }
    function clear(a)
    {
        if(a==null||!("BVFiveState" in a.m)||a.m.BVFiveState==null)return;
        this.cancelRush(a);
        foreach(ref in a.m.BVFiveState.Effects)
        {
            local e=this.api().readValkyrieCombatWeakRef(ref);
            if(e!=null&&!e.isGarbage())
            {
                local container=e.getContainer();e.removeSelf();
                if(container!=null){container.update();container.getActor().setDirty(true);}
            }
        }
        a.m.BVFiveState=null;
    }
};
