this.juzumaru_changes <- this.inherit("scripts/items/weapons/battle_valkyries/tenka_goken_sword", {
 m = { Owner = "tamaba_satori" },
 function create() { this.tenka_goken_sword.create();this.m.Name="$bv{item.juzumaru_changes.name}";this.m.Description="$bv{item.juzumaru_changes.description}"; }
});
