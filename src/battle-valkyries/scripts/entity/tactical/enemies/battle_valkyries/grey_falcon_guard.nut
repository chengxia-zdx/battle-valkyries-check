this.grey_falcon_guard <- this.inherit("scripts/entity/tactical/humans/noble_footman", {
	function create() { this.noble_footman.create(); this.m.Name = "$bv{enemy.grey_falcon.guard.name}"; },
	function assignRandomEquipment()
	{
		// Explicit native equipment avoids noble faction/banner dependencies.
		foreach (path in ["weapons/arming_sword", "shields/heater_shield", "armor/reinforced_mail_hauberk", "helmets/kettle_hat_with_closed_mail"])
			this.m.Items.equip(this.new("scripts/items/" + path));
	}
});
