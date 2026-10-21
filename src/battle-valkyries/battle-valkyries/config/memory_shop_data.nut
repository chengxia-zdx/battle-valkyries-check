::$bvvar{namespace}.MemoryShopProducts <- [
	{
		ID = "melee_skill_keepsake",
		Name = "$bv{item.memory_melee_skill.name}",
		Description = "$bv{item.memory_melee_skill.description}",
		EffectLabel = "$bv{item.memory_melee_skill.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_melee_skill_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_melee_skill_keepsake_item",
		Cost = { Fragment = 2, Crystal = 2 }
	},
	{
		ID = "ranged_skill_keepsake",
		Name = "$bv{item.memory_ranged_skill.name}",
		Description = "$bv{item.memory_ranged_skill.description}",
		EffectLabel = "$bv{item.memory_ranged_skill.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_ranged_skill_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_ranged_skill_keepsake_item",
		Cost = { Fragment = 2, Crystal = 2 }
	},
	{
		ID = "melee_defense_keepsake",
		Name = "$bv{item.memory_melee_defense.name}",
		Description = "$bv{item.memory_melee_defense.description}",
		EffectLabel = "$bv{item.memory_melee_defense.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_melee_defense_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_melee_defense_keepsake_item",
		Cost = { Fragment = 2, Crystal = 2 }
	},
	{
		ID = "ranged_defense_keepsake",
		Name = "$bv{item.memory_ranged_defense.name}",
		Description = "$bv{item.memory_ranged_defense.description}",
		EffectLabel = "$bv{item.memory_ranged_defense.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_ranged_defense_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_ranged_defense_keepsake_item",
		Cost = { Fragment = 2, Crystal = 2 }
	},
	{
		ID = "stamina_keepsake",
		Name = "$bv{item.memory_stamina.name}",
		Description = "$bv{item.memory_stamina.description}",
		EffectLabel = "$bv{item.memory_stamina.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_stamina_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_stamina_keepsake_item",
		Cost = { Fragment = 4 }
	},
	{
		ID = "hitpoints_keepsake",
		Name = "$bv{item.memory_hitpoints.name}",
		Description = "$bv{item.memory_hitpoints.description}",
		EffectLabel = "$bv{item.memory_hitpoints.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_hitpoints_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_hitpoints_keepsake_item",
		Cost = { Fragment = 4 }
	},
	{
		ID = "initiative_keepsake",
		Name = "$bv{item.memory_initiative.name}",
		Description = "$bv{item.memory_initiative.description}",
		EffectLabel = "$bv{item.memory_initiative.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_initiative_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_initiative_keepsake_item",
		Cost = { Fragment = 4 }
	},
	{
		ID = "bravery_keepsake",
		Name = "$bv{item.memory_bravery.name}",
		Description = "$bv{item.memory_bravery.description}",
		EffectLabel = "$bv{item.memory_bravery.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_bravery_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_bravery_keepsake_item",
		Cost = { Fragment = 4 }
	},
	{
		ID = "level_keepsake",
		Name = "$bv{item.memory_level.name}",
		Description = "$bv{item.memory_level.description}",
		EffectLabel = "$bv{item.memory_level.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_level_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_level_keepsake_item",
		Cost = { Crystal = 4, Eternal = 1 }
	},
	{
		ID = "bond_keepsake",
		Name = "$bv{item.memory_bond.name}",
		Description = "$bv{item.memory_bond.description}",
		EffectLabel = "$bv{item.memory_bond.effect}",
		Icon = "ui/items/$bvvar{iconPrefix}/memory_bond_keepsake.png",
		ItemScript = "scripts/items/misc/battle_valkyries/memory_bond_keepsake_item",
		Cost = { Emblem = 1 }
	}
];

::$bvvar{namespace}.getMemoryShopProductByID <- function( _productID )
{
	foreach (product in ::$bvvar{namespace}.MemoryShopProducts)
	{
		if (product.ID == _productID) return product;
	}
	return null;
};

::$bvvar{namespace}.validateMemoryShopData <- function()
{
	local ids = {};
	local resourceKeys = {};
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		resourceKeys[resource.Key] <- true;
	}
	foreach (product in ::$bvvar{namespace}.MemoryShopProducts)
	{
		if (!("ID" in product) || product.ID == "" || product.ID in ids) return false;
		if (!("Icon" in product) || product.Icon == "") return false;
		if (!("ItemScript" in product) || product.ItemScript == "") return false;
		if (!("Cost" in product) || typeof product.Cost != "table" || product.Cost.len() == 0) return false;
		foreach (key, amount in product.Cost)
		{
			if (!(key in resourceKeys) || typeof amount != "integer" || amount <= 0) return false;
		}
		ids[product.ID] <- true;
	}
	return true;
};
