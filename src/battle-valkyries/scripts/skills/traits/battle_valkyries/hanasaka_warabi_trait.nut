this.hanasaka_warabi_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "hanasaka_warabi" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
