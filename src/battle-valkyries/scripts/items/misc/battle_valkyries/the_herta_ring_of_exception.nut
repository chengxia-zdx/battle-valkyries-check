this.the_herta_ring_of_exception <- this.inherit("scripts/items/item", {
    // Legends visits each class's own members before inheritance is merged.
    m = {},
    function create()
    {
        this.item.create();this.m.ID="$bvvar{modId}.misc.the_herta_ring_of_exception";
        this.m.Name="$bv{item.the_herta_ring_of_exception.name}";this.m.Description="$bv{item.the_herta_ring_of_exception.description}";
        this.m.Categories="$bv{item.the_herta_ring_of_exception.category}";
        this.m.Icon="$bvvar{iconPrefix}/the_herta_ring_of_exception.png";this.m.IconLarge=this.m.Icon;
        this.m.SlotType=this.Const.ItemSlot.None;this.m.ItemType=this.Const.Items.ItemType.Quest;
        this.m.IsUsable=false;this.m.IsSellable=false;this.m.IsDroppedAsLoot=false;this.m.IsAllowedInBag=false;this.m.Value=0;
    }
    function drop(tile=null) { return false; }
    function getTooltip()
    {
        return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
            {id=3,type="image",image=this.getIcon(),isLarge=false}];
    }
});
