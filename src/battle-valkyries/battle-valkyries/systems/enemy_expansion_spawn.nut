// Generation-only service. No actor hooks, global spawn-table edits or custom
// Troop serialization. The host still selects every ordinary member.
::$bvvar{namespace}.EnemySpawn <- {
	Contract = null,
	WorldSpawnDepth = 0,
	GenerationDepth = 0,
	ForceHostile = false,
	Warned = {},
	function config() { return ::$bvvar{namespace}.ExpandedEnemySpawnConfig; },
	function warn( _reason )
	{
		if (_reason in this.Warned) return;
		this.Warned[_reason] <- true;
		::logWarning("[Battle Valkyries] Enemy generation skipped: " + _reason);
	},
	function isSupportedContract( _contract )
	{
		if (_contract == null) return false;
		local type = _contract.getType();
		return type.find("contract.") == 0 && this.config().Contracts.find(type.slice(9)) != null;
	},
	function templateName( _template )
	{
		foreach (key in this.config().Templates)
			if (key in ::Const.World.Spawn && ::Const.World.Spawn[key] == _template) return key;
		return null;
	},
	function withContract( _contract, _original, _args )
	{
		local previous = this.Contract;
		this.Contract = _contract;
		local result;
		try { result = _original.acall(_args); }
		catch (e) { this.Contract = previous; throw e; }
		this.Contract = previous;
		return result;
	},
	function hostile( _faction )
	{
		if (_faction == ::Const.Faction.Player || _faction == ::Const.Faction.PlayerAnimals) return false;
		if (this.ForceHostile && this.isSupportedContract(this.Contract)) return true;
		try { return !::World.FactionManager.isAlliedWithPlayer(_faction); }
		catch (e) { return false; }
	},
	function qualityShare( _day ) { return _day <= 10 ? 0.0 : (_day <= 20 ? 0.35 : (_day <= 30 ? 0.50 : 0.60)); },
	function templateCosts( _name )
	{
		if (_name == null || !(_name in ::Const.World.Spawn)) return null;
		local template = ::Const.World.Spawn[_name];
		if (typeof template != "table") return null;
		if (!("Name" in template)) return {};
		// Legends buys with the recipe entry's Cost, which can differ from
		// Type.Cost. Conflicting prices for one script are deliberately unknown.
		local prices = {};
		local visit = null;
		visit = function(node)
		{
			if (typeof node == "array") { foreach (item in node) visit(item); return; }
			if (typeof node != "table") return;
			if ("Type" in node && typeof node.Type == "table" && "Script" in node.Type)
			{
				local key = node.Type.Script;
				local cost = "Cost" in node && (typeof node.Cost == "integer" || typeof node.Cost == "float") ? node.Cost : null;
				if (!(key in prices)) prices[key] <- cost;
				else if (prices[key] != cost) prices[key] = null;
			}
			foreach (field in ["Fixed", "Troops", "Types", "SortedTypes", "Guards"])
				if (field in node) visit(node[field]);
		};
		visit(template);
		return prices;
	},
	function scene( _mode, _template, _budget )
	{
		if (this.Contract != null)
		{
			local d = this.Contract.getDifficultyMult();
			return d < 0.9 ? "one" : (d <= 1.1 ? "two" : "hard");
		}
		// Native effective budget thresholds, before any Valkyrie multiplier.
		if (_mode == "location") return _budget >= 600 ? "hard" : "elite";
		return this.config().EliteTemplates.find(_template) != null ? "elite" : "ordinary";
	},
	function makePlan( _budget, _mode, _template, _supported )
	{
		local ns = ::$bvvar{namespace};
		local flags = this.Contract == null ? null : this.Contract.m.Flags;
		local day = ::World.getTime().Days;
		local mult = ns.getValkyrieEnemyBudgetMult(this.Contract == null ? _mode : "contract");
		local scene = this.scene(_mode, _template, _budget);
		// Only actual hostile generation freezes a contract. Difficulty/payment
		// getters never write flags or consume random numbers.
		if (_supported && flags != null)
		{
			if (flags.has("BVSpawnDay"))
			{
				day = flags.get("BVSpawnDay");
				mult = flags.get("BVSpawnMult");
				scene = flags.get("BVSpawnScene");
			}
			else
			{
				flags.set("BVSpawnVersion", this.config().Version);
				flags.set("BVSpawnDay", day);
				flags.set("BVSpawnMult", mult);
				flags.set("BVSpawnScene", scene);
			}
		}
		local q = _supported ? this.qualityShare(day) : 0.0;
		local delta = ::Math.maxf(0.0, _budget * (mult - 1.0));
		local plan = {
			Day = day, Scene = scene, Enabled = _supported && mult > 1.0 && q > 0.0,
			Base = _budget, Total = _budget + delta, Native = _budget + (1.0 - q) * delta,
			Quality = q * delta, Flags = _supported ? flags : null, Repeat = false,
			Costs = this.templateCosts(_template),
			ExtraChampions = q > 0.0 ? 0 : ns.getValkyrieEnemyMinibossBonus(this.Contract == null ? "world" : "contract")
		};
		if (plan.Flags != null && flags.has("BVSpawnBudget"))
		{
			// All later waves share the first batch's remaining quality allocation
			// and quotas. They do not receive another full scaling allocation.
			plan.Repeat = true;
			plan.Quality = flags.get("BVSpawnBudget");
			plan.Native = _budget;
			plan.Total = _budget + plan.Quality;
		}
		return plan;
	},
	function limits( _plan, _count )
	{
		local s = _plan.Scene;
		// Whole encounter quotas; the existing flag ledger shares these across waves.
		local t4 = s == "hard" ? 3 : 2;
		local result = { t25 = ::Math.max(1, (_count * 0.10).tointeger()),
			t4 = ::Math.min(t4, ::Math.max(1, (_count * t4 / 20.0).tointeger())),
			t5 = s == "elite" || s == "hard" ? 1 : 0 };
		if (_plan.Day <= 10) return { t25 = 0, t4 = 0, t5 = 0 };
		if (_plan.Day <= 20)
		{
			result.t4 = s == "elite" || s == "hard" ? 1 : 0;
			result.t5 = 0;
		}
		else if (_plan.Day <= 30) result.t5 = s == "hard" ? 1 : 0;
		if (s == "one") return { t25 = 1, t4 = 0, t5 = 0 };
		if (s == "two") result.t5 = 0;
		return result;
	},
	function chance( _scene ) { return _scene == "one" ? 20 : (_scene == "two" ? 40 : (_scene == "hard" ? 100 : (_scene == "elite" ? 85 : 60))); },
	function source( _troop, _tier )
	{
		foreach (entry in this.config().Sources)
		{
			local scripts = _tier == "t25" ? entry.Mid : (_tier == "t5" && "T5" in entry ? entry.T5 : entry.High);
			foreach (script in scripts)
				if (_troop.Script == "scripts/entity/tactical/" + script) return entry.Group;
		}
		return null;
	},
	function isNativeElite( _troop )
	{
		if (_troop.Variant != 0) return true;
		foreach (script in this.config().NativeElites)
			if (_troop.Script == "scripts/entity/tactical/" + script) return true;
		return false;
	},
	function safeMetadata( _troop )
	{
		if (_troop.Variant != 0 || ("Name" in _troop && _troop.Name != "")) return false;
		foreach (key in ["Callback", "Tag", "Outfits"])
			if (key in _troop && _troop[key] != null && _troop[key] != "") return false;
		foreach (key, value in _troop)
			if (["ID", "Variant", "Strength", "Cost", "Row", "Party", "Faction", "Tag", "Script", "Name", "NameList", "TitleList", "Callback", "Outfits", "Credits", "DieRoll"].find(key) == null) return false;
		return true;
	},
	function cost( _troop, _prices = null )
	{
		if (_prices != null) return _troop.Script in _prices ? _prices[_troop.Script] : null;
		if ("Cost" in _troop && typeof _troop.Cost != "null" && _troop.Cost >= 0) return _troop.Cost.tofloat();
		// Only initial generation is eligible. A missing/ambiguous host cost must
		// not be guessed from Strength (Legends uses different strength values).
		return null;
	},
	function flagCount( _flags, _key ) { return _flags != null && _flags.has(_key) ? _flags.get(_key) : 0; },
	function apply( _troops, _start, _plan, _owner = null, _survivors = null )
	{
		local ns = ::$bvvar{namespace};
		local flags = _plan.Flags;
		local count = _troops.len() - _start;
		if (count <= 0) return;
		local survivors = _survivors == null ? [] : _survivors;
		local limits = this.limits(_plan, count + survivors.len());
		local won = false;
		if (_plan.Repeat)
		{
			won = flags.get("BVSpawnWon");
			foreach (tier in ["t25", "t4", "t5"])
			{
				local consumed = 0;
				foreach (group in ns.ExpandedEnemyGroups)
					consumed += this.flagCount(flags, "BVSpawnUsed_" + group.ID + "_" + tier);
				// Old saves can contain the former 6/3 quota. Keep their survivors,
				// but never refill that obsolete allowance in a later wave.
				limits[tier] = ::Math.min(this.flagCount(flags, "BVSpawnLeft_" + tier), ::Math.max(0, limits[tier] - consumed));
			}
		}
		else won = _plan.Enabled && ::Math.rand(1, 100) <= this.chance(_plan.Scene);
		local budget = _plan.Quality;
		local totalCost = 0.0;
		local nativePressure = 0;
		local counts = {};
		local existing = {};
		foreach (t in survivors)
		{
			if (this.isNativeElite(t)) ++nativePressure;
			local key = this.customKey(t);
			if (key == null)
			{
				local group = this.source(t, "t4");
				if (group == null) group = this.source(t, "t25");
				if (group == null) group = this.source(t, "t5");
				if (group != null) { if (!(group in counts)) counts[group] <- 0; ++counts[group]; }
				continue;
			}
			local def = ns.getExpandedEnemyDefinition(key);
			local group = key.slice(0, key.len() - def.Tier.len() - 1);
			if (!(group in counts)) counts[group] <- 0;
			++counts[group];
			if (!(group in existing)) existing[group] <- { t25 = 0, t4 = 0, t5 = 0 };
			++existing[group][def.Tier];
			if (!_plan.Repeat) limits[def.Tier] = ::Math.max(0, limits[def.Tier] - 1);
		}
		for (local i = _start; i < _troops.len(); ++i)
		{
			local t = _troops[i];
			local c = this.cost(t, _plan.Costs);
			if (c == null) { if (won) this.warn("unknown host troop cost"); won = false; }
			else totalCost += c;
			if (this.isNativeElite(t)) ++nativePressure;
			local group = this.source(t, "t4");
			if (group == null) group = this.source(t, "t25");
			if (group == null) group = this.source(t, "t5");
			if (group != null) { if (!(group in counts)) counts[group] <- 0; ++counts[group]; }
		}
		budget = ::Math.minf(budget, ::Math.maxf(0.0, _plan.Total - totalCost));
		local largeCount = 0;
		local controlCount = 0;
		foreach (group, n in counts)
		{
			if (this.config().Large.find(group) != null) largeCount += n;
			if (this.config().Control.find(group) != null) controlCount += n;
		}
		// Large bodies and control cores use their own small-encounter quotas,
		// rather than disappearing due to human headcount rounding.
		if (!_plan.Repeat && _plan.Scene != "one" && (_plan.Day > 20 || (_plan.Day > 10 && (_plan.Scene == "elite" || _plan.Scene == "hard"))))
			limits.t4 = ::Math.max(limits.t4, ::Math.max(::Math.min(1, (largeCount * 0.5).tointeger()), controlCount > 0 ? 1 : 0));
		limits.t5 = ::Math.max(0, limits.t5 - nativePressure);
		local used = {};
		local largeUsed = this.flagCount(flags, "BVSpawnLargeUsed");
		local largeT4 = this.flagCount(flags, "BVSpawnLargeT4");
		local largeT5 = this.flagCount(flags, "BVSpawnLargeT5");
		local coreUsed = this.flagCount(flags, "BVSpawnCoreUsed");
		local existingLarge = 0; local existingLargeT4 = 0; local existingLargeT5 = 0; local existingCores = 0;
		foreach (group, u in existing)
		{
			if (this.config().Large.find(group) != null) { existingLarge += u.t25 + u.t4 + u.t5; existingLargeT4 += u.t4; existingLargeT5 += u.t5; }
			if (this.config().Control.find(group) != null) existingCores += u.t4 + u.t5;
		}
		largeUsed = ::Math.max(largeUsed, existingLarge); largeT4 = ::Math.max(largeT4, existingLargeT4); largeT5 = ::Math.max(largeT5, existingLargeT5); coreUsed = ::Math.max(coreUsed, existingCores);
		local changed = {};
		// High tiers get first access to their distinct slots; no slot can be
		// upgraded a second time, and cheaper replacements never refund points.
		if (won) foreach (tier in ["t5", "t4", "t25"])
		{
			local indices = [];
			for (local i = _start; i < _troops.len(); ++i) indices.push(i);
			// Shuffle within this one encounter, not one independent spawn roll per member.
			for (local i = indices.len() - 1; i > 0; --i) { local j = ::Math.rand(0, i); local v = indices[i]; indices[i] = indices[j]; indices[j] = v; }
			foreach (i in indices)
			{
				if (limits[tier] <= 0) break;
				local t = _troops[i];
				if (i in changed || this.isNativeElite(t) || !this.safeMetadata(t)) continue;
				local group = this.source(t, tier);
				if (group == null || !(group in counts)) continue;
				local large = this.config().Large.find(group) != null;
				local control = this.config().Control.find(group) != null;
				local beast = large || control || ["direwolves", "hyenas", "ghouls", "spiders", "serpents"].find(group) != null;
				if (!beast && count + survivors.len() < 6) continue;
				if (!(group in used)) used[group] <- { t25 = this.flagCount(flags, "BVSpawnUsed_" + group + "_t25"), t4 = this.flagCount(flags, "BVSpawnUsed_" + group + "_t4"), t5 = this.flagCount(flags, "BVSpawnUsed_" + group + "_t5") };
				local u = used[group];
				if (group in existing) foreach (k in ["t25", "t4", "t5"]) u[k] = ::Math.max(u[k], existing[group][k]);
				if (large && largeUsed >= ::Math.min(3, (largeCount * 0.5).tointeger())) continue;
				if (large && ((tier == "t4" && largeT4 >= 1) || (tier == "t5" && largeT5 >= 1))) continue;
				if (control && tier != "t25" && coreUsed >= 1) continue;
				if (large && (u.t25 + u.t4 + u.t5 >= ::Math.min(3, (counts[group] * 0.5).tointeger()) || (tier == "t4" && u.t4 >= 1) || (tier == "t5" && (counts[group] < 3 || u.t5 >= 1)))) continue;
				if (control && ((tier == "t25" && u.t25 >= 1) || (tier != "t25" && u.t4 + u.t5 >= 1) || (tier == "t5" && nativePressure > 0))) continue;
				if ((group == "spiders" || group == "serpents") && tier == "t5" && u.t5 >= 1) continue;
				local key = group + "_" + tier;
				local def = ns.getExpandedEnemyDefinition(key);
				if (def == null || !(def.Troop in ::Const.World.Spawn.Troops)) continue;
				local reference = ::Const.World.Spawn.Troops[def.Troop];
				if (!("Cost" in reference) || reference.Cost <= 0) continue;
				local metadataCheck = clone reference;
				metadataCheck.Variant = 0; metadataCheck.Name <- "";
				if (!this.safeMetadata(metadataCheck)) continue;
				local factor = tier == "t25" ? 0.9 : (tier == "t4" ? (large || control ? 1.6 : 2.0) : (large || control ? 2.2 : 3.2));
				local price = reference.Cost * factor;
				// T2.5 never weakens an existing high-tier member.
				local sourceCost = this.cost(t, _plan.Costs);
				if (tier == "t25" && sourceCost >= reference.Cost) continue;
				local extra = ::Math.maxf(0.0, price - sourceCost);
				if (extra > budget) continue;
				local replacement = clone reference;
				replacement.Script = ns.getExpandedEnemyScript(key);
				replacement.Name <- def.Name;
				replacement.Variant = 0;
				replacement.Cost = price;
				replacement.Strength = reference.Strength * factor;
				foreach (field in ["Faction", "Party", "Credits"])
					if (field in t) replacement[field] <- t[field];
				if ("DieRoll" in t) replacement.DieRoll <- 100;
				_troops[i] = replacement;
				changed[i] <- true;
				if (large) ++largeUsed;
				if (large && tier == "t4") ++largeT4;
				if (large && tier == "t5") ++largeT5;
				if (control && tier != "t25") ++coreUsed;
				++u[tier]; --limits[tier]; budget -= extra;
			}
		}
		if (flags != null)
		{
			flags.set("BVSpawnBudget", budget);
			flags.set("BVSpawnWon", won);
			flags.set("BVSpawnLargeUsed", largeUsed);
			flags.set("BVSpawnLargeT4", largeT4);
			flags.set("BVSpawnLargeT5", largeT5);
			flags.set("BVSpawnCoreUsed", coreUsed);
			foreach (tier in ["t25", "t4", "t5"]) flags.set("BVSpawnLeft_" + tier, limits[tier]);
			foreach (group, u in used) foreach (tier in ["t25", "t4", "t5"]) flags.set("BVSpawnUsed_" + group + "_" + tier, u[tier]);
		}
		if (_owner != null)
		{
			_owner.getFlags().set("BVEnemySpawnVersion", this.config().Version);
			_owner.getFlags().set("BVEnemySpawnDay", _plan.Day);
			_owner.getFlags().set("BVEnemySpawnScene", _plan.Scene);
			_owner.updateStrength();
		}
	},
	function customKey( _troop )
	{
		local prefix = "scripts/entity/tactical/enemies/battle_valkyries/bv_enemy_";
		if (_troop.Script.find(prefix) != 0) return null;
		local key = _troop.Script.slice(prefix.len());
		return ::$bvvar{namespace}.getExpandedEnemyDefinition(key) == null ? null : key;
	}
};
