this.grail_wish_executor <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/grail_wishforged_guard", {
 function create() { this.grail_wishforged_guard.create(); this.m.Name="$bv{chapter.grail.enemy.executor}";this.m.XP=1600;this.m.GrailBrush="bust_bv_unclaimed_grail_four_oaths_wish_executor"; },
 function onInit() { this.grail_wishforged_guard.onInit();local p=this.m.BaseProperties;p.Hitpoints=1000;p.MeleeSkill=100;p.MeleeDefense=25;p.RangedDefense=20;p.DamageTotalMult*=1.4;this.m.Hitpoints=p.Hitpoints;this.m.CurrentProperties=clone p; },
 function assignRandomEquipment() { this.m.Items.equip(this.new("scripts/items/weapons/ancient/ancient_sword")); this.m.Items.equip(this.new("scripts/items/armor/ancient/ancient_plate_harness")); this.m.Items.equip(this.new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));this.refreshGrailVisual(); }
});
