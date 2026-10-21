this.ye_shunguang_enlightened_clarity_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { EvadeGainUsedThisRound = false, PendingHitSkillRef = null, PendingHitSkillID = null, ChapterActions = null, ChapterPaidSkill = null },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.EvadeGainUsedThisRound = false;
		this.m.ChapterActions <- {};
		this.m.ChapterPaidSkill <- null;
		this.clearPendingHit();
	}

	function getOwner() { local c = this.getContainer(); return c == null ? null : c.getActor(); }
	function getStance() { local c = this.getContainer(); return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.ye_shunguang_qingming_stance"); }
	function getState() { local c = this.getContainer(); return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.ye_shunguang_enlightened_state"); }
	function debugValue( _value ) { return _value == null ? "null" : _value.tostring(); }
	function debugSkillID( _skill )
	{
		try { return _skill == null ? "null" : _skill.getID(); } catch (e) { return "<skill-id-error>"; }
	}
	function debugTargetQualification( _event )
	{
		local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(this.getOwner());
		local attackerID = _event != null && "Attacker" in _event ? ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker) : null;
		local skill = _event != null && "Skill" in _event ? _event.Skill : null;
		local direct = ::$bvvar{namespace}.isDirectAttack(skill);
		local weapon = ::$bvvar{namespace}.isActiveWeaponAttack(skill);
		local ranged = null;
		try { ranged = skill.isRanged(); } catch (e) { ranged = "error"; }
		return "owner=" + this.debugValue(ownerID) + " attacker=" + this.debugValue(attackerID)
			+ " direct=" + direct + " weapon=" + weapon + " ranged=" + this.debugValue(ranged);
	}
	function debugLog( _stage, _details = "" )
	{
		try
		{
			local stance = this.getStance();
			local count = stance == null ? -1 : stance.getCount();
			local weapon = "getQingmingWeapon" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getQingmingWeapon(this.getOwner()) : null;
			local form = weapon == null ? "other" : (weapon.m.SwordForm ? "sword" : "casket");
			::logInfo("[Battle Valkyries] [YeShunguangDebug] stage=" + _stage + " count=" + count
				+ " weaponForm=" + form + " pendingSkill=" + this.debugValue(this.m.PendingHitSkillID) + (_details == "" ? "" : " " + _details));
		}
		catch (e) {}
	}
	function ensureStance()
	{
		local stance = this.getStance();
		if (stance != null) { this.debugLog("ensure-existing"); return stance; }
		local c = this.getContainer();
		if (c == null) { this.debugLog("ensure-failed", "reason=no-container"); return null; }
		stance = ::new("$bvvar{privateFolder}/skills/effects/ye_shunguang_qingming_stance_effect");
		c.add(stance);
		this.debugLog("ensure-created");
		return stance;
	}

	function isEnlightened() { return this.getState() != null; }
	function hasMeleeWeapon()
	{
		local owner = this.getOwner();
		if (owner == null) return false;
		local weapon = null;
		try { weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isExcludedSource( _source ) { return _source == "aoo" || _source == "riposte" || _source == "counter" || _source == "followup" || _source == "fixed_damage" || _source == "damage_over_time"; }
	function isOwnActiveMeleeWeaponAttack( _event )
	{
		local owner = this.getOwner();
		if (_event == null || owner == null || !("Attacker" in _event)
			|| ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker) != ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) || !("Skill" in _event)
			|| !::$bvvar{namespace}.isActiveWeaponAttack(_event.Skill) || this.isExcludedSource("Source" in _event ? _event.Source : null)) return false;
		try { return !_event.Skill.isRanged(); } catch (e) { return false; }
	}

	function resetRoundState()
	{
		this.m.EvadeGainUsedThisRound = false;
		this.clearPendingHit();
		local state = this.getState();
		if (state != null) state.resetRoundBlock();
	}
	function clearPendingHit()
	{
		this.m.PendingHitSkillRef = null;
		this.m.PendingHitSkillID = null;
	}
	function markPendingHit( _skill )
	{
		this.m.PendingHitSkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_skill);
		this.m.PendingHitSkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill);
		this.debugLog("pending-marked", "skill=" + this.debugSkillID(_skill));
	}
	function isPendingHitFor( _skill )
	{
		if (_skill == null) return false;
		local pending = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.PendingHitSkillRef);
		if (pending != null && pending == _skill) return true;
		local skillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_skill);
		return this.m.PendingHitSkillID != null && skillID != null && this.m.PendingHitSkillID == skillID;
	}
	function resetCombatState()
	{
		this.m.ChapterActions = {}; this.m.ChapterPaidSkill = null;
		this.resetRoundState();
		local stance = this.ensureStance();
		if (stance != null) stance.clear();
	}
	function clearEnlightenedState()
	{
		local state = this.getState();
		local c = this.getContainer();
		if (state != null && c != null) c.remove(state);
	}
	function cleanupCombatRuntime()
	{
		this.resetCombatState();
		this.clearEnlightenedState();
	}

	function getValkyrieWeaponSkillPolicy( _usedSkill )
	{
		local state = this.getState();
		local stance = this.getStance();
		if (state == null || stance == null || stance.getCount() <= 0 || _usedSkill == null || !this.hasMeleeWeapon()) return null;
		return { Token = "ye_shunguang_flowing_light", APDelta = -4, FatigueDelta = -15 };
	}
	function commitValkyrieWeaponSkillPolicy( _token, _context )
	{
		if (_token != "ye_shunguang_flowing_light") return;
		local state = this.getState();
		if (state != null)
		{
			this.m.ChapterPaidSkill = _context != null && "Skill" in _context ? _context.Skill : null;
			if ("getCurrentValkyrieActionContext" in ::$bvvar{namespace})
			{
				local action = ::$bvvar{namespace}.getCurrentValkyrieActionContext(this.getOwner(), this.m.ChapterPaidSkill);
				if (action != null && "ActionToken" in action)
				{
					if (this.m.ChapterActions == null) this.m.ChapterActions = {};
					this.m.ChapterActions[action.ActionToken] <- { Blocked = true, Gained = false };
				}
			}
			state.consumeStance();
		}
	}

	function onMissed( _attacker, _skill )
	{
		this.skill.onMissed(_attacker, _skill);
		if (this.isEnlightened() || this.m.EvadeGainUsedThisRound || _attacker == null || _skill == null || !::$bvvar{namespace}.isDirectAttack(_skill)) return;
		try { if (_skill.isRanged()) return; } catch (e) { return; }
		local owner = this.getOwner();
		if (owner == null || _attacker.isAlliedWith(owner)) return;
		local stance = this.ensureStance();
		if (stance != null && stance.getCount() < 6) { stance.addCount(1); this.m.EvadeGainUsedThisRound = true; }
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		// Capture the state at action start, including the last discounted strike
		// which spends the final stance and removes Enlightenment before it hits.
		if (this.m.ChapterActions == null) this.m.ChapterActions = {};
		local token = "ActionToken" in _event ? _event.ActionToken : null;
		if (_event.Type == "ActionResolved" && token != null) { if (token in this.m.ChapterActions) delete this.m.ChapterActions[token]; return; }
		// skill_container returns a WeakTableRef; event dispatch unwraps it.
		// Compare actor identity, not the wrapper with the raw actor table.
		local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(this.getOwner());
		if (_event.Type == "ActionStarted" && token != null && "Actor" in _event && ownerID != null
			&& ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Actor) == ownerID)
		{
			local paid = token in this.m.ChapterActions && this.m.ChapterActions[token].Blocked;
			this.m.ChapterActions[token] <- { Blocked = paid || this.isEnlightened() || ("Skill" in _event && _event.Skill == this.m.ChapterPaidSkill), Gained = false };
			this.m.ChapterPaidSkill = null;
		}
		local action = token != null && token in this.m.ChapterActions ? this.m.ChapterActions[token] : null;
		local wasEnlightened = action != null && action.Blocked;
		local weapon = "getQingmingWeapon" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getQingmingWeapon(this.getOwner()) : null;
		// Log before the sword/state early returns so a missing event can be
		// distinguished from an event received but rejected by the stance rules.
		if (_event.Type == "ActionStarted" || _event.Type == "TargetResolved" || _event.Type == "NewRound")
		{
			this.debugLog("event-" + _event.Type,
				"action=" + this.debugValue(token) + " tracked=" + (action != null) + " blocked=" + wasEnlightened
				+ " attempt=" + this.debugValue("AttemptToken" in _event ? _event.AttemptToken : null)
				+ " skill=" + this.debugSkillID("Skill" in _event ? _event.Skill : null)
				+ " hit=" + this.debugValue("Hit" in _event ? _event.Hit : null)
				+ " nullified=" + this.debugValue("Nullified" in _event ? _event.Nullified : null)
				+ " source=" + this.debugValue("Source" in _event ? _event.Source : null));
		}
		if (weapon != null && weapon.m.SwordForm && _event.Type == "TargetResolved" && this.isOwnActiveMeleeWeaponAttack(_event))
		{
			if (!this.isEnlightened() && !wasEnlightened && action != null && !action.Gained)
			{
				action.Gained = true;
				this.ensureStance().addCount(3);
				this.debugLog("qingming-gain-complete", "action=" + this.debugValue(token) + " gain=3");
			}
			else this.debugLog("qingming-gain-skipped", "action=" + this.debugValue(token)
				+ " reason=" + (this.isEnlightened() || wasEnlightened ? "enlightened" : (action == null ? "missing-action" : "already-gained")));
			return;
		}
		if (wasEnlightened) return;
		if (_event.Type == "NewRound") { this.resetRoundState(); return; }
		if (this.isEnlightened()) { this.debugLog("event-ignored", "reason=enlightened"); return; }
		if (_event.Type == "TargetResolved" && this.isOwnActiveMeleeWeaponAttack(_event)
			&& "Hit" in _event && _event.Hit && !("Nullified" in _event && _event.Nullified))
		{
			if (this.isPendingHitFor(_event.Skill))
			{
				this.debugLog("target-deduplicated", "skill=" + this.debugSkillID(_event.Skill));
				return;
			}
			this.markPendingHit(_event.Skill);
			local stance = this.ensureStance();
			if (stance != null && stance.getCount() < 6) stance.addCount(2);
			this.debugLog("target-gain-complete", "skill=" + this.debugSkillID(_event.Skill));
		}
		else if (_event.Type == "TargetResolved") this.debugLog("target-rejected", "qualifying=false " + this.debugTargetQualification(_event));
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill == this.m.ChapterPaidSkill) this.m.ChapterPaidSkill = null;
		local matched = this.isPendingHitFor(_skill);
		this.debugLog("executed-clear", "skill=" + this.debugSkillID(_skill) + " matched=" + matched + " free=" + this.debugValue(_forFree));
		this.clearPendingHit();
	}

	function getTooltip()
	{
		local weapon = "getQingmingWeapon" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getQingmingWeapon(this.getOwner()) : null;
		local attackText = weapon != null && weapon.m.SwordForm ? "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.qingming}" : "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.attack}";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = attackText },
			{ id = 4, type = "text", icon = "ui/icons/melee_defense.png", text = "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.evade}" },
			{ id = 5, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.ye_shunguang_enlightened_clarity.tooltip.ready}" }
		];
	}

	function onDeath( _fatalityType ) { this.cleanupCombatRuntime(); }
	function onCombatStarted() { this.debugLog("combat-started-before"); this.resetCombatState(); this.debugLog("combat-started-after"); }
	function onCombatFinished() { this.debugLog("combat-finished-before"); this.cleanupCombatRuntime(); this.debugLog("combat-finished-after"); this.skill.onCombatFinished(); }
});
