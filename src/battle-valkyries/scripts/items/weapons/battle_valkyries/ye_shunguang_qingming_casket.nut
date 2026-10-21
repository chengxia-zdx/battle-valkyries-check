this.ye_shunguang_qingming_casket <- this.inherit("scripts/items/weapons/weapon", {
	m = { SwordForm = false },
	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.qingming_casket";
		this.m.Description = "$bv{item.qingming_casket.description}";
		this.m.Categories = "$bv{item.qingming_casket.category}";
		this.m.SlotType = this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Legendary | this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true; this.m.ShowQuiver = false; this.m.ShowArmamentIcon = true;
		this.m.Value = 30000; this.m.Condition = 120.0; this.m.ConditionMax = 120.0; this.m.StaminaModifier = -12;
		this.m.RangeMin = 1; this.m.RangeMax = 2; this.m.RangeIdeal = 2; this.m.ChanceToHitHead = 0;
		this.m.IsUnique = true; this.m.IsDroppedAsLoot = false; this.m.SwordForm = false;
		this.refreshForm();
	}
	function refreshForm()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local stage = ::$bvvar{namespace}.getYunkiWeaponStage(actor);
		if (actor == null && "Chapters" in ::$bvvar{namespace}) stage = ::$bvvar{namespace}.Chapters.weaponStage("yunki_demon_chronicle");
		// Tier six is now the permanent, pre-boss forging reward. Combat reset
		// and save/load must never turn an earned complete blade back into a casket.
		this.m.SwordForm = stage >= 6;
		local sword = this.m.SwordForm;
		this.m.Name = sword ? "$bv{item.qingming_sword.name}" : "$bv{item.qingming_casket.name}";
		this.m.Icon = "$bvvar{iconPrefix}/" + (sword ? "qingming_sword" : "qingming_casket") + "_70x70.png";
		this.m.IconLarge = "$bvvar{iconPrefix}/" + (sword ? "qingming_sword" : "qingming_casket") + ".png";
		this.m.ArmamentIcon = sword ? "icon_bv_qingming_sword" : "icon_bv_qingming_casket";
		this.m.RegularDamage = sword ? 120 : (stage >= 5 ? 90 : (stage >= 2 ? 80 : 70));
		this.m.RegularDamageMax = sword ? 150 : this.m.RegularDamage + 20;
		this.m.ArmorDamageMult = sword ? 1.75 : 1.30; this.m.DirectDamageMult = sword ? 0.45 : 0.30;
		this.m.AdditionalAccuracy = sword ? 15 : (stage >= 4 ? 10 : 5);
	}
	function setSwordForm(value) { this.m.SwordForm = value; this.refreshForm(); local c = this.getContainer(); if (c != null && c.getActor() != null) { c.getActor().getSkills().update(); c.getActor().setDirty(true); } }
	function getTooltip() { this.refreshForm(); local ret = this.weapon.getTooltip(); ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.qingming_casket.tooltip}" }); return ret; }
	function onEquip() { this.refreshForm(); this.weapon.onEquip(); ::$bvvar{namespace}.syncQingmingWeaponSkills(this.getContainer().getActor()); }
	function onUnequip()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		foreach (key in ["qingming_casket_strike", "qingming_unsheathe"]) ::$bvvar{namespace}.detachTransientSkill(actor, key, "$bvvar{modId}.owner.item.qingming_casket");
		this.weapon.onUnequip();
	}
	function onDeserialize(input) { this.weapon.onDeserialize(input); this.m.SwordForm = false; this.refreshForm(); }
});
