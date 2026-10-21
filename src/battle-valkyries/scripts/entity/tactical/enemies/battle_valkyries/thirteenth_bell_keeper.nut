this.thirteenth_bell_keeper <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/thirteenth_bell_construct", {
 function create() { this.thirteenth_bell_construct.create(); this.m.ClockRole = "keeper"; this.m.Name = "$bv{chapter.thirteenth_bell.enemy.keeper}"; }
});
