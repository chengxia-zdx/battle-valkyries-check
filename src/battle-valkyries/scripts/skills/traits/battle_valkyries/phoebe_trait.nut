this.phoebe_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "phoebe" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
