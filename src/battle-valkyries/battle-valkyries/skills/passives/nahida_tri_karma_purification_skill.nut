this.nahida_tri_karma_purification_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		Spec = null,
		ContributorsThisRound = null,
		TriggersThisRound = 0,
		MarkedTargets = null,
		NetworkOrdinal = 0,
		ShrineActive = false,
		ShrineCenterRef = null,
		ShrineExpireRound = 0,
		ShrineToken = null,
		ShrineOrdinal = 0,
		ShrineRadius = 0,
		SharedResolve = 0,
		ShrineAllyDamagePercent = 0.50,
		ShrineKarmaDamageMult = 1.20
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.KilledString = "$bv{skill.nahida_tri_karma_purification.killed}";
		this.m.ContributorsThisRound = {};
		this.m.MarkedTargets = [];
		this.m.Spec = {
			DamageMin = 45, DamageMax = 60, BaseDirectDamage = 0.25, BaseTriggerCap = 2, ShrineTriggerCap = 3,
			ResolveFloor = 70, ResolvePerStep = 5, MaxResolveSteps = 10, DamagePerStep = 2, DirectPerStep = 0.015
		};
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition != null && "Spec" in _definition) this.m.Spec = clone _definition.Spec;
	}

	function getOwner()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function getRound()
	{
		try { return this.Time.getRound(); } catch (e) { return 0; }
	}

	function resetRoundState()
	{
		this.m.ContributorsThisRound = {};
		this.m.TriggersThisRound = 0;
	}

	function createNetworkToken()
	{
		this.m.NetworkOrdinal++;
		local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(this.getOwner());
		return "nahida-network-" + ownerID + "-" + this.m.NetworkOrdinal;
	}

	function makeTargetRecord( _target )
	{
		return {
			Ref = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target),
			ID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target)
		};
	}

	function readTargetRecord( _record )
	{
		if (_record == null || !("Ref" in _record)) return null;
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_record.Ref);
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target)) return null;
		return target;
	}

	function getOwnedSeed( _target )
	{
		local owner = this.getOwner();
		if (owner == null || _target == null || _target.getSkills() == null) return null;
		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.nahida_seed_of_skandha");
		return effect != null && "isOwnedBy" in effect && effect.isOwnedBy(owner) && effect.isValid() ? effect : null;
	}

	function hasOwnedSeed( _target )
	{
		return this.getOwnedSeed(_target) != null;
	}

	function applySeed( _target, _networkToken, _duration )
	{
		local owner = this.getOwner();
		if (owner == null || _target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return false;
		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.nahida_seed_of_skandha");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/nahida_seed_of_skandha_effect");
			effect.setup(owner, _networkToken, _duration);
			_target.getSkills().add(effect);
		}
		else effect.setup(owner, _networkToken, _duration);
		this.m.MarkedTargets.push(this.makeTargetRecord(_target));
		try { _target.getSkills().update(); _target.setDirty(true); } catch (e) {}
		return true;
	}

	function getMarkedTargets()
	{
		local ret = [];
		local validRecords = [];
		foreach (record in this.m.MarkedTargets)
		{
			local target = this.readTargetRecord(record);
			if (target == null || !this.hasOwnedSeed(target)) continue;
			ret.push(target);
			validRecords.push(record);
		}
		this.m.MarkedTargets = validRecords;
		return ret;
	}

	function clearOwnedSeeds()
	{
		foreach (record in this.m.MarkedTargets)
		{
			local target = this.readTargetRecord(record);
			if (target == null || target.getSkills() == null) continue;
			local effect = target.getSkills().getSkillByID("$bvvar{modId}.effects.nahida_seed_of_skandha");
			if (effect != null && "isOwnedBy" in effect && effect.isOwnedBy(this.getOwner())) effect.removeSelf();
			try { target.getSkills().update(); target.setDirty(true); } catch (e) {}
		}
		this.m.MarkedTargets = [];
	}

	function extendOwnedSeeds( _rounds )
	{
		foreach (target in this.getMarkedTargets())
		{
			local effect = this.getOwnedSeed(target);
			if (effect != null) effect.addRounds(_rounds);
		}
	}

	function isRosterMember( _actor )
	{
		if (_actor == null) return false;
		local actorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
		try
		{
			foreach (candidate in ::World.getPlayerRoster().getAll())
			{
				candidate = ::$bvvar{namespace}.readValkyrieCombatWeakRef(candidate);
				if (candidate == _actor || (actorID != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(candidate) == actorID)) return true;
			}
		}
		catch (e) {}
		return false;
	}

	function isEligibleTriggerEvent( _event )
	{
		if (_event == null || !("Victim" in _event) || !("Attacker" in _event) || !("Skill" in _event)) return false;
		local owner = this.getOwner();
		local attacker = _event.Attacker;
		local skill = _event.Skill;
		local damage = ("HitpointDamage" in _event ? _event.HitpointDamage : 0) + ("ArmorDamage" in _event ? _event.ArmorDamage : 0);
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner) || attacker == null || skill == null || skill == this || damage <= 0) return false;
		if (!this.isRosterMember(attacker) || !this.hasOwnedSeed(_event.Victim)) return false;
		if (::$bvvar{namespace}.isCounterOrAOO(_event) || ::$bvvar{namespace}.isValkyrieFollowup(_event)) return false;
		local source = "Source" in _event && typeof _event.Source == "string" ? _event.Source : "";
		if (source == "nahida_tri_karma_purification" || source == "nahida_all_schemes_to_know") return false;
		if (::$bvvar{namespace}.isDirectAttack(skill)) return true;
		return source.find("damage_over_time") != null || source.find("dot") != null;
	}

	function getResolveSteps()
	{
		local owner = this.getOwner();
		if (owner == null) return 0;
		local bravery = 0;
		try { bravery = owner.getCurrentProperties().Bravery; } catch (e) { bravery = 0; }
		local above = this.Math.max(0, bravery - this.m.Spec.ResolveFloor);
		return this.Math.min(this.m.Spec.MaxResolveSteps, this.Math.floor(above / this.m.Spec.ResolvePerStep));
	}

	function getKarmaDamageRoll()
	{
		local damage = this.Math.rand(this.m.Spec.DamageMin, this.m.Spec.DamageMax) + this.getResolveSteps() * this.m.Spec.DamagePerStep;
		if (this.isShrineActive()) damage = this.Math.floor(damage * this.m.ShrineKarmaDamageMult);
		return damage;
	}

	function getKarmaDirectDamage()
	{
		return this.m.Spec.BaseDirectDamage + this.getResolveSteps() * this.m.Spec.DirectPerStep;
	}

	function applyKarmaDamage( _target )
	{
		local owner = this.getOwner();
		if (owner == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return false;
		local damage = this.getKarmaDamageRoll();
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage;
		hitInfo.DamageArmor = damage;
		hitInfo.DamageDirect = this.getKarmaDirectDamage();
		hitInfo.DamageMinimum = 0;
		hitInfo.DamageFatigue = 0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _target, "nahida_tri_karma", { Scale = 0.72, EndScale = 0.98 });
		local token = ::$bvvar{namespace}.pushValkyrieCombatSource("nahida_tri_karma_purification", owner, { Skill = this });
		try { _target.onDamageReceived(owner, this, hitInfo); }
		catch (e)
		{
			if (token != null) ::$bvvar{namespace}.popValkyrieCombatSource(token);
			throw e;
		}
		if (token != null) ::$bvvar{namespace}.popValkyrieCombatSource(token);
		return true;
	}

	function triggerKarma( _attacker )
	{
		local attackerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_attacker);
		if (attackerID == null) return false;
		local key = attackerID.tostring();
		if (key in this.m.ContributorsThisRound || this.m.TriggersThisRound >= this.getTriggerCap()) return false;
		local targets = this.getMarkedTargets();
		if (targets.len() == 0) return false;
		this.m.ContributorsThisRound[key] <- true;
		this.m.TriggersThisRound++;
		foreach (target in targets) this.applyKarmaDamage(target);
		return true;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved" || !this.isEligibleTriggerEvent(_event)) return;
		this.triggerKarma(_event.Attacker);
	}

	function getTriggerCap()
	{
		return this.isShrineActive() ? this.m.Spec.ShrineTriggerCap : this.m.Spec.BaseTriggerCap;
	}

	function getRosterActors()
	{
		local ret = [];
		try
		{
			foreach (actor in ::World.getPlayerRoster().getAll())
			{
				actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(actor);
				if (actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)) ret.push(actor);
			}
		}
		catch (e) {}
		return ret;
	}

	function calculateSharedResolve( _percent, _cap )
	{
		local highest = 0;
		foreach (actor in this.getRosterActors())
		{
			try { highest = this.Math.max(highest, actor.getCurrentProperties().Bravery); } catch (e) {}
		}
		return this.Math.min(_cap, this.Math.floor(highest * _percent));
	}

	function beginShrine( _centerTile, _spec )
	{
		local owner = this.getOwner();
		if (owner == null || _centerTile == null || _spec == null || ::$bvvar{namespace}.isActorDeadOrDying(owner)) return false;
		this.clearShrine();
		this.m.SharedResolve = this.calculateSharedResolve(_spec.SharedResolvePercent, _spec.SharedResolveCap);
		this.m.ShrineRadius = _spec.Radius;
		this.m.ShrineAllyDamagePercent = _spec.AllyDamagePercent;
		this.m.ShrineKarmaDamageMult = _spec.KarmaDamageMult;
		this.m.ShrineCenterRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_centerTile);
		this.m.ShrineExpireRound = this.getRound() + _spec.Duration;
		this.m.ShrineOrdinal++;
		this.m.ShrineToken = "nahida-shrine-" + ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) + "-" + this.m.ShrineOrdinal;
		this.m.ShrineActive = true;
		this.extendOwnedSeeds(_spec.MarkExtension);
		foreach (actor in this.getRosterActors()) this.applyShrineEffect(actor);
		return true;
	}

	function applyShrineEffect( _actor )
	{
		if (_actor == null || _actor.getSkills() == null) return;
		local effect = _actor.getSkills().getSkillByID("$bvvar{modId}.effects.nahida_shrine_of_maya");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/nahida_shrine_of_maya_effect");
			effect.setup(this.getOwner(), this.m.ShrineToken);
			_actor.getSkills().add(effect);
		}
		else effect.setup(this.getOwner(), this.m.ShrineToken);
		try { _actor.getSkills().update(); _actor.setDirty(true); } catch (e) {}
	}

	function isShrineActive()
	{
		local owner = this.getOwner();
		return this.m.ShrineActive && owner != null && !::$bvvar{namespace}.isActorDeadOrDying(owner)
			&& this.m.ShrineCenterRef != null && this.getRound() < this.m.ShrineExpireRound;
	}

	function isShrineTokenActive( _token )
	{
		return this.isShrineActive() && typeof _token == "string" && _token == this.m.ShrineToken;
	}

	function isActorInsideShrine( _actor )
	{
		if (!this.isShrineActive() || _actor == null) return false;
		local center = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.ShrineCenterRef);
		if (center == null) return false;
		try { return _actor.isPlacedOnMap() && center.getDistanceTo(_actor.getTile()) <= this.m.ShrineRadius; }
		catch (e) { return false; }
	}

	function getSharedResolve() { return this.isShrineActive() ? this.m.SharedResolve : 0; }

	function getShrineAllyDamageBonus()
	{
		return this.isShrineActive() ? this.getSharedResolve() * this.m.ShrineAllyDamagePercent / 100.0 : 0.0;
	}

	function clearShrine()
	{
		local owner = this.getOwner();
		foreach (actor in this.getRosterActors())
		{
			if (actor.getSkills() == null) continue;
			local effect = actor.getSkills().getSkillByID("$bvvar{modId}.effects.nahida_shrine_of_maya");
			if (effect != null && (owner == null || effect.getOwner() == owner)) effect.removeSelf();
			try { actor.getSkills().update(); actor.setDirty(true); } catch (e) {}
		}
		this.m.ShrineActive = false;
		this.m.ShrineCenterRef = null;
		this.m.ShrineExpireRound = 0;
		this.m.ShrineToken = null;
		this.m.ShrineRadius = 0;
		this.m.SharedResolve = 0;
	}

	function onNewRound()
	{
		this.resetRoundState();
		if (this.m.ShrineActive && !this.isShrineActive()) this.clearShrine();
	}

	function onCombatStarted()
	{
		this.clearOwnedSeeds();
		this.clearShrine();
		this.resetRoundState();
		this.m.NetworkOrdinal = 0;
		this.m.ShrineOrdinal = 0;
	}

	function onDeath( _fatalityType )
	{
		this.clearOwnedSeeds();
		this.clearShrine();
	}

	function onCombatFinished()
	{
		this.clearOwnedSeeds();
		this.clearShrine();
		this.resetRoundState();
		this.skill.onCombatFinished();
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_tri_karma_purification.tooltip.trigger}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.nahida_tri_karma_purification.tooltip.damage}" },
			{ id = 5, type = "text", icon = "ui/icons/bravery.png", text = "$bv{skill.nahida_tri_karma_purification.tooltip.resolve}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_tri_karma_purification.tooltip.limit}" }
		];
		if (this.isShrineActive()) ret.push({ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_tri_karma_purification.tooltip.domain_active}" });
		return ret;
	}
});
