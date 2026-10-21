::$bvvar{namespace}.getExpandedEnemyDefinition <- function( _key )
{
	if (typeof _key != "string") return null;
	foreach (group in ::$bvvar{namespace}.ExpandedEnemyGroups)
		foreach (enemy in group.Enemies)
			if (enemy.Key == _key) return enemy;
	return null;
};

::$bvvar{namespace}.getExpandedEnemyScript <- function( _key )
{
	return "scripts/entity/tactical/enemies/battle_valkyries/bv_enemy_" + _key;
};

::$bvvar{namespace}.initializeExpandedEnemy <- function( _actor, _key )
{
	local def = ::$bvvar{namespace}.getExpandedEnemyDefinition(_key);
	if (def == null) throw "[Battle Valkyries] Unknown expanded enemy: " + _key;
	_actor.getFlags().set("BVExpandedEnemyKey", _key);
	_actor.m.Name = def.Name;
	::$bvvar{namespace}.restoreExpandedEnemyCombat(_actor, _key);
	_actor.setHitpoints(_actor.getHitpointsMax());
	::$bvvar{namespace}.applyExpandedEnemyVisual(_actor, _key);
};

::$bvvar{namespace}.getExpandedEnemyCombatProfile <- function( _key )
{
	local profiles = ::$bvvar{namespace}.ExpandedEnemyCombatProfiles;
	if (typeof _key != "string" || !(_key in profiles)) return null;
	local profile = profiles[_key];
	if (!("LegendMod" in ::Const)) return profile;
	local adjusted = clone profile;
	adjusted.Hitpoints = profile.LegendsHitpoints;
	adjusted.Add = clone profile.Add;
	foreach (property, delta in adjusted.Add) adjusted.Add[property] = delta * 0.8;
	return adjusted;
};

// Also used after reading an old save. Never heals or assigns equipment here.
::$bvvar{namespace}.restoreExpandedEnemyCombat <- function( _actor, _key )
{
	if (::$bvvar{namespace}.getExpandedEnemyDefinition(_key) == null) return;
	_actor.getFlags().set("BVExpandedEnemyKey", _key);
	local skills = _actor.getSkills();
	if (_key == "orcs_t25" || _key == "orcs_t4")
		foreach (id in ["actives.warcry", "perk.captain", "effects.captain",
			"perk.legend_composure", "perk.inspiring_presence", "trait.fearless"])
			skills.removeByID(id);
	if (_key == "orcs_t25")
		foreach (id in ["perk.battle_forged", "perk.fearsome", "effects.berserker_rage"])
			skills.removeByID(id);
	if (!skills.hasSkill("trait.bv_enemy_tier"))
		skills.add(::new("scripts/skills/traits/battle_valkyries/bv_enemy_tier_trait"));
	local profile = ::$bvvar{namespace}.getExpandedEnemyCombatProfile(_key);
	if (profile != null)
	{
		if ("Perks" in profile)
			foreach (perk in profile.Perks)
				if (!skills.hasSkill("perk." + perk.slice(5)))
					skills.add(::new("scripts/skills/perks/" + perk));
		if ("NightmareDamage" in profile)
		{
			local nightmare = skills.getSkillByID("actives.nightmare");
			if (nightmare == null || !("BVExpandedNightmare" in nightmare.m))
			{
				// Keep the vanilla skill ID so the inherited alp AI still finds it.
				skills.removeByID("actives.nightmare");
				skills.add(::new("scripts/skills/actives/battle_valkyries/bv_enemy_nightmare_skill"));
			}
		}
	}
	skills.update();
};

