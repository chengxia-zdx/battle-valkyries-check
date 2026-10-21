::$bvvar{namespace}.LiuyingBondTraitID <- "$bvvar{modId}.trait.liuying_bond";
::$bvvar{namespace}.LiuyingBondEventID <- "event.battle_valkyries_liuying_bond";
::$bvvar{namespace}.LiuyingBondGainPerBattle <- 4;
::$bvvar{namespace}.LiuyingBondAttributeReward <- 5;

::$bvvar{namespace}.getLiuyingBondPerkReward <- function( _stage )
{
	return _stage >= 100 ? 2 : 1;
};

::$bvvar{namespace}.getLiuyingBondMoneyReward <- function( _stage )
{
	if (_stage == 20)
	{
		return 300;
	}
	else if (_stage == 40)
	{
		return 500;
	}
	else if (_stage == 80)
	{
		return 800;
	}

	return 0;
};

::$bvvar{namespace}.isLiuyingBondChallengeStage <- function( _stage )
{
	return _stage == 20 || _stage == 40 || _stage == 60 || _stage == 80 || _stage == 100;
};

::$bvvar{namespace}.getLiuyingBondThreatFromStage <- function( _stage )
{
	if (_stage == 20)
	{
		return 0.05;
	}
	else if (_stage == 40)
	{
		return 0.10;
	}
	else if (_stage == 60)
	{
		return 0.45;
	}
	else if (_stage == 80)
	{
		return 0.15;
	}
	else if (_stage == 100)
	{
		return 0.70;
	}

	return 0.0;
};

::$bvvar{namespace}.getLiuyingBondChallengeScript <- function( _stage )
{
	if (_stage == 20)
	{
		return "scripts/entity/world/locations/battle_valkyries/liuying_unsent_letter_camp_location";
	}
	else if (_stage == 40)
	{
		return "scripts/entity/world/locations/battle_valkyries/liuying_fading_hand_camp_location";
	}
	else if (_stage == 60)
	{
		return "scripts/entity/world/locations/battle_valkyries/liuying_glamoth_signal_camp_location";
	}
	else if (_stage == 80)
	{
		return "scripts/entity/world/locations/battle_valkyries/liuying_name_beyond_fire_camp_location";
	}
	else if (_stage == 100)
	{
		return "scripts/entity/world/locations/battle_valkyries/liuying_complete_combustion_echo_camp_location";
	}

	return null;
};

