this.liuying_sam_core_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		BVSkillOwnerToken = "$bvvar{modId}.owner.item.liuying_sam_core"
	},

	function create()
	{
		this.accessory.create();
		this.m.ID = "$bvvar{modId}.accessory.liuying_sam_core";
		this.m.Name = "$bv{item.liuying_sam_core.name}";
		this.m.Description = "$bv{item.liuying_sam_core.description}";
		this.m.Categories = "$bv{item.liuying_sam_core.category}";
		this.m.Icon = "$bvvar{iconPrefix}/liuying_sam_core.png";
		this.m.IconLarge = "$bvvar{iconPrefix}/liuying_sam_core.png";
		this.m.Value = 12000;
		this.m.IsDroppedAsLoot = false;
		this.m.IsAllowedInBag = true;
		this.m.ShowOnCharacter = false;
		this.m.AddGenericSkill = false;
	}

	function getTooltip()
	{
		local ret = this.accessory.getTooltip();
		ret.push({
			id = 67,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{item.liuying_sam_core.tooltip.owner}"
		});
		ret.push({
			id = 68,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = "$bv{item.liuying_sam_core.tooltip.skill}"
		});
		return ret;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		local attachResult = ::$bvvar{namespace}.attachTransientSkill(actor, "liuying_sam_deploy", this.m.BVSkillOwnerToken);

		if (!attachResult.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "liuying_sam_deploy", attachResult.Code, "item.liuying_sam_core.attach");
		}
	}

	function onUnequip()
	{
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		local detachResult = ::$bvvar{namespace}.detachTransientSkill(actor, "liuying_sam_deploy", this.m.BVSkillOwnerToken);

		if (!detachResult.Success && detachResult.Code != "owner_not_found")
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "liuying_sam_deploy", detachResult.Code, "item.liuying_sam_core.detach");
		}

		this.accessory.onUnequip();
	}
});
