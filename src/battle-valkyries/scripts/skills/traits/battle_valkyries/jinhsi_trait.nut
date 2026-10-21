this.jinhsi_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "jinhsi" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