::$bvvar{namespace}.getLiuyingBondChallengeBand <- function( _stage )
{
	local days = ::World == null ? 0 : ::World.getTime().Days;
	local thresholds = null;

	if (_stage == 20)
	{
		thresholds = [35, 75, 140];
	}
	else if (_stage == 40)
	{
		thresholds = [50, 100, 170];
	}
	else if (_stage == 60)
	{
		thresholds = [70, 130, 210];
	}
	else if (_stage == 80)
	{
		thresholds = [90, 160, 250];
	}
	else if (_stage == 100)
	{
		thresholds = [110, 200, 320];
	}

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

::$bvvar{namespace}.getLiuyingBondChallengeTier <- function( _stage )
{
	local baseResources = 0;
	local step = 0;

	if (_stage == 20)
	{
		baseResources = 250;
		step = 55;
	}
	else if (_stage == 40)
	{
		baseResources = 380;
		step = 70;
	}
	else if (_stage == 60)
	{
		baseResources = 520;
		step = 90;
	}
	else if (_stage == 80)
	{
		baseResources = 680;
		step = 110;
	}
	else if (_stage == 100)
	{
		baseResources = 900;
		step = 140;
	}

	return baseResources + step * ::$bvvar{namespace}.getLiuyingBondChallengeBand(_stage);
};

::$bvvar{namespace}.populateLiuyingBondChallengeDefenders <- function( _location, _stage )
{
	if (_location == null)
	{
		return;
	}

	local band = ::$bvvar{namespace}.getLiuyingBondChallengeBand(_stage);
	local troops = ::Const.World.Spawn.Troops;

	if (_stage == 20)
	{
		_location.addTroops(troops.Direwolf, 6);
		_location.addTroops(troops.DirewolfHIGH, 1);

		if (band >= 1) { _location.addTroops(troops.Direwolf, 2); }
		if (band >= 2) { _location.addTroops(troops.Direwolf, 1); _location.addTroops(troops.DirewolfHIGH, 1); }
		if (band >= 3) { _location.addTroops(troops.Direwolf, 2); }
	}
	else if (_stage == 40)
	{
		_location.addTroops(troops.BanditRaider, 5);
		_location.addTroops(troops.BanditMarksman, 2);
		_location.addTroops(troops.BanditMarauder, 1);

		if (band >= 1) { _location.addTroops(troops.BanditRaider, 1); _location.addTroops(troops.BanditMarksman, 1); }
		if (band >= 2) { _location.addTroops(troops.BanditRaider, 1); _location.addTroops(troops.BanditMarauder, 1); }
		if (band >= 3) { _location.addTroops(troops.BanditRaider, 1); _location.addTroops(troops.BanditMarksman, 1); }
	}
	else if (_stage == 60)
	{
		_location.addTroops(troops.SkeletonMedium, 4);
		_location.addTroops(troops.SkeletonMediumPolearm, 2);
		_location.addTroops(troops.SkeletonHeavy, 2);

		if (band >= 1) { _location.addTroops(troops.SkeletonMedium, 1); _location.addTroops(troops.SkeletonHeavy, 1); }
		if (band >= 2) { _location.addTroops(troops.SkeletonHeavy, 1); _location.addTroops(troops.SkeletonPriest, 1); }
		if (band >= 3) { _location.addTroops(troops.SkeletonMediumPolearm, 1); _location.addTroops(troops.SkeletonHeavy, 1); }
	}
	else if (_stage == 80)
	{
		_location.addTroops(troops.NomadOutlaw, 5);
		_location.addTroops(troops.NomadArcher, 2);
		_location.addTroops(troops.NomadLeader, 1);

		if (band >= 1) { _location.addTroops(troops.NomadOutlaw, 1); _location.addTroops(troops.NomadArcher, 1); }
		if (band >= 2) { _location.addTroops(troops.NomadOutlaw, 2); }
		if (band >= 3) { _location.addTroops(troops.NomadOutlaw, 1); _location.addTroops(troops.DesertStalker, 1); }
	}
	else if (_stage == 100)
	{
		_location.addTroops(troops.OrcYoung, 5);
		_location.addTroops(troops.OrcWarrior, 3);
		_location.addTroops(troops.OrcBerserker, 1);
		_location.addTroops(troops.OrcWarlord, 1);

		if (band >= 1) { _location.addTroops(troops.OrcYoung, 1); _location.addTroops(troops.OrcWarrior, 1); }
		if (band >= 2) { _location.addTroops(troops.OrcYoung, 1); _location.addTroops(troops.OrcBerserker, 1); }
		if (band >= 3) { _location.addTroops(troops.OrcWarrior, 1); _location.addTroops(troops.OrcBerserker, 1); }
	}
};

::$bvvar{namespace}.LiuyingBondStages <- [
	{
		Value = 20,
		Name = "$bv{event.liuying_bond.20.stage}",
		Title = "$bv{event.liuying_bond.20.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_20_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_20_cg.png",
		Text = "$bv{event.liuying_bond.20.text}",
		RevealText = "$bv{event.liuying_bond.20.reveal}",
		RevealOption = "$bv{event.liuying_bond.20.option}",
		ChallengeText = "$bv{event.liuying_bond.reward.challenge_20}"
	},
	{
		Value = 40,
		Name = "$bv{event.liuying_bond.40.stage}",
		Title = "$bv{event.liuying_bond.40.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_40_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_40_cg.png",
		Text = "$bv{event.liuying_bond.40.text}",
		RevealText = "$bv{event.liuying_bond.40.reveal}",
		RevealOption = "$bv{event.liuying_bond.40.option}",
		ChallengeText = "$bv{event.liuying_bond.reward.challenge_40}"
	},
	{
		Value = 60,
		Name = "$bv{event.liuying_bond.60.stage}",
		Title = "$bv{event.liuying_bond.60.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_60_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_60_cg.png",
		Text = "$bv{event.liuying_bond.60.text}",
		RevealText = "$bv{event.liuying_bond.60.reveal}",
		RevealOption = "$bv{event.liuying_bond.60.option}",
		ChallengeText = "$bv{event.liuying_bond.reward.challenge_60}"
	},
	{
		Value = 80,
		Name = "$bv{event.liuying_bond.80.stage}",
		Title = "$bv{event.liuying_bond.80.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_80_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_80_cg.png",
		Text = "$bv{event.liuying_bond.80.text}",
		RevealText = "$bv{event.liuying_bond.80.reveal}",
		RevealOption = "$bv{event.liuying_bond.80.option}",
		ChallengeText = "$bv{event.liuying_bond.reward.challenge_80}"
	},
	{
		Value = 100,
		Name = "$bv{event.liuying_bond.100.stage}",
		Title = "$bv{event.liuying_bond.100.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_100_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/liuying_bond_100_cg.png",
		Text = "$bv{event.liuying_bond.100.text}",
		RevealText = "$bv{event.liuying_bond.100.reveal}",
		RevealOption = "$bv{event.liuying_bond.100.option}",
		ChallengeText = "$bv{event.liuying_bond.reward.challenge_100}"
	}
];

::$bvvar{namespace}.getLiuyingBondStageByValue <- function( _value )
{
	foreach( stage in ::$bvvar{namespace}.LiuyingBondStages )
	{
		if (stage.Value == _value)
		{
			return stage;
		}
	}

	return null;
};

::$bvvar{namespace}.findLiuyingBondTrait <- function()
{
	if (::World == null || ::World.getPlayerRoster() == null)
	{
		return null;
	}

	foreach( bro in ::World.getPlayerRoster().getAll() )
	{
		if (bro == null || ::$bvvar{namespace}.isActorDeadOrDying(bro))
		{
			continue;
		}

		if (::$bvvar{namespace}.getActorValkyrieID(bro) != "liuying")
		{
			continue;
		}

		local trait = bro.getSkills().getSkillByID(::$bvvar{namespace}.LiuyingBondTraitID);

		if (trait != null)
		{
			return trait;
		}
	}

	return null;
};

::$bvvar{namespace}.getLiuyingBondPendingStage <- function()
{
	local trait = ::$bvvar{namespace}.findLiuyingBondTrait();

	if (trait == null || !trait.hasPendingStage())
	{
		return null;
	}

	return ::$bvvar{namespace}.getLiuyingBondStageByValue(trait.getNextPendingStage());
};

::$bvvar{namespace}.isValidLiuyingBondChallengeTile <- function( _tile )
{
	return _tile != null
		&& _tile.Type != ::Const.World.TerrainType.Ocean
		&& _tile.Type != ::Const.World.TerrainType.Shore
		&& !_tile.IsOccupied;
};

::$bvvar{namespace}.getLiuyingBondChallengeSpawnTile <- function( _minDistance = 3, _maxDistance = 8 )
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

			if (distance < _minDistance || distance > _maxDistance || !::$bvvar{namespace}.isValidLiuyingBondChallengeTile(tile))
			{
				continue;
			}

			candidates.push(tile);
		}
	}

	if (candidates.len() != 0)
	{
		return candidates[::Math.rand(0, candidates.len() - 1)];
	}

	if (_maxDistance < 16)
	{
		return ::$bvvar{namespace}.getLiuyingBondChallengeSpawnTile(_minDistance, 16);
	}

	return null;
};

