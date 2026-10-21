this.fate_harlaown_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={ValkyrieID="fate_harlaown"},
 function create(){this.character_background.create();::$bvvar{namespace}.setupValkyrieBackground(this,"fate_harlaown");},
 function onBuildDescription(){return ::$bvvar{namespace}.getValkyrieByID("fate_harlaown").BackgroundDescription;},
 function onChangeAttributes(){return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("fate_harlaown");}
});
