::$bvvar{namespace}.XilianBondTraitID <- "$bvvar{modId}.trait.xilian_bond";
::$bvvar{namespace}.XilianBondEventID <- "event.battle_valkyries_xilian_bond";
::$bvvar{namespace}.XilianBondGainPerBattle <- 4;
::$bvvar{namespace}.XilianBondAttributeReward <- 5;
::$bvvar{namespace}.ValkyrieBondTraitIDs <- [];

::$bvvar{namespace}.registerValkyrieBondTrait <- function( _traitID, _eventCheck )
{
	if (_traitID == null)
	{
		return false;
	}

	foreach( entry in ::$bvvar{namespace}.ValkyrieBondTraitIDs )
	{
		if (entry.ID == _traitID)
		{
			entry.EventCheck = _eventCheck;
			return false;
		}
	}

	::$bvvar{namespace}.ValkyrieBondTraitIDs.push({
		ID = _traitID,
		EventCheck = _eventCheck
	});
	return true;
};

::$bvvar{namespace}.findValkyrieBondTraitForActor <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null)
	{
		return null;
	}

	foreach( entry in ::$bvvar{namespace}.ValkyrieBondTraitIDs )
	{
		local trait = _actor.getSkills().getSkillByID(entry.ID);

		if (trait != null)
		{
			return trait;
		}
	}

	return null;
};

::$bvvar{namespace}.requestValkyrieBondEventCheckForTrait <- function( _trait )
{
	if (_trait == null)
	{
		return false;
	}

	local traitID = _trait.getID();

	foreach( entry in ::$bvvar{namespace}.ValkyrieBondTraitIDs )
	{
		if (entry.ID == traitID && entry.EventCheck != null)
		{
			return entry.EventCheck();
		}
	}

	return false;
};

::$bvvar{namespace}.getXilianBondPerkReward <- function( _stage )
{
	return _stage >= 100 ? 2 : 1;
};

::$bvvar{namespace}.getXilianBondMoneyReward <- function( _stage )
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

::$bvvar{namespace}.isXilianBondChallengeStage <- function( _stage )
{
	return _stage == 20 || _stage == 40 || _stage == 60 || _stage == 80 || _stage == 100;
};

::$bvvar{namespace}.getXilianBondThreatFromStage <- function( _stage )
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

::$bvvar{namespace}.getXilianBondChallengeScript <- function( _stage )
{
	if (_stage == 20)
	{
		return "scripts/entity/world/locations/battle_valkyries/xilian_shard_camp_location";
	}
	else if (_stage == 40)
	{
		return "scripts/entity/world/locations/battle_valkyries/xilian_campfire_camp_location";
	}
	else if (_stage == 60)
	{
		return "scripts/entity/world/locations/battle_valkyries/xilian_memory_camp_location";
	}
	else if (_stage == 80)
	{
		return "scripts/entity/world/locations/battle_valkyries/xilian_broken_loop_camp_location";
	}
	else if (_stage == 100)
	{
		return "scripts/entity/world/locations/battle_valkyries/xilian_echo_camp_location";
	}

	return null;
};

::$bvvar{namespace}.getXilianBondChallengeBand <- function( _stage )
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

::$bvvar{namespace}.getXilianBondChallengeTier <- function( _stage )
{
	local baseResources = 0;
	local step = 0;

	if (_stage == 20)
	{
		baseResources = 350;
		step = 70;
	}
	else if (_stage == 40)
	{
		baseResources = 500;
		step = 90;
	}
	else if (_stage == 60)
	{
		baseResources = 700;
		step = 110;
	}
	else if (_stage == 80)
	{
		baseResources = 900;
		step = 140;
	}
	else if (_stage == 100)
	{
		baseResources = 1150;
		step = 180;
	}

	return baseResources + step * ::$bvvar{namespace}.getXilianBondChallengeBand(_stage);
};

