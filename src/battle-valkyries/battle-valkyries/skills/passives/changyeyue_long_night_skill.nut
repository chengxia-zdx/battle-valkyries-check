this.changyeyue_long_night_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		Memory = 0,
		MemoryMax = 100,
		MemoryOnHit = 25,
		MemoryOnKill = 25,
		MemoryOnAllyDamaged = 15,
		AllyDamageRange = 4,
		LastAllyDamageRound = -1,
		HitChanceBonusAgainstOblivion = 30,
		ExtraDamageAgainstOblivion = 30,
		IsApplyingOblivionDamage = false
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function getMemoryMax()
	{
		return this.m.MemoryMax;
	}

	function getMemory()
	{
		return this.Math.max(0, this.Math.min(this.m.MemoryMax, this.m.Memory));
	}

	function hasFullMemory()
	{
		return this.getMemory() >= this.getMemoryMax();
	}

	function addMemory( _amount )
	{
		if (_amount <= 0)
		{
			return this.getMemory();
		}

		this.m.Memory = this.Math.min(this.m.MemoryMax, this.getMemory() + _amount);
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_75", actor.getTile());
			actor.setDirty(true);
		}

		return this.getMemory();
	}

	function spendMemory( _amount )
	{
		if (_amount <= 0)
		{
			return true;
		}

		if (this.getMemory() < _amount)
		{
			return false;
		}

		this.m.Memory = this.getMemory() - _amount;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null)
		{
			actor.setDirty(true);
		}

		return true;
	}

	function resetMemory()
	{
		this.m.Memory = 0;
		this.m.LastAllyDamageRound = -1;
		this.m.IsApplyingOblivionDamage = false;
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
				text = "$bv{skill.changyeyue_long_night.tooltip.memory}" + this.getMemory() + "/" + this.getMemoryMax()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.changyeyue_long_night.tooltip.gain}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.changyeyue_long_night.tooltip.oblivion}"
			}
		];
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function getCurrentRound()
	{
		try
		{
			return this.Time.getRound();
		}
		catch (e)
		{
			return 0;
		}
	}

	function isTrackedAttack( _skill, _target )
	{
		local actor = this.getActor();
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& _skill != null && _skill != this && _skill.isAttack()
			&& _target != null && !_target.isAlliedWith(actor) && _target.isAttackable();
	}

	function getOblivionEffect( _target )
	{
		if (_target == null || _target.getSkills() == null)
		{
			return null;
		}

		return _target.getSkills().getSkillByID("$bvvar{modId}.effects.changyeyue_oblivion");
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.isTrackedAttack(_skill, _targetEntity) && this.getOblivionEffect(_targetEntity) != null)
		{
			_properties.MeleeSkill += this.m.HitChanceBonusAgainstOblivion;
			_properties.RangedSkill += this.m.HitChanceBonusAgainstOblivion;
		}
	}

	function applyOblivionDamage( _actor, _target, _options = null )
	{
		if (_actor == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		if (_target.isPlacedOnMap())
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#b8d4ff"), _target.getTile(), 0, 45, 1.0, 0.25, 0, 200, 200);
		}

		local options = _options == null ? {} : clone _options;
		if (!("Source" in options)) options.Source <- "changyeyue_oblivion_followup";
		if (!("BodyPart" in options)) options.BodyPart <- this.Const.BodyPart.Body;
		this.m.IsApplyingOblivionDamage = true;
		local result = null;

		try
		{
			result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_actor, this, _target, this.m.ExtraDamageAgainstOblivion, options);
		}
		catch (e)
		{
			this.m.IsApplyingOblivionDamage = false;
			throw e;
		}

		this.m.IsApplyingOblivionDamage = false;
		return result != null && "Applied" in result && result.Applied;
	}

	function tryTriggerOblivionDamage( _target, _options = null )
	{
		local actor = this.getActor();
		local oblivion = this.getOblivionEffect(_target);

		if (actor == null || oblivion == null || !oblivion.canTriggerFollowup())
		{
			return;
		}

		oblivion.markFollowupTriggered();
		this.applyOblivionDamage(actor, _target, _options);
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
		local target = _event.Victim;
		if (actor == null || attacker == null || actor.getID() != attacker.getID() || !this.isTrackedAttack(_event.Skill, target))
		{
			return;
		}

		this.addMemory(this.m.MemoryOnHit);
		local options = { Source = "changyeyue_oblivion_followup" };
		if ("ActionToken" in _event && _event.ActionToken != null) options.ActionToken <- _event.ActionToken;
		if ("AttemptToken" in _event && _event.AttemptToken != null) options.AttemptToken <- _event.AttemptToken;
		this.tryTriggerOblivionDamage(target, options);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getActor();
		if (actor == null || _targetEntity == null || _targetEntity.isAlliedWith(actor))
		{
			return;
		}

		if (_skill == this)
		{
			if (!this.m.IsApplyingOblivionDamage)
			{
				return;
			}
		}
		else if (_skill == null || !_skill.isAttack())
		{
			return;
		}

		this.addMemory(this.m.MemoryOnKill);
	}

	function onAllyDamaged( _ally, _hitpointDamage )
	{
		local actor = this.getActor();
		if (actor == null || _ally == null || _hitpointDamage <= 0 || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return;
		}

		if (!actor.isPlacedOnMap() || !_ally.isPlacedOnMap() || actor.getTile().getDistanceTo(_ally.getTile()) > this.m.AllyDamageRange)
		{
			return;
		}

		local round = this.getCurrentRound();
		if (this.m.LastAllyDamageRound == round)
		{
			return;
		}

		this.m.LastAllyDamageRound = round;
		this.addMemory(this.m.MemoryOnAllyDamaged);
	}

	function onCombatStarted()
	{
		this.resetMemory();
	}

	function onCombatFinished()
	{
		this.resetMemory();
		this.skill.onCombatFinished();
	}
});
