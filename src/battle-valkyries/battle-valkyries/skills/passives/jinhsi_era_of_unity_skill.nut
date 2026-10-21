this.jinhsi_era_of_unity_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Contributors = null, AllyGainsThisRound = 0 },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.Contributors = {};
		this.m.AllyGainsThisRound = 0;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.jinhsi_era_of_unity.tooltip.ally}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.jinhsi_era_of_unity.tooltip.cap}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.jinhsi_era_of_unity.tooltip.ready}" }
		];
	}

	function getIncandescenceEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.jinhsi_incandescence");
	}

	function ensureIncandescenceEffect()
	{
		local effect = this.getIncandescenceEffect();
		if (effect != null) return effect;
		local c = this.getContainer();
		if (c == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/jinhsi_incandescence_effect");
		c.add(effect);
		local actor = c.getActor();
		if (actor != null)
		{
			try { actor.setDirty(true); } catch (e) {}
		}
		return effect;
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "followup"
			|| _source == "fixed_damage" || _source == "damage_over_time"
			|| _source == "jinhsi_incarnation" || _source == "jinhsi_illuminous_epiphany";
	}

	function canAllyContribute( _event )
	{
		if (_event == null || !("Attacker" in _event) || _event.Attacker == null
			|| !("Skill" in _event) || !::$bvvar{namespace}.isDirectAttack(_event.Skill)
			|| this.isExcludedSource("Source" in _event ? _event.Source : null)) return false;
		if (!("HitpointDamage" in _event) || !("ArmorDamage" in _event)
			|| (_event.HitpointDamage <= 0 && _event.ArmorDamage <= 0)) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner != null && ::$bvvar{namespace}.isEligibleRosterAlly(owner, _event.Attacker);
	}

	function tryGainFromAlly( _event )
	{
		if (!this.canAllyContribute(_event) || this.m.AllyGainsThisRound >= 3) return false;
		local contributorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker);
		if (contributorID == null || contributorID in this.m.Contributors) return false;
		local effect = this.ensureIncandescenceEffect();
		if (effect == null || effect.getCount() >= 6) return false;
		this.m.Contributors[contributorID] <- true;
		this.m.AllyGainsThisRound++;
		effect.addCount(1);
		return true;
	}

	function resetRoundState()
	{
		this.m.Contributors = {};
		this.m.AllyGainsThisRound = 0;
	}

	function resetCombatState()
	{
		this.resetRoundState();
		local effect = this.getIncandescenceEffect();
		if (effect != null) effect.clear();
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "NewRound") { this.resetRoundState(); return; }
		if (_event.Type == "DamageResolved") this.tryGainFromAlly(_event);
	}

	function onNewRound() { this.resetRoundState(); }
	function onCombatStarted() { this.resetCombatState(); this.ensureIncandescenceEffect(); }
	function onCombatFinished() { this.resetCombatState(); this.skill.onCombatFinished(); }
});
