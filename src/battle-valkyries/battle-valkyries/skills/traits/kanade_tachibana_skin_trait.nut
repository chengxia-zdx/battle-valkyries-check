this.kanade_tachibana_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={SkinValkyrieID="kanade_tachibana"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieSkinTrait(this,"kanade_tachibana");},
 function getTooltip(){return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);}
});
