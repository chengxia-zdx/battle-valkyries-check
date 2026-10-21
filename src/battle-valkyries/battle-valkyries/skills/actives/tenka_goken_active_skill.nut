this.tenka_goken_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    m={Spec=null},
    function create()
    {
        this.valkyrie_active_skill.create();this.m.IsWeaponSkill=true;this.m.IsRanged=false;
        this.m.IsUsingHitchance=true;this.m.IsShowingProjectile=false;this.m.IsVisibleTileNeeded=true;
        this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=1;
    }
    function onValkyrieSkillBound(d)
    {
        this.m.Spec=d.Spec;local s=this.m.Spec;
        this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.Target=="self"?0:1;this.m.MaxRange=s.Max;
        this.m.IsAttack=s.Target=="enemy"||s.Target=="approach"||s.Target=="arc";
        this.m.IsTargeted=true;this.m.IsTargetingActor=s.Target=="enemy"||s.Target=="approach";this.m.IsAOE=s.Target=="arc";
    }
    function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
    function f(){return ::$bvvar{namespace}.TenkaGoken;}
    function isValkyrieWeaponSkillPolicyOptOut(){return true;}
    function unavailable()
    {
        local f=this.f(),a=this.actor(),d=this.m.Spec;
        if(!f.able(a))return "$bv{tenka.unarmed}";
        if(d.Mode=="weapon"?!f.validWeaponSkill(a,d):!f.isOwner(a,d))return "$bv{tenka.owner_required}";
        local s=f.state(a);
        if(s.Moving!=null)return "$bv{tenka.moving}";
        if(!f.ready(a,this.m.BVSkillKey))return "$bv{tenka.cooldown}"+(s.Cooldowns[this.m.BVSkillKey]-f.round());
        if((d.Target=="move"||d.Target=="approach")&&(a.getCurrentProperties().IsRooted||s.Footwork))return "$bv{tenka.footwork_used}";
        if(d.Mode=="chain"&&(s.Chain<2||f.ends(a)>=s.ChainEnd))return "$bv{tenka.chain_required}";
        return null;
    }
    function isUsable(){return this.unavailable()==null&&this.skill.isUsable();}
    function getFatigueCost()
    {
        local cost=this.skill.getFatigueCost(),a=this.actor();if(a==null)return cost;
        local f=this.f(),s=f.state(a),d=this.m.Spec;
        if(d.Mode=="nerve"&&s.LungeDiscount&&f.validWeaponSkill(a,d))cost=::Math.max(0,cost-4);
        if(d.Mode=="chain"&&f.validWeaponSkill(a,d))cost=::Math.max(0,cost-4);
        return cost;
    }
    function onAfterUpdate(p){this.m.FatigueCostMult=p.IsSpecializedInSwords?::Const.Combat.WeaponSpecFatigueMult:1.0;}
    function getValkyrieShieldDefenseScale(){return this.m.Spec.HalfShield?0.5:1.0;}
    function onVerifyTarget(origin,tile)
    {
        local f=this.f(),a=this.actor(),d=this.m.Spec;
        if(!f.able(a)||tile==null)return false;
        if(d.Target=="self")return tile.ID==origin.ID;
        local distance=origin.getDistanceTo(tile);
        if(distance<1||distance>d.Max||!tile.IsVisibleForEntity||!origin.hasLineOfSightTo(tile,d.Max))return false;
        if(d.Target=="move")return f.api().EightValkyries.path(a,tile,3)!=null;
        if(d.Target=="arc")return distance==1&&::Math.abs(origin.Level-tile.Level)<=1;
        if(!tile.IsOccupiedByActor||!f.enemy(a,tile.getEntity(),d.Max))return false;
        if(d.Mode=="chain")return f.api().readValkyrieCombatWeakRef(f.state(a).ChainTarget)==tile.getEntity();
        return d.Target!="approach"||(distance>=2&&f.approach(a,tile.getEntity())!=null);
    }
    function getAffectedTiles(tile){return this.m.Spec.Target=="arc"?this.f().arc(this.actor(),tile,this.m.Spec.Mode=="dance"?3:2):[tile];}
    function onTargetSelected(tile)
    {
        this.skill.onTargetSelected(tile);
        if(this.m.Spec.Target=="arc")foreach(t in this.getAffectedTiles(tile))::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}];
        local reason=this.unavailable();if(reason!=null)out.push({id=4,type="text",icon="ui/icons/warning.png",text=reason});
        if(this.m.Spec.Target=="arc")out.push({id=5,type="text",icon="ui/icons/warning.png",text="$bv{tenka.friendly_fire}"});
        out.push({id=6,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.TenkaTechniqueNotes[this.m.BVSkillKey]});return out;
    }
    function onUse(a,tile)
    {
        local f=this.f(),d=this.m.Spec,s=f.state(a),c=f.api().getCurrentValkyrieActionContext(a,this);
        if(this.unavailable()!=null||!this.onVerifyTarget(a.getTile(),tile)||!f.paid(c)||c.ActionToken in s.Actions)return false;
        s.Actions[c.ActionToken]<-true;s.Cooldowns[this.m.BVSkillKey]<-f.round()+d.CD;
        if(d.Mode=="breath"){f.refund(a,15);s.Breath=true;s.BreathEnd=f.ends(a)+2;}
        else if(d.Mode=="guard")
        {
            s.GuardUntil=s.Starts+1;
            if(d.Owner=="onigawara_rin")foreach(ally in ::World.getPlayerRoster().getAll())
                if(ally!=a&&f.alive(ally)&&ally.isAlliedWith(a)&&a.getTile().getDistanceTo(ally.getTile())==1)f.effect(a,ally,"protect");
        }
        else if(d.Target=="move")
        {s.Footwork=true;return f.move(a,f.api().EightValkyries.path(a,tile,3));}
        else if(d.Target=="approach")
        {
            local target=tile.getEntity(),path=f.approach(a,target);s.Footwork=true;
            local data={Target=f.api().makeValkyrieCombatWeakRef(target),Token=c.ActionToken};
            return f.move(a,path,this.onApproachArrived.bindenv(this),data);
        }
        else if(d.Target=="arc")this.area(a,tile,c.ActionToken);
        else this.attack(a,tile.getEntity(),c.ActionToken);
        if(f.alive(a)){a.getSkills().update();a.setDirty(true);}
        return true;
    }
    function canResolveMovement(a)
    {
        local f=this.f(),d=this.m.Spec;
        // Like Black Flash, delayed effects belong to the still-equipped skill.
        if(this.isGarbage()||!f.api().sameValkyrieCombatObject(this.actor(),a)||!f.able(a))return false;
        return d.Mode=="weapon"?f.validWeaponSkill(a,d):f.isOwner(a,d);
    }
    function onApproachArrived(a,data)
    {
        if(!this.canResolveMovement(a))return;
        local target=this.f().api().readValkyrieCombatWeakRef(data.Target);
        if(this.f().enemy(a,target))this.attack(a,target,data.Token);
    }
    function attack(a,b,token)
    {
        local f=this.f(),d=clone this.m.Spec,s=f.state(a),owner=f.isOwner(a,d),mode=d.Mode;
        if(!f.able(a)||!f.enemy(a,b))return;
        local bonus=f.beginSword(a,mode,b),hit=false;
        if(mode=="chain")
        {
            s.Chain=0;s.ChainMode=null;s.ChainTarget=null;
            foreach(i,mult in [0.85,0.95,1.05])
            {if(!f.able(a)||!f.enemy(a,b))break;d.D=mult;local r=f.strike(a,this,b,d,bonus,token,i==2);bonus=0;if(r.Hit)hit=true;}
        }
        else if(mode=="weapon"&&d.Owner=="tamaba_satori")
        {
            for(local i=0;i<2;i++)
            {if(!f.able(a)||!f.enemy(a,b))break;d.Hit=this.m.Spec.Hit+(owner&&i==1?10:0);local r=f.strike(a,this,b,d,bonus,token);bonus=0;if(r.Hit)hit=true;}
        }
        else
        {
            if(mode=="bear")
            {
                local bear=::new("$bvvar{privateFolder}/skills/actives/tenka_goken_bear_attack");bear.configure(a,this);
                local source=f.api().pushValkyrieCombatSource("followup",a,{Skill=bear,ParentActionToken=token});local bearHit=false;
                try{bearHit=bear.attackEntity(a,b,false);}catch(ex){f.api().popValkyrieCombatSource(source);throw ex;}
                f.api().popValkyrieCombatSource(source);if(bearHit)d.Hit+=15;
                if(!f.able(a)||!f.enemy(a,b))return;
            }
            if(mode=="lunge")d.D+=::Math.min(0.4,a.getCurrentProperties().getInitiative()/400.0);
            if(mode=="weapon"&&d.Owner=="onigawara_rin"&&owner)d.Pierce+=0.05;
            local before=f.api().getValkyrieDamageSnapshot(b),r=f.strike(a,this,b,d,bonus,token);hit=r.Hit;
            if(hit&&f.alive(b)&&mode=="nerve"&&f.api().getValkyrieDamageDelta(b,before).Hitpoints>=5
                &&!b.getCurrentProperties().IsImmuneToBleeding&&f.api().EightValkyries.debuffable(b))f.effect(a,b,"pain");
            if(mode=="weapon"&&d.Owner=="kikakujo_mary"&&owner&&hit&&f.alive(b))
            {s.RoseTarget=f.api().makeValkyrieCombatWeakRef(b);s.RoseRound=f.round();}
        }
        if(!f.alive(a))return;
        f.hitRecovery(a,hit);f.observe(a,b);
        if(mode!="chain")f.chain(a,mode,b);
        if(mode=="lunge")s.LungeDiscount=true;
        if(mode=="nerve")s.LungeDiscount=false;
        if(mode=="leap")s.LeapDiscount=true;
        if(mode=="weapon"&&d.Owner=="hanasaka_warabi")this.retreat(a,b,owner);
        a.getSkills().update();a.setDirty(true);
    }
    function retreat(a,b,owner)
    {
        local f=this.f();if(a.getCurrentProperties().IsRooted)return;local origin=a.getTile(),best=null,score=999;
        for(local i=0;i<6;i++)if(origin.hasNextTile(i))
        {
            local t=origin.getNextTile(i);if(!t.IsEmpty||!t.IsVisibleForEntity||::Math.abs(t.Level-origin.Level)>1)continue;
            local n=t.getZoneOfControlCountOtherThan(a.getAlliedFactions());
            if(n<score){score=n;best=t;}
        }
        if(best!=null)f.move(a,[best],null,null,true,owner?f.api().makeValkyrieCombatWeakRef(b):null);
    }
    function area(a,tile,token)
    {
        local f=this.f(),d=this.m.Spec,s=f.state(a),hit=false,firstBonus=0.0;
        if(d.Owner=="inaba_tsukuyo"&&f.isOwner(a,d)&&tile.IsOccupiedByActor&&f.enemy(a,tile.getEntity()))
            firstBonus=f.beginSword(a,d.Mode,tile.getEntity());
        foreach(t in this.getAffectedTiles(tile))
        {
            if(!f.able(a))break;if(!t.IsOccupiedByActor)continue;local b=t.getEntity();
            if(!f.alive(b)||a==b||a.getTile().getDistanceTo(t)!=1||::Math.abs(a.getTile().Level-t.Level)>1)continue;
            // Friendly fire follows the same physical attack route, without enemy-only gains.
            local bonus=t.ID==tile.ID?firstBonus:0.0;
            local r=f.api().applyValkyrieWeaponAttack(a,this,b,{WeaponDamageMult=d.D+bonus+(f.coordinated(a,b)?0.15:0),ArmorDamageMult=(d.D+bonus+(f.coordinated(a,b)?0.15:0))*d.A,DirectDamageAdd=d.Pierce,DirectDamageCap=0.75,HitChance=d.Hit,ParentActionToken=token,Source="followup"});
            if(r.Hit&&!b.isAlliedWith(a))hit=true;
        }
        f.hitRecovery(a,hit);
        if(hit&&d.Mode=="weapon"&&d.Owner=="inaba_tsukuyo"&&f.isOwner(a,d))s.MoonUntil=s.Starts+1;
    }
});
