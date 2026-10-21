local isUnavailableValkyrieTargetingObject = function( _value )
{
	if (_value == null) return true;
	if (typeof _value != "instance") return false;
	try
	{
		return _value.isNull();
	}
	catch (e)
	{
		return false;
	}
};

local getValkyrieTargetingObjectID = function( _value )
{
	if (isUnavailableValkyrieTargetingObject(_value)) return null;
	try
	{
		return _value.getID();
	}
	catch (e)
	{
		return null;
	}
};

local getValkyrieTargetingTileID = function( _tile )
{
	if (isUnavailableValkyrieTargetingObject(_tile)) return null;
	try
	{
		return _tile.ID;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getValkyrieHitFactorsWithoutCover <- function( _skill, _targetTile )
{
	// The native factor list gates only its cover warning on IsUsingHitchance.
	// Suppress that warning during this query, preserving all other factors and
	// restoring the real hit-roll flag before any preview or attack can use it.
	local usingHitchance = _skill.m.IsUsingHitchance;
	local ret = null;
	_skill.m.IsUsingHitchance = false;
	try { ret = _skill.skill.getHitFactors.bindenv(_skill)(_targetTile); }
	catch (e)
	{
		_skill.m.IsUsingHitchance = usingHitchance;
		throw e;
	}
	_skill.m.IsUsingHitchance = usingHitchance;
	return ret;
};

::$bvvar{namespace}.getValkyrieSixDirectionLineTiles <- function( _origin, _target )
{
	local ret = [];
	if (isUnavailableValkyrieTargetingObject(_origin) || isUnavailableValkyrieTargetingObject(_target)) return ret;
	local originID = getValkyrieTargetingTileID(_origin);
	local targetID = getValkyrieTargetingTileID(_target);
	if (originID == null || targetID == null || originID == targetID) return ret;

	local distance = 0;
	try
	{
		distance = _origin.getDistanceTo(_target);
	}
	catch (e)
	{
		return ret;
	}
	if (distance <= 0) return ret;

	for (local direction = 0; direction < 6; direction++)
	{
		local line = [];
		local tile = _origin;
		local complete = true;
		for (local step = 0; step < distance; step++)
		{
			if (!tile.hasNextTile(direction))
			{
				complete = false;
				break;
			}
			tile = tile.getNextTile(direction);
			if (isUnavailableValkyrieTargetingObject(tile))
			{
				complete = false;
				break;
			}
			line.push(tile);
		}
		if (complete && line.len() == distance && tile.ID != _target.ID) complete = false;
		if (complete) return line;
	}
	return ret;
};

::$bvvar{namespace}.getValkyrieRadiusTiles <- function( _center, _radius, _includeCenter = true )
{
	local ret = [];
	if (isUnavailableValkyrieTargetingObject(_center) || _radius == null || _radius < 0) return ret;
	local centerID = getValkyrieTargetingTileID(_center);
	if (centerID == null) return ret;

	local visited = {};
	visited[centerID] <- true;
	local queue = [{ Tile = _center, Depth = 0 }];
	local cursor = 0;
	while (cursor < queue.len())
	{
		local entry = queue[cursor];
		cursor++;
		if (entry.Depth > 0 || _includeCenter) ret.push(entry.Tile);
		if (entry.Depth >= _radius) continue;

		for (local direction = 0; direction < 6; direction++)
		{
			if (!entry.Tile.hasNextTile(direction)) continue;
			local next = entry.Tile.getNextTile(direction);
			local nextID = getValkyrieTargetingTileID(next);
			if (nextID == null || nextID in visited) continue;
			visited[nextID] <- true;
			queue.push({ Tile = next, Depth = entry.Depth + 1 });
		}
	}
	return ret;
};

::$bvvar{namespace}.getValkyrieWideLineTiles <- function( _origin, _target, _width = 1 )
{
	local ret = [];
	if (_width == null || _width < 0) return ret;
	local centerLine = ::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(_origin, _target);
	if (centerLine.len() == 0) return ret;
	local targetDistance = centerLine.len();
	local seen = {};
	foreach (centerTile in centerLine)
	{
		foreach (tile in ::$bvvar{namespace}.getValkyrieRadiusTiles(centerTile, _width, true))
		{
			local distance = 0;
			try
			{
				distance = _origin.getDistanceTo(tile);
			}
			catch (e)
			{
				continue;
			}
			if (distance < 1 || distance > targetDistance) continue;
			local tileID = getValkyrieTargetingTileID(tile);
			if (tileID == null || tileID in seen) continue;
			seen[tileID] <- true;
			ret.push(tile);
		}
	}
	return ret;
};

::$bvvar{namespace}.isEligibleValkyrieEnemyTarget <- function( _owner, _target, _maxRange = null, _requireLOS = false )
{
	if (isUnavailableValkyrieTargetingObject(_owner) || isUnavailableValkyrieTargetingObject(_target) || _owner == _target) return false;
	try
	{
		if (!_owner.isPlacedOnMap() || !_owner.isAlive() || _owner.isDying() || _owner.getHitpoints() <= 0) return false;
		if (!_target.isPlacedOnMap() || !_target.isAlive() || _target.isDying() || _target.getHitpoints() <= 0) return false;
		if (!_target.isAttackable() || _owner.isAlliedWith(_target)) return false;
		local originTile = _owner.getTile();
		local targetTile = _target.getTile();
		if (isUnavailableValkyrieTargetingObject(originTile) || isUnavailableValkyrieTargetingObject(targetTile)) return false;
		if (_maxRange != null && (_maxRange < 0 || originTile.getDistanceTo(targetTile) > _maxRange)) return false;
		if (_requireLOS)
		{
			local visibleForEntity = null;
			try { visibleForEntity = targetTile.IsVisibleForEntity; } catch (visibilityError) { visibleForEntity = null; }
			if (visibleForEntity != null)
			{
				if (!visibleForEntity) return false;
			}
			else
			{
				local vision = _owner.getCurrentProperties().getVision();
				if (!originTile.hasLineOfSightTo(targetTile, vision)) return false;
			}
		}
		return true;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles <- function( _owner, _tiles, _options = null )
{
	local ret = [];
	if (isUnavailableValkyrieTargetingObject(_owner) || _tiles == null || typeof _tiles != "array") return ret;
	local stopAtFriendly = _options != null && "StopAtFriendly" in _options && _options.StopAtFriendly;
	local seen = {};
	foreach (tile in _tiles)
	{
		if (isUnavailableValkyrieTargetingObject(tile) || !tile.IsOccupiedByActor) continue;
		local actor = null;
		try
		{
			actor = tile.getEntity();
		}
		catch (e)
		{
			continue;
		}
		if (isUnavailableValkyrieTargetingObject(actor)) continue;
		if (stopAtFriendly)
		{
			local allied = false;
			try { allied = _owner.isAlliedWith(actor); } catch (e) {}
			if (allied) break;
		}
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_owner, actor)) continue;
		local actorID = getValkyrieTargetingObjectID(actor);
		if (actorID == null || actorID in seen) continue;
		seen[actorID] <- true;
		ret.push(actor);
	}
	return ret;
};

::$bvvar{namespace}.sortValkyrieTargetsByDistance <- function( _originTile, _targets, _farthestFirst = false )
{
	local ret = [];
	if (isUnavailableValkyrieTargetingObject(_originTile) || _targets == null || typeof _targets != "array") return ret;
	local snapshots = [];
	foreach (index, target in _targets)
	{
		if (isUnavailableValkyrieTargetingObject(target)) continue;
		try
		{
			snapshots.push({
				Target = target,
				Distance = _originTile.getDistanceTo(target.getTile()),
				ActorID = target.getID(),
				OriginalIndex = index
			});
		}
		catch (e)
		{
		}
	}
	snapshots.sort(function( _a, _b )
	{
		if (_a.Distance != _b.Distance)
		{
			if (_farthestFirst) return _a.Distance > _b.Distance ? -1 : 1;
			return _a.Distance < _b.Distance ? -1 : 1;
		}
		if (_a.ActorID != _b.ActorID) return _a.ActorID < _b.ActorID ? -1 : 1;
		if (_a.OriginalIndex == _b.OriginalIndex) return 0;
		return _a.OriginalIndex < _b.OriginalIndex ? -1 : 1;
	});
	foreach (snapshot in snapshots) ret.push(snapshot.Target);
	return ret;
};

::$bvvar{namespace}.findNearestValkyrieEnemy <- function( _owner, _maxRange, _requireLOS = true, _randomIndexFn = null )
{
	if (isUnavailableValkyrieTargetingObject(_owner) || _maxRange == null || _maxRange <= 0) return null;
	local originTile = null;
	try
	{
		if (!_owner.isPlacedOnMap() || !_owner.isAlive() || _owner.isDying() || _owner.getHitpoints() <= 0) return null;
		originTile = _owner.getTile();
	}
	catch (e)
	{
		return null;
	}
	if (isUnavailableValkyrieTargetingObject(originTile)) return null;

	local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(originTile, _maxRange, true);
	local candidates = ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_owner, tiles);
	local nearestDistance = null;
	local nearest = [];
	foreach (candidate in candidates)
	{
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_owner, candidate, _maxRange, _requireLOS)) continue;
		local distance = originTile.getDistanceTo(candidate.getTile());
		if (nearestDistance == null || distance < nearestDistance)
		{
			nearestDistance = distance;
			nearest = [candidate];
		}
		else if (distance == nearestDistance)
		{
			nearest.push(candidate);
		}
	}
	if (nearest.len() == 0) return null;

	local index = _randomIndexFn == null ? ::Math.rand(0, nearest.len() - 1) : _randomIndexFn(nearest.len());
	if (typeof index != "integer" || index < 0 || index >= nearest.len()) index = 0;
	return nearest[index];
};
