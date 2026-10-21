this.castorice_cocoon_drain_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		ArmorDamageMult = 1.5,
		FixedHitpointDamage = 10,
		HitpointCost = 10,
		NewbudOnUse = 25,
		NewbudOnKill = 25
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.castorice_cocoon_drain.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/daze_bomb_01.wav",
			"sounds/combat/dlc6/daze_bomb_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 20;
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

	function getHitpointCost( actor )
	{
		local bv = ::$bvvar{namespace};
		return "hasLiuchunFlow" in bv && bv.hasLiuchunFlow(actor) ? 0 : this.m.HitpointCost;
	}

	function hasEnoughHitpoints( _actor )
	{
		if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
		{
			return false;
		}

		if (_actor.getHitpoints() <= this.getHitpointCost(_actor))
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable() && this.hasEnoughHitpoints(actor);
	}

	function getTooltip()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
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
				text = this.getHitpointCost(actor) == 0 ? "$bv{skill.castorice_cocoon_drain.tooltip.liuchun}" : "$bv{skill.castorice_cocoon_drain.tooltip.cost}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "$bv{skill.castorice_cocoon_drain.tooltip.armor}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.castorice_cocoon_drain.tooltip.hp}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.castorice_cocoon_drain.tooltip.newbud}"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.castorice_cocoon_drain.tooltip.guaranteed}"
			}
		];

		if (actor != null && !this.hasEnoughHitpoints(actor))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.castorice_cocoon_drain.tooltip.not_enough_hp}"
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

	function payHitpointCost( _user )
	{
		if (!this.hasEnoughHitpoints(_user))
		{
			return false;
		}

		local cost = this.getHitpointCost(_user);
		if (cost == 0) return true;
		_user.setHitpoints(_user.getHitpoints() - cost);
		_user.setDirty(true);
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (target == null || target.isAlliedWith(_user) || !target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return false;
		}

		if (!this.payHitpointCost(_user))
		{
			return false;
		}

		local newbud = this.getNewbudSkill();
		this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#b88cff"), target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		local snapshot = ::$bvvar{namespace}.getValkyrieDamageSnapshot(target);
		this.applyWeaponDamage(_user, target, 1.0, this.m.ArmorDamageMult);
		this.applyHitpointDamage(_user, target, this.m.FixedHitpointDamage);
		::$bvvar{namespace}.notifyValkyrieAttackHitFromSnapshot(_user, this, target, this.Const.BodyPart.Body, snapshot);

		if (newbud != null && !::$bvvar{namespace}.isActorDeadOrDying(_user))
		{
			newbud.addNewbud(this.m.NewbudOnUse);
			if (::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				newbud.addNewbud(this.m.NewbudOnKill);
			}
		}

		return true;
	}
});
