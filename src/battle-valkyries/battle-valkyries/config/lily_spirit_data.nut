::$bvvar{namespace}.LilySpiritRecordTraitID <- "$bvvar{modId}.trait.lily_spirit_record";
::$bvvar{namespace}.LilySpiritOwnerPrefix <- "lily_spirit_loadout:";
::$bvvar{namespace}.LilyUlvStepOwnerToken <- "$bvvar{modId}.owner.skill.lily_ulv_step";
::$bvvar{namespace}.LilySpiritSlotCount <- 6;
::$bvvar{namespace}.LilySpiritInitialLoadout <- [
	"umbral_knight", "gerrod", "dark_witch_eleine",
	"guardian_sigrid", "cliffside_hamlet_youth", "headless_defender"
];

// Stable order doubles as the serialized bit index and the Hub collection order.
::$bvvar{namespace}.LilySpirits <- [
	{ Key="umbral_knight", Type="main", Unlock=0, AP=4, Fatigue=12, MinRange=1, MaxRange=2, Hit=15, Damage=1.20, Armor=1.00, Direct=0.00, Shape="single", Tags=["first_kill_ap"] },
	{ Key="gerrod", Type="main", Unlock=0, AP=6, Fatigue=28, MinRange=1, MaxRange=1, Hit=0, Damage=1.80, Armor=2.50, Direct=0.20, Shape="single", Tags=["stagger","armor_break_stun"] },
	{ Key="dark_witch_eleine", Type="main", Unlock=0, AP=4, Fatigue=18, MinRange=2, MaxRange=7, Hit=25, Damage=1.10, Armor=1.00, Direct=0.50, Shape="single", Tags=["three_projectiles","ignore_distance"] },
	{ Key="guardian_silva", Type="main", Unlock=90, AP=5, Fatigue=24, MinRange=1, MaxRange=1, Hit=0, Damage=1.50, Armor=2.00, Direct=0.00, Shape="single", Tags=["two_hits","stationary_bonus"] },
	{ Key="mad_knight_ulv", Type="main", Unlock=120, AP=4, Fatigue=18, MinRange=1, MaxRange=1, Hit=0, Damage=1.40, Armor=1.00, Direct=0.30, Shape="single", Tags=["two_hits","bleed","kill_step"] },
	{ Key="knight_captain_julius", Type="main", Unlock=180, AP=5, Fatigue=24, MinRange=1, MaxRange=4, Hit=25, Damage=1.40, Armor=1.00, Direct=0.25, Shape="line", Tags=["ignore_shield"] },
	{ Key="hoenir", Type="main", Unlock=225, AP=3, Fatigue=14, MinRange=2, MaxRange=6, Hit=25, Damage=0.90, Armor=1.00, Direct=0.35, Shape="single", Tags=["twice_per_turn"] },
	{ Key="faden", Type="main", Unlock=290, AP=6, Fatigue=30, MinRange=2, MaxRange=5, Hit=0, Damage=1.60, Armor=1.00, Direct=0.35, Shape="radius1", Tags=["knockback","stun","once_per_turn"] },

	{ Key="guardian_sigrid", Type="sub", Unlock=0, AP=3, Fatigue=18, MinRange=0, MaxRange=0, Hit=0, Damage=0.80, Armor=2.20, Direct=0.00, Shape="adjacent", Uses=4, Tags=["stagger"] },
	{ Key="cliffside_hamlet_youth", Type="sub", Unlock=0, AP=2, Fatigue=16, MinRange=2, MaxRange=5, Hit=0, Damage=1.00, Armor=1.00, Direct=0.00, Shape="radius1", Uses=4, Tags=["ignore_shield"] },
	{ Key="western_merchant", Type="sub", Unlock=15, AP=2, Fatigue=12, MinRange=0, MaxRange=0, Hit=0, Damage=0.50, Armor=1.00, Direct=0.00, Shape="self", Uses=2, Tags=["crow"] },
	{ Key="headless_defender", Type="sub", Unlock=0, AP=1, Fatigue=10, MinRange=0, MaxRange=0, Hit=0, Damage=1.40, Armor=1.00, Direct=0.00, Shape="self", Uses=3, Tags=["front_guard"] },
	{ Key="castle_town_maiden", Type="sub", Unlock=165, AP=2, Fatigue=14, MinRange=0, MaxRange=0, Hit=0, Damage=0.60, Armor=1.00, Direct=0.00, Shape="self", Uses=2, Tags=["maiden_followup"] },
	{ Key="fallen_archer", Type="sub", Unlock=60, AP=3, Fatigue=20, MinRange=2, MaxRange=6, Hit=0, Damage=1.00, Armor=1.00, Direct=0.00, Shape="radius1", Uses=3, Tags=["large_bonus"] },
	{ Key="elder_crypt_keeper", Type="sub", Unlock=75, AP=2, Fatigue=16, MinRange=1, MaxRange=4, Hit=0, Damage=0.70, Armor=1.00, Direct=0.00, Shape="single", Uses=3, Tags=["root_or_ap"] },
	{ Key="fungal_sorcerer", Type="sub", Unlock=30, AP=2, Fatigue=14, MinRange=2, MaxRange=4, Hit=0, Damage=0.60, Armor=1.00, Direct=0.00, Shape="radius1", Uses=3, Tags=["fungal_poison"] },
	{ Key="floral_sorceress", Type="sub", Unlock=45, AP=2, Fatigue=14, MinRange=0, MaxRange=0, Hit=0, Damage=0.70, Armor=1.00, Direct=0.00, Shape="adjacent", Uses=4, Tags=["stagger","knockback"] },
	{ Key="fallen_sentinel", Type="sub", Unlock=105, AP=3, Fatigue=20, MinRange=1, MaxRange=5, Hit=0, Damage=1.20, Armor=1.00, Direct=0.00, Shape="line", Uses=3, Tags=["ignore_shield"] },
	{ Key="hidden_test_subject", Type="sub", Unlock=210, AP=2, Fatigue=12, MinRange=0, MaxRange=0, Hit=0, Damage=1.00, Armor=1.00, Direct=0.00, Shape="self", Uses=2, Tags=["all_guard"] },
	{ Key="dark_executioner", Type="sub", Unlock=255, AP=3, Fatigue=18, MinRange=2, MaxRange=6, Hit=30, Damage=1.50, Armor=1.00, Direct=0.30, Shape="single", Uses=3, Tags=["teleport_behind","ignore_shield"] },
	{ Key="incompetent_sinner", Type="sub", Unlock=270, AP=3, Fatigue=18, MinRange=1, MaxRange=3, Hit=0, Damage=0.90, Armor=1.00, Direct=0.00, Shape="line", Uses=3, Tags=["dash"] },
	{ Key="verboten_champion", Type="sub", Unlock=310, AP=2, Fatigue=16, MinRange=1, MaxRange=2, Hit=0, Damage=1.10, Armor=1.00, Direct=0.00, Shape="radius1", Uses=3, Tags=["leap","two_hits"] },
	{ Key="cliffside_hamlet_elder", Type="sub", Unlock=150, AP=4, Fatigue=22, MinRange=2, MaxRange=6, Hit=0, Damage=1.40, Armor=1.00, Direct=0.00, Shape="radius1", Uses=2, Tags=["stagger"] },
	{ Key="chief_guardian", Type="sub", Unlock=135, AP=3, Fatigue=18, MinRange=1, MaxRange=2, Hit=0, Damage=1.10, Armor=1.00, Direct=0.00, Shape="radius1", Uses=3, Tags=["two_hits"] },
	{ Key="one_eyed_royal_aegis", Type="sub", Unlock=240, AP=4, Fatigue=24, MinRange=1, MaxRange=1, Hit=0, Damage=1.50, Armor=2.50, Direct=0.00, Shape="radius1", Uses=2, Tags=["main_stun","stagger"] },
	{ Key="forsaken_fellwyrm", Type="sub", Unlock=195, AP=3, Fatigue=20, MinRange=2, MaxRange=5, Hit=0, Damage=0.50, Armor=1.00, Direct=0.00, Shape="radius2", Uses=2, Tags=["fellwyrm_poison"] }
];

