::$bvvar{namespace}.finishInvalidValkyrieDeathState <- function( _actor, _killer = null, _skill = null, _label = "", _removeFromMap = true, _forceDeath = false )
{
	if (_actor == null || !::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor))
	{
		return false;
	}

	local hp = null;

	try
	{
		hp = _actor.getHitpoints();
	}
	catch (e)
	{
		return false;
	}

	if (hp > 0 && !_forceDeath)
	{
		return false;
	}

	if (_forceDeath && hp > 0)
	{
		try
		{
			_actor.setHitpoints(0);
		}
		catch (e)
		{
			try
			{
				_actor.m.Hitpoints = 0;
			}
			catch (ignored)
			{
			}
		}

		hp = 0;
	}

	local alive = false;

	try
	{
		alive = _actor.isAlive();
	}
	catch (e)
	{
		return false;
	}

	local isPlaced = false;
	local deathTile = null;

	try
	{
		isPlaced = _actor.isPlacedOnMap();
		deathTile = isPlaced ? _actor.getTile() : null;
	}
	catch (e)
	{
		isPlaced = false;
		deathTile = null;
	}

	if (!alive && !isPlaced)
	{
		return false;
	}

	local actorName = ::$bvvar{namespace}.getActorNameForDeathDebug(_actor);

	try
	{
		_actor.setActionPoints(0);
		_actor.m.IsTurnDone = true;
		_actor.m.IsDying = true;
		_actor.m.IsAlive = false;
	}
	catch (e)
	{
	}

	try
	{
		::$bvvar{namespace}.prepareValkyrieDeathAppearance(_actor);

		if (_removeFromMap && (isPlaced || _actor.isPlacedOnMap()))
		{
			// A removed actor cannot retain its body sprite. Materialize exactly one
			// corpse detail on the tile before removing it from the tactical map.
			if (deathTile == null)
			{
				try
				{
					deathTile = _actor.getTile();
				}
				catch (e)
				{
				}
			}

			local spawnedCorpse = ::$bvvar{namespace}.spawnValkyrieDeathDecal(_actor, deathTile, "forced-death-state");

			if (!spawnedCorpse)
			{
				::$bvvar{namespace}.log("[DeathFix] Forced death could not materialize a corpse for " + actorName + " before removeFromMap" + (_label == "" ? "" : " label=" + _label));
			}

			_actor.removeFromMap();
		}
		else
		{
			// Some compatibility paths intentionally keep the dead actor placed.
			// In that case use its body layer instead of adding a second tile decal.
			::$bvvar{namespace}.applyValkyrieDeathBrush(_actor, "forced-death-state");
		}

		::$bvvar{namespace}.log("[DeathFix] Forced valkyrie death state for " + actorName + " hp=" + hp + " removeFromMap=" + (_removeFromMap ? "true" : "false") + " forceDeath=" + (_forceDeath ? "true" : "false") + (_label == "" ? "" : " label=" + _label));
		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to force valkyrie death state for " + actorName + ": " + e);
		return false;
	}
};

::$bvvar{namespace}.finishInvalidValkyrieDeathStateSafe <- function( _actor, _killer = null, _skill = null, _label = "", _removeFromMap = true, _forceDeath = false )
{
	try
	{
		return ::$bvvar{namespace}.finishInvalidValkyrieDeathState(_actor, _killer, _skill, _label, _removeFromMap, _forceDeath);
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed safe death fallback for " + ::$bvvar{namespace}.getActorNameForDeathDebug(_actor) + ": " + e);
	}

	return false;
};

::$bvvar{namespace}.getActorForDeathDropItemDebug <- function( _item )
{
	if (_item == null || _item == -1)
	{
		return null;
	}

	local container = null;

	try
	{
		container = _item.getContainer();
	}
	catch (e)
	{
		return null;
	}

	if (container == null)
	{
		return null;
	}

	try
	{
		local actorRef = container.getActor();

		if (actorRef == null || actorRef.isNull())
		{
			return null;
		}

		return actorRef.get();
	}
	catch (e)
	{
	}

	return null;
};

