::$bvvar{namespace}.HertaCombat <- {
    function api() { return ::$bvvar{namespace}; },
    function owns(a) { return a != null && this.api().getActorValkyrieID(a) == "the_herta" && a.isPlayerControlled(); },
    function weapon(a)
    {
        if (!this.owns(a) || a.getItems() == null) return null;
        local w = a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        return w != null && (w.getID() == "$bvvar{modId}.weapon.the_herta_answer_foreordained"
            || w.getID() == "$bvvar{modId}.weapon.the_herta_unending_inquiry") ? w : null;
    },
    function sword(a) { local w = this.weapon(a); return w != null && w.getID() == "$bvvar{modId}.weapon.the_herta_answer_foreordained"; },
    function staff(a) { local w = this.weapon(a); return w != null && !this.sword(a); },
    function state(a)
    {
        if (!this.owns(a)) return null;
        if (!("BVHertaCombat" in a.m)) a.m.BVHertaCombat <- {
            Active = false, Inspiration = 0, LastRound = -1, GainSpent = false, StaffSpent = false,
            PremiseSpent = false, StepSpent = false, ReturnSpent = false, UltimateRefundSpent = false
        };
        return a.m.BVHertaCombat;
    },
    function start(a)
    {
        local s = this.state(a); if (s == null) return;
        s.Active = true; s.Inspiration = 2; s.LastRound = -1;
        s.GainSpent = false; s.StaffSpent = false; s.PremiseSpent = false; s.StepSpent = false;
        s.ReturnSpent = false; s.UltimateRefundSpent = false;
    },
    function turn(a)
    {
        local s = this.state(a);
        if (s == null || !s.Active || !this.api().EightValkyries.normal(a) || s.LastRound == ::Time.getRound()) return;
        s.LastRound = ::Time.getRound();
        s.GainSpent = false; s.StaffSpent = false; s.PremiseSpent = false; s.StepSpent = false;
    },
    function finish(a)
    {
        local s = this.state(a); if (s != null) { s.Active = false; s.Inspiration = 0; }
        if ("HertaAstrolabe" in this.api()) this.api().HertaAstrolabe.release(a);
    },
    function add(a, amount)
    {
        local s = this.state(a); if (s == null || !s.Active) return 0;
        s.Inspiration = ::Math.max(0, ::Math.min(4, s.Inspiration + amount)); return s.Inspiration;
    },
    function syncWeapon(a)
    {
        if (!this.owns(a)) return;
        local w = this.weapon(a), sword = this.sword(a);
        foreach (key in ["the_herta_starlit_query", "the_herta_verdict_slash", "the_herta_star_step",
            "the_herta_orbit_cleave", "the_herta_final_verdict", "the_herta_weapon_mastery"])
        {
            local enabled = w != null && (key == "the_herta_weapon_mastery" || (sword ? key != "the_herta_starlit_query" : key == "the_herta_starlit_query"));
            if (enabled)
            {
                local result = this.api().attachTransientSkill(a, key, "$bvvar{modId}.owner.herta.weapon");
                if (!result.Success) throw "[Battle Valkyries] Herta weapon skill attachment failed: " + key + " " + result.Code;
                local skill = a.getSkills().getSkillByID(this.api().getValkyrieSkillRuntimeID(key));
                if (skill != null && key != "the_herta_weapon_mastery") skill.setItem(w);
            }
            else this.api().detachTransientSkill(a, key, "$bvvar{modId}.owner.herta.weapon");
        }
    }
};
