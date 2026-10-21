this.tio_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m = { ValkyrieID = "tio" },
 function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, "tio"); }
 function onBuildDescription() { return ::$bvvar{namespace}.getValkyrieByID("tio").BackgroundDescription; }
 function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("tio"); }
});
