this.ye_shunguang_heartbound_circlet <- this.inherit("scripts/items/helmets/helmet", {
    function create()
    {
        this.helmet.create();
        this.m.ID = "$bvvar{modId}.helmet.ye_shunguang_heartbound_circlet";
        this.m.Name = "$bv{item.ye_shunguang_heartbound_circlet.name}"; this.m.Description = "$bv{item.ye_shunguang_heartbound_circlet.description}";
        this.m.Value = 18000; this.m.Condition = 240.0; this.m.ConditionMax = 240.0;
        this.m.StaminaModifier = -4; this.m.Vision = 0;
        this.m.Variant = 84; this.updateVariant();
        this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact; this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
        this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
    }
    function updateVariant()
    {
        this.helmet.updateVariant();
        this.m.Icon = "$bvvar{iconPrefix}/ye_shunguang_heartbound_circlet.png";
        this.m.IconLarge = "$bvvar{iconPrefix}/ye_shunguang_heartbound_circlet.png";
    }
    function onUpdateProperties(properties)
    {
        this.helmet.onUpdateProperties(properties);
        local actor = this.getContainer() == null ? null : this.getContainer().getActor();
        if (actor != null && ::$bvvar{namespace}.getActorValkyrieID(actor) == "ye_shunguang") properties.Bravery += 10;
    }
    function getTooltip()
    {
        local ret = this.helmet.getTooltip();
        ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.ye_shunguang_heartbound_circlet.owner}" });
        ret.push({ id = 71, type = "text", icon = "ui/icons/special.png", text = "$bv{item.ye_shunguang_heartbound_circlet.bonus}" });
        return ret;
    }
});
