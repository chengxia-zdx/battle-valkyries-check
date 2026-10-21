this.mikazuki_unyo <- this.inherit("scripts/items/weapons/battle_valkyries/tenka_goken_sword", {
 m = { Owner = "inaba_tsukuyo" },
 function create() { this.tenka_goken_sword.create();this.m.Name="$bv{item.mikazuki_unyo.name}";this.m.Description="$bv{item.mikazuki_unyo.description}"; }
});