// Both the autonomous timer and a necromancer consume the same corpse token.
// Only our three zombie classes call this; native Fallen Heroes stay untouched.
::$bvvar{namespace}.generateExpandedEnemyCorpse <- function( _actor, _tile, _fatality, _killer, _original )
{
	local count = _actor.getFlags().get("BVEnemyResurrections");
	if (count == null) count = _actor.m.IsResurrected ? 1 : 0;
	local eligible = count < 1 && _tile != null
		&& _fatality != ::Const.FatalityType.Decapitated && _fatality != ::Const.FatalityType.Smashed;
	local oldResurrected = _actor.m.IsResurrected;
	local oldFatality = _actor.m.IsResurrectingOnFatality;
	_actor.m.IsResurrectingOnFatality = false;
	if (!eligible) _actor.m.IsResurrected = true; // Prevent the parent scheduling a second timer.
	local corpse;
	try { corpse = _original(_tile, _fatality, _killer); }
	catch (e) { _actor.m.IsResurrected = oldResurrected; _actor.m.IsResurrectingOnFatality = oldFatality; throw e; }
	_actor.m.IsResurrected = oldResurrected;
	_actor.m.IsResurrectingOnFatality = oldFatality;
	if (corpse == null) return null;
	if (corpse.Custom == null) corpse.Custom = {};
	corpse.Custom.BVEnemyResurrections <- count + 1;
	corpse.Custom.BVEnemyCanResurrect <- eligible;
	corpse.Custom.BVEnemyRewardID <- _actor.getFlags().get("BVEnemyRewardID");
	local key = _actor.getFlags().get("BVExpandedEnemyKey");
	corpse.Hitpoints = key == "zombies_t25" ? 0.30 : (key == "zombies_t4" ? 0.35 : 0.40);
	if (!eligible) { corpse.IsResurrectable = false; corpse.IsConsumable = false; }
	return corpse;
};

::$bvvar{namespace}.restoreExpandedEnemyCorpse <- function( _actor, _info )
{
	local custom = _info.Custom;
	_actor.getFlags().set("BVEnemyResurrections", custom != null && "BVEnemyResurrections" in custom ? custom.BVEnemyResurrections : 1);
	if (custom != null && "BVEnemyRewardID" in custom)
	{
		_actor.getFlags().set("BVEnemyRewardID", custom.BVEnemyRewardID);
		if ("EnemyRewards" in ::$bvvar{namespace}) ::$bvvar{namespace}.EnemyRewards.resurrect(_actor);
	}
};

// Legends perks inherited from the parent (notably cultist specializations)
// expect real layered armor. Resolve registered outfits through the host factory
// instead of creating vanilla armor and pretending it has an Upgrades array.
::$bvvar{namespace}.createExpandedEnemyEquipment <- function( _path )
{
	if ("LegendMod" in ::Const)
	{
		local host = ::Const.LegendMod;
		local common = ::Const.World.Common;
		if (_path.find("armor/") == 0 && "Armors" in host && "pickArmor" in common && _path.slice(6) in host.Armors)
			return common.pickArmor([[1, _path.slice(6)]]);
		if (_path.find("helmets/") == 0 && "Helmets" in host && "pickHelmet" in common && _path.slice(8) in host.Helmets)
			return common.pickHelmet([[1, _path.slice(8)]]);
		if (_path.find("armor_upgrades/") == 0 && "Armors" in host && "pickArmorUpgrade" in common && _path.slice(15) in host.Armors)
			return common.pickArmorUpgrade([[1, _path.slice(15)]]);
	}
	return ::new("scripts/items/" + _path);
};

// Called only by the custom actor's initial equipment callback. Do not replace
// restored corpse equipment, refill broken gear, or inject a second bag weapon.
::$bvvar{namespace}.equipExpandedEnemy <- function( _actor, _key )
{
	local profile = ::$bvvar{namespace}.getExpandedEnemyCombatProfile(_key);
	if (profile == null || !("Equipment" in profile)) return false;
	if (_actor.getFlags().get("BVExpandedEnemyEquipmentAssigned") == true) return true;
	local items = _actor.getItems();
	local gear = profile.Equipment;
	foreach (slot in ["Mainhand", "Offhand", "Body", "Head", "Ammo"])
	{
		if (!(slot in gear) || !items.hasEmptySlot(::Const.ItemSlot[slot])) continue;
		local item = ::$bvvar{namespace}.createExpandedEnemyEquipment(gear[slot]);
		if (slot == "Body" && "BodyUpgrade" in gear)
			item.setUpgrade(::$bvvar{namespace}.createExpandedEnemyEquipment(gear.BodyUpgrade));
		if (!items.equip(item))
			::logError("[Battle Valkyries] Could not equip " + gear[slot] + " on " + _key);
	}
	if ("Bag" in gear)
		foreach (path in gear.Bag) items.addToBag(::new("scripts/items/" + path));
	_actor.getFlags().set("BVExpandedEnemyEquipmentAssigned", true);
	_actor.getSkills().update();
	return true;
};

