::$bvvar{namespace} <- {
	ID = "$bvvar{modId}",
	Name = "$bv{mod.name}",
	Version = "$bvvar{version}",
	// Modern Hooks Object
	MH = null,
	// MSU Object
	Mod = null,
}
// Instantiate the Modern Hooks object, add MSU as a requirement, and queue after MSU
// https://bbmodding.enduriel.com/docs/modern-hooks/mod-object/
::$bvvar{namespace}.MH = ::Hooks.register(::$bvvar{namespace}.ID, ::$bvvar{namespace}.Version, ::$bvvar{namespace}.Name);
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/valkyries_hub.js");
// Listeners capture prototype methods when registerScreens constructs the roster.
// Patch before construction; LateJS leaves those listeners on the fixed-size list.
::Hooks.registerJS("ui/mods/$bvvar{privateFolder}/roster.js");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/roster.css");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/valkyrie_detail.js");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/ryza_workshop.js");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/ryza_workshop.css");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/valkyrie_combat_cinematic.js");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/kanade_rotation_preview.js");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/es_preview.js");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/es_preview.css");
::Hooks.registerJS("ui/mods/$bvvar{privateFolder}/rachel_hud.js");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/rachel_hud.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/kanade_rotation_preview.css");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/valkyrie_chapters.js");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/orbment_workshop.js");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/valkyrie_main_menu.js");
::Hooks.registerLateJS("ui/mods/$bvvar{privateFolder}/test_panel.js");
// The tactical turn-sequence class is declared with the normal UI modules.
// Register this wrapper in the same phase, otherwise a late script can run
// before that class exists and silently fail to install its guard.
::Hooks.registerJS("ui/mods/$bvvar{privateFolder}/turn_sequence_dead_entity_guard.js");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/valkyries_hub.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/valkyrie_detail.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/valkyrie_combat_cinematic.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/valkyrie_chapters.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/orbment_workshop.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/lily_spirits.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/valkyrie_events.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/valkyrie_main_menu.css");
::Hooks.registerCSS("ui/mods/$bvvar{privateFolder}/test_panel.css");
::$bvvar{namespace}.MH.require("mod_msu");
::$bvvar{namespace}.MH.queue(">mod_msu", function(){
	// Instantiate the MSU Object
	// https://github.com/MSUTeam/MSU/wiki/Mod
	::$bvvar{namespace}.Mod = ::MSU.Class.Mod(::$bvvar{namespace}.ID, ::$bvvar{namespace}.Version, ::$bvvar{namespace}.Name);

	// Includes the 'load' file of your private folder
	// Within this file, you can execute things or load more files (such as hooks)
	// as to better organise your mod, not clutter this file, and load things in order
	::include("$bvvar{privateFolder}/load.nut")
});

// SHS Legends and Jimmy Tooltips patch compatibility targets in late queues.
// Register these small layers after both of them so their replacements cannot
// bypass the Valkyrie guards. Neither mod is required: ordering tokens only take
// effect when the corresponding optional mod is installed.
::$bvvar{namespace}.MH.queue(">mod_legends", ">mod_Jimmys_Tooltips_legends", function(){
	::include("$bvvar{privateFolder}/hooks/valkyrie_perk_tooltip_late.nut");
	::include("$bvvar{privateFolder}/hooks/legends_tooltip_event_guard.nut");
	::include("$bvvar{privateFolder}/hooks/legends_retinue_compat.nut");
	::include("$bvvar{privateFolder}/hooks/roster_expansion.nut");
	::include("$bvvar{privateFolder}/hooks/legends_valkyrie_identity_late.nut");
	::include("$bvvar{privateFolder}/hooks/enemy_expansion_spawn.nut");
	::include("$bvvar{privateFolder}/hooks/enemy_expansion_rewards.nut");
}, ::Hooks.QueueBucket.VeryLate);
