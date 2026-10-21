::$bvvar{namespace}.HimekoBondTraitID <- "$bvvar{modId}.trait.himeko_bond";
::$bvvar{namespace}.HimekoBondEventID <- "event.battle_valkyries_himeko_bond";
::$bvvar{namespace}.HimekoBondGainPerBattle <- 4;

::$bvvar{namespace}.isHimekoBondChallengeStage <- function( _stage )
{
	return _stage == 20 || _stage == 40 || _stage == 60 || _stage == 80 || _stage == 100;
};

::$bvvar{namespace}.getHimekoBondChallengeScript <- function( _stage )
{
	if (_stage == 20) return "scripts/entity/world/locations/battle_valkyries/himeko_lance_cache_camp_location";
	if (_stage == 40) return "scripts/entity/world/locations/battle_valkyries/himeko_star_circlet_camp_location";
	if (_stage == 60) return "scripts/entity/world/locations/battle_valkyries/himeko_navigator_armor_camp_location";
	if (_stage == 80) return "scripts/entity/world/locations/battle_valkyries/himeko_trailblazer_hangar_camp_location";
	if (_stage == 100) return "scripts/entity/world/locations/battle_valkyries/himeko_astral_oath_camp_location";
	return null;
};

::$bvvar{namespace}.getHimekoBondChallengeBand <- function( _stage )
{
	local days = ::World == null ? 0 : ::World.getTime().Days;
	local thresholds = null;

	if (_stage == 20) thresholds = [35, 75, 140];
	else if (_stage == 40) thresholds = [50, 100, 170];
	else if (_stage == 60) thresholds = [70, 130, 210];
	else if (_stage == 80) thresholds = [90, 160, 250];
	else if (_stage == 100) thresholds = [110, 200, 320];

	if (thresholds == null)
	{
		return 0;
	}

	local band = 0;

	foreach( threshold in thresholds )
	{
		if (days >= threshold)
		{
			band = band + 1;
		}
	}

	if (::$bvvar{namespace}.isValkyrieEnemyScalingEnabled())
	{
		band = ::Math.min(3, band + 1);
	}

	return band;
};

::$bvvar{namespace}.getHimekoBondChallengeTier <- function( _stage )
{
	local baseResources = 250;
	local step = 55;

	if (_stage == 40) { baseResources = 380; step = 70; }
	else if (_stage == 60) { baseResources = 520; step = 90; }
	else if (_stage == 80) { baseResources = 680; step = 110; }
	else if (_stage == 100) { baseResources = 900; step = 140; }

	return baseResources + step * ::$bvvar{namespace}.getHimekoBondChallengeBand(_stage);
};

::$bvvar{namespace}.populateHimekoBondChallengeDefenders <- function( _location, _stage )
{
	if (_location == null)
	{
		return;
	}

	local band = ::$bvvar{namespace}.getHimekoBondChallengeBand(_stage);
	local troops = ::Const.World.Spawn.Troops;

	if (_stage == 20)
	{
		_location.addTroops(troops.BanditRaider, 5 + band);
		_location.addTroops(troops.BanditMarksman, 2);
		_location.addTroops(troops.BanditMarauder, 1 + (band >= 2 ? 1 : 0));
	}
	else if (_stage == 40)
	{
		_location.addTroops(troops.GoblinSkirmisher, 5 + band);
		_location.addTroops(troops.GoblinAmbusher, 2 + (band >= 2 ? 1 : 0));
		_location.addTroops(troops.GoblinOverseer, 1);
	}
	else if (_stage == 60)
	{
		_location.addTroops(troops.BarbarianThrall, 4 + band);
		_location.addTroops(troops.BarbarianChosen, 3 + (band >= 2 ? 1 : 0));
		_location.addTroops(troops.BarbarianBeastmaster, 1);
	}
	else if (_stage == 80)
	{
		_location.addTroops(troops.OrcYoung, 5 + band);
		_location.addTroops(troops.OrcWarrior, 3 + (band >= 2 ? 1 : 0));
		_location.addTroops(troops.OrcBerserker, 1);
	}
	else if (_stage == 100)
	{
		_location.addTroops(troops.SkeletonMedium, 5 + band);
		_location.addTroops(troops.SkeletonMediumPolearm, 2);
		_location.addTroops(troops.SkeletonHeavy, 3 + (band >= 2 ? 1 : 0));
		_location.addTroops(troops.SkeletonPriest, 1);
	}
};

