this.ye_shunguang_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "ye_shunguang" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
