this.grey_falcon_arbalester <- this.inherit("scripts/entity/tactical/humans/noble_arbalester", {
	function create() { this.noble_arbalester.create(); this.m.Name = "$bv{enemy.grey_falcon.arbalester.name}"; },
	function onInit()
	{
		this.noble_arbalester.onInit();
		this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/grey_falcon_crossbow_order_effect"));
	},
	function assignRandomEquipment()
	{
		foreach (path in ["weapons/heavy_crossbow", "ammo/quiver_of_bolts", "armor/mail_shirt", "helmets/padded_kettle_hat"])
			this.m.Items.equip(this.new("scripts/items/" + path));
		this.m.Items.addToBag(this.new("scripts/items/weapons/shortsword"));
	}
});
