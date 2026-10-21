this.liuying_molten_drive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.liuying_molten_drive.killed}";
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
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.HitChanceBonus = 100;
		this.m.DirectDamageMult = 0.35;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 18;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 35;
	}

	function isUltimateUnlocked()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || actor.getSkills() == null)
		{
			return false;
		}

		local trait = actor.getSkills().getSkillByID(::$bvvar{namespace}.LiuyingBondTraitID);
		return trait != null && trait.hasUltimateSkillUnlocked();
	}

	function getActionPointCost()
	{
		return this.isUltimateUnlocked() ? 3 : 4;
	}

	function getFatigueCost()
	{
		return this.isUltimateUnlocked() ? 14 : 18;
	}

	function getFixedDamage()
	{
		return this.isUltimateUnlocked() ? 140 : 110;
	}

	function getArmorDamageMult()
	{
		return this.isUltimateUnlocked() ? 1.90 : 1.60;
	}

	function getArmorDamage()
	{
		return this.Math.floor(this.getFixedDamage() * this.getArmorDamageMult());
	}

	function isUsable()
	{
		return this.skill.isUsable()
			&& this.getContainer() != null
			&& this.getContainer().hasSkill("$bvvar{modId}.effects.liuying_glamoth_cavalry");
	}

	function getTooltip()
	{
		local damage = this.getFixedDamage();
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
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.liuying_molten_drive.tooltip.damage_prefix}" + "[color=" + this.Const.UI.Color.DamageValue + "]" + damage + "[/color]" + "$bv{skill.liuying_molten_drive.tooltip.damage_suffix}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "$bv{skill.liuying_molten_drive.tooltip.armor_prefix}" + "[color=" + this.Const.UI.Color.DamageValue + "]" + this.getArmorDamage() + "[/color]" + "$bv{skill.liuying_molten_drive.tooltip.armor_suffix}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = this.isUltimateUnlocked() ? "$bv{skill.liuying_molten_drive.tooltip.upgraded_hit}" : "$bv{skill.liuying_molten_drive.tooltip.hit}"
			}
		];

		if (this.isUltimateUnlocked())
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.liuying_molten_drive.tooltip.upgraded_status}"
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
			&& target != null && !target.isAlliedWith(user) && !::$bvvar{namespace}.isActorDeadOrDying(target) && target.isAttackable();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local damage = this.getFixedDamage();
			_properties.MeleeSkill += this.isUltimateUnlocked() ? 30 : 20;
			_properties.DamageRegularMin = damage;
			_properties.DamageRegularMax = damage;
			_properties.DamageRegularMult = 1.0;
			_properties.DamageArmorMult = this.getArmorDamageMult();
			_properties.DamageDirectAdd = 0.0;
			_properties.DamageDirectMeleeAdd = 0.0;
			_properties.DamageDirectRangedAdd = 0.0;
			_properties.DamageDirectMult = 1.0;
			_properties.DamageTotalMult = 1.0;
			_properties.MeleeDamageMult = 1.0;
			_properties.RangedDamageMult = 1.0;
		}
	}

	function applyUpgradedStatus( _target )
	{
		if (!this.isUltimateUnlocked() || _target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
		_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
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

		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, target, false);

		if (success)
		{
			this.applyUpgradedStatus(target);
		}

		return true;
	}
});