// Keep every localization token literal so the single-source renderer can
// resolve it before Squirrel evaluates this file. Constructing $bv tokens at
// runtime would leave untranslated text in both language packages.
local lilySpiritCopy = {
	umbral_knight={Name="$bv{skill.lily_spirit_umbral_knight.name}",Description="$bv{skill.lily_spirit_umbral_knight.description}"},
	gerrod={Name="$bv{skill.lily_spirit_gerrod.name}",Description="$bv{skill.lily_spirit_gerrod.description}"},
	dark_witch_eleine={Name="$bv{skill.lily_spirit_dark_witch_eleine.name}",Description="$bv{skill.lily_spirit_dark_witch_eleine.description}"},
	guardian_silva={Name="$bv{skill.lily_spirit_guardian_silva.name}",Description="$bv{skill.lily_spirit_guardian_silva.description}"},
	mad_knight_ulv={Name="$bv{skill.lily_spirit_mad_knight_ulv.name}",Description="$bv{skill.lily_spirit_mad_knight_ulv.description}"},
	knight_captain_julius={Name="$bv{skill.lily_spirit_knight_captain_julius.name}",Description="$bv{skill.lily_spirit_knight_captain_julius.description}"},
	hoenir={Name="$bv{skill.lily_spirit_hoenir.name}",Description="$bv{skill.lily_spirit_hoenir.description}"},
	faden={Name="$bv{skill.lily_spirit_faden.name}",Description="$bv{skill.lily_spirit_faden.description}"},
	guardian_sigrid={Name="$bv{skill.lily_spirit_guardian_sigrid.name}",Description="$bv{skill.lily_spirit_guardian_sigrid.description}"},
	cliffside_hamlet_youth={Name="$bv{skill.lily_spirit_cliffside_hamlet_youth.name}",Description="$bv{skill.lily_spirit_cliffside_hamlet_youth.description}"},
	western_merchant={Name="$bv{skill.lily_spirit_western_merchant.name}",Description="$bv{skill.lily_spirit_western_merchant.description}"},
	headless_defender={Name="$bv{skill.lily_spirit_headless_defender.name}",Description="$bv{skill.lily_spirit_headless_defender.description}"},
	castle_town_maiden={Name="$bv{skill.lily_spirit_castle_town_maiden.name}",Description="$bv{skill.lily_spirit_castle_town_maiden.description}"},
	fallen_archer={Name="$bv{skill.lily_spirit_fallen_archer.name}",Description="$bv{skill.lily_spirit_fallen_archer.description}"},
	elder_crypt_keeper={Name="$bv{skill.lily_spirit_elder_crypt_keeper.name}",Description="$bv{skill.lily_spirit_elder_crypt_keeper.description}"},
	fungal_sorcerer={Name="$bv{skill.lily_spirit_fungal_sorcerer.name}",Description="$bv{skill.lily_spirit_fungal_sorcerer.description}"},
	floral_sorceress={Name="$bv{skill.lily_spirit_floral_sorceress.name}",Description="$bv{skill.lily_spirit_floral_sorceress.description}"},
	fallen_sentinel={Name="$bv{skill.lily_spirit_fallen_sentinel.name}",Description="$bv{skill.lily_spirit_fallen_sentinel.description}"},
	hidden_test_subject={Name="$bv{skill.lily_spirit_hidden_test_subject.name}",Description="$bv{skill.lily_spirit_hidden_test_subject.description}"},
	dark_executioner={Name="$bv{skill.lily_spirit_dark_executioner.name}",Description="$bv{skill.lily_spirit_dark_executioner.description}"},
	incompetent_sinner={Name="$bv{skill.lily_spirit_incompetent_sinner.name}",Description="$bv{skill.lily_spirit_incompetent_sinner.description}"},
	verboten_champion={Name="$bv{skill.lily_spirit_verboten_champion.name}",Description="$bv{skill.lily_spirit_verboten_champion.description}"},
	cliffside_hamlet_elder={Name="$bv{skill.lily_spirit_cliffside_hamlet_elder.name}",Description="$bv{skill.lily_spirit_cliffside_hamlet_elder.description}"},
	chief_guardian={Name="$bv{skill.lily_spirit_chief_guardian.name}",Description="$bv{skill.lily_spirit_chief_guardian.description}"},
	one_eyed_royal_aegis={Name="$bv{skill.lily_spirit_one_eyed_royal_aegis.name}",Description="$bv{skill.lily_spirit_one_eyed_royal_aegis.description}"},
	forsaken_fellwyrm={Name="$bv{skill.lily_spirit_forsaken_fellwyrm.name}",Description="$bv{skill.lily_spirit_forsaken_fellwyrm.description}"}
};

foreach (spirit in ::$bvvar{namespace}.LilySpirits)
{
	spirit.Name <- lilySpiritCopy[spirit.Key].Name;
	spirit.Description <- lilySpiritCopy[spirit.Key].Description;
}

::$bvvar{namespace}.getLilySpirit <- function( _key )
{
	foreach (spirit in ::$bvvar{namespace}.LilySpirits) if (spirit.Key == _key) return spirit;
	return null;
};
