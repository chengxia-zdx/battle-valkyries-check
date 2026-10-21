this.jingliu_moonflower_birth_and_death_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false,
		IsCurrentAttack = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.jingliu_moonflower_birth_and_death.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/slash_01.wav",
			"sounds/combat/slash_02.wav",
			"sounds/combat/slash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/slash_hit_01.wav",
			"sounds/combat/slash_hit_02.wav",
			"sounds/combat/slash_hit_03.wav"
		];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsShieldRelevant = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.HitChanceBonus = 25;
		this.m.DirectDamageMult = 0.0;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
		this.m.ChanceDecapitate = 66;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
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
				icon = "ui/icons/fatigue.png",
				text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.cost}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.hit}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.damage}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.direct}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.ap}"
			}
		];

		if (this.m.IsSpent)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.spent}"
			});
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 25;
			_properties.DamageRegularMult *= 2.0;
			_properties.DamageArmorMult *= 2.0;
			_properties.DamageDirectMeleeAdd += 0.25;
		}
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (target == null || target.isAlliedWith(_user) || ::$bvvar{namespace}.isActorDeadOrDying(target) || !target.isAttackable())
		{
			return false;
		}

		this.m.IsSpent = true;
		if ("playValkyrieVisual" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.playValkyrieVisual(this, _user, "jingliu_moonflower_cast");
			::$bvvar{namespace}.playValkyrieVisual(this, target, "jingliu_moonflower_impact");
		}
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
		this.m.IsCurrentAttack = true;
		local result = false;

		try
		{
			result = this.attackEntity(_user, target);
		}
		catch (e)
		{
			this.m.IsCurrentAttack = false;
			throw e;
		}

		this.m.IsCurrentAttack = false;
		return result;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity == null)
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

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		actor.setActionPoints(actor.getActionPointsMax());
		actor.setDirty(true);
		this.spawnIcon("status_effect_34", actor.getTile());
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
