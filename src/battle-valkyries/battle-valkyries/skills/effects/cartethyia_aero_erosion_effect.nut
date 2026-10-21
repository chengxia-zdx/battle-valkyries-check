this.cartethyia_aero_erosion_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.cartethyia_aero_erosion";
		this.m.Name = "$bv{effect.cartethyia_aero_erosion.name}";
		this.m.Description = "$bv{effect.cartethyia_aero_erosion.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cartethyia_wind_net.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cartethyia_wind_net_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.IsStacking = false;
	}
	function isAeroErosion() { return true; }
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.cartethyia_aero_erosion.tooltip}" }]; }
});
