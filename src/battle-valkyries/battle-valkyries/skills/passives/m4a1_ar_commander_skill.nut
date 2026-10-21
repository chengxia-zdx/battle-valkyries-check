this.m4a1_ar_commander_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function owner() { return this.getContainer().getActor(); }
	function state() { return ::$bvvar{namespace}.getM4A1State(this.owner()); }
	function onCombatStarted()
	{
		::$bvvar{namespace}.startM4A1Combat(this.owner());
		this.ensureDisplay();
	}
	function ensureDisplay()
	{
		if (this.state() == null || !this.state().Active) return;
		if (!this.getContainer().hasSkill("$bvvar{modId}.effects.m4a1_magazine"))
			this.getContainer().add(::new("$bvvar{privateFolder}/skills/effects/m4a1_magazine_effect"));
	}
	function onAdded() { this.ensureDisplay(); }
	function onTurnStart()
	{
		local owner = this.owner(), state = this.state();
		if (state == null || !state.Active || !::$bvvar{namespace}.isM4A1NormalTurn(owner)
			|| ::$bvvar{namespace}.isActorDeadOrDying(owner) || state.LastTurnRound == ::Time.getRound()) return;
		state.LastTurnRound = ::Time.getRound(); state.Turn++;
		::$bvvar{namespace}.clearM4A1Mark(owner);
		owner.setFatigue(this.Math.max(0, owner.getFatigue() - 10));
		this.ensureDisplay();
	}
	function onTurnEnd()
	{
		local state = this.state();
		if (state != null && ::$bvvar{namespace}.isM4A1NormalTurn(this.owner()) && state.Turn >= state.FocusUntil) state.FocusUntil = -1;
	}
	function onValkyrieCombatEvent(_event)
	{
		local state = this.state(), owner = this.owner();
		if (state == null || !state.Active || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap()) return;
		if (_event.Type == "TargetResolved")
		{
			if (!::$bvvar{namespace}.isM4A1PaidAttack(_event) || !_event.Hit || _event.Nullified) return;
			local own = _event.Attacker == owner && ::$bvvar{namespace}.isM4A1RifleSkill(_event.Skill)
				&& _event.Target != null && !_event.Target.isAlliedWith(owner);
			local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(state.MarkRef);
			local ally = _event.Attacker != owner && ::$bvvar{namespace}.isEligibleRosterAlly(owner, _event.Attacker) && target == _event.Target;
			if (!own && !ally) return;
			if (!(_event.ActionToken in state.Pending)) state.Pending[_event.ActionToken] <- { Own = own, Damaged = false, HitTarget = null, Hits = 0 };
			local pending = state.Pending[_event.ActionToken];
			if (_event.HitpointDamage > 0 || _event.ArmorDamage > 0) pending.Damaged = true;
			// Only the selected primary target may be marked/suppressed, not a diverted bullet.
			local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(owner, _event.Skill);
			if (own && context != null && context.TargetID == _event.TargetID)
			{ pending.HitTarget = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_event.Target); pending.Hits++; }
			return;
		}
		if (_event.Type != "ActionResolved" || !(_event.ActionToken in state.Pending)) return;
		local pending = state.Pending[_event.ActionToken]; delete state.Pending[_event.ActionToken];
		::$bvvar{namespace}.refreshM4A1Round(state);
		if (_event.ActionToken in state.Settled) return;
		state.Settled[_event.ActionToken] <- true;
		if (pending.Damaged && ((pending.Own && state.OwnGains < 2) || (!pending.Own && state.AllyGains < 1)))
		{
			if (pending.Own) state.OwnGains++; else state.AllyGains++;
			::$bvvar{namespace}.addM4A1Charge(owner, 1);
		}
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(pending.HitTarget);
		if (pending.Own && target != null && !::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			::$bvvar{namespace}.setM4A1Mark(owner, target);
			if (pending.Hits >= 2 && _event.Skill.getBattleValkyriesSkillKey() == "m4a1_three_round_burst")
			{
				local effect = target.getSkills().getSkillByID("$bvvar{modId}.effects.m4a1_suppressed");
				if (effect == null) target.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/m4a1_suppressed_effect"));
				else effect.onRefresh();
			}
		}
	}
	function onDeath(_fatalityType) { ::$bvvar{namespace}.stopM4A1Combat(this.owner()); }
	function onCombatFinished() { ::$bvvar{namespace}.stopM4A1Combat(this.owner()); this.skill.onCombatFinished(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}, {id=3,type="text",icon="skills/$bvvar{iconPrefix}/m4a1_magazine.png",text=::$bvvar{namespace}.getM4A1AmmoText(this.state())}]; }
});
