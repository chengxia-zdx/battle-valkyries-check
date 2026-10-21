this.raiden_shogun_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { SkinValkyrieID = "raiden_shogun" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieSkinTrait(this, this.m.SkinValkyrieID);
	}

	function getTooltip()
	{
		return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);
	}
});

