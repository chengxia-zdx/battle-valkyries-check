this.changli_true_sight_enflamement_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		HeartEyeSpent = false,
		CountedActions = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.HeartEyeSpent = false;
		this.m.CountedActions = {};
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
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.changli_true_sight_enflamement.tooltip.heart_eye}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.changli_true_sight_enflamement.tooltip.layers}"
			}
		];

		if (this.m.HeartEyeSpent)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.changli_true_sight_enflamement.tooltip.spent}"
			});
		}

		return ret;
	}

	function getEnflamementEffect()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID("$bvvar{modId}.effects.changli_enflamement");
	}

	function ensureEnflamementEffect()
	{
		local effect = this.getEnflamementEffect();
		if (effect != null)
		{
			return effect;
		}

		local container = this.getContainer();
		if (container == null)
		{
			return null;
		}

		effect = ::new("$bvvar{privateFolder}/skills/effects/changli_enflamement_effect");
		container.add(effect);
		return effect;
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "followup";
	}

	function isQualifyingMeleeAttack( _skill, _source = null )
	{
		if (_skill == null || !::$bvvar{namespace}.isActiveWeaponAttack(_skill) || _skill.isRanged())
		{
			return false;
		}

		if (_source == null)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			local context = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(actor, _skill);
			_source = context != null && "Source" in context ? context.Source : null;
		}

		return !this.isExcludedSource(_source);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (!this.m.HeartEyeSpent && _properties != null && this.isQualifyingMeleeAttack(_skill))
		{
			_properties.MeleeSkill += 15;
		}
	}

	function isOwnerAttackEvent( _event )
	{
		if (_event == null || !("Attacker" in _event) || _event.Attacker == null)
		{
			return false;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker)
			== ::$bvvar{namespace}.getValkyrieCombatObjectID(actor);
	}

	function canGainEnflamement( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "TargetResolved"
			|| !("Hit" in _event) || !_event.Hit
			|| ("Nullified" in _event && _event.Nullified)
			|| !("ActionToken" in _event) || _event.ActionToken == null
			|| !("Skill" in _event) || !this.isQualifyingMeleeAttack(_event.Skill, "Source" in _event ? _event.Source : null)
			|| !("Target" in _event) || _event.Target == null
			|| !this.isOwnerAttackEvent(_event))
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		try
		{
			return !_event.Target.isAlliedWith(actor);
		}
		catch (e)
		{
			return false;
		}
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event))
		{
			return;
		}

		if (_event.Type == "ActionResolved")
		{
			if ("ActionToken" in _event && _event.ActionToken in this.m.CountedActions)
			{
				delete this.m.CountedActions[_event.ActionToken];
			}
			return;
		}

		if (!this.canGainEnflamement(_event) || _event.ActionToken in this.m.CountedActions)
		{
			return;
		}

		this.m.CountedActions[_event.ActionToken] <- true;
		this.m.HeartEyeSpent = true;
		local effect = this.ensureEnflamementEffect();
		if (effect != null)
		{
			effect.addCount(1);
		}
	}

	function onTurnStart()
	{
		this.m.HeartEyeSpent = false;
	}

	function onCombatStarted()
	{
		this.m.HeartEyeSpent = false;
		this.m.CountedActions = {};
		local effect = this.ensureEnflamementEffect();
		if (effect != null)
		{
			effect.clear();
		}
	}

	function onCombatFinished()
	{
		this.m.HeartEyeSpent = false;
		this.m.CountedActions = {};
		local effect = this.getEnflamementEffect();
		if (effect != null)
		{
			effect.clear();
		}
		this.skill.onCombatFinished();
	}
});
