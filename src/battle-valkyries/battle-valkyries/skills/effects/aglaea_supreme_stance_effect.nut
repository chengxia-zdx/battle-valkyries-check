this.aglaea_supreme_stance_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		TurnsLeft = 2
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.aglaea_supreme_stance";
		this.m.Name = "$bv{effect.aglaea_supreme_stance.name}";
		this.m.Description = "$bv{effect.aglaea_supreme_stance.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/aglaea_supreme_stance.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/aglaea_supreme_stance_sw.png";
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
				icon = "ui/icons/direct_damage.png",
				text = "$bv{effect.aglaea_supreme_stance.tooltip.damage}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.aglaea_supreme_stance.tooltip.duration}"
			}
		];
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}
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
		this.m.TurnsLeft = 2;
	}
});
