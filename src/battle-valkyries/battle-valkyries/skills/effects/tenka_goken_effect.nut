this.tenka_goken_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
    m={Source=null,Kind=null,Amount=0,Until=0,TargetStarts=0,TargetEnd=0},
    function create()
    {
        this.valkyrie_effect_skill.create();this.m.IsRemovedAfterBattle=true;
        this.m.Name="$bv{tenka.effect.name}";this.m.Description="$bv{tenka.effect.description}";
        this.m.Icon="skills/$bvvar{iconPrefix}/onigawara_rin_guard.png";this.m.IsHidden=false;
    }
    function getIcon()
    {
        return this.m.Kind=="pain" ? "skills/$bvvar{iconPrefix}/kikakujo_mary_nerve.png" : "skills/$bvvar{iconPrefix}/onigawara_rin_guard.png";
    }
    function source(){return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Source);}
    function valid()
    {
        local f=::$bvvar{namespace}.TenkaGoken,a=this.source(),target=this.getContainer().getActor();
        if(!f.alive(target))return false;
        if(this.m.Kind=="pain")return f.ends(target)<this.m.TargetEnd;
        return f.alive(a)&&f.armed(a)&&f.state(a).Starts<this.m.Until;
    }
    function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.m.Kind=="protect"?"$bv{tenka.protect}":"$bv{tenka.pain}"}];}
    function onUpdate(p)
    {
        if(!this.valid())return;
        if(this.m.Kind=="protect")p.MeleeDefense+=6;
        else {p.MeleeSkillMult*=0.9;p.RangedSkillMult*=0.9;}
    }
    function onTurnEnd(){if(!this.valid())this.removeSelf();}
});
