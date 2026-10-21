this.cipher_name_your_price_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = ["sounds/combat/throw_net_01.wav"];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 10;
		this.m.MinRange = 0;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 99;
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function assignOldPatron( _target )
	{
		return ::$bvvar{namespace}.assignCipherOldPatron(this.getActor(), _target);
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
				text = "$bv{skill.cipher_name_your_price.tooltip.cost}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cipher_name_your_price.tooltip.target}"
			}
		];

		local actor = this.getActor();
		local record = ::$bvvar{namespace}.getCipherOldPatronRecord(actor);

		if (record != null && record.Actor != null)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cipher_name_your_price.tooltip.current}" + record.Actor.getName()
			});
		}
		else
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cipher_name_your_price.tooltip.no_target}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (_targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local actor = this.getActor();
		local target = _targetTile.getEntity();
		return actor != null
			&& target != null
			&& !target.isAlliedWith(actor)
			&& target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target);
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		local effect = this.assignOldPatron(target);

		if (effect == null)
		{
			return false;
		}

		return true;
	}
});
