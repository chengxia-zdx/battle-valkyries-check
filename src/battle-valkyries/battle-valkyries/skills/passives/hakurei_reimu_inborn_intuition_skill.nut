this.hakurei_reimu_inborn_intuition_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		MaxSpiritPower = 4,
		StartingSpiritPower = 1,
		OffensiveGainUsedThisRound = false,
		DefensiveGainUsedThisRound = false,
		BarrierRefs = [],
		BarrierIDs = []
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.MaxSpiritPower = 4;
		this.m.StartingSpiritPower = 1;
		this.m.OffensiveGainUsedThisRound = false;
		this.m.DefensiveGainUsedThisRound = false;
		this.m.BarrierRefs = [];
		this.m.BarrierIDs = [];
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition == null || !("Spec" in _definition)) return;
		local spec = _definition.Spec;
		if ("MaxSpiritPower" in spec) this.m.MaxSpiritPower = spec.MaxSpiritPower;
		if ("StartingSpiritPower" in spec) this.m.StartingSpiritPower = spec.StartingSpiritPower;
	}

	function getOwner()
	{
		local c = this.getContainer();
		return c == null ? null : c.getActor();
	}

	function getSpiritEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.hakurei_reimu_spirit_power");
	}

	function ensureSpiritEffect()
	{
		local effect = this.getSpiritEffect();
		if (effect != null) return effect.configure(this.m.MaxSpiritPower);
		local c = this.getContainer();
		if (c == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/hakurei_reimu_spirit_power_effect");
		effect.configure(this.m.MaxSpiritPower);
		c.add(effect);
		return effect;
	}

	function getSpiritPower()
	{
		local effect = this.getSpiritEffect();
		return effect == null ? 0 : effect.getCount();
	}

	function isExcludedSource( _event )
	{
		if (_event == null || ::$bvvar{namespace}.isCounterOrAOO(_event) || ::$bvvar{namespace}.isValkyrieFollowup(_event)) return true;
		local source = "Source" in _event ? _event.Source : null;
		if (source == null || typeof source != "string") return false;
		return source == "dot" || source == "damage_over_time" || source == "terrain" || source == "reflection"
			|| source.find("fixed") != null || source.find("counter") != null || source.find("aoo") != null;
	}

	function isFantasySeal( _skill )
	{
		if (_skill == null) return false;
		try { return _skill.getBattleValkyriesSkillKey() == "hakurei_reimu_fantasy_seal"; }
		catch (e) { return false; }
	}

	function claimOffensiveSpirit()
	{
		if (this.m.OffensiveGainUsedThisRound) return false;
		local effect = this.ensureSpiritEffect();
		if (effect == null || effect.getCount() >= effect.getMaxCount()) return false;
		this.m.OffensiveGainUsedThisRound = true;
		effect.addCount(1);
		return true;
	}

	function claimDefensiveSpirit()
	{
		if (this.m.DefensiveGainUsedThisRound) return false;
		local effect = this.ensureSpiritEffect();
		if (effect == null || effect.getCount() >= effect.getMaxCount()) return false;
		this.m.DefensiveGainUsedThisRound = true;
		effect.addCount(1);
		return true;
	}

	function resetRoundClaims()
	{
		this.m.OffensiveGainUsedThisRound = false;
		this.m.DefensiveGainUsedThisRound = false;
	}

	function trackBarrier( _effect )
	{
		if (_effect == null) return;
		this.m.BarrierRefs.push(::$bvvar{namespace}.makeValkyrieCombatWeakRef(_effect));
		this.m.BarrierIDs.push(::$bvvar{namespace}.getValkyrieCombatObjectID(_effect));
	}

	function clearOwnedBarriers()
	{
		local owner = this.getOwner();
		for (local i = this.m.BarrierRefs.len() - 1; i >= 0; i = i - 1)
		{
			local effect = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.BarrierRefs[i]);
			if (effect != null)
			{
				try { if (owner == null || effect.isOwnedBy(owner)) effect.removeSelf(); } catch (e) {}
			}
		}
		this.m.BarrierRefs = [];
		this.m.BarrierIDs = [];
	}

	function onNewRound()
	{
		// Global rounds arrive through the engine skill lifecycle, not combat-action events.
		this.resetRoundClaims();
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type != "TargetResolved" || this.m.OffensiveGainUsedThisRound || this.isExcludedSource(_event)) return;
		local owner = this.getOwner();
		if (owner == null || !("Attacker" in _event) || !("Skill" in _event)
			|| ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker) != ::$bvvar{namespace}.getValkyrieCombatObjectID(owner)
			|| !::$bvvar{namespace}.isDirectAttack(_event.Skill) || this.isFantasySeal(_event.Skill)) return;
		local hpDamage = "HitpointDamage" in _event ? _event.HitpointDamage : 0;
		local armorDamage = "ArmorDamage" in _event ? _event.ArmorDamage : 0;
		if (hpDamage > 0 || armorDamage > 0) this.claimOffensiveSpirit();
	}

	function onMissed( _attacker, _skill )
	{
		this.skill.onMissed(_attacker, _skill);
		local owner = this.getOwner();
		if (owner == null || _attacker == null || _skill == null || !::$bvvar{namespace}.isDirectAttack(_skill)) return;
		try { if (_attacker.isAlliedWith(owner)) return; } catch (e) { return; }
		this.claimDefensiveSpirit();
	}

	function onTurnStart()
	{
		this.clearOwnedBarriers();
	}

	function onCombatStarted()
	{
		this.resetRoundClaims();
		this.clearOwnedBarriers();
		local effect = this.ensureSpiritEffect();
		if (effect != null) effect.setCount(this.m.StartingSpiritPower);
	}

	function cleanupCombatRuntime()
	{
		this.resetRoundClaims();
		this.clearOwnedBarriers();
		local effect = this.getSpiritEffect();
		local c = this.getContainer();
		if (effect != null && c != null) c.remove(effect);
	}

	function onDeath( _fatalityType ) { this.cleanupCombatRuntime(); }
	function onCombatFinished() { this.cleanupCombatRuntime(); this.skill.onCombatFinished(); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.offense}" },
			{ id = 4, type = "text", icon = "ui/icons/ranged_defense.png", text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.defense}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.resource}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.hakurei_reimu_inborn_intuition.tooltip.current_prefix}" + this.getSpiritPower() + " / " + this.m.MaxSpiritPower }
		];
	}
});
