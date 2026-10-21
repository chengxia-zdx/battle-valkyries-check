this.xilian_tomorrow_anchor_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		TurnsLeft = 3
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.xilian_tomorrow_anchor";
		this.m.Name = "$bv{effect.xilian_tomorrow_anchor.name}";
		this.m.Description = "$bv{effect.xilian_tomorrow_anchor.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/xilian_beyond_closed_loop.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Overlay <- "status_effect_34";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		return "$bv{effect.xilian_tomorrow_anchor.description}" + " " + "$bv{effect.xilian_tomorrow_anchor.duration_prefix}" + this.m.TurnsLeft + "$bv{effect.xilian_tomorrow_anchor.duration_suffix}";
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
				text = "$bv{effect.xilian_tomorrow_anchor.tooltip.melee_defense}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "$bv{effect.xilian_tomorrow_anchor.tooltip.ranged_defense}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "$bv{effect.xilian_tomorrow_anchor.tooltip.bravery}"
			}
		];
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		this.spawnIcon("status_effect_34", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 15;
		_properties.RangedDefense += 15;
		_properties.Bravery += 20;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}
});