::$bvvar{namespace}.ExpandedEnemyHiddenSprites <- [
	"body", "head", "head_frenzy", "hair", "beard", "beard_top", "eyes", "closed_eyes",
	"helmet", "helmet_damage", "armor", "surcoat", "quiver",
	"armor_upgrade_back", "armor_upgrade_front", "tattoo_body", "tattoo_head",
	"injury", "injury_body", "body_blood", "dirt", "scar_head", "scar_body", "shaft",
	"legs_back", "legs_front", "background", "eye_rings", "accessory_special",
	"armor_layer_chain", "armor_layer_plate", "armor_layer_tabbard", "armor_layer_cloak_front",
	"armor_layer_cloak", "armor_upgrade_back_top", "helmet_vanity_lower", "helmet_vanity_lower_2",
	"helmet_helm_lower", "helmet_top_lower", "helmet_helm", "helmet_top", "helmet_vanity", "helmet_vanity_2",
	"charm_body", "charm_armor", "charm_head", "charm_hair",
	"bandage_1", "bandage_2", "bandage_3", "permanent_injury_1", "permanent_injury_2",
	"permanent_injury_3", "permanent_injury_4"
];

::$bvvar{namespace}.applyExpandedEnemyVisual <- function( _actor, _key )
{
	local def = ::$bvvar{namespace}.getExpandedEnemyDefinition(_key);
	if (def == null || def.Art == null || !_actor.hasSprite("accessory")) return;
	// A whole bust contains a head. Keep the original layered representation
	// for headless resurrected corpses rather than visually restoring a head.
	if ("IsHeadless" in _actor.m && _actor.m.IsHeadless)
	{
		_actor.getSprite("accessory").Visible = false;
		foreach (name in ["body", "armor", "armor_upgrade_back", "armor_upgrade_front", "surcoat"])
			if (_actor.hasSprite(name) && _actor.getSprite(name).HasBrush)
			{
				_actor.getSprite(name).Alpha = 255;
				_actor.getSprite(name).Visible = true;
			}
		return;
	}
	// Retain original brushes for injury, equipment and corpse logic. Only their
	// rendering is suppressed; the independent sprite contains the whole bust.
	foreach (name in ::$bvvar{namespace}.ExpandedEnemyHiddenSprites)
		if (_actor.hasSprite(name))
		{
			_actor.getSprite(name).Visible = false;
			_actor.getSprite(name).Alpha = 0;
		}
	local sprite = _actor.getSprite("accessory");
	// All expansion source busts face right. Beast parents only flip their own
	// original layers, so explicitly apply the human-style faction convention.
	sprite.setHorizontalFlipping(!_actor.isAlliedWithPlayer());
	// Absolute live-bust offset only: leave sockets, equipment and status bars
	// at their native positions, and never accumulate displacement on updates.
	if ("LiveOffsetY" in def)
		_actor.setSpriteOffset("accessory", ::createVec(0, def.LiveOffsetY));
	if (!sprite.HasBrush || sprite.getBrush().Name != def.Art)
	{
		sprite.setBrush(def.Art);
		sprite.Alpha = 255;
		sprite.Visible = true;
		sprite.Scale = def.VisualScale;
	}
	// Do not reset alpha: the original actor fade/teleport animation owns it.
};

::$bvvar{namespace}.applyExpandedEnemyCorpseVisual <- function( _key, _tile )
{
	local def = ::$bvvar{namespace}.getExpandedEnemyDefinition(_key);
	if (def == null || def.Art == null || def.DeathArt == null || _tile == null || !_tile.Properties.has("Corpse")) return;
	// Parent onDeath has already registered the corpse, loot and resurrection
	// data. Replace only the rendered corpse details, preserving those records.
	_tile.clear(::Const.Tactical.DetailFlag.Corpse);
	local decal = _tile.spawnDetail(def.DeathArt, ::Const.Tactical.DetailFlag.Corpse, false);
	decal.Alpha = 255;
	decal.Scale = 0.9 * def.VisualScale;
};

