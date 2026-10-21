this.five_valkyries_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
    m={BVFiveEffect=true,Source=null,Kind="",Amount=0,Defense=0,SourceTurn=0,TargetStart=0,TargetEnd=0,AppliedRound=0,Ticks=0,Consumed=false,Shattered=false},
    function create(){this.valkyrie_effect_skill.create();this.m.IsStacking=false;this.m.IsHidden=false;this.m.IconMini="status_effect_34_mini";}
    function fv(){return ::$bvvar{namespace}.FiveValkyries;}
    function source(){return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Source);}
    function configure(a,kind,id)
    {
        this.m.Source=::$bvvar{namespace}.makeValkyrieCombatWeakRef(a);this.m.Kind=kind;this.m.ID=id;
        local names={shield="$bv{five.shield}",chill="$bv{five.chill}",freeze="$bv{five.freeze}",slow="$bv{five.slow}",stop="$bv{five.stop}",burn="$bv{five.burn}",seal="$bv{five.seal}"};
        local desc={shield="$bv{five.shield.description}",chill="$bv{five.chill.description}",freeze="$bv{five.freeze.description}",slow="$bv{five.slow.description}",stop="$bv{five.stop.description}",burn="$bv{five.burn.description}",seal="$bv{five.seal.description}"};
        local icons={shield="cirno_ice_wing_guard",chill="cirno_icicle_volley",freeze="cirno_perfect_freeze",slow="tokisaki_kurumi_bullet_two_delay",stop="tokisaki_kurumi_bullet_seven_time_stop",burn="shana_nietono_no_shana",seal="shana_fuzetsu"};
        this.m.Name=names[kind];this.m.Description=desc[kind];this.m.Icon="skills/$bvvar{iconPrefix}/"+icons[kind]+".png";
    }
    function valid()
    {
        local f=this.fv(),source=this.source();if(!f.alive(source))return false;
        if(this.m.Kind=="shield"){local s=f.state(source);return s!=null&&s.Turn<this.m.SourceTurn&&this.m.Amount>0;}
        return this.m.Kind!="burn"||this.m.Ticks>0;
    }
    function getTooltip()
    {
        local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
        if(this.m.Kind=="shield"||this.m.Kind=="chill"||this.m.Kind=="slow")out.push({id=3,type="text",icon="ui/icons/special.png",text="$bv{five.resource}"+this.m.Amount});
        if(this.m.Defense>0)out.push({id=4,type="text",icon="ui/icons/melee_defense.png",text="$bv{five.curtain.description}"});return out;
    }
    function onUpdate(p)
    {
        if(!this.valid())return;
        if(this.m.Kind=="shield"){p.MeleeDefense+=this.m.Defense;p.RangedDefense+=this.m.Defense;}
        if(this.m.Kind=="seal"){p.MeleeSkill-=15;p.RangedSkill-=15;p.Initiative-=30;}
        if((this.m.Kind=="freeze"||this.m.Kind=="stop")&&this.m.Consumed){p.IsStunned=true;p.IsAbleToUseSkills=false;}
    }
    function onCombatFinished(){this.removeSelf();}
});
