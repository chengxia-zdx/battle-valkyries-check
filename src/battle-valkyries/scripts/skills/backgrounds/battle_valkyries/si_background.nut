this.si_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={ValkyrieID="si"},
 function create(){this.character_background.create();::$bvvar{namespace}.setupValkyrieBackground(this,"si");},
 function onBuildDescription(){return ::$bvvar{namespace}.getValkyrieByID("si").BackgroundDescription;},
 function onChangeAttributes(){return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("si");}
});
