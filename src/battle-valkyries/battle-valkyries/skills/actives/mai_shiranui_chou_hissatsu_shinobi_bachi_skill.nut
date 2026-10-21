this.mai_shiranui_chou_hissatsu_shinobi_bachi_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false,
		PendingCharge = null
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc2/lunge_move_01.wav",
			"sounds/combat/dlc2/lunge_move_02.wav",
			"sounds/combat/dlc2/lunge_move_03.wav"
		];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsSpearwallRelevant = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
		this.m.IsSpent = false;
		this.m.PendingCharge = null;
	}

	function getOwner()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function hasMeleeWeapon( _actor )
	{
		local weapon = null;
		try { weapon = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isRooted( _actor )
	{
		try { return _actor.getCurrentProperties().IsRooted; } catch (e) { return true; }
	}

	function isInEnemyZoneOfControl( _actor )
	{
		try { return _actor.getTile().hasZoneOfControlOtherThan(_actor.getAlliedFactions()); } catch (e) { return true; }
	}

	function isUsable()
	{
		local owner = this.getOwner();
		return this.skill.isUsable() && !this.m.IsSpent && this.m.PendingCharge == null
			&& owner != null && !::$bvvar{namespace}.isActorDeadOrDying(owner)
			&& this.hasMeleeWeapon(owner) && !this.isRooted(owner) && !this.isInEnemyZoneOfControl(owner);
	}

	function isValidChargeTarget( _user, _target )
	{
		if (_user == null || _target == null || !::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, _target, this.m.MaxRange, true))
		{
			return false;
		}
		local distance = _user.getTile().getDistanceTo(_target.getTile());
		return distance >= this.m.MinRange && distance <= this.m.MaxRange;
	}

	function getChargeRouteTiles( _originTile, _destinationTile )
	{
		local ret = [];
		if (_originTile == null || _destinationTile == null) return ret;
		local distance = _originTile.getDistanceTo(_destinationTile);
		if (distance <= 0) return ret;

		local dx = (_destinationTile.Pos.X - _originTile.Pos.X) / distance;
		local dy = (_destinationTile.Pos.Y - _originTile.Pos.Y) / distance;
		local seen = {};
		for (local step = 1; step <= distance; step++)
		{
			local world = this.createVec(_originTile.Pos.X + dx * step, _originTile.Pos.Y + dy * step);
			local coords = this.Tactical.worldToTile(world);
			if (!this.Tactical.isValidTile(coords.X, coords.Y)) return [];
			local tile = this.Tactical.getTile(coords);
			if (tile == null) return [];
			if (!(tile.ID in seen))
			{
				seen[tile.ID] <- true;
				ret.push(tile);
			}
		}

		return ret.len() > 0 && ret[ret.len() - 1].ID == _destinationTile.ID ? ret : [];
	}

	function isChargeRouteValid( _user, _destinationTile )
	{
		if (_user == null || _destinationTile == null || !_destinationTile.IsEmpty) return false;
		local previous = _user.getTile();
		local route = this.getChargeRouteTiles(previous, _destinationTile);
		if (route.len() == 0) return false;

		foreach (tile in route)
		{
			if (!tile.IsEmpty || this.Math.abs(tile.Level - previous.Level) > 1) return false;
			local isDestination = tile.ID == _destinationTile.ID;
			if (!isDestination && tile.hasZoneOfControlOtherThan(_user.getAlliedFactions())) return false;
			previous = tile;
		}
		return true;
	}

	function getDirectionDifference( _a, _b )
	{
		local diff = this.Math.abs(_a - _b);
		return this.Math.min(diff, 6 - diff);
	}

	function resolveChargeDestination( _user, _target )
	{
		if (!this.isValidChargeTarget(_user, _target)) return null;
		local origin = _user.getTile();
		local targetTile = _target.getTile();
		local preferredDirection = targetTile.getDirectionTo(origin);
		local best = null;

		for (local direction = 0; direction < 6; direction++)
		{
			if (!targetTile.hasNextTile(direction)) continue;
			local tile = targetTile.getNextTile(direction);
			if (!tile.IsEmpty || this.Math.abs(tile.Level - targetTile.Level) > 1 || !this.isChargeRouteValid(_user, tile)) continue;
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
		if (owner == null || this.m.IsSpent || this.m.PendingCharge != null || !this.hasMeleeWeapon(owner)
			|| this.isRooted(owner) || this.isInEnemyZoneOfControl(owner)) return false;
		local target = _targetTile.getEntity();
		return this.resolveChargeDestination(owner, target) != null;
	}

	function onTargetSelected( _targetTile )
	{
		if (_targetTile == null || !_targetTile.IsOccupiedByActor) return;
		local destination = this.resolveChargeDestination(this.getOwner(), _targetTile.getEntity());
		if (destination != null)
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, destination, destination.Pos.X, destination.Pos.Y);
		}
	}

	function releaseBusy()
	{
		try { if (this.getContainer() != null) this.getContainer().setBusy(false); } catch (e) {}
	}

	function addOrRefreshFlameDance( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || _user.getSkills() == null) return null;
		local existing = _user.getSkills().getSkillByID("$bvvar{modId}.effects.mai_shiranui_flame_dance");
		if (existing != null)
		{
			existing.onRefresh();
			return existing;
		}
		local effect = this.new("$bvvar{privateFolder}/skills/effects/mai_shiranui_flame_dance_effect");
		if (effect != null) _user.getSkills().add(effect);
		return effect;
	}

	function resolvePendingTarget( _tag )
	{
		local target = _tag == null ? null : ::$bvvar{namespace}.readValkyrieCombatWeakRef(_tag.TargetRef);
		return target != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(target) == _tag.TargetID ? target : null;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		local destination = this.resolveChargeDestination(_user, target);
		if (destination == null) return false;

		local tag = {
			Skill = this,
			UserRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_user),
			UserID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_user),
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(target),
			OldTile = _user.getTile(),
			DestinationTile = destination,
			DestinationID = destination.ID
		};
		this.m.IsSpent = true;
		this.m.PendingCharge = tag;
		this.getContainer().setBusy(true);
		_user.spawnTerrainDropdownEffect(_user.getTile());
		try
		{
			this.Tactical.getNavigator().teleport(_user, destination, this.onTeleportDone.bindenv(this), tag, false, 3.0);
		}
		catch (e)
		{
			this.releaseBusy();
			this.m.PendingCharge = null;
			this.m.IsSpent = false;
			throw e;
		}
		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		if (this.m.PendingCharge != _tag) return;
		this.releaseBusy();
		this.m.PendingCharge = null;
		if (_entity == null || ::$bvvar{namespace}.getValkyrieCombatObjectID(_entity) != _tag.UserID
			|| ::$bvvar{namespace}.isActorDeadOrDying(_entity) || !_entity.isPlacedOnMap()
			|| _entity.getTile().ID != _tag.DestinationID)
		{
			return;
		}

		local target = this.resolvePendingTarget(_tag);
		if (target != null && !::$bvvar{namespace}.isActorDeadOrDying(target) && target.isPlacedOnMap()
			&& !_entity.isAlliedWith(target) && _entity.getTile().getDistanceTo(target.getTile()) == 1)
		{
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_entity, this, target, {
				WeaponDamageMult = 1.0,
				ArmorDamageMult = 1.0,
				DirectDamageAdd = 0.0,
				HitChance = 10,
				IgnoreDistance = true,
				IgnoreShield = false,
				Source = "mai_shiranui_charge"
			});
			if (result != null && "Hit" in result && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target)
				&& this.Math.rand(1, 100) <= 80)
			{
				::$bvvar{namespace}.addOrRefreshStatus(_entity, target, { Type = "stunned", Turns = 1 });
			}
		}

		if (!::$bvvar{namespace}.isActorDeadOrDying(_entity))
		{
			this.addOrRefreshFlameDance(_entity);
			try { this.spawnIcon("status_effect_34", _entity.getTile()); } catch (e) {}
		}
	}

	function resetCombatState()
	{
		if (this.m.PendingCharge != null) this.releaseBusy();
		this.m.IsSpent = false;
		this.m.PendingCharge = null;
	}

	function onCombatStarted() { this.resetCombatState(); }
	function onCombatFinished()
	{
		this.resetCombatState();
		this.skill.onCombatFinished();
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.cost}" },
			{ id = 5, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.attack}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.stun}" },
			{ id = 7, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.buff}" },
			{ id = 8, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.path}" }
		];
		local owner = this.getOwner();
		if (this.m.IsSpent) ret.push({ id = 9, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.spent}" });
		else if (owner != null && !this.hasMeleeWeapon(owner)) ret.push({ id = 9, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.weapon_required}" });
		else if (owner != null && this.isRooted(owner)) ret.push({ id = 9, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.rooted}" });
		else if (owner != null && this.isInEnemyZoneOfControl(owner)) ret.push({ id = 9, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.mai_shiranui_chou_hissatsu_shinobi_bachi.tooltip.zoc}" });
		return ret;
	}
});
