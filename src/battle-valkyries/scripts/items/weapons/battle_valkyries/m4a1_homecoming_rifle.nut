// Stable public item path. Ammunition belongs to the actor's combat ledger.
this.m4a1_homecoming_rifle <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.m4a1_homecoming_rifle";
		this.m.Name = "$bv{item.m4a1_homecoming_rifle.name}";
		this.m.Description = "$bv{item.m4a1_homecoming_rifle.description}";
		this.m.Categories = "$bv{item.m4a1_homecoming_rifle.category}";
		this.m.IconLarge = "$bvvar{iconPrefix}/m4a1_homecoming_rifle.png";
		this.m.Icon = "$bvvar{iconPrefix}/m4a1_homecoming_rifle_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = false; this.m.ShowQuiver = false; this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bv_m4a1_homecoming_rifle";
		this.m.Value = 12000; this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
		this.m.StaminaModifier = -10; this.m.RangeMin = 1; this.m.RangeMax = 7; this.m.RangeIdeal = 3;
		this.m.Condition = 100.0; this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 65; this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.60; this.m.DirectDamageMult = 0.45;
		this.m.AdditionalAccuracy = 0;
	}
	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({id=70,type="text",icon="ui/icons/special.png",text="$bv{item.m4a1_homecoming_rifle.tooltip}"});
		return ret;
	}
});
