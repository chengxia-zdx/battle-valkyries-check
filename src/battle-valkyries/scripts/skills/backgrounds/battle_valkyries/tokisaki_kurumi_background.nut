this.tokisaki_kurumi_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { ValkyrieID = "tokisaki_kurumi" },
	function create() { this.character_background.create(); ::$bvvar{namespace}.setupValkyrieBackground(this, this.m.ValkyrieID); }
	function onBuildDescription() { local t=::$bvvar{namespace}.getValkyrieByID(this.m.ValkyrieID); return t==null?"":t.BackgroundDescription; }
	function onChangeAttributes() { return ::$bvvar{namespace}.getValkyrieAttributeAdjustments(this.m.ValkyrieID); }
});
