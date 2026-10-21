this.himeko_victory_rush_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { BrokenArmorParts = null, DefeatedTargets = null, PendingFollowups = null },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.BrokenArmorParts = {};
		this.m.DefeatedTargets = {};
		this.m.PendingFollowups = {};
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.himeko_victory_rush.tooltip.charge}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.himeko_victory_rush.tooltip.followup}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.himeko_victory_rush.tooltip.snapshot}" }
		];
	}

	function getChargeEffect()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.himeko_victory_rush_charge");
	}

	function isReplacedByTrailblaze()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor != null && ::$bvvar{namespace}.hasHimekoTrailblazeUnlocked(actor);
	}

	function removeChargeEffect()
	{
		local c = this.getContainer();
		local effect = this.getChargeEffect();
		if (c == null || effect == null) return false;
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

	function ensureChargeEffect()
	{
		if (this.isReplacedByTrailblaze()) return null;
		local effect = this.getChargeEffect();
		if (effect != null) return effect;
		local c = this.getContainer();
		if (c == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/himeko_victory_rush_charge_effect");
		c.add(effect);
		return effect;
	}

	function isOwnerAlive()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return false;
		try { return actor.isPlacedOnMap(); }
		catch (e) { return false; }
	}

	function getArmorPartKey( _target, _part )
	{
		return ::$bvvar{namespace}.getValkyrieCombatObjectID(_target) + ":" + _part;
	}

	function tryGainArmorBreakCharge( _event )
	{
		if (!this.isOwnerAlive() || _event == null || !("Victim" in _event) || _event.Victim == null
			|| !("Before" in _event) || !("After" in _event)) return;
		local owner = this.getContainer().getActor();
		local target = _event.Victim;
		try { if (target.isAlliedWith(owner)) return; } catch (e) { return; }
		local gained = 0;
		foreach (part in ["Head", "Body"])
		{
			local beforeKey = part + "Armor";
			if (!(beforeKey in _event.Before) || !(beforeKey in _event.After)
				|| _event.Before[beforeKey] <= 0 || _event.After[beforeKey] != 0) continue;
			local key = this.getArmorPartKey(target, part);
			if (key in this.m.BrokenArmorParts) continue;
			this.m.BrokenArmorParts[key] <- true;
			gained++;
		}
		if ("Hitpoints" in _event.Before && "Hitpoints" in _event.After
			&& _event.Before.Hitpoints > 0 && _event.After.Hitpoints <= 0)
		{
			local defeatedKey = ::$bvvar{namespace}.getValkyrieCombatObjectID(target);
			if (!(defeatedKey in this.m.DefeatedTargets))
			{
				this.m.DefeatedTargets[defeatedKey] <- true;
				gained++;
			}
		}
		if (gained > 0)
		{
			local effect = this.ensureChargeEffect();
			if (effect != null) effect.addCount(gained);
		}
	}

	function isFriendlyDirectAttack( _event )
	{
		if (_event == null || !("Actor" in _event) || _event.Actor == null || !("Target" in _event) || _event.Target == null
			|| !("ActionToken" in _event) || _event.ActionToken == null || ("IsFollowup" in _event && _event.IsFollowup)
			|| ("Source" in _event && _event.Source == "followup")) return false;
		if (!("IsDirectAttack" in _event) || !_event.IsDirectAttack) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null) return false;
		try { return _event.Actor.isAlliedWith(owner) && !_event.Target.isAlliedWith(owner); }
		catch (e) { return false; }
	}

	function prepareFollowup( _event )
	{
		if (!this.isFriendlyDirectAttack(_event)) return;
		local effect = this.ensureChargeEffect();
		if (effect == null || !effect.isReady()) return;
		this.m.PendingFollowups[_event.ActionToken] <- {
			TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_event.Target),
			TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Target)
		};
		if (!::$bvvar{namespace}.queueValkyrieActionSettlementTask(_event.ActionToken, this))
		{
			delete this.m.PendingFollowups[_event.ActionToken];
		}
	}

	function hasUsableWeapon()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getItems() == null) return false;
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.Weapon);
	}

	function tryFireFollowup( _actionToken )
	{
		if (!(_actionToken in this.m.PendingFollowups)) return false;
		local pending = this.m.PendingFollowups[_actionToken];
		delete this.m.PendingFollowups[_actionToken];
		if (!this.isOwnerAlive()) return false;
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(pending.TargetRef);
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || !this.hasUsableWeapon()) return false;
		try
		{
			if (!actor.isPlacedOnMap() || !target.isPlacedOnMap() || target.isAlliedWith(actor)) return false;
			local actorTile = actor.getTile();
			local targetTile = target.getTile();
			if (actorTile == null || targetTile == null || actorTile.getDistanceTo(targetTile) > 7) return false;
		}
		catch (e) { return false; }
		local effect = this.getChargeEffect();
		if (effect == null || !effect.isReady()) return false;
		effect.setCount(effect.getCount() - 3);
		this.playFollowupCastVisuals(target);
		// A lethal hit may unplace the target before post-hit visuals can read
		// its tile, so draw the orbital strike while the target is still placed.
		this.playFollowupImpactVisuals(target);
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(actor, this, target, {
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.5,
			DirectDamageAdd = 0.25,
			ParentActionToken = _actionToken
		});
		try
		{
			::logInfo("[Battle Valkyries] [HimekoFollowup] target=" + pending.TargetID
				+ " applied=" + (result != null && "Applied" in result ? result.Applied : false)
				+ " hit=" + (result != null && "Hit" in result ? result.Hit : false));
		}
		catch (e) {}
		return true;
	}

	function onValkyrieActionSettlement( _actionToken )
	{
		if (typeof _actionToken != "string") return;
		this.tryFireFollowup(_actionToken);
	}

	function playOwnerAttackRing( _event )
	{
		if (_event == null || !("Actor" in _event) || _event.Actor == null
			|| !("IsDirectAttack" in _event) || !_event.IsDirectAttack) return false;
		// Victory Rush owns its cast visual explicitly so it can be placed on
		// Himeko before the orbital impact is drawn on the enemy.
		if ("Source" in _event && _event.Source == "followup") return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || _event.Actor != actor || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return false;
		try
		{
			if (!actor.isPlacedOnMap() || !("playValkyrieVisual" in ::$bvvar{namespace})) return false;
			return ::$bvvar{namespace}.playValkyrieVisual(this, actor, "himeko_owner_ring");
		}
		catch (e) { return false; }
	}

	function playFollowupCastVisuals( _target )
	{
		if (_target == null) return;
		try
		{
			if (!_target.isPlacedOnMap()) return;
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null && actor.isPlacedOnMap())
			{
				this.spawnIcon("status_effect_34", actor.getTile());
			}
			local castPlayed = false;
			if ("playValkyrieVisual" in ::$bvvar{namespace})
			{
				if (actor != null && actor.isPlacedOnMap())
				{
					castPlayed = ::$bvvar{namespace}.playValkyrieVisual(this, actor, "himeko_owner_ring");
				}
			}
			if (!castPlayed && actor != null && actor.isPlacedOnMap())
			{
				try { ::$bvvar{namespace}.playValkyrieVisual(this, actor, "himeko_owner_ring"); } catch (e) {}
			}
		}
		catch (e)
		{
		}
	}

	function playFollowupImpactVisuals( _target )
	{
		if (_target == null) return;
		try
		{
			if (!_target.isPlacedOnMap()) return;
			this.spawnIcon("status_effect_34", _target.getTile());
			local impactPlayed = false;
			if ("playValkyrieVisual" in ::$bvvar{namespace})
			{
				impactPlayed = ::$bvvar{namespace}.playValkyrieVisual(this, _target, "himeko_orbital");
			}
			if (!impactPlayed)
			{
				this.Tactical.spawnSpriteEffect("effect_fire_01", this.createColor("#ff9d42"), _target.getTile(), 0, 45, 1.45, 0.25, 0, 520, 200);
			}
		}
		catch (e) {}
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (this.isReplacedByTrailblaze())
		{
			this.m.PendingFollowups = {};
			this.removeChargeEffect();
			return;
		}
		if (_event.Type == "DamageResolved") { this.tryGainArmorBreakCharge(_event); return; }
		if (_event.Type == "ActionStarted") { this.playOwnerAttackRing(_event); this.prepareFollowup(_event); return; }
		if (_event.Type == "ActionResolved" && "ActionToken" in _event && _event.ActionToken != null
			&& _event.ActionToken in this.m.PendingFollowups)
		{
			// Never start a nested tactical attack from the deferred notification:
			// tactical AI may already have resumed and a lethal follow-up can then
			// leave the native action generator pointing at a removed entity.
			delete this.m.PendingFollowups[_event.ActionToken];
		}
	}

	function resetCombatState()
	{
		this.m.BrokenArmorParts = {};
		this.m.DefeatedTargets = {};
		this.m.PendingFollowups = {};
		local effect = this.getChargeEffect();
		if (effect != null) effect.clear();
	}

	function onRemoved() { this.resetCombatState(); this.removeChargeEffect(); }
	function onCombatStarted()
	{
		this.resetCombatState();
		if (this.isReplacedByTrailblaze()) this.removeChargeEffect();
		else this.ensureChargeEffect();
	}
	function onCombatFinished() { this.resetCombatState(); this.skill.onCombatFinished(); }
});
