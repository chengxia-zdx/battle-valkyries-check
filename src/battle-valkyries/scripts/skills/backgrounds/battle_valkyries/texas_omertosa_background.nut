this.texas_omertosa_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { ValkyrieID = "texas_omertosa" },

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
