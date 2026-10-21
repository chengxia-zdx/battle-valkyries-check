this.ryza_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m = { ValkyrieID = "ryza" },
 function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, "ryza"); }
 function onBuildDescription() { return ::$bvvar{namespace}.getValkyrieByID("ryza").BackgroundDescription; }
 function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("ryza"); }
});
