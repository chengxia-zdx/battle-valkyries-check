this.kikakujo_mary_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "kikakujo_mary" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
