this.olga_spell_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    m = { BVOlgaSpell = true, Spec = null, CastResolve = null },
    function create()
    {
        this.valkyrie_active_skill.create();
        this.m.IsWeaponSkill = false; this.m.IsRanged = true; this.m.IsUsingHitchance = false;
        this.m.IsShowingProjectile = false; this.m.IsDoingAttackMove = false;
        this.m.IsShieldRelevant = false; this.m.IsIgnoredAsAOO = true; this.m.IsVisibleTileNeeded = true;
        this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 99;
    }
    function onValkyrieSkillBound(d)
    {
        this.m.Spec = d.Spec; local s = this.m.Spec;
        this.m.ActionPointCost = s.AP; this.m.FatigueCost = s.Fatigue;
        this.m.MinRange = s.Min; this.m.MaxRange = s.Max; this.m.DirectDamageMult = s.Pierce;
        this.m.IsAttack = s.Base > 0; this.m.IsTargeted = true; this.m.IsTargetingActor = s.Radius == 0; this.m.IsAOE = s.Radius > 0;
    }
    function f() { return ::$bvvar{namespace}.Olga; }
    function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
    function isValkyrieWeaponSkillPolicyOptOut() { return true; }
    function unavailable()
    {
        local f = this.f(), a = this.actor(), s = f.state(a), d = this.m.Spec;
        if (s == null || !f.alive(a) || !::$bvvar{namespace}.EightValkyries.able(a)) return "$bv{olga.unavailable}";
        if (f.stage(a) < d.Stage) return "$bv{olga.stage_locked}";
        if (d.Mode == "annihilation" && s.AnnihilationRound == f.round()) return "$bv{olga.round_used}";
        if (d.Mode == "eclipse" && s.EclipseReady > f.round()) return "$bv{olga.cooldown}" + (s.EclipseReady - f.round());
        if (d.Mode == "control" && s.Controls >= 2) return "$bv{olga.control.exhausted}";
        if (d.Mode == "control" && f.api().getValkyrieTemporaryPlayerControlHandlesForController(a).len() > 0) return "$bv{olga.control.occupied}";
        return null;
    }
    function isUsable() { return this.unavailable() == null && this.skill.isUsable(); }
    function onVerifyTarget(origin, tile)
    {
        local f = this.f(), a = this.actor(), d = this.m.Spec;
        if (!f.alive(a) || origin == null || tile == null || !tile.IsVisibleForEntity) return false;
        local distance = origin.getDistanceTo(tile);
        if (distance < d.Min || distance > d.Max || !origin.hasLineOfSightTo(tile, d.Max)) return false;
        if (d.Radius > 0) return true;
        if (!tile.IsOccupiedByActor || !f.enemy(a, tile.getEntity())) return false;
        return d.Mode != "control" || f.controlDenial(a, tile.getEntity()) == null;
    }
    function getAffectedTiles(tile) { return this.m.Spec.Radius == 0 ? [tile] : this.f().api().getValkyrieRadiusTiles(tile, this.m.Spec.Radius, true); }
    function onTargetSelected(tile)
    {
        this.skill.onTargetSelected(tile);
        if (this.m.Spec.Radius > 0) foreach (t in this.getAffectedTiles(tile)) this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
    }
    function targets(tile) { return this.f().api().getValkyrieEnemyTargetsOnTiles(this.actor(), this.getAffectedTiles(tile)); }
    function damage()
    {
        local resolve = this.m.CastResolve == null ? this.actor().getCurrentProperties().getBravery() : this.m.CastResolve;
        return ::Math.floor(this.m.Spec.Base + this.m.Spec.Resolve * resolve);
    }
    function finalizeSpellProperties(p)
    {
        local d = this.m.Spec, amount = this.damage();
        p.DamageRegularMin = amount; p.DamageRegularMax = amount; p.DamageRegularMult = 1.0; p.DamageArmorMult = d.Armor;
        p.DamageDirectMult = 1.0; p.DamageDirectAdd = 0.0; p.DamageDirectMeleeAdd = 0.0; p.DamageDirectRangedAdd = 0.0;
        p.DamageAdditionalWithEachTile = 0; p.HitChanceAdditionalWithEachTile = 0;
        p.HitChance[::Const.BodyPart.Head] = 0; p.HitChance[::Const.BodyPart.Body] = 100;
        p.HitChanceMult[::Const.BodyPart.Head] = 1.0; p.HitChanceMult[::Const.BodyPart.Body] = 1.0;
    }
    function getTooltip()
    {
        local result = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", text = this.getCostString() }];
        if (this.actor() != null && this.m.IsAttack) result.push({ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{olga.damage}" + this.damage() });
        local reason = this.unavailable();
        if (reason != null) result.push({ id = 5, type = "text", icon = "ui/icons/warning.png", text = reason });
        if (this.m.Spec.Mode == "control") result.push({ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{olga.control.remaining}" + (this.f().state(this.actor()) == null ? 2 : 2 - this.f().state(this.actor()).Controls) });
        return result;
    }
    function onUse(a, tile)
    {
        // Costs have already been paid by the shared action adapter.
        local f = this.f(), bv = f.api(), d = this.m.Spec, s = f.state(a), context = bv.getCurrentValkyrieActionContext(a, this);
        if (this.unavailable() != null || !this.onVerifyTarget(a.getTile(), tile) || context == null || context.IsFree || context.IsImplicit || context.Source != "managed_active") return false;
        if (s.LastAction == context.ActionToken) return false;
        local targets = this.targets(tile);
        if (d.Mode == "control" && !f.control(a, tile.getEntity())) return false;
        s.LastAction = context.ActionToken;
        if (d.Mode == "annihilation") s.AnnihilationRound = f.round();
        if (d.Mode == "eclipse") s.EclipseReady = f.round() + 3;
        bv.playValkyrieSkillAudio(a, this.m.BVSkillKey);
        bv.playValkyrieVisual(this, a, "olga_cast");
        if (d.Mode == "control") { bv.playValkyrieVisual(this, tile.getEntity(), "olga_control"); return true; }
        if (d.Mode == "curse") { f.effect(tile.getEntity(), "curse"); bv.playValkyrieVisual(this, tile.getEntity(), "olga_curse"); return true; }
        // Snapshot curses before any target receives this cast's new eclipse curse.
        local cursed = {}; foreach (b in targets) cursed[b.getID()] <- f.cursed(b);
        this.m.CastResolve = a.getCurrentProperties().getBravery();
        try
        {
            foreach (b in targets)
            {
                if (!f.alive(a)) break;
                if (!f.enemy(a, b)) continue;
                local before = bv.getValkyrieDamageSnapshot(b);
                bv.playValkyrieVisual(this, b, "olga_" + d.Mode);
                local hit = this.attackEntity(a, b, false);
                if (hit) f.refund(a, cursed[b.getID()]);
                if (!f.alive(b)) continue;
                local delta = bv.getValkyrieDamageDelta(b, before);
                if (hit && delta.Hitpoints + delta.Armor > 0) f.effect(b, "erosion");
                if (hit && d.Mode == "shock")
                {
                    local special = f.special(b);
                    b.setActionPoints(special ? ::Math.max(0, b.getActionPoints() - 4) : 0);
                    f.effect(b, special ? "daze" : "stun");
                }
                if (hit && d.Mode == "eclipse") { f.effect(b, "curse"); f.web(b); }
            }
        }
        catch (e) { this.m.CastResolve = null; throw e; }
        this.m.CastResolve = null;
        if (f.alive(a)) { a.getSkills().update(); a.setDirty(true); }
        return true;
    }
});
