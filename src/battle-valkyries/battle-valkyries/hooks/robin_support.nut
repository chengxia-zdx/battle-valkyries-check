::$bvvar{namespace}.RobinAuraID <- "$bvvar{modId}.effects.robin_harmony_aura";
::$bvvar{namespace}.RobinSunnySongID <- "$bvvar{modId}.effects.robin_sunny_song";
::$bvvar{namespace}.RobinEncoreID <- "$bvvar{modId}.effects.robin_encore_protagonist";
::$bvvar{namespace}.RobinConcertoID <- "$bvvar{modId}.effects.robin_starry_concerto";
::$bvvar{namespace}.RobinGrantedActionID <- "$bvvar{modId}.effects.robin_granted_action";
::$bvvar{namespace}.RobinCleanseEffectIDs <- ["effects.dazed", "effects.staggered", "effects.distracted", "effects.disarmed"];

::$bvvar{namespace}.getRobinPassive <- function( _actor )
{
	return _actor == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(_actor, "robin_harmonic_resonance");
};

::$bvvar{namespace}.getRobinCombatRoster <- function( _owner, _includeOwner = true )
{
	local ret = [];
	if (_owner == null || ::World == null || ::World.getPlayerRoster() == null) return ret;
	foreach (actor in ::World.getPlayerRoster().getAll())
	{
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor)) continue;
		local placed = false;
		try { placed = actor.isPlacedOnMap(); } catch (e) { placed = false; }
		if (!placed) continue;
		if (actor == _owner)
		{
			if (_includeOwner) ret.push(actor);
			continue;
		}
		if (::$bvvar{namespace}.isEligibleRosterAlly(_owner, actor)) ret.push(actor);
	}
	return ret;
};

::$bvvar{namespace}.improveRobinMoraleOneStep <- function( _actor )
{
	if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor)) return false;
	local current = null;
	try { current = _actor.getMoraleState(); } catch (e) { return false; }
	local next = null;
	if (current == ::Const.MoraleState.Fleeing || current == ::Const.MoraleState.Breaking) next = ::Const.MoraleState.Wavering;
	else if (current == ::Const.MoraleState.Wavering) next = ::Const.MoraleState.Steady;
	else if (current == ::Const.MoraleState.Steady) next = ::Const.MoraleState.Confident;
	if (next == null) return false;
	try { _actor.setMoraleState(next); _actor.setDirty(true); return true; } catch (e) { return false; }
};

::$bvvar{namespace}.cleanseRobinEncoreEffects <- function( _actor )
{
	if (_actor == null || _actor.getSkills() == null) return;
	foreach (id in ::$bvvar{namespace}.RobinCleanseEffectIDs)
	{
		while (_actor.getSkills().hasSkill(id)) _actor.getSkills().removeByID(id);
	}
	_actor.getSkills().update();
};

::$bvvar{namespace}.reloadRobinTurnBar <- function( _bar )
{
	if (_bar == null || _bar.m == null || _bar.m.JSHandle == null) return;
	_bar.m.JSHandle.call("clear", null);
	local maxVisibleIndex = ::Math.min(_bar.m.CurrentEntities.len(), _bar.m.MaxVisibleEntities);
	for (local i = 0; i < maxVisibleIndex; ++i)
		_bar.m.JSHandle.call("addEntity", _bar.convertEntityToUIData(_bar.m.CurrentEntities[i], i == maxVisibleIndex - 1));
};

::$bvvar{namespace}.findRobinTurnIndex <- function( _entities, _target )
{
	if (_entities == null || _target == null) return null;
	for (local i = 0; i < _entities.len(); ++i)
		if (_entities[i] != null && _entities[i].getID() == _target.getID()) return i;
	return null;
};

::$bvvar{namespace}.hasRobinFinishedTurn <- function( _actor )
{
	if (_actor == null) return false;
	try { return _actor.m.IsTurnDone; } catch (e) { return false; }
};

::$bvvar{namespace}.insertRobinGrantedTurn <- function( _target )
{
	if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target) || !("Tactical" in getroottable()) || ::Tactical.TurnSequenceBar == null) return false;
	local bar = ::Tactical.TurnSequenceBar;
	local current = bar.m.CurrentEntities;
	if (current == null || current.len() == 0 || ::$bvvar{namespace}.findRobinTurnIndex(current, _target) != null) return false;
	current.insert(current.len() == 0 ? 0 : 1, _target);
	_target.m.IsTurnDone = false;
	_target.m.IsSkippingTurn = false;
	_target.m.IsTurnStarted = false;
	_target.setWaitActionSpent(false);
	_target.setDirty(true);
	::$bvvar{namespace}.reloadRobinTurnBar(bar);
	return true;
};

::$bvvar{namespace}.addRobinGrantedAction <- function( _target, _amount, _overflow, _insertTurn )
{
	if (_target == null || _target.getSkills() == null) return false;
	local effect = ::new("$bvvar{privateFolder}/skills/effects/robin_granted_action_effect");
	effect.setup(_amount, _overflow);
	effect.m.BVIsExtraTurn = _insertTurn;
	_target.getSkills().add(effect);
	_target.getSkills().update();
	return !_insertTurn || ::$bvvar{namespace}.insertRobinGrantedTurn(_target);
};

::$bvvar{namespace}.notifyRobinActorTurnStart <- function( _actor )
{
	if (_actor == null || ::World == null || ::World.getPlayerRoster() == null) return;
	foreach (candidate in ::World.getPlayerRoster().getAll())
	{
		local passive = ::$bvvar{namespace}.getRobinPassive(candidate);
		if (passive != null && "resetActorTurn" in passive) passive.resetActorTurn(_actor);
	}
};

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onTurnStart = @(__original) function()
	{
		local ret = __original();
		::$bvvar{namespace}.notifyRobinActorTurnStart(this);
		return ret;
	}
});