::$bvvar{namespace}.getDeathDropTileDebugText <- function( _tile )
{
	if (_tile == null)
	{
		return "null";
	}

	local text = "tile";

	try
	{
		text = text + "=" + _tile.SquareCoords.X + "," + _tile.SquareCoords.Y;
	}
	catch (e)
	{
		text = text + "=?";
	}

	try
	{
		text = text + " items=" + _tile.Items.len();
	}
	catch (e)
	{
		text = text + " items=?";
	}

	try
	{
		text = text + " containing=" + ::$bvvar{namespace}.skinDebugValue(_tile.IsContainingItems);
	}
	catch (e)
	{
	}

	return text;
};

::$bvvar{namespace}.getDeathDropItemDebugText <- function( _item, _tile = null, _actor = null )
{
	local itemID = "?";
	local itemName = "?";
	local instanceID = "?";
	local slotType = "?";
	local currentSlot = "?";
	local isDropped = "?";
	local isChangeable = "?";
	local isAllowedInBag = "?";
	local isSkinItem = "?";

	try
	{
		itemID = _item.getID();
	}
	catch (e)
	{
	}

	try
	{
		itemName = _item.getName();
	}
	catch (e)
	{
	}

	try
	{
		instanceID = _item.getInstanceID();
	}
	catch (e)
	{
	}

	try
	{
		slotType = _item.getSlotType();
	}
	catch (e)
	{
	}

	try
	{
		currentSlot = _item.getCurrentSlotType();
	}
	catch (e)
	{
	}

	try
	{
		isDropped = _item.isDroppedAsLoot();
	}
	catch (e)
	{
	}

	try
	{
		isChangeable = _item.isChangeableInBattle();
	}
	catch (e)
	{
	}

	try
	{
		isAllowedInBag = _item.isAllowedInBag();
	}
	catch (e)
	{
	}

	try
	{
		isSkinItem = ::$bvvar{namespace}.isValkyrieSkinItem(_item);
	}
	catch (e)
	{
	}

	if (_actor == null)
	{
		_actor = ::$bvvar{namespace}.getActorForDeathDropItemDebug(_item);
	}

	local actorName = _actor == null ? "null" : ::$bvvar{namespace}.getActorNameForDeathDebug(_actor);
	local hp = "?";
	local alive = "?";
	local dying = "?";

	if (_actor != null)
	{
		try
		{
			hp = _actor.getHitpoints();
		}
		catch (e)
		{
		}

		try
		{
			alive = _actor.isAlive();
		}
		catch (e)
		{
		}

		try
		{
			dying = _actor.isDying();
		}
		catch (e)
		{
		}
	}

	return "actor=" + actorName
		+ " hp=" + hp
		+ " alive=" + ::$bvvar{namespace}.skinDebugValue(alive)
		+ " dying=" + ::$bvvar{namespace}.skinDebugValue(dying)
		+ " itemID=" + itemID
		+ " itemName=" + itemName
		+ " instance=" + instanceID
		+ " currentSlot=" + currentSlot
		+ " slotType=" + slotType
		+ " droppedAsLoot=" + ::$bvvar{namespace}.skinDebugValue(isDropped)
		+ " changeable=" + ::$bvvar{namespace}.skinDebugValue(isChangeable)
		+ " allowedInBag=" + ::$bvvar{namespace}.skinDebugValue(isAllowedInBag)
		+ " skinItem=" + ::$bvvar{namespace}.skinDebugValue(isSkinItem)
		+ " " + ::$bvvar{namespace}.getDeathDropTileDebugText(_tile);
};

