this.kafka_script_direction_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		DirectiveSpentThisRound = false,
		EchoSpentThisRound = false,
		TargetRef = null,
		TargetID = null,
		EffectID = null,
		IsSwitching = false
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.resetKafkaRuntimeState();
	}

	function resetKafkaRuntimeState()
	{
		this.m.DirectiveSpentThisRound = false;
		this.m.EchoSpentThisRound = false;
		this.m.TargetRef = null;
		this.m.TargetID = null;
		this.m.EffectID = null;
		this.m.IsSwitching = false;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.kafka_script_direction.tooltip.slot}" },
			{ id = 4, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.kafka_script_direction.tooltip.echo}" },
			{ id = 5, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.kafka_script_direction.tooltip.round}" }
		];
		return ret;
	}

	function getKafkaDirectiveTarget()
	{
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.TargetRef);
		return target != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(target) == this.m.TargetID ? target : null;
	}

	function getKafkaDirectiveEffect()
	{
		local target = this.getKafkaDirectiveTarget();
		if (target == null || this.m.EffectID == null) return null;
		try { return target.getSkills().getSkillByID(this.m.EffectID); } catch (e) { return null; }
	}

	function canIssueKafkaDirective()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return !this.m.DirectiveSpentThisRound && owner != null && !::$bvvar{namespace}.isActorDeadOrDying(owner)
			&& !this.hasUnresolvedKafkaDirectiveCleanup();
	}

	function hasUnresolvedKafkaDirectiveCleanup()
	{
		if (this.m.EffectID == "$bvvar{modId}.effects.kafka_spirit_control" && this.getKafkaDirectiveEffect() == null)
		{
			local target = this.getKafkaDirectiveTarget();
			if (target != null && ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(target) != null) return true;
		}
		return this.getKafkaUntrackedControlHandle() != null;
	}

	function getKafkaUntrackedControlHandle()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null) return null;
		local target = this.getKafkaDirectiveTarget();
		local effect = this.getKafkaDirectiveEffect();
		foreach (handle in ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandlesForController(owner))
		{
			local controlled = ::$bvvar{namespace}.readValkyrieCombatWeakRef(handle.TargetRef);
			if (effect != null && target != null && (controlled == target || (controlled != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(controlled) == this.m.TargetID))) continue;
			return handle;
		}
		return null;
	}

	function restoreKafkaUntrackedControls( _reason = "orphan_retry" )
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null) return true;
		local success = true;
		foreach (handle in ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandlesForController(owner))
		{
			local controlled = ::$bvvar{namespace}.readValkyrieCombatWeakRef(handle.TargetRef);
			local target = this.getKafkaDirectiveTarget();
			local effect = this.getKafkaDirectiveEffect();
			if (effect != null && target != null && (controlled == target || (controlled != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(controlled) == this.m.TargetID))) continue;
			if (!::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl(handle, _reason)) success = false;
		}
		return success;
	}

	function isSameKafkaDirective( _target, _effectID )
	{
		if (_target == null || _effectID == null || this.m.EffectID != _effectID) return false;
		local target = this.getKafkaDirectiveTarget();
		return target != null && (target == _target || ::$bvvar{namespace}.getValkyrieCombatObjectID(_target) == this.m.TargetID)
			&& this.getKafkaDirectiveEffect() != null;
	}

	function clearKafkaDirective( _reason = "clear" )
	{
		local target = this.getKafkaDirectiveTarget();
		local effect = this.getKafkaDirectiveEffect();
		if (effect == null && target != null && this.m.EffectID == "$bvvar{modId}.effects.kafka_spirit_control")
		{
			local orphanHandle = ::$bvvar{namespace}.getValkyrieTemporaryPlayerControlHandle(target);
			if (orphanHandle != null && !::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl(orphanHandle, _reason)) return false;
		}
		if (effect != null && "prepareKafkaDirectiveRemoval" in effect && !effect.prepareKafkaDirectiveRemoval(_reason))
		{
			return false;
		}
		this.m.IsSwitching = true;
		if (target != null && effect != null)
		{
			try { target.getSkills().remove(effect); } catch (e) {}
			local remaining = null;
			try { remaining = target.getSkills().getSkillByID(this.m.EffectID); } catch (e) { remaining = effect; }
			if (remaining != null)
			{
				this.m.IsSwitching = false;
				return false;
			}
		}
		this.m.TargetRef = null;
		this.m.TargetID = null;
		this.m.EffectID = null;
		this.m.IsSwitching = false;
		return true;
	}

	function onKafkaDirectiveEffectRemoved( _effect, _target )
	{
		if (this.m.IsSwitching) return;
		local targetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
		if (targetID == this.m.TargetID)
		{
			this.m.TargetRef = null;
			this.m.TargetID = null;
			this.m.EffectID = null;
		}
	}

	function issueKafkaDirective( _kind, _target )
	{
		if (!this.canIssueKafkaDirective() || _target == null) return false;
		local effectID = _kind == "ally" ? "$bvvar{modId}.effects.kafka_script_protagonist" : (_kind == "enemy" ? "$bvvar{modId}.effects.kafka_spirit_control" : null);
		if (effectID == null || this.isSameKafkaDirective(_target, effectID)) return false;
		local owner = this.getContainer().getActor();
		if (_kind == "enemy" && !::$bvvar{namespace}.canAcquireValkyrieTemporaryPlayerControl(_target, owner)) return false;

		local effect = null;
		try
		{
			effect = this.new(_kind == "ally"
				? "$bvvar{privateFolder}/skills/effects/kafka_script_protagonist_effect"
				: "$bvvar{privateFolder}/skills/effects/kafka_spirit_control_effect");
			effect.setKafkaDirector(owner, this);
		}
		catch (e) { return false; }

		if (!this.clearKafkaDirective("replace")) return false;
		try { _target.getSkills().add(effect); } catch (e) { return false; }
		local installed = null;
		try { installed = _target.getSkills().getSkillByID(effectID); } catch (e) { installed = null; }
		if (installed != effect || !effect.isKafkaDirectiveApplied())
		{
			try { if (installed == effect) _target.getSkills().remove(effect); } catch (e) {}
			return false;
		}

		this.m.TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target);
		this.m.TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
		this.m.EffectID = effectID;
		if (_kind == "enemy" && effect.shouldReleaseKafkaControlForLastHostile())
		{
			this.clearKafkaDirective("last_hostile_on_apply");
			return false;
		}
		this.m.DirectiveSpentThisRound = true;
		return true;
	}

	function checkKafkaLastHostile()
	{
		if (this.m.EffectID != "$bvvar{modId}.effects.kafka_spirit_control") return false;
		local effect = this.getKafkaDirectiveEffect();
		if (effect != null && effect.shouldReleaseKafkaControlForLastHostile())
		{
			this.clearKafkaDirective("last_hostile");
			return true;
		}
		return false;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved") return;
		local target = this.getKafkaDirectiveTarget();
		if (target != null && !this.m.EchoSpentThisRound)
		{
			local attacker = "Attacker" in _event ? _event.Attacker : null;
			local damage = ("HitpointDamage" in _event ? _event.HitpointDamage : 0) + ("ArmorDamage" in _event ? _event.ArmorDamage : 0);
			if (damage > 0 && attacker != null && (attacker == target || ::$bvvar{namespace}.getValkyrieCombatObjectID(attacker) == this.m.TargetID))
			{
				local owner = this.getContainer() == null ? null : this.getContainer().getActor();
				if (owner != null && !::$bvvar{namespace}.isActorDeadOrDying(owner))
				{
					owner.setActionPoints(this.Math.min(owner.getActionPointsMax(), owner.getActionPoints() + 2));
					owner.setDirty(true);
					this.m.EchoSpentThisRound = true;
				}
			}
		}
		this.checkKafkaLastHostile();
	}

	function onNewRound()
	{
		// A failed acquire may leave a repair handle without ever creating an
		// effect. Retry it on a real round boundary; until it succeeds, the
		// preflight above keeps both actives disabled before their costs are paid.
		this.restoreKafkaUntrackedControls("new_round_orphan_retry");
		if (this.hasUnresolvedKafkaDirectiveCleanup()) this.clearKafkaDirective("new_round_orphan_retry");
		this.m.DirectiveSpentThisRound = false;
		this.m.EchoSpentThisRound = false;
		this.checkKafkaLastHostile();
	}

	function onCombatStarted()
	{
		this.clearKafkaDirective("combat_start");
		this.m.DirectiveSpentThisRound = false;
		this.m.EchoSpentThisRound = false;
	}

	function onDeath( _fatalityType )
	{
		this.clearKafkaDirective("director_death");
	}

	function onCombatFinished()
	{
		this.clearKafkaDirective("combat_finish");
		this.m.DirectiveSpentThisRound = false;
		this.m.EchoSpentThisRound = false;
		this.skill.onCombatFinished();
	}
});
