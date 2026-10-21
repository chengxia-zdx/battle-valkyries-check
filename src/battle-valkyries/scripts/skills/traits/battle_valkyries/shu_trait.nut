this.shu_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "shu" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, "shu"); }
});
