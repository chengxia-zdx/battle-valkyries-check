this.cerydra_command_turn_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = 0,
		ShouldRestoreNormalTurn = false,
		DidApplyStart = false,
		DidScheduleRestore = false,
		IsCommandPhase = true
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		this.m.ID = "$bvvar{modId}.effects.cerydra_command_turn";
		this.m.Name = "$bv{effect.cerydra_command_turn.name}";
		this.m.Description = "$bv{effect.cerydra_command_turn.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cerydra_checkmate_command.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cerydra_checkmate_command_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function setupCommand( _owner, _shouldRestoreNormalTurn )
	{
		this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner);
		this.m.OwnerID = _owner == null ? 0 : _owner.getID();
		this.m.ShouldRestoreNormalTurn = _shouldRestoreNormalTurn;
	}

	function getOwner()
	{
		if (this.m.Owner == null || this.m.Owner.isNull())
		{
			return null;
		}

		local owner = this.m.Owner;
		return ::$bvvar{namespace}.isActorDeadOrDying(owner) ? null : owner;
	}

	function onUpdate( _properties )
	{
		if (this.m.IsCommandPhase)
		{
			_properties.DamageTotalMult *= 1.15;
		}
	}

	function applyCommandStart()
	{
		if (!this.m.IsCommandPhase || this.m.DidApplyStart)
		{
			return;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return;
		}

		this.m.DidApplyStart = true;
		actor.setActionPoints(actor.getActionPointsMax());
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - 15));
		actor.setDirty(true);

		if (actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}
	}

	function onTurnStart()
	{
		this.applyCommandStart();
	}

	function onResumeTurn()
	{
		this.applyCommandStart();
	}

	function addCommandExhaustion( _actor )
	{
		if (_actor == null || _actor.getSkills() == null || _actor.getSkills().hasSkill(::$bvvar{namespace}.CerydraCommandExhaustedID))
		{
			return;
		}

		local exhausted = ::new("$bvvar{privateFolder}/skills/effects/cerydra_command_exhausted_effect");
		_actor.getSkills().add(exhausted);
	}

	function onTurnEnd()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (this.m.IsCommandPhase)
		{
			this.m.IsCommandPhase = false;

			if (actor != null && this.m.ShouldRestoreNormalTurn && !this.m.DidScheduleRestore)
			{
				this.m.DidScheduleRestore = true;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function( _tag )
				{
					::$bvvar{namespace}.restoreCerydraNormalTurn(_tag.Target);
				}, {
					Target = actor
				});
			}

			return;
		}

		local owner = this.getOwner();
		local passive = owner == null ? null : ::$bvvar{namespace}.getCerydraWarBannerSkill(owner);
		if (passive != null && actor != null)
		{
			passive.downgradePeerageToMerit(actor);
		}

		this.addCommandExhaustion(actor);
		this.removeSelf();
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
			}
		];

		if (this.m.IsCommandPhase)
		{
			ret.push({
				id = 3,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{effect.cerydra_command_turn.tooltip.ap}"
			});
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{effect.cerydra_command_turn.tooltip.damage}"
			});
		}
		else
		{
			ret.push({
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.cerydra_command_turn.tooltip.followup}"
			});
		}

		return ret;
	}
});
