this.hysilens_returning_oath <- this.inherit("scripts/items/weapons/weapon", {
	function create()
	{
		this.weapon.create(); this.m.ID = "$bvvar{modId}.weapon.hysilens_returning_oath";
		this.m.Name = "$bv{item.hysilens_returning_oath.name}"; this.m.Description = "$bv{item.hysilens_returning_oath.description}";
		this.m.Categories = "$bv{item.hysilens_returning_oath.category}";
		this.m.SlotType = this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Legendary | this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true; this.m.ShowQuiver = false; this.m.ShowArmamentIcon = true;
		this.m.Value = 18000; this.m.Condition = 100.0; this.m.ConditionMax = 100.0; this.m.StaminaModifier = -12;
		this.m.RegularDamage = 120; this.m.RegularDamageMax = 150; this.m.ArmorDamageMult = 1.75; this.m.DirectDamageMult = 0.4;
		this.m.AdditionalAccuracy = 15; this.m.RangeMin = 1; this.m.RangeMax = 1; this.m.RangeIdeal = 1; this.m.ChanceToHitHead = 0;
		this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
		this.m.Icon = "$bvvar{iconPrefix}/hysilens_returning_oath.png"; this.m.IconLarge = "$bvvar{iconPrefix}/hysilens_returning_oath_large.png";
		this.m.ArmamentIcon = "icon_bv_hysilens_returning_oath";
	}
	function onEquip() { this.weapon.onEquip(); ::$bvvar{namespace}.syncReturningOathSkills(this.getContainer().getActor()); }
	function lowerCondition(value = this.Const.Combat.WeaponDurabilityLossOnHit)
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		this.weapon.lowerCondition(value);
		if (this.getCondition() <= 0) ::$bvvar{namespace}.downgradeReturningOathErosion(actor);
	}
	function onUnequip()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		::$bvvar{namespace}.downgradeReturningOathErosion(actor);
		::$bvvar{namespace}.detachTransientSkill(actor, "royal_tide_slash", "$bvvar{modId}.owner.item.hysilens_returning_oath");
		this.weapon.onUnequip();
	}
});
