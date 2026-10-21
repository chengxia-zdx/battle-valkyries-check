this.renne_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "renne" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, "renne"); }
});
