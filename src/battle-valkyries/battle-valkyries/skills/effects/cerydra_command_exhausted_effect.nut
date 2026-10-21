this.cerydra_command_exhausted_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		this.m.ID = "$bvvar{modId}.effects.cerydra_command_exhausted";
		this.m.Name = "$bv{effect.cerydra_command_exhausted.name}";
		this.m.Description = "$bv{effect.cerydra_command_exhausted.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cerydra_command_exhausted_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cerydra_checkmate_command_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function onRoundEnd()
	{
		this.removeSelf();
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
				icon = "ui/tooltips/warning.png",
				text = "$bv{effect.cerydra_command_exhausted.tooltip.limit}"
			}
		];
	}
});
