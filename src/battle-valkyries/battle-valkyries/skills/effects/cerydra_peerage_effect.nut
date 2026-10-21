this.cerydra_peerage_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = 0,
		FixedDamage = 20,
		LastDamageCounter = -1,
		LastDamageTargetID = -1
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.cerydra_peerage";
		this.m.Name = "$bv{effect.cerydra_peerage.name}";
		this.m.Description = "$bv{effect.cerydra_peerage.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cerydra_peerage_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cerydra_royal_edict_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Overlay <- "status_effect_34";
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

	function removeNegativeEffects()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		::$bvvar{namespace}.removeCerydraNegativeEffects(actor);
	}

	function onAdded()
	{
		this.removeNegativeEffects();
	}

	function onRefresh()
	{
		this.removeNegativeEffects();
	}

	function onTurnStart()
	{
		this.removeNegativeEffects();
	}

	function onUpdate( _properties )
	{
		this.removeNegativeEffects();
		_properties.MeleeSkill += 20;
		_properties.RangedSkill += 20;
		_properties.MeleeDefense += 20;
		_properties.RangedDefense += 20;
		_properties.Bravery += 15;
		_properties.DamageTotalMult *= 1.2;
	}

	function applyFixedDamage( _attacker, _skill, _target, _options = null )
	{
		if (_attacker == null || _skill == null || !_skill.isAttack() || _target == null || _target.isAlliedWith(_attacker) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local counter = this.Const.SkillCounter;
		local targetID = _target.getID();

		if (this.m.LastDamageCounter == counter && this.m.LastDamageTargetID == targetID)
		{
			return false;
		}

		this.m.LastDamageCounter = counter;
		this.m.LastDamageTargetID = targetID;

		if (_target.isPlacedOnMap())
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#8fc7ff"), _target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		}

		local options = _options == null ? {} : clone _options;
		if (!("Source" in options)) options.Source <- "cerydra_peerage_fixed";
		if (!("BodyPart" in options)) options.BodyPart <- this.Const.BodyPart.Body;
		local result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_attacker, this, _target, this.m.FixedDamage, options);
		return result != null && "Applied" in result && result.Applied;
	}

	function getTooltip()
	{
		local owner = this.getOwner();
		local ownerName = owner == null ? "$bv{effect.cerydra_peerage.tooltip.owner_missing}" : owner.getName();

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
				text = "$bv{effect.cerydra_peerage.tooltip.owner}" + ownerName
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "$bv{effect.cerydra_peerage.tooltip.stats}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{effect.cerydra_peerage.tooltip.fixed_damage}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.cerydra_peerage.tooltip.immunity}"
			}
		];
	}
});
