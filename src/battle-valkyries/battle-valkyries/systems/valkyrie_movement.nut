// Navigator arrival callbacks run while isTravelling is still true. Never start
// another teleport (or its attack) on that stack. The native navigator may also
// clear BusyStack, so movement owns a separate, nonserialized container hold.
::$bvvar{namespace}.isValkyrieMovementBusy <- function(_container)
{
	return _container != null && "BVMovementHold" in _container.m
		&& _container.m.BVMovementHold != null && _container.m.BVMovementHold.Active;
};
::$bvvar{namespace}.beginValkyrieMovement <- function(_actor, _cancel)
{
	local container = _actor.getSkills();
	if (::$bvvar{namespace}.isValkyrieMovementBusy(container)) return null;
	local hold = { Actor=::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor), Active=true, Cancel=_cancel };
	container.m.BVMovementHold <- hold;
	if ("touchValkyrieActionBusy" in ::$bvvar{namespace}) ::$bvvar{namespace}.touchValkyrieActionBusy(container, true);
	return hold;
};
::$bvvar{namespace}.endValkyrieMovement <- function(_hold)
{
	if (_hold == null || !_hold.Active) return;
	_hold.Active = false; _hold.Cancel = null;
	local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_hold.Actor);
	if (actor == null || actor.getSkills() == null) return;
	local container = actor.getSkills();
	if ("BVMovementHold" in container.m && container.m.BVMovementHold == _hold) container.m.BVMovementHold = null;
	if ("touchValkyrieActionBusy" in ::$bvvar{namespace}) ::$bvvar{namespace}.touchValkyrieActionBusy(container, container.isBusy());
};
::$bvvar{namespace}.queueValkyrieMovementArrival <- function(_hold, _callback, _data)
{
	if (_hold == null || !_hold.Active) return;
	local pending = { Hold=_hold, Callback=_callback, Data=_data, Attempts=0 };
	try { ::Time.scheduleEvent(::TimeUnit.Virtual, 10, ::$bvvar{namespace}.resumeValkyrieMovementArrival, pending); }
	catch (e) { if (_hold.Active) _hold.Cancel(); throw e; }
};
::$bvvar{namespace}.resumeValkyrieMovementArrival <- function(_pending)
{
	local hold = _pending.Hold;
	if (!hold.Active) return;
	try
	{
		local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(hold.Actor);
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.isPlacedOnMap()) { hold.Cancel(); return; }
		if (::Tactical.getNavigator().isTravelling(actor))
		{
			// Finite retry protects against a broken external navigator retaining a trip.
			if (++_pending.Attempts >= 100) { hold.Cancel(); return; }
			::Time.scheduleEvent(::TimeUnit.Virtual, 10, ::$bvvar{namespace}.resumeValkyrieMovementArrival, _pending);
			return;
		}
		_pending.Callback(actor, _pending.Data);
	}
	catch (e) { if (hold.Active) hold.Cancel(); throw e; }
};
