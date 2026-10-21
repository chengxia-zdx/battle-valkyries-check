this.ryza_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "ryza" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, "ryza"); }
});
