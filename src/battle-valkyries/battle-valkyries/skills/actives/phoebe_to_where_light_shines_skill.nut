this.phoebe_to_where_light_shines_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.SoundOnUse = ["sounds/combat/dlc6/daze_bomb_01.wav", "sounds/combat/dlc6/daze_bomb_02.wav"];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true)
			&& owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function getTargetAreaTiles( _targetTile )
	{
		return _targetTile == null ? [] : ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true);
	}

	function onTargetSelected( _targetTile )
	{
		foreach (tile in this.getTargetAreaTiles(_targetTile))
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || _targetTile == null || !_targetTile.IsOccupiedByActor || !this.onVerifyTarget(_user.getTile(), _targetTile))
		{
			return false;
		}

		local primary = _targetTile.getEntity();
		::$bvvar{namespace}.addOrRefreshStatus(_user, primary, { Type = "dazed", Turns = 1 });

		local adjacentTiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, false);
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, adjacentTiles))
		{
			::$bvvar{namespace}.addOrRefreshStatus(_user, target, { Type = "staggered", Turns = 1 });
		}

		return true;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.phoebe_to_where_light_shines.tooltip.primary}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.phoebe_to_where_light_shines.tooltip.area}" },
			{ id = 6, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.phoebe_to_where_light_shines.tooltip.rules}" }
		];
	}
});
