this.jeanne_revelation_holy_banner_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { BaseAuraRange = 4, TrueBannerRangeBonus = 1, LastNormalTurnRound = -2, LastJudgmentRebateRound = -2 },

	function create() { this.valkyrie_passive_skill.create(); }
	function getActor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
	function hasLegalWeapon() { return ::$bvvar{namespace}.hasJeanneLegalBannerWeapon(this.getActor()); }
	function getAuraRange() { return this.m.BaseAuraRange + (::$bvvar{namespace}.isJeanneTrueBannerWeapon(this.getActor()) ? this.m.TrueBannerRangeBonus : 0); }

	function getRevelationEffect()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID(::$bvvar{namespace}.JeanneRevelationID);
	}

	function ensureRevelationEffect()
	{
		local effect = this.getRevelationEffect();
		if (effect != null) return effect;
		local container = this.getContainer();
		if (container == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/jeanne_revelation_effect");
		container.add(effect);
		return effect;
	}

	function getRevelation() { local effect=this.ensureRevelationEffect(); return effect == null ? 0 : effect.getCount(); }
	function addRevelation( _amount=1 )
	{
		local effect=this.ensureRevelationEffect();
		if (effect == null) return 0;
		local before = effect.getCount();
		local count = effect.addCount(_amount);
		if (before < 4 && count == 4 && this.hasLegalWeapon() && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			::$bvvar{namespace}.playValkyrieSkillAudio(this.getActor(), "jeanne_revelation_ready");
		return count;
	}
	function consumeRevelation( _amount ) { local effect=this.ensureRevelationEffect(); return effect != null && effect.consumeCount(_amount); }
	function getStartingRevelation() { return ::$bvvar{namespace}.getJeanneStartingRevelation(this.getActor()); }
	function getAuraFatigueRecovery() { return ::$bvvar{namespace}.getJeanneAuraFatigueRecovery(this.getActor()); }
	function hasBondUpgrade( _stage ) { return ::$bvvar{namespace}.hasJeanneBondUpgrade(this.getActor(), _stage); }

	function refundJudgmentRevelation()
	{
		local owner = this.getActor();
		if (!this.hasBondUpgrade(80) || !::$bvvar{namespace}.isJeanneNormalTurnStart(owner)) return false;
		local round = -1;
		try { round = this.Time.getRound(); } catch (e) { return false; }
		if (round < 0 || this.m.LastJudgmentRebateRound == round) return false;
		this.m.LastJudgmentRebateRound = round;
		this.addRevelation(1);
		return true;
	}

	function getOwnedEffect( _actor, _id )
	{
		if (_actor == null || _actor.getSkills() == null) return null;
		local effect = _actor.getSkills().getSkillByID(_id);
		return effect != null && ("isOwnedBy" in effect) && effect.isOwnedBy(this.getActor()) ? effect : null;
	}

	function clearOwnedEffects( _ids )
	{
		foreach (actor in ::$bvvar{namespace}.getJeanneTacticalActors())
		{
			if (actor == null || actor.getSkills() == null) continue;
			foreach (id in _ids)
			{
				local effect = this.getOwnedEffect(actor, id);
				if (effect != null) effect.removeSelf();
			}
			actor.getSkills().update();
		}
	}

	function clearAura() { this.clearOwnedEffects([::$bvvar{namespace}.JeanneHolyBannerAuraID]); }
	function clearAllOwnedEffects()
	{
		this.clearOwnedEffects([
			::$bvvar{namespace}.JeanneHolyBannerAuraID,
			::$bvvar{namespace}.JeanneHolyFlagProtectionID,
			::$bvvar{namespace}.JeanneHolyMaidenBlessingID
		]);
	}

	function refreshAura()
	{
		local owner = this.getActor();
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap())
		{
			this.clearAura();
			return;
		}

		foreach (ally in ::$bvvar{namespace}.getJeanneTacticalActors())
		{
			if (!::$bvvar{namespace}.isEligibleRosterAlly(owner, ally)) continue;
			local existing = ally.getSkills().getSkillByID(::$bvvar{namespace}.JeanneHolyBannerAuraID);
			if (existing == null)
			{
				existing = ::new("$bvvar{privateFolder}/skills/effects/jeanne_holy_banner_aura_effect");
				existing.setupOwner(owner);
				ally.getSkills().add(existing);
			}
			else if ("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasJeanneLegalBannerWeapon(owner)
				&& owner.getTile().getDistanceTo(ally.getTile()) <= this.getAuraRange()
				&& (!existing.isInAura() || (::$bvvar{namespace}.hasGrailBlessing(owner) && !::$bvvar{namespace}.hasGrailBlessing(existing.getOwner()))))
			{
				existing.setupOwner(owner);
			}
			ally.getSkills().update();
		}
	}

	function isJudgementSkill( _skill )
	{
		if (_skill == null) return false;
		try { return _skill.getBattleValkyriesSkillKey() == "jeanne_true_name_divine_judgement"; }
		catch (e) { return false; }
	}

	function getAttackSource( _skill )
	{
		local owner = this.getActor();
		local frame = owner == null ? null : ::$bvvar{namespace}.getCurrentValkyrieCombatSource(owner, _skill);
		return frame != null && "Source" in frame ? frame.Source : null;
	}

	function ignoresShieldFor( _usedSkill ) { return this.isJudgementSkill(_usedSkill); }

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties == null || !this.hasLegalWeapon() || !::$bvvar{namespace}.isActiveWeaponAttack(_skill)) return;
		_properties.DamageRegularMult *= 1.25;
		_properties.DamageDirectMeleeAdd += 0.10;
		local source = this.getAttackSource(_skill);
		if (!this.isJudgementSkill(_skill) && source != "aoo" && source != "riposte" && source != "followup"
			&& source != "fixed" && source != "dot" && source != "terrain" && source != "reflection")
		{
			_properties.MeleeSkill += 10;
		}
	}

	function onCombatStarted()
	{
		this.m.LastNormalTurnRound = -2;
		this.m.LastJudgmentRebateRound = -2;
		local effect = this.ensureRevelationEffect();
		if (effect != null) effect.setCount(this.getStartingRevelation());
		this.refreshAura();
	}

	function onTurnStart()
	{
		local owner = this.getActor();
		if (!::$bvvar{namespace}.isJeanneNormalTurnStart(owner)) return;
		local round = -1;
		try { round = this.Time.getRound(); } catch (e) { round = -1; }
		if (round >= 0 && this.m.LastNormalTurnRound == round) return;
		this.m.LastNormalTurnRound = round;
		this.addRevelation(1);
		if (owner != null
			&& "hasJeanneEternalStandardEquipped" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.hasJeanneEternalStandardEquipped(owner))
		{
			owner.setFatigue(this.Math.max(0, owner.getFatigue() - this.getAuraFatigueRecovery()));
			owner.setDirty(true);
		}
		this.refreshAura();
	}

	function onMovementFinished() { this.refreshAura(); }
	function onRoundEnd() { this.refreshAura(); }
	function onDeath( _fatalityType ) { this.clearAllOwnedEffects(); }
	function onCombatFinished()
	{
		this.m.LastNormalTurnRound = -2;
		this.m.LastJudgmentRebateRound = -2;
		this.clearAllOwnedEffects();
		local effect = this.getRevelationEffect();
		if (effect != null) effect.clear();
		this.skill.onCombatFinished();
	}

	function getTooltip()
	{
		local ret = [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/bravery.png", text="$bv{skill.jeanne_revelation_holy_banner.tooltip.aura_prefix}" + this.getAuraRange() + "$bv{skill.jeanne_revelation_holy_banner.tooltip.aura_suffix}" },
			{ id=4, type="text", icon="ui/icons/fatigue.png", text="$bv{skill.jeanne_revelation_holy_banner.tooltip.recovery_prefix}" + this.getAuraFatigueRecovery() + "$bv{skill.jeanne_revelation_holy_banner.tooltip.recovery_suffix}" },
			{ id=5, type="text", icon="ui/icons/hitchance.png", text="$bv{skill.jeanne_revelation_holy_banner.tooltip.combat}" },
			{ id=6, type="text", icon="ui/icons/special.png", text="$bv{skill.jeanne_revelation_holy_banner.tooltip.revelation_prefix}" + this.getRevelation() + "/4" + "$bv{skill.jeanne_revelation_holy_banner.tooltip.revelation_start_prefix}" + this.getStartingRevelation() + "$bv{skill.jeanne_revelation_holy_banner.tooltip.revelation_start_suffix}" }
		];
		if (this.hasBondUpgrade(20)) ret.push({ id=7, type="text", icon="ui/icons/morale.png", text="$bv{skill.jeanne_revelation_holy_banner.tooltip.bond_morale}" });
		if (!this.hasLegalWeapon()) ret.push({ id=8, type="text", icon="ui/tooltips/warning.png", text="$bv{skill.jeanne_revelation_holy_banner.tooltip.weapon_required}" });
		return ret;
	}
});
