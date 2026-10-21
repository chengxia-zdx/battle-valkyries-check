this.katsushika_hokusai_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "katsushika_hokusai" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
