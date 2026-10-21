// Combat-only state is kept on actors, so rebuilding managed skills cannot refill it.
::$bvvar{namespace}.EightValkyries <- {
    function api() { return ::$bvvar{namespace}; }
    function alive(a) { return a != null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap(); }
    function owner(a) { return a == null ? null : this.api().getActorValkyrieID(a); }
    function supported(a) { local id=this.owner(a); return id != null && id in this.api().EightValkyrieDefinitions && a.isPlayerControlled(); }
    function round() { return ::Time.getRound(); }
    function normal(a)
    {
        if(a==null||a.getSkills().hasSkill("$bvvar{modId}.effects.cerydra_command_turn"))return false;
        local robin=a.getSkills().getSkillByID("$bvvar{modId}.effects.robin_granted_action");
        return robin==null||!robin.m.BVIsExtraTurn;
    }
    function debuffable(a) { local p=a.getCurrentProperties();return !("IsImmuneToDebuffs" in p)||!p.IsImmuneToDebuffs; }
    function able(a)
    {
        if (!this.alive(a) || !a.isPlayerControlled() || a.getMoraleState()==::Const.MoraleState.Fleeing) return false;
        local p=a.getCurrentProperties();
        return p.IsAbleToUseSkills && !p.IsStunned;
    }
    function state(a)
    {
        if (!this.supported(a)) return null;
        if (!("BVEightState" in a.m) || a.m.BVEightState==null)
        {
            local id=this.owner(a), d=this.api().EightValkyrieDefinitions[id];
            a.m.BVEightState <- { ID=id, Resource=d.Start, Cap=d.Cap, Prestige=id=="lumiore"?1:0,
                Turn=0, LastTurnRound=-1, Round=-1, Cooldowns={}, Gains={}, Echo=false, Counters=0,
                Reflections=0, Previous=null, Pending={}, PrimaryTargets={}, GuardBudget={}, GuardCount=0, ShieldGift=false, DamageProgress=0,
                Field=null, FieldUntil=0, Study=null, StudyUntil=0, Guard=null, GuardUntil=0,
                WardUntil=0, WardToken=null, Moved=false, MoveAim=false, MoveTiles={}, StartTile=null,
                Retreat=false, RetreatUsed=false, CustomMove=false, Move=null, Effects=[] };
        }
        local s=a.m.BVEightState;
        if (s.Round!=this.round())
        {
            s.Round=this.round();s.Gains={};s.Echo=false;s.Counters=0;s.Reflections=0;s.Previous=null;
            s.GuardBudget={};s.GuardCount=0;s.ShieldGift=false;s.DamageProgress=0;s.MoveTiles={};s.RetreatUsed=false;
        }
        return s;
    }
    function resource(a, n) { local s=this.state(a); if(s!=null) s.Resource=::Math.max(0,::Math.min(s.Cap,s.Resource+n)); }
    function gainOnce(a,key,n,limit=1)
    {
        local s=this.state(a); if(s==null)return false;
        local used=key in s.Gains?s.Gains[key]:0;
        if(used>=limit)return false;
        s.Gains[key]<-used+1;this.resource(a,n);return true;
    }
    function ready(a,key) { local s=this.state(a);return s!=null&&(!(key in s.Cooldowns)||s.Turn>=s.Cooldowns[key]); }
    function resolve(a) { return ::Math.max(0,::Math.min(150,a.getCurrentProperties().getBravery())); }
    function weapon(a)
    {
        if(a==null)return null;
        return a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    }
    function armed(a,id)
    {
        local w=this.weapon(a);if(w==null)return false;
        if(id=="misono_mika")return w.getID()=="$bvvar{modId}.weapon.mika_quis_ut_deus";
        if(id=="sorasaki_hina")return w.getID()=="$bvvar{modId}.weapon.hina_the_end_destroyer";
        return w.isItemType(::Const.Items.ItemType.MeleeWeapon);
    }
    function los(a,b,range) { return a!=null&&b!=null&&a.getDistanceTo(b)<=range&&a.hasLineOfSightTo(b,range); }
    function enemy(a,b,range)
    {
        return this.api().isEligibleValkyrieEnemyTarget(a,b,range,true)&&::Math.abs(a.getTile().Level-b.getTile().Level)<=4&&this.los(a.getTile(),b.getTile(),range);
    }
    function ally(a,b,self=true)
    {
        return this.alive(a)&&this.alive(b)&&b.isPlayerControlled()&&((self&&a==b)||this.api().isEligibleRosterAlly(a,b));
    }
    function allies(a,center,radius,self=true)
    {
        local out=[];
        foreach(b in ::World.getPlayerRoster().getAll())
            if(this.ally(a,b,self)&&this.los(center,b.getTile(),radius))out.push(b);
        out.sort(function(x,y){if(x==y)return 0;local d=x.getHitpoints()/x.getHitpointsMax().tofloat()-y.getHitpoints()/y.getHitpointsMax().tofloat();return d<0?-1:(d>0?1:(x.getID()<y.getID()?-1:1));});
        return out;
    }
    function enemies(a,center,radius,range,limit,primary=null)
    {
        local out=[];
        foreach(b in this.api().getValkyrieEnemyTargetsOnTiles(a,this.api().getValkyrieRadiusTiles(center,radius,true)))
            if(this.enemy(a,b,range)&&this.los(center,b.getTile(),radius))out.push(b);
        out.sort(function(x,y){if(x==y)return 0;if(x==primary)return -1;if(y==primary)return 1;local d=center.getDistanceTo(x.getTile())-center.getDistanceTo(y.getTile());return d==0?(x.getID()<y.getID()?-1:1):d;});
        if(out.len()>limit)out.resize(limit);return out;
    }
    function adjacent(a) { return a.getTile().getZoneOfControlCountOtherThan(a.getAlliedFactions())>0; }
    function cone(a,primary)
    {
        local out=[],origin=a.getTile(),end=primary.getTile();
        local dx=end.Pos.X-origin.Pos.X,dy=end.Pos.Y-origin.Pos.Y;
        foreach(b in this.enemies(a,origin,6,6,999,primary))
        {
            if(origin.getDistanceTo(b.getTile())<2)continue;
            local x=b.getTile().Pos.X-origin.Pos.X,y=b.getTile().Pos.Y-origin.Pos.Y;
            local dot=x*dx+y*dy;
            if(dot>0&&dot*dot>=(x*x+y*y)*(dx*dx+dy*dy)*0.75-0.001)out.push(b);
        }
        if(out.len()>5)out.resize(5);return out;
    }
    function path(a,dest,limit)
    {
        if(!this.alive(a)||dest==null||!dest.IsEmpty||a.getCurrentProperties().IsRooted)return null;
        local start=a.getTile(),queue=[{Tile=start,Path=[]}],seen={};seen[start.ID]<-true;
        for(local i=0;i<queue.len();i++)
        {
            local e=queue[i];if(e.Path.len()>=limit)continue;
            for(local d=0;d<6;d++)if(e.Tile.hasNextTile(d))
            {
                local t=e.Tile.getNextTile(d);
                if(t.ID in seen||!t.IsEmpty||::Math.abs(t.Level-e.Tile.Level)>1)continue;
                seen[t.ID]<-true;local p=clone e.Path;p.push(t);
                if(t.ID==dest.ID)return p;
                queue.push({Tile=t,Path=p});
            }
        }
        return null;
    }
    function approach(a,target)
    {
        if(a.getTile().getDistanceTo(target.getTile())==1)return [];
        local best=null;
        for(local d=0;d<6;d++)if(target.getTile().hasNextTile(d))
        {
            local p=this.path(a,target.getTile().getNextTile(d),2);
            if(p!=null&&(best==null||p.len()<best.len()||(p.len()==best.len()&&p[p.len()-1].ID<best[best.len()-1].ID)))best=p;
        }
        return best;
    }
    function move(a,path,provoke=false,onDone=null,data=null)
    {
        local s=this.state(a);if(s==null||path==null||s.CustomMove)return false;
        if(path.len()==0){if(onDone!=null)onDone(a,data);return true;}
        local tag={Actor=this.api().makeValkyrieCombatWeakRef(a),State=s,Path=clone path,Index=0,
            Provoke=provoke,OnDone=onDone,Data=data,Finished=false,Hold=null};
        local service=this;
        tag.Hold=this.api().beginValkyrieMovement(a,function(){service.finishMove(tag,false);});
        if(tag.Hold==null)return false;
        s.Move=tag;s.CustomMove=true;
        // Keep the original paid action open until arrival and its attack resolve.
        try{this.moveNext(a,tag);}
        catch(ex){this.finishMove(tag,false);throw ex;}
        return true;
    }
    function finishMove(tag,completed)
    {
        if(tag.Finished)return;
        tag.Finished=true;
        local a=this.api().readValkyrieCombatWeakRef(tag.Actor),failed=null;
        try{if(completed&&this.able(a)&&tag.OnDone!=null)tag.OnDone(a,tag.Data);}
        catch(ex){failed=ex;}
        tag.State.Move=null;tag.State.CustomMove=false;tag.OnDone=null;tag.Data=null;
        this.api().endValkyrieMovement(tag.Hold);
        this.refreshFields();
        if(failed!=null)throw failed;
    }
    function cancelMove(a)
    {
        if(a!=null&&"BVEightState" in a.m&&a.m.BVEightState!=null&&a.m.BVEightState.Move!=null)
            this.finishMove(a.m.BVEightState.Move,false);
    }
    function moveNext(a,tag)
    {
        if(tag.Finished)return;
        if(!this.able(a)||a.m.BVEightState!=tag.State||a.getCurrentProperties().IsRooted)
        {this.finishMove(tag,false);return;}
        if(tag.Index>=tag.Path.len()){this.finishMove(tag,true);return;}
        local origin=a.getTile(),t=tag.Path[tag.Index];
        if(!t.IsEmpty||origin.getDistanceTo(t)!=1||::Math.abs(origin.Level-t.Level)>1)
        {this.finishMove(tag,false);return;}
        local stopped=false;
        if(tag.Provoke)
        {
            for(local d=0;d<6;d++)if(origin.hasNextTile(d))
            {
                local neighbor=origin.getNextTile(d);
                if(neighbor.IsOccupiedByActor)
                {
                    local foe=neighbor.getEntity();
                    if(this.alive(foe)&&!foe.isAlliedWith(a)&&foe.hasZoneOfControl()&&foe.onAttackOfOpportunity(a,false))stopped=true;
                    if(stopped||tag.Finished||!this.able(a)||a.getCurrentProperties().IsRooted)break;
                }
            }
        }
        if(stopped||tag.Finished||!this.able(a)||a.getCurrentProperties().IsRooted||!t.IsEmpty||a.getTile().ID!=origin.ID)
        {this.finishMove(tag,false);return;}
        // Each teleport is asynchronous; never queue the next tile before arrival.
        local step={Move=tag,Index=tag.Index,Tile=t};
        a.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
        ::Tactical.getNavigator().teleport(a,t,this.onMoveStep.bindenv(this),step,false);
    }
    function onMoveStep(a,step)
    {
        local tag=step.Move;
        if(tag.Finished||tag.Index!=step.Index||("Queued" in step&&step.Queued))return;
        step.Queued<-true;
        this.api().queueValkyrieMovementArrival(tag.Hold,this.onMoveArrived.bindenv(this),step);
    }
    function onMoveArrived(a,step)
    {
        local tag=step.Move;
        if(tag.Finished||tag.Index!=step.Index)return;
        try
        {
            if(a!=this.api().readValkyrieCombatWeakRef(tag.Actor)||!this.alive(a)||a.getTile().ID!=step.Tile.ID)
            {this.finishMove(tag,false);return;}
            tag.Index++;tag.State.Moved=true;tag.State.MoveAim=true;
            this.moveNext(a,tag);
        }
        catch(ex){this.finishMove(tag,false);throw ex;}
    }
    function moved(a,t,paid=false)
    {
        local s=this.state(a);if(s==null)return;s.Moved=true;
        if(s.CustomMove)return;
        if(paid)
        {
            s.MoveAim=true;
            if(s.ID=="sekka"&&t.ID!=s.StartTile)
            {
                s.MoveTiles[t.ID]<-true;
                if(s.MoveTiles.len()>=2)this.gainOnce(a,"walk",2);
            }
        }
    }
    function heal(a,n)
    {
        if(!this.alive(a))return false;local before=a.getHitpoints();
        a.setHitpoints(::Math.min(a.getHitpointsMax(),before+::Math.floor(n)));a.setDirty(true);
        return a.getHitpoints()>before;
    }
    function cleanse(a)
    {
        foreach(id in ["effects.bleeding","effects.goblin_poison","effects.spider_poison","effects.poison"])
            if(a.getSkills().hasSkill(id)){a.getSkills().removeByID(id);return true;}
        return false;
    }
    function effect(a,source,kind,turns,amount=0)
    {
        if(!this.alive(a)||!this.alive(source))return null;
        local id="$bvvar{modId}.effects.eight_"+kind+"_"+source.getID();
        local e=a.getSkills().getSkillByID(id);
        if(e==null)
        {
            e=::new("$bvvar{privateFolder}/skills/effects/eight_valkyries_effect");
            e.configure(source,kind,id);a.getSkills().add(e);
            this.state(source).Effects.push(this.api().makeValkyrieCombatWeakRef(e));
        }
        local s=this.state(source);e.m.Until=s.Turn+turns;
        e.m.Amount=::Math.min(80,::Math.max(e.m.Amount,amount));
        e.m.TargetEnd=("BVEightNormalEnds" in a.m?a.m.BVEightNormalEnds:0)+1;
        a.getSkills().update();a.setDirty(true);return e;
    }
    function findEffect(a,source,kind)
    {
        if(a==null||source==null)return null;
        local e=a.getSkills().getSkillByID("$bvvar{modId}.effects.eight_"+kind+"_"+source.getID());
        return e!=null&&e.valid()?e:null;
    }
    function shield(a,source,n,turns)
    {
        local e=this.effect(a,source,"shield",turns,n),s=this.state(source);
        if(e!=null&&a!=source&&s.ID=="argente"&&!s.ShieldGift)
        {s.ShieldGift=true;this.effect(source,source,"shield",2,30);}
        return e;
    }
    function refreshFields()
    {
        foreach(a in ::World.getPlayerRoster().getAll())if(this.alive(a)){a.getSkills().update();a.setDirty(true);}
    }
    function clearEffects(a)
    {
        if(a==null||!("BVEightState" in a.m)||a.m.BVEightState==null)return;
        local recipients=[];
        foreach(ref in a.m.BVEightState.Effects)
        {
            local effect=this.api().readValkyrieCombatWeakRef(ref);
            if(effect!=null&&!effect.isGarbage())
            {
                local container=effect.getContainer();effect.removeSelf();
                if(container!=null&&container.getActor()!=a&&recipients.find(container)==null)recipients.push(container);
            }
        }
        a.m.BVEightState.Effects=[];
        foreach(container in recipients)if(this.alive(container.getActor())){container.update();container.getActor().setDirty(true);}
    }
    function fieldContains(source,a)
    {
        if(!this.able(source)||!this.ally(source,a))return false;
        local s=this.state(source);if(s==null||s.Field==null||s.Turn>=s.FieldUntil)return false;
        return this.los(s.Field,a.getTile(),s.ID=="suisui"?2:3);
    }
    function turn(a)
    {
        local s=this.state(a);if(s==null||!this.normal(a)||s.LastTurnRound==this.round())return;
        s.LastTurnRound=this.round();s.Turn++;s.Moved=false;s.MoveAim=false;s.Retreat=false;s.StartTile=a.getTile().ID;
        if(s.Turn>1)
        {
            if(s.ID=="sorasaki_hina")this.resource(a,-1);
            if(s.ID=="xin"||s.ID=="argente")this.resource(a,1);
            if(s.ID=="lumiore")this.resource(a,2);
        }
        if(s.Turn>=s.StudyUntil)s.Study=null;
        if(s.Turn>=s.GuardUntil)s.Guard=null;
        if(s.Turn>=s.FieldUntil)s.Field=null;
        if(s.Turn>=s.WardUntil)s.WardToken=null;
        local remaining=[];
        foreach(ref in s.Effects)
        {
            local effect=this.api().readValkyrieCombatWeakRef(ref);
            if(effect==null||effect.isGarbage())continue;
            if(!effect.valid())effect.removeSelf();else remaining.push(ref);
        }
        s.Effects=remaining;
        if(s.ID=="suisui"&&this.able(a))
        {
            local n=0;
            foreach(b in this.allies(a,a.getTile(),3))if(b.getHitpoints()<b.getHitpointsMax())
            {
                if(this.heal(b,8+0.04*this.resolve(a)))this.feedback(a,b,"suisui_clear_current","apply",n==0);
                if(++n>=3)break;
            }
        }
        this.refreshFields();
    }
    function feedback(a,target,key,event="cast",sound=true)
    {
        // Services isolate presentation exceptions. Visual options never gate audio.
        this.api().playValkyrieVisual(a,target,"eight_"+key+"_"+event);
        if(sound)this.api().playValkyrieSkillAudio(a,"eight_"+key+"_"+event,this.api().captureValkyrieSkillAudioPosition(target));
    }
    function paid(e)
    {
        if(e==null||!("Source" in e)||!("ActionToken" in e)||e.ActionToken==null)return false;
        return (!("IsFree" in e)||!e.IsFree)&&(e.Source=="managed_active"||e.Source=="weapon_active"||e.Source=="unknown/direct"||e.Source=="direct");
    }
};
