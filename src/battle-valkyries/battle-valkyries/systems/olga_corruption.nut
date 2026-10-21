::$bvvar{namespace}.OlgaCorruptionTraitID <- "$bvvar{modId}.trait.olga_corruption";
::$bvvar{namespace}.OlgaCorruption <- {
	function ensureTrait(actor)
	{
		if (actor == null || !::$bvvar{namespace}.Olga.supported(actor)) return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.OlgaCorruptionTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/olga_corruption_trait"); skills.add(trait);
			trait.migrateLegacyStage(::$bvvar{namespace}.Olga.stage(actor));
		}
		return trait;
	},
	function findTrait()
	{
		if (::World == null || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (!::$bvvar{namespace}.isActorDeadOrDying(actor) && ::$bvvar{namespace}.Olga.supported(actor)) return this.ensureTrait(actor);
		return null;
	},
	function addFromBondItem(actor, amount)
	{
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !::$bvvar{namespace}.Olga.supported(actor)) return 0;
		local trait = this.ensureTrait(actor);
		if (trait == null) return 0;
		local added = trait.addCorruption(amount);
		if (added > 0) { try { actor.setDirty(true); } catch (e) {} }
		// addCorruption queues the next story. The native scheduler waits until inventory closes.
		return added;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.OlgaCorruptionStages) if (entry.Value == value) return entry;
		return null;
	},
	function combatID()
	{
		local id = ::World.Statistics.getFlags().get("LastCombatID");
		return typeof id == "integer" ? id : 0;
	},
	function startCombat(actor)
	{
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.isPlacedOnMap() || this.ensureTrait(actor) == null) return;
		local flags = actor.getFlags();
		flags.set("BVOlgaCorruptionCombatID", this.combatID() + 1);
		flags.set("BVOlgaCorruptionInCombat", true);
	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVOlgaCorruptionCombatID") == this.combatID()
			&& actor.getFlags().get("BVOlgaCorruptionInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatCorruption(this.combatID());
			actor.getFlags().set("BVOlgaCorruptionInCombat", false);
			this.deliverRewards(trait);
		}
	},
	function awardCombatCorruption(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVOlgaCorruptionInCombat") != true || flags.get("BVOlgaCorruptionCombatID") != combatID
			|| flags.get("BVOlgaCorruptionLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addCorruption(4);
		flags.set("BVOlgaCorruptionLastAwardedCombatID", combatID);
	},
	function deliverRewards(trait)
	{
		if (trait == null) return;
		local actor = trait.getContainer().getActor();
		if (!::$bvvar{namespace}.Olga.supported(actor) || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return;
		foreach (value in trait.m.TriggeredStages)
		{
			if (trait.hasClaimedStage(value)) continue;
			try
			{
				local n = value / 20;
				if (::$bvvar{namespace}.Olga.stage(actor) < n && !::$bvvar{namespace}.Olga.grantStage(actor, n)) return;
				local result = ::$bvvar{namespace}.syncActorSkills(actor, "olga-corruption-reward");
				if (!result.Success) return;
				trait.addStage(trait.m.ClaimedStages, value);
				trait.addStage(trait.m.NoticeStages, value);
				trait.queueReachedStages();
			}
			catch (e) { ::logWarning("[Battle Valkyries] Olga corruption reward deferred: " + value + " " + e); return; }
		}
	},
	function rewardNotice(trait, value)
	{
		return trait.hasClaimedStage(value) ? "$bv{event.olga_corruption.claimed}" : "$bv{event.olga_corruption.pending}";
	},
	function locations(value)
	{
		local result = [];
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.olga_corruption_" + value) result.push(location);
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
		if (trait == null || !trait.m.PrologueSeen || this.stage(value) == null || trait.hasTriggeredStage(value)) return false;
		local recovery = trait.hasChallengeSpawnedStage(value);
		if (!recovery && trait.getNextPendingStage() != value) return false;
		local existing = [];
		foreach (location in this.locations(value))
		{
			if (location.getFlags().get("BVOlgaCorruptionOwner") == trait.getContainer().getActor().getID()) existing.push(location);
			else location.die();
		}
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
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/olga_corruption_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value, trait.getContainer().getActor().getID()); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Olga corruption camp creation failed: " + e); return false; }
		if (!recovery && !trait.startChallengeStage(value)) { location.die(); return false; }
		return true;
	},
	function maintain()
	{
		local trait = this.findTrait();
		// Remove orphaned or completed objectives only on safe world-event maintenance.
		foreach (entry in ::$bvvar{namespace}.OlgaCorruptionStages)
			foreach (location in this.locations(entry.Value))
				if (trait == null || !trait.hasChallengeSpawnedStage(entry.Value) || location.getFlags().get("BVOlgaCorruptionOwner") != trait.getContainer().getActor().getID()) location.die();
		if (trait == null) return null;
		this.deliverRewards(trait);
		foreach (value in trait.m.ChallengeSpawnedStages) if (this.locations(value).len() == 0) this.spawn(value);
		return trait;
	},
	function completeCamp(location)
	{
		local trait = this.findTrait(), value = location.getCorruptionStage();
		if (trait == null || location.getFlags().get("BVOlgaCorruptionOwner") != trait.getContainer().getActor().getID() || !this.wasVictorious(trait.getContainer().getActor())
			|| location.getFlags().get("BVOlgaCorruptionCombatID") != this.combatID()) return false;
		return trait.completeChallengeStage(value);
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null || (trait.m.PrologueSeen && !trait.hasPendingStage() && trait.getNoticeStage() == 0)) return false;
		return ::World.Events.updateSpecialEvents();
	}
};
