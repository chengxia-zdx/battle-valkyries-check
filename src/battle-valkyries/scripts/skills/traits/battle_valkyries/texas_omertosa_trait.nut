this.texas_omertosa_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "texas_omertosa" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
