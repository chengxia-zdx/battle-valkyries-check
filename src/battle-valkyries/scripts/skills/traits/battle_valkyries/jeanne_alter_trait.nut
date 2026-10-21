this.jeanne_alter_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "jeanne_alter" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 20;
		_properties.MeleeSkill += 10;
		_properties.Initiative += 15;
		_properties.Stamina += 10;
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
				text = "$bv{valkyrie.jeanne_alter.trait.tooltip.resolve}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "$bv{valkyrie.jeanne_alter.trait.tooltip.melee_initiative}"
			}
		];
	}
});
