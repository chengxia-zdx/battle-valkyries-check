this.robin_harmonic_resonance_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Harmony = 0, MaxHarmony = 12, AttackGained = null, KillGained = null, ConcertoRecipients = 0 },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.Harmony = 0;
		this.m.MaxHarmony = 12;
		this.m.AttackGained = {};
		this.m.KillGained = {};
		this.m.ConcertoRecipients = 0;
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition != null && "Spec" in _definition && "MaxHarmony" in _definition.Spec) this.m.MaxHarmony = _definition.Spec.MaxHarmony;
	}
	function owner() { local c = this.getContainer(); return c == null ? null : c.getActor(); }
	function getHarmony() { return this.Math.max(0, this.Math.min(this.m.MaxHarmony, this.m.Harmony)); }
	function isHarmonyPaused() { return this.m.ConcertoRecipients > 0; }
	function getAuraTier() { local h=this.getHarmony(); return h >= 12 ? 4 : h >= 9 ? 3 : h >= 6 ? 2 : h >= 3 ? 1 : 0; }
	function getAuraSkillBonus() { return this.getAuraTier() * 3; }
	function getAuraDamageMult() { return 1.0 + this.getAuraTier() * 0.05; }

	function setHarmony( _value )
	{
		this.m.Harmony = this.Math.max(0, this.Math.min(this.m.MaxHarmony, _value));
		this.syncAuraEffects();
		return this.m.Harmony;
	}
	function addHarmony( _value = 1 ) { return this.isHarmonyPaused() ? this.getHarmony() : this.setHarmony(this.getHarmony() + _value); }
	function consumeHarmony( _value )
	{
		if (_value < 0 || this.getHarmony() < _value) return false;
		this.setHarmony(this.getHarmony() - _value);
		return true;
	}

	function isEligibleActor( _actor )
	{
		local owner = this.owner();
		return owner != null && _actor != null && (_actor == owner || ::$bvvar{namespace}.isEligibleRosterAlly(owner, _actor));
	}
	function actorKey( _actor ) { local id=::$bvvar{namespace}.getValkyrieCombatObjectID(_actor); return id == null ? "" : id.tostring(); }
	function resetActorTurn( _actor )
	{
		local key = this.actorKey(_actor);
		if (key == "") return;
		if (key in this.m.AttackGained) delete this.m.AttackGained[key];
		if (key in this.m.KillGained) delete this.m.KillGained[key];
	}
	function isExcludedSource( _event )
	{
		local source = _event != null && "Source" in _event ? _event.Source : null;
		return source == "aoo" || source == "riposte" || source == "counter" || source == "followup" || source == "fixed_damage" || source == "dot" || source == "damage_over_time" || source == "reflection" || source == "scenery";
	}
	function isQualifyingDirectAttack( _event )
	{
		if (_event == null || !("Actor" in _event) || !("Skill" in _event) || !this.isEligibleActor(_event.Actor) || this.isExcludedSource(_event)) return false;
		return ::$bvvar{namespace}.isDirectAttack(_event.Skill);
	}

	function syncAuraEffects()
	{
		local owner = this.owner();
		if (owner == null) return;
		foreach (actor in ::$bvvar{namespace}.getRobinCombatRoster(owner, true))
		{
			local effect = actor.getSkills().getSkillByID(::$bvvar{namespace}.RobinAuraID);
			if (effect == null)
			{
				effect = ::new("$bvvar{privateFolder}/skills/effects/robin_harmony_aura_effect");
				effect.setupOwner(owner);
				actor.getSkills().add(effect);
			}
			actor.getSkills().update();
			actor.setDirty(true);
		}
	}
	function clearAuraEffects()
	{
		local owner = this.owner();
		if (owner == null) return;
		foreach (actor in ::$bvvar{namespace}.getRobinCombatRoster(owner, true))
		{
			local effect = actor.getSkills().getSkillByID(::$bvvar{namespace}.RobinAuraID);
			if (effect != null && "isOwnedBy" in effect && effect.isOwnedBy(owner)) actor.getSkills().remove(effect);
		}
	}

	function beginConcerto( _recipientCount ) { this.m.ConcertoRecipients = this.Math.max(0, _recipientCount); }
	function finishConcertoRecipient()
	{
		this.m.ConcertoRecipients = this.Math.max(0, this.m.ConcertoRecipients - 1);
		return this.m.ConcertoRecipients;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || this.isHarmonyPaused()) return;
		if (_event.Type == "ActionStarted" && this.isQualifyingDirectAttack(_event))
		{
			local key = this.actorKey(_event.Actor);
			if (key != "" && !(key in this.m.AttackGained)) { this.m.AttackGained[key] <- true; this.addHarmony(1); }
			return;
		}
		if (_event.Type != "TargetResolved" || !("Attacker" in _event) || !this.isEligibleActor(_event.Attacker) || this.isExcludedSource(_event)) return;
		if (!("Hit" in _event) || !_event.Hit || !("Target" in _event) || _event.Target == null || !::$bvvar{namespace}.isActorDeadOrDying(_event.Target)) return;
		local key = this.actorKey(_event.Attacker);
		if (key != "" && !(key in this.m.KillGained)) { this.m.KillGained[key] <- true; this.addHarmony(1); }
	}

	function onCombatStarted() { this.m.AttackGained={}; this.m.KillGained={}; this.m.ConcertoRecipients=0; this.setHarmony(0); }
	function onCombatFinished() { this.clearAuraEffects(); this.m.AttackGained={}; this.m.KillGained={}; this.m.ConcertoRecipients=0; this.m.Harmony=0; this.skill.onCombatFinished(); }
	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() }, { id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/special.png", text="$bv{skill.robin_harmonic_resonance.tooltip.current_prefix}" + this.getHarmony() + "/" + this.m.MaxHarmony + "$bv{skill.robin_harmonic_resonance.tooltip.current_suffix}" },
			{ id=4, type="text", icon="ui/icons/hitchance.png", text="$bv{skill.robin_harmonic_resonance.tooltip.aura}" },
			{ id=5, type="text", icon="ui/icons/regular_damage.png", text="$bv{skill.robin_harmonic_resonance.tooltip.thresholds}" }
		];
	}
});