::$bvvar{namespace}.populateXilianBondChallengeDefenders <- function( _location, _stage )
{
	if (_location == null)
	{
		return;
	}

	local band = ::$bvvar{namespace}.getXilianBondChallengeBand(_stage);
	local troops = ::Const.World.Spawn.Troops;

	if (_stage == 20)
	{
		_location.addTroops(troops.BanditRaider, 4);
		_location.addTroops(troops.BanditMarksman, 2);
		_location.addTroops(troops.BanditMarauder, 1);
		_location.addTroops(troops.BanditLeader, 1);

		if (band >= 1) { _location.addTroops(troops.BanditRaider, 1); _location.addTroops(troops.BanditMarksman, 1); }
		if (band >= 2) { _location.addTroops(troops.BanditRaider, 1); _location.addTroops(troops.BanditMarauder, 1); }
		if (band >= 3) { _location.addTroops(troops.BanditRaider, 1); _location.addTroops(troops.BanditMarksman, 1); }
	}
	else if (_stage == 40)
	{
		_location.addTroops(troops.GoblinSkirmisher, 5);
		_location.addTroops(troops.GoblinAmbusher, 3);
		_location.addTroops(troops.GoblinShaman, 1);
		_location.addTroops(troops.GoblinOverseer, 1);
		_location.addTroops(troops.GoblinWolfrider, 1);

		if (band >= 1) { _location.addTroops(troops.GoblinSkirmisher, 1); _location.addTroops(troops.GoblinWolfrider, 1); }
		if (band >= 2) { _location.addTroops(troops.GoblinSkirmisher, 1); _location.addTroops(troops.GoblinAmbusher, 1); }
		if (band >= 3) { _location.addTroops(troops.GoblinSkirmisher, 1); _location.addTroops(troops.GoblinOverseer, 1); _location.addTroops(troops.GoblinWolfrider, 1); }
	}
	else if (_stage == 60)
	{
		_location.addTroops(troops.BarbarianMarauder, 5);
		_location.addTroops(troops.BarbarianChosen, 2);
		_location.addTroops(troops.BarbarianDrummer, 1);
		_location.addTroops(troops.BarbarianChampion, 1);
		_location.addTroops(troops.BarbarianBeastmaster, 1);
		_location.addTroops(troops.BarbarianUnhold, 1);

		if (band >= 1) { _location.addTroops(troops.BarbarianMarauder, 1); _location.addTroops(troops.BarbarianChosen, 1); }
		if (band >= 2) { _location.addTroops(troops.BarbarianMarauder, 1); _location.addTroops(troops.BarbarianChosen, 1); }
		if (band >= 3) { _location.addTroops(troops.BarbarianChosen, 1); _location.addTroops(troops.BarbarianUnhold, 1); }
	}
	else if (_stage == 80)
	{
		_location.addTroops(troops.OrcYoung, 5);
		_location.addTroops(troops.OrcWarrior, 3);
		_location.addTroops(troops.OrcBerserker, 2);
		_location.addTroops(troops.OrcWarlord, 1);

		if (band >= 1) { _location.addTroops(troops.OrcYoung, 1); _location.addTroops(troops.OrcWarrior, 1); }
		if (band >= 2) { _location.addTroops(troops.OrcWarrior, 1); _location.addTroops(troops.OrcBerserker, 1); }
		if (band >= 3) { _location.addTroops(troops.OrcYoung, 1); _location.addTroops(troops.OrcWarrior, 1); _location.addTroops(troops.OrcBerserker, 1); }
	}
	else if (_stage == 100)
	{
		_location.addTroops(troops.SkeletonMedium, 4);
		_location.addTroops(troops.SkeletonMediumPolearm, 2);
		_location.addTroops(troops.SkeletonHeavy, 4);
		_location.addTroops(troops.SkeletonHeavyPolearm, 1);
		_location.addTroops(troops.SkeletonPriest, 1);
		_location.addTroops(troops.SkeletonBoss, 1);

		if (band >= 1) { _location.addTroops(troops.SkeletonMedium, 1); _location.addTroops(troops.SkeletonHeavy, 1); }
		if (band >= 2) { _location.addTroops(troops.SkeletonHeavy, 1); _location.addTroops(troops.SkeletonHeavyPolearm, 1); _location.addTroops(troops.SkeletonPriest, 1); }
		if (band >= 3) { _location.addTroops(troops.SkeletonMedium, 1); _location.addTroops(troops.SkeletonHeavy, 2); _location.addTroops(troops.SkeletonPriest, 1); }
	}
};

