this.jingliu_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "jingliu" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.MeleeSkill += 5;
		_properties.MeleeDefense += 5;
		_properties.Initiative += 10;
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
				icon = "ui/icons/bravery.png",
				text = "$bv{valkyrie.jingliu.trait.tooltip.resolve}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "$bv{valkyrie.jingliu.trait.tooltip.melee}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "$bv{valkyrie.jingliu.trait.tooltip.defense_initiative}"
			}
		];
	}
});
