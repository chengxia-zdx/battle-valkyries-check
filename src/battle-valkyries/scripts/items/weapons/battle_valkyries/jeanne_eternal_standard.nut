this.jeanne_eternal_standard <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		BVSkillOwnerToken = "$bvvar{modId}.owner.item.jeanne_eternal_standard"
	},

	function create()
	{
		this.weapon.create();
		this.m.ID = "$bvvar{modId}.weapon.jeanne_eternal_standard";
		this.m.Name = "$bv{item.jeanne_eternal_standard.name}";
		this.m.Description = "$bv{item.jeanne_eternal_standard.description}";
		this.m.Categories = "$bv{item.jeanne_eternal_standard.category}";
		this.m.IconLarge = "$bvvar{iconPrefix}/jeanne_eternal_standard.png";
		this.m.Icon = "$bvvar{iconPrefix}/jeanne_eternal_standard_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Legendary
			| this.Const.Items.ItemType.Named
			| this.Const.Items.ItemType.Weapon
			| this.Const.Items.ItemType.MeleeWeapon
			| this.Const.Items.ItemType.TwoHanded
			| this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = false;
		this.m.ArmamentIcon = "";
		this.m.Value = 30000;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -12;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 80;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.35;
		this.m.AdditionalAccuracy = 5;
		this.m.IsUnique = true;
		this.m.IsDroppedAsLoot = false;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({ id = 70, type = "text", icon = "ui/icons/special.png", text = "$bv{item.jeanne_eternal_standard.tooltip.owner}" });
		ret.push({ id = 71, type = "text", icon = "ui/icons/bravery.png", text = "$bv{item.jeanne_eternal_standard.tooltip.banner}" });
		ret.push({ id = 72, type = "text", icon = "ui/icons/fatigue.png", text = "$bv{item.jeanne_eternal_standard.tooltip.together}" });
		ret.push({ id = 73, type = "text", icon = "ui/icons/action_points.png", text = "$bv{item.jeanne_eternal_standard.tooltip.skills}" });
		return ret;
	}

	function attachWeaponSkills( _actor )
	{
		foreach( skillKey in ["jeanne_holy_banner_thrust", "jeanne_holy_banner_sweep"] )
		{
			local result = ::$bvvar{namespace}.attachTransientSkill(_actor, skillKey, this.m.BVSkillOwnerToken);
			if (!result.Success)
			{
				::$bvvar{namespace}.logValkyrieSkillFailure(_actor, skillKey, result.Code, "item.jeanne_eternal_standard.attach");
			}
		}
	}

	function detachWeaponSkills( _actor )
	{
		foreach( skillKey in ["jeanne_holy_banner_thrust", "jeanne_holy_banner_sweep"] )
		{
			local result = ::$bvvar{namespace}.detachTransientSkill(_actor, skillKey, this.m.BVSkillOwnerToken);
			if (!result.Success && result.Code != "owner_not_found")
			{
				::$bvvar{namespace}.logValkyrieSkillFailure(_actor, skillKey, result.Code, "item.jeanne_eternal_standard.detach");
			}
		}
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		// Like the vanilla standard, draw the flag behind the bearer. Include
		// its pole in this brush: whole-bust skins suppress the vanilla shaft.
		if (actor != null && actor.hasSprite("background"))
		{
			local banner = actor.getSprite("background");
			banner.setBrush("bv_jeanne_eternal_standard_banner");
			banner.Visible = true;
			banner.Alpha = 255;
			actor.setDirty(true);
		}
		this.attachWeaponSkills(actor);
	}

	function onUnequip()
	{
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		if (actor != null && actor.hasSprite("background"))
		{
			local banner = actor.getSprite("background");
			if (banner.HasBrush && banner.getBrush().Name == "bv_jeanne_eternal_standard_banner")
			{
				banner.resetBrush();
				actor.setDirty(true);
			}
		}
		this.detachWeaponSkills(actor);
		this.weapon.onUnequip();
	}
});
