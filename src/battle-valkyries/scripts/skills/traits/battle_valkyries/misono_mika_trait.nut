this.misono_mika_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "misono_mika" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
