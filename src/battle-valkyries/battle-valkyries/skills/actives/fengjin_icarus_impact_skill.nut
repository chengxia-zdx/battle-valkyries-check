this.fengjin_icarus_impact_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		RegularDamageMult = 0.8,
		ArmorDamageMult = 1.0
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.fengjin_icarus_impact.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/daze_bomb_01.wav",
			"sounds/combat/dlc6/daze_bomb_02.wav"
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
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.fengjin_icarus_impact.tooltip.cost}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "$bv{skill.fengjin_icarus_impact.tooltip.armor}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.fengjin_icarus_impact.tooltip.hp}"
			}
		];
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

	function applyWeaponDamage( _user, _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		local weaponDamage = this.rollWeaponDamage(_user, _target);
		if (weaponDamage <= 0)
		{
			return;
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = this.Math.floor(weaponDamage * this.m.RegularDamageMult);
		hitInfo.DamageArmor = this.Math.floor(weaponDamage * this.m.ArmorDamageMult);
		hitInfo.DamageDirect = 0.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
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

		this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#8be8ff"), target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		local snapshot = ::$bvvar{namespace}.getValkyrieDamageSnapshot(target);
		this.applyWeaponDamage(_user, target);
		::$bvvar{namespace}.notifyValkyrieAttackHitFromSnapshot(_user, this, target, this.Const.BodyPart.Body, snapshot);
		return true;
	}
});
