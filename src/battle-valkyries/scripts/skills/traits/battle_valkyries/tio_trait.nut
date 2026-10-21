this.tio_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "tio" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, "tio"); }
});
