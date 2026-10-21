this.mai_shiranui_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "mai_shiranui" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
