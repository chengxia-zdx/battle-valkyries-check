this.cerydra_banner_aura_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = 0
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.cerydra_banner_aura";
		this.m.Name = "$bv{effect.cerydra_banner_aura.name}";
		this.m.Description = "$bv{effect.cerydra_banner_aura.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cerydra_banner_aura_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cerydra_royal_edict_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function setupOwner( _owner )
	{
		this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner);
		this.m.OwnerID = _owner == null ? 0 : _owner.getID();
	}

	function getOwner()
	{
		if (this.m.Owner == null || this.m.Owner.isNull())
		{
			return null;
		}

		local owner = this.m.Owner;
		return ::$bvvar{namespace}.isActorDeadOrDying(owner) ? null : owner;
	}

	function isOwnedBy( _owner )
	{
		return _owner != null && this.m.OwnerID != 0 && this.m.OwnerID == _owner.getID();
	}

	function isInAura()
	{
		local owner = this.getOwner();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (owner == null || actor == null || actor == owner || !actor.isAlliedWith(owner) || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return false;
		}

		if (!owner.isPlacedOnMap() || !actor.isPlacedOnMap())
		{
			return false;
		}

		local passive = ::$bvvar{namespace}.getCerydraWarBannerSkill(owner);
		local range = passive == null ? 4 : passive.getAuraRange();
		return owner.getTile().getDistanceTo(actor.getTile()) <= range;
	}

	function onUpdate( _properties )
	{
		if (!this.isInAura())
		{
			return;
		}

		_properties.Bravery += 10;
		_properties.MeleeSkill += 5;
		_properties.RangedSkill += 5;
		_properties.MeleeDefense += 5;
		_properties.RangedDefense += 5;
	}

	function isHidden()
	{
		return !this.isInAura();
	}

	function getTooltip()
	{
		local owner = this.getOwner();
		local ownerName = owner == null ? "$bv{effect.cerydra_banner_aura.tooltip.owner_missing}" : owner.getName();

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.cerydra_banner_aura.tooltip.owner}" + ownerName
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "$bv{effect.cerydra_banner_aura.tooltip.stats}"
			}
		];
	}
});
