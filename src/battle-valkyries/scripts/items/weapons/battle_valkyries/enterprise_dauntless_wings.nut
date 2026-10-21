// Stable public save path. Aviation keeps its independent damage and actor ledger.
this.enterprise_dauntless_wings <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.enterprise_dauntless_wings";
		this.m.Name = "$bv{item.enterprise_dauntless_wings.name}";
		this.m.Description = "$bv{item.enterprise_dauntless_wings.description}";
		this.m.Categories = "$bv{item.enterprise_dauntless_wings.category}";
		this.m.IconLarge = "$bvvar{iconPrefix}/enterprise_dauntless_wings.png";
		this.m.Icon = "$bvvar{iconPrefix}/enterprise_dauntless_wings_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true; this.m.ShowQuiver = true; this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bv_enterprise_dauntless_wings";
		this.m.Value = 12000; this.m.IsUnique = true; this.m.IsDroppedAsLoot = false;
		this.m.RangeMin = 2; this.m.RangeMax = 7; this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -10;
		this.m.Condition = 100.0; this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 60; this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.30; this.m.DirectDamageMult = 0.35;
		this.m.AdditionalAccuracy = 5;
	}
	function getAmmoID() { return "ammo.arrows"; }
	function getAdditionalRange(_actor) { return _actor.getCurrentProperties().IsSpecializedInBows ? 1 : 0; }
	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/quick_shot"));
		this.addSkill(this.new("scripts/skills/actives/aimed_shot"));
	}
	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({id=70,type="text",icon="ui/icons/special.png",text="$bv{item.enterprise_dauntless_wings.tooltip}"});
		return ret;
	}
});
