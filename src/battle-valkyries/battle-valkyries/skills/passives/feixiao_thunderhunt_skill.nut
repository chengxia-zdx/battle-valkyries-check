this.feixiao_thunderhunt_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { AttackProgress = 0, GainsThisRound = 0, FollowupUsedThisRound = false, PendingTargets = null },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.AttackProgress = 0;
		this.m.GainsThisRound = 0;
		this.m.FollowupUsedThisRound = false;
		this.m.PendingTargets = {};
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.feixiao_thunderhunt.tooltip.aureus}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.feixiao_thunderhunt.tooltip.followup}" },
			{ id = 5, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.feixiao_thunderhunt.tooltip.hit}" }
		];
	}

	function getAureusEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.feixiao_flying_aureus");
	}

	function ensureAureusEffect()
	{
		local effect = this.getAureusEffect();
		if (effect != null) return effect;
		local c = this.getContainer();
		if (c == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/feixiao_flying_aureus_effect");
		c.add(effect);
		return effect;
	}

	function getOwner()
	{
		local c = this.getContainer();
		return c == null ? null : c.getActor();
	}

	function hasMeleeWeapon()
	{
		local owner = this.getOwner();
		if (owner == null) return false;
		local weapon = null;
		try { weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isOwnerAbleToFollowup()
	{
		local owner = this.getOwner();
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !this.hasMeleeWeapon()) return false;
		try { if (owner.getMoraleState() == this.Const.MoraleState.Fleeing) return false; } catch (e) {}
		try { if (owner.getSkills().hasSkill("effects.stunned")) return false; } catch (e) {}
		return true;
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "counter" || _source == "followup"
			|| _source == "fixed_damage" || _source == "damage_over_time" || _source == "terraverge";
	}

	function isTerravergeAction( _event )
	{
		if (_event == null || !("Skill" in _event) || _event.Skill == null) return false;
		try { return _event.Skill.getID() == ::$bvvar{namespace}.getValkyrieSkillRuntimeID("feixiao_terraverge"); }
		catch (e) { return false; }
	}

	function isQualifyingAttack( _event )
	{
		if (_event == null || !("Actor" in _event) || _event.Actor == null || !("Target" in _event) || _event.Target == null
			|| !("IsDirectAttack" in _event) || !_event.IsDirectAttack || this.isExcludedSource("Source" in _event ? _event.Source : null)
			|| this.isTerravergeAction(_event)) return false;
		local owner = this.getOwner();
		if (owner == null || _event.Target.isAlliedWith(owner)) return false;
		return _event.Actor == owner || ::$bvvar{namespace}.isEligibleRosterAlly(owner, _event.Actor);
	}

	function recordAttackProgress()
	{
		local effect = this.ensureAureusEffect();
		if (effect == null || effect.isReady() || this.m.GainsThisRound >= 2) return false;
		this.m.AttackProgress++;
		try { ::logInfo("[Battle Valkyries] [FeixiaoAureus] stage=progress progress=" + this.m.AttackProgress + " count=" + effect.getCount()); } catch (e) {}
		if (this.m.AttackProgress < 2) return true;
		this.m.AttackProgress = 0;
		this.m.GainsThisRound++;
		effect.addCount(1);
		try { ::logInfo("[Battle Valkyries] [FeixiaoAureus] stage=gain progress=0 count=" + effect.getCount()); } catch (e) {}
		return true;
	}

	function rememberAllyAction( _event )
	{
		if (!this.isQualifyingAttack(_event) || _event.Actor == this.getOwner() || !("ActionToken" in _event) || _event.ActionToken == null) return;
		this.m.PendingTargets[_event.ActionToken] <- {
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_event.Target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target)
		};
	}

	function getFollowupTarget( _target )
	{
		local owner = this.getOwner();
		if (owner == null) return null;
		if (::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, _target, 4, true)) return _target;
		return ::$bvvar{namespace}.findNearestValkyrieEnemy(owner, 4, true);
	}

	function executeThunderhunt( _target, _consumeRoundUse = false, _parentActionToken = null )
	{
		if (!this.isOwnerAbleToFollowup() || (_consumeRoundUse && this.m.FollowupUsedThisRound)) return false;
		local owner = this.getOwner();
		local target = this.getFollowupTarget(_target);
		if (target == null) return false;
		this.playThunderhuntCastVisuals(owner);
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(owner, this, target, {
			WeaponDamageMult = 0.60, ArmorDamageMult = 1.0, DirectDamageAdd = 0.0,
			HitChance = 20, IgnoreDistance = true, IgnoreShield = true, ParentActionToken = _parentActionToken
		});
		if (result == null || !("Applied" in result) || !result.Applied) return false;
		if ("Hit" in result && result.Hit) this.playThunderhuntImpactVisuals(target);
		if (_consumeRoundUse) this.m.FollowupUsedThisRound = true;
		this.recordAttackProgress();
		try
		{
			::logInfo("[Battle Valkyries] [FeixiaoThunderhunt] target=" + ::$bvvar{namespace}.getValkyrieCombatObjectID(target)
				+ " hit=" + ("Hit" in result ? result.Hit : false) + " progress=" + this.m.AttackProgress
				+ " aureus=" + (this.getAureusEffect() == null ? -1 : this.getAureusEffect().getCount()));
		}
		catch (e) {}
		return true;
	}

	function playThunderhuntCastVisuals( _owner )
	{
		if (_owner == null) return;
		try
		{
			if (!_owner.isPlacedOnMap()) return;
			local lightningPlayed = false;
			local auraPlayed = false;
			if ("playValkyrieVisual" in ::$bvvar{namespace})
			{
				lightningPlayed = ::$bvvar{namespace}.playValkyrieVisual(this, _owner, "feixiao_thunderhunt_cast");
				auraPlayed = ::$bvvar{namespace}.playValkyrieVisual(this, _owner, "feixiao_thunderhunt_aura");
			}
			if (!lightningPlayed)
			{
				local offsets = [
					{ X = -42, Y = 45 },
					{ X = 42, Y = 45 },
					{ X = 0, Y = 82 },
					{ X = 0, Y = 12 }
				];
				for (local i = 0; i < offsets.len(); ++i)
				{
					this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#67e8f9"), _owner.getTile(), offsets[i].X, offsets[i].Y, 0.9 + i * 0.08, 0.25, i * 70, 1000, 200);
				}
			}
			if (!auraPlayed)
			{
				local effects = ["effect_lightning_01", "effect_lightning_02", "effect_lightning_03"];
				local offsets = [
					{ X = -28, Y = 43 },
					{ X = 28, Y = 43 },
					{ X = -12, Y = 70 },
					{ X = 12, Y = 20 }
				];
				for (local i = 0; i < offsets.len(); ++i)
				{
					this.Tactical.spawnSpriteEffect(effects[i % effects.len()], this.createColor("#9af7ff"), _owner.getTile(), offsets[i].X, offsets[i].Y, 0.55 + i * 0.08, 0.25, i * 55, 1000, 200);
				}
			}
		}
		catch (e) {}
	}

	function playThunderhuntImpactVisuals( _target )
	{
		if (_target == null) return;
		try
		{
			if (!_target.isPlacedOnMap()) return;
			this.spawnIcon("status_effect_34", _target.getTile());
			local played = false;
			if ("playValkyrieVisual" in ::$bvvar{namespace})
				played = ::$bvvar{namespace}.playValkyrieVisual(this, _target, "feixiao_lance", { Scale = 1.2, Duration = 320, Layers = 2 });
			if (!played)
				this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#67e8f9"), _target.getTile(), 0, 45, 1.2, 0.25, 0, 320, 200);
		}
		catch (e) {}
	}

	function resolveAllyAction( _event )
	{
		if (_event == null || !("ActionToken" in _event) || _event.ActionToken == null || !(_event.ActionToken in this.m.PendingTargets)) return false;
		local pending = this.m.PendingTargets[_event.ActionToken];
		delete this.m.PendingTargets[_event.ActionToken];
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(pending.TargetRef);
		return this.executeThunderhunt(target, true, _event.ActionToken);
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_properties == null) return;
		local owner = this.getOwner();
		local policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(owner, _skill, _target);
		if (policy != null && "SourceSkillRef" in policy && ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef) == this) _properties.MeleeSkill += 20;
	}

	function resetRoundState()
	{
		this.m.GainsThisRound = 0;
		this.m.FollowupUsedThisRound = false;
	}

	function resetCombatState( _startingAureus = 0 )
	{
		this.m.AttackProgress = 0;
		this.m.PendingTargets = {};
		this.resetRoundState();
		local effect = this.ensureAureusEffect();
		if (effect != null) effect.setCount(_startingAureus);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "ActionStarted")
		{
			if (this.isQualifyingAttack(_event)) { this.recordAttackProgress(); this.rememberAllyAction(_event); }
			return;
		}
		if (_event.Type == "ActionResolved") this.resolveAllyAction(_event);
	}

	function onNewRound()
	{
		this.resetRoundState();
		this.m.PendingTargets = {};
	}

	function onCombatStarted()
	{
		this.resetCombatState(3);
		try { ::logInfo("[Battle Valkyries] [FeixiaoAureus] stage=combat-start count=" + (this.getAureusEffect() == null ? -1 : this.getAureusEffect().getCount())); } catch (e) {}
	}
	function onCombatFinished() { this.resetCombatState(0); this.skill.onCombatFinished(); }
});
