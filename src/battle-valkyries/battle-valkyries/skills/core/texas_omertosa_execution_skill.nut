this.texas_omertosa_execution_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { PendingCutIn = null },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
	}

	function getOwner()
	{
		local container = this.getContainer();
		return container == null ? null : container.getActor();
	}

	function getTradition()
	{
		local owner = this.getOwner();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "texas_omertosa_tradition");
	}

	function hasMeleeWeapon()
	{
		local owner = this.getOwner();
		local weapon = null;
		try { weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isUsable()
	{
		local tradition = this.getTradition();
		return this.m.PendingCutIn == null && this.skill.isUsable() && this.hasMeleeWeapon() && tradition != null && tradition.isCutInReady();
	}

	function getDirectionDifference( _a, _b )
	{
		local diff = this.Math.abs(_a - _b);
		return this.Math.min(diff, 6 - diff);
	}

	function resolveCutInDestination( _user, _target )
	{
		if (_user == null || _target == null || !::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, _target, this.m.MaxRange, true)) return null;
		local origin = _user.getTile();
		local targetTile = _target.getTile();
		if (origin.getDistanceTo(targetTile) == 1) return origin;
		local preferredDirection = targetTile.getDirectionTo(origin);
		local best = null;
		for (local direction = 0; direction < 6; direction++)
		{
			if (!targetTile.hasNextTile(direction)) continue;
			local tile = targetTile.getNextTile(direction);
			if (!tile.IsEmpty || this.Math.abs(tile.Level - targetTile.Level) > 1) continue;
			local candidate = {
				Tile = tile,
				Distance = origin.getDistanceTo(tile),
				DirectionDifference = this.getDirectionDifference(direction, preferredDirection),
				TileID = tile.ID
			};
			if (best == null || candidate.Distance < best.Distance
				|| candidate.Distance == best.Distance && candidate.DirectionDifference < best.DirectionDifference
				|| candidate.Distance == best.Distance && candidate.DirectionDifference == best.DirectionDifference && candidate.TileID < best.TileID)
			{
				best = candidate;
			}
		}
		return best == null ? null : best.Tile;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getOwner();
		local tradition = this.getTradition();
		return owner != null && tradition != null && tradition.isCutInReady() && this.hasMeleeWeapon()
			&& this.resolveCutInDestination(owner, _targetTile.getEntity()) != null;
	}

	function onTargetSelected( _targetTile )
	{
		if (_targetTile == null || !_targetTile.IsOccupiedByActor) return;
		local destination = this.resolveCutInDestination(this.getOwner(), _targetTile.getEntity());
		if (destination != null)
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, destination, destination.Pos.X, destination.Pos.Y);
		}
	}

	function canResolveCutIn(_user)
	{
		return _user != null && !::$bvvar{namespace}.isActorDeadOrDying(_user) && _user.isPlacedOnMap()
			&& _user.getCurrentProperties().IsAbleToUseSkills && !_user.getCurrentProperties().IsStunned && this.hasMeleeWeapon();
	}
	function cancelCutIn()
	{
		local tag = this.m.PendingCutIn;
		this.m.PendingCutIn = null;
		if (tag != null) ::$bvvar{namespace}.endValkyrieMovement(tag.Hold);
	}
	function onCutInArrived(_user, _tag)
	{
		if (this.m.PendingCutIn != _tag || _tag.Queued) return;
		_tag.Queued = true;
		::$bvvar{namespace}.queueValkyrieMovementArrival(_tag.Hold, this.resolveCutInArrival.bindenv(this), _tag);
	}
	function resolveCutInArrival(_user, _tag)
	{
		if (this.m.PendingCutIn != _tag) return;
		try
		{
			if (!this.isGarbage() && this.canResolveCutIn(_user) && _user.getTile().ID == _tag.Destination.ID)
			{
				_user.spawnTerrainDropdownEffect(_user.getTile());
				this.executeEntry(_user);
			}
		}
		catch (e) { this.cancelCutIn(); throw e; }
		this.cancelCutIn();
	}
	function performCutIn( _user, _target, _mode )
	{
		local destination = this.resolveCutInDestination(_user, _target);
		local tradition = this.getTradition();
		if (destination == null || this.m.PendingCutIn != null || tradition == null || !tradition.isCutInReady() || !this.canResolveCutIn(_user)) return false;
		local tag = { Destination=destination, Hold=null, Queued=false };
		tag.Hold = ::$bvvar{namespace}.beginValkyrieMovement(_user, this.cancelCutIn.bindenv(this));
		if (tag.Hold == null) return false;
		this.m.PendingCutIn = tag;
		if (!tradition.consumeCutIn(_mode)) { this.cancelCutIn(); return false; }
		try
		{
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "texas_cut_in");
		if (destination.ID != _user.getTile().ID)
		{
			_user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			this.Tactical.getNavigator().teleport(_user, destination, this.onCutInArrived.bindenv(this), tag, false);
		}
		else this.resolveCutInArrival(_user, tag);
		}
		catch (e) { this.cancelCutIn(); throw e; }
		return true;
	}
	function onDeath(_fatalityType) { this.cancelCutIn(); }
	function onRemoved() { this.cancelCutIn(); }
	function onCombatStarted() { this.cancelCutIn(); }
	function onCombatFinished() { this.cancelCutIn(); this.skill.onCombatFinished(); }

	function getAdjacentEnemies( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || !_user.isPlacedOnMap()) return [];
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(), 1, true));
	}
});
