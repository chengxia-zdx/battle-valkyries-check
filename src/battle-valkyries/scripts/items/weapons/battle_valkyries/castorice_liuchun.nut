this.castorice_liuchun <- this.inherit("scripts/items/weapons/weapon", {
	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.castorice_liuchun";
		this.m.Name = "$bv{item.castorice_liuchun.name}"; this.m.Description = "$bv{item.castorice_liuchun.description}";
		this.m.Categories = "$bv{item.castorice_liuchun.category}";
		this.m.SlotType = this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Legendary | this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true; this.m.ShowQuiver = false; this.m.ShowArmamentIcon = true;
		this.m.Value = 18000; this.m.Condition = 100.0; this.m.ConditionMax = 100.0; this.m.StaminaModifier = -10;
		this.m.RegularDamage = 100; this.m.RegularDamageMax = 120; this.m.ArmorDamageMult = 1.5; this.m.DirectDamageMult = 0.25;
		this.m.RangeMin = 1; this.m.RangeMax = 1; this.m.RangeIdeal = 1; this.m.ChanceToHitHead = 0;
		this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
		this.m.Icon = "$bvvar{iconPrefix}/castorice_liuchun.png"; this.m.IconLarge = "$bvvar{iconPrefix}/castorice_liuchun_large.png";
		this.m.ArmamentIcon = "icon_bv_castorice_liuchun";
	}
	function onEquip() { this.weapon.onEquip(); ::$bvvar{namespace}.syncLiuchunWeaponSkills(this.getContainer().getActor()); }
	function onUnequip()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		::$bvvar{namespace}.detachTransientSkill(actor, "spring_liuchun_strike", "$bvvar{modId}.owner.item.castorice_liuchun");
		this.weapon.onUnequip();
	}
});
