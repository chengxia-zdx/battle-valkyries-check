this.cerydra_checkmate_command_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = ["sounds/combat/footwork_01.wav"];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function getPassive()
	{
		return ::$bvvar{namespace}.getCerydraWarBannerSkill(this.getActor());
	}

	function grantCommandTurn( _user, _target )
	{
		return ::$bvvar{namespace}.grantCerydraCommandTurn(_user, _target);
	}

	function isPeerageTargetInRange( _record )
	{
		local actor = this.getActor();
		return actor != null && actor.isPlacedOnMap()
			&& _record != null && _record.Actor != null && _record.Actor.isPlacedOnMap()
			&& actor.getTile().getDistanceTo(_record.Actor.getTile()) <= this.getMaxRange();
	}

	function isUsable()
	{
		local passive = this.getPassive();
		local record = passive == null ? null : passive.getPeerageRecord();
		return this.skill.isUsable()
			&& passive != null
			&& passive.hasFullEdict()
			&& record != null
			&& this.isPeerageTargetInRange(record)
			&& passive.canUseCommandThisRound();
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.turn}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.bonus}"
			}
		];

		local passive = this.getPassive();
		local record = passive == null ? null : passive.getPeerageRecord();
		local hasFullEdict = passive != null && passive.hasFullEdict();
		local inRange = this.isPeerageTargetInRange(record);
		local canUseThisRound = passive != null && passive.canUseCommandThisRound();

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{skill.cerydra_checkmate_command.tooltip.edict_prefix}"
				+ (passive == null ? 0 : passive.getEdict()) + "/4"
				+ "$bv{skill.cerydra_checkmate_command.tooltip.edict_suffix}"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "$bv{skill.cerydra_checkmate_command.tooltip.range}"
		});

		local id = 8;
		if (!hasFullEdict)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.no_edict}"
			});
			id = ++id;
		}
		if (record == null)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.no_peerage}"
			});
			id = ++id;
		}
		if (record != null && !inRange)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.out_of_range}"
			});
			id = ++id;
		}
		if (!canUseThisRound)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.round_limit}"
			});
			id = ++id;
		}
		if (hasFullEdict && record != null && inRange && canUseThisRound)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cerydra_checkmate_command.tooltip.current}" + record.Actor.getName()
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local actor = this.getActor();
		local target = _targetTile.getEntity();
		local passive = this.getPassive();
		local record = passive == null ? null : passive.getPeerageRecord();

		return actor != null
			&& target != null
			&& actor != target
			&& target.isAlliedWith(actor)
			&& target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target)
			&& record != null
			&& record.Actor == target
			&& !target.getSkills().hasSkill(::$bvvar{namespace}.CerydraCommandExhaustedID);
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		local passive = this.getPassive();

		if (passive == null || target == null || !passive.hasFullEdict() || !passive.canUseCommandThisRound())
		{
			return false;
		}

		if (!this.grantCommandTurn(_user, target))
		{
			return false;
		}

		passive.markCommandUsed();
		if ("consumeRoyalTideGrowth" in ::$bvvar{namespace}) ::$bvvar{namespace}.consumeRoyalTideGrowth(_user, "cerydra");
		return true;
	}
});
