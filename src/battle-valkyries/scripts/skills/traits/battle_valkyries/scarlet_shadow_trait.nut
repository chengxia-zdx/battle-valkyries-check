this.scarlet_shadow_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "scarlet_shadow" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
