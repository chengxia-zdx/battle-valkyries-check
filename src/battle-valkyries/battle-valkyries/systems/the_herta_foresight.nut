// Final per-attack snapshot; shared container hook owns integration.
::$bvvar{namespace}.HertaForesight <- {
    SwordID = "$bvvar{modId}.weapon.the_herta_answer_foreordained",

    function applies(actor, skill)
    {
        if (actor == null || skill == null) return false;
        if (::$bvvar{namespace}.isActorDeadOrDying(actor)) return false;
        if (::$bvvar{namespace}.getActorFlagString(actor, ::$bvvar{namespace}.ValkyrieIDFlag) != "the_herta") return false;
        if (!skill.isAttack() || skill.isRanged()) return false;
        // Read inherited members through the delegate, not `in`.
        try { if (!skill.m.IsWeaponSkill) return false; } catch (e) { return false; }
        local weapon = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (weapon == null || weapon.getID() != this.SwordID) return false;
        // Explicit source ownership excludes shield attacks, unarmed and spells.
        // The real weapon must bind its actives with the same item reference.
        try { return skill.getHertaSourceWeapon() == weapon; } catch (e) { return false; }
    },

    function finalize(actor, skill, properties)
    {
        if (properties == null || !this.applies(actor, skill)) return properties;
        local result = clone properties;
        // Idempotence lives only on the per-use snapshot, never on the actor.
        if ("HertaForesightApplied" in result && result.HertaForesightApplied) return result;
        local melee = result.MeleeSkill * result.MeleeSkillMult;
        local ranged = result.RangedSkill * result.RangedSkillMult;
        result.MeleeSkill = melee + (ranged > 0 ? ranged : 0);
        result.MeleeSkillMult = 1.0;
        result.HertaForesightApplied <- true;
        return result;
    }
};