::$bvvar{namespace}.getLiuyingBondChallengeFactionType <- function( _stage )
{
	if (_stage == 20)
	{
		return ::Const.FactionType.Beasts;
	}
	else if (_stage == 40)
	{
		return ::Const.FactionType.Bandits;
	}
	else if (_stage == 60)
	{
		return ::Const.FactionType.Undead;
	}
	else if (_stage == 80)
	{
		return ::Const.FactionType.OrientalBandits;
	}

	return ::Const.FactionType.Orcs;
};

::$bvvar{namespace}.getLiuyingBondChallengeFallbackFaction <- function( _stage )
{
	if (_stage == 20)
	{
		return ::Const.Faction.Beasts;
	}
	else if (_stage == 40)
	{
		return ::Const.Faction.Bandits;
	}
	else if (_stage == 60)
	{
		return ::Const.Faction.Undead;
	}
	else if (_stage == 80)
	{
		return ::Const.Faction.OrientalBandits;
	}

	return ::Const.Faction.Orcs;
};

::$bvvar{namespace}.attachLiuyingBondChallengeFaction <- function( _location, _stage )
{
	if (_location == null || ::World == null || ::World.FactionManager == null)
	{
		return;
	}

	local faction = ::World.FactionManager.getFactionOfType(::$bvvar{namespace}.getLiuyingBondChallengeFactionType(_stage));

	if (faction != null)
	{
		faction.addSettlement(_location, false);
	}
	else
	{
		_location.setFaction(::$bvvar{namespace}.getLiuyingBondChallengeFallbackFaction(_stage));
		_location.updatePlayerRelation();
	}
};

