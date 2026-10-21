::$bvvar{namespace}.SkillAudioRuntime <- { Active=false, LastFiles={} };

::$bvvar{namespace}.resetValkyrieSkillAudio <- function( _active = false )
{
	this.SkillAudioRuntime = { Active=_active, LastFiles={} };
};

// Only the already-resolved shot count is queued. Never retain an actor or
// allow delayed presentation from one battle to leak into another battle.
::$bvvar{namespace}.playValkyrieSkillAudioSequence <- function( _owner, _cue, _count, _interval = 130 )
{
	if (_count <= 0 || !this.playValkyrieSkillAudio(_owner, _cue)) return;
	try
	{
		local runtime = this.SkillAudioRuntime;
		for (local i = 1; i < _count; i++)
			::Time.scheduleEvent(::TimeUnit.Virtual, i * _interval, function(data)
			{
				if (::$bvvar{namespace}.SkillAudioRuntime != data.Runtime || !data.Runtime.Active) return;
				// Squirrel dereferences a weakref stored in a table on slot access.
				::$bvvar{namespace}.playValkyrieSkillAudio(data.Owner, data.Cue, data.Position);
			}, { Runtime=runtime, Owner=_owner.weakref(), Cue=_cue, Position=this.captureValkyrieSkillAudioPosition(_owner) });
	}
	catch (e) { ::logWarning("[Battle Valkyries] Skill audio sequence failed: " + _cue + " / " + e); }
};

// Snapshot before damage: lethal hits must not dereference the removed target.
::$bvvar{namespace}.captureValkyrieSkillAudioPosition <- function( _actor )
{
	try
	{
		if (_actor == null || !_actor.isPlacedOnMap() || _actor.isHiddenToPlayer()) return null;
		local pos = _actor.getPos();
		return { Pos=::createVec(pos.X, pos.Y) };
	}
	catch (e) { return null; }
};

// Called only at explicit successful actions / gameplay resource gains.
// _position is a pre-hit snapshot; no timers or persistent actor references.
::$bvvar{namespace}.playValkyrieSkillAudio <- function( _owner, _cue, _position = null )
{
	try
	{
		if (!this.SkillAudioRuntime.Active || _owner == null || !(_cue in this.SkillAudioCues)) return false;
		local cue = this.SkillAudioCues[_cue];
		local equipmentCue="Equipment" in cue && cue.Equipment=="orbment";
        local ownerOK=equipmentCue ? ("Orbments" in this && this.Orbments.item(_owner)!=null) : this.getActorValkyrieID(_owner)==cue.Owner;
        if (!ownerOK || this.isActorDeadOrDying(_owner)) return false;
		local origin = this.captureValkyrieSkillAudioPosition(_owner);
		if (origin == null) return false;
		local percent = this.getSettingValue("SkillSoundVolume");
		if (percent == null) percent = 100;
		local gain = ::Math.maxf(0.0, ::Math.minf(2.0, percent.tofloat() / 100.0));
		if (gain <= 0.0 || cue.Files.len() == 0) return false;
		local index = 0;
		// Deterministic alternation avoids consuming combat RNG for presentation.
		if (_cue in this.SkillAudioRuntime.LastFiles)
			index = (this.SkillAudioRuntime.LastFiles[_cue] + 1) % cue.Files.len();
		local position = _position == null ? origin : _position;
		::Sound.play(cue.Files[index], ::Const.Sound.Volume.Skill * this.SkillAudioBaseGain * cue.Volume * gain, position.Pos, 1.0);
		this.SkillAudioRuntime.LastFiles[_cue] <- index;
		return true;
	}
	catch (e)
	{
		::logWarning("[Battle Valkyries] Skill audio failed: " + _cue + " / " + e);
		return false;
	}
};
