::$bvvar{namespace}.YeShunguangBondTraitID <- "$bvvar{modId}.trait.ye_shunguang_bond";
::$bvvar{namespace}.YeShunguangBond <- {
	function ensureTrait(actor)
	{
		if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "ye_shunguang") return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.YeShunguangBondTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/ye_shunguang_bond_trait"); skills.add(trait);
		}
		return trait;
	},
	function findTrait()
	{
		if (::World == null || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (!::$bvvar{namespace}.isActorDeadOrDying(actor) && ::$bvvar{namespace}.getActorValkyrieID(actor) == "ye_shunguang") return this.ensureTrait(actor);
		return null;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.YeShunguangBondStages) if (entry.Value == value) return entry;
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
		flags.set("BVYeBondCombatID", this.combatID() + 1);
		flags.set("BVYeBondInCombat", true);
		flags.set("BVYeHeartRecalledUsed", false);
	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVYeBondCombatID") == this.combatID()
			&& actor.getFlags().get("BVYeBondInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatBond(this.combatID());
			actor.getFlags().set("BVYeBondInCombat", false);
			this.deliverRewards(trait);
		}
	},
	function awardCombatBond(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVYeBondInCombat") != true || flags.get("BVYeBondCombatID") != combatID
			|| flags.get("BVYeBondLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addBond(4);
		flags.set("BVYeBondLastAwardedCombatID", combatID);
	},
	function deliverRewards(trait)
	{
		if (trait == null || ::World == null || ::World.Assets == null) return;
		local assets = ::World.Assets;
		foreach (value in trait.m.TriggeredStages)
		{
			if (trait.hasClaimedStage(value)) continue;
			local entry = this.stage(value);
			if (entry == null) continue;
			try
			{
				if (entry.Item != null)
				{
					local stash = assets.getStash();
					if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) continue;
					if (stash.add(::new(entry.Item)) == null) continue;
				}
				else if (value == 100)
				{
					local result = ::$bvvar{namespace}.syncActorSkills(trait.getContainer().getActor(), "ye-bond-reward");
					if (!result.Success) { ::logWarning("[Battle Valkyries] Ye bond skill delivery deferred: " + result.Code); continue; }
				}
				else
				{
					local money = assets.getMoney(), tools = assets.getArmorParts(), medicine = assets.getMedicine();
					try
					{
						assets.setMoney(money + entry.Money); assets.setArmorParts(tools + entry.Tools); assets.setMedicine(medicine + entry.Medicine);
					}
					catch (e) { assets.setMoney(money); assets.setArmorParts(tools); assets.setMedicine(medicine); throw e; }
				}
				trait.addStage(trait.m.ClaimedStages, value);
				trait.addStage(trait.m.NoticeStages, value);
			}
			catch (e) { ::logWarning("[Battle Valkyries] Ye bond reward remains pending: " + value + " " + e); }
		}
	},
	function rewardNotice(trait, value)
	{
		local entry = this.stage(value);
		if (trait.hasClaimedStage(value))
		{
			if (entry != null && entry.Item != null) return "$bv{event.ye_shunguang_bond.claimed_item}";
			if (value == 100) return "$bv{event.ye_shunguang_bond.claimed_skill}";
			return "$bv{event.ye_shunguang_bond.claimed}";
		}
		if (entry != null && entry.Item != null && ::World != null && ::World.Assets != null)
		{
			local stash = ::World.Assets.getStash();
			if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) return "$bv{event.ye_shunguang_bond.pending_space}";
		}
		return "$bv{event.ye_shunguang_bond.pending}";
	},
	function locations(value)
	{
		local result = [];
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.ye_shunguang_bond_" + value) result.push(location);
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
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/ye_shunguang_bond_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Ye bond camp creation failed: " + e); return false; }
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
			|| location.getFlags().get("BVYeBondCombatID") != this.combatID()) return false;
		return trait.completeChallengeStage(value);
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null || (!trait.hasPendingStage() && trait.getNoticeStage() == 0)) return false;
		return ::World.Events.updateSpecialEvents();
	}
};
