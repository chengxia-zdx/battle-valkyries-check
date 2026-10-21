this.himeko_astral_lance <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		BVSkillOwnerToken = "$bvvar{modId}.owner.item.himeko_astral_lance"
	},

	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.himeko_astral_lance";
		this.m.Name = "$bv{item.himeko_astral_lance.name}";
		this.m.Description = "$bv{item.himeko_astral_lance.description}";
		this.m.Categories = "$bv{item.himeko_astral_lance.category}";
		this.m.IconLarge = "$bvvar{iconPrefix}/himeko_astral_lance.png";
		this.m.Icon = "$bvvar{iconPrefix}/himeko_astral_lance_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Legendary | this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		// The generic item skill is hidden, but it is also the vanilla carrier
		// that calls weapon.onUpdateProperties and injects this weapon's damage
		// into the wielder's current combat properties.
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bv_himeko_astral_lance";
		this.m.Value = 30000;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -12;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 110;
		this.m.RegularDamageMax = 140;
		this.m.ArmorDamageMult = 1.75;
		this.m.DirectDamageMult = 0.45;
		this.m.AdditionalAccuracy = 15;
		this.m.ChanceToHitHead = 10;
		this.m.IsUnique = true;
		this.m.IsDroppedAsLoot = false;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.himeko_astral_lance.tooltip.owner}" });
		ret.push({ id = 71, type = "text", icon = "ui/icons/action_points.png", text = "$bv{item.himeko_astral_lance.tooltip.skill}" });
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		local result = ::$bvvar{namespace}.attachTransientSkill(actor, "himeko_astral_lance_strike", this.m.BVSkillOwnerToken);

		if (!result.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "himeko_astral_lance_strike", result.Code, "item.himeko_astral_lance.attach");
		}
	}

	function onUnequip()
	{
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		local result = ::$bvvar{namespace}.detachTransientSkill(actor, "himeko_astral_lance_strike", this.m.BVSkillOwnerToken);

		if (!result.Success && result.Code != "owner_not_found")
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "himeko_astral_lance_strike", result.Code, "item.himeko_astral_lance.detach");
		}

		this.weapon.onUnequip();
	}
});
