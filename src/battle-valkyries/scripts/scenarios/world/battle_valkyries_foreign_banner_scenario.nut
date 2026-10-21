this.battle_valkyries_foreign_banner_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create() {
		this.m.ID = "scenario.battle_valkyries_foreign_banner";
		this.m.Name = "$bv{origin.foreign_banner.name}";
		// Origin Customizer extracts the image using the vanilla events/ path convention.
		this.m.Description = "[p=c][img]gfx/ui/events/battle_valkyries_foreign_banner.png[/img][/p][p]$bv{origin.foreign_banner.selection}[/p]";
		this.m.Difficulty = 1; this.m.Order = 12;
	},
	function onSpawnAssets() {
		local api = ::$bvvar{namespace}, roster = this.World.getPlayerRoster();
		local backgrounds = ["companion_1h_background", "companion_ranged_background"], positions = [3, 15];
		local biographies = ["$bv{origin.foreign_banner.shield_bio}", "$bv{origin.foreign_banner.crossbow_bio}"];
		for (local i = 0; i < backgrounds.len(); ++i) {
			local actor = roster.create("scripts/entity/tactical/player");
			actor.m.HireTime = this.Time.getVirtualTimeF(); actor.setStartValuesEx([backgrounds[i]]);
			actor.getBackground().m.RawDescription = biographies[i]; actor.getBackground().buildDescription(true);
			actor.improveMood(1.0, "$bv{origin.foreign_banner.hire_reason}"); actor.setPlaceInFormation(positions[i]);
			if ("Roster" in api && api.Roster.enabled()) api.Roster.setPosition(actor, positions[i]);
		}
		foreach (entry in [{ ID = "jeanne", Position = 4 }, { ID = "enterprise", Position = 16 }]) {
			local result = api.createValkyrieRosterActor(entry.ID, this, { ChargeCrowns = false, FormationPolicy = entry.Position });
			if (!result.Success) throw "[Battle Valkyries] Foreign Banner founder creation failed: " + entry.ID;
			local actor = result.Actor, items = actor.getItems();
			if (entry.ID == "jeanne" && items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
				items.equip(this.new("scripts/items/weapons/pitchfork"));
			if (items.getItemAtSlot(this.Const.ItemSlot.Body) == null) items.equip(this.new("scripts/items/armor/padded_surcoat"));
			if (items.getItemAtSlot(this.Const.ItemSlot.Head) == null) items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		if ("Roster" in api && api.Roster.enabled()) api.Roster.normalize();
		// Vanilla medium funds are 2000: retain difficulty scaling, start with 800.
		this.World.Assets.m.Money = this.Math.floor(this.World.Assets.m.Money * 0.4);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/bread_item"));
		api.ForeignBanner.grant(this);
	},
	function onSpawnPlayer() {
		local towns = this.World.EntityManager.getSettlements(), town = null, spawn = null;
		foreach (candidate in towns) if (!candidate.isMilitary() && !candidate.isIsolatedFromRoads() && candidate.getSize() >= 2 && !candidate.isSouthern()) { town = candidate; break; }
		if (town == null) foreach (candidate in towns) if (!candidate.isIsolatedFromRoads()) { town = candidate; break; }
		if (town == null) throw "[Battle Valkyries] Foreign Banner requires a reachable settlement";
		local center = town.getTile(), settings = this.World.getNavigator().createSettings();
		settings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
		for (local radius = 2; radius <= 8 && spawn == null; ++radius)
			for (local x = this.Math.max(2, center.SquareCoords.X - radius); x <= this.Math.min(this.Const.World.Settings.SizeX - 2, center.SquareCoords.X + radius) && spawn == null; ++x)
				for (local y = this.Math.max(2, center.SquareCoords.Y - radius); y <= this.Math.min(this.Const.World.Settings.SizeY - 2, center.SquareCoords.Y + radius); ++y) {
					if (!this.World.isValidTileSquare(x, y)) continue;
					local tile = this.World.getTileSquare(x, y), distance = tile.getDistanceTo(center);
					if (distance < 2 || distance > radius || tile.IsOccupied || tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore) continue;
					if (!this.World.getNavigator().findPath(tile, center, settings, 0).isEmpty()) { spawn = tile; break; }
				}
		if (spawn == null) throw "[Battle Valkyries] Foreign Banner spawn path unavailable";
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", spawn.Coords.X, spawn.Coords.Y);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function(tag) {
			local origin = ::$bvvar{namespace}.ForeignBanner;
			if (!origin.isOrigin() || !origin.safeWorld()) return;
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.battle_valkyries_foreign_banner_intro");
		}, null);
	},
	function onContractFinished(contractType, cancelled) {
		local origin = ::$bvvar{namespace}.ForeignBanner;
		if (!origin.isOrigin() || cancelled || origin.read("first_contract")) return;
		origin.write("first_contract", true);
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function(tag) {
			if (::$bvvar{namespace}.ForeignBanner.isOrigin() && ::$bvvar{namespace}.ForeignBanner.safeWorld())
				this.World.State.m.WorldScreen.getTopbarOptionsModule().showBattleValkyrieChapter({ ID = "foreign_banner", OpenOriginScene = "first_contract" });
		}, null);
	}
});
