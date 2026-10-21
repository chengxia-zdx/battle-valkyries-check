this.fate_harlaown_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m={ValkyrieID="fate_harlaown"},
 function create(){this.character_trait.create();::$bvvar{namespace}.setupValkyrieTrait(this,"fate_harlaown");}
});
