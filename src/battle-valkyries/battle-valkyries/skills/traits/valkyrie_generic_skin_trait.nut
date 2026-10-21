this.valkyrie_generic_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
	function create()
	{
		this.character_trait.create();
		this.m.IsSerialized = false;
	}

	function bindValkyrieSkinTrait( _valkyrieID, _skinID = null )
	{
		::$bvvar{namespace}.setupValkyrieSkinTrait(this, _valkyrieID, _skinID);
	}

	function getTooltip()
	{
		return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);
	}
});
