this.tilixibiesi_beyond_warp_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		SelectedTarget = null,
		SelectedTargetID = 0,
		SpentThisTurn = false,
		HitpointFinalCost = 5
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = ["sounds/combat/footwork_01.wav"];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 99;
		this.m.HitpointFinalCost = 5;
	}

	function clearSelectedTarget()
	{
		this.m.SelectedTarget = null;
		this.m.SelectedTargetID = 0;
	}

	function getSelectedTarget()
	{
		if (this.m.SelectedTarget == null || this.m.SelectedTarget.isNull())
		{
			this.clearSelectedTarget();
			return null;
		}

		local target = this.m.SelectedTarget;
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || !target.isPlacedOnMap())
		{
			this.clearSelectedTarget();
			return null;
		}

		return target;
	}

	function hasSelectedTarget()
	{
		return this.getSelectedTarget() != null;
	}

	function getFinalActionPointCost()
	{
		return this.skill.getActionPointCost();
	}

	function getFinalFatigueCost()
	{
		return this.skill.getFatigueCost();
	}

	function getActionPointCost()
	{
		return this.hasSelectedTarget() ? this.getFinalActionPointCost() : 0;
	}

	function getFatigueCost()
	{
		return this.hasSelectedTarget() ? this.getFinalFatigueCost() : 0;
	}

	function canPayFinalCost()
	{
		local actor = this.getContainer().getActor();
		return actor != null
			&& actor.getActionPoints() >= this.getFinalActionPointCost()
			&& actor.getFatigue() + this.getFinalFatigueCost() <= actor.getFatigueMax()
			&& actor.getHitpoints() > this.m.HitpointFinalCost;
	}

	function canPayHitpointCost()
	{
		local actor = this.getContainer().getActor();
		return actor != null && actor.getHitpoints() > this.m.HitpointFinalCost;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.SpentThisTurn && this.canPayFinalCost();
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.cost_prefix}"
					+ this.getFinalActionPointCost()
					+ "$bv{skill.tilixibiesi_beyond_warp.tooltip.cost_middle}"
					+ this.getFinalFatigueCost()
					+ "$bv{skill.tilixibiesi_beyond_warp.tooltip.cost_suffix}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/health.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.hp}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.target}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.destination}"
			}
		];

		local id = 7;
		local target = this.getSelectedTarget();
		if (target != null)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.selected}" + target.getName()
			});
			id = ++id;
		}

		if (this.m.SpentThisTurn)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.spent}"
			});
			id = ++id;
		}
		else if (!this.canPayFinalCost())
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.unavailable}"
			});
		}

		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.hasSelectedTarget() ? this.Const.UI.Cursor.Rotation : this.Const.UI.Cursor.Hand;
	}

	function onTargetSelected( _targetTile )
	{
		// IsRanged lets the native highlighter show the full-map target range; this is not a ranged attack.
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (_targetTile == null || !this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = this.getSelectedTarget();
		if (target == null)
		{
			if (!_targetTile.IsOccupiedByActor)
			{
				return false;
			}

			local entity = _targetTile.getEntity();
			return entity != null && entity.isAttackable() && !::$bvvar{namespace}.isActorDeadOrDying(entity);
		}

		return _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null)
		{
			this.clearSelectedTarget();
			return false;
		}

		local target = this.getSelectedTarget();
		if (target == null)
		{
			if (!_targetTile.IsOccupiedByActor)
			{
				return false;
			}

			target = _targetTile.getEntity();
			if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || !target.isAttackable())
			{
				return false;
			}

			this.m.SelectedTarget = this.WeakTableRef(target);
			this.m.SelectedTargetID = target.getID();
			this.spawnIcon("status_effect_34", target.getTile());
			return true;
		}

		if (!_targetTile.IsEmpty || !this.canPayHitpointCost())
		{
			return false;
		}

		local oldTile = target.getTile();
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		this.Tactical.getNavigator().teleport(target, _targetTile, null, null, false);

		if (oldTile != null)
		{
			this.spawnIcon("status_effect_34", oldTile);
		}

		this.spawnIcon("status_effect_34", _targetTile);
		_user.setHitpoints(this.Math.max(1, _user.getHitpoints() - this.m.HitpointFinalCost));
		_user.setDirty(true);
		target.setDirty(true);
		this.m.SpentThisTurn = true;
		this.clearSelectedTarget();
		return true;
	}

	function onTurnStart()
	{
		this.m.SpentThisTurn = false;
		this.clearSelectedTarget();
	}

	function onTurnEnd()
	{
		this.clearSelectedTarget();
	}

	function onCombatStarted()
	{
		this.m.SpentThisTurn = false;
		this.clearSelectedTarget();
	}

	function onCombatFinished()
	{
		this.m.SpentThisTurn = false;
		this.clearSelectedTarget();
		this.skill.onCombatFinished();
	}
});
