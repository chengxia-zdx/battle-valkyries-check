this.aglaea_seam_stitch_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.aglaea_seam_stitch";
		this.m.Name = "$bv{effect.aglaea_seam_stitch.name}";
		this.m.Description = "$bv{effect.aglaea_seam_stitch.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/aglaea_seam_stitch.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/aglaea_seam_stitch_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
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
				text = "$bv{effect.aglaea_seam_stitch.tooltip.damage}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{effect.aglaea_seam_stitch.tooltip.ap}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "$bv{effect.aglaea_seam_stitch.tooltip.kill}"
			}
		];
	}

	function onRefresh()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}
	}
});
