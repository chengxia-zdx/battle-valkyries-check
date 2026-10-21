this.rachel_alucard_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={ValkyrieID="rachel_alucard"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieTrait(this,this.m.ValkyrieID);}
});
