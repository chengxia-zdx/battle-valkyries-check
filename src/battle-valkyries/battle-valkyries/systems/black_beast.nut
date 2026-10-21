// Stable identity flags own progress; transient counters survive managed-skill rebuilds.
::$bvvar{namespace}.BlackBeast <- {
    AuraRefreshing = false,
    function api() { return ::$bvvar{namespace}; }
    function owner(a) { return a == null ? null : this.api().getActorValkyrieID(a); }
    function supported(a) { local id = this.owner(a); return a != null && a.isPlayerControlled() && id != null && id in this.api().BlackBeastDefinitions; }
    function alive(a) { return a != null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap(); }
    function able(a) { return this.api().EightValkyries.able(a); }
    function stage(a)
    {
        if (!this.supported(a)) return 0;
        local n = a.getFlags().get("$bvvar{modId}.black_beast.stage");
        return typeof n == "integer" ? ::Math.max(0, ::Math.min(5, n)) : 0;
    }
    function entitled(a, d) { return this.supported(a) && this.owner(a) == d.Spec.Owner && this.stage(a) >= d.BlackBeastStage && (!("BlackBeastMaxStage" in d) || this.stage(a) <= d.BlackBeastMaxStage); }
    function skinUnlocked(a, role, n)
    {
        if (a != null) return this.supported(a) && this.owner(a) == role && this.stage(a) >= n;
        if (!("World" in ::getroottable()) || ::World == null || ::World.getPlayerRoster() == null) return false;
        foreach (b in ::World.getPlayerRoster().getAll()) if (this.supported(b) && this.owner(b) == role && this.stage(b) >= n) return true;
        return false;
    }
    function grantStage(a, n)
    {
        if (!this.supported(a) || typeof n != "integer" || n < 0 || n > 5) return false;
        try { if (::Tactical.isActive()) return false; } catch (e) {}
        local old = this.stage(a); if (n < old || n > old + 1) return false; if (n == old) return true;
        local key = "$bvvar{modId}.black_beast.stage", flags = a.getFlags(), had = flags.has(key), success = false;
        flags.set(key, n);
        try { success = this.api().syncActorSkills(a, "black_beast_stage").Success; } catch (e) {}
        if (!success) { if (had) flags.set(key, old); else flags.remove(key); this.api().syncActorSkills(a, "black_beast_stage_rollback"); return false; }
        a.getSkills().update(); a.setDirty(true); return true;
    }
    function presentation(a, role = null)
    {
        local actual = this.stage(a), views = [];
        foreach (i, entry in this.api().BlackBeastStageViews[role == null ? this.owner(a) : role])
        {
            local v = { Stage = i, Name = entry.Name, Locked = i > actual, UnlockHint = i > actual ? "$bv{black_beast.stage.locked}" : "" };
            if (!v.Locked) { v.Description <- entry.Description; v.DetailMedia <- clone entry.DetailMedia; }
            views.push(v);
        }
        return { Type = "olga_stages", ActualStage = actual, StageViews = views };
    }
    function round() { return ::Time.getRound(); }
    function clock(a) { return this.api().FiveValkyries.clock(a); }
    function normal(a) { return this.api().EightValkyries.normal(a); }
    function paid(e) { return this.api().EightValkyries.paid(e); }
    function state(a)
    {
        if (!this.supported(a)) return null;
        if (!("BVBlackBeastState" in a.m) || a.m.BVBlackBeastState == null)
        {
            local n = this.stage(a);
            a.m.BVBlackBeastState <- { ID = this.owner(a), Round = -1, Counts = {}, Refunds = {}, Cooldowns = {}, Actions = {}, HitActions = {}, LastTurn = -1,
                Stacks = n >= 5 ? 5 : (n >= 3 ? 3 : 2), StackEndRound = this.round() + 1, CounterRefund = 0,
                GuardUntilRound = -1, GuardKind = "", PursuitRound = -1, PursuitAction = null, Countering = false,
                DivineRound = -1, DivineToken = null, SealsCast = 0, PressureAction = null, PressureTargets = {},
                CastFatigue = 0, CastWeaponMin = 0, CastWeaponMax = 0, CastPursuit = false, CastStack10 = false, InCombat = false };
        }
        local s = a.m.BVBlackBeastState;
        if (s.Round != this.round()) { s.Round = this.round(); s.Counts = {}; s.Refunds = {}; s.CounterRefund = 0; }
        return s;
    }
    function weapon(a) { return this.api().EightValkyries.weapon(a); }
    function weaponCategory(w, key)
    {
        if(w==null)return false;
        // MSU/Legends expose stable type flags; display categories are localized.
        local types={sword="Sword",hammer="Hammer",axe="Axe",polearm="Polearm",spear="Spear"};
        if(!(key in types))return false;
        try
        {
            if("isWeaponType" in w && "WeaponType" in ::Const.Items && types[key] in ::Const.Items.WeaponType)
            {
                if(w.isWeaponType(::Const.Items.WeaponType[types[key]]))return true;
                // A known different type must not be overridden by display text.
                if(!w.isWeaponType(0))return false;
            }
        }
        catch(e) {}
        // Vanilla has no type API; translated MSU categories can also yield None.
        local categories=null;
        try{categories=w.getCategories().tolower();}catch(e){return false;}
        local aliases={sword=["sword","剑","劍"],hammer=["hammer","锤","錘"],axe=["axe","斧"],polearm=["polearm","长柄武器","长柄","長柄武器","長柄"],spear=["spear","矛"]};
        // Replace the UTF-8 separator whole, not as individual split() bytes.
        local separator=categories.find("，");
        while(separator!=null)
        {
            categories=categories.slice(0,separator)+","+categories.slice(separator+"，".len());
            separator=categories.find("，");
        }
        foreach(part in split(categories,",/"))if(aliases[key].find(strip(part))!=null)return true;
        return false;
    }
    function shield(a)
    {
        local i = a == null ? null : a.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        return i != null && i.isItemType(::Const.Items.ItemType.Shield) && i.getCondition() > 0 ? i : null;
    }
    function armed(a, role = null)
    {
        if (!this.supported(a)) return false;
        local id = role == null ? this.owner(a) : role, w = this.weapon(a), off = a.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        if (id == "celestine") return true;
        if (w == null || !w.isItemType(::Const.Items.ItemType.MeleeWeapon)) return false;
        local two = w.isItemType(::Const.Items.ItemType.TwoHanded);
        if (id == "chloe" || id == "maia") return !two && this.shield(a) != null;
        if (id == "alicia") return !two && off == null && this.weaponCategory(w,"sword");
        if (off != null || !two) return false;
        if (id == "claudia") return this.weaponCategory(w,"hammer");
        if (id == "luu_luu") return this.weaponCategory(w,"axe");
        if(id=="prim")foreach(allowed in ["weapon.player_banner","weapon.battle_standard","weapon.polehammer","weapon.named_polehammer"])if(w.getID()==allowed)return true;
        return this.weaponCategory(w,"polearm") || this.weaponCategory(w,"spear");
    }
    function enemy(a, b, range = 99) { return this.api().EightValkyries.enemy(a, b, range); }
    function ally(a, b, self = true) { return this.api().EightValkyries.ally(a, b, self); }
    function allies(a, tile, radius, self = true) { return this.api().EightValkyries.allies(a, tile, radius, self); }
    function enemies(a, tile, radius, range = 99) { return this.api().EightValkyries.enemies(a, tile, radius, range, 99); }
    function directWeapon(skill) { return skill != null && this.api().isDirectAttack(skill) && skill.m.IsWeaponSkill && !skill.isRanged(); }
    function refund(a, amount, key = null)
    {
        if (!this.alive(a)) return false;
        if (key != null) { local s = this.state(a); if (s == null || key in s.Refunds) return false; s.Refunds[key] <- true; }
        a.setFatigue(::Math.max(0, a.getFatigue() - amount)); a.setDirty(true); return true;
    }
    function count(a, key) { local s = this.state(a); return s == null || !(key in s.Counts) ? 0 : s.Counts[key]; }
    function useCount(a, key) { local s = this.state(a); s.Counts[key] <- this.count(a, key) + 1; }
    function effect(b, kind, owner = null, turns = 2)
    {
        if (!this.alive(b)) return null;
        if((kind=="stun" || kind=="daze" || kind=="stagger") && this.maiaControlImmune(b))return null;
        local id = "$bvvar{modId}.effects.black_beast_" + kind, e = b.getSkills().getSkillByID(id);
        if (e == null) { e = ::new("$bvvar{privateFolder}/skills/effects/black_beast_effect"); e.configure(kind); b.getSkills().add(e); }
        e.m.OwnerRef = this.api().makeValkyrieCombatWeakRef(owner);
        local incoming=this.stage(owner);
        e.m.Stage = kind=="seal" || kind=="shatter" || kind=="blessing" ? ::Math.max(e.m.Stage,incoming) : incoming;
        e.m.EndAt = this.clock(b).Ends + turns;
        e.m.CastRound = this.round();
        b.getSkills().update(); b.setDirty(true); return e;
    }
    function getEffect(b, kind) { return b == null ? null : b.getSkills().getSkillByID("$bvvar{modId}.effects.black_beast_" + kind); }
    function seal(a, b)
    {
        if (!this.enemy(a, b)) return false;
        local existing=this.getEffect(b,"seal"),ownerID=a.getID(),oldStage=existing==null?-1:existing.m.Stage;
        local fresh=existing==null || !(ownerID in existing.m.SealOwners);
        local e = this.effect(b, "seal", a);
        if (e == null) return false;
        e.m.SealOwners[ownerID]<-true;e.m.Stage=::Math.max(oldStage,e.m.Stage);
        b.setActionPoints(::Math.max(0, ::Math.min(b.getActionPoints(), b.getCurrentProperties().ActionPoints)));
        if (fresh && this.stage(a) >= 1) this.refund(a, 10, "new_seal");
        return true;
    }
    function root(b)
    {
        if (!this.alive(b)) return false;
        local skills = b.getSkills();
        if (!skills.hasSkill("effects.web")) skills.add(::new("scripts/skills/effects/web_effect"));
        if (!skills.hasSkill("actives.break_free")) { local e = ::new("scripts/skills/actives/break_free_skill"); e.setDecal("web_destroyed"); skills.add(e); }
        foreach (x in [{Sprite="status_rooted",Brush="bust_web2"},{Sprite="status_rooted_back",Brush="bust_web2_back"}])
            if (b.hasSprite(x.Sprite)) { local p=b.getSprite(x.Sprite); p.setBrush(x.Brush); p.Visible=true; }
        skills.update(); b.setDirty(true); return true;
    }
    function control(b, kind, owner = null)
    {
        if (!this.alive(b) || this.maiaControlImmune(b)) return;
        this.effect(b, kind, owner, 1);
        if (kind == "stun") b.setActionPoints(0);
    }
    function addStacks(a, n)
    {
        local s = this.state(a); if (s == null || !this.armed(a)) return;
        s.Stacks = ::Math.min(this.stage(a) >= 5 ? 10 : (this.stage(a) >= 3 ? 8 : 5), s.Stacks + n);
        s.StackEndRound = this.round() + 1; a.getSkills().update(); a.setDirty(true);
    }
    function guard(a) { local s = this.state(a); return s != null && (s.ID == "chloe" && this.stage(a) >= 5 || s.GuardKind != ""); }
    function maiaProtection(a)
    {
        local n = this.stage(a);
        return { Radius = n >= 3 ? 2 : 1, Defense = n >= 5 ? 20 : (n >= 3 ? 15 : 10),
            Reduction = n >= 5 ? 50 : (n >= 3 ? 35 : 25), WallReduction = n >= 5 ? 65 : 50,
            SelfReduction = n >= 5 ? 50 : (n >= 3 ? 35 : 20), Immune = n >= 5 };
    }
    function auraSummary(a, role)
    {
        local result = { Active = false, Defense = 0, Reduction = 0, Wall = false, Immune = false,
            Resolve = 0, Initiative = 0, Fatigue = 0, Damage = 0 };
        foreach (b in this.auraOwners(a, role))
        {
            result.Active = true;
            local n = this.stage(b);
            if (role == "maia")
            {
                local v = this.maiaProtection(b), wall = this.guard(b), reduction = wall ? v.WallReduction : v.Reduction;
                result.Defense = ::Math.max(result.Defense, v.Defense);
                result.Immune = result.Immune || v.Immune;
                if (reduction > result.Reduction) { result.Reduction = reduction; result.Wall = wall; }
                else if (reduction == result.Reduction) result.Wall = result.Wall || wall;
            }
            else
            {
                result.Defense = ::Math.max(result.Defense, n >= 5 ? 20 : (n >= 3 ? 15 : 10));
                result.Resolve = ::Math.max(result.Resolve, n >= 5 ? 35 : (n >= 3 ? 25 : 20));
                result.Initiative = ::Math.max(result.Initiative, n >= 5 ? 30 : (n >= 3 ? 25 : 15));
                result.Fatigue = ::Math.max(result.Fatigue, n >= 5 ? 10 : (n >= 3 ? 8 : (n >= 1 ? 5 : 0)));
                if (n >= 5 && a.getMoraleState() >= ::Const.MoraleState.Wavering) result.Damage = 15;
            }
        }
        return result;
    }
    function wallDescription(a)
    {
        local v = this.maiaProtection(a);
        return ::format("$bv{black_beast.feedback.wall}", v.Radius, v.WallReduction, v.Reduction) + ::format("$bv{black_beast.feedback.maia_self}", v.SelfReduction);
    }
    // Indicators describe existing combat state only. They never apply bonuses.
    function syncFeedback(a)
    {
        if (a == null || ("BVBlackBeastFeedbackUpdating" in a.m && a.m.BVBlackBeastFeedbackUpdating)) return;
        a.m.BVBlackBeastFeedbackUpdating <- true;
        try
        {
            local wanted = {}, live = this.alive(a) && !("BVBlackBeastFeedbackFinished" in a.m && a.m.BVBlackBeastFeedbackFinished);
            if (live)
            {
                local s = this.state(a);
                if (s != null)
                {
                    if (s.ID == "maia" && this.shield(a) != null && this.guard(a)) wanted.maia_wall <- true;
                    if (s.ID == "chloe" && this.guard(a)) wanted.chloe_guard <- true;
                    if (s.ID == "chloe" && this.armed(a) && s.PursuitRound == this.round()) wanted.chloe_pursuit <- true;
                    if (s.ID == "alicia")
                    {
                        if (this.guard(a)) wanted.alicia_counter <- true;
                        if (s.Stacks > 0 && this.armed(a)) wanted.alicia_stacks <- true;
                    }
                    if (s.ID == "celestine") wanted.celestine_divine <- true;
                }
                foreach (role in ["maia", "prim"]) if (this.auraOwners(a, role).len() > 0) wanted[role + "_aura"] <- true;
            }
            local changed = false;
            foreach (e in clone a.getSkills().m.Skills)
                if (e != null && "BVBlackBeastFeedback" in e.m && e.m.BVBlackBeastFeedback && !e.isGarbage() && !(e.m.Kind in wanted))
                { e.removeSelf(); changed = true; }
            foreach (kind, unused in wanted)
                if (this.getEffect(a, kind) == null)
                {
                    local e = ::new("$bvvar{privateFolder}/skills/effects/black_beast_effect");
                    e.configure(kind);
                    if (kind == "chloe_guard" && this.stage(a) >= 3) e.m.Icon = "skills/$bvvar{iconPrefix}/chloe_fortress.png";
                    a.getSkills().add(e); changed = true;
                }
            if (changed) a.setDirty(true);
        }
        catch (e) { a.m.BVBlackBeastFeedbackUpdating = false; throw e; }
        a.m.BVBlackBeastFeedbackUpdating = false;
    }
    function startCombat(a)
    {
        if (!this.supported(a)) return;
        a.m.BVBlackBeastFeedbackFinished <- false;
        a.m.BVBlackBeastState <- null; local s = this.state(a); s.InCombat = true;
        this.syncFeedback(a);
    }
    function finishCombat(a)
    {
        if (a != null) { a.m.BVBlackBeastFeedbackFinished <- true; this.clearEffects(a); a.m.BVBlackBeastState <- null; this.refreshAuraIfChanged(a); }
    }
    function clearEffects(a)
    {
        if (a == null) return;
        foreach (e in clone a.getSkills().m.Skills) if (e != null && "BVBlackBeastEffect" in e.m && !e.isGarbage()) e.removeSelf();
    }
    function normalStart(a)
    {
        if (!this.normal(a)) return;
        // Round-based stances do not expire during waits/resumes or granted extra turns.
        local s = this.state(a);
        if (s != null && s.LastTurn != this.round())
        {
            s.LastTurn = this.round();
            if (s.GuardUntilRound < this.round()) s.GuardKind = "";
            if (s.ID == "chloe" && this.armed(a)) this.refund(a, this.stage(a) >= 4 ? 20 : 10);
            if (s.ID == "maia" && this.shield(a) != null && this.stage(a) >= 1) this.refund(a, this.stage(a) >= 5 ? 25 : 15);
        }
        foreach (e in clone a.getSkills().m.Skills)
            if (e != null && "BVBlackBeastEffect" in e.m && e.m.Kind == "protect" && this.round() > e.m.CastRound && !e.isGarbage()) e.removeSelf();
        local stun = this.getEffect(a, "stun"); if (stun != null) a.setActionPoints(0);
        this.auraFatigue(a);
        if (this.alive(a)) { a.getSkills().update(); a.setDirty(true); }
    }
    function normalEnd(a)
    {
        foreach (e in clone a.getSkills().m.Skills)
            if (e != null && "BVBlackBeastEffect" in e.m && !e.isGarbage() && !e.permanent() && e.m.Kind != "protect" && this.clock(a).Ends >= e.m.EndAt) e.removeSelf();
        local s = this.state(a);
        if (s != null && s.ID == "alicia" && this.stage(a) < 5 && this.round() > s.StackEndRound) s.Stacks = 0;
        if (this.alive(a)) { a.getSkills().update(); a.setDirty(true); }
    }
    function auraOwners(a, id)
    {
        local out = []; if (!this.alive(a) || ::World.getPlayerRoster() == null) return out;
        foreach (b in ::World.getPlayerRoster().getAll())
        {
            if (b == a || !this.alive(b) || this.owner(b) != id || !this.supported(b) || !this.ally(b, a, false)) continue;
            if (id == "maia" ? this.shield(b) == null : !this.armed(b)) continue;
            if ("BVBlackBeastFeedbackFinished" in b.m && b.m.BVBlackBeastFeedbackFinished) continue;
            local n = this.stage(b), radius = id == "prim" ? (n >= 5 ? 8 : (n >= 3 ? 6 : 5)) : (n >= 3 ? 2 : 1);
            if (b.getTile().getDistanceTo(a.getTile()) <= radius) out.push(b);
        }
        return out;
    }
    function refreshAuraIfChanged(a)
    {
        if(a==null || this.AuraRefreshing)return;
        local id=this.owner(a);if(id!="prim" && id!="maia")return;
        // World-map recruitment and post-battle updates have no tactical manager.
        // Do not cache a signature until recipients can actually be refreshed.
        if(!("Tactical" in ::getroottable()) || ::Tactical==null || !("Entities" in ::Tactical) || ::Tactical.Entities==null)return;
        local active=this.supported(a) && this.alive(a) && (id=="maia"?this.shield(a)!=null:this.armed(a));
        if("BVBlackBeastFeedbackFinished" in a.m && a.m.BVBlackBeastFeedbackFinished)active=false;
        local signature=active?id+":"+this.stage(a)+":"+a.getTile().ID+":"+this.guard(a)+":"+a.getFaction():"off";
        if("BVBlackBeastAuraSignature" in a.m && a.m.BVBlackBeastAuraSignature==signature)return;
        a.m.BVBlackBeastAuraSignature<-signature;
        if(!( "World" in ::getroottable()) || ::World==null || ::World.getPlayerRoster()==null)return;
        this.AuraRefreshing=true;
        try{foreach(b in ::Tactical.Entities.getAllInstancesAsArray())if(b!=a && this.alive(b)){b.getSkills().update();b.setDirty(true);}}
        catch(e){this.AuraRefreshing=false;throw e;}
        this.AuraRefreshing=false;
    }
    function auraProperties(a, p)
    {
        local prim = this.auraSummary(a, "prim"), maia = this.auraSummary(a, "maia");
        if (prim.Active)
        {
            local bonus = prim.Defense;
            p.MeleeSkill += bonus; p.RangedSkill += bonus; p.MeleeDefense += bonus; p.RangedDefense += bonus;
            p.Bravery += prim.Resolve; p.Initiative += prim.Initiative;
        }
        if (maia.Active) { p.MeleeDefense += maia.Defense; p.RangedDefense += maia.Defense; if(maia.Immune)p.IsImmuneToKnockBackAndGrab=true; }
    }
    function auraDamage(a, skill, p)
    {
        if (skill == null || !this.api().isDirectAttack(skill)) return;
        local mult = 1.0;
        if(this.supported(a) && this.owner(a)=="maia" && this.shield(a)!=null)
        {
            mult = 1.0 - this.maiaProtection(a).SelfReduction / 100.0;
        }
        mult = ::Math.minf(mult, 1.0 - this.auraSummary(a, "maia").Reduction / 100.0);
        p.DamageReceivedTotalMult *= mult;
    }
    function auraFatigue(a)
    {
        if (!this.alive(a)) return;
        local best = 0;
        foreach (b in this.auraOwners(a, "prim")) { local n = this.stage(b); if (n >= 1) best = ::Math.max(best, n >= 5 ? 10 : (n >= 3 ? 8 : 5)); }
        if (best > 0 && (!("BVPrimAuraRound" in a.m) || a.m.BVPrimAuraRound != this.round())) { a.m.BVPrimAuraRound <- this.round(); this.refund(a, best); }
    }
    function shatter(a, b) { if (this.enemy(a, b)) this.effect(b, "shatter", a); }
    function maiaControlImmune(a) { return this.supported(a) && this.owner(a)=="maia" && this.stage(a)>=3 && this.shield(a)!=null; }
    function improveMorale(a, steps)
    {
        if(!this.alive(a))return false;
        local current=a.getMoraleState(),cap=::Const.MoraleState.Confident;
        if("MaxMoraleState" in a.m)cap=::Math.min(cap,a.m.MaxMoraleState);
        if(current>=cap || current< ::Const.MoraleState.Fleeing)return false;
        a.setMoraleState(::Math.min(cap,current+steps));a.setDirty(true);return true;
    }
    function ensureInnateSkills(a)
    {
        if(!this.supported(a) || this.owner(a)!="chloe")return;
        local skills=a.getSkills();
        foreach(key in ["shield_expert","steel_brow","underdog","pathfinder","recover","footwork"])
            if(!skills.hasSkill("perk."+key))skills.add(::new("scripts/skills/perks/perk_"+key));
    }
    function healRepair(b, hp, armor, cleanse = false)
    {
        if (!this.alive(b)) return false;
        local changed = this.api().EightValkyries.heal(b, hp);
        foreach (slot in [::Const.ItemSlot.Head, ::Const.ItemSlot.Body])
        {
            local i = b.getItems().getItemAtSlot(slot); if (i == null || !("ConditionMax" in i.m)) continue;
            local old = i.getCondition(); i.setCondition(::Math.min(i.getConditionMax(), old + armor)); changed = changed || i.getCondition() > old;
        }
        if (cleanse) foreach (id in ["effects.bleeding", "effects.goblin_poison", "effects.spider_poison", "effects.poison"]) b.getSkills().removeByID(id);
        b.getSkills().update(); b.setDirty(true); return changed;
    }
    function sealAvailable(b)
    {
        return this.alive(b) && b.isPlayerControlled() && !("BVBlackBeastRevived" in b.m && b.m.BVBlackBeastRevived) && this.getEffect(b, "resurrection") == null;
    }
    function hasSurvival(b) { return this.alive(b) && b.isPlayerControlled() && this.getEffect(b, "resurrection") != null && !("BVBlackBeastRevived" in b.m && b.m.BVBlackBeastRevived); }
    function claimSurvival(b, hp, frame)
    {
        // Absorption bridges may temporarily raise current HP before the
        // engine subtracts its original local damage. Compare adjusted damage
        // with the HP captured before that bridge, avoiding double absorption.
        local before = "BeforeHP" in frame ? frame.BeforeHP : b.getHitpoints();
        if (frame.Triggered || !frame.CouldDie || hp <= 0 || hp < before || !this.alive(b) || !this.hasSurvival(b)) return false;
        local e = this.getEffect(b, "resurrection"), owner = this.api().readValkyrieCombatWeakRef(e.m.OwnerRef);
        if (!this.alive(owner) || !this.supported(owner) || this.owner(owner) != "celestine" || this.stage(owner) < 5) return false;
        b.m.BVBlackBeastRevived <- true; e.removeSelf(); frame.Triggered = true; frame.Kind = "celestine_resurrection";
        frame.RestoreHP = ::Math.max(1, ::Math.floor(b.getHitpointsMax() * 0.5)); frame.OwnerRef = this.api().makeValkyrieCombatWeakRef(owner);
        b.setIsAbleToDie(false); return true;
    }
};

