// Presentation-only state: never serialized and never used to gate combat logic.
::$bvvar{namespace}.VoiceRuntime <- { Active = false, Actors = {}, NormalUntil = 0.0, UrgentUntil = 0.0 };
::$bvvar{namespace}.VoiceSkillEvents <- {
	fengjin_feather_rescue = "heal",
	jeanne_luminosite_eternelle = "guard",
	hakurei_reimu_duplex_barrier = "guard"
};

::$bvvar{namespace}.resetValkyrieVoices <- function( _active )
{
	this.VoiceRuntime = { Active = _active, Actors = {}, NormalUntil = 0.0, UrgentUntil = 0.0 };
};

::$bvvar{namespace}.isValkyrieVoiceActor <- function( _actor )
{
	if (_actor == null || !_actor.isPlayerControlled()) return false;
	local id = this.getActorValkyrieID(_actor);
	return (id != null && this.getValkyrieByID(id) != null) || this.getValkyrieVoiceConfigForActor(_actor) != null;
};

::$bvvar{namespace}.getValkyrieVoiceState <- function( _actor )
{
	local id = _actor.getID();
	if (!(id in this.VoiceRuntime.Actors))
	{
		this.VoiceRuntime.Actors[id] <- {
			Until = 0.0, Last = "", Cooldowns = {}, DamageDepth = 0,
			ReallyDead = null, DeathSeen = false, WasHurt = false, LastAction = null
		};
	}
	return this.VoiceRuntime.Actors[id];
};

::$bvvar{namespace}.traceValkyrieVoicePlayback <- function( _actor, _event, _reason )
{
	if (this.isValkyrieVoiceDebugActor(_actor))
		this.debugValkyrieVoice("voice.scheduler", _actor, -1, "event=" + _event + " " + _reason);
};

::$bvvar{namespace}.getValkyrieVoicePool <- function( _actor, _event )
{
	if (_event == "ye_shunguang_skill")
		return this.getActorValkyrieID(_actor) == "ye_shunguang" ? this.YeShunguangSkillVoicePool : [];
	if (_event == "ye_shunguang_reflection")
		return this.getActorValkyrieID(_actor) == "ye_shunguang" ? this.YeShunguangReflectionVoicePool : [];
	local config = this.getValkyrieVoiceConfigForActor(_actor);
	local legacyEvent = null;
	if (_event == "hurt_light" || _event == "hurt_medium" || _event == "hurt_heavy" || _event == "knockout")
		legacyEvent = ::Const.Sound.ActorEvent.DamageReceived;
	else if (_event == "death") legacyEvent = ::Const.Sound.ActorEvent.Death;
	else if (_event == "fatigue" || _event == "flee") legacyEvent = ::Const.Sound.ActorEvent.Fatigue;
	if (config != null && legacyEvent != null)
	{
		local sounds = this.getValkyrieVoiceSoundsForEvent(config, legacyEvent);
		if (sounds != null && sounds.len() > 0) return sounds;
	}
	// No approved flee or unconscious dialogue: use only approved pain vocalizations.
	if (_event == "knockout") return [this.SharedVoicePools.hurt_medium[0], this.SharedVoicePools.hurt_medium[3]];
	if (_event == "flee") return [];
	return _event in this.SharedVoicePools ? this.SharedVoicePools[_event] : [];
};

::$bvvar{namespace}.playValkyrieVoice <- function( _actor, _event, _volume = 1.0 )
{
	if (!this.VoiceRuntime.Active || !this.isValkyrieVoiceActor(_actor)) return false;
	if ("CombatCinematic" in this && this.CombatCinematic.Active) return false;
	local percent = this.getSettingValue("VoiceVolumePercent");
	if (typeof percent != "integer" && typeof percent != "float") percent = 300;
	// New 100% = five times the previous default gain of 4.0.
	local gain = 20.0 * ::Math.maxf(0.0, ::Math.minf(300.0, percent.tofloat())) / 100.0;
	if (gain <= 0.0 || _volume <= 0.0) return false;
	local urgent = _event == "death" || _event == "knockout";
	if (!_actor.isPlacedOnMap() || _actor.isHiddenToPlayer()) return false;
	if (!urgent && (!_actor.isAlive() || _actor.isDying())) return false;
	local state = this.getValkyrieVoiceState(_actor);
	local now = ::Time.getRealTimeF();
	if (urgent)
	{
		if (state.DeathSeen) return false;
		state.DeathSeen = true;
		// A single urgent voice may overlap the normal slot; never stop a shared WAV globally.
		if (now < this.VoiceRuntime.UrgentUntil) return false;
	}
	else if (now < state.Until || now < this.VoiceRuntime.NormalUntil || now < this.VoiceRuntime.UrgentUntil
		|| (_event in state.Cooldowns && now < state.Cooldowns[_event]))
	{
		this.traceValkyrieVoicePlayback(_actor, _event, "skip=occupied_or_cooldown");
		return false;
	}
	if ((_event == "effort" || _event == "fatigue") && ::Math.rand(1, 100) > 35) return false;
	local pool = this.getValkyrieVoicePool(_actor, _event);
	if (pool.len() == 0) return false;
	local choices = [];
	foreach (file in pool) if (pool.len() == 1 || file != state.Last) choices.push(file);
	local file = choices[::Math.rand(0, choices.len() - 1)];
	// Third-party pack voices without measured metadata use a conservative occupation estimate.
	local duration = file in this.VoiceFileDurations ? this.VoiceFileDurations[file] : 6.0;
	::Sound.play(file, _volume * gain, _actor.getPos(), 1.0);
	local until = now + duration + 0.25;
	state.Until = ::Math.maxf(state.Until, until);
	state.Last = file;
	local cooldown = _event == "fatigue" ? 12.0 : (_event == "effort" ? 6.0 : 1.0);
	state.Cooldowns[_event] <- now + ::Math.maxf(duration + 0.25, cooldown);
	if (urgent) this.VoiceRuntime.UrgentUntil = until;
	else this.VoiceRuntime.NormalUntil = until;
	this.traceValkyrieVoicePlayback(_actor, _event, "play=" + file + " seconds=" + duration + " volume=" + (_volume * gain));
	return true;
};

