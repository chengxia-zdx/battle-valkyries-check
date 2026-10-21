this.hu_tao_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={SkinValkyrieID="hu_tao"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieSkinTrait(this,"hu_tao");},
 function getTooltip(){return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);}
});
