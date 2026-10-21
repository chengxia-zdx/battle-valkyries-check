this.m4a1_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "m4a1" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
