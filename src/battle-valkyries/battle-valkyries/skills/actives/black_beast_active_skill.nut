// Numerical specs are catalog data; every paid action uses the shared token/policy runner.
this.black_beast_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    m = { BVBlackBeastActive = true, Spec = null, Cast = null, HitSpec = null, GateTarget = null, DualFirst = null },
    function f() { return ::$bvvar{namespace}.BlackBeast; }
    function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
    function targetFx(b) { if(this.f().alive(b))this.f().api().playValkyrieVisual(this,b,"black_beast_"+this.m.BVSkillKey+"_impact"); }
    function create()
    {
        this.valkyrie_active_skill.create(); this.m.IsShowingProjectile=false; this.m.IsDoingAttackMove=false;
        this.m.IsVisibleTileNeeded=true; this.m.IsIgnoredAsAOO=true; this.m.MaxRangeBonus=0; this.m.MaxLevelDifference=4;
    }
    function onValkyrieSkillBound(d)
    {
        this.m.Spec=clone d.Spec; local s=this.m.Spec;
        this.m.ActionPointCost=s.AP; this.m.FatigueCost=s.Fatigue; this.m.MinRange=s.Min; this.m.MaxRange=s.Max;
        this.m.IsTargeted=s.Target!="self"; this.m.IsTargetingActor=s.Target=="enemy" || s.Target=="ally" || s.Target=="gate";
        this.m.IsAttack=s.Mult>0; this.m.IsRanged=s.Owner=="celestine" || s.Mode=="talisman" || s.Mode=="array";
        this.m.IsWeaponSkill=this.m.IsAttack && s.Owner!="celestine"; this.m.IsUsingHitchance=this.m.IsWeaponSkill;
        this.m.IsAOE=s.Target=="area" || s.Target=="flanks" || s.Target=="self" && s.Mult>0;
        this.m.IsShieldRelevant=s.Owner!="celestine"; this.m.DirectDamageMult=s.Pierce;
        if(s.Owner=="celestine" || s.Mode=="talisman" || s.Mode=="array") this.m.MaxLevelDifference=99;
    }
    function isValkyrieWeaponSkillPolicyOptOut() { return true; }
    function pursuit() { local a=this.actor(),s=this.f().state(a);return s!=null && s.ID=="chloe" && this.m.IsWeaponSkill && s.PursuitRound==this.f().round(); }
    function getActionPointCost()
    {
        if(this.m.Spec.Mode=="gate" && this.m.GateTarget==null) return 0;
        if(this.m.Spec.Mode=="dual" && this.f().stage(this.actor())>=4 && this.m.DualFirst==null) return 0;
        local n=this.skill.getActionPointCost(),a=this.actor();
        if(this.m.Spec.Owner=="alicia" && this.m.Spec.Mode=="triple" && this.f().stage(a)>=5 && this.f().state(a).Stacks>=10)n=4;
        return this.pursuit()?::Math.max(1,n-(this.f().stage(a)>=1?2:1)):n;
    }
    function getFatigueCost()
    {
        if(this.m.Spec.Mode=="gate" && this.m.GateTarget==null)return 0;
        if(this.m.Spec.Mode=="dual" && this.f().stage(this.actor())>=4 && this.m.DualFirst==null)return 0;
        local n=this.skill.getFatigueCost();
        if(this.m.Spec.Owner=="alicia" && this.m.Spec.Mode=="thrust" && this.f().stage(this.actor())>=4)n=10;
        return this.pursuit()?::Math.max(0,n-(this.f().stage(this.actor())>=1?12:8)):n;
    }
    function unavailable()
    {
        local f=this.f(),a=this.actor(),d=this.m.Spec,s=f.state(a);
        if(s==null || s.ID!=d.Owner || !f.able(a))return "$bv{black_beast.unavailable}";
        local def=f.api().ValkyrieSkillCatalog[this.m.BVSkillKey];if(!f.entitled(a,def))return "$bv{black_beast.stage.locked}";
        local needsShield=d.Owner=="maia" || d.Owner=="chloe" && d.Mode=="swap";
        if(needsShield && (f.shield(a)==null || this.m.IsWeaponSkill && !f.armed(a)))return "$bv{black_beast.equipment}";
        if(!needsShield && !(d.Owner=="chloe" && !this.m.IsWeaponSkill) && !f.armed(a))return "$bv{black_beast.equipment}";
        if(this.m.IsWeaponSkill && !a.getCurrentProperties().IsAbleToUseWeaponSkills)return "$bv{black_beast.equipment}";
        local cap=d.Owner=="chloe" && d.Mode=="swap" && f.stage(a)>=5?2:d.RoundCap;
        if(cap>0 && f.count(a,this.m.BVSkillKey)>=cap)return "$bv{black_beast.round_used}";
        if(d.Mode=="purge" && "purge" in s.Cooldowns && s.Cooldowns.purge>f.round())return "$bv{black_beast.cooldown}";
        if(d.Mode=="resurrection" && s.SealsCast>=2)return "$bv{black_beast.seals_used}";
        if(d.Mode=="breath" && a.getFatigue()<=0)return "$bv{black_beast.no_fatigue}";
        if(d.Mode=="furnace" && f.enemies(a,a.getTile(),1,1).len()==0)return "$bv{black_beast.no_target}";
        return null;
    }
    function isUsable() { return this.unavailable()==null && this.skill.isUsable(); }
    function getDescription()
    {
        if (this.m.Spec != null && this.m.Spec.Owner == "maia" && (this.m.Spec.Mode == "wall" || this.m.Spec.Mode == "cry") && this.actor() != null)
            return (this.m.Spec.Mode == "cry" ? "$bv{black_beast.feedback.cry}" : "") + this.f().wallDescription(this.actor());
        return this.m.Description;
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}],reason=this.unavailable();
        if(reason!=null)out.push({id=4,type="text",icon="ui/tooltips/warning.png",text=reason});
        if(this.m.Spec.Mode=="gate")out.push({id=5,type="text",icon="ui/icons/special.png",text=this.m.GateTarget==null?"$bv{black_beast.gate.select}":"$bv{black_beast.gate.destination}"});
        if(this.m.Spec.Mode=="dual" && this.f().stage(this.actor())>=4)out.push({id=6,type="text",icon="ui/icons/special.png",text=this.m.DualFirst==null?"$bv{black_beast.dual.first}":"$bv{black_beast.dual.second}"});
        local a=this.actor(),n=this.f().stage(a),d=this.m.Spec;
        if(a!=null && d.Owner=="kaguya")
            out.push({id=7,type="text",icon="ui/icons/special.png",text=::format("$bv{black_beast.feedback.seal}",n>=5?4:(n>=3?3:2),n>=5?40:(n>=3?35:25),n>=5?30:(n>=3?20:(n>=1?15:10)))+(n>=3?"$bv{black_beast.feedback.no_movement}":"")+(n>=5?"$bv{black_beast.feedback.battle_end}":"$bv{black_beast.feedback.two_turns}")});
        if(a!=null && d.Owner=="claudia")
            out.push({id=8,type="text",icon="ui/icons/special.png",text=::format("$bv{black_beast.feedback.shatter}",n>=3?30:25,n>=3?100:50)+(n>=3?"$bv{black_beast.feedback.shatter_pierce}":"")+(n>=5?"$bv{black_beast.feedback.battle_end}":"$bv{black_beast.feedback.two_turns}")});
        if(a!=null && d.Mode=="blessing")out.push({id=9,type="text",icon="ui/icons/special.png",text=::format("$bv{black_beast.feedback.blessing}",n>=3?20:15,n>=3?30:20)+"$bv{black_beast.feedback.two_turns}"});
        if(a!=null && d.Owner=="celestine" && this.m.IsAttack)out.push({id=10,type="text",icon="ui/icons/regular_damage.png",text="$bv{olga.damage}"+::Math.floor(d.Mode=="judgment"?70+0.5*a.getHitpoints():150+0.8*a.getHitpoints())});
        if(a!=null && d.Mode=="rally")out.push({id=11,type="text",icon="ui/icons/special.png",text=::format("$bv{black_beast.feedback.rally}",n>=5?8:(n>=3?6:5),n>=5?30:(n>=1?20:15),n>=1?2:1)});
        if(a!=null && d.Mode=="counter")out.push({id=12,type="text",icon="ui/icons/special.png",text=::format("$bv{black_beast.feedback.counter}",n>=4?150:100,::Math.max(0,30-this.f().state(a).CounterRefund))});
        if(d.Owner=="maia" && (d.Mode=="fang" || d.Mode=="sweep") || d.Owner=="claudia" && (d.Mode=="hammer" || d.Mode=="sweep" || d.Mode=="wave"))
            out.push({id=13,type="text",icon="ui/icons/special.png",text="$bv{black_beast.feedback.control_details}"});
        return out;
    }
    function gateUnit(b)
    {
        local f=this.f();return f.alive(b) && b.getCurrentProperties().IsMovable && !f.api().Olga.special(b) && !("IsImmovable" in b.m && b.m.IsImmovable) && b.getTile().IsOccupiedByActor;
    }
    function onVerifyTarget(origin,tile)
    {
        local f=this.f(),a=this.actor(),d=this.m.Spec;
        if(!f.alive(a) || origin==null || tile==null || !tile.IsVisibleForEntity)return false;
        if(d.Target=="self")return tile.ID==origin.ID;
        if(d.Mode=="gate")
        {
            if(this.m.GateTarget==null)return tile.IsOccupiedByActor && this.gateUnit(tile.getEntity());
            local b=f.api().readValkyrieCombatWeakRef(this.m.GateTarget);
            return this.gateUnit(b) && tile.IsEmpty && tile.Type> ::Const.Tactical.TerrainType.Impassable && tile.Type< ::Const.Tactical.TerrainType.COUNT;
        }
        local dist=origin.getDistanceTo(tile);if(dist<d.Min || dist>d.Max || !origin.hasLineOfSightTo(tile,d.Max))return false;
        if(d.Target=="area")return true;
        if(!tile.IsOccupiedByActor)return false;local b=tile.getEntity();
        if(d.Target=="ally")
        {
            if(!f.ally(a,b))return false;
            if(d.Mode=="swap") {local p=b.getCurrentProperties();return b!=a && !a.getCurrentProperties().IsRooted && !p.IsRooted && !p.IsStunned && p.IsMovable && !p.IsImmuneToRotation;}
            return d.Mode!="resurrection" || f.sealAvailable(b);
        }
        if(!f.enemy(a,b,d.Max))return false;
        if(d.Mode=="dual" && this.m.DualFirst!=null && !f.enemy(a,f.api().readValkyrieCombatWeakRef(this.m.DualFirst),1))return false;
        if(d.Mode=="split")return f.shield(b)!=null;
        if(d.Mode=="taunt")return b.getAIAgent()!=null && !b.isPlayerControlled();
        return true;
    }
    function getAffectedTiles(tile)
    {
        local d=this.m.Spec,f=this.f(),a=this.actor();
        if(d.Target=="self" && this.m.IsAttack || d.Target=="area")return f.api().getValkyrieRadiusTiles(d.Target=="self"?a.getTile():tile,1,true);
        if(d.Target=="flanks")
        {
            local out=[tile],dir=tile.getDirectionTo(a.getTile());
            foreach(x in [(dir+1)%6,(dir+5)%6])if(tile.hasNextTile(x))out.push(tile.getNextTile(x));
            return out;
        }
        return [tile];
    }
    function onTargetSelected(tile)
    {
        this.skill.onTargetSelected(tile);
        if(this.m.IsAOE)foreach(t in this.getAffectedTiles(tile))this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
    }
    function targets(tile)
    {
        return this.f().api().getValkyrieEnemyTargetsOnTiles(this.actor(),this.getAffectedTiles(tile));
    }
    function hitSpec(a, center)
    {
        local d=clone this.m.Spec,n=this.f().stage(a),id=d.Owner,m=d.Mode,w=this.f().weapon(a);
        d.Range<-d.Target=="self"?1:(d.Target=="area"?d.Max+1:d.Max);d.IgnoreShield<-false;d.AddPierce<-false;d.Bonus<-0;
        if(id=="chloe")
        {
            d.AddPierce=true;d.IgnoreShield=true;
            if(m=="slash"){d.Mult=n>=5?2.6:(n>=4?2.1:1.9);if(n>=5){d.Hit=45;d.Pierce=0.65;}}
            if(m=="dual"){d.Mult=n>=5?2.1:(n>=4?1.6:1.4);if(n>=5){d.Hit=45;d.Pierce=0.6;}}
            if(this.m.Cast.Pursuit && n>=1)d.Mult+=0.3;
        }
        if(id=="alicia")
        {
            d.AddPierce=true;d.IgnoreShield=n>=1;
            if(m=="thrust" && n>=3)d.Mult=1.5;
            if(m=="triple" && n>=5)d.Mult=1.0;
            if(n>=3)d.Mult*=1.0+0.05*this.f().state(a).Stacks;
        }
        if(id=="claudia" && n>=3 && center!=null && center.getArmor(::Const.BodyPart.Head)<=0 && center.getArmor(::Const.BodyPart.Body)<=0)d.Mult+=0.5;
        if(id=="kaguya")
        {
            local two=a.getTile().getDistanceTo(this.m.Cast.Center)==2;
            if(two){d.Mult+=0.5;d.Pierce+=0.3;d.IgnoreShield=true;}
        }
        if(id=="prim")
        {
            d.Hit+=10+::Math.floor(this.m.Cast.Resolve*0.2);
            if(m=="thrust")d.AddPierce=true;
            if(m=="twin"){d.Mult=n>=5?1.0:0.9;d.Bonus=::Math.floor(this.m.Cast.Resolve*(n>=5?0.5:0.25));d.Armor=w.m.ArmorDamageMult;d.Pierce=w.m.DirectDamageMult;}
        }
        if(id=="luu_luu" && m=="vent") {d.Pierce=::Math.minf(1.0,w.m.DirectDamageMult+0.2);d.Armor=w.m.ArmorDamageMult;d.Bonus=n>=3?this.m.Cast.Vent: ::Math.floor(this.m.Cast.Vent*0.5);}
        if(id=="luu_luu" && m=="furnace")d.Bonus=this.m.Cast.Fatigue;
        return d;
    }
    function onAnySkillUsed(skill,target,p)
    {
        if(skill!=this || this.m.Cast==null || !this.m.IsAttack)return;
        if(this.m.IsWeaponSkill){p.DamageRegularMin=this.m.Cast.WeaponMin;p.DamageRegularMax=this.m.Cast.WeaponMax;}
        else
        {
            local amount=::Math.floor(this.m.Spec.Mode=="judgment"?70+0.5*this.m.Cast.HP:150+0.8*this.m.Cast.HP);
            p.DamageRegularMin=amount;p.DamageRegularMax=amount;p.DamageRegularMult=1.0;p.DamageArmorMult=this.m.Spec.Armor;
            p.DamageDirectMult=1.0;p.DamageDirectAdd=0;p.DamageDirectMeleeAdd=0;p.DamageDirectRangedAdd=0;
            p.HitChance[::Const.BodyPart.Head]=0;p.HitChance[::Const.BodyPart.Body]=100;
            p.HitChanceMult[::Const.BodyPart.Head]=1;p.HitChanceMult[::Const.BodyPart.Body]=1;
        }
        p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
    }
    function strike(a,b,d)
    {
        local f=this.f();if(!f.able(a) || !f.enemy(a,b,d.Range) || this.m.IsWeaponSkill && (!f.armed(a) || !a.getCurrentProperties().IsAbleToUseWeaponSkills))return false;
        local previous=this.m.DirectDamageMult,shield=this.m.IsShieldRelevant,policy=null,hit=false,before=[b.getArmor(::Const.BodyPart.Head),b.getArmor(::Const.BodyPart.Body)],tile=b.getTile();
        this.m.HitSpec=d;this.m.IsShieldRelevant=!d.IgnoreShield;
        this.m.DirectDamageMult=d.AddPierce?::Math.minf(1.0,f.weapon(a).m.DirectDamageMult+d.Pierce):d.Pierce;
        if(this.m.IsWeaponSkill)
        {
            // Engine min/max truncate floats: 85% sword armor damage must not become a zero divisor.
            local w=f.weapon(a);policy=f.api().pushValkyrieWeaponAttackPolicy(a,this,b,w,{WeaponDamageMult=d.Mult,ArmorDamageMult=d.Armor/::Math.maxf(0.01,w.m.ArmorDamageMult),DirectDamageOverride=this.m.DirectDamageMult,HitChance=d.Hit,IgnoreDistance=true,IgnoreShield=d.IgnoreShield,Source="managed_active"},this);
        }
        try{hit=this.attackEntity(a,b,false);}
        catch(e){if(policy!=null)f.api().popValkyrieWeaponAttackPolicy(policy.Token);this.m.HitSpec=null;this.m.DirectDamageMult=previous;this.m.IsShieldRelevant=shield;throw e;}
        if(policy!=null)f.api().popValkyrieWeaponAttackPolicy(policy.Token);
        this.m.HitSpec=null;this.m.DirectDamageMult=previous;this.m.IsShieldRelevant=shield;
        if(hit)f.api().playValkyrieVisual(this,{getTile=function(){return tile;}},"black_beast_"+this.m.BVSkillKey+"_impact");
        if(hit && d.Owner=="claudia")this.armorRefund(a,b,before);
        if(!f.alive(b))return hit;
        if(hit && d.Owner=="claudia")
        {
            f.shatter(a,b);
            if(d.Mode=="wedge") {this.shaveArmor(b,0.25);this.armorRefund(a,b,before);}
            if(d.Mode=="hammer" || d.Mode=="sweep" || d.Mode=="wave"){f.control(b,"daze",a);f.control(b,"stagger",a);}
        }
        if(hit && d.Owner=="maia")
        {
            f.control(b,"daze",a);f.control(b,"stagger",a);
            if(d.Mode=="fang")this.knock(a,b);
        }
        return hit;
    }
    function armorRefund(a,b,before)
    {
        if(!this.f().alive(a))return;
        if(before[0]>0 && b.getArmor(::Const.BodyPart.Head)<=0 || before[1]>0 && b.getArmor(::Const.BodyPart.Body)<=0)this.f().refund(a,12,"armor_break");
    }
    function shaveArmor(b,ratio)
    {
        foreach(slot in [::Const.ItemSlot.Head,::Const.ItemSlot.Body]) {local i=b.getItems().getItemAtSlot(slot);if(i!=null)i.setCondition(::Math.max(0,i.getCondition()-::Math.floor(i.getCondition()*ratio)));}
        b.getSkills().update();b.setDirty(true);
    }
    function knock(a,b)
    {
        local f=this.f(),p=b.getCurrentProperties(),native=::new("scripts/skills/actives/knock_back"),dest=native.findTileToKnockBackTo(a.getTile(),b.getTile());
        if(dest==null || p.IsRooted || !p.IsMovable || p.IsImmuneToKnockBackAndGrab){f.control(b,"stun",a);return;}
        foreach(id in ["effects.shieldwall","effects.spearwall","effects.riposte"])b.getSkills().removeByID(id);
        ::Tactical.State.handleInvoluntaryMovement(b,a,b.getTile(),dest,this,null,null);
    }
    function taunt(a,b)
    {
        if(!this.f().enemy(a,b,5) || b.getAIAgent()==null || b.isPlayerControlled())return false;
        b.getAIAgent().setForcedOpponent(a);b.getSkills().add(::new("scripts/skills/effects/taunted_effect"));return true;
    }
    function cancelGate() { this.m.GateTarget=null;this.m.DualFirst=null;this.m.IsTargetingActor=true; }
    function onTargetDeselected() { this.cancelGate(); }
    function onCombatFinished() { this.cancelGate();this.skill.onCombatFinished(); }
    function onTurnEnd() { this.cancelGate(); }
    function onUse(a,tile)
    {
        local f=this.f(),s=f.state(a),d=this.m.Spec,c=f.api().getCurrentValkyrieActionContext(a,this);
        if(this.unavailable()!=null || !this.onVerifyTarget(a.getTile(),tile) || c==null || !f.paid(c))return false;
        if(d.Mode=="gate" && this.m.GateTarget==null) {this.m.GateTarget=f.api().makeValkyrieCombatWeakRef(tile.getEntity());this.m.IsTargetingActor=false;return true;}
        if(d.Mode=="dual" && f.stage(a)>=4 && this.m.DualFirst==null) {this.m.DualFirst=f.api().makeValkyrieCombatWeakRef(tile.getEntity());return true;}
        if(c.ActionToken in s.Actions && s.Actions[c.ActionToken]=="cast")return false;
        local pursuit=this.pursuit(),w=f.weapon(a),list=this.targets(tile);
        this.m.Cast={HP=a.getHitpoints(),Resolve=a.getCurrentProperties().getBravery(),Fatigue=a.getFatigue(),Vent=::Math.min(a.getFatigue(),f.stage(a)>=3?60:40),WeaponMin=w==null?0:w.m.RegularDamage,WeaponMax=w==null?0:w.m.RegularDamageMax,Stacks=s.Stacks,Pursuit=pursuit,Center=tile};
        if(pursuit){s.PursuitRound=-1;s.PursuitAction=c.ActionToken;}
        s.Actions[c.ActionToken]<-"cast";f.useCount(a,this.m.BVSkillKey);
        if(d.Mode=="purge")s.Cooldowns.purge<-f.round()+2;
        f.api().playValkyrieSkillAudio(a,this.m.BVSkillKey);f.api().playValkyrieVisual(this,a,"black_beast_"+this.m.BVSkillKey+"_cast");
        local failure=null;try{this.execute(a,tile,list);}catch(e){failure=e;}
        this.m.Cast=null;this.m.HitSpec=null;if(f.alive(a)){a.getSkills().update();a.setDirty(true);}
        if(failure!=null)throw failure;return true;
    }
    function execute(a,tile,list)
    {
        local f=this.f(),s=f.state(a),d=this.m.Spec,n=f.stage(a),id=d.Owner,m=d.Mode;
        if(m=="gate")
        {
            local b=f.api().readValkyrieCombatWeakRef(this.m.GateTarget);this.cancelGate();
            if(this.gateUnit(b) && tile.IsEmpty){this.targetFx(b);b.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);::Tactical.getNavigator().teleport(b,tile,null,null,false);f.api().playValkyrieVisual(this,{getTile=function(){return tile;}},"black_beast_celestine_gate_impact");}
            return;
        }
        if(id=="chloe" && m=="swap")
        {
            local ally=tile.getEntity();::Tactical.getNavigator().switchEntities(a,ally,null,null,1.0);
            this.targetFx(ally);
            if(!a.getSkills().hasSkill("effects.shieldwall"))a.getSkills().add(::new("scripts/skills/effects/shieldwall_effect"));
            s.PursuitRound=f.round();s.PursuitAction=null;return;
        }
        if(m=="stance" || m=="fortress" || m=="counter" || m=="wall" || m=="cry")
        {
            s.GuardKind=m;s.GuardUntilRound=f.round();
            if(m=="cry")foreach(b in f.enemies(a,a.getTile(),5,5))this.taunt(a,b);
            return;
        }
        if(m=="breath"){f.refund(a,n>=4?40:30);return;}
        if(id=="celestine" && d.Target=="ally")
        {
            local b=tile.getEntity();
            if(m=="blessing" || m=="protect"){f.effect(b,m,a);this.targetFx(b);}
            if(m=="resurrection"){f.effect(b,m,a,999999);s.SealsCast++;this.targetFx(b);}
            if(m=="healing")
            {
                local hp=::Math.floor(50+0.25*b.getHitpointsMax()),armor=::Math.floor(50+0.15*b.getHitpointsMax()),changed=f.healRepair(b,hp,armor,true),count=n>=5?2:(n>=1?1:0);this.targetFx(b);
                foreach(extra in f.allies(a,b.getTile(),2))if(extra!=b && count>0 && (extra.getHitpoints()<extra.getHitpointsMax() || extra.getArmor(::Const.BodyPart.Head)<extra.getArmorMax(::Const.BodyPart.Head) || extra.getArmor(::Const.BodyPart.Body)<extra.getArmorMax(::Const.BodyPart.Body)))
                {local factor=n>=5?0.75:0.5;changed=f.healRepair(extra,::Math.floor(hp*factor),::Math.floor(armor*factor)) || changed;this.targetFx(extra);count--;}
                if(changed && n>=1)f.refund(a,10,"healing");
            }
            return;
        }
        if(id=="prim" && m=="rally")
        {
            foreach(b in f.allies(a,a.getTile(),n>=5?8:(n>=3?6:5))) {f.refund(b,n>=5?30:(n>=1?20:15));f.improveMorale(b,n>=1?2:1);this.targetFx(b);}
            return;
        }
        if(id=="prim" && m=="cleanse")
        {
            local main=tile.getEntity(),recipients=[main];foreach(b in f.allies(a,main.getTile(),1))if(b!=main){recipients.push(b);break;}
            foreach(b in recipients)
            {
                foreach(k in ["effects.stunned","effects.dazed","effects.staggered","effects.web","effects.net","effects.rooted","effects.disarmed","effects.knocked_down","$bvvar{modId}.effects.black_beast_stun","$bvvar{modId}.effects.black_beast_daze","$bvvar{modId}.effects.black_beast_stagger"])b.getSkills().removeByID(k);
                foreach(sprite in ["status_rooted","status_rooted_back"])if(b.hasSprite(sprite))b.getSprite(sprite).Visible=false;
                f.refund(b,30);b.getSkills().update();b.setDirty(true);
                this.targetFx(b);
            }
            return;
        }
        if(m=="taunt"){this.taunt(a,tile.getEntity());this.targetFx(tile.getEntity());return;}
        if(id=="kaguya" && (m=="talisman" || m=="array"))
        {
            foreach(b in list)if(f.enemy(a,b,d.Max+1)){f.root(b);f.seal(a,b);this.targetFx(b);if(m=="talisman")b.setActionPoints(::Math.max(0,b.getActionPoints()-3));}
            return;
        }
        if(id=="luu_luu" && m=="split")
        {
            local b=tile.getEntity(),shield=f.shield(b);if(shield==null)return;
            shield.applyShieldDamage(f.weapon(a).getShieldDamage());
            if(shield.getCondition()>0 || !f.enemy(a,b,1))return;
            this.strike(a,b,this.hitSpec(a,b));return;
        }
        if(id=="chloe" && m=="dual")
        {
            local b=tile.getEntity(),plan=[b,b];
            if(n>=4){plan[0]=f.api().readValkyrieCombatWeakRef(this.m.DualFirst);plan[1]=b;this.m.DualFirst=null;}
            foreach(target in plan) {if(!f.able(a))break;if(f.enemy(a,target,1))this.strike(a,target,this.hitSpec(a,target));}
            return;
        }
        foreach(b in list)
        {
            if(!f.able(a))break;
            for(local i=0;i<d.Hits;i++)
            {
                if(!f.able(a) || !f.enemy(a,b,d.Target=="self"?1:d.Max+1))break;
                local spec=this.hitSpec(a,b),hit=this.strike(a,b,spec);
                if(id=="claudia" && m=="city" && hit && f.enemy(a,b,1))
                {
                    local before=[b.getArmor(::Const.BodyPart.Head),b.getArmor(::Const.BodyPart.Body)];this.shaveArmor(b,1.0);this.armorRefund(a,b,before);
                    local follow=clone spec;follow.Mult=2.0;follow.Armor=1.5;follow.Pierce=1.0;this.strike(a,b,follow);
                }
                if(id=="claudia" && m=="wave" && b.getTile().ID==tile.ID && hit && f.alive(b) && !b.getCurrentProperties().IsImmuneToStun)f.control(b,"stun",a);
            }
            if(id=="kaguya" && m=="purge" && f.enemy(a,b,d.Max+1)){f.root(b);f.seal(a,b);if(b.getTile().ID==tile.ID)f.control(b,"stun",a);}
        }
        if(id=="luu_luu" && f.alive(a)) {if(m=="vent")f.refund(a,this.m.Cast.Vent);if(m=="furnace")a.setFatigue(0);}
    }
});
