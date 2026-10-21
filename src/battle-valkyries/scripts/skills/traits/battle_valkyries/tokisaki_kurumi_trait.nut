this.tokisaki_kurumi_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "tokisaki_kurumi" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