::$bvvar{namespace}.HimekoBondStages <- [
	{
		Value = 20,
		Name = "$bv{event.himeko_bond.20.stage}",
		Title = "$bv{event.himeko_bond.20.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_20_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_20_cg.png",
		Text = "$bv{event.himeko_bond.20.text}",
		RevealText = "$bv{event.himeko_bond.20.reveal}",
		RevealOption = "$bv{event.himeko_bond.20.option}",
		ChallengeText = "$bv{event.himeko_bond.reward.challenge_20}"
	},
	{
		Value = 40,
		Name = "$bv{event.himeko_bond.40.stage}",
		Title = "$bv{event.himeko_bond.40.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_40_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_40_cg.png",
		Text = "$bv{event.himeko_bond.40.text}",
		RevealText = "$bv{event.himeko_bond.40.reveal}",
		RevealOption = "$bv{event.himeko_bond.40.option}",
		ChallengeText = "$bv{event.himeko_bond.reward.challenge_40}"
	},
	{
		Value = 60,
		Name = "$bv{event.himeko_bond.60.stage}",
		Title = "$bv{event.himeko_bond.60.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_60_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_60_cg.png",
		Text = "$bv{event.himeko_bond.60.text}",
		RevealText = "$bv{event.himeko_bond.60.reveal}",
		RevealOption = "$bv{event.himeko_bond.60.option}",
		ChallengeText = "$bv{event.himeko_bond.reward.challenge_60}"
	},
	{
		Value = 80,
		Name = "$bv{event.himeko_bond.80.stage}",
		Title = "$bv{event.himeko_bond.80.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_80_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_80_cg.png",
		Text = "$bv{event.himeko_bond.80.text}",
		RevealText = "$bv{event.himeko_bond.80.reveal}",
		RevealOption = "$bv{event.himeko_bond.80.option}",
		ChallengeText = "$bv{event.himeko_bond.reward.challenge_80}"
	},
	{
		Value = 100,
		Name = "$bv{event.himeko_bond.100.stage}",
		Title = "$bv{event.himeko_bond.100.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_100_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/himeko_bond_100_cg.png",
		Text = "$bv{event.himeko_bond.100.text}",
		RevealText = "$bv{event.himeko_bond.100.reveal}",
		RevealOption = "$bv{event.himeko_bond.100.option}",
		ChallengeText = "$bv{event.himeko_bond.reward.challenge_100}"
	}
];

::$bvvar{namespace}.getHimekoBondStageByValue <- function( _value )
{
	foreach( stage in ::$bvvar{namespace}.HimekoBondStages )
	{
		if (stage.Value == _value)
		{
			return stage;
		}
	}

	return null;
};

::$bvvar{namespace}.findHimekoBondTrait <- function()
{
	if (::World == null || ::World.getPlayerRoster() == null)
	{
		return null;
	}

	foreach( actor in ::World.getPlayerRoster().getAll() )
	{
		if (actor != null
			&& !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& ::$bvvar{namespace}.getActorValkyrieID(actor) == "himeko")
		{
			local trait = actor.getSkills().getSkillByID(::$bvvar{namespace}.HimekoBondTraitID);

			if (trait != null)
			{
				return trait;
			}
		}
	}

	return null;
};

::$bvvar{namespace}.getHimekoBondPendingStage <- function()
{
	local trait = ::$bvvar{namespace}.findHimekoBondTrait();
	return trait == null || !trait.hasPendingStage() ? null : ::$bvvar{namespace}.getHimekoBondStageByValue(trait.getNextPendingStage());
};

::$bvvar{namespace}.getHimekoBondChallengeLocations <- function( _stage )
{
	local ret = [];

	if (!::$bvvar{namespace}.isHimekoBondChallengeStage(_stage)
		|| ::World == null
		|| ::World.EntityManager == null)
	{
		return ret;
	}

	local typeID = "$bvvar{modId}.location.himeko_bond_" + _stage;

	foreach( location in ::World.EntityManager.getLocations() )
	{
		if (location != null && location.getTypeID() == typeID)
		{
			ret.push(location);
		}
	}

	return ret;
};

::$bvvar{namespace}.isValidHimekoBondChallengeTile <- function( _tile )
{
	return _tile != null
		&& _tile.Type != ::Const.World.TerrainType.Ocean
		&& _tile.Type != ::Const.World.TerrainType.Shore
		&& !_tile.IsOccupied;
};

::$bvvar{namespace}.getHimekoBondChallengeSpawnTile <- function( _minDistance = 3, _maxDistance = 8 )
{
	if (::World == null || ::World.State == null || ::World.State.getPlayer() == null)
	{
		return null;
	}

	local playerTile = ::World.State.getPlayer().getTile();
	local candidates = [];

	for( local x = ::Math.max(2, playerTile.SquareCoords.X - _maxDistance); x <= ::Math.min(::Const.World.Settings.SizeX - 2, playerTile.SquareCoords.X + _maxDistance); x = ++x )
	{
		for( local y = ::Math.max(2, playerTile.SquareCoords.Y - _maxDistance); y <= ::Math.min(::Const.World.Settings.SizeY - 2, playerTile.SquareCoords.Y + _maxDistance); y = ++y )
		{
			if (!::World.isValidTileSquare(x, y))
			{
				continue;
			}

			local tile = ::World.getTileSquare(x, y);
			local distance = tile.getDistanceTo(playerTile);

			if (distance >= _minDistance && distance <= _maxDistance && ::$bvvar{namespace}.isValidHimekoBondChallengeTile(tile))
			{
				candidates.push(tile);
			}
		}
	}

	if (candidates.len() != 0)
	{
		return candidates[::Math.rand(0, candidates.len() - 1)];
	}

	return _maxDistance < 16 ? ::$bvvar{namespace}.getHimekoBondChallengeSpawnTile(_minDistance, 16) : null;
};

