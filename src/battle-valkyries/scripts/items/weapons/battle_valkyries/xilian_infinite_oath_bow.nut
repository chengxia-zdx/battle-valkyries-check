this.xilian_infinite_oath_bow <- this.inherit("scripts/items/weapons/weapon", {
	m = {},

	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.xilian_infinite_oath_bow";
		this.m.Name = "$bv{item.xilian_infinite_oath_bow.name}";
		this.m.Description = "$bv{item.xilian_infinite_oath_bow.description}";
		this.m.Categories = "$bv{item.xilian_infinite_oath_bow.category}";
		this.m.IconLarge = "$bvvar{iconPrefix}/xilian_memory_bow.png";
		this.m.Icon = "$bvvar{iconPrefix}/xilian_memory_bow_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bv_xilian_memory_bow";
		this.m.Value = 20000;
		this.m.RangeMin = 2;
		this.m.RangeMax = 7;
		this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -5;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.RegularDamage = 100;
		this.m.RegularDamageMax = 120;
		this.m.ArmorDamageMult = 2.0;
		this.m.DirectDamageMult = 0.5;
		this.m.AdditionalAccuracy = 30;
		this.m.IsUnique = true;
		this.m.IsDroppedAsLoot = false;
	}

	function getAmmoID()
	{
		return "ammo.arrows";
	}

	function getAdditionalRange( _actor )
	{
		return _actor.getCurrentProperties().IsSpecializedInBows ? 1 : 0;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 70,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{item.xilian_infinite_oath_bow.tooltip.owner}"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/quick_shot"));
		this.addSkill(this.new("scripts/skills/actives/aimed_shot"));
	}
});
