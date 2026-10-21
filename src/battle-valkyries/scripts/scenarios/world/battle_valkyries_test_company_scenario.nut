this.$bvvar{scenarioScript} <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},

	function create()
	{
		this.m.ID = "$bvvar{scenarioId}";
		this.m.Name = "$bv{test_origin.name}";
		this.m.Description = "[p=c][img]gfx/ui/events/event_80.png[/img][/p][p]$bv{test_origin.description}[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 11;
	}

	function isValid()
	{
		return true;
	}

	function isUsedTestSpawnTile( _tile, _usedTiles )
	{
		if (_usedTiles == null)
		{
			return false;
		}

		foreach( usedTile in _usedTiles )
		{
			if (usedTile != null && usedTile.SquareCoords.X == _tile.SquareCoords.X && usedTile.SquareCoords.Y == _tile.SquareCoords.Y)
			{
				return true;
			}
		}

		return false;
	}

	function isValidTestSpawnTile( _tile, _usedTiles = null )
	{
		if (_tile == null || _tile.Type == this.Const.World.TerrainType.Ocean || _tile.Type == this.Const.World.TerrainType.Shore || _tile.IsOccupied)
		{
			return false;
		}

		return !this.isUsedTestSpawnTile(_tile, _usedTiles);
	}

	function getTestWorldSpawnTile( _playerTile, _minDistance, _maxDistance, _usedTiles = null )
	{
		local candidates = [];

		for( local x = this.Math.max(2, _playerTile.SquareCoords.X - _maxDistance); x <= this.Math.min(this.Const.World.Settings.SizeX - 2, _playerTile.SquareCoords.X + _maxDistance); x = ++x )
		{
			for( local y = this.Math.max(2, _playerTile.SquareCoords.Y - _maxDistance); y <= this.Math.min(this.Const.World.Settings.SizeY - 2, _playerTile.SquareCoords.Y + _maxDistance); y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				local tile = this.World.getTileSquare(x, y);
				local distance = tile.getDistanceTo(_playerTile);

				if (distance < _minDistance || distance > _maxDistance)
				{
					continue;
				}

				if (!this.isValidTestSpawnTile(tile, _usedTiles))
				{
					continue;
				}

				candidates.push(tile);
			}
		}

		if (candidates.len() != 0)
		{
			return candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		if (_maxDistance < 18)
		{
			return this.getTestWorldSpawnTile(_playerTile, _minDistance, 18, _usedTiles);
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (_playerTile.hasNextTile(i))
			{
				local tile = _playerTile.getNextTile(i);

				if (this.isValidTestSpawnTile(tile, _usedTiles))
				{
					return tile;
				}
			}
		}

		return null;
	}

	function revealTestWorldEntity( _entity )
	{
		if (_entity == null)
		{
			return;
		}

		try
		{
			_entity.setVisibleInFogOfWar(true);
		}
		catch( e )
		{
		}

		try
		{
			_entity.setDiscovered(true);
		}
		catch( e )
		{
		}
	}

	function spawnTestLegendaryLocationsNearPlayer( _playerTile )
	{
		local usedTiles = [];
		local locations = [
			{
				Script = "scripts/entity/world/locations/legendary/black_monolith_location",
				MinDistance = 5,
				MaxDistance = 10,
				TacticalType = this.Const.World.TerrainTacticalType.Quarry
			},
			{
				Script = "scripts/entity/world/locations/legendary/unique_goblin_city_location",
				MinDistance = 6,
				MaxDistance = 11
			},
			{
				Script = "scripts/entity/world/locations/legendary/unhold_graveyard_location",
				MinDistance = 7,
				MaxDistance = 12
			},
			{
				Script = "scripts/entity/world/locations/legendary/witch_hut_location",
				MinDistance = 8,
				MaxDistance = 13
			},
			{
				Script = "scripts/entity/world/locations/legendary/waterwheel_location",
				MinDistance = 9,
				MaxDistance = 14
			}
		];

		foreach( def in locations )
		{
			local tile = this.getTestWorldSpawnTile(_playerTile, def.MinDistance, def.MaxDistance, usedTiles);
			if (tile == null)
			{
				::logWarning("[Battle Valkyries] Test origin could not find a tile for legendary location " + def.Script);
				continue;
			}

			if ("TacticalType" in def)
			{
				tile.TacticalType = def.TacticalType;
			}

			local location = this.World.spawnLocation(def.Script, tile.Coords);
			if (location == null)
			{
				::logWarning("[Battle Valkyries] Test origin could not spawn legendary location " + def.Script);
				continue;
			}

			location.onSpawned();
			if (def.Script == "scripts/entity/world/locations/legendary/unique_goblin_city_location")
			{
				local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins);
				if (goblins != null)
				{
					goblins.addSettlement(location, false);
				}
			}

			this.revealTestWorldEntity(location);
			usedTiles.push(tile);
		}
	}

	function spawnTestChampionCampNearPlayer( _playerTile )
	{
		local tile = this.getTestWorldSpawnTile(_playerTile, 2, 4);

		if (tile == null)
		{
			::logWarning("[Battle Valkyries] Test origin could not find a tile for the champion camp.");
			return null;
		}

		local camp = this.World.spawnLocation("scripts/entity/world/locations/battle_valkyries/battle_valkyries_test_champion_camp_location", tile.Coords);

		if (camp == null)
		{
			::logWarning("[Battle Valkyries] Test origin could not spawn the champion camp.");
			return null;
		}

		camp.onSpawned();

		local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);

		if (bandits == null)
		{
			::logWarning("[Battle Valkyries] Test origin could not attach the champion camp to the bandit faction.");
			return camp;
		}

		camp.setBanner(this.Const.BanditBanners[this.Math.rand(0, this.Const.BanditBanners.len() - 1)]);
		bandits.addSettlement(camp, false);
		camp.populateDefenders();
		this.revealTestWorldEntity(camp);
		::logInfo("[Battle Valkyries] Test origin spawned a nearby camp with 5 brigand champions.");
		return camp;
	}

	function addTestXilianBondCrystalsToStash()
	{
		local stash = this.World.Assets.getStash();
		local count = 10;
		local requiredCapacity = stash.getNumberOfFilledSlots() + count;

		if (stash.getCapacity() < requiredCapacity)
		{
			stash.resize(requiredCapacity);
		}

		for( local i = 0; i < count; i = ++i )
		{
			local item = this.new("scripts/items/misc/xilian_bond_crystal_item");

			if (stash.add(item) == null)
			{
				::logWarning("[Battle Valkyries] Test origin stash is full; could not add xilian bond crystal.");
				return;
			}
		}
	}

	function addTestMemoryResources()
	{
		foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
		{
			::$bvvar{namespace}.setMemoryWorldValue("balance." + resource.Key, 1000);
		}

		::logInfo("[Battle Valkyries] Test origin initialized every memory resource to 1000.");
	}

	function getTestAlchemyEnchantmentSystem()
	{
		local root = getroottable();

		if ("AlchemyEnchantmentSystem" in root)
		{
			return ::AlchemyEnchantmentSystem;
		}

		if ("AlchemyEnchantmentSystemZh" in root)
		{
			return ::AlchemyEnchantmentSystemZh;
		}

		return null;
	}

	function addTestAlchemyEnchantmentResources()
	{
		local alchemy = this.getTestAlchemyEnchantmentSystem();
		if (alchemy == null
			|| !("EquipmentAffixTierOrder" in alchemy)
			|| !("addEquipmentMaterial" in alchemy)
			|| !("addEquipmentRemovalStone" in alchemy))
		{
			return;
		}

		local addedTiers = 0;
		foreach (tierID in alchemy.EquipmentAffixTierOrder)
		{
			if (alchemy.addEquipmentMaterial(tierID, 1000))
			{
				addedTiers = ++addedTiers;
			}
		}

		local removalAdded = alchemy.addEquipmentRemovalStone(1000);
		if (addedTiers == alchemy.EquipmentAffixTierOrder.len() && removalAdded)
		{
			::logInfo("[Battle Valkyries] Test origin added 1000 of every enchantment stone and removal stone.");
		}
		else
		{
			::logWarning("[Battle Valkyries] Test origin could not initialize every alchemy/enchantment resource.");
		}
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];
		local backgrounds = [
			"companion_1h_background",
			"companion_2h_background",
			"companion_ranged_background"
		];
		local formation = [
			3,
			4,
			5
		];
		local bros = [];

		for( local i = 0; i < backgrounds.len(); i = ++i )
		{
			local bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.5, "$bv{test_origin.hire_mood}");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			bro.setStartValuesEx([
				backgrounds[i]
			]);
			bro.setPlaceInFormation(formation[i]);
			bros.push(bro);
		}

		bros[0].getBackground().m.RawDescription = "$bv{test_origin.founder_0}";
		bros[1].getBackground().m.RawDescription = "$bv{test_origin.founder_1}";
		bros[2].getBackground().m.RawDescription = "$bv{test_origin.founder_2}";

		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.addTestXilianBondCrystalsToStash();
		this.addTestMemoryResources();
		this.addTestAlchemyEnchantmentResources();
		this.World.Assets.m.Money = 3000000;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.spawnTestChampionCampNearPlayer(randomVillageTile);
		this.spawnTestLegendaryLocationsNearPlayer(randomVillageTile);
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.early_access_scenario_intro");
		}, null);
	}
});