::$bvvar{namespace}.XilianBondStages <- [
	{
		Value = 20,
		Name = "$bv{event.xilian_bond.20.stage}",
		Title = "$bv{event.xilian_bond.20.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_20_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_20_cg.png",
		Text = "$bv{event.xilian_bond.20.text}",
		RevealText = "$bv{event.xilian_bond.20.reveal}",
		RevealOption = "$bv{event.xilian_bond.20.option}",
		ChallengeText = "$bv{event.xilian_bond.reward.challenge_20}"
	},
	{
		Value = 40,
		Name = "$bv{event.xilian_bond.40.stage}",
		Title = "$bv{event.xilian_bond.40.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_40_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_40_cg.png",
		Text = "$bv{event.xilian_bond.40.text}",
		RevealText = "$bv{event.xilian_bond.40.reveal}",
		RevealOption = "$bv{event.xilian_bond.40.option}",
		ChallengeText = "$bv{event.xilian_bond.reward.challenge_40}"
	},
	{
		Value = 60,
		Name = "$bv{event.xilian_bond.60.stage}",
		Title = "$bv{event.xilian_bond.60.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_60_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_60_cg.png",
		Text = "$bv{event.xilian_bond.60.text}",
		RevealText = "$bv{event.xilian_bond.60.reveal}",
		RevealOption = "$bv{event.xilian_bond.60.option}",
		ChallengeText = "$bv{event.xilian_bond.reward.challenge_60}"
	},
	{
		Value = 80,
		Name = "$bv{event.xilian_bond.80.stage}",
		Title = "$bv{event.xilian_bond.80.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_80_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_80_cg.png",
		Text = "$bv{event.xilian_bond.80.text}",
		RevealText = "$bv{event.xilian_bond.80.reveal}",
		RevealOption = "$bv{event.xilian_bond.80.option}",
		ChallengeText = "$bv{event.xilian_bond.reward.challenge_80}"
	},
	{
		Value = 100,
		Name = "$bv{event.xilian_bond.100.stage}",
		Title = "$bv{event.xilian_bond.100.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_100_intro.png",
		CGImage = "gfx/ui/events/$bvvar{iconPrefix}/xilian_bond_100_cg.png",
		Text = "$bv{event.xilian_bond.100.text}",
		RevealText = "$bv{event.xilian_bond.100.reveal}",
		RevealOption = "$bv{event.xilian_bond.100.option}",
		ChallengeText = "$bv{event.xilian_bond.reward.challenge_100}"
	}
];

::$bvvar{namespace}.getXilianBondStageByValue <- function( _value )
{
	foreach( stage in ::$bvvar{namespace}.XilianBondStages )
	{
		if (stage.Value == _value)
		{
			return stage;
		}
	}

	return null;
};

::$bvvar{namespace}.findXilianBondTrait <- function()
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

		if (::$bvvar{namespace}.getActorValkyrieID(bro) != "xilian")
		{
			continue;
		}

		local trait = bro.getSkills().getSkillByID(::$bvvar{namespace}.XilianBondTraitID);

		if (trait != null)
		{
			return trait;
		}
	}

	return null;
};

::$bvvar{namespace}.getXilianBondPendingStage <- function()
{
	local trait = ::$bvvar{namespace}.findXilianBondTrait();

	if (trait == null || !trait.hasPendingStage())
	{
		return null;
	}

	return ::$bvvar{namespace}.getXilianBondStageByValue(trait.getNextPendingStage());
};

::$bvvar{namespace}.isValidXilianBondChallengeTile <- function( _tile )
{
	return _tile != null
		&& _tile.Type != ::Const.World.TerrainType.Ocean
		&& _tile.Type != ::Const.World.TerrainType.Shore
		&& !_tile.IsOccupied;
};

::$bvvar{namespace}.getXilianBondChallengeSpawnTile <- function( _minDistance = 3, _maxDistance = 8 )
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

			if (distance < _minDistance || distance > _maxDistance || !::$bvvar{namespace}.isValidXilianBondChallengeTile(tile))
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
		return ::$bvvar{namespace}.getXilianBondChallengeSpawnTile(_minDistance, 16);
	}

	return null;
};

::$bvvar{namespace}.getXilianBondChallengeFactionType <- function( _stage )
{
	if (_stage == 20)
	{
		return ::Const.FactionType.Bandits;
	}
	else if (_stage == 40)
	{
		return ::Const.FactionType.Goblins;
	}
	else if (_stage == 60)
	{
		return ::Const.FactionType.Barbarians;
	}
	else if (_stage == 80)
	{
		return ::Const.FactionType.Orcs;
	}

	return ::Const.FactionType.Undead;
};

::$bvvar{namespace}.getXilianBondChallengeFallbackFaction <- function( _stage )
{
	if (_stage == 20)
	{
		return ::Const.Faction.Bandits;
	}
	else if (_stage == 40)
	{
		return ::Const.Faction.Goblins;
	}
	else if (_stage == 60)
	{
		return ::Const.Faction.Barbarians;
	}
	else if (_stage == 80)
	{
		return ::Const.Faction.Orcs;
	}

	return ::Const.Faction.Undead;
};

::$bvvar{namespace}.attachXilianBondChallengeFaction <- function( _location, _stage )
{
	if (_location == null || ::World == null || ::World.FactionManager == null)
	{
		return;
	}

	local faction = ::World.FactionManager.getFactionOfType(::$bvvar{namespace}.getXilianBondChallengeFactionType(_stage));

	if (faction != null)
	{
		faction.addSettlement(_location, false);
	}
	else
	{
		_location.setFaction(::$bvvar{namespace}.getXilianBondChallengeFallbackFaction(_stage));
		_location.updatePlayerRelation();
	}
};

