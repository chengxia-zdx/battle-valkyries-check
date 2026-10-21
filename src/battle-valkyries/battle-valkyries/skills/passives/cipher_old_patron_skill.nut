this.cipher_old_patron_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		FixedDamagePerKickback = 15,
		APRecoveryOnKill = 2,
		LastDamageCounter = -1,
		LastDamageTargetID = -1,
		LastKillRewardCounter = -1,
		LastKillRewardTargetID = -1,
		DidAutoAssign = false,
		IsApplyingKickbackDamage = false
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
				text = "$bv{skill.cipher_old_patron.tooltip.mark}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.cipher_old_patron.tooltip.kickback}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.cipher_old_patron.tooltip.damage}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.cipher_old_patron.tooltip.kill}"
			}
		];
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function getOldPatronEffectEvenIfDead( _target )
	{
		if (_target == null || _target.getSkills() == null)
		{
			return null;
		}

		return _target.getSkills().getSkillByID(::$bvvar{namespace}.CipherOldPatronEffectID);
	}

	function hasOwnedOldPatron( _target )
	{
		local actor = this.getActor();
		local effect = this.getOldPatronEffectEvenIfDead(_target);
		return effect != null && effect.isOwnedBy(actor);
	}

	function assignOldPatron( _target )
	{
		local actor = this.getActor();
		return ::$bvvar{namespace}.assignCipherOldPatron(actor, _target);
	}

	function assignHighestHitpointsOldPatron()
	{
		local actor = this.getActor();

		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !("Tactical" in getroottable()) || this.Tactical.Entities == null)
		{
			return null;
		}

		local best = null;
		local bestHitpoints = -1;
		local bestDistance = 9999;
		local actors = this.Tactical.Entities.getAllInstancesAsArray();

		foreach( target in actors )
		{
			if (target == null || target.isAlliedWith(actor) || !target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				continue;
			}

			local hp = target.getHitpoints();
			local distance = 9999;

			if (actor.isPlacedOnMap() && target.isPlacedOnMap())
			{
				distance = actor.getTile().getDistanceTo(target.getTile());
			}

			if (hp > bestHitpoints || hp == bestHitpoints && distance < bestDistance)
			{
				best = target;
				bestHitpoints = hp;
				bestDistance = distance;
			}
		}

		return best == null ? null : this.assignOldPatron(best);
	}

	function applyKickbackDamage( _target, _damage, _options = null )
	{
		local actor = this.getActor();

		if (actor == null || _target == null || _damage <= 0 || ::$bvvar{namespace}.isActorDeadOrDying(actor) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		if (_target.isPlacedOnMap())
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#d7b7ff"), _target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		}

		local options = _options == null ? {} : clone _options;
		if (!("Source" in options)) options.Source <- "cipher_old_patron_kickback";
		if (!("BodyPart" in options)) options.BodyPart <- this.Const.BodyPart.Body;
		this.m.IsApplyingKickbackDamage = true;
		local result = null;

		try
		{
			result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(actor, this, _target, _damage, options);
		}
		catch (e)
		{
			this.m.IsApplyingKickbackDamage = false;
			throw e;
		}

		this.m.IsApplyingKickbackDamage = false;
		return result != null && "Applied" in result && result.Applied;
	}

	function refreshMoonlitHeist( _actor )
	{
		if (_actor == null || _actor.getSkills() == null)
		{
			return false;
		}

		local skill = ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, "cipher_moonlit_heist");

		if (skill == null || !("refreshMoonlitHeist" in skill))
		{
			return false;
		}

		skill.refreshMoonlitHeist();
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
		_actor.setActionPoints(this.Math.min(_actor.getActionPointsMax(), _actor.getActionPoints() + this.m.APRecoveryOnKill));
		this.refreshMoonlitHeist(_actor);

		if (_actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_53", _actor.getTile());
		}

		_actor.setDirty(true);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved"
			|| !("Attacker" in _event) || !("Skill" in _event) || !("Victim" in _event))
		{
			return;
		}

		local actor = this.getActor();
		local attacker = _event.Attacker;
		local skill = _event.Skill;
		local target = _event.Victim;
		local effect = this.getOldPatronEffectEvenIfDead(target);

		if (actor == null || attacker == null || actor.getID() != attacker.getID()
			|| skill == null || skill == this || !skill.isAttack()
			|| effect == null || !effect.isOwnedBy(actor) || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return;
		}

		local counter = this.Const.SkillCounter;
		local targetID = target.getID();

		if (this.m.LastDamageCounter == counter && this.m.LastDamageTargetID == targetID)
		{
			return;
		}

		this.m.LastDamageCounter = counter;
		this.m.LastDamageTargetID = targetID;

		local damage = effect.getKickback() * this.m.FixedDamagePerKickback;

		if (damage > 0)
		{
			local options = { Source = "cipher_old_patron_kickback" };
			if ("ActionToken" in _event && _event.ActionToken != null) options.ActionToken <- _event.ActionToken;
			if ("AttemptToken" in _event && _event.AttemptToken != null) options.AttemptToken <- _event.AttemptToken;
			this.applyKickbackDamage(target, damage, options);
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity == null)
		{
			return;
		}

		local actor = this.getActor();
		local effect = this.getOldPatronEffectEvenIfDead(_targetEntity);

		if (actor == null || effect == null || !effect.isOwnedBy(actor))
		{
			return;
		}

		if (_skill == this)
		{
			if (!this.m.IsApplyingKickbackDamage)
			{
				return;
			}
		}
		else if (_skill == null || !_skill.isAttack())
		{
			return;
		}

		this.rewardKillOnce(actor, _targetEntity.getID(), this.Const.SkillCounter);
		effect.removeSelf();
	}

	function onCombatStarted()
	{
		this.m.LastDamageCounter = -1;
		this.m.LastDamageTargetID = -1;
		this.m.LastKillRewardCounter = -1;
		this.m.LastKillRewardTargetID = -1;
		this.m.IsApplyingKickbackDamage = false;
		this.m.DidAutoAssign = this.assignHighestHitpointsOldPatron() != null;
	}

	function onTurnStart()
	{
		if (!this.m.DidAutoAssign)
		{
			this.m.DidAutoAssign = this.assignHighestHitpointsOldPatron() != null;
		}
	}

	function onCombatFinished()
	{
		local actor = this.getActor();

		if (actor != null)
		{
			::$bvvar{namespace}.clearCipherOldPatron(actor);
		}

		this.m.LastDamageCounter = -1;
		this.m.LastDamageTargetID = -1;
		this.m.LastKillRewardCounter = -1;
		this.m.LastKillRewardTargetID = -1;
		this.m.DidAutoAssign = false;
		this.m.IsApplyingKickbackDamage = false;
		this.skill.onCombatFinished();
	}
});
