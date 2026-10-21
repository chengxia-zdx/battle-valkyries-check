this.eight_valkyries_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
    m={ Source=null, Kind="", Until=0, Amount=0, TargetEnd=0 },
    function create()
    {
        this.valkyrie_effect_skill.create();this.m.IsStacking=false;this.m.IsHidden=false;
        this.m.IconMini="status_effect_34_mini";this.m.Overlay="";
    }
    function source(){return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Source);}
    function configure(a,kind,id)
    {
        this.m.Source=::$bvvar{namespace}.makeValkyrieCombatWeakRef(a);this.m.Kind=kind;this.m.ID=id;
        local names={shield="$bv{eight.shield}",realm="$bv{eight.realm}",guard="$bv{eight.guard}",mark="$bv{eight.mark}",study="$bv{eight.study}",suppression="$bv{eight.suppression}",slow="$bv{eight.slow}"};
        local descriptions={shield="$bv{eight.shield.description}",realm="$bv{eight.realm.description}",guard="$bv{eight.guard.description}",mark="$bv{eight.mark.description}",study="$bv{eight.study.description}",suppression="$bv{eight.suppression.description}",slow="$bv{eight.slow.description}"};
        this.m.Name=names[kind];this.m.Description=descriptions[kind];
        local icons={shield="argente_silver_guard",realm="suisui_river_realm",guard="argente_silver_shelter",mark="sekka_foxfire_path",study="shizuna_silver_parry",suppression="sorasaki_hina_cold_prefect",slow="argente_wing_shield_bash"};
        this.m.Icon="skills/$bvvar{iconPrefix}/"+icons[kind]+".png";
    }
    function valid()
    {
        local e=::$bvvar{namespace}.EightValkyries,a=this.source();if(!e.alive(a))return false;
        local s=e.state(a);if(s==null||s.Turn>=this.m.Until)return false;
        if(this.m.Kind=="study")return ::$bvvar{namespace}.readValkyrieCombatWeakRef(s.Study)==this.getContainer().getActor();
        if(this.m.Kind=="suppression"||this.m.Kind=="slow")
        {local b=this.getContainer().getActor();return !("BVEightNormalEnds" in b.m)||b.m.BVEightNormalEnds<this.m.TargetEnd;}
        return true;
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
        if(this.m.Kind=="shield")out.push({id=3,type="text",icon="ui/icons/health.png",text="$bv{eight.barrier}"+this.m.Amount});
        if(this.m.Kind=="suppression"||this.m.Kind=="slow")out.push({id=4,type="text",icon="ui/icons/time.png",text="$bv{eight.target_expiry}"});
        else
        {
            local s=::$bvvar{namespace}.EightValkyries.state(this.source()),remaining=s==null ? 0 : ::Math.max(0,this.m.Until-s.Turn);
            out.push({id=4,type="text",icon="ui/icons/time.png",text="$bv{eight.remaining}"+remaining});
        }
        return out;
    }
    function onUpdate(p)
    {
        if(!this.valid())return;
        local e=::$bvvar{namespace}.EightValkyries;
        if(this.m.Kind=="suppression"){p.MeleeSkill-=15;p.RangedSkill-=15;p.Initiative-=20;}
        if(this.m.Kind=="slow")p.Initiative-=30;
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        if(this.m.Kind=="realm"&&this.valid()&&::$bvvar{namespace}.EightValkyries.fieldContains(this.source(),this.getContainer().getActor()))p.DamageReceivedTotalMult*=0.8;
    }
    function onAnySkillUsed(skill,target,p)
    {
        if(!this.valid()||skill==null||!skill.isAttack())return;
        local e=::$bvvar{namespace}.EightValkyries,a=this.getContainer().getActor();
        if(this.m.Kind=="suppression"&&target==this.source())p.DamageTotalMult*=0.85;
        if(this.m.Kind=="realm"&&e.fieldContains(this.source(),a))
        {
            local context=::$bvvar{namespace}.getCurrentValkyrieActionContext(a,skill);
            if(e.paid(context))p.DamageTotalMult*=1.2;
        }
    }
    function onTurnStart(){if(!this.valid())this.removeSelf();}
    function onTurnEnd(){if(!this.valid())this.removeSelf();}
});
