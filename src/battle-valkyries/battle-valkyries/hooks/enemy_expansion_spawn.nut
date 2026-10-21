// Registered in VeryLate after Legends has installed its replacements.
local ns = ::$bvvar{namespace};
local service = ns.EnemySpawn;

ns.MH.hook("scripts/contracts/contract", function(q) {
	q.getScaledDifficultyMult = @(__original) function()
	{
		local n = ::$bvvar{namespace};
		// Supported encounters scale at generation, never a second time here.
		return __original() * (n.EnemySpawn.isSupportedContract(this) ? 1.0 : n.getValkyrieEnemyBudgetMult("contract"));
	}
	q.getMinibossModifier = @(__original) function()
	{
		local value = __original();
		local n = ::$bvvar{namespace};
		return value < 0 || n.EnemySpawn.isSupportedContract(this) ? value : value + n.getValkyrieEnemyMinibossBonus("contract");
	}
	// Clearing contracts rebuild camp guards through this method, which calls
	// addTroop directly in both vanilla and Legends, bypassing Common.assignTroops.
	q.addUnitsToEntity = @(__original) function( _entity, _partyList, _resources )
	{
		local s = ::$bvvar{namespace}.EnemySpawn;
		if (s.GenerationDepth != 0 || !s.isSupportedContract(this) || !s.hostile(_entity.getFaction())
			|| _entity.getFlags().has("BVBountyCamp")
			|| (_entity.isLocation() && _entity.isLocationType(::Const.World.LocationType.Unique)))
			return __original(_entity, _partyList, _resources);
		return s.withContract(this, function( entity, list, resources )
		{
			local spawn = ::$bvvar{namespace}.EnemySpawn;
			local template = spawn.templateName(list);
			local plan = spawn.makePlan(resources, "contract", template, template != null);
			local survivors = clone entity.getTroops();
			local start = survivors.len();
			++spawn.GenerationDepth;
			local result;
			try { result = __original(entity, list, plan.Native); }
			catch (e) { --spawn.GenerationDepth; throw e; }
			--spawn.GenerationDepth;
			// A previously generated camp may have just been cleared by the host
			// contract. Its old version flag must not suppress this fresh allocation.
			spawn.apply(entity.getTroops(), start, plan, entity, survivors);
			if (this.m.Flags.get("BVTestBanditContract"))
			{
				local counts = { t25 = 0, t4 = 0, t5 = 0 };
				for (local i = start; i < entity.getTroops().len(); ++i)
				{
					local key = spawn.customKey(entity.getTroops()[i]);
					if (key != null) ++counts[::$bvvar{namespace}.getExpandedEnemyDefinition(key).Tier];
				}
				::logInfo("[Battle Valkyries] Test contract defenders: day=" + plan.Day + ", scene=" + plan.Scene
					+ ", enabled=" + plan.Enabled + ", base=" + plan.Base + ", native=" + plan.Native + ", quality=" + plan.Quality
					+ ", troops=" + (entity.getTroops().len() - start) + ", t25=" + counts.t25 + ", t4=" + counts.t4 + ", t5=" + counts.t5);
			}
			return result;
		}, [this, _entity, _partyList, _resources]);
	}
	// These are the base dispatchers which execute state/screen callbacks.
	// An active contract alone is NOT a spawn context: unrelated world patrols
	// must never inherit its stars or consume its wave allocation.
	foreach (method in ["update", "start", "setHome", "setOrigin", "setState", "setScreen", "processInput",
		"onActorKilled", "onActorRetreated", "onRetreatedFromCombat", "onCombatVictory", "onPartyDestroyed", "onLocationDestroyed"])
	{
		q[method] = @(__original) function(...)
		{
			local args = [this]; args.extend(vargv);
			return ::$bvvar{namespace}.EnemySpawn.withContract(this, __original, args);
		};
	}
});

