this.si_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={SkinValkyrieID="si"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieSkinTrait(this,"si");},
 function getTooltip(){return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);}
});
