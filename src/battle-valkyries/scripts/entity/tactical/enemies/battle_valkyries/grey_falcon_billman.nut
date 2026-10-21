this.grey_falcon_billman <- this.inherit("scripts/entity/tactical/humans/noble_billman", {
	function create() { this.noble_billman.create(); this.m.Name = "$bv{enemy.grey_falcon.billman.name}"; },
	function assignRandomEquipment()
	{
		foreach (path in ["weapons/billhook", "armor/mail_hauberk", "helmets/kettle_hat_with_mail"])
			this.m.Items.equip(this.new("scripts/items/" + path));
	}
});