::$bvvar{namespace}.getHimekoBondChallengeFactionType <- function( _stage )
{
	if (_stage == 20) return ::Const.FactionType.Bandits;
	if (_stage == 40) return ::Const.FactionType.Goblins;
	if (_stage == 60) return ::Const.FactionType.Barbarians;
	if (_stage == 80) return ::Const.FactionType.Orcs;
	return ::Const.FactionType.Undead;
};

::$bvvar{namespace}.getHimekoBondChallengeFallbackFaction <- function( _stage )
{
	if (_stage == 20) return ::Const.Faction.Bandits;
	if (_stage == 40) return ::Const.Faction.Goblins;
	if (_stage == 60) return ::Const.Faction.Barbarians;
	if (_stage == 80) return ::Const.Faction.Orcs;
	return ::Const.Faction.Undead;
};

::$bvvar{namespace}.attachHimekoBondChallengeFaction <- function( _location, _stage )
{
	if (_location == null || ::World == null || ::World.FactionManager == null)
	{
		return;
	}

	local faction = ::World.FactionManager.getFactionOfType(::$bvvar{namespace}.getHimekoBondChallengeFactionType(_stage));

	if (faction != null)
	{
		faction.addSettlement(_location, false);
	}
	else
	{
		_location.setFaction(::$bvvar{namespace}.getHimekoBondChallengeFallbackFaction(_stage));
		_location.updatePlayerRelation();
	}
};

::$bvvar{namespace}.revealHimekoBondChallengeLocation <- function( _location )
{
	if (_location == null)
	{
		return;
	}

	try { _location.setVisibleInFogOfWar(true); } catch (e) {}
	try { _location.setDiscovered(true); } catch (e) {}
	try { if (_location.hasSprite("selection")) _location.getSprite("selection").Visible = true; } catch (e) {}
	try { _location.getFlags().set("BattleValkyriesHimekoBondObjective", true); } catch (e) {}
	try { if (::World != null) ::World.uncoverFogOfWar(_location.getTile().Pos, 500.0); } catch (e) {}
};

::$bvvar{namespace}.spawnHimekoBondChallengeCamp <- function( _stage )
{
	if (!::$bvvar{namespace}.isHimekoBondChallengeStage(_stage) || ::World == null)
	{
		return false;
	}

	local trait = ::$bvvar{namespace}.findHimekoBondTrait();
	local script = ::$bvvar{namespace}.getHimekoBondChallengeScript(_stage);

	if (trait == null || !trait.hasPendingStageValue(_stage) || script == null)
	{
		return false;
	}

	local existingLocations = ::$bvvar{namespace}.getHimekoBondChallengeLocations(_stage);

	if (existingLocations.len() != 0)
	{
		if (!trait.startChallengeStage(_stage))
		{
			return false;
		}

		local recoveredLocation = existingLocations[0];

		for( local i = 1; i < existingLocations.len(); i = ++i )
		{
			existingLocations[i].die();
		}

		recoveredLocation.clearTroops();
		recoveredLocation.populateDefenders();
		::$bvvar{namespace}.revealHimekoBondChallengeLocation(recoveredLocation);
		::logInfo("[Battle Valkyries] Recovered Himeko challenge stage " + _stage + " and removed " + (existingLocations.len() - 1) + " duplicate locations.");
		return true;
	}

	local tile = ::$bvvar{namespace}.getHimekoBondChallengeSpawnTile();

	if (tile == null)
	{
		return false;
	}

	local location = ::World.spawnLocation(script, tile.Coords);

	if (location == null)
	{
		return false;
	}

	if (!trait.startChallengeStage(_stage))
	{
		location.die();
		::logWarning("[Battle Valkyries] Himeko challenge camp was discarded because its pending stage could not be marked: " + _stage);
		return false;
	}

	location.onSpawned();
	::$bvvar{namespace}.revealHimekoBondChallengeLocation(location);
	return true;
};

::$bvvar{namespace}.grantHimekoBondChallengeReward <- function( _stage )
{
	local trait = ::$bvvar{namespace}.findHimekoBondTrait();
	return trait != null && trait.completeChallengeStage(_stage);
};

::$bvvar{namespace}.grantHimekoBondCombatProgress <- function()
{
	local trait = ::$bvvar{namespace}.findHimekoBondTrait();
	return trait == null ? 0 : trait.addBond(::$bvvar{namespace}.HimekoBondGainPerBattle);
};

::$bvvar{namespace}.requestHimekoBondEventCheck <- function()
{
	if (::World == null || !("Events" in ::World) || ::World.Events == null || ::$bvvar{namespace}.getHimekoBondPendingStage() == null)
	{
		return false;
	}

	return ::World.Events.updateSpecialEvents();
};

::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.HimekoBondTraitID, ::$bvvar{namespace}.requestHimekoBondEventCheck);

::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addSpecialEvent(::$bvvar{namespace}.HimekoBondEventID);
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		local ret = __original();
		::$bvvar{namespace}.grantHimekoBondCombatProgress();
		return ret;
	}
});
