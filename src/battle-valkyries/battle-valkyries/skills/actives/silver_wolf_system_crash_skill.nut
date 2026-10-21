this.silver_wolf_system_crash_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false,
		FixedDamage = 10,
		StrikeCount = 5
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.silver_wolf_system_crash.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_01.wav",
			"sounds/enemies/horror_spell_02.wav",
			"sounds/combat/dlc6/daze_bomb_01.wav",
			"sounds/combat/dlc6/daze_bomb_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 100;
		this.m.DirectDamageMult = 0.0;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 99;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getActionPointCost()
	{
		return 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.silver_wolf_system_crash.tooltip.hit}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.silver_wolf_system_crash.tooltip.damage}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.silver_wolf_system_crash.tooltip.special}"
			}
		];

		if (this.m.IsSpent)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.silver_wolf_system_crash.tooltip.spent}"
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
		return user != null && !::$bvvar{namespace}.isActorDeadOrDying(user)
			&& target != null && !target.isAlliedWith(user) && !::$bvvar{namespace}.isActorDeadOrDying(target) && target.isAttackable();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 100;
			_properties.RangedSkill += 100;
			_properties.DamageRegularMin = this.m.FixedDamage;
			_properties.DamageRegularMax = this.m.FixedDamage;
			_properties.DamageRegularMult = 1.0;
			_properties.DamageArmorMult = 1.0;
			_properties.DamageDirectAdd = 0.0;
			_properties.DamageDirectMeleeAdd = 0.0;
			_properties.DamageDirectRangedAdd = 0.0;
			_properties.DamageDirectMult = 1.0;
			_properties.DamageTotalMult = 1.0;
			_properties.MeleeDamageMult = 1.0;
			_properties.RangedDamageMult = 1.0;
		}
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || target.isAlliedWith(_user) || !target.isAttackable())
		{
			return false;
		}

		this.m.IsSpent = true;
		if ("playValkyrieVisual" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.playValkyrieVisual(this, target, "silver_wolf_system_crash");
		}

		for( local i = 0; i < this.m.StrikeCount; i = ++i )
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(_user) || target == null || ::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				break;
			}

			this.attackEntity(_user, target, false);
		}

		if (target != null && !::$bvvar{namespace}.isActorDeadOrDying(target) && !target.getCurrentProperties().IsImmuneToStun)
		{
			local stun = target.getSkills().getSkillByID("effects.stunned");

			if (stun == null)
			{
				stun = this.new("scripts/skills/effects/stunned_effect");
				target.getSkills().add(stun);
			}
			else
			{
				stun.setTurns(1);
			}

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(stun.getLogEntryOnAdded(this.Const.UI.getColorizedEntityName(_user), this.Const.UI.getColorizedEntityName(target)));
			}
		}

		return true;
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.skill.onCombatFinished();
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeBool(this.m.IsSpent);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.IsSpent = _in.readBool();
	}
});
