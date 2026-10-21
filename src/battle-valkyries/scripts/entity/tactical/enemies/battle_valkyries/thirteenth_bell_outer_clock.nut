this.thirteenth_bell_outer_clock <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/thirteenth_bell_construct", {
 function create() { this.thirteenth_bell_construct.create(); this.m.ClockRole = "clock"; this.m.Name = "$bv{chapter.thirteenth_bell.enemy.clock}"; }
});
