this.hysilens_tidal_erosion_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		TurnsLeft = 2,
		Owner = null,
		OwnerID = 0,
		EndTurnDamage = 5,
		OwnerBonusDamage = 20,
		AllyBonusDamage = 10,
		IsApplyingBonusDamage = false
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.hysilens_tidal_erosion";
		this.m.Name = "$bv{effect.hysilens_tidal_erosion.name}";
		this.m.Description = "$bv{effect.hysilens_tidal_erosion.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/hysilens_tidal_erosion_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/hysilens_tidal_erosion_effect_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
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
		this.m.ReturningOath <- "hasReturningOath" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasReturningOath(_owner);
		this.m.TurnsLeft = this.m.ReturningOath ? 3 : 2;
		this.syncReturningOath();
	}
	function downgradeReturningOath()
	{
		this.m.ReturningOath <- false; this.m.TurnsLeft = ::Math.min(2, this.m.TurnsLeft);
		this.m.EndTurnDamage = 5; this.m.OwnerBonusDamage = 20; this.m.AllyBonusDamage = 10;
	}
	function syncReturningOath()
	{
		local upgraded = "ReturningOath" in this.m && this.m.ReturningOath;
		if (upgraded && (!("hasReturningOath" in ::$bvvar{namespace}) || !::$bvvar{namespace}.hasReturningOath(this.getOwner())))
		{ this.downgradeReturningOath(); upgraded = false; }
		this.m.EndTurnDamage = upgraded ? 10 : 5; this.m.OwnerBonusDamage = upgraded ? 35 : 20; this.m.AllyBonusDamage = upgraded ? 15 : 10;
		return upgraded;
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

	function getName()
	{
		return this.m.Name + " (" + this.m.TurnsLeft + ")";
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.syncReturningOath() ? 3 : 2;

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_111", actor.getTile());
		}
	}

	function getTooltip()
	{
		local upgraded = this.syncReturningOath();
		local owner = this.getOwner();
		local ownerName = owner == null ? "$bv{effect.hysilens_tidal_erosion.tooltip.owner_missing}" : owner.getName();

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
				text = "$bv{effect.hysilens_tidal_erosion.tooltip.owner}" + ownerName
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = upgraded ? "$bv{effect.royal_tide.defense}" : "$bv{effect.hysilens_tidal_erosion.tooltip.defense}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = upgraded ? "$bv{effect.royal_tide.vulnerability}" : "$bv{effect.hysilens_tidal_erosion.tooltip.vulnerability}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = upgraded ? "$bv{effect.royal_tide.fixed_damage}" : "$bv{effect.hysilens_tidal_erosion.tooltip.fixed_damage}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = upgraded ? "$bv{effect.royal_tide.followup}" : "$bv{effect.hysilens_tidal_erosion.tooltip.followup}"
			}
		];
	}

	function onUpdate( _properties )
	{
		local upgraded = this.syncReturningOath();
		_properties.MeleeDefense -= upgraded ? 15 : 10;
		_properties.RangedDefense -= upgraded ? 15 : 10;
		_properties.DamageReceivedTotalMult *= upgraded ? 1.25 : 1.15;
	}

	function canTriggerBonusDamage( _attacker, _target, _damageHitpoints, _damageArmor )
	{
		local owner = this.getOwner();
		return !this.m.IsApplyingBonusDamage
			&& owner != null
			&& _attacker != null
			&& _target != null
			&& _attacker.getID() != _target.getID()
			&& _attacker.isAlliedWith(owner)
			&& !_target.isAlliedWith(owner)
			&& (_damageHitpoints > 0 || _damageArmor > 0)
			&& !::$bvvar{namespace}.isActorDeadOrDying(_attacker)
			&& !::$bvvar{namespace}.isActorDeadOrDying(_target);
	}

	function getBonusDamage( _attacker )
	{
		this.syncReturningOath();
		local owner = this.getOwner();
		return owner != null && _attacker != null && owner.getID() == _attacker.getID() ? this.m.OwnerBonusDamage : this.m.AllyBonusDamage;
	}

	function applyFixedDamage( _attacker, _target, _amount, _options = null )
	{
		if (_amount <= 0 || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local options = _options == null ? {} : clone _options;
		if (!("Source" in options)) options.Source <- "hysilens_tidal_erosion";
		if (!("BodyPart" in options)) options.BodyPart <- this.Const.BodyPart.Body;
		this.m.IsApplyingBonusDamage = true;
		local result = null;
		try
		{
			result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_attacker, this, _target, _amount, options);
		}
		catch (e)
		{
			this.m.IsApplyingBonusDamage = false;
			throw e;
		}

		this.m.IsApplyingBonusDamage = false;
		return result != null && "Applied" in result && result.Applied;
	}

	function tryApplyBonusDamageFromResolvedEvent( _event )
	{
		if (_event == null || ("Source" in _event && (_event.Source == "hysilens_tidal_erosion" || _event.Source == "hysilens_tidal_erosion_bonus"))) return false;
		local target = this.getContainer() == null ? null : this.getContainer().getActor();
		local attacker = _event != null && "Attacker" in _event ? _event.Attacker : null;
		local eventTarget = _event != null && "Victim" in _event ? _event.Victim : null;
		local hitpointDamage = _event != null && "HitpointDamage" in _event ? _event.HitpointDamage : 0;
		local armorDamage = _event != null && "ArmorDamage" in _event ? _event.ArmorDamage : 0;

		if (target == null || eventTarget == null || target.getID() != eventTarget.getID()
			|| !this.canTriggerBonusDamage(attacker, target, hitpointDamage, armorDamage))
		{
			return false;
		}

		local options = { Source = "hysilens_tidal_erosion_bonus" };
		// A resolved attempt can be relayed more than once by compatibility hooks.
		// Null tokens retain legacy behavior; tagged attempts grant one follow-up.
		if ("AttemptToken" in _event && _event.AttemptToken != null)
		{
			if ("LastBonusAttempt" in this.m && this.m.LastBonusAttempt == _event.AttemptToken) return false;
			this.m.LastBonusAttempt <- _event.AttemptToken;
		}
		if ("ActionToken" in _event && _event.ActionToken != null) options.ActionToken <- _event.ActionToken;
		if ("AttemptToken" in _event && _event.AttemptToken != null) options.AttemptToken <- _event.AttemptToken;
		return this.applyFixedDamage(attacker, target, this.getBonusDamage(attacker), options);
	}

	function onTurnEnd()
	{
		this.syncReturningOath();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			this.applyFixedDamage(actor, actor, this.m.EndTurnDamage);
		}

		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}
});
