this.tamaba_satori_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { ValkyrieID = "tamaba_satori" },
 function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
