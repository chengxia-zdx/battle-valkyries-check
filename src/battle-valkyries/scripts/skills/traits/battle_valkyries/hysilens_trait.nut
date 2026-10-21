this.hysilens_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "hysilens" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
