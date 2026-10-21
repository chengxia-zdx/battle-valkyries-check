// Fixed recipes; donor bonuses are independent, bounded flat values.
local bv = ::$bvvar{namespace};
bv.RyzaFusionOrder <- [];
{ local d = clone bv.RyzaPets.bone_mastiff; d.Stats = clone d.Stats; d.Name = "$bv{ryza.ext.pet.oath_mastiff}"; d.Description = d.Description + " " + "$bv{ryza.ext.pet.oath_mastiff.description}";
d.Parent <- "bone_mastiff"; d.Inherits <- ["HP", "MeleeDefense", "Bravery"]; d.FusionMaterials <- [{ Key = "unhold_bones", Count = 2 }, { Key = "unhold_heart", Count = 1 }]; bv.RyzaPets.oath_mastiff <- d; bv.RyzaPetOrder.push("oath_mastiff"); bv.RyzaFusionOrder.push("oath_mastiff"); }
{ local d = clone bv.RyzaPets.cerberus; d.Stats = clone d.Stats; d.Name = "$bv{ryza.ext.pet.soul_cerberus}"; d.Description = d.Description + " " + "$bv{ryza.ext.pet.soul_cerberus.description}";
d.Parent <- "cerberus"; d.Inherits <- ["MeleeSkill", "Stamina", "HP"]; d.FusionMaterials <- [{ Key = "unhold_heart", Count = 2 }, { Key = "adrenaline_gland", Count = 2 }]; bv.RyzaPets.soul_cerberus <- d; bv.RyzaPetOrder.push("soul_cerberus"); bv.RyzaFusionOrder.push("soul_cerberus"); }
{ local d = clone bv.RyzaPets.frost_wolf; d.Stats = clone d.Stats; d.Name = "$bv{ryza.ext.pet.hunt_frostwolf}"; d.Description = d.Description + " " + "$bv{ryza.ext.pet.hunt_frostwolf.description}";
d.Parent <- "frost_wolf"; d.Inherits <- ["MeleeSkill", "Initiative", "MeleeDefense"]; d.FusionMaterials <- [{ Key = "adrenaline_gland", Count = 3 }, { Key = "werewolf_pelt", Count = 2 }]; bv.RyzaPets.hunt_frostwolf <- d; bv.RyzaPetOrder.push("hunt_frostwolf"); bv.RyzaFusionOrder.push("hunt_frostwolf"); }
{ local d = clone bv.RyzaPets.ironwing; d.Stats = clone d.Stats; d.Name = "$bv{ryza.ext.pet.sky_ironwing}"; d.Description = d.Description + " " + "$bv{ryza.ext.pet.sky_ironwing.description}";
d.Parent <- "ironwing"; d.Inherits <- ["RangedSkill", "RangedDefense", "Initiative"]; d.FusionMaterials <- [{ Key = "lindwurm_scales", Count = 2 }, { Key = "spider_silk", Count = 2 }]; bv.RyzaPets.sky_ironwing <- d; bv.RyzaPetOrder.push("sky_ironwing"); bv.RyzaFusionOrder.push("sky_ironwing"); }
{ local d = clone bv.RyzaPets.spirit_vulture; d.Stats = clone d.Stats; d.Name = "$bv{ryza.ext.pet.sacred_vulture}"; d.Description = d.Description + " " + "$bv{ryza.ext.pet.sacred_vulture.description}";
d.Parent <- "spirit_vulture"; d.Inherits <- ["Bravery", "HP", "RangedDefense"]; d.FusionMaterials <- [{ Key = "unhold_heart", Count = 2 }, { Key = "spider_silk", Count = 3 }]; bv.RyzaPets.sacred_vulture <- d; bv.RyzaPetOrder.push("sacred_vulture"); bv.RyzaFusionOrder.push("sacred_vulture"); }
{ local d = clone bv.RyzaPets.griffin; d.Stats = clone d.Stats; d.Name = "$bv{ryza.ext.pet.vanguard_griffin}"; d.Description = d.Description + " " + "$bv{ryza.ext.pet.vanguard_griffin.description}";
d.Parent <- "griffin"; d.Inherits <- ["MeleeSkill", "Initiative", "HP"]; d.FusionMaterials <- [{ Key = "adrenaline_gland", Count = 3 }, { Key = "unhold_hide", Count = 2 }]; bv.RyzaPets.vanguard_griffin <- d; bv.RyzaPetOrder.push("vanguard_griffin"); bv.RyzaFusionOrder.push("vanguard_griffin"); }
bv.RyzaInheritanceKeys <- ["HP","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"];
bv.RyzaInheritanceBands <- {
HP = [[0,8],[60,16],[80,28],[100,44],[120,64]], Stamina = [[0,4],[90,8],[110,14],[130,22],[150,32]],
Bravery = [[0,3],[40,6],[60,10],[80,15],[100,22]], Initiative = [[0,5],[90,10],[110,18],[130,28],[150,40]],
MeleeSkill = [[0,1],[50,2],[60,3],[70,5],[80,7],[90,10],[100,13]], RangedSkill = [[0,1],[50,2],[60,3],[70,5],[80,7],[90,10],[100,13]],
MeleeDefense = [[0,1],[10,2],[20,4],[30,7],[40,10]], RangedDefense = [[0,1],[10,2],[20,4],[30,7],[40,10]] };
bv.RyzaInheritanceNames <- {
HP = "$bv{ryza.ext.stat.HP}",
Stamina = "$bv{ryza.ext.stat.Stamina}",
Bravery = "$bv{ryza.ext.stat.Bravery}",
Initiative = "$bv{ryza.ext.stat.Initiative}",
MeleeSkill = "$bv{ryza.ext.stat.MeleeSkill}",
RangedSkill = "$bv{ryza.ext.stat.RangedSkill}",
MeleeDefense = "$bv{ryza.ext.stat.MeleeDefense}",
RangedDefense = "$bv{ryza.ext.stat.RangedDefense}",
};
bv.RyzaAugments <- {}; bv.RyzaAugmentOrder <- [];
bv.RyzaAugmentOrder.push("bone"); bv.RyzaAugments.bone <- { ID = "bone", Name = "$bv{ryza.ext.trait.bone}", Description = "$bv{ryza.ext.trait.bone.description}", Species = "bone_mastiff", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "unhold_bones", Count = 2 }] };
bv.RyzaAugmentOrder.push("scale"); bv.RyzaAugments.scale <- { ID = "scale", Name = "$bv{ryza.ext.trait.scale}", Description = "$bv{ryza.ext.trait.scale.description}", Species = "scale_hound", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "lindwurm_scales", Count = 1 }] };
bv.RyzaAugmentOrder.push("hunt"); bv.RyzaAugments.hunt <- { ID = "hunt", Name = "$bv{ryza.ext.trait.hunt}", Description = "$bv{ryza.ext.trait.hunt.description}", Species = "frost_wolf", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "adrenaline_gland", Count = 2 }] };
bv.RyzaAugmentOrder.push("eagle"); bv.RyzaAugments.eagle <- { ID = "eagle", Name = "$bv{ryza.ext.trait.eagle}", Description = "$bv{ryza.ext.trait.eagle.description}", Species = "wind_hawk", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "spider_silk", Count = 2 }] };
bv.RyzaAugmentOrder.push("three"); bv.RyzaAugments.three <- { ID = "three", Name = "$bv{ryza.ext.trait.three}", Description = "$bv{ryza.ext.trait.three.description}", Species = "cerberus", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "unhold_heart", Count = 1 }] };
bv.RyzaAugmentOrder.push("wall"); bv.RyzaAugments.wall <- { ID = "wall", Name = "$bv{ryza.ext.trait.wall}", Description = "$bv{ryza.ext.trait.wall.description}", Species = "iron_cerberus", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "unhold_bones", Count = 2 }] };
bv.RyzaAugmentOrder.push("blood"); bv.RyzaAugments.blood <- { ID = "blood", Name = "$bv{ryza.ext.trait.blood}", Description = "$bv{ryza.ext.trait.blood.description}", Species = "blood_wolf", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "adrenaline_gland", Count = 2 }] };
bv.RyzaAugmentOrder.push("regen"); bv.RyzaAugments.regen <- { ID = "regen", Name = "$bv{ryza.ext.trait.regen}", Description = "$bv{ryza.ext.trait.regen.description}", Species = "spirit_vulture", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "unhold_heart", Count = 2 }] };
bv.RyzaAugmentOrder.push("guard"); bv.RyzaAugments.guard <- { ID = "guard", Name = "$bv{ryza.ext.trait.guard}", Description = "$bv{ryza.ext.trait.guard.description}", Species = "twin_guardian", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "unhold_hide", Count = 2 }] };
bv.RyzaAugmentOrder.push("pierce"); bv.RyzaAugments.pierce <- { ID = "pierce", Name = "$bv{ryza.ext.trait.pierce}", Description = "$bv{ryza.ext.trait.pierce.description}", Species = "splitjaw", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "lindwurm_bones", Count = 1 }] };
bv.RyzaAugmentOrder.push("stride"); bv.RyzaAugments.stride <- { ID = "stride", Name = "$bv{ryza.ext.trait.stride}", Description = "$bv{ryza.ext.trait.stride.description}", Species = "griffin", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "adrenaline_gland", Count = 2 }] };
bv.RyzaAugmentOrder.push("nerve"); bv.RyzaAugments.nerve <- { ID = "nerve", Name = "$bv{ryza.ext.trait.nerve}", Description = "$bv{ryza.ext.trait.nerve.description}", Species = "mane_tusk", Tier = 3, Core = false, Cost = 5000, Days = 5, Materials = [{ Key = "unhold_hide", Count = 2 }] };
bv.RyzaAugmentOrder.push("wing"); bv.RyzaAugments.wing <- { ID = "wing", Name = "$bv{ryza.ext.trait.wing}", Description = "$bv{ryza.ext.trait.wing.description}", Species = "ironwing", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "lindwurm_scales", Count = 1 }] };
bv.RyzaAugmentOrder.push("night"); bv.RyzaAugments.night <- { ID = "night", Name = "$bv{ryza.ext.trait.night}", Description = "$bv{ryza.ext.trait.night.description}", Species = "nightwing", Tier = 2, Core = false, Cost = 2500, Days = 3, Materials = [{ Key = "poison_gland", Count = 2 }] };
bv.RyzaAugmentOrder.push("life"); bv.RyzaAugments.life <- { ID = "life", Name = "$bv{ryza.ext.trait.life}", Description = "$bv{ryza.ext.trait.life.description}", Species = "spirit_vulture", Tier = 4, Core = true, Cost = 10000, Days = 7, Materials = [{ Key = "unhold_heart", Count = 3 }, { Key = "unhold_bones", Count = 2 }] };
bv.RyzaAugmentOrder.push("giant"); bv.RyzaAugments.giant <- { ID = "giant", Name = "$bv{ryza.ext.trait.giant}", Description = "$bv{ryza.ext.trait.giant.description}", Species = "bone_mastiff", Tier = 4, Core = true, Cost = 10000, Days = 7, Materials = [{ Key = "unhold_heart", Count = 2 }, { Key = "unhold_hide", Count = 3 }] };
bv.RyzaAugmentOrder.push("fury"); bv.RyzaAugments.fury <- { ID = "fury", Name = "$bv{ryza.ext.trait.fury}", Description = "$bv{ryza.ext.trait.fury.description}", Species = "cerberus", Tier = 4, Core = true, Cost = 10000, Days = 7, Materials = [{ Key = "unhold_heart", Count = 2 }, { Key = "adrenaline_gland", Count = 3 }] };

