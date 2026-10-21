this.aemeath_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { SkinValkyrieID = "aemeath" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieSkinTrait(this, "aemeath"); }
 function getTooltip() { return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this); }
});
