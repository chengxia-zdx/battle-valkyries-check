this.es_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={SkinValkyrieID="es"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieSkinTrait(this,"es");},
 function getTooltip(){return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);}
});