ns.MH.hook("scripts/factions/faction", function(q) {
	q.spawnEntity = @(__original) function( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
	{
		local s = ::$bvvar{namespace}.EnemySpawn;
		++s.WorldSpawnDepth;
		local result;
		try { result = __original(_tile, _name, _uniqueName, _template, _resources, _minibossify); }
		catch (e) { --s.WorldSpawnDepth; throw e; }
		--s.WorldSpawnDepth;
		return result;
	}
});

// Some faction actions create an empty party first and assign its troops only
// after spawnEntity returns. Keep that actual generation inside the same scope.
ns.MH.hook("scripts/factions/faction_action", function(q) {
	q.execute = @(__original) function( _isNewCampaign = false )
	{
		local s = ::$bvvar{namespace}.EnemySpawn;
		++s.WorldSpawnDepth;
		local result;
		try { result = __original(_isNewCampaign); }
		catch (e) { --s.WorldSpawnDepth; throw e; }
		--s.WorldSpawnDepth;
		return result;
	}
});

// Common is a global configuration table, not a BB class. Modern Hooks class
// wrappers cannot target it; capture the final host implementation here and
// delegate once, preserving dynamic recipes and addTroop callbacks in Legends.
local assignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = function( _party, _partyList, _resources, _minibossify = 0, _weightMode = 1 )
{
	local s = ::$bvvar{namespace}.EnemySpawn;
	if (_party.getFlags().has("BVBountyCamp") || s.GenerationDepth != 0 || !s.hostile(_party.getFaction())
		|| (s.WorldSpawnDepth == 0 && s.Contract == null)
		|| (s.Contract != null && !s.isSupportedContract(s.Contract))
		|| _party.getFlags().has("BVEnemySpawnVersion"))
		return assignTroops.call(this, _party, _partyList, _resources, _minibossify, _weightMode);
	local template = s.templateName(_partyList);
	local plan = s.makePlan(_resources, "roamer", template, template != null);
	local start = _party.getTroops().len();
	++s.GenerationDepth;
	local result;
	try { result = assignTroops.call(this, _party, _partyList, plan.Native, _minibossify < 0 ? _minibossify : _minibossify + plan.ExtraChampions, _weightMode); }
	catch (e) { --s.GenerationDepth; throw e; }
	--s.GenerationDepth;
	s.apply(_party.getTroops(), start, plan, _party);
	return result;
};

local addUnitsToCombat = ::Const.World.Common.addUnitsToCombat;
::Const.World.Common.addUnitsToCombat = function( _into, _partyList, _resources, _faction, _minibossify = 0 )
{
	local s = ::$bvvar{namespace}.EnemySpawn;
	if (s.GenerationDepth != 0 || !s.isSupportedContract(s.Contract) || !s.hostile(_faction))
		return addUnitsToCombat.call(this, _into, _partyList, _resources, _faction, _minibossify);
	local template = s.templateName(_partyList);
	local plan = s.makePlan(_resources, "contract", template, template != null);
	local start = _into.len();
	++s.GenerationDepth;
	local result;
	try { result = addUnitsToCombat.call(this, _into, _partyList, plan.Native, _faction, _minibossify < 0 ? _minibossify : _minibossify + plan.ExtraChampions); }
	catch (e) { --s.GenerationDepth; throw e; }
	--s.GenerationDepth;
	s.apply(_into, start, plan);
	return result;
};

// Legends exposes an explicit hostile entry point, including temporary wars.
// Its own implementation remains responsible for the final faction assignment.
if ("addHostileUnitsToCombat" in ::Const.World.Common)
{
	local addHostile = ::Const.World.Common.addHostileUnitsToCombat;
	::Const.World.Common.addHostileUnitsToCombat = function( _into, _partyList, _resources, _faction, _minibossify = 0 )
	{
		local s = ::$bvvar{namespace}.EnemySpawn;
		local previous = s.ForceHostile; s.ForceHostile = true;
		local result;
		try { result = addHostile.call(this, _into, _partyList, _resources, _faction, _minibossify); }
		catch (e) { s.ForceHostile = previous; throw e; }
		s.ForceHostile = previous;
		return result;
	};
}

ns.MH.hook("scripts/entity/world/location", function(q) {
	q.createDefenders = @(__original) function()
	{
		local s = ::$bvvar{namespace}.EnemySpawn;
		if (this.getFlags().has("BVBountyCamp") || s.GenerationDepth != 0 || this.isAlliedWithPlayer() || this.m.Resources <= 0
			|| this.isLocationType(::Const.World.LocationType.Unique)
			|| (s.Contract != null && !s.isSupportedContract(s.Contract))) return __original();
		local template = s.templateName(this.m.DefenderSpawnList);
		local originalResources = this.m.Resources;
		local effective = originalResources;
		if (this.m.IsScalingDefenders) effective *= ::Math.minf(3.0, 1.0 + ::World.getTime().Days * 0.0075);
		effective *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		if (::Time.getVirtualTimeF() - this.m.LastSpawnTime <= 60.0) effective *= 0.75;
		local plan = s.makePlan(effective, "location", template, template != null);
		local oldTroops = clone this.getTroops();
		this.m.Resources = originalResources * plan.Native / effective;
		++s.GenerationDepth;
		local result;
		try { result = __original(); }
		catch (e) { this.m.Resources = originalResources; --s.GenerationDepth; throw e; }
		this.m.Resources = originalResources;
		--s.GenerationDepth;
		// A host can rebuild the list or append reinforcements. Only new object
		// references belong to this allocation; survivors are never rerolled.
		local fresh = []; local slots = []; local survivors = [];
		foreach (i, troop in this.getTroops())
			if (oldTroops.find(troop) == null) { fresh.push(troop); slots.push(i); }
			else survivors.push(troop);
		if (fresh.len() != 0)
		{
			s.apply(fresh, 0, plan, null, survivors);
			foreach (i, troop in fresh) this.m.Troops[slots[i]] = troop;
			this.getFlags().set("BVEnemySpawnVersion", s.config().Version);
			this.getFlags().set("BVEnemySpawnDay", plan.Day);
			this.getFlags().set("BVEnemySpawnScene", plan.Scene);
			this.updateStrength();
		}
		return result;
	}
});

ns.MH.hook("scripts/entity/world/world_entity", function(q) {
	q.getTroopComposition = @(__original) function()
	{
		local s = ::$bvvar{namespace}.EnemySpawn;
		local troops = this.m.Troops;
		local ordinary = []; local groups = {};
		foreach (troop in troops)
		{
			local key = s.customKey(troop);
			if (key == null) { ordinary.push(troop); continue; }
			if (!(key in groups)) groups[key] <- { Troop = troop, Count = 0 };
			++groups[key].Count;
		}
		if (groups.len() == 0) return __original();
		// Keep the host's formatting and intelligence rules for ordinary troops.
		this.m.Troops = ordinary;
		local result;
		try { result = __original(); }
		catch (e) { this.m.Troops = troops; throw e; }
		this.m.Troops = troops;
		foreach (key, group in groups)
		{
			local def = ::$bvvar{namespace}.getExpandedEnemyDefinition(key);
			local number = "";
			if (group.Count > 1)
			{
				if ("Legends" in getroottable() && "getEngageNumberNames" in this)
					number = ::Legends.Mod.ModSettings.getSetting("ExactEngageNumbers").getValue() ? group.Count.tostring() : this.getEngageNumberNames(group.Count);
				else if ("Strings" in ::Const && "EngageEnemyNumbers" in ::Const.Strings)
				{
					local names = ::Const.Strings.EngageEnemyNumbers;
					local index = (::Math.minf(1.0, group.Count / 14.0) * (names.len() - 1)).tointeger();
					if (typeof names[index] == "string") number = names[index];
				}
			}
			result.push({ id = 20, type = "text", icon = "ui/orientation/" + ::Const.EntityIcon[group.Troop.ID] + ".png",
				text = (number == null || number == "" ? "" : number + " ") + def.Name });
		}
		return result;
	}
});

// Preserve fixed custom loadouts through Legends' post-equipment dual-wield roll.
if ("Legends" in getroottable()) ns.MH.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	if (q.contains("isAllowedToDualWield", true)) q.isAllowedToDualWield = @(__original) function( _entity )
	{
		if (_entity.getFlags().has("BVExpandedEnemyEquipmentAssigned")) return false;
		return __original(_entity);
	}
});
