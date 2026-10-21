this.olga_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
    m = { BVOlgaEffect = true, Kind = "", EndAt = 999999 },
    function create() { this.valkyrie_effect_skill.create(); this.m.IsStacking = false; this.m.IsHidden = false; this.m.IconMini = "status_effect_34_mini"; }
    function configure(kind)
    {
        this.m.Kind = kind; this.m.ID = "$bvvar{modId}.effects.olga_" + kind;
        if (kind == "control")
        {
            this.m.Name = "$bv{skill.olga_soul_enslavement.name}";
            this.m.Description = "$bv{olga.effect.control.description}";
            this.m.Icon = "skills/$bvvar{iconPrefix}/olga_soul_enslavement.png";
            return;
        }
        local names = { curse = "$bv{skill.olga_queen_curse.name}", erosion = "$bv{skill.olga_dark_erosion.name}", stun = "$bv{olga.effect.stun.name}", daze = "$bv{olga.effect.daze.name}" };
        local descriptions = { curse = "$bv{olga.effect.curse.description}", erosion = "$bv{olga.effect.erosion.description}", stun = "$bv{olga.effect.stun.description}", daze = "$bv{olga.effect.daze.description}" };
        this.m.Name = names[kind]; this.m.Description = descriptions[kind];
        this.m.Icon = "skills/$bvvar{iconPrefix}/" + (kind == "curse" ? "olga_queen_curse" : (kind == "erosion" ? "olga_dark_erosion" : "olga_soul_shock")) + ".png";
    }
    function getTooltip()
    {
        local a = this.getContainer().getActor();
        return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
            { id = 3, type = "text", icon = "ui/icons/time.png", text = "$bv{olga.effect.turns}" + ::Math.max(0, this.m.EndAt - ::$bvvar{namespace}.Olga.clock(a).Ends) }];
    }
    function isHidden()
    {
        if(this.m.Kind!="control")return this.m.IsHidden;
        local a=this.getContainer()==null?null:this.getContainer().getActor(),h=::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(a);
        return h==null || !h.Active || h.Restored;
    }
    function onUpdate(p)
    {
        if (this.m.Kind == "control")
        {
            local a=this.getContainer().getActor(),h=::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(a);
            if (h==null || !h.Active || h.Restored || a.getFaction()==h.OriginalFaction) this.removeSelf();
        }
        if (this.m.Kind == "curse") { p.MeleeSkill -= 15; p.RangedSkill -= 15; p.MeleeDefense -= 15; p.RangedDefense -= 15; p.Bravery -= 20; }
        if (this.m.Kind == "erosion") { p.MeleeDefense -= 10; p.RangedDefense -= 10; p.Bravery -= 10; }
        if (this.m.Kind == "stun") { p.IsStunned = true; p.IsAbleToUseSkills = false; }
        if (this.m.Kind == "daze") { p.InitiativeMult *= 0.75; p.StaminaMult *= 0.75; p.DamageTotalMult *= 0.75; }
    }
    function onAnySkillUsed(skill, target, p)
    {
        if (this.m.Kind == "curse" && ::$bvvar{namespace}.isDirectAttack(skill) && !("BVOlgaCurse" in p))
        { p.DamageTotalMult *= 0.8; p.BVOlgaCurse <- true; }
    }
    function onCombatFinished() { this.removeSelf(); }
});