// Normalize flat attack bonuses after the shared weapon policy.
::$bvvar{namespace}.finalizeBlackBeastProperties <- function(a, skill, b, p)
{
    local f=this.BlackBeast;
    if(b!=null)
    {
        local shatter=f.getEffect(b,"shatter");
        if(shatter!=null && shatter.m.Stage>=3 && this.isDirectAttack(skill))p.DamageDirectAdd+=0.25;
    }
    if(a==null || skill==null || !this.isDirectAttack(skill))return p;
    local s=f.state(a),bonus=0;
    if("BVBlackBeastActive" in skill.m && skill.m.BVBlackBeastActive && skill.m.HitSpec!=null)bonus+=skill.m.HitSpec.Bonus;
    if(s!=null && s.ID=="luu_luu" && f.armed(a) && f.directWeapon(skill) && skill.getID()!="actives.split_shield")
    {
        local c=this.getCurrentValkyrieActionContext(a,skill),excluded="BVBlackBeastActive" in skill.m && (skill.m.Spec.Mode=="vent" || skill.m.Spec.Mode=="furnace");
        if(f.paid(c) && b!=null && !excluded)
        {
            if(s.PressureAction!=c.ActionToken){s.PressureAction=c.ActionToken;s.PressureTargets={};s.CastFatigue=a.getFatigue();}
            if(!(b.getID() in s.PressureTargets))bonus+=::Math.floor(s.CastFatigue*(f.stage(a)>=3?0.5:0.25));
        }
    }
    if(bonus>0 && p.DamageRegularMult>0){p.DamageRegularMin+=bonus/p.DamageRegularMult;p.DamageRegularMax+=bonus/p.DamageRegularMult;}
    foreach(owner in f.auraOwners(a,"prim"))
        if(f.stage(owner)>=5 && a.getMoraleState()>=::Const.MoraleState.Wavering){p.DamageTotalMult*=1.15;break;}
    return p;
};
