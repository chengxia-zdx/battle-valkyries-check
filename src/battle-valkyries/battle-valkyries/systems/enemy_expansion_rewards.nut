// One record belongs to an original world troop, not each tactical incarnation.
// Items use the host serializer, preserving names, rolls, condition and upgrades.
::$bvvar{namespace}.EnemyRewards <- {
	Battle = {},
	Pending = null,
	Summary = "",
	function stash()
	{
		local s = ::new("scripts/items/stash_container");
		s.setResizable(true);
		return s;
	},
	function resetBattle() { this.Battle = {}; this.Summary = ""; },
	function resetWorld() { this.resetBattle(); this.Pending = null; },
	function partyRecords( _party )
	{
		if (!("BVEnemyRewards" in _party.m)) _party.m.BVEnemyRewards <- [];
		return _party.m.BVEnemyRewards;
	},
	function detach( _item )
	{
		local c = _item.getContainer();
		if (c != null && !c.isNull())
		{
			if (_item.getCurrentSlotType() == ::Const.ItemSlot.Bag) c.removeFromBag(_item);
			else if (_item.getCurrentSlotType() != ::Const.ItemSlot.None) c.unequip(_item);
		}
		_item.removeFromContainer();
	},
	function playerOwns( _item )
	{
		if (::World.Assets.getStash().getItems().find(_item) != null) return true;
		foreach (bro in ::World.getPlayerRoster().getAll())
			if (bro.getItems().getAllItems().find(_item) != null) return true;
		return false;
	},
	function durability( _item )
	{
		// Legends' getCondition is only the base layer; setCondition affects the
		// complete outfit. Never discard surviving layers when the base reaches zero.
		return "Upgrades" in _item.m && "getArmor" in _item ? _item.getArmor() : _item.getCondition();
	},
	function replace( _actor, _item )
	{
		local items = _actor.getItems();
		local slot = _item.getSlotType();
		local old = items.getItemAtSlot(slot);
		if (old == _item) return;
		// A two-handed parent weapon may block the shield slot.
		if (old == -1) items.unequip(items.getItemAtSlot(::Const.ItemSlot.Mainhand));
		else if (old != null) items.unequip(old);
		local blocked = _item.getBlockedSlotType();
		if (blocked != null)
		{
			old = items.getItemAtSlot(blocked);
			if (old != null && old != -1) items.unequip(old);
		}
		this.detach(_item);
		if (!items.equip(_item)) throw "[Battle Valkyries] Named enemy equipment did not fit its configured slot";
	},
	function applyTransitionEquipment( _actor, _key, _tier )
	{
		local ns = ::$bvvar{namespace};
		local group = _key.slice(0, _key.len() - _tier.len() - 1);
		if (_tier != "t25" && _key != "orcs_t4") return;
		if (!(group in ns.ExpandedEnemyTransitionEquipment)) return;
		foreach (slot, path in ns.ExpandedEnemyTransitionEquipment[group])
			this.replace(_actor, ns.createExpandedEnemyEquipment(path));
	},
	function makeItems( _key, _tier )
	{
		if (_tier == "t25") return { Items = this.stash(), Equipped = false, BagSecond = false };
		local ns = ::$bvvar{namespace};
		local group = _key.slice(0, _key.len() - _tier.len() - 1);
		local humanoid = group in ns.ExpandedEnemyNamedWeapons;
		local weapon = humanoid ? ns.ExpandedEnemyNamedWeapons[group][_tier == "t4" ? 0 : 1] : "sword";
		local items = this.stash();
		items.add(ns.createExpandedEnemyEquipment("weapons/named/named_" + weapon));
		if (_tier == "t5")
		{
			local second = group == "orcs" ? "shields/named/named_orc_heavy_shield"
				: (group == "goblins" ? "weapons/named/named_goblin_falchion"
				: (["nomads", "bounty_hunters", "cultists", "gladiators"].find(group) != null ? "helmets/named/wolf_helmet" : "helmets/named/named_nordic_helmet_with_closed_mail"));
			items.add(ns.createExpandedEnemyEquipment(second));
		}
		foreach (item in items.getItems())
		{
			if (!item.isItemType(::Const.Items.ItemType.Named)) throw "[Battle Valkyries] Enemy reward factory returned non-Named equipment";
			item.getFlags().set("BVEnemyRewardLocked", true);
		}
		return { Items = items, Equipped = humanoid, BagSecond = group == "goblins" };
	},
	function equipRecord( _actor, _r )
	{
		if (!_r.Equipped) return;
		foreach (i, item in _r.Items.getItems())
		{
			if (item == null || this.playerOwns(item)) continue;
			if (item.getConditionMax() > 0 && this.durability(item) <= 0) continue;
			if (_actor.getItems().getAllItems().find(item) != null) continue;
			if (i == 1 && _r.BagSecond)
			{
				this.detach(item);
				if (!_actor.getItems().addToBag(item)) throw "[Battle Valkyries] Named enemy backup weapon did not fit";
			}
			else this.replace(_actor, item);
		}
		_actor.getSkills().update();
		_actor.getFlags().set("BVExpandedEnemyEquipmentAssigned", true);
	},
	function setup( _actor, _troop )
	{
		local ns = ::$bvvar{namespace};
		local key = _actor.getFlags().get("BVExpandedEnemyKey");
		local def = ns.getExpandedEnemyDefinition(key);
		if (def == null || _actor.isAlliedWithPlayer()) return;
		this.applyTransitionEquipment(_actor, key, def.Tier);
		// setupEntity is the host's original-troop entry; summons, splits and tails
		// created directly by spawnEntity never pass through this registration.
		local party = "Party" in _troop ? _troop.Party : null;
		// Direct contract troops can legitimately have no world party. Being an
		// original setupEntity troop, rather than a summoned child, is the gate.
		// Native tag_collection.get returns false for an absent tag, not null.
		local eligible = def.Tier != "t25" && (party == null || party.isNull() || !party.getFlags().has("BVEnemyTestGroup"));
		local records = party == null || party.isNull() ? [] : this.partyRecords(party);
		local r = null;
		foreach (entry in records) if (entry.Troop == _troop) { r = entry; break; }
		if (r == null) foreach (id, entry in this.Battle)
			if (entry.Troop == _troop) { r = entry; break; }
		if (r == null)
		{
			local gear = this.makeItems(key, def.Tier);
			local id = ns.getMemoryWorldInt("enemy_reward.next_id", 0) + 1;
			ns.setMemoryWorldValue("enemy_reward.next_id", id);
			r = { ID = id, Key = key, Troop = _troop, Items = gear.Items, Equipped = gear.Equipped,
				BagSecond = gear.BagSecond, Eligible = eligible, Dead = false, Settled = false, Resurrections = 0 };
			records.push(r);
		}
		// Repair the old false eligibility of surviving world troops on re-entry,
		// while retaining their item rolls, resurrection count and settled state.
		r.Eligible = eligible;
		r.Dead = false;
		this.Battle[r.ID] <- r;
		_actor.getFlags().set("BVEnemyRewardID", r.ID);
		_actor.getFlags().set("BVEnemyResurrections", r.Resurrections);
		this.equipRecord(_actor, r);
	},
	function death( _actor )
	{
		local id = _actor.getFlags().get("BVEnemyRewardID");
		if (id != null && id in this.Battle) this.Battle[id].Dead = true;
	},
	function resurrect( _actor )
	{
		local id = _actor.getFlags().get("BVEnemyRewardID");
		if (id == null || !(id in this.Battle)) return;
		local r = this.Battle[id];
		r.Dead = false;
		r.Resurrections = _actor.getFlags().get("BVEnemyResurrections");
		local party = "Party" in r.Troop ? r.Troop.Party : null;
		if (!_actor.isAlliedWithPlayer() && party != null && !party.isNull())
		{
			if (party.getTroops().find(r.Troop) == null) party.getTroops().push(r.Troop);
			_actor.setWorldTroop(r.Troop);
			party.updateStrength();
		}
		// The host may have dropped the weapon. Reuse the same object; no repairs.
		this.equipRecord(_actor, r);
	},
	function canReward( _state )
	{
		if (_state.isScenarioMode()) return false;
		local p = _state.getStrategicProperties();
		if (p != null && (p.IsArenaMode || p.IsLootingProhibited)) return false;
		local result = ::Tactical.Entities.getCombatResult();
		return result == ::Const.Tactical.CombatResult.EnemyDestroyed || result == ::Const.Tactical.CombatResult.EnemyRetreated;
	},
	function collect( _state )
	{
		if (!this.canReward(_state)) return;
		local ns = ::$bvvar{namespace};
		local fragments = 0, crystals = 0;
		local loot = _state.m.CombatResultLoot;
		local rewards = [];
		foreach (id, r in this.Battle)
		{
			if (!r.Eligible || !r.Dead || r.Settled) continue;
			rewards.push(r);
			local t5 = ns.getExpandedEnemyDefinition(r.Key).Tier == "t5";
			fragments += t5 ? 2 : 1;
			crystals += t5 ? 1 : 0;
		}
		if (rewards.len() == 0) return;
		// Prepare visible resource bundles before settling any original troop.
		// Each kind occupies one loot slot, with its full quantity shown by the item.
		local resources = [];
		foreach (entry in [{ Kind = "fragment", Amount = fragments }, { Kind = "crystal", Amount = crystals }])
		{
			if (entry.Amount <= 0) continue;
			local item = ::new("scripts/items/misc/battle_valkyries/memory_" + entry.Kind + "_item");
			item.setAmount(entry.Amount);
			item.getFlags().set("BVEnemyRewardGuaranteed", true);
			resources.push(item);
		}
		foreach (r in rewards)
		{
			foreach (item in r.Items.getItems())
			{
				if (item == null || this.playerOwns(item)) continue;
				this.detach(item);
				item.onCombatFinished();
				// Combat damage is retained. A destroyed guaranteed item is salvageable
				// at one durability only after victory, never during combat/resurrection.
				if (item.getConditionMax() > 0 && this.durability(item) <= 0) item.setCondition(1);
				item.getFlags().set("BVEnemyRewardLocked", false);
				item.getFlags().set("BVEnemyRewardGuaranteed", true);
				item.m.IsDroppedAsLoot = true;
				if (loot.getItems().find(item) == null) loot.add(item);
			}
		}
		foreach (item in resources) loot.add(item);
		foreach (r in rewards) r.Settled = true;
		this.Summary = ::format("$bv{enemy_expansion.reward.summary}", fragments, crystals);
		loot.sort();
	},
	function retainUnclaimed( _state )
	{
		if (!this.canReward(_state)) return;
		if (this.Pending == null) this.Pending = this.stash();
		local loot = _state.m.CombatResultLoot;
		foreach (item in clone loot.getItems())
			if (item != null && item.getFlags().get("BVEnemyRewardGuaranteed") == true)
			{
				loot.remove(item);
				this.Pending.add(item);
			}
	},
	function deliverPending()
	{
		if (this.Pending == null || this.Pending.isEmpty()) return;
		local stash = ::World.Assets.getStash();
		foreach (item in clone this.Pending.getItems())
		{
			if (item == null) continue;
			if (stash.add(item) == null) break;
			this.Pending.remove(item);
			item.getFlags().set("BVEnemyRewardGuaranteed", false);
		}
	},
	function serializeParty( _party, _out )
	{
		local live = [];
		foreach (r in this.partyRecords(_party))
		{
			local index = _party.getTroops().find(r.Troop);
			if (index == null) continue;
			live.push({ Index = index, Record = r });
		}
		_out.writeU16(live.len());
		foreach (entry in live)
		{
			local r = entry.Record;
			_out.writeU16(entry.Index); _out.writeI32(r.ID); _out.writeString(r.Key);
			_out.writeBool(r.Equipped); _out.writeBool(r.BagSecond); _out.writeBool(r.Eligible);
			_out.writeBool(r.Settled); _out.writeU8(r.Resurrections);
			// An item already in the player's inventory must not be serialized twice.
			foreach (i, item in r.Items.getItems())
				if (item != null && this.playerOwns(item)) r.Items.getItems()[i] = null;
			r.Items.onSerialize(_out);
		}
	},
	function deserializeParty( _party, _in )
	{
		_party.m.BVEnemyRewards <- [];
		if (_party.getFlags().get("BVEnemyRewardsVersion") != 1) return; // Old save has no trailing section.
		local count = _in.readU16();
		for (local i = 0; i < count; ++i)
		{
			local index = _in.readU16();
			local r = { ID = _in.readI32(), Key = _in.readString(), Equipped = _in.readBool(), BagSecond = _in.readBool(),
				Eligible = _in.readBool(), Settled = _in.readBool(), Resurrections = _in.readU8(), Dead = false, Troop = null, Items = this.stash() };
			r.Items.onDeserialize(_in); // Consume even if the host discarded an obsolete troop.
			if (index >= _party.getTroops().len()) continue;
			r.Troop = _party.getTroops()[index];
			if (r.Troop.Script != ::$bvvar{namespace}.getExpandedEnemyScript(r.Key)) continue;
			_party.m.BVEnemyRewards.push(r);
		}
	}
};
