::$bvvar{namespace}.HertaBondTraitID <- "$bvvar{modId}.trait.the_herta_bond";
::$bvvar{namespace}.HertaBond <- {
	function ensureTrait(actor)
	{
		if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "the_herta") return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.HertaBondTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/the_herta_bond_trait"); skills.add(trait);
		}
		return trait;
	},
	function findTrait()
	{
		if (!("World" in getroottable()) || ::World == null || !("getPlayerRoster" in ::World) || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (::$bvvar{namespace}.getActorValkyrieID(actor) == "the_herta" && !::$bvvar{namespace}.isActorDeadOrDying(actor)) return this.ensureTrait(actor);
		return null;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.HertaBondStages) if (entry.Value == value) return entry;
		return null;
	},
	function combatID()
	{
		local id = ::World.Statistics.getFlags().get("LastCombatID");
		return typeof id == "integer" ? id : 0;
	},
	function startCombat(actor)
	{
		if (this.ensureTrait(actor) == null) return;
		local flags = actor.getFlags();
		flags.set("BVHertaBondCombatID", this.combatID() + 1);
		flags.set("BVHertaBondInCombat", true);
		::$bvvar{namespace}.HertaCombat.start(actor);
	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVHertaBondCombatID") == this.combatID()
			&& actor.getFlags().get("BVHertaBondInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatBond(this.combatID());
			actor.getFlags().set("BVHertaBondInCombat", false);
            ::$bvvar{namespace}.HertaCombat.finish(actor);
			this.deliverRewards(trait);
		}
	},
	function awardCombatBond(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVHertaBondInCombat") != true || flags.get("BVHertaBondCombatID") != combatID
			|| flags.get("BVHertaBondLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addBond(4);
		flags.set("BVHertaBondLastAwardedCombatID", combatID);
	},
	function deliverRewards(trait)
	{
        if(trait==null)return;
        local actor=trait.getContainer().getActor();
        // Preserve old equipment receipts BEFORE updating generic stage receipts.
        // Backfill is also called after world load/show, never during actor load.
        ::$bvvar{namespace}.HertaEquipment.backfill();
        if(trait.m.TriggeredStages.len()==0)return;
        local result=::$bvvar{namespace}.syncActorSkills(actor,"the-herta-bond-reward");
        if(!result.Success)return;
        foreach(value in trait.m.TriggeredStages)
        {
            local entry=this.stage(value);if(entry==null)continue;
            local flags=actor.getFlags(),flag="BVHertaBondPerkGranted"+value,changed=false;
            if(flags.get(flag)!=true)
            {
                actor.setPerkPoints(actor.getPerkPoints()+entry.PerkPoints);
                flags.set(flag,true);changed=true;
            }
            // Wedding keepsake has no combat stats. A full stash must never
            // prevent perk points or ability entitlement from taking effect.
            if(value==100&&!trait.m.RingClaimed)
            {
                if(!("World" in getroottable())||::World==null||::World.Assets==null)continue;
                local stash=::World.Assets.getStash();
                if(!stash.isResizable()&&stash.getNumberOfEmptySlots()<=0)continue;
                if(stash.add(::new("scripts/items/misc/battle_valkyries/the_herta_ring_of_exception"))==null)continue;
                trait.m.RingClaimed=true;changed=true;
            }
            if(!trait.hasClaimedStage(value)||changed)
            {
                trait.addStage(trait.m.ClaimedStages,value);
                trait.addStage(trait.m.NoticeStages,value);
            }
        }
	},
	function rewardNotice(trait,value)
	{
        if(trait.hasClaimedStage(value)&&trait.getContainer().getActor().getFlags().get("BVHertaBondPerkGranted"+value)==true)
            return "$bv{event.the_herta_bond.claimed}";
        if(value==100&&!trait.m.RingClaimed&&::World!=null&&::World.Assets!=null)
        {
            local stash=::World.Assets.getStash();
            if(!stash.isResizable()&&stash.getNumberOfEmptySlots()<=0)return "$bv{event.the_herta_bond.pending_space}";
        }
        return "$bv{event.the_herta_bond.pending}";
	},
	function locations(value)
	{
		local result = [];
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.the_herta_bond_" + value) result.push(location);
		return result;
	},
	function reveal(location)
	{
		location.setVisibleInFogOfWar(true); location.setDiscovered(true);
		if (location.hasSprite("selection")) location.getSprite("selection").Visible = true;
		::World.uncoverFogOfWar(location.getTile().Pos, 500.0);
	},
	function spawn(value)
	{
		local trait = this.findTrait();
		if (trait == null || this.stage(value) == null || trait.hasTriggeredStage(value)) return false;
		local recovery = trait.hasChallengeSpawnedStage(value);
		if (!recovery && trait.getNextPendingStage() != value) return false;
		local existing = this.locations(value);
		if (existing.len() > 0)
		{
			if (!recovery && !trait.startChallengeStage(value)) return false;
			this.reveal(existing[0]);
			for (local i = 1; i < existing.len(); ++i) existing[i].die();
			return true;
		}
		// Reuse the established nearby land search and faction adapters.
		local tile = ::$bvvar{namespace}.getHimekoBondChallengeSpawnTile();
		if (tile == null) return false;
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/the_herta_bond_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Herta bond camp creation failed: " + e); return false; }
		if (!recovery && !trait.startChallengeStage(value)) { location.die(); return false; }
		return true;
	},
	function maintain()
	{
		local trait = this.findTrait();
		if (trait == null) return null;
		this.deliverRewards(trait);
		foreach (value in trait.m.ChallengeSpawnedStages) if (this.locations(value).len() == 0) this.spawn(value);
		return trait;
	},
	function completeCamp(location)
	{
		local trait = this.findTrait(), value = location.getBondStage();
		if (trait == null || !this.wasVictorious(trait.getContainer().getActor())
			|| location.getFlags().get("BVHertaBondCombatID") != this.combatID()) return false;
		return trait.completeChallengeStage(value);
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null || (!trait.hasPendingStage() && trait.getNoticeStage() == 0)) return false;
		return ::World.Events.updateSpecialEvents();
	}
};

::$bvvar{namespace}.hasHertaBondUpgrade <- function(actor, stage)
{
 if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "the_herta") return false;
 local trait = actor.getSkills().getSkillByID(::$bvvar{namespace}.HertaBondTraitID);
 return trait != null && trait.hasTriggeredStage(stage);
};
::$bvvar{namespace}.HertaBond.skinUnlocked <- function(actor)
{
 if (actor == null) { local trait = this.findTrait(); actor = trait == null ? null : trait.getContainer().getActor(); }
 return ::$bvvar{namespace}.hasHertaBondUpgrade(actor,100);
};
