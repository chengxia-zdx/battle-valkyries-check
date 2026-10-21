this.tohsaka_rin_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { SkinValkyrieID = "tohsaka_rin" },
	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieSkinTrait(this, this.m.SkinValkyrieID);
	}
	function getTooltip() { return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this); }
});
