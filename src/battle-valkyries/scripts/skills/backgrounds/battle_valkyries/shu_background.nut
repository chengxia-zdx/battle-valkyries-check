this.shu_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m = { ValkyrieID = "shu" },
 function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, "shu"); }
 function onBuildDescription() { return ::$bvvar{namespace}.getValkyrieByID("shu").BackgroundDescription; }
 function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("shu"); }
});