::$bvvar{namespace}.playValkyrieVoiceSafe <- function( _actor, _event, _volume = 1.0 )
{
	try { return this.playValkyrieVoice(_actor, _event, _volume); }
	catch (e) { ::logWarning("[Battle Valkyries] Voice playback failed: " + e); }
	return false;
};

// Return true even when throttled, so the original male voice cannot leak through.
::$bvvar{namespace}.handleValkyrieActorVoice <- function( _actor, _type, _volume )
{
	local events = ::Const.Sound.ActorEvent;
	if (_type != events.DamageReceived && _type != events.Death && _type != events.Fatigue && _type != events.Flee) return false;
	if (!this.isValkyrieVoiceActor(_actor)) return false;
	local state = this.getValkyrieVoiceState(_actor);
	if (_type == events.DamageReceived)
	{
		if (state.DamageDepth == 0) this.playValkyrieVoiceSafe(_actor, "hurt_medium", _volume);
	}
	else if (_type == events.Death)
	{
		this.playValkyrieVoiceSafe(_actor, state.ReallyDead == true ? "death" : "knockout", _volume);
	}
	else this.playValkyrieVoiceSafe(_actor, _type == events.Fatigue ? "fatigue" : "flee", _volume);
	return true;
};

::$bvvar{namespace}.onValkyrieVoiceDamage <- function( _actor, _before )
{
	local damage = _before - _actor.getHitpoints();
	if (damage <= 0 || !_actor.isAlive() || _actor.isDying()) return;
	this.getValkyrieVoiceState(_actor).WasHurt = true;
	if (damage < ::Const.Combat.PlayPainSoundMinDamage) return;
	local fraction = damage / ::Math.maxf(1.0, _actor.getHitpointsMax().tofloat());
	local event = fraction >= 0.25 ? "hurt_heavy" : (fraction >= 0.10 ? "hurt_medium" : "hurt_light");
	// Keep the actor's event/overall multipliers when deferring pain until after damage.
	// Do not fade a complete spoken sentence down with the old short-grunt damage ratio.
	local volume = ::Const.Sound.Volume.Actor;
	if ("m" in _actor && "SoundVolume" in _actor.m && "SoundVolumeOverall" in _actor.m)
		volume *= _actor.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] * _actor.m.SoundVolumeOverall;
	this.playValkyrieVoiceSafe(_actor, event, volume);
};

::$bvvar{namespace}.onValkyrieVoiceCombatEvent <- function( _event )
{
	if (_event.Type != "ActionStarted" && _event.Type != "ActionResolved") return;
	if (!this.VoiceRuntime.Active || !this.isValkyrieVoiceActor(_event.Actor)) return;
	if (_event.IsImplicit || _event.IsFree || _event.ParentActionToken != null) return;
	local skill = _event.Skill;
	if (skill == null) return;
	local key = "BVSkillKey" in skill.m ? skill.m.BVSkillKey : null;
	local event = key != null && key in this.VoiceSkillEvents ? this.VoiceSkillEvents[key] : (key != null ? "cast" : "effort");
	// Identity survives skin changes. One line per explicit skill use, including
	// weapon skills. Reflection uses a paired line after successful state entry.
	local yeSkill = this.getActorValkyrieID(_event.Actor) == "ye_shunguang";
	if (yeSkill) event = key == "ye_shunguang_reflection" ? "ye_shunguang_reflection" : "ye_shunguang_skill";
	if (!yeSkill && key == null && !_event.IsActiveWeaponAttack) return;
	// Reflection must finish adding Enlightened State before its voice can play.
	local resolved = event == "heal" || event == "guard" || event == "ye_shunguang_reflection";
	if (resolved != (_event.Type == "ActionResolved")) return;
	if (resolved && !_event.UseResult) return;
	local state = this.getValkyrieVoiceState(_event.Actor);
	if (state.LastAction == _event.ActionToken) return;
	state.LastAction = _event.ActionToken;
	if (event == "ye_shunguang_reflection" && "tryPlayYeShunguangCinematic" in this
		&& this.tryPlayYeShunguangCinematic(_event.Actor)) return;
	this.playValkyrieVoiceSafe(_event.Actor, event, ::Const.Sound.Volume.Actor);
};
