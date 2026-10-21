// Actor-owned combat state survives managed skill reconstruction, but not battles.
::$bvvar{namespace}.getEnterpriseState <- function(_actor)
{
	return _actor != null && "BVEnterpriseCombat" in _actor.m ? _actor.m.BVEnterpriseCombat : null;
};
::$bvvar{namespace}.startEnterpriseCombat <- function(_actor)
{
	if (_actor == null || this.getActorValkyrieID(_actor) != "enterprise" || !_actor.isPlayerControlled()) return null;
	local state = this.getEnterpriseState(_actor), epoch = this.ValkyrieCombatEvents.Epoch;
	if (state != null && state.Epoch == epoch) return state;
	state = {Epoch=epoch, Active=true, Sorties=2, Turn=0, LastTurnRound=-1, AirstrikeRound=-1,
		DecisiveUsed=false, Ghost=false, MarkRef=null, Busy=false, RecoveryRound=-1};
	_actor.m.BVEnterpriseCombat <- state;
	return state;
};
::$bvvar{namespace}.clearEnterpriseMark <- function(_actor)
{
	local state = this.getEnterpriseState(_actor);
	if (state == null) return;
	local target = this.readValkyrieCombatWeakRef(state.MarkRef);
	state.MarkRef = null;
	if (target == null) return;
	foreach (effect in target.getSkills().m.Skills)
		if (effect.getID() == "$bvvar{modId}.effects.enterprise_air_lock" && effect.getOwner() == _actor) effect.removeSelf();
};
::$bvvar{namespace}.stopEnterpriseCombat <- function(_actor)
{
	this.clearEnterpriseMark(_actor);
	local state = this.getEnterpriseState(_actor);
	if (state == null) return;
	state.Active = false; state.Ghost = false; state.Busy = false;
};
::$bvvar{namespace}.advanceEnterpriseTurn <- function(_actor)
{
	local state = this.getEnterpriseState(_actor);
	local granted = _actor == null ? null : _actor.getSkills().getSkillByID("$bvvar{modId}.effects.robin_granted_action");
	if (state == null || !state.Active || this.isActorDeadOrDying(_actor) || !_actor.isPlacedOnMap()
		|| _actor.getSkills().hasSkill("$bvvar{modId}.effects.cerydra_command_turn")
		|| (granted != null && granted.m.BVIsExtraTurn)
		|| state.LastTurnRound == ::Time.getRound()) return;
	state.LastTurnRound = ::Time.getRound();
	this.clearEnterpriseMark(_actor); state.Ghost = false;
	local previous = state.Sorties;
	if (state.Turn > 0) state.Sorties = ::Math.min(3, state.Sorties + 1);
	state.Turn++;
	if (previous < 2 && state.Sorties >= 2) this.playValkyrieSkillAudio(_actor, "enterprise_sortie_ready");
};
::$bvvar{namespace}.canEnterpriseCommand <- function(_actor)
{
	local state = this.getEnterpriseState(_actor);
	return state != null && state.Active && !state.Busy && this.getActorValkyrieID(_actor) == "enterprise"
		&& _actor.isPlayerControlled() && !this.isActorDeadOrDying(_actor) && _actor.isPlacedOnMap()
		&& _actor.getCurrentProperties().IsAbleToUseSkills && _actor.getMoraleState() != ::Const.MoraleState.Fleeing
		&& !_actor.getTile().hasZoneOfControlOtherThan(_actor.getAlliedFactions());
};
::$bvvar{namespace}.setEnterpriseMark <- function(_actor, _target)
{
	local state = this.getEnterpriseState(_actor);
	if (state == null || !state.Active || !this.isEligibleValkyrieEnemyTarget(_actor, _target)) return;
	this.clearEnterpriseMark(_actor);
	local effect = ::new("$bvvar{privateFolder}/skills/effects/enterprise_air_lock_effect");
	effect.m.OwnerRef = this.makeValkyrieCombatWeakRef(_actor);
	state.MarkRef = this.makeValkyrieCombatWeakRef(_target);
	_target.getSkills().add(effect);
	this.playValkyrieVisual(effect, _target, "enterprise_target_lock");
	this.playValkyrieSkillAudio(_actor, "enterprise_air_lock_apply", this.captureValkyrieSkillAudioPosition(_target));
};
::$bvvar{namespace}.getEnterpriseStateText <- function(_actor)
{
	local state = this.getEnterpriseState(_actor);
	if (state == null || !state.Active) return "$bv{enterprise.state.outside}";
	return "$bv{enterprise.state.sorties}" + state.Sorties + "/3\n"
		+ (state.AirstrikeRound == ::Time.getRound() ? "$bv{enterprise.state.airstrike_used}" : "$bv{enterprise.state.airstrike_ready}") + "\n"
		+ (state.DecisiveUsed ? "$bv{enterprise.state.decisive_used}" : "$bv{enterprise.state.decisive_ready}") + "\n"
		+ (state.Ghost ? "$bv{enterprise.state.ghost_ready}" : "$bv{enterprise.state.ghost_empty}");
};
::$bvvar{namespace}.getEnterpriseAirstrikeTiles <- function(_origin, _center, _mode)
{
	local tiles = [];
	if (_origin == null || _center == null || _origin.getDistanceTo(_center) < 2 || _origin.getDistanceTo(_center) > 7) return tiles;
	if (_mode == "decisive_airwing") tiles = this.getValkyrieRadiusTiles(_center, 1, true);
	else if (_mode == "carrier_strafe")
	{
		// Pick the closest neighboring step, breaking ties by the stable direction index.
		local direction = -1, best = 999;
		for (local i = 0; i < 6; i++) if (_origin.hasNextTile(i))
		{
			local distance = _origin.getNextTile(i).getDistanceTo(_center);
			if (distance < best) { best = distance; direction = i; }
		}
		if (direction < 0) return tiles;
		local tile = _center;
		for (local step = 0; step < 3; step++)
		{
			tiles.push(tile);
			if (!tile.hasNextTile(direction)) break;
			tile = tile.getNextTile(direction);
		}
	}
	else tiles = [_center];
	local ret = [];
	foreach (tile in tiles) if (_origin.getDistanceTo(tile) <= 7) ret.push(tile);
	return ret;
};
// Called after ordinary property construction: held weapon base damage cannot leak into aviation.
::$bvvar{namespace}.finalizeEnterpriseAirstrikeProperties <- function(_actor, _skill, _target, _properties)
{
	if (_actor == null || _skill == null || this.getActorValkyrieID(_actor) != "enterprise"
		|| !this.isBattleValkyriesManagedRuntimeSkill(_skill)) return _properties;
	local key = _skill.getBattleValkyriesSkillKey();
	if (key != "enterprise_dauntless_dive" && key != "enterprise_carrier_strafe" && key != "enterprise_decisive_airwing") return _properties;
	_skill.finalizeAirstrikeProperties(_target, _properties);
	return _properties;
};
