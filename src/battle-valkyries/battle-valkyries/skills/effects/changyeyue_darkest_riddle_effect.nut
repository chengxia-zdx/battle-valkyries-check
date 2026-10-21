this.changyeyue_darkest_riddle_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		TurnsLeft = 3
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.changyeyue_darkest_riddle";
		this.m.Name = "$bv{effect.changyeyue_darkest_riddle.name}";
		this.m.Description = "$bv{effect.changyeyue_darkest_riddle.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/changyeyue_darkest_riddle.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/changyeyue_darkest_riddle_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Overlay <- "status_effect_34";
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
				icon = "ui/icons/melee_defense.png",
				text = "$bv{effect.changyeyue_darkest_riddle.tooltip.defense}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.changyeyue_darkest_riddle.tooltip.duration}"
			}
		];
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_75", actor.getTile());
		}
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.7;
		_properties.MeleeDefense += 20;
		_properties.RangedDefense += 20;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onCombatStarted()
	{
		this.m.TurnsLeft = 3;
	}
});
