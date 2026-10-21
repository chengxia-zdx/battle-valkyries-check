this.dojigiri_dance <- this.inherit("scripts/items/weapons/battle_valkyries/tenka_goken_sword", {
 m = { Owner = "hanasaka_warabi" },
 function create() { this.tenka_goken_sword.create();this.m.Name="$bv{item.dojigiri_dance.name}";this.m.Description="$bv{item.dojigiri_dance.description}"; }
});
