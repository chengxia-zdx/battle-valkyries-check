this.togawa_sakiko_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "togawa_sakiko" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
