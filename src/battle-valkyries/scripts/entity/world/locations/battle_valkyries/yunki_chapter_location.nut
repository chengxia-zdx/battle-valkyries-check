this.yunki_chapter_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function chapter() { return this.getFlags().get("BVChapterID"); },
	function node() { return this.getFlags().get("BVChapterNode"); },
	function getChapterFactionType() { return this.node() == "temple" ? this.Const.FactionType.Bandits : this.Const.FactionType.Undead; },
	function repairChapterFaction()
	{
		local d = this.data();
		if (d == null || !d.Battle || ::World == null || ::World.FactionManager == null) return;
		local manager = ::World.FactionManager, faction = manager.getFactionOfType(this.getChapterFactionType());
		// Factions may not have been restored yet during location deserialization.
		if (faction == null) return;
		local registered = false;
		foreach (other in manager.getFactions())
		{
			if (other == null) continue;
			local matches = 0;
			foreach (loc in other.getSettlements()) if (loc != null && loc.getID() == this.getID()) ++matches;
			if (other.getID() == faction.getID() && matches == 1) { registered = true; continue; }
			// Remove stale memberships and duplicates without destroying the camp.
			for (local i = 0; i < matches; ++i) other.removeSettlement(this);
		}
		if (!registered) faction.addSettlement(this, false);
		if (this.getFaction() != faction.getID()) this.setFaction(faction.getID());
		this.updatePlayerRelation();
	},
	function data()
	{
		local d = ::$bvvar{namespace}.Chapters.definition(this.chapter());
		return d != null && this.node() in d.Nodes ? d.Nodes[this.node()] : null;
	},
	function create()
	{
		this.location.create(); this.m.TypeID = "$bvvar{modId}.location.yunki_chapter";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingBanner = false; this.m.IsSpawningDefenders = false; this.m.IsScalingDefenders = false;
		this.m.IsDespawningDefenders = false; this.m.Resources = 200;
		// Other mods can mutate the shared default's bonus slot via a shallow clone.
		// Ruins accepts only a camp decorator with spawnDetail there, or null.
		this.m.CombatLocation.Template = ["tactical.ruins", null];
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.ForceLineBattle = true; this.m.CombatLocation.AdditionalRadius = 2;
	},
	function configure()
	{
		local d = this.data(); if (d == null) return;
		this.m.Name = d.Name;
		local definition = ::$bvvar{namespace}.Chapters.definition(this.chapter()), names = "";
		foreach (id in definition.Actors)
			names += (names == "" ? "" : "$bv{chapter.location.actor_separator}") + ::$bvvar{namespace}.Valkyries[id].Name;
		this.m.Description = d.Battle ? format("$bv{chapter.location.battle}", definition.Name, names) : "$bv{chapter.location.explore}";
		this.m.IsShowingDefenders = d.Battle;
		if (this.hasSprite("body")) this.getSprite("body").setBrush(d.Brush);
	},
	function onInit() { this.location.onInit(); this.addSprite("body").setBrush("world_bandit_camp_01"); },
	function onSpawned()
	{
		this.configure(); this.location.onSpawned();
		local d = this.data(); if (d != null && d.Battle)
		{
			this.repairChapterFaction(); this.populateDefenders();
		}
		::$bvvar{namespace}.Chapters.reveal(this);
	},
	function populateDefenders()
	{
		if (this.m.Troops.len() > 0) { this.reinforceDefenders(); return; }
		if (this.node() == "temple")
		{
			for (local i = 0; i < 10; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditRaider }, false, 0);
			for (local i = 0; i < 3; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditMarksman }, false, 0);
			this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.BanditLeader }, false, 0);
		}
		else if (this.node() == "stone_gate")
		{
			for (local i = 0; i < 8; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.SkeletonMedium }, false, 0);
			for (local i = 0; i < 3; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.SkeletonHeavy }, false, 0);
			this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.SkeletonPriest }, false, 0);
		}
		else if (this.node() == "soul_array")
		{
			for (local i = 0; i < 3; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.ZombieKnight }, false, 0);
			for (local i = 0; i < 2; ++i) this.Const.World.Common.addTroop(this, { Type = this.Const.World.Spawn.Troops.Vampire }, false, 0);
			this.addPhantoms(4);
		}
		else if (this.node() == "nightmare")
		{
			local boss = clone this.Const.World.Spawn.Troops.Necromancer;
			boss.Script = "scripts/entity/tactical/enemies/battle_valkyries/yunki_nightmare";
			boss.Name <- "$bv{enemy.yunki_nightmare.name}"; boss.Variant = 0;
			this.Const.World.Common.addTroop(this, { Type = boss }, false, 0);
			for (local i = 0; i < 3; ++i)
			{
				local lamp = clone this.Const.World.Spawn.Troops.Necromancer;
				lamp.Script = "scripts/entity/tactical/enemies/battle_valkyries/yunki_nightmare_lamp";
				lamp.Name <- "$bv{enemy.yunki_lamp.name}"; lamp.Variant = 0;
				this.Const.World.Common.addTroop(this, { Type = lamp }, false, 0);
			}
			this.addPhantoms(3);
		}
		this.reinforceDefenders();
		this.updateStrength();
	},
	function reinforceDefenders()
	{
		// One-time reinforcements also upgrade saved camps without replacing survivors.
		// Persist the revision so retreats and reloads never replenish these troops.
		if (this.m.Troops.len() == 0 || this.getFlags().get("BVYunkiDefenderRevision") == 1) return;
		local groups = {
			temple = [["brigands_t4", 3], ["brigands_t5", 1]],
			stone_gate = [["ancients_t4", 3], ["ancients_t5", 1]],
			soul_array = [["zombies_t4", 3], ["zombies_t5", 1], ["ancients_t4", 2]],
			nightmare = [["zombies_t4", 2], ["ancients_t4", 2], ["ancients_t5", 1]]
		};
		if (!(this.node() in groups)) return;
		foreach (entry in groups[this.node()]) this.addExpandedDefenders(entry[0], entry[1]);
		this.getFlags().set("BVYunkiDefenderRevision", 1);
		this.updateStrength();
	},
	function addExpandedDefenders(key, count)
	{
		// Explicit chapter encounters use the catalogue, independent of natural-spawn settings.
		local def = ::$bvvar{namespace}.getExpandedEnemyDefinition(key);
		local troop = clone this.Const.World.Spawn.Troops[def.Troop];
		troop.Script = ::$bvvar{namespace}.getExpandedEnemyScript(key);
		troop.Variant = 0;
		for (local i = 0; i < count; ++i)
		{
			local added = this.Const.World.Common.addTroop(this, { Type = troop }, false, 0);
			// Native addTroop clears Name before returning the world troop.
			added.Name = def.Name;
		}
	},
	function addPhantoms(count)
	{
		local phantom = clone this.Const.World.Spawn.Troops.Necromancer;
		phantom.Script = "scripts/entity/tactical/enemies/battle_valkyries/yunki_nightmare_phantom";
		phantom.Name <- "$bv{enemy.yunki_phantom.name}"; phantom.Variant = 0;
		for (local i = 0; i < count; ++i) this.Const.World.Common.addTroop(this, { Type = phantom }, false, 0);
	},
	function onEnter()
	{
		local d = this.data();
		if (d != null && d.Battle) { this.repairChapterFaction(); return this.location.onEnter(); }
		// Arrival does not advance story. Open the chapter and choose the local investigation.
		try { ::World.State.m.WorldScreen.getTopbarOptionsModule().showBattleValkyrieChapter(this.chapter()); } catch (e) {}
		return false;
	},
	function onBeforeCombatStarted()
	{
		this.populateDefenders();
		::$bvvar{namespace}.Chapters.Battle = { ID = this.chapter(), Node = this.node(), Participants = {} };
		this.location.onBeforeCombatStarted();
	},
	function onCombatLost()
	{
		::$bvvar{namespace}.Chapters.battleWon(this.chapter(), this.node());
		if (this.hasSprite("selection")) this.getSprite("selection").Visible = false;
		this.location.onCombatLost();
	},
	function onUpdate() { this.location.onUpdate(); if (this.hasSprite("selection")) this.getSprite("selection").Visible = this.isAlive(); },
	function onDeserialize(input) { this.location.onDeserialize(input); this.configure(); this.reinforceDefenders(); ::$bvvar{namespace}.Chapters.reveal(this); }
});
