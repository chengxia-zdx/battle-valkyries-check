this.rachel_alucard_skin_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={SkinValkyrieID="rachel_alucard"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieSkinTrait(this,"rachel_alucard");},
 function getTooltip(){return ::$bvvar{namespace}.getValkyrieSkinTraitTooltip(this);}
});
