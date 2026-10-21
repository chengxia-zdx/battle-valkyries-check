this.skirk_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "skirk" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 15;
		_properties.MeleeDefense += 10;
		_properties.Initiative += 20;
		_properties.Bravery += 15;
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
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
				text = "$bv{valkyrie.skirk.trait.tooltip.melee}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "$bv{valkyrie.skirk.trait.tooltip.defense}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "$bv{valkyrie.skirk.trait.tooltip.initiative_resolve}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "$bv{valkyrie.skirk.trait.tooltip.mental}"
			}
		];
	}
});
