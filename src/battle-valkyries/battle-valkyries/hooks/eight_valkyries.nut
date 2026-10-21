// The only new damage boundary is post-armor HP absorption/transfer. Attacks
// continue through the existing shared action adapter; no second skill hook.
::$bvvar{namespace}.MH.hook("scripts/items/item_container",function(q){
    q.equip=@(__original) function(item)
    {
        if(item!=null&&item.getSlotType()!=::Const.ItemSlot.Bag)
        {
            local id=item.getID(),owner=id=="$bvvar{modId}.weapon.mika_quis_ut_deus"?"misono_mika":(id=="$bvvar{modId}.weapon.hina_the_end_destroyer"?"sorasaki_hina":null);
            if(owner!=null&&(!this.getActor().isPlayerControlled()||::$bvvar{namespace}.getActorValkyrieID(this.getActor())!=owner))return false;
        }
        return __original(item);
    }
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q){
    q.onTurnStart=@(__original) function()
    {
        local e=::$bvvar{namespace}.EightValkyries;
        this.m.BVEightExtraActive<-!e.normal(this);
        if(!this.m.BVEightExtraActive&&(!("BVEightTurnRound" in this.m)||this.m.BVEightTurnRound!=e.round()))
        {this.m.BVEightNormalActive<-true;this.m.BVEightTurnRound<-e.round();}
        return __original();
    }
    q.onTurnResumed=@(__original) function()
    {
        this.m.BVEightExtraActive<-!::$bvvar{namespace}.EightValkyries.normal(this);
        return __original();
    }
    q.onTurnEnd=@(__original) function()
    {
        if("BVEightNormalActive" in this.m&&this.m.BVEightNormalActive&&!("BVEightExtraActive" in this.m&&this.m.BVEightExtraActive))
        {this.m.BVEightNormalEnds<-("BVEightNormalEnds" in this.m?this.m.BVEightNormalEnds:0)+1;this.m.BVEightNormalActive=false;}
        return __original();
    }
    q.onMovementStep=@(__original) function(tile,level)
    {
        local ap=this.getActionPoints(),result=__original(tile,level);
        if(result)::$bvvar{namespace}.EightValkyries.moved(this,tile,this.getActionPoints()<ap);
        return result;
    }
    q.onMovementFinish=@(__original) function(tile)
    {
        local result=__original(tile),e=::$bvvar{namespace}.EightValkyries;
        e.moved(this,tile,false);e.refreshFields();return result;
    }
    q.onDamageReceived=@(__original) function(attacker,skill,hit)
    {
        local old="BVEightHit" in this.m?this.m.BVEightHit:null;
        this.m.BVEightHit<-{Attacker=attacker,Skill=skill,Hit=hit};local result=null;
        try{result=__original(attacker,skill,hit);}
        catch(ex){this.m.BVEightHit=old;throw ex;}
        this.m.BVEightHit=old;return result;
    }
});
// onCombatStart is defined by player, not actor in the base game.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player",function(q){
    q.onCombatStart=@(__original) function()
    {
        this.m.BVEightNormalEnds<-0;this.m.BVEightTurnRound<--1;this.m.BVEightNormalActive<-false;this.m.BVEightExtraActive<-false;
        return __original();
    }
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q){
    q.onDamageReceived=@(__original) function(attacker,hp,armor)
    {
        local actor=this.getActor(),e=::$bvvar{namespace}.EightValkyries;
        if(hp<=0||!e.alive(actor)||!("BVEightHit" in actor.m)||actor.m.BVEightHit==null)return __original(attacker,hp,armor);
        local frame=actor.m.BVEightHit,originalHP=hp,absorbed=0,ownShield=0;
        if(::$bvvar{namespace}.getValkyrieFixedDamageFrameForHit(frame.Hit,actor,attacker,frame.Skill)!=null)return __original(attacker,hp,armor);
        // Shields absorb ordinary post-armor HP damage; charging/guard require paid hostile attacks.
        local attempt=::$bvvar{namespace}.findValkyrieTargetAttempt(attacker,frame.Skill,actor);
        local paid=attempt!=null&&e.paid(attempt.Context)&&attacker!=null&&!attacker.isAlliedWith(actor)&&frame.Skill!=null&&frame.Skill.isAttack();
        foreach(effect in clone this.m.Skills)
            if(effect!=null&&"Kind" in effect.m&&effect.m.Kind=="shield"&&!effect.isGarbage()&&"valid" in effect&&effect.valid())
            {
                local take=::Math.min(hp,effect.m.Amount);effect.m.Amount-=take;hp-=take;absorbed+=take;
                if(effect.source()==actor)ownShield+=take;
                if(effect.m.Amount<=0)effect.removeSelf();
            }
        local s=e.state(actor);
        if(paid&&s!=null&&s.ID=="argente")
        {s.DamageProgress+=::Math.min(hp,actor.getHitpoints())+ownShield;if(s.DamageProgress>=60)e.gainOnce(actor,"damage",1);}
        if(paid&&hp>0)
        {
            foreach(guard in ::World.getPlayerRoster().getAll())
            {
                if(guard==actor||!e.able(guard)||e.owner(guard)!="argente"||!e.ally(guard,actor,false)||!e.los(guard.getTile(),actor.getTile(),2))continue;
                local gs=e.state(guard),single=gs.Turn<gs.GuardUntil&&::$bvvar{namespace}.readValkyrieCombatWeakRef(gs.Guard)==actor;
                if(!single&&e.findEffect(actor,guard,"guard")==null)continue;
                local token=attempt.Context.ActionToken;
                local used=token in gs.GuardBudget?gs.GuardBudget[token]:0;
                if(!(token in gs.GuardBudget)&&gs.GuardCount>=2)continue;
                local transfer=::Math.min(35-used,::Math.floor(hp*0.35));
                if(transfer<=0)break;
                if(!(token in gs.GuardBudget)){gs.GuardCount++;gs.GuardBudget[token]<-0;}
                gs.GuardBudget[token]+=transfer;hp-=transfer;absorbed+=transfer;
                guard.setHitpoints(::Math.max(0,guard.getHitpoints()-transfer));guard.setDirty(true);
                e.feedback(guard,guard,"argente_silver_guard","apply");
                if(guard.getHitpoints()<=0)guard.kill(attacker,frame.Skill,::Const.FatalityType.None);
                break;
            }
        }
        if(absorbed>0)
        {
            // Same engine boundary as the existing Yixuan sanctuary ward.
            // actor.onDamageReceived subtracts its original local HP amount next.
            actor.m.Hitpoints+=absorbed;frame.Hit.DamageInflictedHitpoints=hp;
            if("InjuryThresholdMult" in frame.Hit)frame.Hit.InjuryThresholdMult=hp<=0?0:frame.Hit.InjuryThresholdMult*originalHP/hp.tofloat();
        }
        return __original(attacker,hp,armor);
    }
});
