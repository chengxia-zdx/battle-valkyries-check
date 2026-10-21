// Named gear is native host equipment, independent of the optional equipment system.
// Wildlife holds treasure; humanoids actually equip the same rolled items later awarded.
::$bvvar{namespace}.ExpandedEnemyNamedWeapons <- {
	brigands = [ "greataxe", "warhammer" ],
	nomads = [ "two_handed_scimitar", "mace" ],
	barbarians = [ "heavy_rusty_axe", "skullhammer" ],
	nobles = [ "mace", "two_handed_hammer" ],
	southern = [ "two_handed_scimitar", "mace" ],
	militia = [ "sword", "mace" ],
	mercenaries = [ "two_handed_hammer", "greatsword" ],
	bounty_hunters = [ "crossbow", "axe" ],
	zombies = [ "greataxe", "sword" ],
	ancients = [ "warscythe", "khopesh" ],
	orcs = [ "orc_axe", "orc_cleaver" ],
	goblins = [ "goblin_heavy_bow", "crossbow" ],
	cultists = [ "dagger", "dagger" ],
	gladiators = [ "shamshir", "mace" ],
	oathbringers = [ "sword", "sword" ],
};
::$bvvar{namespace}.ExpandedEnemyTransitionEquipment <- {
	brigands = { Body = "armor/basic_mail_shirt", Head = "helmets/nasal_helmet" },
	nomads = { Body = "armor/leather_lamellar", Head = "helmets/oriental/nomad_light_helmet" },
	barbarians = { Body = "armor/barbarians/reinforced_animal_hide_armor", Head = "helmets/barbarians/bear_headpiece" },
	nobles = { Body = "armor/reinforced_mail_hauberk", Head = "helmets/closed_flat_top_helmet" },
	southern = { Body = "armor/leather_lamellar", Head = "helmets/oriental/nomad_light_helmet" },
	militia = { Body = "armor/padded_leather", Head = "helmets/nasal_helmet" },
	mercenaries = { Body = "armor/basic_mail_shirt", Head = "helmets/nasal_helmet" },
	bounty_hunters = { Body = "armor/leather_lamellar", Head = "helmets/nasal_helmet" },
	zombies = { Body = "armor/decayed_reinforced_mail_hauberk", Head = "helmets/decayed_full_helm" },
	ancients = { Body = "armor/ancient/ancient_scale_harness", Head = "helmets/ancient/ancient_legionary_helmet" },
	orcs = { Body = "armor/greenskins/orc_warrior_medium_armor", Head = "helmets/greenskins/orc_warrior_medium_helmet" }
};
