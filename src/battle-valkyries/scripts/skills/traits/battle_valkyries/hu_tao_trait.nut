this.hu_tao_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={ValkyrieID="hu_tao"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieTrait(this,this.m.ValkyrieID);}
});
