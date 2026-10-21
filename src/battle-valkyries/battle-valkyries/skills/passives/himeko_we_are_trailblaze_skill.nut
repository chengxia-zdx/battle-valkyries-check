this.himeko_we_are_trailblaze_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		PendingFollowups = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.PendingFollowups = {};
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.himeko_we_are_trailblaze.tooltip.trigger}" },
			{ id = 4, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.himeko_we_are_trailblaze.tooltip.followup}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.himeko_we_are_trailblaze.tooltip.restriction}" }
		];
	}

	function getOwner()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function isOwnerReady()
	{
		local actor = this.getOwner();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return false;
		try { return actor.isPlacedOnMap(); }
		catch (e) { return false; }
	}

	function hasUsableWeapon()
	{
		local actor = this.getOwner();
		if (actor == null || actor.getItems() == null) return false;
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.Weapon);
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "counter"
			|| _source == "followup" || _source == "fixed_damage" || _source == "damage_over_time";
	}

	function isFriendlyActiveAttack( _event )
	{
		if (_event == null || !("Actor" in _event) || _event.Actor == null
			|| !("Target" in _event) || _event.Target == null
			|| !("ActionToken" in _event) || _event.ActionToken == null
			|| !("IsDirectAttack" in _event) || !_event.IsDirectAttack
			|| ("IsImplicit" in _event && _event.IsImplicit)
			|| ("IsCounterOrAOO" in _event && _event.IsCounterOrAOO)
			|| ("IsFollowup" in _event && _event.IsFollowup)
			|| this.isExcludedSource("Source" in _event ? _event.Source : null))
		{
			return false;
		}

		local owner = this.getOwner();
		if (owner == null) return false;
		try { return _event.Actor.isAlliedWith(owner) && !_event.Target.isAlliedWith(owner); }
		catch (e) { return false; }
	}

	function rememberFollowup( _event )
	{
		if (!this.isFriendlyActiveAttack(_event)) return false;
		this.m.PendingFollowups[_event.ActionToken] <- {
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_event.Target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target)
		};
		if (!::$bvvar{namespace}.queueValkyrieActionSettlementTask(_event.ActionToken, this))
		{
			delete this.m.PendingFollowups[_event.ActionToken];
			return false;
		}
		try
		{
			::logInfo("[Battle Valkyries] [HimekoTrailblaze] stage=armed action=" + _event.ActionToken
				+ " attacker=" + ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Actor)
				+ " target=" + ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target));
		}
		catch (e) {}
		return true;
	}

	function onValkyrieActionSettlement( _actionToken )
	{
		if (typeof _actionToken != "string") return;
		try
		{
			::logInfo("[Battle Valkyries] [HimekoTrailblaze] stage=settlement_task action=" + _actionToken
				+ " armed=" + (_actionToken in this.m.PendingFollowups));
		}
		catch (e) {}
		this.tryFireFollowup(_actionToken);
	}

	function removeLegacyChargeEffect()
	{
		local c = this.getContainer();
		if (c == null) return false;
		local effect = c.getSkillByID("$bvvar{modId}.effects.himeko_victory_rush_charge");
		if (effect == null) return false;
		try
		{
			c.remove(effect);
			return true;
		}
		catch (e)
		{
			return false;
		}
	}

	function playFollowupCastVisuals( _target )
	{
		if (_target == null) return;
		try
		{
			if (!_target.isPlacedOnMap()) return;
			local actor = this.getOwner();
			if (actor == null || !actor.isPlacedOnMap()) return;
			this.spawnIcon("status_effect_34", actor.getTile());
			if ("playValkyrieVisual" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.playValkyrieVisual(this, actor, "himeko_owner_ring");
			}
		}
		catch (e) {}
	}

	function playFollowupImpactVisuals( _target )
	{
		if (_target == null) return;
		try
		{
			if (!_target.isPlacedOnMap()) return;
			this.spawnIcon("status_effect_34", _target.getTile());
			local played = false;
			if ("playValkyrieVisual" in ::$bvvar{namespace})
			{
				played = ::$bvvar{namespace}.playValkyrieVisual(this, _target, "himeko_orbital");
			}
			if (!played)
			{
				this.Tactical.spawnSpriteEffect("effect_fire_01", this.createColor("#ff9d42"), _target.getTile(), 0, 45, 1.45, 0.25, 0, 520, 200);
			}
		}
		catch (e) {}
	}

	function tryFireFollowup( _actionToken )
	{
		if (!(_actionToken in this.m.PendingFollowups)) return false;
		local pending = this.m.PendingFollowups[_actionToken];
		delete this.m.PendingFollowups[_actionToken];
		if (!this.isOwnerReady() || !this.hasUsableWeapon()) return false;

		local actor = this.getOwner();
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(pending.TargetRef);
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target)) return false;
		try
		{
			if (!target.isPlacedOnMap() || target.isAlliedWith(actor)) return false;
		}
		catch (e)
		{
			return false;
		}

		this.playFollowupCastVisuals(target);
		// Draw the orbital strike before damage so a lethal follow-up remains visible.
		this.playFollowupImpactVisuals(target);
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(actor, this, target, {
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.5,
			DirectDamageAdd = 0.25,
			ParentActionToken = _actionToken
		});
		try
		{
			::logInfo("[Battle Valkyries] [HimekoTrailblaze] stage=followup action=" + _actionToken
				+ " target=" + pending.TargetID
				+ " applied=" + (result != null && "Applied" in result ? result.Applied : false)
				+ " hit=" + (result != null && "Hit" in result ? result.Hit : false));
		}
		catch (e) {}
		return true;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "ActionStarted")
		{
			this.rememberFollowup(_event);
			return;
		}
		if (_event.Type == "ActionResolved" && "ActionToken" in _event && _event.ActionToken != null
			&& _event.ActionToken in this.m.PendingFollowups)
		{
			// Unsupported third-party action paths may never expose a safe
			// synchronous settlement boundary. Drop their reservation instead
			// of mutating tactical entities after AI evaluation has resumed.
			delete this.m.PendingFollowups[_event.ActionToken];
		}
	}

	function resetCombatState()
	{
		this.m.PendingFollowups = {};
		this.removeLegacyChargeEffect();
	}

	function onAdded() { this.removeLegacyChargeEffect(); }
	function onRemoved() { this.resetCombatState(); }
	function onCombatStarted() { this.resetCombatState(); }
	function onCombatFinished() { this.resetCombatState(); this.skill.onCombatFinished(); }
});
