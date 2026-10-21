this.abigail_williams_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "abigail_williams" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
