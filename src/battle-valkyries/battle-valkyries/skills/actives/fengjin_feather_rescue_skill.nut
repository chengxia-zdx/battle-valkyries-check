this.fengjin_feather_rescue_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		HealAmount = 20
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/first_aid_01.wav",
			"sounds/combat/first_aid_02.wav"
		];
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 20;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 0;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
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
				text = "$bv{skill.fengjin_feather_rescue.tooltip.cost}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/health.png",
				text = "$bv{skill.fengjin_feather_rescue.tooltip.heal}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.fengjin_feather_rescue.tooltip.cleanse}"
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
			&& target != null && target.isAlliedWith(user) && target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target);
	}

	function removeStatusIfPresent( _skills, _id )
	{
		while (_skills.hasSkill(_id))
		{
			_skills.removeByID(_id);
		}
	}

	function clearRootSprites( _target )
	{
		try
		{
			_target.getSprite("status_rooted").Visible = false;
			_target.getSprite("status_rooted_back").Visible = false;
		}
		catch (e)
		{
		}
	}

	function clearNegativeStatusEffects( _target )
	{
		if (_target == null || _target.getSkills() == null)
		{
			return;
		}

		local skills = _target.getSkills();
		local ids = [
			"$bvvar{modId}.effects.spring_root_parasite",
			"effects.stunned",
			"effects.dazed",
			"effects.staggered",
			"effects.disarmed",
			"effects.goblin_poison",
			"effects.spider_poison",
			"effects.bleeding",
			"effects.net",
			"effects.rooted",
			"effects.web",
			"effects.kraken_ensnare",
			"effects.serpent_ensnare",
			"effects.sleeping",
			"effects.horrified",
			"effects.nightmare",
			"effects.distracted",
			"effects.withered"
		];

		foreach( id in ids )
		{
			this.removeStatusIfPresent(skills, id);
		}

		if (skills.hasSkill("actives.break_free"))
		{
			skills.removeByID("actives.break_free");
		}

		this.clearRootSprites(_target);
		skills.update();
		_target.setDirty(true);
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (target == null || !target.isAlliedWith(_user) || !target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return false;
		}

		target.setHitpoints(this.Math.min(target.getHitpointsMax(), target.getHitpoints() + this.m.HealAmount));
		this.clearNegativeStatusEffects(target);
		this.spawnIcon("status_effect_34", _targetTile);
		if ("consumeSpringGrowth" in ::$bvvar{namespace}) ::$bvvar{namespace}.consumeSpringGrowth(_user, "fengjin");
		return true;
	}
});
