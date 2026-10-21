this.royal_tide_last_oath_regent <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/royal_tide_oath_guard", {
	function create()
	{
		this.royal_tide_oath_guard.create(); this.m.Name = "$bv{enemy.royal_tide.regent.name}"; this.m.XP = 1400;
		this.m.RoyalTideBrush = "bust_bv_royal_banner_returning_tide_last_oath_regent";
		this.getFlags().remove("BVRoyalTideOathGuard");
	},
	function onInit()
	{
		this.royal_tide_oath_guard.onInit(); local b = this.m.BaseProperties;
		b.Hitpoints = 1000; b.ActionPoints = 9; b.MeleeSkill = 105; b.MeleeDefense = 20; b.RangedDefense = 10;
		this.m.Hitpoints = b.Hitpoints; this.m.ActionPoints = b.ActionPoints; this.m.CurrentProperties = clone b;
		this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/royal_tide_fortified_oath_effect"));
	},
	function assignRandomEquipment()
	{
		foreach (path in ["weapons/ancient/rhomphaia", "armor/ancient/ancient_plated_mail_hauberk", "helmets/ancient/ancient_honorguard_helmet"])
		{
			local item = this.new("scripts/items/" + path);
			if (item.getSlotType() == this.Const.ItemSlot.Body || item.getSlotType() == this.Const.ItemSlot.Head) { item.m.Condition = 350; item.m.ConditionMax = 350; }
			this.m.Items.equip(item);
		}
		this.refreshRoyalTideVisual();
	}
});
