this.sparxie_backstage_trick_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		Spec = null,
		Smile = 0,
		MaxSmile = 6,
		GuestRef = null,
		GuestID = null,
		GuestCreatedRound = -1,
		GuestExpiresAfterRound = -1,
		GuestGiftsRemaining = 0,
		PendingGuestActions = null,
		PendingConnections = null,
		CombatEpoch = -1
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.PendingGuestActions = {};
		this.m.PendingConnections = {};
	}

	function onValkyrieSkillBound( _definition )
	{
		this.m.Spec = _definition.Spec;
		this.m.MaxSmile = this.m.Spec.MaxSmile;
	}

	function getOwner()
	{
		local container = this.getContainer();
		return container == null ? null : container.getActor();
	}

	function getCurrentEpoch()
	{
		try
		{
			return ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch;
		}
		catch (e)
		{
			return -1;
		}
	}

	function getCurrentRound()
	{
		try
		{
			return this.Time.getRound();
		}
		catch (e)
		{
			return -1;
		}
	}

	function isAliveAndPlaced( _actor )
	{
		if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
		{
			return false;
		}

		try
		{
			return _actor.isPlacedOnMap() && _actor.getTile() != null;
		}
		catch (e)
		{
			return false;
		}
	}

	function isOwnerAliveAndPlaced()
	{
		return this.isAliveAndPlaced(this.getOwner());
	}

	function hasRangedWeapon()
	{
		local owner = this.getOwner();
		if (owner == null)
		{
			return false;
		}

		local weapon = null;
		try
		{
			weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		}
		catch (e)
		{
			weapon = null;
		}

		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.RangedWeapon);
	}

	function isOwnerStunnedOrFleeing()
	{
		local owner = this.getOwner();
		if (owner == null)
		{
			return true;
		}

		try
		{
			if (owner.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				return true;
			}
		}
		catch (e)
		{
		}

		try
		{
			if (owner.getSkills().hasSkill("effects.stunned"))
			{
				return true;
			}
		}
		catch (e)
		{
		}

		return false;
	}

	function getSmile()
	{
		return this.Math.max(0, this.Math.min(this.m.MaxSmile, this.m.Smile));
	}

	function getExclusiveSmileMultiplier( _smile = null )
	{
		local smile = _smile == null ? this.getSmile() : this.Math.max(0, this.Math.min(this.m.MaxSmile, _smile));
		local perSmile = this.m.Spec == null ? 0.04 : this.m.Spec.ExclusiveDamagePerSmile;
		return 1.0 + smile * perSmile;
	}

	function setSmile( _value )
	{
		local next = this.Math.max(0, this.Math.min(this.m.MaxSmile, _value));
		if (next == this.m.Smile)
		{
			return false;
		}

		this.m.Smile = next;
		this.refreshAudienceEffectDisplays();
		return true;
	}

	function addSmile( _amount )
	{
		return _amount > 0 && this.setSmile(this.m.Smile + _amount);
	}

	function clearSmile()
	{
		this.setSmile(0);
	}

	function getGuestGiftsRemaining()
	{
		return this.Math.max(0, this.m.GuestGiftsRemaining);
	}

	function getGuestRoundsRemaining()
	{
		if (this.m.GuestID == null || this.m.GuestExpiresAfterRound < 0)
		{
			return 0;
		}

		local currentRound = this.getCurrentRound();
		return currentRound < 0 ? 0 : this.Math.max(0, this.m.GuestExpiresAfterRound - currentRound + 1);
	}

	function isCurrentGuestID( _targetID )
	{
		return _targetID != null && this.m.GuestID != null && _targetID == this.m.GuestID;
	}

	function getAllActors()
	{
		if (!("Tactical" in getroottable()) || ::Tactical == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null)
		{
			return [];
		}

		try
		{
			return ::Tactical.Entities.getAllInstancesAsArray();
		}
		catch (e)
		{
			return [];
		}
	}

	function getOwnedGuestEffect( _target )
	{
		local owner = this.getOwner();
		if (_target == null || owner == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return null;
		}

		local skills = null;
		try
		{
			skills = _target.getSkills().m.Skills;
		}
		catch (e)
		{
			return null;
		}

		foreach (effect in skills)
		{
			local isGuest = false;
			local isOwned = false;
			try
			{
				isGuest = effect != null && effect.isSparxieLiveGuestEffect();
				isOwned = isGuest && effect.isOwnedBy(owner);
			}
			catch (e)
			{
				isGuest = false;
				isOwned = false;
			}

			if (isGuest && isOwned)
			{
				return effect;
			}
		}

		return null;
	}

	function getOwnedAudienceEffect( _actor )
	{
		local owner = this.getOwner();
		if (_actor == null || owner == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
		{
			return null;
		}

		local skills = null;
		try
		{
			skills = _actor.getSkills().m.Skills;
		}
		catch (e)
		{
			return null;
		}

		foreach (effect in skills)
		{
			local isAudience = false;
			local isOwned = false;
			try
			{
				isAudience = effect != null && effect.isSparxieAudienceBuffEffect();
				isOwned = isAudience && effect.isOwnedBy(owner);
			}
			catch (e)
			{
				isAudience = false;
				isOwned = false;
			}

			if (isAudience && isOwned)
			{
				return effect;
			}
		}

		return null;
	}

	function refreshActorSkills( _actor )
	{
		if (_actor == null)
		{
			return;
		}

		try
		{
			_actor.getSkills().update();
		}
		catch (e)
		{
		}

		try
		{
			_actor.setDirty(true);
		}
		catch (e)
		{
		}
	}

	function refreshAudienceEffectDisplays()
	{
		foreach (actor in this.getAllActors())
		{
			if (this.getOwnedAudienceEffect(actor) != null)
			{
				this.refreshActorSkills(actor);
			}
		}
	}

	function isEligibleAudienceMember( _owner, _actor )
	{
		if (!this.isAliveAndPlaced(_owner) || !this.isAliveAndPlaced(_actor))
		{
			return false;
		}

		local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		local actorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
		if (_owner == _actor || (ownerID != null && ownerID == actorID))
		{
			return true;
		}

		return ::$bvvar{namespace}.isEligibleRosterAlly(_owner, _actor);
	}

	function refreshAudienceEffects()
	{
		local owner = this.getOwner();
		if (!this.isAliveAndPlaced(owner))
		{
			this.clearAudienceEffects();
			return;
		}

		foreach (actor in this.getAllActors())
		{
			local effect = this.getOwnedAudienceEffect(actor);
			if (!this.isEligibleAudienceMember(owner, actor))
			{
				if (effect != null)
				{
					try
					{
						effect.removeSelf();
					}
					catch (e)
					{
					}
					this.refreshActorSkills(actor);
				}
				continue;
			}

			if (effect == null)
			{
				try
				{
					effect = ::new("$bvvar{privateFolder}/skills/effects/sparxie_audience_buff_effect");
					effect.setupOwner(owner);
					actor.getSkills().add(effect);
				}
				catch (e)
				{
					effect = null;
				}
			}

			if (effect != null)
			{
				this.refreshActorSkills(actor);
			}
		}
	}

	function clearAudienceEffects()
	{
		foreach (actor in this.getAllActors())
		{
			local effect = this.getOwnedAudienceEffect(actor);
			if (effect == null)
			{
				continue;
			}

			try
			{
				effect.removeSelf();
			}
			catch (e)
			{
			}
			this.refreshActorSkills(actor);
		}
	}

	function logGuestState( _stage, _reason )
	{
		try
		{
			::logInfo("[Battle Valkyries] [SparxieLive] stage=" + _stage
				+ " reason=" + _reason
				+ " guest=" + (this.m.GuestID == null ? "null" : this.m.GuestID)
				+ " gifts=" + this.m.GuestGiftsRemaining
				+ " smile=" + this.getSmile());
		}
		catch (e)
		{
		}
	}

	function clearGuestState( _reason = "clear" )
	{
		local oldRef = this.m.GuestRef;
		local oldID = this.m.GuestID;
		this.m.GuestRef = null;
		this.m.GuestID = null;
		this.m.GuestCreatedRound = -1;
		this.m.GuestExpiresAfterRound = -1;
		this.m.GuestGiftsRemaining = 0;
		this.m.PendingGuestActions = {};

		local oldTarget = ::$bvvar{namespace}.readValkyrieCombatWeakRef(oldRef);
		if (oldTarget != null && !::$bvvar{namespace}.isActorDeadOrDying(oldTarget))
		{
			local oldTargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(oldTarget);
			if (oldID == null || oldTargetID == oldID)
			{
				local effect = this.getOwnedGuestEffect(oldTarget);
				if (effect != null)
				{
					try
					{
						effect.removeSelf();
					}
					catch (e)
					{
					}
					this.refreshActorSkills(oldTarget);
				}
			}
		}

		this.logGuestState("cleared", _reason);
	}

	function getLivingGuest()
	{
		local guest = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.GuestRef);
		if (guest == null || !this.isCurrentGuestID(::$bvvar{namespace}.getValkyrieCombatObjectID(guest)))
		{
			return null;
		}

		return this.isAliveAndPlaced(guest) ? guest : null;
	}

	function establishGuest( _target )
	{
		local owner = this.getOwner();
		if (!this.isAliveAndPlaced(owner)
			|| !::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, _target, null, false))
		{
			return false;
		}

		this.clearGuestState("replace");
		local currentRound = this.getCurrentRound();
		this.m.GuestRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target);
		this.m.GuestID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
		this.m.GuestCreatedRound = currentRound;
		this.m.GuestExpiresAfterRound = currentRound + 1;
		this.m.GuestGiftsRemaining = this.m.Spec == null ? 3 : this.m.Spec.GuestGiftCount;

		local effect = null;
		try
		{
			effect = ::new("$bvvar{privateFolder}/skills/effects/sparxie_live_guest_effect");
			effect.setupOwner(owner);
			_target.getSkills().add(effect);
			_target.getSkills().update();
		}
		catch (e)
		{
			try
			{
				::logInfo("[Battle Valkyries] [SparxieLive] effect_add_exception=" + e);
			}
			catch (logError)
			{
			}
			effect = null;
		}

		if (effect == null || this.getOwnedGuestEffect(_target) == null)
		{
			this.clearGuestState("effect_add_failed");
			return false;
		}

		if (this.isAliveAndPlaced(_target))
		{
			try
			{
				effect.spawnIcon("status_effect_95", _target.getTile());
			}
			catch (e)
			{
			}
		}

		this.logGuestState("established", "live_connection");
		return true;
	}

	function queueLiveConnection( _actionToken, _target )
	{
		if (_target == null)
		{
			return false;
		}

		if (_actionToken == null || typeof _actionToken != "string" || _actionToken.len() == 0)
		{
			return this.establishGuest(_target);
		}

		this.m.PendingConnections[_actionToken] <- {
			Epoch = this.getCurrentEpoch(),
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target)
		};
		return true;
	}

	function resolveLiveConnection( _actionToken )
	{
		if (_actionToken == null || !(_actionToken in this.m.PendingConnections))
		{
			return false;
		}

		local record = this.m.PendingConnections[_actionToken];
		delete this.m.PendingConnections[_actionToken];
		if (record.Epoch != this.getCurrentEpoch())
		{
			return false;
		}

		// A new connection always ends the old broadcast, even when the new
		// target died during the opening attack.
		this.clearGuestState("live_connection_resolved");
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(record.TargetRef);
		if (target == null
			|| ::$bvvar{namespace}.getValkyrieCombatObjectID(target) != record.TargetID
			|| !this.isAliveAndPlaced(target))
		{
			return false;
		}

		return this.establishGuest(target);
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "counter"
			|| _source == "followup" || _source == "fixed_damage"
			|| _source == "damage_over_time" || _source == "free";
	}

	function getSourceSkill( _attacker, _skill, _target )
	{
		local policy = null;
		try
		{
			policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(_attacker, _skill, _target);
		}
		catch (e)
		{
			policy = null;
		}

		if (policy == null || !("SourceSkillRef" in policy))
		{
			return null;
		}

		return ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef);
	}

	function getSourceSkillKey( _sourceSkill )
	{
		try
		{
			return _sourceSkill == null ? null : _sourceSkill.getBattleValkyriesSkillKey();
		}
		catch (e)
		{
			return null;
		}
	}

	function isExcludedSourceSkill( _key )
	{
		return _key == "sparxie_backstage_trick"
			|| _key == "sparxie_live_connection"
			|| _key == "sparxie_carnival_live";
	}

	function isEligibleGiftAttacker( _attacker )
	{
		local owner = this.getOwner();
		if (!this.isAliveAndPlaced(owner) || !this.isAliveAndPlaced(_attacker))
		{
			return false;
		}

		local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(owner);
		local attackerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_attacker);
		if (owner == _attacker || (ownerID != null && ownerID == attackerID))
		{
			return true;
		}

		return ::$bvvar{namespace}.isEligibleRosterAlly(owner, _attacker);
	}

	function recordGuestHit( _event )
	{
		if (_event == null
			|| !("ActionToken" in _event)
			|| typeof _event.ActionToken != "string"
			|| _event.ActionToken.len() == 0
			|| !("Hit" in _event)
			|| !_event.Hit
			|| ("Nullified" in _event && _event.Nullified)
			|| ("IsFree" in _event && _event.IsFree)
			|| !("Attacker" in _event)
			|| !("Skill" in _event)
			|| !("TargetID" in _event)
			|| !this.isCurrentGuestID(_event.TargetID)
			|| !this.isEligibleGiftAttacker(_event.Attacker)
			|| !::$bvvar{namespace}.isActiveWeaponAttack(_event.Skill))
		{
			return false;
		}

		local target = "Target" in _event ? _event.Target : null;
		local sourceSkill = this.getSourceSkill(_event.Attacker, _event.Skill, target);
		local sourceSkillKey = this.getSourceSkillKey(sourceSkill);
		if (this.isExcludedSourceSkill(sourceSkillKey))
		{
			return false;
		}

		local source = "Source" in _event ? _event.Source : null;
		if (source == "followup")
		{
			local isActiveSource = false;
			try
			{
				isActiveSource = sourceSkill != null && sourceSkill.isActive();
			}
			catch (e)
			{
				isActiveSource = false;
			}
			if (!isActiveSource)
			{
				return false;
			}
		}
		else if (this.isExcludedSource(source))
		{
			return false;
		}

		// A living guest must still carry this Sparxie's effect. A killed
		// guest is deliberately not queried for skills or tile data here.
		if (target != null && !::$bvvar{namespace}.isActorDeadOrDying(target)
			&& this.getOwnedGuestEffect(target) == null)
		{
			this.clearGuestState("guest_effect_missing");
			return false;
		}

		if (_event.ActionToken in this.m.PendingGuestActions)
		{
			return false;
		}

		this.m.PendingGuestActions[_event.ActionToken] <- {
			Epoch = this.getCurrentEpoch(),
			GuestID = this.m.GuestID,
			ParentActionToken = _event.ActionToken
		};
		return true;
	}

	function logGiftResult( _record, _applied, _hit, _skippedDead )
	{
		try
		{
			::logInfo("[Battle Valkyries] [SparxieAudienceGift] token=" + _record.ParentActionToken
				+ " guest=" + _record.GuestID
				+ " applied=" + _applied
				+ " hit=" + _hit
				+ " skipped_dead=" + _skippedDead
				+ " gifts=" + this.m.GuestGiftsRemaining
				+ " smile=" + this.getSmile());
		}
		catch (e)
		{
		}
	}

	function resolveGuestHit( _actionToken )
	{
		if (_actionToken == null || !(_actionToken in this.m.PendingGuestActions))
		{
			return false;
		}

		// Delete before any follow-up helper can publish nested combat events.
		local record = this.m.PendingGuestActions[_actionToken];
		delete this.m.PendingGuestActions[_actionToken];
		if (record.Epoch != this.getCurrentEpoch()
			|| !this.isCurrentGuestID(record.GuestID))
		{
			return false;
		}

		local owner = this.getOwner();
		if (!this.isAliveAndPlaced(owner))
		{
			this.clearGuestState("owner_unavailable");
			this.clearAudienceEffects();
			this.clearSmile();
			return false;
		}

		if (!this.hasRangedWeapon())
		{
			this.clearGuestState("ranged_weapon_missing");
			return false;
		}

		if (this.isOwnerStunnedOrFleeing())
		{
			return false;
		}

		local guest = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.GuestRef);
		local guestID = ::$bvvar{namespace}.getValkyrieCombatObjectID(guest);
		if (guest == null || guestID != record.GuestID || !this.isAliveAndPlaced(guest))
		{
			this.addSmile(1);
			this.logGiftResult(record, false, false, true);
			this.clearGuestState("guest_dead_or_unplaced");
			return false;
		}

		if (this.getOwnedGuestEffect(guest) == null)
		{
			this.clearGuestState("guest_effect_missing");
			return false;
		}

		if (this.m.GuestGiftsRemaining <= 0)
		{
			this.clearGuestState("gift_count_empty");
			return false;
		}

		this.addSmile(1);
		this.m.GuestGiftsRemaining--;
		local smileMultiplier = this.getExclusiveSmileMultiplier();
		try
		{
			this.spawnIcon("status_effect_106", owner.getTile());
		}
		catch (e)
		{
		}

		// Revalidate after all UI/property refresh callbacks caused by Smile.
		guest = this.getLivingGuest();
		if (guest == null || this.getOwnedGuestEffect(guest) == null)
		{
			this.clearGuestState("guest_invalid_before_gift");
			return false;
		}

		local result = null;
		try
		{
			result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(owner, this, guest, {
				WeaponDamageMult = (this.m.Spec == null ? 0.30 : this.m.Spec.GiftWeaponDamageMult) * smileMultiplier,
				ArmorDamageMult = this.m.Spec == null ? 1.0 : this.m.Spec.GiftArmorDamageMult,
				DirectDamageAdd = 0.0,
				AutoHit = true,
				IgnoreDistance = true,
				Source = "followup",
				ParentActionToken = record.ParentActionToken
			});
		}
		catch (e)
		{
			this.logGiftResult(record, false, false, false);
			this.clearGuestState("gift_attack_exception");
			return false;
		}

		local applied = result != null && "Applied" in result && result.Applied;
		local hit = applied && "Hit" in result && result.Hit;
		this.logGiftResult(record, applied, hit, false);

		// Never touch a dead target's tile, skills, or container after attack.
		if (!this.isAliveAndPlaced(guest))
		{
			this.clearGuestState("gift_killed_guest");
			return applied;
		}

		if (hit)
		{
			try
			{
				this.spawnIcon("status_effect_95", guest.getTile());
			}
			catch (e)
			{
			}
		}

		if (this.m.GuestGiftsRemaining <= 0)
		{
			this.clearGuestState("gifts_exhausted");
		}
		else
		{
			this.refreshActorSkills(guest);
		}

		return applied;
	}

	function expireGuestIfNeeded()
	{
		if (this.m.GuestID == null)
		{
			return;
		}

		local currentRound = this.getCurrentRound();
		if (currentRound >= 0 && currentRound > this.m.GuestExpiresAfterRound)
		{
			this.clearGuestState("expired");
			return;
		}

		local guest = this.getLivingGuest();
		if (guest == null)
		{
			this.clearGuestState("guest_unavailable");
			return;
		}

		if (this.getOwnedGuestEffect(guest) == null)
		{
			this.clearGuestState("guest_effect_missing");
		}
	}

	function getTooltip()
	{
		local teamBonus = this.getSmile() * 2;
		local exclusiveBonus = this.getSmile() * 4;
		return [
			{ id = 1, type = "title", text = this.getName() + " (" + this.getSmile() + "/" + this.m.MaxSmile + ")" },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.sparxie_backstage_trick.tooltip.gift}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.sparxie_backstage_trick.tooltip.current_prefix}" + teamBonus + "$bv{skill.sparxie_backstage_trick.tooltip.current_middle}" + exclusiveBonus + "$bv{skill.sparxie_backstage_trick.tooltip.current_suffix}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.sparxie_backstage_trick.tooltip.carnival}" }
		];
	}

	function resetCombatRuntime( _reason )
	{
		this.clearGuestState(_reason);
		this.clearAudienceEffects();
		this.m.PendingConnections = {};
		this.m.PendingGuestActions = {};
		this.m.Smile = 0;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event))
		{
			return;
		}

		if (!this.isOwnerAliveAndPlaced())
		{
			this.resetCombatRuntime("owner_left_tactical");
			return;
		}

		if (_event.Type == "TargetResolved")
		{
			this.recordGuestHit(_event);
			return;
		}

		if (_event.Type == "ActionResolved")
		{
			local token = "ActionToken" in _event ? _event.ActionToken : null;
			this.resolveGuestHit(token);
			this.resolveLiveConnection(token);
			return;
		}

		if (_event.Type == "NewRound")
		{
			this.expireGuestIfNeeded();
			this.refreshAudienceEffects();
		}
	}

	function onCombatStarted()
	{
		this.resetCombatRuntime("combat_started");
		this.m.CombatEpoch = this.getCurrentEpoch();
		this.m.PendingConnections = {};
		this.m.PendingGuestActions = {};
		this.m.Smile = 0;
		this.refreshAudienceEffects();
	}

	function onTurnStart()
	{
		this.expireGuestIfNeeded();
		this.refreshAudienceEffects();
	}

	function onNewRound()
	{
		this.expireGuestIfNeeded();
		this.refreshAudienceEffects();
	}

	function onDeath( _fatalityType )
	{
		this.resetCombatRuntime("death");
	}

	function onRemoved()
	{
		this.resetCombatRuntime("removed");
	}

	function onCombatFinished()
	{
		this.resetCombatRuntime("combat_finished");
		this.m.CombatEpoch = -1;
		this.skill.onCombatFinished();
	}
});
