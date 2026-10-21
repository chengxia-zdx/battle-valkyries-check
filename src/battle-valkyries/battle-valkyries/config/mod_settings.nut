// Keep setting IDs stable: MSU preferences are keyed by mod and setting, not page.
local rosterPage = ::$bvvar{namespace}.Mod.ModSettings.addPage("Valkyries", "$bv{settings.page_title}");

rosterPage.addTitle("valkyrie_roster_title", "$bv{settings.roster_title}");

// Extend the MSU setting locally so an unsafe disable is rejected before the
// saved value changes. No global MSU behavior or serialization is replaced.
local rosterSwitchClass = class extends ::MSU.Class.BooleanSetting {
	function blockedReason( _enabled )
	{
		return "Roster" in ::$bvvar{namespace} ? ::$bvvar{namespace}.Roster.switchBlockedReason(_enabled) : null;
	}
	function getUIData( _flags = [] )
	{
		local ret = base.getUIData(_flags);
		ret.locked = ret.locked || this.blockedReason(!this.getValue()) != null;
		return ret;
	}
	function getDescription()
	{
		local reason = this.blockedReason(!this.getValue());
		return base.getDescription() + (reason == null ? "" : "\n\n" + reason);
	}
	function set( _value, _updateJS = true, _updatePersistence = true, _before = true, _force = false, _after = true )
	{
		::MSU.requireBool(_value);
		if (this.isLocked()) return false;
		if (_value != this.getValue() && "Roster" in ::$bvvar{namespace})
		{
			local reason = this.blockedReason(_value);
			if (reason != null) { ::logWarning("[Battle Valkyries] Roster switch blocked: " + reason); return false; }
			if (!::$bvvar{namespace}.Roster.prepareSwitch(_value)) return false;
		}
		return base.set(_value, _updateJS, _updatePersistence, _before, _force, _after);
	}
};
local rosterSwitch = rosterPage.addElement(rosterSwitchClass("EnableRosterExpansion", ::$bvvar{namespace}.Settings.EnableRosterExpansion,
	"$bv{settings.enable_roster_expansion}", "$bv{settings.enable_roster_expansion.description}"));

rosterPage.addTitle("valkyrie_capacity_title", "$bv{settings.capacity_title}");

local rosterCapacity = rosterPage.addRangeSetting("RosterCapacity", ::$bvvar{namespace}.Settings.RosterCapacity, 50, 200, 25, "$bv{settings.roster_capacity}");
rosterCapacity.setDescription("$bv{settings.roster_capacity.description}");

// MSU restores both global preferences and savegame settings through set().
// Migrate the removed 28-person choice without resetting to the origin default.
local combatCapacityClass = class extends ::MSU.Class.SliderSetting {
	function set( _value, _updateJS = true, _updatePersistence = true, _before = true, _force = false, _after = true )
	{
		return base.set(_value == 28 ? 27 : _value, _updateJS, _updatePersistence, _before, _force, _after);
	}
};
local combatCapacity = rosterPage.addElement(combatCapacityClass("CombatCapacity", ::$bvvar{namespace}.Settings.CombatCapacity,
	[0, 16, 18, 20, 22, 24, 26, 27], ["$bv{settings.combat_capacity.default}", "16", "18", "20", "22", "24", "26", "27"], "$bv{settings.combat_capacity}"));
combatCapacity.setDescription("$bv{settings.combat_capacity.description}");

local presentationPage = ::$bvvar{namespace}.Mod.ModSettings.addPage("Presentation", "$bv{settings.presentation_page_title}");
presentationPage.addTitle("valkyrie_audio_title", "$bv{settings.audio_title}");

// Use a new key because the old percentage was relative to the unboosted recordings.
local voiceVolume = presentationPage.addRangeSetting("VoiceVolumePercent", ::$bvvar{namespace}.Settings.VoiceVolumePercent, 0, 300, 10, "$bv{settings.voice_volume}");
voiceVolume.setDescription("$bv{settings.voice_volume.description}");
// Seed from old global preferences only when no new preference exists. Keep mute
// and relative custom levels; old 400% becomes new 100%. Reset uses 300%.
if (::MSU.Mod.PersistentData.hasFile("ModSettings"))
{
	local savedSettings = ::MSU.Mod.PersistentData.readFile("ModSettings");
	local modID = ::$bvvar{namespace}.Mod.getID();
	if (modID in savedSettings)
	{
		local saved = savedSettings[modID];
		if (!("VoiceVolumePercent" in saved) && "VoiceVolume" in saved
			&& (typeof saved.VoiceVolume == "integer" || typeof saved.VoiceVolume == "float"))
			voiceVolume.set(::Math.maxf(0.0, ::Math.minf(500.0, saved.VoiceVolume.tofloat())) / 4.0, false, false);
	}
}

local skillSoundVolume = presentationPage.addRangeSetting("SkillSoundVolume", ::$bvvar{namespace}.Settings.SkillSoundVolume, 0, 200, 10, "$bv{settings.skill_sound_volume}");
skillSoundVolume.setDescription("$bv{settings.skill_sound_volume.description}");

presentationPage.addTitle("valkyrie_appearance_title", "$bv{settings.appearance_title}");

local hideWeapons = presentationPage.addBooleanSetting("HideWeapons", ::$bvvar{namespace}.Settings.HideWeapons, "$bv{settings.hide_weapons}");
hideWeapons.setDescription("$bv{settings.hide_weapons.description}");

local gameplayPage = ::$bvvar{namespace}.Mod.ModSettings.addPage("Gameplay", "$bv{settings.gameplay_page_title}");
gameplayPage.addTitle("valkyrie_system_title", "$bv{settings.system_title}");

local gachaMode = gameplayPage.addBooleanSetting("GachaMode", ::$bvvar{namespace}.Settings.GachaMode, "$bv{settings.gacha_mode}");
gachaMode.setDescription("$bv{settings.gacha_mode.description}");

gameplayPage.addTitle("valkyrie_difficulty_title", "$bv{settings.difficulty_title}");

local enableValkyrieEnemyScaling = gameplayPage.addBooleanSetting("EnableValkyrieEnemyScaling", ::$bvvar{namespace}.Settings.EnableValkyrieEnemyScaling, "$bv{settings.enable_valkyrie_enemy_scaling}");
enableValkyrieEnemyScaling.setDescription("$bv{settings.enable_valkyrie_enemy_scaling.description}");

// local debugSkin = presentationPage.addBooleanSetting("DebugSkin", ::$bvvar{namespace}.Settings.DebugSkin, "$bv{settings.debug_skin}");
// debugSkin.setDescription("$bv{settings.debug_skin.description}");

// local debugSkills = gameplayPage.addBooleanSetting("DebugSkills", ::$bvvar{namespace}.Settings.DebugSkills, "$bv{settings.debug_skills}");
// debugSkills.setDescription("$bv{settings.debug_skills.description}");

// local debugSaveCompat = gameplayPage.addBooleanSetting("DebugSaveCompat", ::$bvvar{namespace}.Settings.DebugSaveCompat, "$bv{settings.debug_save_compat}");
// debugSaveCompat.setDescription("$bv{settings.debug_save_compat.description}");

local hertaAstrolabe = presentationPage.addElement(::MSU.Class.SliderSetting("HertaAstrolabe", 2,
    [0,1,2], ["$bv{settings.herta_astrolabe.off}","$bv{settings.herta_astrolabe.simple}","$bv{settings.herta_astrolabe.full}"],
    "$bv{settings.herta_astrolabe}"));
hertaAstrolabe.setDescription("$bv{settings.herta_astrolabe.description}");
