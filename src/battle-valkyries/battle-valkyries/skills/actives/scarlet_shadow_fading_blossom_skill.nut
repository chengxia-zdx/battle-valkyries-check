this.scarlet_shadow_fading_blossom_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false,
		FadingDamageMult = 2.6,
		FadingArmorMult = 2.4,
		FadingDirectAdd = 0.30
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.scarlet_shadow_fading_blossom.killed}";
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
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 21;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
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

	function getFlyflowerEffect()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || actor.getSkills() == null)
		{
			return null;
		}

		local effect = actor.getSkills().getSkillByID("$bvvar{modId}.effects.scarlet_shadow_flyflower");

		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/scarlet_shadow_flyflower_effect");
			actor.getSkills().add(effect);
		}

		return effect;
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
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.scarlet_shadow_fading_blossom.tooltip.cost}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.scarlet_shadow_fading_blossom.tooltip.damage}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.scarlet_shadow_fading_blossom.tooltip.ready}"
			}
		];

		if (this.m.IsSpent)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.scarlet_shadow_fading_blossom.tooltip.spent}"
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
			_properties.MeleeSkill += 35;
			_properties.DamageRegularMult *= this.m.FadingDamageMult;
			_properties.DamageArmorMult *= this.m.FadingArmorMult;
			_properties.DamageDirectMeleeAdd += this.m.FadingDirectAdd;
		}
	}

	function applyStatus( _target )
	{
		if (_target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
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

		this.m.IsSpent = true;
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
		local success = this.attackEntity(_user, target, false);

		if (success)
		{
			this.applyStatus(target);
		}

		local effect = this.getFlyflowerEffect();
		if (effect != null)
		{
			effect.setUltimateReady();
		}

		_user.setActionPoints(0);
		_user.setDirty(true);
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
});
