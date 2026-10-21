this.cerydra_military_merit_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = 0,
		LastAttackCounter = -1,
		LastAttackSkillID = ""
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		this.m.ID = "$bvvar{modId}.effects.cerydra_military_merit";
		this.m.Name = "$bv{effect.cerydra_military_merit.name}";
		this.m.Description = "$bv{effect.cerydra_military_merit.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cerydra_military_merit_effect.png";
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

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 10;
		_properties.RangedSkill += 10;
		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;
		_properties.Bravery += 10;
		_properties.DamageTotalMult *= 1.1;
	}

	function recordAttack( _skill )
	{
		local owner = this.getOwner();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (owner == null || actor == null || _skill == null || !_skill.isAttack() || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return false;
		}

		local counter = this.Const.SkillCounter;
		local skillID = _skill.getID();

		if (this.m.LastAttackCounter == counter && this.m.LastAttackSkillID == skillID)
		{
			return false;
		}

		this.m.LastAttackCounter = counter;
		this.m.LastAttackSkillID = skillID;

		local passive = ::$bvvar{namespace}.getCerydraWarBannerSkill(owner);
		return passive != null && passive.addEdict(1);
	}

	function getTooltip()
	{
		local owner = this.getOwner();
		local ownerName = owner == null ? "$bv{effect.cerydra_military_merit.tooltip.owner_missing}" : owner.getName();

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
				text = "$bv{effect.cerydra_military_merit.tooltip.owner}" + ownerName
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "$bv{effect.cerydra_military_merit.tooltip.stats}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{effect.cerydra_military_merit.tooltip.edict}"
			}
		];
	}
});
