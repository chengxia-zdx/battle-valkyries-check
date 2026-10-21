this.c_c_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "c_c" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
