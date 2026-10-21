this.valkyrie_generic_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		Spec = null,
		HasTriggeredThisTurn = false,
		HasMoraleTriggeredThisTurn = false,
		HasEffectTriggeredThisTurn = false,
		HasRecoveredAPThisTurn = false,
		LastOriginalSkill = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if ("Tooltip" in this.m.Spec)
		{
			local id = 3;
			foreach( row in this.m.Spec.Tooltip )
			{
				ret.push({
					id = id,
					type = "text",
					icon = "Icon" in row ? row.Icon : "ui/icons/special.png",
					text = row.Text
				});
				id = ++id;
			}
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		if ("Bonuses" in this.m.Spec)
		{
			::$bvvar{namespace}.applyValkyrieFlatBonuses(_properties, this.m.Spec.Bonuses);
		}

		local actor = this.getContainer().getActor();
		if ("LowHpBonuses" in this.m.Spec && ::$bvvar{namespace}.getActorHitpointRatio(actor) < this.m.Spec.LowHpBonuses.Threshold)
		{
			local bonuses = clone this.m.Spec.LowHpBonuses;
			delete bonuses.Threshold;
			::$bvvar{namespace}.applyValkyrieFlatBonuses(_properties, bonuses);
		}

		if ("LowHpDamageReduction" in this.m.Spec && ::$bvvar{namespace}.getActorHitpointRatio(actor) < this.m.Spec.LowHpDamageReduction.Threshold)
		{
			_properties.DamageReceivedTotalMult *= this.m.Spec.LowHpDamageReduction.Mult;
		}

		if ("DamageReductionMult" in this.m.Spec)
		{
			_properties.DamageReceivedTotalMult *= this.m.Spec.DamageReductionMult;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if ("AttackBonus" in this.m.Spec)
		{
			local bonus = this.m.Spec.AttackBonus;
			local attackType = "AttackType" in bonus ? bonus.AttackType : "any";
			if (::$bvvar{namespace}.doesSkillMatchAttackType(_skill, attackType))
			{
				if ("HitChance" in bonus)
				{
					_properties.MeleeSkill += bonus.HitChance;
					_properties.RangedSkill += bonus.HitChance;
				}

				if ("DamageMult" in bonus)
				{
					_properties.DamageTotalMult *= bonus.DamageMult;
				}
			}
		}

		if ("IgnoreArmor" in this.m.Spec)
		{
			local ignoreArmor = this.m.Spec.IgnoreArmor;
			local attackType = "AttackType" in ignoreArmor ? ignoreArmor.AttackType : "any";
			if (::$bvvar{namespace}.doesSkillMatchAttackType(_skill, attackType))
			{
				_properties.DamageArmorMult *= 0.0;
				_properties.DamageDirectAdd += 1.0;
				_properties.IsIgnoringArmorOnAttack = true;
			}
		}
	}

	function onTurnStart()
	{
		this.m.HasTriggeredThisTurn = false;
		this.m.HasMoraleTriggeredThisTurn = false;
		this.m.HasEffectTriggeredThisTurn = false;
		this.m.HasRecoveredAPThisTurn = false;
	}

	function isValidTarget( _user, _targetEntity )
	{
		return _user != null && !::$bvvar{namespace}.isActorDeadOrDying(_user)
			&& _targetEntity != null && !::$bvvar{namespace}.isActorDeadOrDying(_targetEntity)
			&& !_targetEntity.isAlliedWith(_user) && _targetEntity.isAttackable();
	}

	function applyExtraHitDamage( _user, _targetEntity, _damage, _originalSkill = null, _options = null )
	{
		if (_damage <= 0 || !this.isValidTarget(_user, _targetEntity))
		{
			return false;
		}

		this.m.LastOriginalSkill = _originalSkill;
		local options = _options == null ? {} : clone _options;
		if (!("Source" in options)) options.Source <- "valkyrie_generic_passive_bonus";
		if (!("BodyPart" in options)) options.BodyPart <- this.Const.BodyPart.Body;
		local result = null;

		try
		{
			result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, _targetEntity, _damage, options);
		}
		catch (e)
		{
			this.m.LastOriginalSkill = null;
			throw e;
		}

		this.m.LastOriginalSkill = null;
		return result != null && "Applied" in result && result.Applied;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved"
			|| !("Attacker" in _event) || !("Skill" in _event) || !("Victim" in _event))
		{
			return;
		}

		local user = this.getContainer().getActor();
		local attacker = _event.Attacker;
		local skill = _event.Skill;
		local target = _event.Victim;
		if (user == null || attacker == null || user.getID() != attacker.getID()
			|| !this.isValidTarget(user, target) || skill == null || skill == this || !skill.isAttack())
		{
			return;
		}

		local options = { Source = "valkyrie_generic_passive_bonus" };
		if ("ActionToken" in _event && _event.ActionToken != null) options.ActionToken <- _event.ActionToken;
		if ("AttemptToken" in _event && _event.AttemptToken != null) options.AttemptToken <- _event.AttemptToken;

		if ("FirstHitBonusDamage" in this.m.Spec && !this.m.HasTriggeredThisTurn)
		{
			local bonus = this.m.Spec.FirstHitBonusDamage;
			if (::$bvvar{namespace}.doesSkillMatchAttackType(skill, bonus.AttackType))
			{
				this.m.HasTriggeredThisTurn = true;
				local damage = bonus.Damage;
				if ("LowHpThreshold" in bonus && ::$bvvar{namespace}.getActorHitpointRatio(target) < bonus.LowHpThreshold)
				{
					damage = bonus.LowHpDamage;
				}
				this.applyExtraHitDamage(user, target, damage, skill, options);
			}
		}

		if ("HitBonusDamage" in this.m.Spec)
		{
			local hitBonus = this.m.Spec.HitBonusDamage;
			local attackType = "AttackType" in hitBonus ? hitBonus.AttackType : "any";
			if (::$bvvar{namespace}.doesSkillMatchAttackType(skill, attackType))
			{
				local damage = hitBonus.Damage;
				if ("LowHpThreshold" in hitBonus && ::$bvvar{namespace}.getActorHitpointRatio(target) < hitBonus.LowHpThreshold)
				{
					damage = hitBonus.LowHpDamage;
				}
				this.applyExtraHitDamage(user, target, damage, skill, options);
			}
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local user = this.getContainer().getActor();
		if (!this.isValidTarget(user, _targetEntity) || _skill == null || !_skill.isAttack())
		{
			return;
		}

		if ("FirstDamagingHitMorale" in this.m.Spec && !this.m.HasMoraleTriggeredThisTurn && _damageInflictedHitpoints > 0)
		{
			this.m.HasMoraleTriggeredThisTurn = true;
			::$bvvar{namespace}.applyMentalMoraleCheck(_targetEntity, this.m.Spec.FirstDamagingHitMorale.Penalty);
		}

		if ("DamagingHitMorale" in this.m.Spec && _damageInflictedHitpoints > 0)
		{
			::$bvvar{namespace}.applyMentalMoraleCheck(_targetEntity, this.m.Spec.DamagingHitMorale.Penalty);
		}

		if ("HitMorale" in this.m.Spec)
		{
			local hitMorale = this.m.Spec.HitMorale;
			local attackType = "AttackType" in hitMorale ? hitMorale.AttackType : "any";
			if (::$bvvar{namespace}.doesSkillMatchAttackType(_skill, attackType))
			{
				::$bvvar{namespace}.applyMentalMoraleCheck(_targetEntity, hitMorale.Penalty);
			}
		}

		if ("FirstHitEffect" in this.m.Spec && !this.m.HasEffectTriggeredThisTurn)
		{
			local firstEffect = this.m.Spec.FirstHitEffect;
			local attackType = "AttackType" in firstEffect ? firstEffect.AttackType : "any";
			if (::$bvvar{namespace}.doesSkillMatchAttackType(_skill, attackType))
			{
				this.m.HasEffectTriggeredThisTurn = true;
				::$bvvar{namespace}.applyStatusEffects(user, _targetEntity, firstEffect.Effects);
			}
		}

		if ("HitEffect" in this.m.Spec)
		{
			local hitEffect = this.m.Spec.HitEffect;
			local attackType = "AttackType" in hitEffect ? hitEffect.AttackType : "any";
			if (::$bvvar{namespace}.doesSkillMatchAttackType(_skill, attackType))
			{
				::$bvvar{namespace}.applyStatusEffects(user, _targetEntity, hitEffect.Effects);
			}
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (!("RecoverAPOnKill" in this.m.Spec))
		{
			return;
		}

		local recover = this.m.Spec.RecoverAPOnKill;
		local attackType = "AttackType" in recover ? recover.AttackType : "any";
		local effectiveSkill = _skill;
		if (_skill == this && this.m.LastOriginalSkill != null)
		{
			effectiveSkill = this.m.LastOriginalSkill;
		}

		if (!::$bvvar{namespace}.doesSkillMatchAttackType(effectiveSkill, attackType))
		{
			return;
		}

		local actor = this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || _targetEntity == null || actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		local amount = "Amount" in recover ? recover.Amount : 0;
		if (amount <= 0)
		{
			return;
		}

		if (this.m.HasRecoveredAPThisTurn)
		{
			return;
		}

		this.m.HasRecoveredAPThisTurn = true;
		actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + amount));
		actor.setDirty(true);
		if (actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}
	}

	function onCombatStarted()
	{
		this.onTurnStart();
	}

	function onCombatFinished()
	{
		this.onTurnStart();
		this.skill.onCombatFinished();
	}
});
