// Stable public item path. Ammunition belongs to the actor's combat ledger.
this.hina_the_end_destroyer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.hina_the_end_destroyer";
		this.m.Name = "$bv{item.hina_the_end_destroyer.name}";
		this.m.Description = "$bv{item.hina_the_end_destroyer.description}";
		this.m.Categories = "$bv{item.hina_the_end_destroyer.category}";
		this.m.IconLarge = "$bvvar{iconPrefix}/sorasaki_hina_weapon_large.png";
		this.m.Icon = "$bvvar{iconPrefix}/sorasaki_hina_weapon_icon.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Legendary | this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = false; this.m.ShowQuiver = false; this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bv_sorasaki_hina_weapon";
		this.m.Value = 12000; this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
		this.m.StaminaModifier = -15; this.m.RangeMin = 1; this.m.RangeMax = 7; this.m.RangeIdeal = 3;
		this.m.Condition = 100.0; this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 50; this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.6; this.m.DirectDamageMult = 0.35;
		this.m.AdditionalAccuracy = 0;
	}
	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({id=70,type="text",icon="ui/icons/special.png",text="$bv{item.hina_the_end_destroyer.tooltip}"});
		return ret;
	}
});
