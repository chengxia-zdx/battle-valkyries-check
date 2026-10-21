this.thirteenth_bell_gatekeeper <- this.inherit("scripts/entity/tactical/enemies/battle_valkyries/thirteenth_bell_construct", {
 function create() { this.thirteenth_bell_construct.create(); this.m.ClockRole = "gatekeeper"; this.m.Name = "$bv{chapter.thirteenth_bell.enemy.gatekeeper}"; }
});
