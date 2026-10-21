// Battle-local presentation state. Never serialized or stored in identity flags.
::$bvvar{namespace}.CombatCinematic <- { Active = false, Shown = false, Token = 0, Deadline = 0.0, Screen = null, AudioStarted = false };

// Coherent's video audio is not reliable in the game. Play the original track
// through the native sound engine once the UI reports actual video playback.
::$bvvar{namespace}.startValkyrieCombatCinematicAudio <- function( _token )
{
	local runtime = this.CombatCinematic;
	if (!runtime.Active || runtime.Token != _token || runtime.AudioStarted) return false;
	runtime.AudioStarted = true;
	try
	{
		::Sound.play("sounds/valkyries/ye_shunguang/enlightened_cinematic.wav", 1.0);
		// A native one-shot cannot be recalled on skip. Protect its remaining tail
		// from ordinary dialogue without keeping combat input locked.
		if ("VoiceRuntime" in this)
			this.VoiceRuntime.NormalUntil = ::Math.maxf(this.VoiceRuntime.NormalUntil, ::Time.getRealTimeF() + 7.332);
		return true;
	}
	catch (e) { ::logWarning("[Battle Valkyries] Combat cinematic audio failed: " + e); }
	return false;
};

::$bvvar{namespace}.closeValkyrieCombatCinematic <- function( _token = null )
{
	local runtime = this.CombatCinematic;
	if (_token != null && _token != runtime.Token) return false;
	local screen = runtime.Screen;
	runtime.Active = false;
	runtime.Screen = null;
	if (screen != null && screen.m.JSHandle != null)
	{
		try { screen.m.JSHandle.asyncCall("hideBattleValkyrieCinematic", runtime.Token); }
		catch (e) { ::logWarning("[Battle Valkyries] Combat cinematic cleanup failed: " + e); }
	}
	return true;
};

::$bvvar{namespace}.resetValkyrieCombatCinematic <- function()
{
	this.closeValkyrieCombatCinematic();
	this.CombatCinematic.Shown = false;
	// Old UI completions cannot close a movie from the next battle.
	this.CombatCinematic.Token++;
};

::$bvvar{namespace}.tryPlayYeShunguangCinematic <- function( _actor )
{
	local runtime = this.CombatCinematic;
	if (runtime.Shown || runtime.Active || _actor == null || !_actor.isPlayerControlled()
		|| this.getActorValkyrieID(_actor) != "ye_shunguang" || !_actor.isAlive() || _actor.isDying()) return false;
	if (_actor.getSkills().getSkillByID("$bvvar{modId}.effects.ye_shunguang_enlightened_state") == null) return false;
	try
	{
		local screen = ::Tactical.State.m.TacticalScreen;
		if (screen == null || screen.m.JSHandle == null) return false;
		runtime.Token++;
		runtime.Screen = screen;
		runtime.Active = true;
		runtime.AudioStarted = false;
		// Includes the player's eight-second load timeout and the seven-second clip.
		runtime.Deadline = ::Time.getRealTimeF() + 20.0;
		screen.m.JSHandle.asyncCall("showBattleValkyrieCinematic", {
			Token = runtime.Token,
			Video = "ui/valkyries/combat/ye_shunguang_enlightened.webm"
		});
		runtime.Shown = true;
		return true;
	}
	catch (e)
	{
		this.closeValkyrieCombatCinematic();
		::logWarning("[Battle Valkyries] Combat cinematic unavailable: " + e);
	}
	return false;
};
