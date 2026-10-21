this.hanasaka_warabi_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m = { ValkyrieID = "hanasaka_warabi" },
 function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, this.m.ValkyrieID); }
 function onBuildDescription() { return ::$bvvar{namespace}.getValkyrieByID(this.m.ValkyrieID).BackgroundDescription; }
 function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments(this.m.ValkyrieID); }
});
