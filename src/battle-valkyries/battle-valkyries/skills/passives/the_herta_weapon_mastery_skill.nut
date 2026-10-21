this.the_herta_weapon_mastery_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
    function create() { this.valkyrie_passive_skill.create(); }
    function getTooltip()
    {
        local ret = this.getDefaultTooltip();
        local sword = ::$bvvar{namespace}.HertaCombat.sword(this.getContainer().getActor());
        ret.push({id=20,type="text",icon="ui/icons/special.png",text=sword ? "$bv{skill.the_herta_weapon_mastery.sword}" : "$bv{skill.the_herta_weapon_mastery.staff}"});
        return ret;
    }
    function onUpdate(p)
    {
        // The sword stance trades range for a real front-line defensive benefit.
        local a=this.getContainer().getActor();
        if (::$bvvar{namespace}.HertaCombat.sword(a)) p.MeleeDefense += ::$bvvar{namespace}.hasHertaBondUpgrade(a,60) ? 20 : 15;
    }
    function onTargetHit(skill, target, part, hp, armor)
    {
        local a = this.getContainer().getActor(), combat = ::$bvvar{namespace}.HertaCombat, s = combat.state(a);
        if (s == null || !s.Active || s.StaffSpent || !combat.staff(a) || skill == null
            || skill.getID() != ::$bvvar{namespace}.getValkyrieSkillRuntimeID("the_herta_starlit_query")) return;
        local recovery=::$bvvar{namespace}.hasHertaBondUpgrade(a,20) ? 5 : 3;
        s.StaffSpent = true; a.setFatigue(::Math.max(0, a.getFatigue() - recovery));
    }
});