::$bvvar{namespace}.logValkyrieDeathDropPreview <- function( _actor, _killer, _tile, _label = "", _force = false )
{
	if (_actor == null || (!_force && !::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor)))
	{
		return;
	}

	local label = _label == "" ? "preview" : _label;

	try
	{
		local deathLoot = _actor.getItems().getDroppableLoot(_killer);
		local tileLoot = _actor.getLootForTile(_killer, deathLoot);
		local deathLootCount = deathLoot == null ? 0 : deathLoot.len();
		local tileLootCount = tileLoot == null ? 0 : tileLoot.len();

		::$bvvar{namespace}.log("[DeathDrop] " + label + ".preview actor=" + ::$bvvar{namespace}.getActorNameForDeathDebug(_actor) + " deathLoot=" + deathLootCount + " tileLoot=" + tileLootCount + " " + ::$bvvar{namespace}.getDeathDropTileDebugText(_tile));

		if (deathLoot != null)
		{
			foreach( i, item in deathLoot )
			{
				::$bvvar{namespace}.log("[DeathDrop] " + label + ".deathLoot index=" + i + " " + ::$bvvar{namespace}.getDeathDropItemDebugText(item, _tile, _actor));
			}
		}

		if (tileLoot != null && tileLoot != deathLoot)
		{
			foreach( i, item in tileLoot )
			{
				::$bvvar{namespace}.log("[DeathDrop] " + label + ".tileLoot index=" + i + " " + ::$bvvar{namespace}.getDeathDropItemDebugText(item, _tile, _actor));
			}
		}
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathDrop] " + label + ".preview failed for " + ::$bvvar{namespace}.getActorNameForDeathDebug(_actor) + ": " + e);
	}
};

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.dropLoot = @(__original) function( _tile, _loot, _flip = false )
	{
		if (::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(this))
		{
			local count = _loot == null ? 0 : _loot.len();
			::$bvvar{namespace}.log("[DeathDrop] actor.dropLoot.begin actor=" + ::$bvvar{namespace}.getActorNameForDeathDebug(this) + " count=" + count + " flip=" + ::$bvvar{namespace}.skinDebugValue(_flip) + " " + ::$bvvar{namespace}.getDeathDropTileDebugText(_tile));

			if (_loot != null)
			{
				foreach( i, item in _loot )
				{
					::$bvvar{namespace}.log("[DeathDrop] actor.dropLoot.item index=" + i + " " + ::$bvvar{namespace}.getDeathDropItemDebugText(item, _tile, this));
				}
			}
		}

		return __original(_tile, _loot, _flip);
	}

	q.onAfterDeath = @(__original) function( _tile )
	{
		local ret = null;

		try
		{
			ret = __original(_tile);
		}
		catch (e)
		{
			// Preserve the original exception, but queue the visual first so a later
			// compatibility wrapper cannot leave an otherwise completed death blank.
			::$bvvar{namespace}.scheduleQueuedValkyrieDeathDecal(this, _tile);
			throw e;
		}

		::$bvvar{namespace}.scheduleQueuedValkyrieDeathDecal(this, _tile);
		return ret;
	}

	q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill )
	{
		if (_victim != null && ::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_victim))
		{
			local victimIsPlaced = false;

			try
			{
				victimIsPlaced = _victim.isPlacedOnMap();
			}
			catch (e)
			{
			}

			if (!victimIsPlaced)
			{
				// SHS Sellswords calculates morale distance with _victim.getTile().
				// A failed foreign death wrapper may have removed the Valkyrie before
				// actor.kill completes its broadcast, so there is no valid distance
				// to process and delegating would terminate the game in native code.
				::$bvvar{namespace}.log("[DeathFix] Skipped death broadcast for unplaced valkyrie victim " + ::$bvvar{namespace}.getActorNameForDeathDebug(_victim));
				return;
			}
		}

		return __original(_killer, _victim, _skill);
	}

	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		local ret = 0;

		try
		{
			ret = __original(_attacker, _skill, _hitInfo);
		}
		catch (e)
		{
			if (::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(this))
			{
				::$bvvar{namespace}.log("[DeathFix] Suppressed valkyrie damage/death error for " + ::$bvvar{namespace}.getActorNameForDeathDebug(this) + ": " + e);
				::$bvvar{namespace}.finishInvalidValkyrieDeathStateSafe(this, _attacker, _skill, "actor.onDamageReceived.catch");
				return ret;
			}

			throw e;
		}

		::$bvvar{namespace}.finishInvalidValkyrieDeathStateSafe(this, _attacker, _skill, "actor.onDamageReceived.afterOriginal");
		return ret;
	}
});

::$bvvar{namespace}.MH.hookTree("scripts/items/item", function(q) {
	q.drop = @(__original) function( _tile = null )
	{
		local actor = ::$bvvar{namespace}.getActorForDeathDropItemDebug(this);

		if (actor != null && ::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(actor))
		{
			::$bvvar{namespace}.log("[DeathDrop] item.drop.before " + ::$bvvar{namespace}.getDeathDropItemDebugText(this, _tile, actor));
		}

		return __original(_tile);
	}
});
