this.kanade_tachibana_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={ValkyrieID="kanade_tachibana"},
 function create(){this.character_background.create();::$bvvar{namespace}.setupValkyrieBackground(this,this.m.ValkyrieID);},
 function onBuildDescription(){return ::$bvvar{namespace}.getValkyrieByID(this.m.ValkyrieID).BackgroundDescription;},
 function onChangeAttributes(){return ::$bvvar{namespace}.getValkyrieAttributeAdjustments(this.m.ValkyrieID);}
});
