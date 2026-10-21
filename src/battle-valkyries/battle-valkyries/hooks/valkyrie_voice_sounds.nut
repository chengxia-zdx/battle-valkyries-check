::$bvvar{namespace}.QianxiaoVoiceSkinID <- "chisaki_skin";

::$bvvar{namespace}.QianxiaoVoiceHurtAndDeathSounds <- [
	"sounds/valkyries/qianxiao/qianxiao_0.wav"
];

::$bvvar{namespace}.QianxiaoVoiceFatigueSounds <- [
	"sounds/valkyries/qianxiao/qianxiao_1.wav"
];

::$bvvar{namespace}.ChangliVoiceHurtAndDeathSounds <- [
	"sounds/valkyries/changli/changli_01.wav"
];

::$bvvar{namespace}.ChangliVoiceFatigueSounds <- [
	"sounds/valkyries/changli/changli_02.wav"
];

::$bvvar{namespace}.JinhsiVoiceHurtAndDeathSounds <- [
	"sounds/valkyries/jinhsi/jinhsi_01.wav"
];

::$bvvar{namespace}.JinhsiVoiceFatigueSounds <- [
	"sounds/valkyries/jinhsi/jinhsi_02.wav"
];

::$bvvar{namespace}.YunoVoiceHurtAndDeathSounds <- [
	"sounds/valkyries/yuno/yuno_01.wav"
];

::$bvvar{namespace}.YunoVoiceFatigueSounds <- [
	"sounds/valkyries/yuno/yuno_02.wav"
];

::$bvvar{namespace}.FeixueVoiceHurtAndDeathSounds <- [
	"sounds/valkyries/feixue/feixue_01.wav"
];

::$bvvar{namespace}.FeixueVoiceFatigueSounds <- [
	"sounds/valkyries/feixue/feixue_02.wav"
];

::$bvvar{namespace}.CartethyiaVoiceHurtAndDeathSounds <- [
	"sounds/valkyries/cartethyia/cartethyia_01.wav"
];

::$bvvar{namespace}.CartethyiaVoiceFatigueSounds <- [
	"sounds/valkyries/cartethyia/cartethyia_02.wav"
];

::$bvvar{namespace}.ValkyrieVoiceSoundConfigs <- [
	{
		SkinID = "chisaki_skin",
		DebugName = "chisaki",
		HurtAndDeathSounds = ::$bvvar{namespace}.QianxiaoVoiceHurtAndDeathSounds,
		FatigueSounds = ::$bvvar{namespace}.QianxiaoVoiceFatigueSounds
	},
	{
		SkinID = "changli_skin",
		DebugName = "changli",
		HurtAndDeathSounds = ::$bvvar{namespace}.ChangliVoiceHurtAndDeathSounds,
		FatigueSounds = ::$bvvar{namespace}.ChangliVoiceFatigueSounds
	},
	{
		SkinID = "jinhsi_skin",
		DebugName = "jinhsi",
		HurtAndDeathSounds = ::$bvvar{namespace}.JinhsiVoiceHurtAndDeathSounds,
		FatigueSounds = ::$bvvar{namespace}.JinhsiVoiceFatigueSounds
	},
	{
		SkinID = "yuno_skin",
		DebugName = "yuno",
		HurtAndDeathSounds = ::$bvvar{namespace}.YunoVoiceHurtAndDeathSounds,
		FatigueSounds = ::$bvvar{namespace}.YunoVoiceFatigueSounds
	},
	{
		SkinID = "feixue_skin",
		DebugName = "feixue",
		HurtAndDeathSounds = ::$bvvar{namespace}.FeixueVoiceHurtAndDeathSounds,
		FatigueSounds = ::$bvvar{namespace}.FeixueVoiceFatigueSounds
	},
	{
		SkinID = "cartethyia_skin",
		DebugName = "cartethyia",
		HurtAndDeathSounds = ::$bvvar{namespace}.CartethyiaVoiceHurtAndDeathSounds,
		FatigueSounds = ::$bvvar{namespace}.CartethyiaVoiceFatigueSounds
	}
];

