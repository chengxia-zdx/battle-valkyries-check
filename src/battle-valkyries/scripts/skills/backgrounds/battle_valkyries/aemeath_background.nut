this.aemeath_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={ValkyrieID="aemeath"},
 function create(){this.character_background.create();::$bvvar{namespace}.setupValkyrieBackground(this,"aemeath");}
 function onBuildDescription(){return ::$bvvar{namespace}.getValkyrieByID("aemeath").BackgroundDescription;}
 function onChangeAttributes(){return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("aemeath");}
});