// Only the six adjacent tiles; report failure instead of spawning off-screen.
::$bvvar{namespace}.findExpandedEnemyTestTile <- function( _origin )
{
	local occupied = {};
	foreach (entity in ::World.getAllEntitiesVisibleAtPos(::World.State.getPlayer().getPos(), 1000.0))
		if (entity != null && entity.isAlive()) occupied[entity.getTile().ID] <- true;
	for (local direction = 0; direction < 6; ++direction)
	{
		if (!_origin.hasNextTile(direction)) continue;
		local tile = _origin.getNextTile(direction);
		if (tile.Type == ::Const.World.TerrainType.Ocean || tile.Type == ::Const.World.TerrainType.Shore) continue;
		if (tile.IsOccupied || tile.ID in occupied) continue;
		return tile;
	}
	return null;
};

::$bvvar{namespace}.spawnExpandedEnemyTestParty <- function( _groupID )
{
	local api = ::$bvvar{namespace};
	if (!api.isTestPanelOriginAvailable()) return api.makeTestPanelResult(false, "origin", "$bv{ui.test_panel.error.origin}");
	local group = null;
	if (_groupID == "ordinary_bandits")
	{
		group = { ID = "ordinary_bandits", Label = "$bv{ui.test_panel.ordinary_bandits.label}", Enemies = [] };
		for (local i = 0; i < 10; ++i)
			group.Enemies.push({ Troop = "BanditThug", Name = "$bv{ui.test_panel.ordinary_bandits.name}" });
	}
	else if (_groupID == "all")
	{
		// One catalogue entry per troop, in one ordinary test party. Never alter
		// the catalogue, native troop templates or natural generation budgets.
		group = { ID = "all", Label = "$bv{enemy_expansion.test.all_label}", Enemies = [] };
		foreach (candidate in api.ExpandedEnemyGroups) group.Enemies.extend(candidate.Enemies);
	}
	else
	{
		foreach (candidate in api.ExpandedEnemyGroups)
			if (candidate.ID == _groupID) { group = candidate; break; }
	}
	if (group == null) return api.makeTestPanelResult(false, "invalid", "$bv{ui.test_panel.error.invalid}");
	local player = ::World.State.getPlayer();
	if (player == null || !player.isAlive()) return api.makeTestPanelResult(false, "player", "$bv{enemy_expansion.test.no_player}");
	local tile = api.findExpandedEnemyTestTile(player.getTile());
	if (tile == null) return api.makeTestPanelResult(false, "tile", "$bv{enemy_expansion.test.no_tile}");
	// All test opponents use an already hostile faction, including noble/militia
	// archetypes, so a test never damages diplomatic relations with settlements.
	local faction = ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits);
	if (faction == null) return api.makeTestPanelResult(false, "faction", "$bv{enemy_expansion.test.no_faction}");
	local troops = [];
	foreach (enemy in group.Enemies)
	{
		if (!(enemy.Troop in ::Const.World.Spawn.Troops)) return api.makeTestPanelResult(false, "template", "$bv{enemy_expansion.test.no_template}");
		local troop = clone ::Const.World.Spawn.Troops[enemy.Troop];
		// Ordinary bandits retain the host's basic troop script and equipment.
		if (_groupID != "ordinary_bandits") troop.Script = api.getExpandedEnemyScript(enemy.Key);
		troop.Variant = 0;
		troops.push({ Type = troop, Name = enemy.Name });
	}
	local party = null;
	try
	{
		party = ::World.spawnEntity("scripts/entity/world/parties/battle_valkyries_enemy_test_party", tile.Coords.X, tile.Coords.Y);
		party.setFaction(faction.getID());
		party.setName(group.Label + "$bv{enemy_expansion.test.party_suffix}");
		party.setDescription(_groupID == "ordinary_bandits" ? "$bv{ui.test_panel.action.ordinary_bandits.description}" : "$bv{enemy_expansion.test.party_description}");
		party.getFlags().set("BVEnemyTestGroup", group.ID);
		foreach (entry in troops)
		{
			// No faction spawn, random troop list, champion roll or budget hook.
			local troop = ::Const.World.Common.addTroop(party, { Type = entry.Type }, false, 0);
			troop.Name = entry.Name;
		}
		party.updateStrength();
		party.setVisibleInFogOfWar(true);
		return api.makeTestPanelResult(true, "ok", group.Label + "$bv{enemy_expansion.test.success}");
	}
	catch (e)
	{
		if (party != null) party.die();
		::logError("[Battle Valkyries] Enemy test party failed: " + e);
		return api.makeTestPanelResult(false, "spawn", "$bv{enemy_expansion.test.failed}");
	}
};
