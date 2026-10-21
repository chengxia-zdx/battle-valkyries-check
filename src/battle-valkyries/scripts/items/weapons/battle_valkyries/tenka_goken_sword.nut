// Public subclasses supply durable save paths and character-specific names.
this.tenka_goken_sword <- this.inherit("scripts/items/weapons/weapon", {
    m={Owner=null,BVTenkaSword=true},
    function create()
    {
        this.weapon.create();local d=::$bvvar{namespace}.TenkaGokenWeapons[this.m.Owner];
        this.m.ID="$bvvar{modId}.weapon."+d.Key;this.m.Categories="$bv{tenka.sword_category}";
        this.m.SlotType=::Const.ItemSlot.Mainhand;this.m.BlockedSlotType=d.TwoHanded?::Const.ItemSlot.Offhand:null;
        this.m.ItemType=::Const.Items.ItemType.Weapon|::Const.Items.ItemType.MeleeWeapon|::Const.Items.ItemType.Named|::Const.Items.ItemType.Legendary
            |(d.TwoHanded ? ::Const.Items.ItemType.TwoHanded : ::Const.Items.ItemType.OneHanded);
        this.m.IsDoubleGrippable=!d.TwoHanded;this.m.AddGenericSkill=true;this.m.ShowQuiver=false;
        this.m.RegularDamage=d.Low;this.m.RegularDamageMax=d.High;this.m.ArmorDamageMult=d.Armor;this.m.DirectDamageMult=d.Pierce;
        this.m.AdditionalAccuracy=d.Accuracy;this.m.StaminaModifier=-d.Weight;this.m.Condition=100.0;this.m.ConditionMax=100.0;
        this.m.Value=15000;this.m.IsUnique=true;this.m.IsDroppedAsLoot=false;this.m.RangeMin=1;this.m.RangeMax=1;this.m.RangeIdeal=1;
        this.m.Icon="$bvvar{iconPrefix}/"+d.Key+".png";
        this.m.IconLarge="$bvvar{iconPrefix}/"+d.Key+"_large.png";
        this.m.ArmamentIcon=d.TwoHanded?"icon_sword_two_handed_02":"icon_sword_fencing_01";
    }
    function onEquip()
    {
        this.weapon.onEquip();
        this.addSkill(this.new(this.isItemType(::Const.Items.ItemType.TwoHanded)?"scripts/skills/actives/overhead_strike":"scripts/skills/actives/slash"));
        ::$bvvar{namespace}.TenkaGoken.syncWeapon(this.getContainer().getActor());
    }
    function onUnequip()
    {
        local a=this.getContainer()==null?null:this.getContainer().getActor(),d=::$bvvar{namespace}.TenkaGokenWeapons[this.m.Owner];
        if(a!=null) foreach(key in [this.m.Owner+"_weapon",d.Secondary]) ::$bvvar{namespace}.detachTransientSkill(a,key,"$bvvar{modId}.owner.tenka."+d.Key);
        this.weapon.onUnequip();
    }
});
