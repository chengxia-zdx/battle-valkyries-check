this.himeko_trailblazer_summoner <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		BVSkillOwnerToken = "$bvvar{modId}.owner.item.himeko_trailblazer_summoner",
		BVTrailblazerEntityRef = null,
		DeployedThisBattle = false
	},

	function create()
	{
		this.accessory.create();
		this.m.ID = "$bvvar{modId}.accessory.himeko_trailblazer_summoner";
		this.m.Name = "$bv{item.himeko_trailblazer_summoner.name}";
		this.m.Description = "$bv{item.himeko_trailblazer_summoner.description}";
		this.m.Categories = "$bv{item.himeko_trailblazer_summoner.category}";
		this.m.Icon = "$bvvar{iconPrefix}/himeko_trailblazer_summoner.png";
		this.m.IconLarge = "$bvvar{iconPrefix}/himeko_trailblazer_summoner.png";
		this.m.Value = 30000;
		this.m.IsDroppedAsLoot = false;
		this.m.IsAllowedInBag = true;
		this.m.IsChangeableInBattle = false;
		this.m.ShowOnCharacter = false;
		this.m.AddGenericSkill = false;
		this.m.BVTrailblazerEntityRef = null;
		this.m.DeployedThisBattle = false;
	}

	function isDeployedThisBattle()
	{
		return this.m.DeployedThisBattle;
	}

	// Do not call this method setEntity. The SHS "Accessory Companions" mod
	// identifies every accessory descendant with a setEntity method as a pet
	// and replaces its create, tooltip, icon, and serialization functions.
	function setTrailblazerEntityRef( _entity )
	{
		if (_entity == null || typeof _entity == "instance")
		{
			this.m.BVTrailblazerEntityRef = _entity;
		}
		else
		{
			this.m.BVTrailblazerEntityRef = this.WeakTableRef(_entity);
		}
	}

	function markDeployed( _entity )
	{
		this.m.DeployedThisBattle = true;
		this.setTrailblazerEntityRef(_entity);
	}

	function onTrailblazerDestroyed()
	{
		this.setTrailblazerEntityRef(null);
	}

	function getTooltip()
	{
		local ret = this.accessory.getTooltip();
		ret.push({ id = 67, type = "text", icon = "ui/icons/special.png", text = "$bv{item.himeko_trailblazer_summoner.tooltip.owner}" });
		ret.push({ id = 68, type = "text", icon = "ui/icons/action_points.png", text = "$bv{item.himeko_trailblazer_summoner.tooltip.deploy}" });
		ret.push({ id = 69, type = "text", icon = "ui/icons/armor_body.png", text = "$bv{item.himeko_trailblazer_summoner.tooltip.stats}" });
		return ret;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		local result = ::$bvvar{namespace}.attachTransientSkill(actor, "himeko_trailblazer_deploy", this.m.BVSkillOwnerToken);

		if (!result.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "himeko_trailblazer_deploy", result.Code, "item.himeko_trailblazer_summoner.attach");
		}
	}

	function onUnequip()
	{
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		local result = ::$bvvar{namespace}.detachTransientSkill(actor, "himeko_trailblazer_deploy", this.m.BVSkillOwnerToken);

		if (!result.Success && result.Code != "owner_not_found")
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "himeko_trailblazer_deploy", result.Code, "item.himeko_trailblazer_summoner.detach");
		}

		this.accessory.onUnequip();
	}

	function onCombatFinished()
	{
		this.accessory.onCombatFinished();
		this.setTrailblazerEntityRef(null);
		this.m.DeployedThisBattle = false;
	}
});
