this.odenta_rose <- this.inherit("scripts/items/weapons/battle_valkyries/tenka_goken_sword", {
 m = { Owner = "kikakujo_mary" },
 function create() { this.tenka_goken_sword.create();this.m.Name="$bv{item.odenta_rose.name}";this.m.Description="$bv{item.odenta_rose.description}"; }
});
