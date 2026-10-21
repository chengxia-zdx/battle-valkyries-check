this.alisa_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "alisa" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, "alisa"); }
});
