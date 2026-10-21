this.inaba_tsukuyo_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "inaba_tsukuyo" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
