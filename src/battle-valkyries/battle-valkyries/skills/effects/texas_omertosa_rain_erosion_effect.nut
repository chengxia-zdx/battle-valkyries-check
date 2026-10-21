this.texas_omertosa_rain_erosion_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { TurnsLeft = 2, OwnerRef = null, OwnerID = null },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.texas_omertosa_rain_erosion";
		this.m.Name = "$bv{effect.texas_omertosa_rain_erosion.name}";
		this.m.Description = "$bv{effect.texas_omertosa_rain_erosion.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/texas_omertosa_unrelenting_downpour.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/texas_omertosa_unrelenting_downpour_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.IsStacking = false;
	}

	function setupOwner( _owner )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
	}

	function isOwnedBy( _owner )
	{
		return _owner != null && this.m.OwnerID != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner) == this.m.OwnerID;
	}

	function getName()
	{
		return this.m.Name + " (" + this.m.TurnsLeft + ")";
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{effect.texas_omertosa_rain_erosion.tooltip.penetration}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.texas_omertosa_rain_erosion.tooltip.duration}" }
		];
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0) this.removeSelf();
	}
});
