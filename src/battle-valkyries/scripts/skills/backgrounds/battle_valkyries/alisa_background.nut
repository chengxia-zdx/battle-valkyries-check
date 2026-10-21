this.alisa_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m = { ValkyrieID = "alisa" },
 function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, "alisa"); }
 function onBuildDescription() { return ::$bvvar{namespace}.getValkyrieByID("alisa").BackgroundDescription; }
 function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments("alisa"); }
});
