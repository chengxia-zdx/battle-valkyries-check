// One output species/tier has exactly one recipe. Original armored variants share the base species.
::$bvvar{namespace}.RyzaPets <- {};
::$bvvar{namespace}.RyzaPetOrder <- [];
::$bvvar{namespace}.RyzaPetOrder.push("bone_mastiff");
::$bvvar{namespace}.RyzaPets.bone_mastiff <- { Name = "$bv{ryza.pet.bone_mastiff.name}", Description = "$bv{ryza.pet.bone_mastiff.description}", Role = "defense", RoleName = "$bv{ryza.role.defense}", Bases = ["wardog"], Material = "unhold_bones", Stats = { HP = 340, Body = 450, Head = 320, Attack = 85, Defense = 30, Min = 65, Max = 90, Armor = 90, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("scale_hound");
::$bvvar{namespace}.RyzaPets.scale_hound <- { Name = "$bv{ryza.pet.scale_hound.name}", Description = "$bv{ryza.pet.scale_hound.description}", Role = "warrior", RoleName = "$bv{ryza.role.warrior}", Bases = ["warhound"], Material = "hyena_fur", Stats = { HP = 260, Body = 300, Head = 220, Attack = 95, Defense = 25, Min = 75, Max = 105, Armor = 160, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("frost_wolf");
::$bvvar{namespace}.RyzaPets.frost_wolf <- { Name = "$bv{ryza.pet.frost_wolf.name}", Description = "$bv{ryza.pet.frost_wolf.description}", Role = "pursuit", RoleName = "$bv{ryza.role.pursuit}", Bases = ["wolf"], Material = "adrenaline_gland", Stats = { HP = 220, Body = 200, Head = 150, Attack = 100, Defense = 30, Min = 60, Max = 85, Armor = 90, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("wind_hawk");
::$bvvar{namespace}.RyzaPets.wind_hawk <- { Name = "$bv{ryza.pet.wind_hawk.name}", Description = "$bv{ryza.pet.wind_hawk.description}", Role = "ranged", RoleName = "$bv{ryza.role.ranged}", Bases = ["falcon"], Material = "spider_silk", Stats = { HP = 180, Body = 140, Head = 100, Attack = 90, Defense = 20, Min = 55, Max = 80, Armor = 75, Range = 5 } };
::$bvvar{namespace}.RyzaPetOrder.push("cerberus");
::$bvvar{namespace}.RyzaPets.cerberus <- { Name = "$bv{ryza.pet.cerberus.name}", Description = "$bv{ryza.pet.cerberus.description}", Role = "warrior", RoleName = "$bv{ryza.role.warrior}", Bases = ["wardog", "wardog", "wardog"], Material = "unhold_heart", Stats = { HP = 260, Body = 300, Head = 220, Attack = 95, Defense = 25, Min = 75, Max = 105, Armor = 140, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("iron_cerberus");
::$bvvar{namespace}.RyzaPets.iron_cerberus <- { Name = "$bv{ryza.pet.iron_cerberus.name}", Description = "$bv{ryza.pet.iron_cerberus.description}", Role = "defense", RoleName = "$bv{ryza.role.defense}", Bases = ["warhound", "warhound", "warhound"], Material = "unhold_bones", Stats = { HP = 340, Body = 450, Head = 320, Attack = 85, Defense = 30, Min = 65, Max = 90, Armor = 90, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("blood_wolf");
::$bvvar{namespace}.RyzaPets.blood_wolf <- { Name = "$bv{ryza.pet.blood_wolf.name}", Description = "$bv{ryza.pet.blood_wolf.description}", Role = "pursuit", RoleName = "$bv{ryza.role.pursuit}", Bases = ["wolf", "wolf", "wolf"], Material = "adrenaline_gland", Stats = { HP = 220, Body = 200, Head = 150, Attack = 100, Defense = 30, Min = 60, Max = 85, Armor = 90, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("spirit_vulture");
::$bvvar{namespace}.RyzaPets.spirit_vulture <- { Name = "$bv{ryza.pet.spirit_vulture.name}", Description = "$bv{ryza.pet.spirit_vulture.description}", Role = "support", RoleName = "$bv{ryza.role.support}", Bases = ["falcon", "falcon", "falcon"], Material = "unhold_heart", Stats = { HP = 210, Body = 200, Head = 160, Attack = 75, Defense = 25, Min = 35, Max = 50, Armor = 60, Range = 2 } };
::$bvvar{namespace}.RyzaPetOrder.push("twin_guardian");
::$bvvar{namespace}.RyzaPets.twin_guardian <- { Name = "$bv{ryza.pet.twin_guardian.name}", Description = "$bv{ryza.pet.twin_guardian.description}", Role = "support", RoleName = "$bv{ryza.role.support}", Bases = ["wardog", "warhound"], Material = "unhold_hide", Stats = { HP = 210, Body = 200, Head = 160, Attack = 75, Defense = 25, Min = 35, Max = 50, Armor = 60, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("splitjaw");
::$bvvar{namespace}.RyzaPets.splitjaw <- { Name = "$bv{ryza.pet.splitjaw.name}", Description = "$bv{ryza.pet.splitjaw.description}", Role = "warrior", RoleName = "$bv{ryza.role.warrior}", Bases = ["wardog", "wolf"], Material = "unhold_bones", Stats = { HP = 260, Body = 255, Head = 187, Attack = 95, Defense = 25, Min = 75, Max = 105, Armor = 180, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("griffin");
::$bvvar{namespace}.RyzaPets.griffin <- { Name = "$bv{ryza.pet.griffin.name}", Description = "$bv{ryza.pet.griffin.description}", Role = "pursuit", RoleName = "$bv{ryza.role.pursuit}", Bases = ["wardog", "falcon"], Material = "adrenaline_gland", Stats = { HP = 220, Body = 200, Head = 150, Attack = 100, Defense = 30, Min = 60, Max = 85, Armor = 90, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("mane_tusk");
::$bvvar{namespace}.RyzaPets.mane_tusk <- { Name = "$bv{ryza.pet.mane_tusk.name}", Description = "$bv{ryza.pet.mane_tusk.description}", Role = "defense", RoleName = "$bv{ryza.role.defense}", Bases = ["warhound", "wolf"], Material = "unhold_hide", Stats = { HP = 340, Body = 450, Head = 320, Attack = 85, Defense = 30, Min = 65, Max = 90, Armor = 90, Range = 1 } };
::$bvvar{namespace}.RyzaPetOrder.push("ironwing");
::$bvvar{namespace}.RyzaPets.ironwing <- { Name = "$bv{ryza.pet.ironwing.name}", Description = "$bv{ryza.pet.ironwing.description}", Role = "ranged", RoleName = "$bv{ryza.role.ranged}", Bases = ["warhound", "falcon"], Material = "lindwurm_scales", Stats = { HP = 180, Body = 140, Head = 100, Attack = 90, Defense = 20, Min = 55, Max = 80, Armor = 130, Range = 3 } };
::$bvvar{namespace}.RyzaPetOrder.push("nightwing");
::$bvvar{namespace}.RyzaPets.nightwing <- { Name = "$bv{ryza.pet.nightwing.name}", Description = "$bv{ryza.pet.nightwing.description}", Role = "ranged", RoleName = "$bv{ryza.role.ranged}", Bases = ["wolf", "falcon"], Material = "poison_gland", Stats = { HP = 180, Body = 140, Head = 100, Attack = 90, Defense = 20, Min = 55, Max = 80, Armor = 75, Range = 4 } };
::$bvvar{namespace}.RyzaMaterials <- {
 werewolf_pelt = { ID = "misc.werewolf_pelt", Name = "$bv{ryza.material.werewolf_pelt}", Icon = "ui/items/misc/inventory_wolfpelt_01.png" },
 hyena_fur = { ID = "misc.hyena_fur", Name = "$bv{ryza.material.hyena_fur}", Icon = "ui/items/loot/southern_10.png" },
 adrenaline_gland = { ID = "misc.adrenaline_gland", Name = "$bv{ryza.material.adrenaline_gland}", Icon = "ui/items/misc/inventory_wolf_adrenaline.png" },
 unhold_hide = { ID = "misc.unhold_hide", Name = "$bv{ryza.material.unhold_hide}", Icon = "ui/items/misc/inventory_unhold_hide.png" },
 unhold_bones = { ID = "misc.unhold_bones", Name = "$bv{ryza.material.unhold_bones}", Icon = "ui/items/misc/inventory_unhold_bones.png" },
 unhold_heart = { ID = "misc.unhold_heart", Name = "$bv{ryza.material.unhold_heart}", Icon = "ui/items/misc/inventory_unhold_01.png" },
 lindwurm_scales = { ID = "misc.lindwurm_scales", Name = "$bv{ryza.material.lindwurm_scales}", Icon = "ui/items/misc/inventory_lindwurm_scales.png" },
 lindwurm_bones = { ID = "misc.lindwurm_bones", Name = "$bv{ryza.material.lindwurm_bones}", Icon = "ui/items/misc/inventory_lindwurm_bones.png" },
 poison_gland = { ID = "misc.poison_gland", Name = "$bv{ryza.material.poison_gland}", Icon = "ui/items/misc/inventory_webknecht_poison.png" },
 spider_silk = { ID = "misc.spider_silk", Name = "$bv{ryza.material.spider_silk}", Icon = "ui/items/misc/inventory_webknecht_silk.png" },
};
