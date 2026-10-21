this.scarlet_shadow_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { ValkyrieID = "scarlet_shadow" },

	function create()
	{
		this.character_background.create();
		::$bvvar{namespace}.setupValkyrieBackground(this, this.m.ValkyrieID);
	}

	function onBuildDescription()
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(this.m.ValkyrieID);
		return template != null ? template.BackgroundDescription : "";
	}

	function onChangeAttributes()
	{
		return ::$bvvar{namespace}.getValkyrieAttributeAdjustments(this.m.ValkyrieID);
	}
});
