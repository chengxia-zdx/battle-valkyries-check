this.sword_maiden_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { ValkyrieID = "sword_maiden" },

	function create()
	{
		this.character_background.create();
		::$bvvar{namespace}.setupValkyrieBackground(this, this.m.ValkyrieID);
	}

	function onBuildDescription() { return ::$bvvar{namespace}.buildValkyrieBackgroundDescription(this, this.m.ValkyrieID); }
	function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments(this.m.ValkyrieID); }
});