::$bvvar{namespace}.formatQianxiaoVoiceDebugValue <- function( _value )
{
	if (_value == null)
	{
		return "null";
	}

	if (_value == false)
	{
		return "false";
	}

	if (_value == true)
	{
		return "true";
	}

	return "" + _value;
};

::$bvvar{namespace}.getQianxiaoVoiceEventName <- function( _type )
{
	if (_type == ::Const.Sound.ActorEvent.DamageReceived)
	{
		return "DamageReceived";
	}

	if (_type == ::Const.Sound.ActorEvent.Death)
	{
		return "Death";
	}

	if (_type == ::Const.Sound.ActorEvent.Fatigue)
	{
		return "Fatigue";
	}

	if (_type == ::Const.Sound.ActorEvent.Flee)
	{
		return "Flee";
	}

	return "Other";
};

::$bvvar{namespace}.debugQianxiaoVoice <- function( _label, _actor, _type, _extra = "" )
{
	local actorName = "null";
	local traitSkin = null;
	local flagSkin = null;

	try
	{
		if (_actor != null)
		{
			actorName = _actor.getName();
		}
	}
	catch (e)
	{
		actorName = "unknown";
	}

	try
	{
		traitSkin = ::$bvvar{namespace}.getActorValkyrieSkinIDFromTrait(_actor);
	}
	catch (e)
	{
		traitSkin = null;
	}

	try
	{
		flagSkin = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);
	}
	catch (e)
	{
		flagSkin = null;
	}

	try
	{
		::logInfo("[Battle Valkyries] [VoiceDebug] " + _label
			+ " event=" + ::$bvvar{namespace}.getQianxiaoVoiceEventName(_type)
			+ " actor=" + actorName
			+ " traitSkin=" + ::$bvvar{namespace}.formatQianxiaoVoiceDebugValue(traitSkin)
			+ " flagSkin=" + ::$bvvar{namespace}.formatQianxiaoVoiceDebugValue(flagSkin)
			+ (_extra == "" ? "" : " " + _extra));
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.getQianxiaoVoiceSoundTable <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		return _actor.m.Sound;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getQianxiaoVoiceSet <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		return _actor.m.VoiceSet;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getQianxiaoVoiceApplied <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	try
	{
		return _actor.m.BattleValkyriesQianxiaoVoiceApplied;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.setQianxiaoVoiceApplied <- function( _actor, _value )
{
	if (_actor == null)
	{
		return;
	}

	try
	{
		_actor.m.BattleValkyriesQianxiaoVoiceApplied = _value;
		return;
	}
	catch (e)
	{
	}

	try
	{
		_actor.m.BattleValkyriesQianxiaoVoiceApplied <- _value;
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.getQianxiaoVoiceActorSoundDebugText <- function( _actor, _type )
{
	try
	{
		local soundTable = ::$bvvar{namespace}.getQianxiaoVoiceSoundTable(_actor);

		if (soundTable == null)
		{
			return "soundTable=missing";
		}

		local sounds = soundTable[_type];

		if (sounds == null)
		{
			return "soundList=null";
		}

		return "soundLen=" + sounds.len() + " sound0=" + (sounds.len() > 0 ? sounds[0] : "none");
	}
	catch (e)
	{
		return "soundDebug=error";
	}
};

::$bvvar{namespace}.isQianxiaoVoiceDebugActor <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	try
	{
		local actorName = _actor.getName();

		if (actorName == "Chisaki")
		{
			return true;
		}
	}
	catch (e)
	{
	}

	try
	{
		if (::$bvvar{namespace}.hasQianxiaoVoiceSkinTrait(_actor))
		{
			return true;
		}
	}
	catch (e)
	{
	}

	try
	{
		if (::$bvvar{namespace}.getActorValkyrieSkinID(_actor) == ::$bvvar{namespace}.QianxiaoVoiceSkinID)
		{
			return true;
		}
	}
	catch (e)
	{
	}

	try
	{
		return ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag) == ::$bvvar{namespace}.QianxiaoVoiceSkinID;
	}
	catch (e)
	{
	}

	return false;
};

::$bvvar{namespace}.hasQianxiaoVoiceSkinTrait <- function( _actor )
{
	local trait = ::$bvvar{namespace}.getActorValkyrieSkinTrait(_actor);

	return trait != null
		&& "m" in trait
		&& "BattleValkyriesSkinID" in trait.m
		&& trait.m.BattleValkyriesSkinID == ::$bvvar{namespace}.QianxiaoVoiceSkinID;
};

::$bvvar{namespace}.getQianxiaoVoiceSoundsForEvent <- function( _type )
{
	if (_type == ::Const.Sound.ActorEvent.DamageReceived || _type == ::Const.Sound.ActorEvent.Death)
	{
		return ::$bvvar{namespace}.QianxiaoVoiceHurtAndDeathSounds;
	}

	if (_type == ::Const.Sound.ActorEvent.Fatigue || _type == ::Const.Sound.ActorEvent.Flee)
	{
		return ::$bvvar{namespace}.QianxiaoVoiceFatigueSounds;
	}

	return null;
};

::$bvvar{namespace}.getValkyrieBaseVoiceSetsForGender <- function( _gender )
{
	if (_gender == 1 && "WomanSounds" in ::Const && typeof ::Const.WomanSounds == "array")
	{
		return ::Const.WomanSounds;
	}

	return "HumanSounds" in ::Const && typeof ::Const.HumanSounds == "array" ? ::Const.HumanSounds : null;
};

::$bvvar{namespace}.restoreValkyrieBaseVoiceSoundTable <- function( _actor, _soundTable, _voiceSet )
{
	if (_actor == null || _soundTable == null || typeof _voiceSet != "integer")
	{
		return false;
	}

	local gender = 0;

	try
	{
		gender = _actor.m.Gender;
	}
	catch (e)
	{
	}

	local voiceSets = ::$bvvar{namespace}.getValkyrieBaseVoiceSetsForGender(gender);

	if (voiceSets == null || _voiceSet < 0 || _voiceSet >= voiceSets.len())
	{
		return false;
	}

	local baseVoice = voiceSets[_voiceSet];
	_soundTable[::Const.Sound.ActorEvent.DamageReceived] = baseVoice.DamageReceived;
	_soundTable[::Const.Sound.ActorEvent.Death] = baseVoice.Death;
	_soundTable[::Const.Sound.ActorEvent.Fatigue] = baseVoice.Fatigue;
	_soundTable[::Const.Sound.ActorEvent.Flee] = "Flee" in baseVoice ? baseVoice.Flee : baseVoice.Fatigue;
	return true;
};

::$bvvar{namespace}.restoreQianxiaoVoiceSounds <- function( _actor, _label = "restore" )
{
	local soundTable = ::$bvvar{namespace}.getQianxiaoVoiceSoundTable(_actor);
	local voiceSet = ::$bvvar{namespace}.getQianxiaoVoiceSet(_actor);

	if (soundTable == null || voiceSet == null)
	{
		return false;
	}

	if (!::$bvvar{namespace}.getQianxiaoVoiceApplied(_actor))
	{
		return false;
	}

	try
	{
		if (!::$bvvar{namespace}.restoreValkyrieBaseVoiceSoundTable(_actor, soundTable, voiceSet))
		{
			return false;
		}

		::$bvvar{namespace}.setQianxiaoVoiceApplied(_actor, false);
		::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=restore");
		return true;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.syncQianxiaoVoiceSounds <- function( _actor, _label = "sync", _traceMissing = false )
{
	local soundTable = ::$bvvar{namespace}.getQianxiaoVoiceSoundTable(_actor);

	if (soundTable == null)
	{
		if (_traceMissing)
		{
			::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=skip reason=sound_table_missing");
		}

		return false;
	}

	if (!::$bvvar{namespace}.hasQianxiaoVoiceSkinTrait(_actor))
	{
		local flagSkin = null;

		try
		{
			flagSkin = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);
		}
		catch (e)
		{
			flagSkin = null;
		}

		if (_traceMissing || flagSkin == ::$bvvar{namespace}.QianxiaoVoiceSkinID)
		{
			::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=skip reason=missing_skin_trait");
		}

		::$bvvar{namespace}.restoreQianxiaoVoiceSounds(_actor, _label);
		return false;
	}

	try
	{
		local wasApplied = ::$bvvar{namespace}.getQianxiaoVoiceApplied(_actor);

		soundTable[::Const.Sound.ActorEvent.DamageReceived] = ::$bvvar{namespace}.QianxiaoVoiceHurtAndDeathSounds;
		soundTable[::Const.Sound.ActorEvent.Death] = ::$bvvar{namespace}.QianxiaoVoiceHurtAndDeathSounds;
		soundTable[::Const.Sound.ActorEvent.Fatigue] = ::$bvvar{namespace}.QianxiaoVoiceFatigueSounds;
		soundTable[::Const.Sound.ActorEvent.Flee] = ::$bvvar{namespace}.QianxiaoVoiceFatigueSounds;
		::$bvvar{namespace}.setQianxiaoVoiceApplied(_actor, true);

		if (!wasApplied)
		{
			::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=apply");
		}
		else if (_traceMissing)
		{
			::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=sync " + ::$bvvar{namespace}.getQianxiaoVoiceActorSoundDebugText(_actor, ::Const.Sound.ActorEvent.DamageReceived));
		}

		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=error reason=sync_exception");
		return false;
	}
};

::$bvvar{namespace}.getValkyrieVoiceConfigBySkinID <- function( _skinID )
{
	if (_skinID == null || _skinID == "")
	{
		return null;
	}

	foreach (config in ::$bvvar{namespace}.ValkyrieVoiceSoundConfigs)
	{
		if (config.SkinID == _skinID)
		{
			return config;
		}
	}

	return null;
};

::$bvvar{namespace}.getActorValkyrieVoiceSkinIDFromTrait <- function( _actor )
{
	local trait = ::$bvvar{namespace}.getActorValkyrieSkinTrait(_actor);

	if (trait == null)
	{
		return null;
	}

	try
	{
		return trait.m.BattleValkyriesSkinID;
	}
	catch (e)
	{
	}

	return null;
};

::$bvvar{namespace}.getValkyrieVoiceConfigForActor <- function( _actor )
{
	return ::$bvvar{namespace}.getValkyrieVoiceConfigBySkinID(::$bvvar{namespace}.getActorValkyrieVoiceSkinIDFromTrait(_actor));
};

::$bvvar{namespace}.getValkyrieVoiceSoundTable <- function( _actor )
{
	return ::$bvvar{namespace}.getQianxiaoVoiceSoundTable(_actor);
};

::$bvvar{namespace}.getValkyrieVoiceSet <- function( _actor )
{
	return ::$bvvar{namespace}.getQianxiaoVoiceSet(_actor);
};

::$bvvar{namespace}.getValkyrieVoiceAppliedSkinID <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		return _actor.m.BattleValkyriesCustomVoiceAppliedSkinID;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.setValkyrieVoiceAppliedSkinID <- function( _actor, _skinID )
{
	if (_actor == null)
	{
		return;
	}

	try
	{
		_actor.m.BattleValkyriesCustomVoiceAppliedSkinID = _skinID;
		return;
	}
	catch (e)
	{
	}

	try
	{
		_actor.m.BattleValkyriesCustomVoiceAppliedSkinID <- _skinID;
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.debugValkyrieVoice <- function( _label, _actor, _type, _extra = "" )
{
	::$bvvar{namespace}.debugQianxiaoVoice(_label, _actor, _type, _extra + " appliedSkin=" + ::$bvvar{namespace}.formatQianxiaoVoiceDebugValue(::$bvvar{namespace}.getValkyrieVoiceAppliedSkinID(_actor)));
};

::$bvvar{namespace}.getValkyrieVoiceActorSoundDebugText <- function( _actor, _type )
{
	return ::$bvvar{namespace}.getQianxiaoVoiceActorSoundDebugText(_actor, _type);
};

::$bvvar{namespace}.isValkyrieVoiceDebugActor <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	try
	{
		if (::$bvvar{namespace}.getValkyrieVoiceConfigForActor(_actor) != null)
		{
			return true;
		}
	}
	catch (e)
	{
	}

	try
	{
		local flagSkin = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);
		return ::$bvvar{namespace}.getValkyrieVoiceConfigBySkinID(flagSkin) != null;
	}
	catch (e)
	{
	}

	return false;
};

::$bvvar{namespace}.getValkyrieVoiceSoundsForEvent <- function( _config, _type )
{
	if (_config == null)
	{
		return null;
	}

	if (_type == ::Const.Sound.ActorEvent.DamageReceived || _type == ::Const.Sound.ActorEvent.Death)
	{
		return _config.HurtAndDeathSounds;
	}

	if (_type == ::Const.Sound.ActorEvent.Fatigue || _type == ::Const.Sound.ActorEvent.Flee)
	{
		return _config.FatigueSounds;
	}

	return null;
};

::$bvvar{namespace}.restoreValkyrieVoiceSounds <- function( _actor, _label = "restore" )
{
	local soundTable = ::$bvvar{namespace}.getValkyrieVoiceSoundTable(_actor);
	local voiceSet = ::$bvvar{namespace}.getValkyrieVoiceSet(_actor);

	if (soundTable == null || voiceSet == null)
	{
		return false;
	}

	if (::$bvvar{namespace}.getValkyrieVoiceAppliedSkinID(_actor) == null)
	{
		return false;
	}

	try
	{
		if (!::$bvvar{namespace}.restoreValkyrieBaseVoiceSoundTable(_actor, soundTable, voiceSet))
		{
			return false;
		}

		::$bvvar{namespace}.setValkyrieVoiceAppliedSkinID(_actor, null);
		::$bvvar{namespace}.debugValkyrieVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=restore");
		return true;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.syncValkyrieVoiceSounds <- function( _actor, _label = "sync", _traceMissing = false )
{
	local soundTable = ::$bvvar{namespace}.getValkyrieVoiceSoundTable(_actor);

	if (soundTable == null)
	{
		if (_traceMissing)
		{
			::$bvvar{namespace}.debugValkyrieVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=skip reason=sound_table_missing");
		}

		return false;
	}

	local config = ::$bvvar{namespace}.getValkyrieVoiceConfigForActor(_actor);

	if (config == null)
	{
		local flagSkin = null;

		try
		{
			flagSkin = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);
		}
		catch (e)
		{
			flagSkin = null;
		}

		if (_traceMissing || ::$bvvar{namespace}.getValkyrieVoiceConfigBySkinID(flagSkin) != null)
		{
			::$bvvar{namespace}.debugValkyrieVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=skip reason=missing_skin_trait");
		}

		::$bvvar{namespace}.restoreValkyrieVoiceSounds(_actor, _label);
		return false;
	}

	try
	{
		local wasAppliedSkinID = ::$bvvar{namespace}.getValkyrieVoiceAppliedSkinID(_actor);

		soundTable[::Const.Sound.ActorEvent.DamageReceived] = config.HurtAndDeathSounds;
		soundTable[::Const.Sound.ActorEvent.Death] = config.HurtAndDeathSounds;
		soundTable[::Const.Sound.ActorEvent.Fatigue] = config.FatigueSounds;
		soundTable[::Const.Sound.ActorEvent.Flee] = config.FatigueSounds;
		::$bvvar{namespace}.setValkyrieVoiceAppliedSkinID(_actor, config.SkinID);

		if (wasAppliedSkinID != config.SkinID)
		{
			::$bvvar{namespace}.debugValkyrieVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=apply voice=" + config.DebugName);
		}
		else if (_traceMissing)
		{
			::$bvvar{namespace}.debugValkyrieVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=sync voice=" + config.DebugName + " " + ::$bvvar{namespace}.getValkyrieVoiceActorSoundDebugText(_actor, ::Const.Sound.ActorEvent.DamageReceived));
		}

		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.debugValkyrieVoice(_label, _actor, ::Const.Sound.ActorEvent.DamageReceived, "action=error reason=sync_exception");
		return false;
	}
};

::$bvvar{namespace}.MH.hookTree("scripts/entity/tactical/human", function(q) {
	q.playSound = @(__original) function( _type, _volume, _pitch = 1.0 )
	{
		if (::$bvvar{namespace}.handleValkyrieActorVoice(this, _type, _volume)) return;
		::$bvvar{namespace}.syncValkyrieVoiceSounds(this, "human.playSound", ::$bvvar{namespace}.isValkyrieVoiceDebugActor(this));
		__original(_type, _volume, _pitch);
	}
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		local trace = ::$bvvar{namespace}.isValkyrieVoiceDebugActor(this);
		local hpBefore = null;

		if (trace)
		{
			::$bvvar{namespace}.debugValkyrieVoice("actor.onDamageReceived.before", this, ::Const.Sound.ActorEvent.DamageReceived, "action=enter");

			try
			{
				hpBefore = this.getHitpoints();
			}
			catch (e)
			{
				hpBefore = null;
			}
		}

		::$bvvar{namespace}.syncValkyrieVoiceSounds(this, "actor.onDamageReceived", trace);
		local ret = __original(_attacker, _skill, _hitInfo);

		if (trace)
		{
			local hpAfter = null;
			local hpDamage = "?";
			local armorDamage = "?";

			try
			{
				hpAfter = this.getHitpoints();
			}
			catch (e)
			{
				hpAfter = null;
			}

			try
			{
				hpDamage = "" + _hitInfo.DamageInflictedHitpoints;
			}
			catch (e)
			{
			}

			try
			{
				armorDamage = "" + _hitInfo.DamageInflictedArmor;
			}
			catch (e)
			{
			}

			::$bvvar{namespace}.debugValkyrieVoice("actor.onDamageReceived.after", this, ::Const.Sound.ActorEvent.DamageReceived,
				"action=after"
				+ " hpBefore=" + ::$bvvar{namespace}.formatQianxiaoVoiceDebugValue(hpBefore)
				+ " hpAfter=" + ::$bvvar{namespace}.formatQianxiaoVoiceDebugValue(hpAfter)
				+ " hpDamage=" + hpDamage
				+ " armorDamage=" + armorDamage
				+ " painMin=" + ::Const.Combat.PlayPainSoundMinDamage
				+ " " + ::$bvvar{namespace}.getValkyrieVoiceActorSoundDebugText(this, ::Const.Sound.ActorEvent.DamageReceived));
		}

		return ret;
	}

	q.kill = @(__original) function( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		local trace = ::$bvvar{namespace}.isValkyrieVoiceDebugActor(this);

		if (trace)
		{
			::$bvvar{namespace}.debugValkyrieVoice("actor.kill.before", this, ::Const.Sound.ActorEvent.Death, "action=enter");
		}

		::$bvvar{namespace}.syncValkyrieVoiceSounds(this, "actor.kill", trace);
		return __original(_killer, _skill, _fatalityType, _silent);
	}

	q.onTurnStart = @(__original) function()
	{
		local trace = ::$bvvar{namespace}.isValkyrieVoiceDebugActor(this);

		if (trace)
		{
			::$bvvar{namespace}.debugValkyrieVoice("actor.onTurnStart.before", this, ::Const.Sound.ActorEvent.Fatigue, "action=enter");
		}

		::$bvvar{namespace}.syncValkyrieVoiceSounds(this, "actor.onTurnStart", trace);
		return __original();
	}
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		__original();
		::$bvvar{namespace}.syncValkyrieVoiceSounds(this, "player.onCombatStart", ::$bvvar{namespace}.isValkyrieVoiceDebugActor(this));
	}
});
