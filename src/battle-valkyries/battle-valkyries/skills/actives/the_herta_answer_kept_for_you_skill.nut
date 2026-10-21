this.the_herta_answer_kept_for_you_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    function create()
    {
        this.valkyrie_active_skill.create(); this.m.IsTargeted=false; this.m.IsTargetingActor=false;
        this.m.IsAttack=false; this.m.IsWeaponSkill=false; this.m.ActionPointCost=2; this.m.FatigueCost=10;
    }
    function eligible()
    {
        local a=this.getContainer()==null?null:this.getContainer().getActor();
        local s=::$bvvar{namespace}.HertaCombat.state(a);
        return a!=null && !::$bvvar{namespace}.isActorDeadOrDying(a) && a.isPlacedOnMap()
            && ::$bvvar{namespace}.hasHertaBondUpgrade(a,100) && s!=null && s.Active && !s.ReturnSpent && s.Inspiration<4;
    }
    function isUsable() { return this.skill.isUsable() && this.eligible(); }
    function onUse(user,tile)
    {
        if (!this.eligible() || user!=this.getContainer().getActor()) return false;
        local s=::$bvvar{namespace}.HertaCombat.state(user); s.ReturnSpent=true; s.Inspiration=4;
        ::$bvvar{namespace}.playValkyrieVisual(this,user,"the_herta_vow"); return true;
    }
    function getTooltip()
    {
        local ret=this.getDefaultTooltip();
        if (!this.eligible()) ret.push({id=20,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.the_herta_answer_kept_for_you.unavailable}"});
        return ret;
    }
});
