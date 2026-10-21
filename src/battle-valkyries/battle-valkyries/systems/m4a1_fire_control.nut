// One combat ledger per actor, never per weapon/skill instance and never serialized.
::$bvvar{namespace}.getM4A1State <- function(_actor)
{
	if (_actor == null) return null;
	if (!("BVM4A1Combat" in _actor.m)) _actor.m.BVM4A1Combat <- null;
	return _actor.m.BVM4A1Combat;
};
::$bvvar{namespace}.startM4A1Combat <- function(_actor)
{
	local previous = this.getM4A1State(_actor);
	local epoch = this.ValkyrieCombatEvents.Epoch;
	if (previous != null && previous.Epoch == epoch) return previous;
	local state = {
		Epoch = epoch, Active = true, Ammo = 12, AmmoType = "standard", Standard = 36, AP = 24,
		Charge = 3, Round = -1, OwnGains = 0, AllyGains = 0, CannonRound = -1,
		Turn = 0, LastTurnRound = -1, FocusUntil = -1, FocusReady = 0,
		MarkRef = null, Pending = {}, Settled = {}, Busy = false
	};
	_actor.m.BVM4A1Combat = state;
	return state;
};
::$bvvar{namespace}.hasM4A1Rifle <- function(_actor)
{
	if (_actor == null || this.getActorValkyrieID(_actor) != "m4a1") return false;
	local item = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	return item != null && item.getID() == "$bvvar{modId}.weapon.m4a1_homecoming_rifle";
};
::$bvvar{namespace}.addM4A1Charge <- function(_actor, _amount)
{
	local state = this.getM4A1State(_actor);
	if (state == null || !state.Active) return;
	local before = state.Charge;
	state.Charge = ::Math.min(6, state.Charge + _amount);
	if (before < 3 && state.Charge >= 3 && "playValkyrieSkillAudio" in this)
		this.playValkyrieSkillAudio(_actor, "m4a1_inheritor_ready");
};
::$bvvar{namespace}.isM4A1NormalTurn <- function(_actor)
{
	return _actor != null && !_actor.getSkills().hasSkill("$bvvar{modId}.effects.cerydra_command_turn");
};
::$bvvar{namespace}.refreshM4A1Round <- function(_state)
{
	local round = ::Time.getRound();
	if (_state.Round != round) { _state.Round = round; _state.OwnGains = 0; _state.AllyGains = 0; _state.Settled = {}; }
};
::$bvvar{namespace}.clearM4A1Mark <- function(_actor)
{
	local state = this.getM4A1State(_actor);
	if (state == null) return;
	local target = this.readValkyrieCombatWeakRef(state.MarkRef);
	state.MarkRef = null;
	if (target == null) return;
	local effect = target.getSkills().getSkillByID("$bvvar{modId}.effects.m4a1_focus_target");
	if (effect != null && effect.getOwner() == _actor) { effect.removeSelf(); target.getSkills().update(); }
};
::$bvvar{namespace}.stopM4A1Combat <- function(_actor)
{
	this.clearM4A1Mark(_actor);
	local state = this.getM4A1State(_actor);
	if (state == null) return;
	// Keep the epoch tombstone: reconstruction during this battle cannot refill it.
	state.Active = false; state.Busy = false; state.Pending = {}; state.FocusUntil = -1;
};
::$bvvar{namespace}.canM4A1Reload <- function(_state, _type)
{
	if (_state == null || !_state.Active || (_type != "standard" && _type != "ap")) return false;
	if (_state.AmmoType == _type && _state.Ammo >= 12) return false;
	return (_type == "standard" ? _state.Standard : _state.AP) > 0;
};
::$bvvar{namespace}.reloadM4A1 <- function(_state, _type)
{
	if (!this.canM4A1Reload(_state, _type)) return false;
	if (_state.AmmoType == "standard") _state.Standard += _state.Ammo; else _state.AP += _state.Ammo;
	_state.AmmoType = _type;
	_state.Ammo = ::Math.min(12, _type == "standard" ? _state.Standard : _state.AP);
	if (_type == "standard") _state.Standard -= _state.Ammo; else _state.AP -= _state.Ammo;
	return true;
};
::$bvvar{namespace}.setM4A1Mark <- function(_actor, _target)
{
	local state = this.getM4A1State(_actor);
	if (state == null || !state.Active || this.isActorDeadOrDying(_actor) || this.isActorDeadOrDying(_target)
		|| !_actor.isPlacedOnMap() || !_target.isPlacedOnMap() || _target.isAlliedWith(_actor)) return;
	this.clearM4A1Mark(_actor);
	local effect = ::new("$bvvar{privateFolder}/skills/effects/m4a1_focus_target_effect");
	effect.m.OwnerRef = this.makeValkyrieCombatWeakRef(_actor);
	state.MarkRef = this.makeValkyrieCombatWeakRef(_target);
	_target.getSkills().add(effect);
	if (_target.getSkills().getSkillByID("$bvvar{modId}.effects.m4a1_focus_target") == effect && "playValkyrieSkillAudio" in this)
	{
		local pos = this.captureValkyrieSkillAudioPosition(_target);
		if (pos != null) this.playValkyrieSkillAudio(_actor, "m4a1_ar_commander_apply", pos);
	}
};
::$bvvar{namespace}.isM4A1PaidAttack <- function(_event)
{
	return _event != null && "IsFree" in _event && !_event.IsFree
		&& "Source" in _event && (_event.Source == "managed_active" || _event.Source == "direct")
		&& "Skill" in _event && _event.Skill != null && this.isDirectAttack(_event.Skill);
};
::$bvvar{namespace}.hasM4A1AdjacentEnemy <- function(_actor)
{
	if (_actor == null || !_actor.isPlacedOnMap()) return false;
	local tile = _actor.getTile();
	for (local i = 0; i < 6; i++) if (tile.hasNextTile(i))
	{
		local next = tile.getNextTile(i);
		if (next.IsOccupiedByActor && !next.getEntity().isAlliedWith(_actor) && !this.isActorDeadOrDying(next.getEntity())) return true;
	}
	return false;
};
::$bvvar{namespace}.isM4A1RifleSkill <- function(_skill)
{
	if (_skill == null || !("getBattleValkyriesSkillKey" in _skill)) return false;
	local key = _skill.getBattleValkyriesSkillKey();
	return key == "m4a1_tactical_shot" || key == "m4a1_three_round_burst";
};
::$bvvar{namespace}.getM4A1AmmoText <- function(_state)
{
	if (_state == null || !_state.Active) return "$bv{m4a1.state.outside}";
	return "$bv{m4a1.state.magazine}" + _state.Ammo + "/12 (" + (_state.AmmoType == "standard" ? "$bv{m4a1.ammo.standard}" : "$bv{m4a1.ammo.ap}")
		+ ")\n$bv{m4a1.state.reserve}" + _state.Standard + " / " + _state.AP + "\n$bv{m4a1.state.charge}" + _state.Charge + "/6";
};