// Native anatomist uniqueness flags must be released when a donor leaves the roster.
bv.RyzaNativePotionFlags <- {
 "effects.alp_potion" : "isAlpPotionAcquired",
 "effects.ancient_priest_potion" : "isAncientPriestPotionAcquired",
 "effects.direwolf_potion" : "isDirewolfPotionAcquired",
 "effects.fallen_hero_potion" : "isFallenHeroPotionAcquired",
 "effects.geist_potion" : "isGeistPotionAcquired",
 "effects.goblin_grunt_potion" : "isGoblinGruntPotionAcquired",
 "effects.goblin_overseer_potion" : "isGoblinOverseerPotionAcquired",
 "effects.goblin_shaman_potion" : "isGoblinShamanPotionAcquired",
 "effects.grand_diviner_potion" : "isGrandDivinerPotionAcquired",
 "effects.greater_flesh_golem_potion" : "isGreaterFleshGolemPotionAcquired",
 "effects.hexe_potion" : "isHexePotionAcquired",
 "effects.honor_guard_potion" : "isHonorGuardPotionAcquired",
 "effects.hyena_potion" : "isHyenaPotionAcquired",
 "effects.ifrit_potion" : "isIfritPotionAcquired",
 "effects.ijirok_potion" : "isIjirokPotionAcquired",
 "effects.kraken_potion" : "isKrakenPotionAcquired",
 "effects.lesser_flesh_golem_potion" : "isLesserFleshGolemPotionAcquired",
 "effects.lindwurm_potion" : "isLindwurmPotionAcquired",
 "effects.lorekeeper_potion" : "isLorekeeperPotionAcquired",
 "effects.nachzehrer_potion" : "isNachzehrerPotionAcquired",
 "effects.necromancer_potion" : "isNecromancerPotionAcquired",
 "effects.necrosavant_potion" : "isNecrosavantPotionAcquired",
 "effects.orc_berserker_potion" : "isOrcBerserkerPotionAcquired",
 "effects.orc_warlord_potion" : "isOrcWarlordPotionAcquired",
 "effects.orc_warrior_potion" : "isOrcWarriorPotionAcquired",
 "effects.orc_young_potion" : "isOrcYoungPotionAcquired",
 "effects.rachegeist_potion" : "isRachegeistPotionAcquired",
 "effects.schrat_potion" : "isSchratPotionAcquired",
 "effects.serpent_potion" : "isSerpentPotionAcquired",
 "effects.skeleton_warrior_potion" : "isSkeletonWarriorPotionAcquired",
 "effects.unhold_potion" : "isUnholdPotionAcquired",
 "effects.webknecht_potion" : "isWebknechtPotionAcquired",
 "effects.wiederganger_potion" : "isWiedergangerPotionAcquired"
};
