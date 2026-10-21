this.skirk_serpents_subtlety_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Count = 0, GainsThisRound = 0, GainActionTokens = null },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.Count = 0;
		this.m.GainsThisRound = 0;
		this.m.GainActionTokens = {};
	}

	function getOwner() { local c = this.getContainer(); return c == null ? null : c.getActor(); }
	function getCount() { return this.Math.max(0, this.m.Count); }
	function getResourceEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.skirk_serpents_subtlety");
	}
	function getPhaseEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.skirk_seven_phase_flash");
	}
	function ensureEffect( _path, _id )
	{
		local c = this.getContainer();
		if (c == null) return null;
		local existing = c.getSkillByID(_id);
		if (existing != null) return existing;
		local effect = ::new(_path);
		if (effect != null) c.add(effect);
		return effect;
	}
	function ensureResourceEffect() { return this.ensureEffect("$bvvar{privateFolder}/skills/effects/skirk_serpents_subtlety_effect", "$bvvar{modId}.effects.skirk_serpents_subtlety"); }
	function ensurePhaseEffect() { return this.ensureEffect("$bvvar{privateFolder}/skills/effects/skirk_seven_phase_flash_effect", "$bvvar{modId}.effects.skirk_seven_phase_flash"); }
	function setCount( _value )
	{
		this.m.Count = this.Math.min(6, this.Math.max(0, _value));
		local effect = this.ensureResourceEffect();
		if (effect != null) effect.setCount(this.m.Count);
		return this.m.Count;
	}
	function addCount( _value = 1 ) { return this.setCount(this.m.Count + _value); }
	function clear() { return this.setCount(0); }
	function hasMeleeWeapon()
	{
		local owner = this.getOwner(); local weapon = null;
		try { weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}
	function isMeleeWeaponAttack( _skill )
	{
		return _skill != null && ::$bvvar{namespace}.isActiveWeaponAttack(_skill) && !_skill.isRanged();
	}
	function getSource( _skill )
	{
		local owner = this.getOwner();
		try { local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(owner, _skill); return frame == null ? null : frame.Source; }
		catch (e) { try { return _skill.Source; } catch (ignored) { return null; } }
	}
	function isExcludedSource( _skill )
	{
		local source = this.getSource(_skill);
		return source == "aoo" || source == "riposte" || source == "counter" || source == "followup" || source == "fixed_damage" || source == "damage_over_time";
	}
	function isEligiblePhaseAttack( _skill ) { return this.isMeleeWeaponAttack(_skill) && !this.isExcludedSource(_skill); }

	function ignoresShieldFor( _usedSkill ) { return this.isMeleeWeaponAttack(_usedSkill); }
	function getValkyrieWeaponSkillPolicy( _usedSkill )
	{
		local phase = this.getPhaseEffect();
		if (phase == null || !phase.isPhaseActive() || this.getCount() < 1 || !this.isEligiblePhaseAttack(_usedSkill)) return null;
		return {
			Token = "skirk_seven_phase_flash",
			APDelta = -2,
			FatigueDelta = -10,
			MaxRange = this.Math.max(2, _usedSkill.getMaxRange()),
			HitChanceBonus = 15,
			IgnoreDistance = true,
			TargetWeaponDamageMultiplier = function( _target ) { return 1.40; }
		};
	}
	function commitValkyrieWeaponSkillPolicy( _token, _context )
	{
		if (_token != "skirk_seven_phase_flash") return;
		local phase = this.getPhaseEffect();
		if (phase == null || !phase.isPhaseActive() || this.getCount() < 1) return;
		this.setCount(this.getCount() - 1);
		if (this.getCount() == 0) phase.markExhausted();
	}

	function isOwnDirectWeaponHit( _event )
	{
		local owner = this.getOwner();
		return _event != null && "Attacker" in _event
			&& ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker) == ::$bvvar{namespace}.getValkyrieCombatObjectID(owner)
			&& "Skill" in _event && this.isMeleeWeaponAttack(_event.Skill)
			&& "Hit" in _event && _event.Hit
			&& !("Nullified" in _event && _event.Nullified)
			&& !("Source" in _event && (_event.Source == "aoo" || _event.Source == "riposte" || _event.Source == "counter" || _event.Source == "followup" || _event.Source == "fixed_damage" || _event.Source == "damage_over_time"));
	}
	function tryGainFromHit( _event )
	{
		if (!this.isOwnDirectWeaponHit(_event) || this.m.GainsThisRound >= 2) return false;
		local token = "ActionToken" in _event ? _event.ActionToken : null;
		if (token != null && token in this.m.GainActionTokens) return false;
		if (token != null) this.m.GainActionTokens[token] <- true;
		if (this.getCount() < 6) this.addCount(1);
		this.m.GainsThisRound++;
		return true;
	}
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.skirk_serpents_subtlety.tooltip.start}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.skirk_serpents_subtlety.tooltip.gain}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.skirk_serpents_subtlety.tooltip.shield}" }
		];
	}
	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		local phase = this.getPhaseEffect();
		if (_event.Type == "ActionResolved")
		{
			if (phase != null && phase.isExhausted()) phase.deactivate();
			return;
		}
		if (_event.Type != "TargetResolved" || (phase != null && phase.isPhaseActive())) return;
		this.tryGainFromHit(_event);
	}
	function onTurnStart() { this.m.GainsThisRound = 0; this.m.GainActionTokens = {}; }
	function onCombatStarted()
	{
		this.m.GainsThisRound = 0;
		this.m.GainActionTokens = {};
		this.setCount(2);
		local phase = this.ensurePhaseEffect();
		if (phase != null) phase.deactivate();
	}
	function onCombatFinished() { this.m.GainsThisRound = 0; this.m.GainActionTokens = {}; this.clear(); local phase = this.getPhaseEffect(); if (phase != null) phase.deactivate(); this.skill.onCombatFinished(); }
});
