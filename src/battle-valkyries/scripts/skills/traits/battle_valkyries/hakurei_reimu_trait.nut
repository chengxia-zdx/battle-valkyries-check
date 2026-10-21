this.hakurei_reimu_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "hakurei_reimu" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
