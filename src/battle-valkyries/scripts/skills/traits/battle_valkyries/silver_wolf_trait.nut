this.silver_wolf_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "silver_wolf" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 15;
		_properties.RangedSkill += 15;
		_properties.Initiative += 30;
		_properties.ActionPoints += 3;
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
				icon = "ui/icons/melee_skill.png",
				text = "$bv{valkyrie.silver_wolf.trait.tooltip.melee}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "$bv{valkyrie.silver_wolf.trait.tooltip.ranged}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "$bv{valkyrie.silver_wolf.trait.tooltip.initiative_ap}"
			}
		];
	}
});
