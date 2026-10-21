// Identity and stage are durable flags. All battle counters stay on the actor.
::$bvvar{namespace}.Olga <- {
    function api() { return ::$bvvar{namespace}; }
    function alive(a) { return a != null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap(); }
    function supported(a) { return a != null && a.isPlayerControlled() && this.api().getActorValkyrieID(a) == "olga"; }
    function stage(a)
    {
        if (!this.supported(a)) return 0;
        local n = a.getFlags().get("$bvvar{modId}.olga.stage");
        return typeof n == "integer" ? ::Math.max(0, ::Math.min(5, n)) : 0;
    }
    function entitled(a, d) { return this.supported(a) && this.stage(a) >= d.OlgaStage; }
    function skinUnlocked(a, requiredStage)
    {
        if (a != null) return this.supported(a) && this.stage(a) >= requiredStage;
        if (!("World" in ::getroottable()) || ::World == null || !("getPlayerRoster" in ::World)) return false;
        foreach (actor in ::World.getPlayerRoster().getAll())
            if (this.supported(actor) && this.stage(actor) >= requiredStage) return true;
        return false;
    }
    // Media access is derived from the same durable progress as skills, never from a skin.
    function presentation(a)
    {
        local actual = this.stage(a), views = [];
        foreach (i, entry in this.api().OlgaStageViews)
        {
            local view = { Stage = i, Name = entry.Name, Locked = i > actual,
                UnlockHint = i > actual ? "$bv{olga.stage.locked}" : "" };
            if (!view.Locked)
            {
                view.Description <- entry.Description;
                view.DetailMedia <- clone entry.DetailMedia;
            }
            views.push(view);
        }
        return { Type = "olga_stages", ActualStage = actual, StageViews = views };
    }
    // Trusted reward entry point. Corruption challenges establish the entitlement separately.
    function grantStage(a, n)
    {
        if (!this.supported(a) || typeof n != "integer" || n < 0 || n > 5) return false;
        try { if (::Tactical.isActive()) return false; } catch (e) {}
        local old = this.stage(a);
        if (n < old || n > old + 1) return false;
        if (n == old) return true;
        local flags = a.getFlags(), key = "$bvvar{modId}.olga.stage", had = flags.has(key);
        flags.set(key, n);
        local success = false;
        try { success = this.api().syncActorSkills(a, "olga_stage").Success; } catch (e) {}
        if (!success)
        {
            if (had) flags.set(key, old); else flags.remove(key);
            this.api().syncActorSkills(a, "olga_stage_rollback");
            return false;
        }
        a.getSkills().update(); a.setDirty(true); return true;
    }
    function round() { return ::Time.getRound(); }
    function normal(a) { return this.api().EightValkyries.normal(a); }
    function clock(a) { return this.api().FiveValkyries.clock(a); }
    function state(a)
    {
        if (!this.supported(a)) return null;
        if (!("BVOlgaState" in a.m) || a.m.BVOlgaState == null)
            a.m.BVOlgaState <- { RefundRound = -1, AnnihilationRound = -1, EclipseReady = -1, Controls = 0, LastAction = null, WeaponTargets = {}, WeaponAction = null };
        return a.m.BVOlgaState;
    }
    function enemy(a, b) { return this.alive(a) && this.alive(b) && !b.isAlliedWith(a) && b.isAttackable(); }
    function special(b)
    {
        if (b == null) return true;
        foreach (flag in ["$bvvar{modId}.special_story_boss", "$bvvar{modId}.olga.control_immune"])
            if (b.getFlags().has(flag) && b.getFlags().get(flag)) return true;
        return this.api().isValkyrieTemporaryControlDeniedEntityType(b.getType());
    }
    function controlDenial(a, b)
    {
        if (!this.enemy(a, b)) return "$bv{olga.control.invalid}";
        if (this.special(b)) return "$bv{olga.control.special}";
        if (this.api().getValkyrieTemporaryPlayerControlHandlesForController(a).len() != 0) return "$bv{olga.control.occupied}";
        // Only explicit, vanilla human types expose a safe player skill/input surface.
        if (!(b.getType() in this.api().HokusaiHumanTypes)) return "$bv{olga.control.unsafe}";
        if (this.api().getValkyrieTemporaryControlDenialReason(b, a, true) != null) return "$bv{olga.control.unsafe}";
        local other = false;
        foreach (unit in this.api().getValkyrieTemporaryControlActors())
            if (unit != b && this.enemy(a, unit) && !unit.isNonCombatant()) { other = true; break; }
        return other ? null : "$bv{olga.control.last}";
    }
    function effect(b, kind)
    {
        if (!this.alive(b)) return null;
        local id = "$bvvar{modId}.effects.olga_" + kind;
        local e = b.getSkills().getSkillByID(id);
        if (e == null)
        {
            e = ::new("$bvvar{privateFolder}/skills/effects/olga_effect");
            e.configure(kind);
            b.getSkills().add(e);
        }
        e.m.EndAt = this.clock(b).Ends + (kind == "curse" || kind == "erosion" ? 2 : 1);
        b.getSkills().update(); b.setDirty(true);
        return e;
    }
    function cursed(b) { return b.getSkills().hasSkill("$bvvar{modId}.effects.olga_curse"); }
    function refund(a, wasCursed)
    {
        local s = this.state(a);
        if (!wasCursed || s == null || s.RefundRound == this.round() || !this.alive(a)) return false;
        s.RefundRound = this.round();
        a.setFatigue(::Math.max(0, a.getFatigue() - (this.stage(a) >= 3 ? 15 : 10)));
        return true;
    }
    function web(b)
    {
        if (!this.alive(b) || b.getCurrentProperties().IsImmuneToRoot) return false;
        local skills = b.getSkills();
        if (!skills.hasSkill("effects.web")) skills.add(::new("scripts/skills/effects/web_effect"));
        if (!skills.hasSkill("actives.break_free"))
        {
            local escape = ::new("scripts/skills/actives/break_free_skill");
            escape.setDecal("web_destroyed");
            escape.m.Icon = "skills/active_113.png"; escape.m.IconDisabled = "skills/active_113_sw.png";
            escape.m.Overlay = "active_113"; skills.add(escape);
        }
        foreach (entry in [{ Sprite = "status_rooted", Brush = "bust_web2" }, { Sprite = "status_rooted_back", Brush = "bust_web2_back" }])
            if (b.hasSprite(entry.Sprite)) { local sprite = b.getSprite(entry.Sprite); sprite.setBrush(entry.Brush); sprite.Visible = true; }
        skills.update(); b.setDirty(true); return true;
    }
    function control(a, b)
    {
        if (this.controlDenial(a, b) != null) return false;
        local h = this.api().acquireValkyrieTemporaryPlayerControl(b, a, true);
        if (h == null) return false;
        h.Olga <- true;
        h.OlgaEndAt <- this.clock(b).Ends + 1;
        this.effect(b, "control");
        this.state(a).Controls++;
        return true;
    }
    function maintainControls()
    {
        foreach (h in clone this.api().ValkyrieTemporaryControlRuntime.Handles)
        {
            if (!("Olga" in h) || !h.Active || h.Restored) continue;
            local owner = this.api().readValkyrieCombatWeakRef(h.ControllerRef);
            local target = this.api().readValkyrieCombatWeakRef(h.TargetRef);
            if (!this.alive(owner) || !this.alive(target) || this.api().isValkyrieTemporaryControlLastHostile(h))
                this.restoreControl(h, "olga_invalid_or_last");
        }
    }
    function restoreControl(h, reason)
    {
        local target=this.api().readValkyrieCombatWeakRef(h.TargetRef);
        if (!this.api().restoreValkyrieTemporaryPlayerControl(h, reason)) return false;
        if (target!=null)
        {
            local e=target.getSkills().getSkillByID("$bvvar{modId}.effects.olga_control");
            if(e!=null)e.removeSelf();
            target.setDirty(true);
        }
        return true;
    }
    function endNormalTurn(a)
    {
        foreach (e in clone a.getSkills().m.Skills)
            if (e != null && "BVOlgaEffect" in e.m && !e.isGarbage() && this.clock(a).Ends >= e.m.EndAt) e.removeSelf();
        local h = this.api().getValkyrieTemporaryPlayerControlHandle(a);
        if (h != null && "Olga" in h && this.clock(a).Ends >= h.OlgaEndAt)
            this.restoreControl(h, "olga_normal_turn_complete");
        if (this.alive(a)) { a.getSkills().update(); a.setDirty(true); }
    }
    function releaseActor(a)
    {
        foreach (h in clone this.api().ValkyrieTemporaryControlRuntime.Handles)
            if ("Olga" in h && (this.api().readValkyrieCombatWeakRef(h.TargetRef) == a || this.api().readValkyrieCombatWeakRef(h.ControllerRef) == a))
                this.restoreControl(h, "olga_actor_exit");
    }
    function isSpell(skill) { return skill != null && "m" in skill && "BVOlgaSpell" in skill.m && skill.m.BVOlgaSpell; }
    function weaponKey(a, b)
    {
        local s = this.state(a), c = this.api().getCurrentValkyrieActionContext(a);
        if (s == null || c == null || b == null) return null;
        if (s.WeaponAction != c.ActionToken) { s.WeaponAction = c.ActionToken; s.WeaponTargets = {}; }
        return b.getID().tostring();
    }
};

// Final property normalization runs after every skill/perk callback, like Hokusai.
::$bvvar{namespace}.finalizeOlgaProperties <- function(a, skill, b, p)
{
    local f = this.Olga;
    if (!f.supported(a) || skill == null) return p;
    if (f.isSpell(skill) && skill.isAttack()) { skill.finalizeSpellProperties(p); return p; }
    if (this.isDirectAttack(skill) && skill.m.IsWeaponSkill && !("BVOlgaBonus" in p))
    {
        local key = f.weaponKey(a, b), s = f.state(a);
        if (key == null || !(key in s.WeaponTargets))
        {
            local amount = ::Math.floor(a.getCurrentProperties().getBravery() * 0.5);
            p.DamageRegularMin += amount; p.DamageRegularMax += amount; p.BVOlgaBonus <- true;
        }
    }
    return p;
};
