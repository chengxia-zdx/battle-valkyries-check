this.himeko_navigator_circlet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},

	function create()
	{
		this.helmet.create();
		this.m.ID = "$bvvar{modId}.helmet.himeko_navigator_circlet";
		this.m.Name = "$bv{item.himeko_navigator_circlet.name}";
		this.m.Description = "$bv{item.himeko_navigator_circlet.description}";
		this.m.Value = 20000;
		this.m.Condition = 300.0;
		this.m.ConditionMax = 300.0;
		this.m.StaminaModifier = -4;
		this.m.Variant = 84;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
		this.m.IsUnique = true;
		this.m.IsDroppedAsLoot = false;
	}

	function updateVariant()
	{
		this.helmet.updateVariant();
		this.m.Icon = "$bvvar{iconPrefix}/himeko_navigator_circlet.png";
		this.m.IconLarge = "$bvvar{iconPrefix}/himeko_navigator_circlet.png";
	}

	function getTooltip()
	{
		local ret = this.helmet.getTooltip();
		ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.himeko_navigator_circlet.tooltip.owner}" });
		ret.push({ id = 71, type = "text", icon = "ui/icons/fatigue.png", text = "$bv{item.himeko_navigator_circlet.tooltip.light}" });
		return ret;
	}
});
