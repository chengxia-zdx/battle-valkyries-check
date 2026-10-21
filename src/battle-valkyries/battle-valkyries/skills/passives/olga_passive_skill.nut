this.olga_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
    function create() { this.valkyrie_passive_skill.create(); }
    function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
    function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
    function onUpdate(p)
    {
        if (this.m.BVSkillKey == "olga_dark_queen" && ::$bvvar{namespace}.Olga.supported(this.actor())) p.ActionPoints += ::$bvvar{namespace}.Olga.stage(this.actor());
    }
    function onValkyrieCombatEvent(e)
    {
        local f = ::$bvvar{namespace}.Olga, a = this.actor();
        if (this.m.BVSkillKey != "olga_dark_queen" || !f.supported(a) || e.Type != "TargetResolved" || e.Attacker != a || !e.Hit || e.Skill == null || !e.Skill.m.IsWeaponSkill) return;
        local key = f.weaponKey(a, e.Target); if (key != null) f.state(a).WeaponTargets[key] <- true;
    }
    function onCombatStarted() { if (this.m.BVSkillKey == "olga_dark_queen" && this.actor() != null) this.actor().m.BVOlgaState <- null; }
    function onCombatFinished()
    {
        if (this.m.BVSkillKey == "olga_dark_queen" && this.actor() != null) { ::$bvvar{namespace}.Olga.releaseActor(this.actor()); this.actor().m.BVOlgaState <- null; }
        this.skill.onCombatFinished();
    }
});
