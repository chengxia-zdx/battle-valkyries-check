this.cipher_moonlit_heist_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		SpentThisTurn = false
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
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.SpentThisTurn;
	}

	function refreshMoonlitHeist()
	{
		this.m.SpentThisTurn = false;
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
				text = "$bv{skill.cipher_moonlit_heist.tooltip.cost}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cipher_moonlit_heist.tooltip.target}"
			}
		];

		if (this.m.SpentThisTurn)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cipher_moonlit_heist.tooltip.spent}"
			});
		}
		else if (!this.skill.isUsable())
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cipher_moonlit_heist.tooltip.unavailable}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return _targetTile != null && this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsEmpty)
		{
			return false;
		}

		local oldTile = _user.getTile();
		_user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		this.Tactical.getNavigator().teleport(_user, _targetTile, null, null, false);

		if (oldTile != null)
		{
			this.spawnIcon("status_effect_53", oldTile);
		}

		this.spawnIcon("status_effect_53", _targetTile);
		this.m.SpentThisTurn = true;
		_user.setDirty(true);
		return true;
	}

	function onTurnStart()
	{
		this.m.SpentThisTurn = false;
	}

	function onCombatStarted()
	{
		this.m.SpentThisTurn = false;
	}

	function onCombatFinished()
	{
		this.m.SpentThisTurn = false;
		this.skill.onCombatFinished();
	}
});
