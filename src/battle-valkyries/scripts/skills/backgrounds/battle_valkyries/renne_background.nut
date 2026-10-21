this.renne_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m = { ValkyrieID = "renne" },
 function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, "renne"); }
 function onBuildDescription() { return ::$bvvar{namespace}.getValkyrieByID("renne").BackgroundDescription; }
 function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("renne"); }
});
