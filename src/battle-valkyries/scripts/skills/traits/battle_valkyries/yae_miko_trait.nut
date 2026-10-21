this.yae_miko_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "yae_miko" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
