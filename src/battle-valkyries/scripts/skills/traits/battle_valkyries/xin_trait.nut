this.xin_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "xin" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
