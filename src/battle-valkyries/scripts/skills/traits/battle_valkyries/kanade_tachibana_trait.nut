this.kanade_tachibana_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={ValkyrieID="kanade_tachibana"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieTrait(this,this.m.ValkyrieID);}
});
