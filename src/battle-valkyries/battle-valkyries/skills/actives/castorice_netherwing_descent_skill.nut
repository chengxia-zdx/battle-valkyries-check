this.castorice_netherwing_descent_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		MainDamageMult = 3.0,
		MainArmorDamageMult = 2.0,
		MainFixedHitpointDamage = 50,
		SecondaryDamageMult = 1.0,
		SecondaryArmorDamageMult = 1.5,
		SecondaryFixedHitpointDamage = 10,
		HealAmount = 20,
		HealRange = 3,
		NewbudCost = 100
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.castorice_netherwing_descent.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_lance_01.wav",
			"sounds/combat/dlc6/fire_lance_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/shield_hit_wood_01.wav",
			"sounds/combat/shield_hit_wood_02.wav",
			"sounds/combat/shield_hit_wood_03.wav"
		];
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 10;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.HitChanceBonus = 100;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getNewbudSkill()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getSkills() == null)
		{
			return null;
		}

		return ::$bvvar{namespace}.getRuntimeSkillByKey(actor, "castorice_newbud");
	}

	function isUsable()
	{
		local newbud = this.getNewbudSkill();
		return this.skill.isUsable() && newbud != null && newbud.hasFullNewbud();
	}

	function getTooltip()
	{
		local newbud = this.getNewbudSkill();
		local current = newbud == null ? 0 : newbud.getNewbud();
		local max = newbud == null ? this.m.NewbudCost : newbud.getNewbudMax();
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.cost}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.main}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.secondary}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/health.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.heal}"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.target}"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.guaranteed}"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.conversion}"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.newbud_prefix}" + current + "/" + max
			}
		];

		if (newbud == null || !newbud.hasFullNewbud())
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.castorice_netherwing_descent.tooltip.not_ready}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local user = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return user != null && !::$bvvar{namespace}.isActorDeadOrDying(user)
			&& target != null && !target.isAlliedWith(user) && target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target);
	}

	function rollWeaponDamage( _user, _target )
	{
		if (_user == null || this.m.Container == null)
		{
			return 0;
		}

		local properties = this.m.Container.buildPropertiesForUse(this, _target);
		local minDamage = this.Math.max(0, properties.DamageRegularMin);
		local maxDamage = this.Math.max(minDamage, properties.DamageRegularMax);
		local baseDamage = this.Math.rand(minDamage, maxDamage);
		local damageMult = properties.DamageRegularMult * properties.DamageTotalMult * (this.m.IsRanged ? properties.RangedDamageMult : properties.MeleeDamageMult);
		return this.Math.max(0, this.Math.floor(baseDamage * damageMult));
	}

	function applyWeaponDamage( _user, _target, _damageMult, _armorDamageMult )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		local weaponDamage = this.rollWeaponDamage(_user, _target);
		if (weaponDamage <= 0)
		{
			return;
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = this.Math.floor(weaponDamage * _damageMult);
		hitInfo.DamageArmor = this.Math.floor(weaponDamage * _armorDamageMult);
		hitInfo.DamageDirect = 0.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
	}

	function applyHitpointDamage( _user, _target, _amount )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || _amount <= 0 || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _amount;
		hitInfo.DamageArmor = 0;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
	}

	function isValidEnemyTarget( _user, _target )
	{
		return _user != null && !::$bvvar{namespace}.isActorDeadOrDying(_user) && _target != null && !_target.isAlliedWith(_user) && _target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(_target);
	}

	function applyNetherwingHit( _user, _target, _damageMult, _armorDamageMult, _fixedHitpointDamage )
	{
		if (!this.isValidEnemyTarget(_user, _target))
		{
			return;
		}

		this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#8c4dff"), _target.getTile(), 0, 45, 1.15, 0.25, 0, 200, 200);
		local snapshot = ::$bvvar{namespace}.getValkyrieDamageSnapshot(_target);
		this.applyWeaponDamage(_user, _target, _damageMult, _armorDamageMult);
		this.applyHitpointDamage(_user, _target, _fixedHitpointDamage);
		::$bvvar{namespace}.notifyValkyrieAttackHitFromSnapshot(_user, this, _target, this.Const.BodyPart.Body, snapshot);
	}

	function healAllies( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || !_user.isPlacedOnMap())
		{
			return;
		}

		local userTile = _user.getTile();
		local actors = this.Tactical.Entities.getAllInstancesAsArray();
		foreach( target in actors )
		{
			if (target == null || target.getID() == _user.getID() || !target.isPlacedOnMap())
			{
				continue;
			}

			if (!target.isAlliedWith(_user) || !target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				continue;
			}

			if (target.getTile().getDistanceTo(userTile) > this.m.HealRange)
			{
				continue;
			}

			target.setHitpoints(this.Math.min(target.getHitpointsMax(), target.getHitpoints() + this.m.HealAmount));
			this.spawnIcon("status_effect_34", target.getTile());
			target.setDirty(true);
		}
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (!this.isValidEnemyTarget(_user, target))
		{
			return false;
		}

		local newbud = this.getNewbudSkill();
		if (newbud == null || !newbud.spendNewbud(this.m.NewbudCost))
		{
			return false;
		}

		this.applyNetherwingHit(_user, target, this.m.MainDamageMult, this.m.MainArmorDamageMult, this.m.MainFixedHitpointDamage);

		for( local i = 0; i != 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
				continue;
			}

			local nextTile = _targetTile.getNextTile(i);
			if (nextTile == null || !nextTile.IsOccupiedByActor)
			{
				continue;
			}

			local secondary = nextTile.getEntity();
			if (secondary == null || secondary.getID() == target.getID())
			{
				continue;
			}

			this.applyNetherwingHit(_user, secondary, this.m.SecondaryDamageMult, this.m.SecondaryArmorDamageMult, this.m.SecondaryFixedHitpointDamage);
		}

		this.healAllies(_user);
		if ("consumeSpringGrowth" in ::$bvvar{namespace}) ::$bvvar{namespace}.consumeSpringGrowth(_user, "castorice");
		return true;
	}
});
