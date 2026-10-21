this.cerydra_promote_pawn_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = ["sounds/combat/first_aid_01.wav"];
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 10;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 12;
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
				icon = "ui/icons/special.png",
				text = "$bv{skill.cerydra_promote_pawn.tooltip.target}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.cerydra_promote_pawn.tooltip.merit}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.cerydra_promote_pawn.tooltip.reset}"
			}
		];

		local passive = this.getPassive();
		local record = passive == null ? null : passive.getMilitaryRecord();

		if (record != null && record.Actor != null)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cerydra_promote_pawn.tooltip.current}" + record.Actor.getName()
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
		return actor != null
			&& target != null
			&& actor != target
			&& target.isAlliedWith(actor)
			&& target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target);
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local passive = this.getPassive();
		local target = _targetTile.getEntity();

		if (passive == null || !passive.assignMilitaryMerit(target))
		{
			return false;
		}

		return true;
	}
});