::$bvvar{namespace}.revealLiuyingBondChallengeLocation <- function( _location )
{
	if (_location == null)
	{
		return;
	}

	try
	{
		_location.setVisibleInFogOfWar(true);
	}
	catch (e)
	{
	}

	try
	{
		_location.setDiscovered(true);
	}
	catch (e)
	{
	}

	try
	{
		if (_location.hasSprite("selection"))
		{
			_location.getSprite("selection").Visible = true;
		}
	}
	catch (e)
	{
	}

	try
	{
		_location.getFlags().set("BattleValkyriesLiuyingBondObjective", true);
	}
	catch (e)
	{
	}

	try
	{
		if (::World != null)
		{
			::World.uncoverFogOfWar(_location.getTile().Pos, 500.0);
		}
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.spawnLiuyingBondChallengeCamp <- function( _stage )
{
	if (!::$bvvar{namespace}.isLiuyingBondChallengeStage(_stage) || ::World == null)
	{
		return false;
	}

	local trait = ::$bvvar{namespace}.findLiuyingBondTrait();

	if (trait == null || !trait.hasPendingStageValue(_stage))
	{
		return false;
	}

	local script = ::$bvvar{namespace}.getLiuyingBondChallengeScript(_stage);
	local tile = ::$bvvar{namespace}.getLiuyingBondChallengeSpawnTile();

	if (script == null || tile == null)
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
		::logWarning("[Battle Valkyries] Liuying challenge camp was discarded because its pending stage could not be marked: " + _stage);
		return false;
	}

	location.onSpawned();
	::$bvvar{namespace}.revealLiuyingBondChallengeLocation(location);
	return true;
};

::$bvvar{namespace}.grantLiuyingBondChallengeReward <- function( _stage )
{
	local trait = ::$bvvar{namespace}.findLiuyingBondTrait();

	if (trait == null)
	{
		return false;
	}

	return trait.completeChallengeStage(_stage);
};

::$bvvar{namespace}.grantLiuyingBondCombatProgress <- function( _label = "" )
{
	local trait = ::$bvvar{namespace}.findLiuyingBondTrait();

	if (trait == null)
	{
		return 0;
	}

	return trait.addBond(::$bvvar{namespace}.LiuyingBondGainPerBattle);
};

::$bvvar{namespace}.requestLiuyingBondEventCheck <- function()
{
	if (::World == null || !("Events" in ::World) || ::World.Events == null || ::$bvvar{namespace}.getLiuyingBondPendingStage() == null)
	{
		return false;
	}

	return ::World.Events.updateSpecialEvents();
};

::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.LiuyingBondTraitID, ::$bvvar{namespace}.requestLiuyingBondEventCheck);

::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addSpecialEvent(::$bvvar{namespace}.LiuyingBondEventID);
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		local ret = __original();
		::$bvvar{namespace}.grantLiuyingBondCombatProgress("world_state.onCombatFinished");
		return ret;
	}
});
