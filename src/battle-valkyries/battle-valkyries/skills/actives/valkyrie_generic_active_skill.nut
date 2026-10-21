this.valkyrie_generic_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Spec = null,
		IsSpent = false,
		UsesSpent = 0,
		IsCurrentAttack = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.KilledString = "KilledString" in this.m.Spec ? this.m.Spec.KilledString : "$bv{skill.generic.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = ["sounds/combat/dlc6/daze_bomb_01.wav", "sounds/combat/dlc6/daze_bomb_02.wav"];
		this.m.SoundOnHit = ["sounds/combat/shield_hit_wood_01.wav", "sounds/combat/shield_hit_wood_02.wav", "sounds/combat/shield_hit_wood_03.wav"];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = this.m.Spec.IsAttack;
		this.m.IsRanged = this.m.Spec.IsAttack && this.m.Spec.AttackType == "ranged";
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = this.m.Spec.IsAttack && this.m.Spec.DamageMode == "weapon";
		this.m.IsShieldRelevant = this.m.Spec.IsAttack && this.m.Spec.DamageMode == "weapon";
		this.m.IsVisibleTileNeeded = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.HitChanceBonus = "HitChance" in this.m.Spec ? this.m.Spec.HitChance : 0;
		this.m.DirectDamageMult = "DirectDamage" in this.m.Spec ? this.m.Spec.DirectDamage : 0.0;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = this.m.Spec.MinRange;
		this.m.MaxRange = this.m.Spec.MaxRange;
		this.m.MaxLevelDifference = 99;
		this.m.ChanceDecapitate = this.m.Spec.IsAttack ? 25 : 0;
		this.m.ChanceDisembowel = this.m.Spec.IsAttack ? 15 : 0;
		this.m.ChanceSmash = 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getRemainingUses() > 0;
	}

	function getMaxUses()
	{
		return "MaxUses" in this.m.Spec ? this.Math.max(1, this.m.Spec.MaxUses) : 1;
	}

	function getRemainingUses()
	{
		return this.Math.max(0, this.getMaxUses() - this.m.UsesSpent);
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
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = this.getMaxUses() == 1 ? "$bv{skill.generic.once_free}" : "$bv{skill.generic.three_uses_free}"
			}
		];

		local id = 4;
		if ("Tooltip" in this.m.Spec)
		{
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

		if (this.getRemainingUses() <= 0)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.generic.spent}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local user = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || ::$bvvar{namespace}.isActorDeadOrDying(user))
		{
			return false;
		}

		if (this.m.Spec.Target == "ally")
		{
			return target.getID() != user.getID() && target.isAlliedWith(user) && target.isAttackable();
		}

		if (this.m.Spec.Target == "self")
		{
			return target.getID() == user.getID() && target.isAttackable();
		}

		return !target.isAlliedWith(user) && target.isAttackable();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this || !this.m.Spec.IsAttack)
		{
			return;
		}

		if ("HitChance" in this.m.Spec)
		{
			_properties.MeleeSkill += this.m.Spec.HitChance;
			_properties.RangedSkill += this.m.Spec.HitChance;
		}

		if (this.m.Spec.DamageMode == "fixed")
		{
			_properties.DamageRegularMin = this.m.Spec.FixedDamage;
			_properties.DamageRegularMax = this.m.Spec.FixedDamage;
			_properties.DamageRegularMult = 1.0;
			_properties.DamageArmorMult = this.m.Spec.ArmorDamageMult;
			_properties.DamageDirectAdd = 0.0;
			_properties.DamageDirectMeleeAdd = 0.0;
			_properties.DamageDirectRangedAdd = 0.0;
			_properties.DamageDirectMult = 1.0;
			_properties.DamageTotalMult = 1.0;
			_properties.MeleeDamageMult = 1.0;
			_properties.RangedDamageMult = 1.0;
		}
		else if (this.m.Spec.DamageMode == "weapon")
		{
			_properties.DamageRegularMult *= this.m.Spec.WeaponDamageMult;
			_properties.DamageArmorMult *= this.m.Spec.ArmorDamageMult;

			if ("DirectDamageAdd" in this.m.Spec)
			{
				_properties.DamageDirectMeleeAdd += this.m.Spec.DirectDamageAdd;
				_properties.DamageDirectRangedAdd += this.m.Spec.DirectDamageAdd;
			}
		}
	}

	function restoreTargetArmorSlot( _target, _bodyPart, _itemSlot )
	{
		local item = null;

		try
		{
			item = _target.getItems().getItemAtSlot(_itemSlot);
		}
		catch (e)
		{
			item = null;
		}

		if (item != null)
		{
			item.setArmor(item.getArmorMax());
		}

		_target.getBaseProperties().Armor[_bodyPart] = _target.getBaseProperties().ArmorMax[_bodyPart];
	}

	function restoreTargetArmor( _target )
	{
		this.restoreTargetArmorSlot(_target, this.Const.BodyPart.Head, this.Const.ItemSlot.Head);
		this.restoreTargetArmorSlot(_target, this.Const.BodyPart.Body, this.Const.ItemSlot.Body);
	}

	function clearTargetPermanentInjurySprites( _target )
	{
		for( local i = 1; i <= 4; i = ++i )
		{
			try
			{
				local sprite = _target.getSprite("permanent_injury_" + i);

				if (sprite != null)
				{
					sprite.Visible = false;
					sprite.resetBrush();
				}
			}
			catch (e)
			{
			}
		}
	}

	function restoreTargetInjuries( _target )
	{
		_target.getSkills().removeByType(this.Const.SkillType.Injury);

		try
		{
			_target.updateInjuryVisuals();
		}
		catch (e)
		{
		}

		this.clearTargetPermanentInjurySprites(_target);
		_target.getSkills().update();
		_target.setDirty(true);
	}

	function applyDirectEffects( _user, _target )
	{
		if ("SetTargetAP" in this.m.Spec)
		{
			if (this.m.Spec.SetTargetAP == "max")
			{
				_target.setActionPoints(_target.getActionPointsMax());
			}
			else
			{
				_target.setActionPoints(this.Math.max(0, this.m.Spec.SetTargetAP));
			}
			_target.setDirty(true);
		}

		if ("RestoreTargetVitals" in this.m.Spec && this.m.Spec.RestoreTargetVitals)
		{
			_target.setHitpoints(_target.getHitpointsMax());
			this.restoreTargetArmor(_target);
			_target.getSkills().update();
			_target.setDirty(true);
		}

		if ("RestoreTargetInjuries" in this.m.Spec && this.m.Spec.RestoreTargetInjuries)
		{
			this.restoreTargetInjuries(_target);
		}

		if ("MoraleCheck" in this.m.Spec)
		{
			local moraleChecks = "MoraleChecks" in this.m.Spec ? this.Math.max(1, this.m.Spec.MoraleChecks) : 1;
			for (local i = 0; i < moraleChecks; i = ++i)
			{
				::$bvvar{namespace}.applyMentalMoraleCheck(_target, this.m.Spec.MoraleCheck);
			}
		}

		if ("Effects" in this.m.Spec)
		{
			::$bvvar{namespace}.applyStatusEffects(_user, _target, this.m.Spec.Effects);
		}
	}

	function playConfiguredVisuals( _user, _target )
	{
		if (!("playValkyrieVisual" in ::$bvvar{namespace})) return;
		if ("VisualThemeOwner" in this.m.Spec) ::$bvvar{namespace}.playValkyrieVisual(this, _user, this.m.Spec.VisualThemeOwner);
		if ("VisualThemeTarget" in this.m.Spec) ::$bvvar{namespace}.playValkyrieVisual(this, _target, this.m.Spec.VisualThemeTarget);
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return false;
		}

		this.m.UsesSpent = this.Math.min(this.getMaxUses(), this.m.UsesSpent + 1);
		this.m.IsSpent = this.getRemainingUses() <= 0;

		if (!this.m.Spec.IsAttack)
		{
			this.playConfiguredVisuals(_user, target);
			this.applyDirectEffects(_user, target);
			if (_user.isPlacedOnMap())
			{
				this.spawnIcon("status_effect_34", _user.getTile());
			}
			return true;
		}

		// Play configured attack effects before resolution: lethal hits may detach
		// the target from the tactical map before any post-hit effect can render.
		this.playConfiguredVisuals(_user, target);

		if (this.m.Spec.AttackType == "melee")
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
		}
		else if (!("VisualThemeTarget" in this.m.Spec))
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#7ddcff"), target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		}

		this.m.IsCurrentAttack = true;
		local success = false;

		try
		{
			success = this.attackEntity(_user, target, false);
		}
		catch (e)
		{
			this.m.IsCurrentAttack = false;
			throw e;
		}

		this.m.IsCurrentAttack = false;
		if (success && target != null && !::$bvvar{namespace}.isActorDeadOrDying(target) && "EffectsOnHit" in this.m.Spec)
		{
			::$bvvar{namespace}.applyStatusEffects(_user, target, this.m.Spec.EffectsOnHit);
		}

		if ("RecoverAPOnUse" in this.m.Spec && !::$bvvar{namespace}.isActorDeadOrDying(_user))
		{
			if (this.m.Spec.RecoverAPOnUse == "max")
			{
				_user.setActionPoints(_user.getActionPointsMax());
			}
			else
			{
				_user.setActionPoints(this.Math.min(_user.getActionPointsMax(), _user.getActionPoints() + this.m.Spec.RecoverAPOnUse));
			}

			_user.setDirty(true);
			if (_user.isPlacedOnMap())
			{
				this.spawnIcon("status_effect_34", _user.getTile());
			}
		}

		return true;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local hasAPRecover = "RecoverAPOnKill" in this.m.Spec;
		local hasFatigueMult = "FatigueMultOnKill" in this.m.Spec;
		if ((!hasAPRecover && !hasFatigueMult) || _targetEntity == null)
		{
			return;
		}

		if (_skill != this && !this.m.IsCurrentAttack)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		local changed = false;
		if (hasAPRecover)
		{
			if (this.m.Spec.RecoverAPOnKill == "max")
			{
				actor.setActionPoints(actor.getActionPointsMax());
			}
			else
			{
				actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + this.m.Spec.RecoverAPOnKill));
			}
			changed = true;
		}

		if (hasFatigueMult)
		{
			local newFatigue = this.Math.floor(actor.getFatigue() * this.m.Spec.FatigueMultOnKill);
			actor.setFatigue(this.Math.max(0, this.Math.min(actor.getFatigueMax(), newFatigue)));
			changed = true;
		}

		if (!changed)
		{
			return;
		}

		actor.setDirty(true);
		if (actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
		this.m.UsesSpent = 0;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.m.UsesSpent = 0;
		this.skill.onCombatFinished();
	}
});
