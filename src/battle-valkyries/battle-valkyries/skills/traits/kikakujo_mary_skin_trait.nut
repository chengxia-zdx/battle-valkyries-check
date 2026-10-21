this.kikakujo_mary_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { SkinValkyrieID = "kikakujo_mary" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieSkinTrait(this,this.m.SkinValkyrieID); }
 function getTooltip() { return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this); }
});
