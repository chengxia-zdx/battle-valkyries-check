this.yae_miko_kitsune_thunder_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		TriggeredTargets = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.TriggeredTargets = {};
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
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.yae_miko_kitsune_thunder.tooltip.hit}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.yae_miko_kitsune_thunder.tooltip.damage}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.yae_miko_kitsune_thunder.tooltip.direct}"
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties == null || !::$bvvar{namespace}.isDirectAttack(_skill))
		{
			return;
		}

		_properties.MeleeSkill += 15;
		_properties.RangedSkill += 15;

		if (::$bvvar{namespace}.isActiveWeaponAttack(_skill))
		{
			_properties.DamageRegularMult *= 1.2;
		}
	}

	function getTriggerTargetID( _event )
	{
		if (_event != null && "TargetID" in _event && _event.TargetID != null)
		{
			return _event.TargetID;
		}

		return _event == null || !("Target" in _event)
			? null
			: ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target);
	}

	function isOwnerAttackEvent( _event, _actor )
	{
		if (_event == null || _actor == null || !("Attacker" in _event) || _event.Attacker == null)
		{
			return false;
		}

		return ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker)
			== ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
	}

	function canTriggerKitsuneThunder( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "TargetResolved"
			|| !("Hit" in _event) || !_event.Hit
			|| ("Nullified" in _event && _event.Nullified)
			|| ("Source" in _event && _event.Source == "yae_miko_kitsune_thunder")
			|| !("ActionToken" in _event) || _event.ActionToken == null
			|| !("Skill" in _event) || !::$bvvar{namespace}.isDirectAttack(_event.Skill)
			|| !("Target" in _event) || _event.Target == null
			|| ::$bvvar{namespace}.isActorDeadOrDying(_event.Target))
		{
			return false;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (!this.isOwnerAttackEvent(_event, actor) || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			return false;
		}

		try
		{
			return !_event.Target.isAlliedWith(actor);
		}
		catch (e)
		{
			return false;
		}
	}

	function markTriggerOnce( _actionToken, _targetID )
	{
		if (_actionToken == null || _targetID == null)
		{
			return false;
		}

		if (!(_actionToken in this.m.TriggeredTargets))
		{
			this.m.TriggeredTargets[_actionToken] <- {};
		}

		local targets = this.m.TriggeredTargets[_actionToken];
		if (_targetID in targets)
		{
			return false;
		}

		targets[_targetID] <- true;
		return true;
	}

	function playKitsuneThunderEffect( _target )
	{
		try
		{
			if (_target != null && _target.isPlacedOnMap())
			{
				if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _target, "yae_miko_thunder");
			}
		}
		catch (e)
		{
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
			if ("ActionToken" in _event && _event.ActionToken in this.m.TriggeredTargets)
			{
				delete this.m.TriggeredTargets[_event.ActionToken];
			}
			return;
		}

		if (!this.canTriggerKitsuneThunder(_event))
		{
			return;
		}

		local targetID = this.getTriggerTargetID(_event);
		if (!this.markTriggerOnce(_event.ActionToken, targetID))
		{
			return;
		}

		local actor = this.getContainer().getActor();
		this.playKitsuneThunderEffect(_event.Target);
		::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(actor, this, _event.Target, 30, {
			ActionToken = _event.ActionToken,
			AttemptToken = "AttemptToken" in _event ? _event.AttemptToken : null,
			Source = "yae_miko_kitsune_thunder"
		});
	}

	function onCombatStarted()
	{
		this.m.TriggeredTargets = {};
	}

	function onCombatFinished()
	{
		this.m.TriggeredTargets = {};
		this.skill.onCombatFinished();
	}
});