::$bvvar{namespace}.revealXilianBondChallengeLocation <- function( _location )
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
		_location.getFlags().set("BattleValkyriesXilianBondObjective", true);
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

::$bvvar{namespace}.appendXilianBondNamedEquipmentScripts <- function( _result, _source, _seen )
{
	if (_source == null)
	{
		return;
	}

	foreach( script in _source )
	{
		local fullScript = "scripts/items/" + script;

		if (fullScript in _seen)
		{
			continue;
		}

		_seen.rawset(fullScript, true);
		_result.push(fullScript);
	}
};

::$bvvar{namespace}.getXilianBondRandomRedEquipmentScripts <- function()
{
	local result = [];
	local seen = {};
	local listNames = [
		"NamedArmors",
		"NamedHelmets",
		"NamedShields",
		"NamedBanditShields",
		"NamedUndeadShields",
		"NamedOrcShields",
		"NamedSouthernShields",
		"NamedMeleeWeapons",
		"NamedRangedWeapons",
		"NamedOrcWeapons",
		"NamedGoblinWeapons",
		"NamedBarbarianWeapons",
		"NamedBarbarianHelmets",
		"NamedBarbarianArmors",
		"NamedSouthernWeapons",
		"NamedSouthernMeleeWeapons",
		"NamedSouthernHelmets",
		"NamedSouthernArmors",
		"NamedUndeadWeapons"
	];

	foreach( listName in listNames )
	{
		if (listName in ::Const.Items)
		{
			::$bvvar{namespace}.appendXilianBondNamedEquipmentScripts(result, ::Const.Items[listName], seen);
		}
	}

	return result;
};

::$bvvar{namespace}.getXilianBondEquipmentSystem <- function()
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
};

::$bvvar{namespace}.createXilianBondRandomRedEquipment <- function( _stage )
{
	local scripts = ::$bvvar{namespace}.getXilianBondRandomRedEquipmentScripts();

	if (scripts.len() == 0)
	{
		return null;
	}

	local item = ::new(scripts[::Math.rand(0, scripts.len() - 1)]);

	if (item == null)
	{
		return null;
	}

	local equipmentSystem = ::$bvvar{namespace}.getXilianBondEquipmentSystem();

	if (equipmentSystem != null
		&& "initializeEquipmentItem" in equipmentSystem
		&& "isEquipmentSystemEnabled" in equipmentSystem
		&& equipmentSystem.isEquipmentSystemEnabled())
	{
		equipmentSystem.initializeEquipmentItem(item, {
			Rarity = "red",
			Force = true,
			Source = "xilian_bond_stage_" + _stage
		});
	}

	return item;
};

::$bvvar{namespace}.spawnXilianBondChallengeCamp <- function( _stage )
{
	if (!::$bvvar{namespace}.isXilianBondChallengeStage(_stage) || ::World == null)
	{
		return false;
	}

	local trait = ::$bvvar{namespace}.findXilianBondTrait();

	if (trait == null || !trait.hasPendingStageValue(_stage))
	{
		return false;
	}

	local script = ::$bvvar{namespace}.getXilianBondChallengeScript(_stage);
	local tile = ::$bvvar{namespace}.getXilianBondChallengeSpawnTile();

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
		::logWarning("[Battle Valkyries] Xilian challenge camp was discarded because its pending stage could not be marked: " + _stage);
		return false;
	}

	location.onSpawned();
	::$bvvar{namespace}.revealXilianBondChallengeLocation(location);
	return true;
};

::$bvvar{namespace}.grantXilianBondChallengeReward <- function( _stage )
{
	local trait = ::$bvvar{namespace}.findXilianBondTrait();

	if (trait == null)
	{
		return false;
	}

	return trait.completeChallengeStage(_stage);
};

::$bvvar{namespace}.grantXilianBondCombatProgress <- function( _label = "" )
{
	local trait = ::$bvvar{namespace}.findXilianBondTrait();

	if (trait == null)
	{
		return 0;
	}

	return trait.addBond(::$bvvar{namespace}.XilianBondGainPerBattle);
};

::$bvvar{namespace}.requestXilianBondEventCheck <- function()
{
	if (::World == null || !("Events" in ::World) || ::World.Events == null || ::$bvvar{namespace}.getXilianBondPendingStage() == null)
	{
		return false;
	}

	return ::World.Events.updateSpecialEvents();
};

::$bvvar{namespace}.registerValkyrieBondTrait(::$bvvar{namespace}.XilianBondTraitID, ::$bvvar{namespace}.requestXilianBondEventCheck);

::$bvvar{namespace}.MH.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addSpecialEvent(::$bvvar{namespace}.XilianBondEventID);
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		local ret = __original();
		::$bvvar{namespace}.grantXilianBondCombatProgress("world_state.onCombatFinished");
		return ret;
	}
});
