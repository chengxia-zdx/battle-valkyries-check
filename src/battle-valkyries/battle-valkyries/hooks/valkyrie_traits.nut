::$bvvar{namespace}.MH.hook("scripts/skills/traits/character_trait", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (!("ValkyrieID" in this.m))
		{
			return;
		}

		local traitData = ::$bvvar{namespace}.getValkyrieTraitData(this.m.ValkyrieID);
		if (traitData == null || !("TraitBonuses" in traitData))
		{
			return;
		}

		::$bvvar{namespace}.applyValkyrieFlatBonuses(_properties, traitData.TraitBonuses);
	}

	q.getTooltip = @(__original) function()
	{
		if (!("ValkyrieID" in this.m))
		{
			return __original();
		}

		local traitData = ::$bvvar{namespace}.getValkyrieTraitData(this.m.ValkyrieID);
		if (traitData == null || !("TraitTooltip" in traitData))
		{
			return __original();
		}

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
				icon = "ui/icons/special.png",
				text = traitData.TraitTooltip
			}
		];
	}
});
