// Per-actor progression and objectives. No progress is inferred from visual skins.
::$bvvar{namespace}.BlackBeastCorruption <- {
    function api() { return ::$bvvar{namespace}; }
    function actors()
    {
        local out = [];
        if (!("World" in ::getroottable()) || ::World == null || ::World.getPlayerRoster() == null) return out;
        foreach (a in ::World.getPlayerRoster().getAll())
            if (this.api().BlackBeast.supported(a) && !this.api().isActorDeadOrDying(a)) out.push(a);
        return out;
    }
    function ensureTrait(a)
    {
        if (!this.api().BlackBeast.supported(a)) return null;
        local role = this.api().getActorValkyrieID(a), id = "$bvvar{modId}.trait." + role + "_corruption";
        local trait = a.getSkills().getSkillByID(id);
        if (trait == null)
        {
            trait = ::new("scripts/skills/traits/battle_valkyries/" + role + "_corruption_trait");
            a.getSkills().add(trait); trait.migrateLegacyStage(this.api().BlackBeast.stage(a));
        }
        return trait;
    }
    function ownerTrait(owner)
    {
        foreach (a in this.actors()) if (a.getID() == owner) return this.ensureTrait(a);
        return null;
    }
    function role(trait) { return this.api().getActorValkyrieID(trait.getContainer().getActor()); }
    function stage(role, value)
    {
        if (!(role in this.api().BlackBeastCorruptionStages)) return null;
        foreach (e in this.api().BlackBeastCorruptionStages[role]) if (e.Value == value) return e;
        return null;
    }
    function addFromBondItem(a, amount)
    {
        if (a == null || this.api().isActorDeadOrDying(a)) return 0;
        local trait = this.ensureTrait(a); if (trait == null) return 0;
        local added = trait.addCorruption(amount); if (added > 0) a.setDirty(true); return added;
    }
    function combatID() { return this.api().OlgaCorruption.combatID(); }
    function startCombat(a)
    {
        if (a == null || this.api().isActorDeadOrDying(a) || !a.isPlacedOnMap() || this.ensureTrait(a) == null) return;
        a.getFlags().set("BVBlackBeastCorruptionCombatID", this.combatID() + 1);
        a.getFlags().set("BVBlackBeastCorruptionInCombat", true);
    }
    function wasVictorious(a)
    {
        return a != null && !this.api().isActorDeadOrDying(a)
            && a.getFlags().get("BVBlackBeastCorruptionCombatID") == this.combatID()
            && a.getFlags().get("BVBlackBeastCorruptionInCombat") == true
            && ::World.Statistics.getFlags().get("LastCombatResult") == 1;
    }
    function awardCombatCorruption(id)
    {
        foreach (a in this.actors())
        {
            local flags = a.getFlags();
            if (flags.get("BVBlackBeastCorruptionInCombat") != true || flags.get("BVBlackBeastCorruptionCombatID") != id
                || flags.get("BVBlackBeastCorruptionLastAwardedCombatID") == id
                || ::World.Statistics.getFlags().get("LastCombatResult") != 1) continue;
            this.ensureTrait(a).addCorruption(4); flags.set("BVBlackBeastCorruptionLastAwardedCombatID", id);
        }
    }
    function finishCombat()
    {
        this.awardCombatCorruption(this.combatID());
        foreach (a in this.actors())
        {
            a.getFlags().set("BVBlackBeastCorruptionInCombat", false);
            this.deliverRewards(this.ensureTrait(a));
        }
    }
    function deliverRewards(trait)
    {
        if (trait == null) return;
        local a = trait.getContainer().getActor();
        if (!this.api().BlackBeast.supported(a) || this.api().isActorDeadOrDying(a)) return;
        foreach (value in trait.m.TriggeredStages)
        {
            if (trait.hasClaimedStage(value)) continue;
            try
            {
                local n = value / 20;
                if (this.api().BlackBeast.stage(a) < n && !this.api().BlackBeast.grantStage(a, n)) return;
                if (!this.api().syncActorSkills(a, "black_beast_corruption_reward").Success) return;
                trait.addStage(trait.m.ClaimedStages, value); trait.addStage(trait.m.NoticeStages, value);
                trait.queueReachedStages();
            }
            catch (e) { ::logWarning("[Battle Valkyries] Black Beast reward deferred: " + a.getID() + " " + value + " " + e); return; }
        }
    }
    function rewardNotice(trait, value)
    {
        return trait.hasClaimedStage(value) ? "$bv{event.black_beast_corruption.claimed}" : "$bv{event.black_beast_corruption.pending}";
    }
    function locations(owner = null, value = null)
    {
        local out = [];
        foreach (l in ::World.EntityManager.getLocations())
            if (l != null && l.isAlive() && l.getFlags().get("BVBlackBeastCorruptionCamp") == true
                && (owner == null || l.getFlags().get("BVBlackBeastCorruptionOwner") == owner)
                && (value == null || l.getCorruptionStage() == value)) out.push(l);
        return out;
    }
    function reveal(l) { this.api().OlgaCorruption.reveal(l); }
    function spawn(trait, value)
    {
        if (trait == null || !trait.m.PrologueSeen || this.stage(this.role(trait), value) == null || trait.hasTriggeredStage(value)) return false;
        local a = trait.getContainer().getActor(), recovery = trait.hasChallengeSpawnedStage(value);
        if (!this.api().BlackBeast.supported(a) || this.api().isActorDeadOrDying(a) || (!recovery && trait.getNextPendingStage() != value)) return false;
        local existing = this.locations(a.getID(), value);
        if (existing.len() > 0)
        {
            if (!recovery && !trait.startChallengeStage(value)) return false;
            this.reveal(existing[0]); for (local i = 1; i < existing.len(); ++i) existing[i].die(); return true;
        }
        local tile = this.api().getHimekoBondChallengeSpawnTile(); if (tile == null) return false;
        local l = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/black_beast_corruption_camp_location", tile.Coords);
        if (l == null) return false;
        try { l.configure(this.role(trait), value, a.getID()); l.onSpawned(); }
        catch (e) { l.die(); ::logWarning("[Battle Valkyries] Black Beast camp creation failed: " + e); return false; }
        if (!recovery && !trait.startChallengeStage(value)) { l.die(); return false; }
        return true;
    }
    function maintain()
    {
        foreach (l in this.locations())
        {
            local trait = this.ownerTrait(l.getFlags().get("BVBlackBeastCorruptionOwner"));
            if (trait == null || this.role(trait) != l.getRoleID() || !trait.hasChallengeSpawnedStage(l.getCorruptionStage())) l.die();
        }
        foreach (a in this.actors())
        {
            local trait = this.ensureTrait(a); this.deliverRewards(trait);
            foreach (value in clone trait.m.ChallengeSpawnedStages) this.spawn(trait, value);
        }
    }
    function findTrait()
    {
        // Deliver every actor's rewards before selecting the next story. Roster order is stable.
        foreach (a in this.actors()) { local t = this.ensureTrait(a); if (t.getNoticeStage() > 0) return t; }
        foreach (a in this.actors()) { local t = this.ensureTrait(a); if (!t.m.PrologueSeen || t.hasPendingStage()) return t; }
        return null;
    }
    function completeCamp(l)
    {
        local trait = this.ownerTrait(l.getFlags().get("BVBlackBeastCorruptionOwner"));
        if (trait == null || this.role(trait) != l.getRoleID() || !this.wasVictorious(trait.getContainer().getActor())
            || l.getFlags().get("BVBlackBeastCorruptionCombatID") != this.combatID()) return false;
        return trait.completeChallengeStage(l.getCorruptionStage());
    }
};
