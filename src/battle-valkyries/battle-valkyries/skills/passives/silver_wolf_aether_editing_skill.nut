::$bvvar{namespace}.getSilverWolfRewriteController <- function( _actor )
{
	if (_actor == null) return null;
	try { return _actor.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("silver_wolf_aether_editing")); }
	catch (e) { return null; }
};

::$bvvar{namespace}.isSilverWolfRewriteActorPresent <- function( _actor )
{
	if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor)) return false;
	try { return _actor.isPlacedOnMap(); }
	catch (e) { return true; }
};

::$bvvar{namespace}.SilverWolfTargetDebugSeen <- {};
::$bvvar{namespace}.logSilverWolfTargetDebug <- function( _skill, _targetTile, _stage, _reason, _details = "" )
{
	local target = null;
	try { if (_targetTile != null && _targetTile.IsOccupiedByActor) target = _targetTile.getEntity(); } catch (e) { target = null; }
	if (target == null) return;
	local skillID = "unknown";
	local targetID = "unknown";
	try { skillID = _skill == null ? "unknown" : _skill.getID(); } catch (e) {}
	try { targetID = target.getID(); } catch (e) {}
	local key = _stage + "|" + _reason + "|" + skillID + "|" + targetID;
	if (key in ::$bvvar{namespace}.SilverWolfTargetDebugSeen) return;
	::$bvvar{namespace}.SilverWolfTargetDebugSeen[key] <- true;
	::logInfo("[Battle Valkyries] [SilverWolfTarget] stage=" + _stage + " reason=" + _reason + " skill=" + skillID + " target=" + targetID + (_details == "" ? "" : " " + _details));
};

::$bvvar{namespace}.isSilverWolfRewriteTarget <- function( _owner, _targetTile, _skill, _maxRange = 7 )
{
	if (_owner == null || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
	try
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (!target.isAlive() || target.isDying() || target.getHitpoints() <= 0)
		{
			::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "dead_or_dying");
			return false;
		}
		if (!target.isAttackable())
		{
			::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "not_attackable");
			return false;
		}
		if (_owner.isAlliedWith(target))
		{
			::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "allied");
			return false;
		}
		local distance = _owner.getTile().getDistanceTo(_targetTile);
		if (distance < 1 || distance > _maxRange)
		{
			::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "range", "distance=" + distance + " max=" + _maxRange);
			return false;
		}
		local visible = null;
		try { visible = _targetTile.IsVisibleForEntity; } catch (visibilityError) { visible = null; }
		if (visible == null && "Visible" in target) visible = target.Visible;
		if (visible != null && !visible)
		{
			::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "not_visible", "distance=" + distance);
			return false;
		}
		::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "accepted", "distance=" + distance + " visible=" + visible);
		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.logSilverWolfTargetDebug(_skill, _targetTile, "rewrite", "exception", "error=" + e);
		return false;
	}
};

this.silver_wolf_aether_editing_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { UsedThisTurn = false, TargetRef = null, TargetID = null, PersistentMode = null },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.UsedThisTurn = false;
		this.m.TargetRef = null;
		this.m.TargetID = null;
		this.m.PersistentMode = null;
	}

	function getOwner()
	{
		local c = this.getContainer();
		return c == null ? null : c.getActor();
	}

	function getOwnerID()
	{
		return ::$bvvar{namespace}.getValkyrieCombatObjectID(this.getOwner());
	}

	function getPersistentTarget()
	{
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.TargetRef);
		if (target == null || ::$bvvar{namespace}.getValkyrieCombatObjectID(target) != this.m.TargetID || !::$bvvar{namespace}.isSilverWolfRewriteActorPresent(target))
		{
			this.clearPersistentTarget();
			return null;
		}
		return target;
	}

	function hasPersistentTarget() { return this.getPersistentTarget() != null; }
	function isUsedThisTurn() { return this.m.UsedThisTurn; }
	function canRewrite() { return !this.m.UsedThisTurn && ::$bvvar{namespace}.isSilverWolfRewriteActorPresent(this.getOwner()); }

	function getPersistentEffectID( _mode )
	{
		local ownerID = this.getOwnerID();
		return "$bvvar{modId}.effects.silver_wolf_" + _mode + "_vulnerability." + (ownerID == null ? "none" : ownerID);
	}

	function clearPersistentTarget()
	{
		local target = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.TargetRef);
		local mode = this.m.PersistentMode;
		if (target != null && mode != null)
		{
			try
			{
				local effect = target.getSkills().getSkillByID(this.getPersistentEffectID(mode));
				if (effect != null) target.getSkills().remove(effect);
			}
			catch (e) {}
		}
		this.m.TargetRef = null;
		this.m.TargetID = null;
		this.m.PersistentMode = null;
	}

	function applyPersistentVulnerability( _target, _mode )
	{
		local owner = this.getOwner();
		if (!this.canRewrite() || !::$bvvar{namespace}.isSilverWolfRewriteActorPresent(_target)) return false;
		local script = _mode == "attack" ? "$bvvar{privateFolder}/skills/effects/silver_wolf_attack_vulnerability_effect" : "$bvvar{privateFolder}/skills/effects/silver_wolf_defense_vulnerability_effect";
		local effect = null;
		try { effect = this.new(script); effect.setSilverWolfOwner(owner); } catch (e) { effect = null; }
		if (effect == null) return false;
		this.clearPersistentTarget();
		_target.getSkills().add(effect);
		this.m.TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_target);
		this.m.TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_target);
		this.m.PersistentMode = _mode;
		this.m.UsedThisTurn = true;
		try { _target.getSkills().update(); _target.setDirty(true); owner.setDirty(true); } catch (e) {}
		return true;
	}

	function applySpeedVulnerability( _target )
	{
		local owner = this.getOwner();
		if (!this.canRewrite() || !::$bvvar{namespace}.isSilverWolfRewriteActorPresent(_target)) return false;
		local immune = false;
		try { immune = _target.getCurrentProperties().IsImmuneToStun; } catch (e) { immune = false; }
		if (immune) return false;
		this.clearPersistentTarget();
		local stun = _target.getSkills().getSkillByID("effects.stunned");
		if (stun == null)
		{
			stun = this.new("scripts/skills/effects/stunned_effect");
			if (stun == null) return false;
			_target.getSkills().add(stun);
		}
		stun.setTurns(1);
		this.m.UsedThisTurn = true;
		try { _target.getSkills().update(); _target.setDirty(true); owner.setDirty(true); } catch (e) {}
		return true;
	}

	function onTurnStart() { this.m.UsedThisTurn = false; this.getPersistentTarget(); }
	function onDeath( _fatalityType ) { this.clearPersistentTarget(); this.m.UsedThisTurn = false; }
	function onRemoved() { this.clearPersistentTarget(); }
	function onCombatFinished() { this.clearPersistentTarget(); this.m.UsedThisTurn = false; this.skill.onCombatFinished(); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.silver_wolf_aether_editing.tooltip.shared}" }
		];
	}
});
