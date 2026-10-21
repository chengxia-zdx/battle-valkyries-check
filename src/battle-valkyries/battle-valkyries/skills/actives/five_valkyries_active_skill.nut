this.five_valkyries_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    m={Spec=null,StrikeSpec=null,HitIndex=0,CastBoost=1.0},
    function fv(){return ::$bvvar{namespace}.FiveValkyries;}
    function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
    function key(){return this.m.BVSkillKey;}
    function create()
    {
        this.valkyrie_active_skill.create();this.m.IsUsingHitchance=true;this.m.IsShowingProjectile=false;
        this.m.IsDoingAttackMove=false;this.m.IsVisibleTileNeeded=true;this.m.MaxRangeBonus=0;
        this.m.IsIgnoredAsAOO=true;this.m.MaxLevelDifference=4;
    }
    function onValkyrieSkillBound(d)
    {
        this.m.Spec=clone d.Spec;local s=this.m.Spec;
        this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.Min;this.m.MaxRange=s.Max;
        this.m.IsTargeted=s.Target!="self"&&s.Target!="select";
        this.m.IsTargetingActor=s.Target=="enemy"||s.Target=="ally";
        this.m.IsAttack=s.Low>0;this.m.IsRanged=this.m.IsAttack&&!s.Melee;
        this.m.IsWeaponSkill=false;this.m.IsShieldRelevant=!s.IgnoreShield;this.m.DirectDamageMult=s.Pierce;
    }
    function gapActor(){local s=this.fv().state(this.actor());return s==null ? null : ::$bvvar{namespace}.readValkyrieCombatWeakRef(s.Gap);}
    function gapSelecting(){return this.m.Spec.Target=="gap"&&this.gapActor()==null;}
    function getActionPointCost(){return this.gapSelecting()?0:this.skill.getActionPointCost();}
    function getFatigueCost(){return this.gapSelecting()?0:this.skill.getFatigueCost();}
    function getMaxRange(){return this.m.Spec.Target=="gap"&&!this.gapSelecting()?8:this.skill.getMaxRange();}
    function isValkyrieWeaponSkillPolicyOptOut(){return true;}
    function available()
    {
        local f=this.fv(),a=this.actor(),s=f.state(a),d=this.m.Spec,k=this.key();
        if(s==null||s.ID!=d.Owner||s.Rush!=null||!f.able(a)||!f.ready(a,k)||s.Resource<d.Resource)return false;
        if(!f.entitled(a,::$bvvar{namespace}.ValkyrieSkillCatalog[k]))return false;
        if(k=="tokisaki_kurumi_bullet_one_acceleration"&&("acceleration" in s.Gains||a.getActionPoints()>=a.getActionPointsMax()))return false;
        if(k=="tokisaki_kurumi_bullet_twelve_replay"&&(s.ReplayUsed||s.Snapshot==null))return false;
        if(k=="tohsaka_rin_double_formula"&&"formula" in s.Gains)return false;
        if(d.Target=="move"&&a.getCurrentProperties().IsRooted)return false;
        if(d.Target=="select"&&(s.Loadout.find(d.Gem)==null||s.Primary==d.Gem))return false;
        return true;
    }
    function isUsable(){return this.available()&&this.skill.isUsable();}
    function onVerifyTarget(origin,tile)
    {
        local f=this.fv(),a=this.actor(),d=this.m.Spec;if(!f.alive(a)||tile==null)return false;
        if(d.Target=="self"||d.Target=="select")return tile.ID==origin.ID;
        if(d.Target=="gap")
        {
            local b=this.gapActor();
            if(b==null)return tile.IsOccupiedByActor&&origin.getDistanceTo(tile)<=4&&f.ally(a,tile.getEntity())&&!tile.getEntity().getCurrentProperties().IsRooted&&origin.hasLineOfSightTo(tile,4);
            return f.ally(a,b)&&origin.getDistanceTo(b.getTile())<=4&&!b.getCurrentProperties().IsRooted&&tile.IsEmpty&&tile.IsVisibleForEntity&&b.getTile().getDistanceTo(tile)<=4&&b.getTile().hasLineOfSightTo(tile,4)&&::Math.abs(tile.Level-b.getTile().Level)<=4;
        }
        local range=origin.getDistanceTo(tile);
        if(range<d.Min||range>d.Max||!tile.IsVisibleForEntity||!origin.hasLineOfSightTo(tile,d.Max)||::Math.abs(tile.Level-origin.Level)>4)return false;
        if(d.Target=="move")return f.shared().path(a,tile,d.Max)!=null;
        if(d.Target=="area"||d.Target=="line")return true;
        if(!tile.IsOccupiedByActor)return false;local b=tile.getEntity();
        if(d.Target=="ally")return f.ally(a,b)&&f.clock(b).Snapshot!=null;
        return f.enemy(a,b,d.Max);
    }
    function targets(tile)
    {
        local f=this.fv(),a=this.actor(),k=this.key(),d=this.m.Spec;
        if(d.Target=="line")return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(a,f.line(a,tile));
        if(d.Target=="area")
        {
            local radius=k=="cirno_perfect_freeze"||k=="tohsaka_rin_prismatic_jeweled_sword"?2:1;
            local cap=k=="cirno_perfect_freeze"?7:(d.Owner=="cirno"||radius==2?5:4);
            return f.enemies(a,tile,radius,d.Max+radius,cap,tile.IsOccupiedByActor?tile.getEntity():null);
        }
        return tile.IsOccupiedByActor?[tile.getEntity()]:[];
    }
    function getAffectedTiles(tile)
    {
        if(this.m.Spec.Target=="line")return this.fv().line(this.actor(),tile);
        if(this.m.Spec.Target=="area")return ::$bvvar{namespace}.getValkyrieRadiusTiles(tile,this.key()=="cirno_perfect_freeze"||this.key()=="tohsaka_rin_prismatic_jeweled_sword"?2:1,true);
        return [tile];
    }
    function onTargetSelected(tile)
    {
        this.skill.onTargetSelected(tile);
        if(this.m.Spec.Target=="line"||this.m.Spec.Target=="area")foreach(t in this.getAffectedTiles(tile))this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}];
        local s=this.fv().state(this.actor()),d=this.m.Spec;if(s==null)return out;
        if(d.Low>0)out.push({id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{five.damage}"+d.Low+" - "+d.High});
        if(s.Cap>0)out.push({id=5,type="text",icon="ui/icons/special.png",text="$bv{five.resource}"+s.Resource+" / "+s.Cap+" (-"+d.Resource+")"});
        out.push({id=6,type="text",icon="ui/icons/time.png",text="$bv{five.cooldown}"+(this.key() in s.Cooldowns?::Math.max(0,s.Cooldowns[this.key()]-s.Turn):0)});
        if(s.ID=="tohsaka_rin")
        {
            local selected=[];foreach(k in [s.Primary,s.Secondary])foreach(o in ::$bvvar{namespace}.FiveDefinitions.tohsaka_rin.Options)if(o.Key==k)selected.push(o.Name);
            out.push({id=7,type="text",icon="ui/icons/special.png",text="$bv{five.selection}"+this.fv().join(selected," / ")});
        }
        if(d.Target=="gap")out.push({id=8,type="text",icon="ui/icons/special.png",text=this.gapSelecting()?"$bv{five.gap_select}":"$bv{five.gap_destination}"});
        if(!this.available())out.push({id=9,type="text",icon="ui/icons/warning.png",text="$bv{five.unavailable}"});return out;
    }
    function onAnySkillUsed(skill,target,p)
    {
        if(skill!=this||!this.m.IsAttack)return;local d=this.m.StrikeSpec==null?this.m.Spec:this.m.StrikeSpec;
        local mult="Mult" in d?d.Mult:1.0;
        p.DamageRegularMin=::Math.floor(d.Low*mult);p.DamageRegularMax=::Math.floor(d.High*mult);p.DamageArmorMult=d.Armor;
        p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
        p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
        if(d.Melee)p.MeleeSkill+=20;else p.RangedSkill+=20;
    }
    function strike(a,b,mult=1.0,gemList=null,followup=false)
    {
        local f=this.fv(),d=clone this.m.Spec,k=this.key();if(!f.able(a)||!f.enemy(a,b,d.Max+2))return false;
        d.Mult<-mult;
        if(k=="yakumo_yukari_life_death_boundary"&&b.getHitpoints()*2<b.getHitpointsMax())d.Mult*=1.5;
        if(d.Owner=="shana"&&f.findEffect(b,"burn")!=null)d.Mult*=1.25;
        if(k=="tokisaki_kurumi_bullet_seven_time_stop"&&!f.canStop(b))d.Mult*=1.5;
        if(gemList!=null)
        {
            if(gemList.find("ruby")!=null)d.Mult*=1.3;
            if(gemList.find("topaz")!=null){d.Armor=2.0;d.Pierce=0.5;}
            if(gemList.find("sapphire")!=null&&!f.canDebuff(b))d.Mult*=1.25;
        }
        local old=this.m.StrikeSpec,oldPierce=this.m.DirectDamageMult,token=null,hit=false,tile=b.getTile(),pos=::$bvvar{namespace}.captureValkyrieSkillAudioPosition(b);
        this.m.StrikeSpec=d;this.m.DirectDamageMult=d.Pierce;
        if(followup)token=::$bvvar{namespace}.pushValkyrieCombatSource("followup",a,{Skill=this});
        try{hit=this.attackEntity(a,b,false);}
        catch(ex){if(token!=null)::$bvvar{namespace}.popValkyrieCombatSource(token);this.m.StrikeSpec=old;this.m.DirectDamageMult=oldPierce;throw ex;}
        if(token!=null)::$bvvar{namespace}.popValkyrieCombatSource(token);this.m.StrikeSpec=old;this.m.DirectDamageMult=oldPierce;
        if(hit)
        {
            if(d.Owner=="tokisaki_kurumi"&&!followup)f.mark(a,b);
            f.feedback(a,{getTile=function(){return tile;}},k,"impact",this.m.HitIndex<2,pos);
            if(!followup&&f.alive(b))
            {
                if(d.Owner=="cirno")f.chill(a,this,b,k=="cirno_perfect_freeze"?3:(k=="cirno_diamond_blizzard"?2:1));
                if(k=="tokisaki_kurumi_bullet_two_delay"&&f.control(b,a,"slow",3))f.feedback(a,b,k,"apply",false);
                if(k=="tokisaki_kurumi_bullet_seven_time_stop"&&f.control(b,a,"stop"))f.feedback(a,b,k,"apply",false);
                if(gemList!=null&&gemList.find("sapphire")!=null)f.control(b,a,"slow",2);
            }
        }
        this.m.HitIndex++;return hit;
    }
    function onUse(a,tile)
    {
        // Vanilla has already paid AP/fatigue before onUse. Never call isAffordable here.
        local f=this.fv(),s=f.state(a),d=this.m.Spec,k=this.key();
        local context=::$bvvar{namespace}.getCurrentValkyrieActionContext(a,this);
        if(context!=null&&!f.paid(context))return false;
        if(!this.available()||!this.onVerifyTarget(a.getTile(),tile))return false;
        if(this.gapSelecting()){s.Gap=::$bvvar{namespace}.makeValkyrieCombatWeakRef(tile.getEntity());return true;}
        if(d.Target=="select"){s.Secondary=s.Primary;s.Primary=d.Gem;return true;}
        local list=this.targets(tile),gems=null,boost=1.0,hitAny=false,killed=false;
        if(k=="tohsaka_rin_gem_magic"||k=="tohsaka_rin_double_formula")gems=k=="tohsaka_rin_double_formula"?[s.Primary,s.Secondary]:[s.Primary];
        if(d.Owner=="shana"&&d.Low>0){if(s.Wings)boost=1.25;s.Wings=false;}
        local resonance=k=="tohsaka_rin_prismatic_jeweled_sword"&&f.progress(a)>=180&&s.UsedGems.len()>=3;
        if(resonance){boost*=1.3;s.UsedGems={};}
        f.resource(a,-d.Resource);s.Cooldowns[k]<-s.Turn+d.Cooldown;this.m.HitIndex=0;
        if(k=="tohsaka_rin_double_formula")s.Gains.formula<-1;
        f.feedback(a,a,k,"cast",d.Owner!="tokisaki_kurumi"||d.Low==0);
        switch(k)
        {
        case "yakumo_yukari_gap_passage":
            local traveler=this.gapActor();if(!f.move(traveler,tile))return false;s.Gap=null;f.feedback(a,traveler,k,"apply",false);break;
        case "yakumo_yukari_phantasm_curtain":
            local n=0;foreach(b in f.allies(a,a.getTile(),3)){f.shield(b,a,70,15);f.feedback(a,b,k,"apply",false);if(++n>=3)break;}
break;
        case "tokisaki_kurumi_bullet_one_acceleration":s.Gains.acceleration<-1;a.setActionPoints(::Math.min(a.getActionPointsMax(),a.getActionPoints()+3));break;
        case "tokisaki_kurumi_bullet_four_rewind":f.rewind(tile.getEntity(),f.clock(tile.getEntity()).Snapshot);f.feedback(a,tile.getEntity(),k,"apply",false);break;
        case "tokisaki_kurumi_bullet_eight_shadow":s.Shadows=f.progress(a)>=100?2:1;s.ShadowUntil=s.Turn+3;break;
        case "tokisaki_kurumi_bullet_twelve_replay":s.ReplayUsed=true;f.rewind(a,s.Snapshot,true);break;
        case "cirno_ice_wing_guard":f.shield(a,a,80);break;
        case "shana_crimson_wings":if(!f.rush(a,tile))return false;break;
        case "shana_fuzetsu":
            foreach(b in f.enemies(a,a.getTile(),2,2,999))
            {
                if(f.canDebuff(b)){f.effect(b,a,"seal");f.feedback(a,b,k,"apply",false);}
            }
            break;
        default:
            if(k=="shana_heavenly_flame")list=f.enemies(a,tile,1,4,3,tile.getEntity());
            local hits=[];
            foreach(i,b in list)
            {
                if(!f.able(a))break;
                local count=k=="tokisaki_kurumi_dual_gun_volley"||k=="shana_nietono_no_shana"?2:1,localHit=false;
                for(local n=0;n<count;n++)
                {
                    if(!f.alive(b)||!f.able(a))break;
                    if(this.strike(a,b,boost*(k=="shana_heavenly_flame"&&i>0?0.6:1.0),gems))localHit=true;
                }
                if(localHit){hitAny=true;hits.push(b);if(d.Owner=="shana")f.burn(a,b);}
                if(!f.alive(b))killed=true;
            }
            if(gems!=null)
            {
                foreach(g in gems)if(hitAny||g=="emerald"){s.UsedGems[g]<-true;s.BattleGems[g]<-true;}
                if(gems.find("amethyst")!=null)foreach(b in hits)if(f.alive(b)&&f.able(a))this.strike(a,b,0.5,gems,true);
                if(gems.find("emerald")!=null&&f.alive(a))f.shield(a,a,80);
            }
            if(d.Owner=="tokisaki_kurumi"&&d.Low>0)
            {
                if(s.Shadows>0&&s.Turn<s.ShadowUntil&&list.len()>0&&f.enemy(a,list[0],d.Max)&&f.able(a)){s.Shadows--;this.strike(a,list[0],0.7,null,true);}
                ::$bvvar{namespace}.playValkyrieSkillAudioSequence(a,"five_"+k+"_shot",this.m.HitIndex,130);
                if(k=="tokisaki_kurumi_dual_gun_volley"&&hitAny)f.gain(a,"volley",1,2);
            }
            if(k=="tohsaka_rin_jeweled_sword"&&hitAny)f.gain(a,"sword",2,2);
            if(d.Owner=="shana"&&hitAny&&k!="shana_heavenly_flame")f.gain(a,"blade",1,2);
            if(k=="shana_heavenly_flame"&&killed&&f.alive(a)){a.setActionPoints(::Math.min(a.getActionPointsMax(),a.getActionPoints()+3));f.shield(a,a,50);}
            break;
        }
        if(resonance&&f.alive(a))f.resource(a,2);
        if(d.Owner=="yakumo_yukari"&&k!="yakumo_yukari_boundary_train")f.gain(a,"boundary",1,2);
        if(f.alive(a)){a.getSkills().update();a.setDirty(true);}
return true;
    }
});
