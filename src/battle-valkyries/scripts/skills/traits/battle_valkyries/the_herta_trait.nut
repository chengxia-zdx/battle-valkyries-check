this.the_herta_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "the_herta" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
