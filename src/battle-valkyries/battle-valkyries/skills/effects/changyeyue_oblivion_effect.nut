this.changyeyue_oblivion_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		TurnsLeft = 3,
		LastFollowupRound = -1,
		ActionPointsReduced = false
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.changyeyue_oblivion";
		this.m.Name = "$bv{effect.changyeyue_oblivion.name}";
		this.m.Description = "$bv{effect.changyeyue_oblivion.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/changyeyue_oblivion.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/changyeyue_oblivion_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function getName()
	{
		return this.m.Name + " (" + this.m.TurnsLeft + ")";
	}

	function getTooltip()
	{
		return [
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
				icon = "ui/icons/regular_damage.png",
				text = "$bv{effect.changyeyue_oblivion.tooltip.damage}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{effect.changyeyue_oblivion.tooltip.stats}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{effect.changyeyue_oblivion.tooltip.ap}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.changyeyue_oblivion.tooltip.disarm}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{effect.changyeyue_oblivion.tooltip.followup}"
			}
		];
	}

	function getCurrentRound()
	{
		try
		{
			return this.Time.getRound();
		}
		catch (e)
		{
			return 0;
		}
	}

	function canTriggerFollowup()
	{
		return this.m.LastFollowupRound != this.getCurrentRound();
	}

	function markFollowupTriggered()
	{
		this.m.LastFollowupRound = this.getCurrentRound();
	}

	function reduceCurrentAP()
	{
		if (this.m.ActionPointsReduced)
		{
			return;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return;
		}

		actor.setActionPoints(this.Math.max(0, actor.getActionPoints() - 2));
		actor.setDirty(true);
		this.m.ActionPointsReduced = true;
	}

	function applyDisarm()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getSkills() == null || actor.getItems() == null || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return;
		}

		if (actor.getCurrentProperties().IsImmuneToDisarm || actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			return;
		}

		local disarm = actor.getSkills().getSkillByID("effects.disarmed");
		if (disarm == null)
		{
			disarm = this.new("scripts/skills/effects/disarmed_effect");
			actor.getSkills().add(disarm);
			disarm.setTurns(3);
		}
		else
		{
			disarm.setTurns(3);
		}
	}

	function onAdded()
	{
		this.reduceCurrentAP();
		this.applyDisarm();
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		this.m.ActionPointsReduced = false;
		this.reduceCurrentAP();
		this.applyDisarm();

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_111", actor.getTile());
		}
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 1.15;
		_properties.Bravery -= 20;
		_properties.MeleeSkill -= 20;
		_properties.RangedSkill -= 20;
		_properties.MeleeDefense -= 20;
		_properties.RangedDefense -= 20;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}
});
