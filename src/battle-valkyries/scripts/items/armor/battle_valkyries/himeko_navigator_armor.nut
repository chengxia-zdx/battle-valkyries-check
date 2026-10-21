this.himeko_navigator_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},

	function create()
	{
		this.armor.create();
		this.m.ID = "$bvvar{modId}.armor.himeko_navigator_armor";
		this.m.Name = "$bv{item.himeko_navigator_armor.name}";
		this.m.Description = "$bv{item.himeko_navigator_armor.description}";
		this.m.Value = 20000;
		this.m.Condition = 300.0;
		this.m.ConditionMax = 300.0;
		this.m.StaminaModifier = -4;
		this.m.Variant = 80;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
		this.m.IsUnique = true;
		this.m.IsDroppedAsLoot = false;
	}

	function updateVariant()
	{
		this.armor.updateVariant();
		this.m.Icon = "$bvvar{iconPrefix}/himeko_navigator_armor.png";
		this.m.IconLarge = "$bvvar{iconPrefix}/himeko_navigator_armor_large.png";
	}

	function getTooltip()
	{
		local ret = this.armor.getTooltip();
		ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.himeko_navigator_armor.tooltip.owner}" });
		ret.push({ id = 71, type = "text", icon = "ui/icons/fatigue.png", text = "$bv{item.himeko_navigator_armor.tooltip.light}" });
		return ret;
	}
});
