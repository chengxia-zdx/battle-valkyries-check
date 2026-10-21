this.yixuan_arcane_mastery_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		PrimaryTargets = null,
		TriggeredActions = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.PrimaryTargets = {};
		this.m.TriggeredActions = {};
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.yixuan_arcane_mastery.tooltip.piercing}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.yixuan_arcane_mastery.tooltip.points}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.yixuan_arcane_mastery.tooltip.exclusions}" }
		];
	}

	function getTechniquePointsEffect()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID("$bvvar{modId}.effects.yixuan_technique_points");
	}

	function ensureTechniquePointsEffect()
	{
		local effect = this.getTechniquePointsEffect();
		if (effect != null) return effect;
		local container = this.getContainer();
		if (container == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/yixuan_technique_points_effect");
		container.add(effect);
		return effect;
	}

	function getLifePiercingDamage()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return 0;
		return this.Math.min(25, this.Math.floor(actor.getHitpointsMax() * 0.15));
	}

	function isOwner( _actor )
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner != null && _actor != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "followup" || _source == "yixuan_life_piercing" || _source == "yixuan_endless_talisman";
	}

	function isQualifyingWeaponAction( _event )
	{
		return _event != null && !this.isExcludedSource("Source" in _event ? _event.Source : null)
			&& (("IsActiveWeaponAttack" in _event && _event.IsActiveWeaponAttack)
				|| ("Skill" in _event && ::$bvvar{namespace}.isActiveWeaponAttack(_event.Skill)));
	}

	function tryApplyLifePiercing( _target, _actionToken, _attemptToken = null )
	{
		if (_target == null || _actionToken == null || _actionToken in this.m.TriggeredActions || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}
		this.m.TriggeredActions[_actionToken] <- true;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local amount = this.getLifePiercingDamage();
		if (actor == null || amount <= 0) return false;
		local hitPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(_target) : null;
		local result = ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(actor, this, _target, amount, {
			ActionToken = _actionToken,
			AttemptToken = _attemptToken,
			Source = "yixuan_life_piercing"
		});
		if (result == null || !("Applied" in result) || !result.Applied) return false;
		if (hitPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(actor, "yixuan_life_pierce", hitPosition);
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _target, "yixuan_ink", { Scale = 0.28, EndScale = 0.48, Duration = 220 });
		local effect = this.ensureTechniquePointsEffect();
		if (effect != null) effect.addCount(1);
		return true;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "ActionStarted")
		{
			if (this.isOwner("Actor" in _event ? _event.Actor : null) && this.isQualifyingWeaponAction(_event)
				&& "ActionToken" in _event && _event.ActionToken != null && "Target" in _event && _event.Target != null)
			{
				this.m.PrimaryTargets[_event.ActionToken] <- ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target);
			}
			return;
		}
		if (_event.Type == "ActionResolved")
		{
			if ("ActionToken" in _event && _event.ActionToken != null)
			{
				if (_event.ActionToken in this.m.PrimaryTargets) delete this.m.PrimaryTargets[_event.ActionToken];
				if (_event.ActionToken in this.m.TriggeredActions) delete this.m.TriggeredActions[_event.ActionToken];
			}
			return;
		}
		if (_event.Type != "TargetResolved" || !("Hit" in _event) || !_event.Hit
			|| ("Nullified" in _event && _event.Nullified) || !this.isQualifyingWeaponAction(_event)
			|| !this.isOwner("Attacker" in _event ? _event.Attacker : null)
			|| !("ActionToken" in _event) || !(_event.ActionToken in this.m.PrimaryTargets)
			|| !("TargetID" in _event) || this.m.PrimaryTargets[_event.ActionToken] != _event.TargetID)
		{
			return;
		}
		this.tryApplyLifePiercing(_event.Target, _event.ActionToken, "AttemptToken" in _event ? _event.AttemptToken : null);
	}

	function resetCombatState()
	{
		this.m.PrimaryTargets = {};
		this.m.TriggeredActions = {};
		local effect = this.getTechniquePointsEffect();
		if (effect != null) effect.clear();
	}

	function onCombatStarted()
	{
		this.m.PrimaryTargets = {};
		this.m.TriggeredActions = {};
		local effect = this.ensureTechniquePointsEffect();
		if (effect != null) effect.clear();
	}

	function onCombatFinished()
	{
		this.resetCombatState();
		this.skill.onCombatFinished();
	}
});
