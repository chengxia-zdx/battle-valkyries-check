// One data-bound runner; the catalog owns stable skill IDs and numerical specs.
this.eight_valkyries_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    m={ Spec=null, Cast=null, HitSpec=null, HitIndex=0 },
    function ev(){return ::$bvvar{namespace}.EightValkyries;}
    function actor(){return this.getContainer()==null?null:this.getContainer().getActor();}
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
        this.m.IsTargeted=s.Target!="self";this.m.IsTargetingActor=s.Target=="enemy"||s.Target=="enemy_buff"||s.Target=="ally";
        this.m.IsAttack=s.Target=="enemy";this.m.IsRanged=this.m.IsAttack&&!s.Melee;
        this.m.IsWeaponSkill=this.m.IsAttack&&s.Weapon;this.m.IsShieldRelevant=!s.IgnoreShield;
        this.m.DirectDamageMult=s.Pierce;
    }
    function retreat()
    {
        if(this.m.BVSkillKey!="sekka_returning_shadow")return false;
        local s=this.ev().state(this.actor());return s!=null&&s.Retreat&&!s.RetreatUsed;
    }
    function getActionPointCost(){return this.retreat()?0:this.skill.getActionPointCost();}
    function getFatigueCost(){return this.retreat()?0:this.skill.getFatigueCost();}
    function isValkyrieWeaponSkillPolicyOptOut(){return !this.m.IsAttack;}
    function isUsable()
    {
        local e=this.ev(),a=this.actor(),s=e.state(a),d=this.m.Spec,key=this.m.BVSkillKey;
        if(s==null||s.ID!=d.Owner||s.CustomMove||!e.able(a)||!this.skill.isUsable())return false;
        if(!this.retreat()&&!e.ready(a,key))return false;
        if((this.m.IsWeaponSkill||key=="misono_mika_star_magazine"||key=="sorasaki_hina_cool_reload")&&!e.armed(a,d.Owner))return false;
        if(d.Target=="move"&&a.getCurrentProperties().IsRooted)return false;
        if(d.Owner=="sorasaki_hina")
        {
            if(s.Resource+d.Resource>8)return false;
            if(key=="sorasaki_hina_final_sweep"&&e.adjacent(a))return false;
            if(key=="sorasaki_hina_cool_reload"&&s.Resource==0&&a.getFatigue()==0)return false;
        }
        else if(s.Resource<d.Resource)return false;
        if(key=="misono_mika_star_magazine"&&s.Resource>=3)return false;
        if(key=="lumiore_golden_dragon"&&s.Prestige<3)return false;
        return true;
    }
    function onVerifyTarget(origin,tile)
    {
        local e=this.ev(),a=this.actor(),d=this.m.Spec,k=this.m.BVSkillKey;
        if(!e.alive(a)||tile==null)return false;
        if(d.Target=="self")return tile.ID==origin.ID;
        local range=origin.getDistanceTo(tile);
        if(range<d.Min||range>d.Max||!e.los(origin,tile,d.Max)||!this.skill.onVerifyTarget(origin,tile))return false;
        if(d.Target=="move")
        {
            if(e.path(a,tile,d.Max)==null)return false;
            if(k=="misono_mika_trinity_breach"&&e.enemies(a,tile,2,d.Max+2,1).len()==0)return false;
            if(this.retreat()&&tile.getZoneOfControlCountOtherThan(a.getAlliedFactions())>0)return false;
            return true;
        }
        if(d.Target=="ground")return tile.IsVisibleForEntity;
        if(!tile.IsOccupiedByActor)return false;local b=tile.getEntity();
        if(d.Target=="ally")return e.ally(a,b,k!="argente_silver_shelter");
        if(!e.enemy(a,b,d.Max))return false;
        if(k=="shizuna_black_flash"&&e.approach(a,b)==null)return false;
        return true;
    }
    function targets(tile)
    {
        local e=this.ev(),a=this.actor(),k=this.m.BVSkillKey;
        if(tile==null||!tile.IsOccupiedByActor)return [];
        local b=tile.getEntity();
        if(k=="sorasaki_hina_final_sweep")return e.cone(a,b);
        if(k=="lumiore_golden_dragon")return e.enemies(a,tile,2,8,5,b);
        if(k=="sekka_nine_tail_resolve")return e.enemies(a,tile,1,3,3,b);
        return [b];
    }
    function getAffectedTiles(tile)
    {
        local k=this.m.BVSkillKey;
        if(k=="suisui_river_realm"||k=="xin_myriad_palace")return ::$bvvar{namespace}.getValkyrieRadiusTiles(tile,k=="suisui_river_realm"?2:3,true);
        if(k=="sorasaki_hina_final_sweep"||k=="lumiore_golden_dragon"||k=="sekka_nine_tail_resolve")
        {local out=[];foreach(a in this.targets(tile))out.push(a.getTile());return out;}
        return [tile];
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}];
        local s=this.ev().state(this.actor());if(s==null)return out;
        if(s.Cap>0)out.push({id=4,type="text",icon="ui/icons/special.png",text="$bv{eight.state}"+s.Resource+" / "+s.Cap});
        if(s.ID=="lumiore")out.push({id=5,type="text",icon="ui/icons/special.png",text="$bv{eight.prestige}"+s.Prestige+" / 3"});
        local cd=this.m.BVSkillKey in s.Cooldowns?::Math.max(0,s.Cooldowns[this.m.BVSkillKey]-s.Turn):0;
        out.push({id=6,type="text",icon="ui/icons/time.png",text="$bv{eight.cooldown}"+cd});
        if(!this.isUsable())out.push({id=7,type="text",icon="ui/icons/warning.png",text="$bv{eight.unavailable}"});return out;
    }
    function onTargetSelected(tile)
    {
        this.skill.onTargetSelected(tile);
        local k=this.m.BVSkillKey;
        if(k=="suisui_river_realm"||k=="xin_myriad_palace"||k=="sorasaki_hina_final_sweep"||k=="lumiore_golden_dragon"||k=="sekka_nine_tail_resolve")
            foreach(t in this.getAffectedTiles(tile))this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
    }
    function onAnySkillUsed(skill,target,p)
    {
        if(skill!=this||!this.m.IsAttack)return;
        local e=this.ev(),a=this.actor(),d=this.m.HitSpec==null?this.m.Spec:this.m.HitSpec;
        local r=this.m.Cast==null?e.resolve(a):this.m.Cast.Resolve;
        if(!d.Weapon)
        {
            local damage=::Math.floor((d.Damage+r*d.Resolve)*("Mult" in d?d.Mult:1.0));
            p.DamageRegularMin=damage;p.DamageRegularMax=damage;p.DamageArmorMult=d.Armor;
            p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
        }
        else if(this.m.Cast!=null)
        {p.DamageRegularMin=this.m.Cast.WeaponMin;p.DamageRegularMax=this.m.Cast.WeaponMax;}
        p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
        if(!d.Weapon){if(d.Melee)p.MeleeSkill+=d.Hit;else p.RangedSkill+=d.Hit;}
        local bonus=this.m.Cast==null?0:this.m.Cast.Aim;
        if(d.Melee)p.MeleeSkill+=bonus;else p.RangedSkill+=bonus;
        if(target!=null&&d.Owner=="misono_mika")
        {local dist=a.getTile().getDistanceTo(target.getTile());p.RangedSkill+=dist<=2?10:-5*::Math.max(0,dist-3);}
        if(target!=null&&d.Owner=="sorasaki_hina")
        {local s=e.state(a);p.RangedSkill+=(s.Moved?0:10)-4*::Math.max(0,a.getTile().getDistanceTo(target.getTile())-4)-(e.adjacent(a)?20:0);}
    }
    function strike(a,b,d,mult=1.0,range=null)
    {
        local e=this.ev();if(!e.able(a)||!e.enemy(a,b,range==null?d.Max:range))return false;
        if(d.Weapon&&(!e.armed(a,d.Owner)||!a.getCurrentProperties().IsAbleToUseWeaponSkills))return false;
        local spec=clone d;spec.Mult<-mult;this.m.HitSpec=spec;
        local previousPierce=this.m.DirectDamageMult,previousShield=this.m.IsShieldRelevant;
        this.m.DirectDamageMult=d.Pierce;this.m.IsShieldRelevant=!d.IgnoreShield;
        local policy=null,hit=false,pos=::$bvvar{namespace}.captureValkyrieSkillAudioPosition(b),tile=b.getTile();
        if(d.Weapon)
        {
            local w=e.weapon(a),armorRatio=d.Armor/::Math.max(0.01,w.m.ArmorDamageMult);
            local pierce=d.Owner=="shizuna"?::Math.min(d.Pierce==0.25?0.75:0.70,w.m.DirectDamageMult+d.Pierce):d.Pierce;
            policy=::$bvvar{namespace}.pushValkyrieWeaponAttackPolicy(a,this,b,w,{WeaponDamageMult=mult,ArmorDamageMult=armorRatio,DirectDamageOverride=pierce,HitChance=d.Hit,IgnoreDistance=true,IgnoreShield=d.IgnoreShield,Source="managed_active"},this);
        }
        try{hit=this.attackEntity(a,b,false);}
        catch(ex){if(policy!=null)::$bvvar{namespace}.popValkyrieWeaponAttackPolicy(policy.Token);this.m.HitSpec=null;this.m.DirectDamageMult=previousPierce;this.m.IsShieldRelevant=previousShield;throw ex;}
        if(policy!=null)::$bvvar{namespace}.popValkyrieWeaponAttackPolicy(policy.Token);
        this.m.HitSpec=null;this.m.DirectDamageMult=previousPierce;this.m.IsShieldRelevant=previousShield;
        if(hit)
        {
            // Capture the tile before damage; lethal hits still display at the victim's position.
            ::$bvvar{namespace}.playValkyrieVisual(this,{getTile=function(){return tile;}},"eight_"+this.m.BVSkillKey+"_impact");
            if(this.m.HitIndex<3&&pos!=null)::$bvvar{namespace}.playValkyrieSkillAudio(a,"eight_"+this.m.BVSkillKey+"_impact",pos);
            if(d.Owner=="sorasaki_hina"&&e.alive(b)&&e.debuffable(b))e.effect(b,a,"suppression",99);
            if(this.m.BVSkillKey=="argente_wing_shield_bash"&&e.alive(b)&&e.debuffable(b))e.effect(b,a,"slow",99);
        }
        this.m.HitIndex++;return hit;
    }
    function freeStrike(a,b,damage,factor,armor,pierce,mult,parent=null,range=6)
    {
        local old=this.m.Cast,d=clone this.m.Spec;d.Damage=damage;d.Resolve=factor;d.Armor=armor;d.Pierce=pierce;d.Hit=20;d.Weapon=false;d.IgnoreShield=false;
        this.m.Cast={Resolve=this.ev().resolve(a),Aim=0};this.m.HitIndex=0;
        local token=::$bvvar{namespace}.pushValkyrieCombatSource("followup",a,{Skill=this,ParentActionToken=parent});local hit=false;
        try{hit=this.strike(a,b,d,mult,range);}
        catch(ex){::$bvvar{namespace}.popValkyrieCombatSource(token);this.m.Cast=old;throw ex;}
        ::$bvvar{namespace}.popValkyrieCombatSource(token);this.m.Cast=old;return hit;
    }
    function onBlackFlashArrived(a,data)
    {
        local e=this.ev(),b=::$bvvar{namespace}.readValkyrieCombatWeakRef(data.Target);
        if(this.isGarbage()||!::$bvvar{namespace}.sameValkyrieCombatObject(this.actor(),a)||!e.able(a)||!e.enemy(a,b,1))return;
        local old=this.m.Cast,spec=clone this.m.Spec;
        spec.IgnoreShield=::$bvvar{namespace}.readValkyrieCombatWeakRef(e.state(a).Study)==b;
        this.m.Cast=data.Cast;
        try{if(this.strike(a,b,spec,1.4,1))e.gainOnce(a,"hit",1);}
        catch(ex){this.m.Cast=old;throw ex;}
        this.m.Cast=old;
    }
    function onTrinityBreachArrived(a,data)
    {
        if(!this.isGarbage()&&::$bvvar{namespace}.sameValkyrieCombatObject(this.actor(),a)&&this.ev().able(a))this.ev().shield(a,a,40,1);
    }
    function onUse(a,tile)
    {
        local e=this.ev(),d=this.m.Spec,k=this.m.BVSkillKey,s=e.state(a);
        if(!this.isUsable()||!this.onVerifyTarget(a.getTile(),tile))return false;
        local list=this.targets(tile),center=tile,freeRetreat=this.retreat(),nine=s.Resource==9;
        local w=e.weapon(a);this.m.Cast={Resolve=e.resolve(a),Aim=d.Owner=="sekka"&&s.MoveAim?15:0,WeaponMin=w==null?0:w.m.RegularDamage,WeaponMax=w==null?0:w.m.RegularDamageMax};this.m.HitIndex=0;
        if(this.m.IsAttack)s.MoveAim=false;
        if(freeRetreat){s.Retreat=false;s.RetreatUsed=true;}
        else
        {
            s.Cooldowns[k]<-s.Turn+d.Cooldown;
            if(d.Owner=="sorasaki_hina")e.resource(a,d.Resource);
            else e.resource(a,-(k=="sekka_nine_tail_resolve"&&nine?9:d.Resource));
            if(d.Owner=="lumiore")s.Prestige=k=="lumiore_golden_dragon" ? 0 : ::Math.min(3,s.Prestige+d.Resource);
        }
        local visualTarget=d.Target=="ground"?{getTile=function(){return tile;}}:a;
        e.feedback(a,visualTarget,k,"cast",!(d.Weapon&&!d.Melee&&this.m.IsAttack));
        local failed=null;
        try{this.execute(a,tile,list,freeRetreat,nine);}
        catch(ex){failed=ex;}
        this.m.Cast=null;this.m.HitSpec=null;
        if(failed!=null)throw failed;
        if(d.Owner=="lumiore"&&d.Resource>0&&!s.Echo&&e.able(a))
        {
            s.Echo=true;
            if(d.Target=="self"){local near=e.enemies(a,a.getTile(),5,5,1);center=near.len()>0?near[0].getTile():null;}
            if(center!=null)
            {
                local attack=::$bvvar{namespace}.getRuntimeSkillByKey(a,"lumiore_golden_breath"),context=::$bvvar{namespace}.getCurrentValkyrieActionContext(a,this);
                local echoes=e.enemies(a,center,1,7,3);
                if(attack!=null&&echoes.len()>0){e.feedback(a,a,"lumiore_golden_prestige","cast");foreach(b in echoes)attack.freeStrike(a,b,25,0.25,1.5,0.35,1,context==null?null:context.ActionToken,7);}
            }
        }
        if(e.alive(a)){a.getSkills().update();a.setDirty(true);}
return true;
    }
    function execute(a,tile,list,freeRetreat,nine)
    {
        local e=this.ev(),d=this.m.Spec,k=this.m.BVSkillKey,s=e.state(a),r=this.m.Cast.Resolve;
        switch(k)
        {
        case "suisui_water_fan":
            if(this.strike(a,list[0],d))foreach(b in e.enemies(a,tile,1,6,9))if(b!=list[0]){this.strike(a,b,d,0.5,6);break;}
            break;
        case "suisui_spring_mountain":
            local recipients=[tile.getEntity()];foreach(b in e.allies(a,tile,1))if(b!=recipients[0]&&b.getHitpoints()<b.getHitpointsMax()&&recipients.len()<3)recipients.push(b);
            foreach(b in recipients){local changed=e.heal(b,25+0.15*r);changed=e.cleanse(b)||changed;if(changed)e.feedback(a,b,k,"apply",false);}
break;
        case "suisui_river_realm": case "xin_myriad_palace":
            s.Field=tile;s.FieldUntil=s.Turn+2;
            if(s.ID=="xin")s.Resource=3;
            else foreach(b in ::World.getPlayerRoster().getAll())if(e.ally(a,b))
            {e.effect(b,a,"realm",2);if(e.fieldContains(a,b)){e.heal(b,20);e.feedback(a,b,k,"apply",false);}}
            e.refreshFields();break;
        case "misono_mika_starlight_burst":case "sorasaki_hina_cold_burst":case "misono_mika_kyrie_eleison":
            local count=k=="misono_mika_kyrie_eleison"?5:2,b=list[0],scale=k=="misono_mika_kyrie_eleison"?1+0.25*b.getHitpoints()/b.getHitpointsMax().tofloat():1.0;
            for(local i=0;i<count;i++)
            {
                if(!e.able(a)||!e.enemy(a,b,d.Max))break;
                this.strike(a,b,d,scale*(count==5?(i==4?2.2:0.45):(s.ID=="sorasaki_hina"?0.8:1.0)));
            }
            ::$bvvar{namespace}.playValkyrieSkillAudioSequence(a,"eight_"+k+"_shot",this.m.HitIndex,130);break;
        case "misono_mika_trinity_breach":
            e.move(a,e.path(a,tile,2),false,this.onTrinityBreachArrived.bindenv(this));break;
        case "misono_mika_star_magazine":s.Resource=3;break;
        case "sorasaki_hina_cool_reload":e.resource(a,-6);a.setFatigue(::Math.max(0,a.getFatigue()-20));break;
        case "sorasaki_hina_final_sweep":
            foreach(b in list)for(local i=0;i<4;i++){if(!e.able(a)||!e.enemy(a,b,6))break;this.strike(a,b,d,0.65);}
            ::$bvvar{namespace}.playValkyrieSkillAudioSequence(a,"eight_"+k+"_shot",::Math.min(4,this.m.HitIndex),130);break;
        case "xin_worldly_form":if(this.strike(a,list[0],d))e.gainOnce(a,"basic",1);break;
        case "xin_unified_thought":e.resource(a,2);s.WardUntil=s.Turn+1;s.WardToken=null;break;
        case "shizuna_silver_parry":s.Study=::$bvvar{namespace}.makeValkyrieCombatWeakRef(list[0]);s.StudyUntil=s.Turn+2;e.effect(list[0],a,"study",2);break;
        case "shizuna_black_flash":
            local b=list[0];
            e.move(a,e.approach(a,b),true,this.onBlackFlashArrived.bindenv(this),
                {Target=::$bvvar{namespace}.makeValkyrieCombatWeakRef(b),Cast=this.m.Cast});break;
        case "shizuna_severing_world":
            local b=list[0],studied=::$bvvar{namespace}.readValkyrieCombatWeakRef(s.Study)==b;
            if(studied){s.Study=null;local mark=e.findEffect(b,a,"study");if(mark!=null)mark.removeSelf();}
            if(this.strike(a,b,d,studied?4.0:3.4))e.gainOnce(a,"hit",1);break;
        case "lumiore_golden_breath":this.strike(a,list[0],d);break;
        case "lumiore_burning_scales":a.setFatigue(::Math.max(0,a.getFatigue()-25));break;
        case "lumiore_golden_dragon":foreach(b in list)this.strike(a,b,d,1,8);break;
        case "argente_wing_shield_bash":this.strike(a,list[0],d);break;
        case "argente_silver_shelter":
            s.Guard=::$bvvar{namespace}.makeValkyrieCombatWeakRef(list[0]);s.GuardUntil=s.Turn+2;e.shield(list[0],a,70,2);e.feedback(a,list[0],k,"apply",false);break;
        case "argente_silver_oath":
            local n=0;foreach(b in e.allies(a,a.getTile(),2))
            {e.shield(b,a,55,2);e.heal(b,20);if(b!=a)e.effect(b,a,"guard",1);e.feedback(a,b,k,"apply",false);if(++n>=5)break;}
break;
        case "sekka_foxfire_path":
            if(this.strike(a,list[0],d)){e.gainOnce(a,"hit",1,2);if(e.alive(list[0]))e.effect(list[0],a,"mark",2);}
break;
        case "sekka_returning_shadow":e.move(a,e.path(a,tile,3));if(!freeRetreat&&e.alive(a))e.resource(a,2);break;
        case "sekka_nine_tail_resolve":
            local at=0,marked={},spec=clone d;if(nine){spec.Damage=95;spec.Resolve=0.4;}
            for(local i=0;i<3;i++)
            {
                while(at<list.len()&&!e.alive(list[at]))at++;
                if(at>=list.len()||!e.able(a)||!e.enemy(a,list[at],3))break;
                local b=list[at],id=b.getID();
                if(!(id in marked)){local mark=e.findEffect(b,a,"mark");marked[id]<-mark!=null;if(mark!=null)mark.removeSelf();}
                local hit=this.strike(a,b,spec,marked[id]?1.25:1.0);
                if(hit&&!e.alive(b)&&e.alive(a)&&!s.RetreatUsed)s.Retreat=true;
            }
break;
        }
    }
});
