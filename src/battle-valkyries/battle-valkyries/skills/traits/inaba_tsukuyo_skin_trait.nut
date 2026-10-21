this.inaba_tsukuyo_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { SkinValkyrieID = "inaba_tsukuyo" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieSkinTrait(this,this.m.SkinValkyrieID); }
 function getTooltip() { return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this); }
});
