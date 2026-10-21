this.texas_omertosa_tradition_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		CutInReady = true,
		CooldownTurns = 0,
		Mode = null,
		ModeTurns = 0,
		DownpourCharges = 0,
		FirstKillTriggered = false,
		PendingSettlements = null,
		PendingReplayToken = null,
		PendingReplayMode = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.PendingSettlements = {};
	}

	function getOwner()
	{
		local container = this.getContainer();
		return container == null ? null : container.getActor();
	}

	function isOwnerAlive()
	{
		local owner = this.getOwner();
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner)) return false;
		try { return owner.isPlacedOnMap(); } catch (e) { return false; }
	}

	function isCutInReady()
	{
		return this.m.CutInReady && this.isOwnerAlive();
	}

	function activateMode( _mode )
	{
		this.m.Mode = _mode;
		this.m.ModeTurns = 2;
		this.m.DownpourCharges = _mode == "downpour" ? 3 : 0;
	}

	function consumeCutIn( _mode )
	{
		if (!this.isCutInReady() || (_mode != "downpour" && _mode != "sword_rain")) return false;
		this.m.CutInReady = false;
		// The next two complete personal turns remain unavailable. The third
		// following turn begins ready again.
		this.m.CooldownTurns = 3;
		this.activateMode(_mode);
		return true;
	}

	function refreshModeFromFirstKill( _mode )
	{
		this.m.CutInReady = false;
		this.m.CooldownTurns = 3;
		this.activateMode(_mode);
	}

	function getTooltip()
	{
		local state = this.m.CutInReady ? "$bv{skill.texas_omertosa_tradition.tooltip.ready}" : "$bv{skill.texas_omertosa_tradition.tooltip.charging_prefix}" + this.m.CooldownTurns + "$bv{skill.texas_omertosa_tradition.tooltip.charging_suffix}";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.texas_omertosa_tradition.tooltip.cut_in}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.texas_omertosa_tradition.tooltip.mode}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.texas_omertosa_tradition.tooltip.survival}" },
			{ id = 6, type = "text", icon = "ui/icons/health.png", text = "$bv{skill.texas_omertosa_tradition.tooltip.first_kill}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = state }
		];
	}

	function getRainErosion( _target )
	{
		if (_target == null || _target.getSkills() == null) return null;
		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.texas_omertosa_rain_erosion");
		return effect != null && effect.isOwnedBy(this.getOwner()) ? effect : null;
	}

	function getSourceSkillKey( _usedSkill, _target )
	{
		local owner = this.getOwner();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(owner, _usedSkill, _target);
		if (policy == null || !("SourceSkillRef" in policy)) return null;
		local source = ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef);
		try { return source == null ? null : source.getBattleValkyriesSkillKey(); } catch (e) { return null; }
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_properties == null || _skill == null) return;
		if (this.getRainErosion(_target) != null) _properties.DamageDirectAdd += 0.30;
		if (this.m.Mode == null || this.m.ModeTurns <= 0 || !::$bvvar{namespace}.isActiveWeaponAttack(_skill)) return;
		local sourceKey = this.getSourceSkillKey(_skill, _target);
		if (sourceKey == "texas_omertosa_unrelenting_downpour" || sourceKey == "texas_omertosa_torrential_sword_rain") return;
		_properties.DamageRegularMult *= 1.20;
		_properties.DamageArmorMult *= 1.20;
	}

	function onUpdate( _properties )
	{
		if (!this.m.FirstKillTriggered) _properties.DamageReceivedTotalMult *= 0.75;
	}

	function getSettlement( _actionToken, _create = false )
	{
		if (typeof _actionToken != "string" || _actionToken.len() == 0) return null;
		if (!(_actionToken in this.m.PendingSettlements) && _create) this.m.PendingSettlements[_actionToken] <- { Followup = null };
		return _actionToken in this.m.PendingSettlements ? this.m.PendingSettlements[_actionToken] : null;
	}

	function prepareDownpourFollowup( _event )
	{
		if (this.m.Mode != "downpour" || this.m.ModeTurns <= 0 || this.m.DownpourCharges <= 0 || _event == null
			|| !("Actor" in _event) || _event.Actor != this.getOwner() || !("Target" in _event) || _event.Target == null
			|| !("ActionToken" in _event) || _event.ActionToken == null || !("IsActiveWeaponAttack" in _event) || !_event.IsActiveWeaponAttack
			|| ("Source" in _event && _event.Source == "followup")) return;
		local owner = this.getOwner();
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, _event.Target)) return;
		local settlement = this.getSettlement(_event.ActionToken, true);
		settlement.Followup = {
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_event.Target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target)
		};
		if (!::$bvvar{namespace}.queueValkyrieActionSettlementTask(_event.ActionToken, this)) delete this.m.PendingSettlements[_event.ActionToken];
	}

	function healFirstKill()
	{
		local owner = this.getOwner();
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner)) return false;
		owner.setHitpoints(owner.getHitpointsMax());
		owner.setDirty(true);
		if (owner.isPlacedOnMap()) this.spawnIcon("status_effect_79", owner.getTile());
		return true;
	}

	function triggerFirstKill( _event )
	{
		if (this.m.FirstKillTriggered || _event == null || !("Attacker" in _event) || _event.Attacker != this.getOwner()
			|| !("Victim" in _event) || _event.Victim == null || !("Before" in _event) || !("After" in _event)
			|| _event.Before.Hitpoints <= 0 || _event.After.Hitpoints > 0) return false;
		this.m.FirstKillTriggered = true;
		this.healFirstKill();
		if (this.m.Mode == null || this.m.ModeTurns <= 0)
		{
			this.m.CutInReady = true;
			this.m.CooldownTurns = 0;
			return true;
		}
		local mode = this.m.Mode;
		this.refreshModeFromFirstKill(mode);
		local actionToken = "ActionToken" in _event ? _event.ActionToken : null;
		this.m.PendingReplayToken = actionToken;
		this.m.PendingReplayMode = mode;
		if (actionToken != null && ::$bvvar{namespace}.queueValkyrieActionSettlementTask(actionToken, this)) return true;
		local skillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(this);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function( _tag )
		{
			local skill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_tag.SkillRef);
			if (skill != null) skill.resolvePendingReplay(_tag.ActionToken);
		}, { SkillRef = skillRef, ActionToken = actionToken });
		return true;
	}

	function resolveDownpourFollowup( _pending, _actionToken )
	{
		if (_pending == null || this.m.Mode != "downpour" || this.m.ModeTurns <= 0 || this.m.DownpourCharges <= 0 || !this.isOwnerAlive()) return false;
		local owner = this.getOwner();
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_pending.TargetRef);
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target)) return false;
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "texas_downpour_slash");
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(owner, this, target, {
			WeaponDamageMult = 0.60, ArmorDamageMult = 1.0, DirectDamageAdd = 0.0,
			HitChance = 20, IgnoreDistance = true, ParentActionToken = _actionToken
		});
		if (result != null && "Applied" in result && result.Applied)
		{
			this.m.DownpourCharges--;
			return true;
		}
		return false;
	}

	function resolvePendingReplay( _actionToken )
	{
		if (this.m.PendingReplayMode == null || this.m.PendingReplayToken != _actionToken || !this.isOwnerAlive()) return false;
		local mode = this.m.PendingReplayMode;
		this.m.PendingReplayMode = null;
		this.m.PendingReplayToken = null;
		local key = mode == "downpour" ? "texas_omertosa_unrelenting_downpour" : "texas_omertosa_torrential_sword_rain";
		local skill = ::$bvvar{namespace}.getRuntimeSkillByKey(this.getOwner(), key);
		if (skill == null || !("replayEntry" in skill)) return false;
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, this.getOwner(), "texas_cut_in");
		return skill.replayEntry(this.getOwner());
	}

	function onValkyrieActionSettlement( _actionToken )
	{
		local settlement = this.getSettlement(_actionToken, false);
		if (settlement != null)
		{
			delete this.m.PendingSettlements[_actionToken];
			this.resolveDownpourFollowup(settlement.Followup, _actionToken);
		}
		this.resolvePendingReplay(_actionToken);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "ActionStarted") this.prepareDownpourFollowup(_event);
		else if (_event.Type == "DamageResolved") this.triggerFirstKill(_event);
	}

	function applyDazed( _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return;
		local effect = _target.getSkills().getSkillByID("effects.dazed");
		if (effect == null) _target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
		else if ("onRefresh" in effect) effect.onRefresh();
	}

	function getSwordRainTargets()
	{
		local owner = this.getOwner();
		if (owner == null || !owner.isPlacedOnMap()) return [];
		local enemies = ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner, ::$bvvar{namespace}.getValkyrieRadiusTiles(owner.getTile(), 4, true));
		local ranked = [];
		foreach (index, enemy in enemies)
		{
			local turnDone = false;
			local initiative = 0;
			try { turnDone = enemy.isTurnDone(); } catch (e) { try { turnDone = enemy.m.IsTurnDone; } catch (ignored) {} }
			try { initiative = enemy.getInitiative(); } catch (e) { try { initiative = enemy.getCurrentProperties().getInitiative(); } catch (ignored) {} }
			ranked.push({ Target = enemy, TurnDone = turnDone, Initiative = initiative, Index = index });
		}
		ranked.sort(function( _a, _b )
		{
			if (_a.TurnDone != _b.TurnDone) return !_a.TurnDone ? -1 : 1;
			if (_a.Initiative != _b.Initiative) return _a.Initiative > _b.Initiative ? -1 : 1;
			return _a.Index < _b.Index ? -1 : (_a.Index > _b.Index ? 1 : 0);
		});
		local ret = [];
		for (local i = 0; i < ranked.len() && i < 3; i++) ret.push(ranked[i].Target);
		return ret;
	}

	function fireEndTurnSwordRain()
	{
		if (!this.isOwnerAlive()) return;
		local owner = this.getOwner();
		foreach (target in this.getSwordRainTargets())
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "texas_sword_rain");
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(owner, this, target, {
				WeaponDamageMult = 0.70, ArmorDamageMult = 1.0, DirectDamageAdd = 0.20,
				HitChance = 30, IgnoreDistance = true
			});
			if (result != null && "Hit" in result && result.Hit) this.applyDazed(target);
		}
	}

	function onTurnStart()
	{
		if (!this.m.CutInReady && this.m.CooldownTurns > 0)
		{
			this.m.CooldownTurns--;
			if (this.m.CooldownTurns <= 0) this.m.CutInReady = true;
		}
	}

	function onTurnEnd()
	{
		if (this.m.Mode == "sword_rain" && this.m.ModeTurns > 0) this.fireEndTurnSwordRain();
		if (this.m.ModeTurns > 0 && --this.m.ModeTurns <= 0)
		{
			this.m.Mode = null;
			this.m.DownpourCharges = 0;
		}
	}

	function resetCombatState()
	{
		this.m.CutInReady = true;
		this.m.CooldownTurns = 0;
		this.m.Mode = null;
		this.m.ModeTurns = 0;
		this.m.DownpourCharges = 0;
		this.m.FirstKillTriggered = false;
		this.m.PendingSettlements = {};
		this.m.PendingReplayToken = null;
		this.m.PendingReplayMode = null;
	}

	function onCombatStarted()
	{
		this.resetCombatState();
	}

	function onDeath( _fatalityType )
	{
		this.m.PendingSettlements = {};
		this.m.PendingReplayToken = null;
		this.m.PendingReplayMode = null;
	}

	function onCombatFinished()
	{
		this.resetCombatState();
		this.skill.onCombatFinished();
	}
});
