this.onimaru_aun <- this.inherit("scripts/items/weapons/battle_valkyries/tenka_goken_sword", {
 m = { Owner = "onigawara_rin" },
 function create() { this.tenka_goken_sword.create();this.m.Name="$bv{item.onimaru_aun.name}";this.m.Description="$bv{item.onimaru_aun.description}"; }
});
