this.fate_harlaown_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={SkinValkyrieID="fate_harlaown"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieSkinTrait(this,"fate_harlaown");},
 function getTooltip(){return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);}
});
