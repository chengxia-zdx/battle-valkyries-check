this.ye_shunguang_homeward_vestment <- this.inherit("scripts/items/armor/armor", {
    function create()
    {
        this.armor.create();
        this.m.ID = "$bvvar{modId}.armor.ye_shunguang_homeward_vestment";
        this.m.Name = "$bv{item.ye_shunguang_homeward_vestment.name}"; this.m.Description = "$bv{item.ye_shunguang_homeward_vestment.description}";
        this.m.Value = 18000; this.m.Condition = 300.0; this.m.ConditionMax = 300.0;
        this.m.StaminaModifier = -8; 
        this.m.Variant = 80; this.updateVariant();
        this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact; this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
        this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
    }
    function updateVariant()
    {
        this.armor.updateVariant();
        this.m.Icon = "$bvvar{iconPrefix}/ye_shunguang_homeward_vestment.png";
        this.m.IconLarge = "$bvvar{iconPrefix}/ye_shunguang_homeward_vestment_large.png";
    }
    function onUpdateProperties(properties)
    {
        this.armor.onUpdateProperties(properties);
        local actor = this.getContainer() == null ? null : this.getContainer().getActor();
        if (actor != null && ::$bvvar{namespace}.getActorValkyrieID(actor) == "ye_shunguang") properties.Initiative += 10;
    }
    function getTooltip()
    {
        local ret = this.armor.getTooltip();
        ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.ye_shunguang_homeward_vestment.owner}" });
        ret.push({ id = 71, type = "text", icon = "ui/icons/special.png", text = "$bv{item.ye_shunguang_homeward_vestment.bonus}" });
        return ret;
    }
});
