this.aglaea_seam_stitch_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		BaseSeamDamage = 30,
		SupremeBonusDamage = 20,
		APRecovery = 2,
		FatigueRecoveryOnKill = 10,
		LastSkillCounter = -1,
		LastTargetID = -1,
		LastTargetHadSeam = false,
		LastAPRewardCounter = -1,
		LastAPRewardTargetID = -1,
		LastKillRewardCounter = -1,
		LastKillRewardTargetID = -1,
		IsApplyingSeamDamage = false
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
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
				icon = "ui/icons/special.png",
				text = "$bv{skill.aglaea_seam_stitch.tooltip.mark}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.aglaea_seam_stitch.tooltip.damage}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.aglaea_seam_stitch.tooltip.ap}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "$bv{skill.aglaea_seam_stitch.tooltip.kill}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.aglaea_seam_stitch.tooltip.supreme}"
			}
		];
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function isValidEnemy( _actor, _target )
	{
		return _actor != null && _target != null && !_target.isAlliedWith(_actor) && !::$bvvar{namespace}.isActorDeadOrDying(_actor);
	}

	function isAttackableEnemy( _actor, _target )
	{
		return this.isValidEnemy(_actor, _target) && _target.isAttackable() && !::$bvvar{namespace}.isActorDeadOrDying(_target);
	}

	function isTrackedAttack( _skill, _target )
	{
		if (_skill == null || _skill == this || !_skill.isAttack())
		{
			return false;
		}

		local actor = this.getActor();
		return this.isAttackableEnemy(actor, _target);
	}

	function getSeamEffect( _target )
	{
		if (_target == null || _target.getSkills() == null)
		{
			return null;
		}

		return _target.getSkills().getSkillByID("$bvvar{modId}.effects.aglaea_seam_stitch");
	}

	function hasSeam( _target )
	{
		return this.getSeamEffect(_target) != null;
	}

	function addSeam( _target )
	{
		if (_target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return null;
		}

		local effect = this.getSeamEffect(_target);

		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/aglaea_seam_stitch_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}

		return effect;
	}

	function hasSupremeStance( _actor )
	{
		return _actor != null && _actor.getSkills() != null && _actor.getSkills().hasSkill("$bvvar{modId}.effects.aglaea_supreme_stance");
	}

	function getCurrentSeamDamage()
	{
		local actor = this.getActor();
		return this.m.BaseSeamDamage + (this.hasSupremeStance(actor) ? this.m.SupremeBonusDamage : 0);
	}

	function rewardAPOnce( _actor, _targetID, _counter )
	{
		if (_actor == null || _targetID == null || _counter == null)
		{
			return false;
		}

		if (this.m.LastAPRewardCounter == _counter && this.m.LastAPRewardTargetID == _targetID)
		{
			return false;
		}

		this.m.LastAPRewardCounter = _counter;
		this.m.LastAPRewardTargetID = _targetID;
		_actor.setActionPoints(this.Math.min(_actor.getActionPointsMax(), _actor.getActionPoints() + this.m.APRecovery));
		_actor.setDirty(true);

		if (_actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", _actor.getTile());
		}

		return true;
	}

	function rewardKillOnce( _actor, _targetID, _counter )
	{
		if (_actor == null || _targetID == null || _counter == null)
		{
			return;
		}

		if (this.m.LastKillRewardCounter == _counter && this.m.LastKillRewardTargetID == _targetID)
		{
			return;
		}

		this.m.LastKillRewardCounter = _counter;
		this.m.LastKillRewardTargetID = _targetID;
		this.rewardAPOnce(_actor, _targetID, _counter);
		_actor.setFatigue(this.Math.max(0, _actor.getFatigue() - this.m.FatigueRecoveryOnKill));
		_actor.setDirty(true);
	}

	function applySeamDamage( _actor, _target, _damage, _options = null )
	{
		if (_actor == null || _target == null || _damage <= 0 || ::$bvvar{namespace}.isActorDeadOrDying(_actor) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		if (_target.isPlacedOnMap())
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#f2d56b"), _target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		}

		local options = _options == null ? {} : clone _options;
		if (!("Source" in options)) options.Source <- "aglaea_seam_stitch";
		if (!("BodyPart" in options)) options.BodyPart <- this.Const.BodyPart.Body;
		this.m.IsApplyingSeamDamage = true;
		local result = null;

		try
		{
			result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_actor, this, _target, _damage, options);
		}
		catch (e)
		{
			this.m.IsApplyingSeamDamage = false;
			throw e;
		}

		this.m.IsApplyingSeamDamage = false;
		return result != null && "Applied" in result && result.Applied;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (!this.isTrackedAttack(_skill, _targetEntity))
		{
			return;
		}

		this.m.LastSkillCounter = this.Const.SkillCounter;
		this.m.LastTargetID = _targetEntity.getID();
		this.m.LastTargetHadSeam = this.hasSeam(_targetEntity);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved"
			|| !("Attacker" in _event) || !("Skill" in _event) || !("Victim" in _event))
		{
			return;
		}

		local actor = this.getActor();
		local target = _event.Victim;
		local attacker = _event.Attacker;
		local skill = _event.Skill;
		if (actor == null || attacker == null || actor.getID() != attacker.getID() || !this.isTrackedAttack(skill, target))
		{
			return;
		}

		local targetID = target.getID();
		local counter = this.Const.SkillCounter;
		local hadSeam = this.m.LastSkillCounter == counter && this.m.LastTargetID == targetID ? this.m.LastTargetHadSeam : this.hasSeam(target);

		if (!hadSeam)
		{
			this.addSeam(target);
			return;
		}

		this.rewardAPOnce(actor, targetID, counter);
		local options = { Source = "aglaea_seam_stitch" };
		if ("ActionToken" in _event && _event.ActionToken != null) options.ActionToken <- _event.ActionToken;
		if ("AttemptToken" in _event && _event.AttemptToken != null) options.AttemptToken <- _event.AttemptToken;
		this.applySeamDamage(actor, target, this.getCurrentSeamDamage(), options);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity == null)
		{
			return;
		}

		local actor = this.getActor();

		if (!this.isValidEnemy(actor, _targetEntity))
		{
			return;
		}

		if (_skill == this)
		{
			if (!this.m.IsApplyingSeamDamage)
			{
				return;
			}
		}
		else if (_skill == null || !_skill.isAttack())
		{
			return;
		}

		this.rewardKillOnce(actor, _targetEntity.getID(), this.Const.SkillCounter);
	}

	function onCombatStarted()
	{
		this.m.LastSkillCounter = -1;
		this.m.LastTargetID = -1;
		this.m.LastTargetHadSeam = false;
		this.m.LastAPRewardCounter = -1;
		this.m.LastAPRewardTargetID = -1;
		this.m.LastKillRewardCounter = -1;
		this.m.LastKillRewardTargetID = -1;
		this.m.IsApplyingSeamDamage = false;
	}

	function onCombatFinished()
	{
		this.onCombatStarted();
		this.skill.onCombatFinished();
	}
});
