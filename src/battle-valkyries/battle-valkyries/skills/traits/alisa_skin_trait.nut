this.alisa_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { SkinValkyrieID = "alisa" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieSkinTrait(this, "alisa"); }
 function getTooltip() { return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this); }
});
