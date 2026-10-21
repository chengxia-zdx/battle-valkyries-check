::$bvvar{namespace}.BountyCamps <- {
	function theme(id) { return id in ::$bvvar{namespace}.BountyCampThemes ? ::$bvvar{namespace}.BountyCampThemes[id] : null; },
	function troop(symbol)
	{
		local troops = ::Const.World.Spawn.Troops;
		return typeof troops == "table" && symbol in troops ? troops[symbol] : null;
	},
	function available(t)
	{
		if (t == null || (t.DLC != null && (!(t.DLC in ::Const.DLC) || !::Const.DLC[t.DLC]))) return false;
		if (!(t.Faction in ::Const.FactionType) || ::World.FactionManager.getFactionOfType(::Const.FactionType[t.Faction]) == null) return false;
		foreach (g in t.Groups) foreach (tier in ["t25", "t4", "t5"])
		{
			local d = ::$bvvar{namespace}.getExpandedEnemyDefinition(g + "_" + tier);
			if (d == null || this.troop(d.Troop) == null) return false;
		}
		foreach (s in t.Supports) if (this.troop(s) == null) return false;
		return true;
	},
	function championPool(t)
	{
		local pool = [];
		if (!::Const.DLC.Wildmen) return pool;
		foreach (symbol in t.Champions)
		{
			local source = this.troop(symbol);
			if (source != null && source.Variant > 0 && "NameList" in source && source.NameList.len() > 0) pool.push(symbol);
		}
		return pool;
	},
	function canOffer(t)
	{
		// Old beast camps remain loadable. New Wildmen bounties require real champions.
		return this.available(t) && (!::Const.DLC.Wildmen || this.championPool(t).len() > 0);
	},
	function offer(id)
	{
		// Persist only a theme quote here, never generate defenders from UI reads.
		if (::World == null || ::World.Flags == null || ::World.State == null || ::World.FactionManager == null) return null;
		local flags = ::World.Flags;
		local key = "$bvvar{modId}.bounty.camp.offer." + id;
		if (flags.has(key) && this.canOffer(this.theme(flags.get(key)))) return this.theme(flags.get(key));
		local biome = "north";
		local player = ::World.State.getPlayer();
		if (player != null)
		{
			local terrain = player.getTile().Type;
			foreach (name in ["Desert", "Oasis", "Steppe"])
				if (name in ::Const.World.TerrainType && terrain == ::Const.World.TerrainType[name]) biome = "desert";
		}
		local recentKey = "$bvvar{modId}.bounty.camp.recent";
		local recent = flags.has(recentKey) ? flags.get(recentKey) : "";
		local pool = [];
		foreach (themeID, t in ::$bvvar{namespace}.BountyCampThemes)
		{
			if (!this.canOffer(t) || (t.Biome != "any" && t.Biome != biome)) continue;
			// Wild/giant subthemes collectively should not drown out army themes.
			local weight = t.Supports.len() == 0 ? 1 : 3;
			if (recent == themeID) weight = 1;
			for (local i = 0; i < weight; ++i) pool.push(t);
		}
		if (pool.len() == 0) return null;
		local chosen = pool[::Math.rand(0, pool.len() - 1)];
		flags.set(key, chosen.ID);
		flags.set(recentKey, chosen.ID);
		return chosen;
	},
	function budgetTargets(budget, capacity, weights)
	{
		// A capped elite allocation only releases budget to T2.5/supports.
		// In particular, ranged T4 caps must never buy additional T5 units.
		local targets = { T5 = ::Math.min(budget * weights.T5, capacity.T5),
			T4 = ::Math.min(budget * weights.T4, capacity.T4) };
		targets.Other <- ::Math.min(capacity.Other, budget - targets.T5 - targets.T4);
		return targets;
	},
	function profile(count, t)
	{
		local ns = ::$bvvar{namespace};
		count = ns.getValkyrieBountyOwnedCountClamped(count);
		local stars = ns.getValkyrieBountyStars(count);
		local rule = ns.BountyCampRules[stars - 1];
		local weights = ns.BountyCampBudgetShares[stars - 1];
		local ratio = (count - rule.MinOwned).tofloat() / (rule.MaxOwned - rule.MinOwned);
		local interpolate = function(a, b) { return ::Math.floor(a + (b - a) * ratio + 0.5).tointeger(); };
		local result = { Stars = stars, Budget = (::Math.floor(interpolate(rule.MinBudget, rule.MaxBudget) * t.BudgetMult / 10.0) * 10).tointeger(),
			Size = 0, Champions = this.championPool(t).len() > 0 ? count : 0, T5 = 0, T4 = 0, Supports = 0 };
		local limit = t.Large ? 4 + (stars - 1) * 2 : interpolate(rule.MinSize, rule.MaxSize);
		// Champions never consume any of these three allocations or defender slots.
		local caps = { T5 = ::Math.min(rule.MaxT5, t.Large ? (stars == 3 ? 2 : 1) : limit),
			T4 = ::Math.min(rule.MaxT4, t.Large ? stars : t.T4Cap) };
		local targets = this.budgetTargets(result.Budget, { T5 = caps.T5 * t.Prices[2], T4 = caps.T4 * t.Prices[1], Other = result.Budget }, weights);
		local total = t.Prices[0]; // Keep at least one T2.5 member.
		result.Size = 1;
		foreach (tier in ["T5", "T4"])
		{
			if (caps[tier] == 0 || weights[tier] == 0) continue;
			local price = t.Prices[tier == "T5" ? 2 : 1];
			local reserveT4 = tier == "T5" && caps.T4 > 0 && weights.T4 > 0;
			local reserve = reserveT4 ? t.Prices[1] : 0;
			local slots = limit - result.Size - (reserveT4 ? 1 : 0);
			// Round once; an enabled tier keeps one core when affordable.
			local desired = ::Math.max(1, ::Math.floor(targets[tier] / price + 0.5).tointeger());
			result[tier] = ::Math.max(0, ::Math.min(caps[tier], ::Math.min(slots,
				::Math.min(desired, ((result.Budget - total - reserve) / price).tointeger()))));
			total += result[tier] * price; result.Size += result[tier];
		}
		// All remaining budget, including rounding/cap surplus, is lower-tier only.
		// Buy limited theme supports first, then T2.5. Never refill elite quotas.
		while (result.Supports < t.SupportCount && result.Size < limit)
		{
			local price = t.Supports[result.Supports % t.Supports.len()] == "Necromancer" ? 150 : 50;
			if (total + price > result.Budget) break;
			++result.Supports; ++result.Size; total += price;
		}
		while (result.Size < limit && total + t.Prices[0] <= result.Budget)
		{
			++result.Size; total += t.Prices[0];
		}
		result.Size += result.Champions; // Hub/saves report the complete encounter.
		return result;
	},
	function summary(size, t4, t5, champions = 0)
	{
		return "$bv{bounty.camp.size}" + size + " / $bv{bounty.camp.champions}" + champions + " / T5: " + t5 + " / T4: " + t4;
	},
	function plan(t, count)
	{
		local p = this.profile(count, t);
		local entries = [];
		local spent = 0;
		local ranged = 0;
		local add = function(key, symbol, tier, price) {
			if (spent + price > p.Budget || entries.len() >= p.Size) return false;
			entries.push({ Key = key, Symbol = symbol, Tier = tier, Price = price }); spent += price;
			return true;
		};
		local pool = this.championPool(t);
		for (local i = 0; i < p.Champions; ++i)
			add(null, pool[::Math.rand(0, pool.len() - 1)], "champion", 0);
		foreach (tier in ["t5", "t4", "t25"])
		{
			local target = tier == "t5" ? p.T5 : (tier == "t4" ? p.T4 : p.Size - p.Supports - entries.len());
			local price = t.Prices[tier == "t5" ? 2 : (tier == "t4" ? 1 : 0)];
			for (local i = 0; i < target; ++i)
			{
				local groups = [];
				foreach (g in t.Groups) if (!(g == "bounty_hunters" && tier == "t4" && ranged >= 3)) groups.push(g);
				local group = groups[::Math.rand(0, groups.len() - 1)];
				if (!add(group + "_" + tier, null, tier, price)) break;
				if (group == "bounty_hunters" && tier == "t4") ++ranged;
			}
		}
		for (local i = 0; i < p.Supports; ++i)
		{
			local symbol = t.Supports[i % t.Supports.len()];
			add(null, symbol, "support", symbol == "Necromancer" ? 150 : 50);
		}
		return { Entries = entries, Spent = spent, Budget = p.Budget, Size = p.Size };
	},
	function populate(camp, t, count)
	{
		local ns = ::$bvvar{namespace};
		local plan = this.plan(t, count);
		if (camp.getTroops().len() != 0) throw "[Battle Valkyries] Refusing to regenerate bounty camp";
		foreach (e in plan.Entries)
		{
			local def = e.Key == null ? null : ns.getExpandedEnemyDefinition(e.Key);
			local source = this.troop(def == null ? e.Symbol : def.Troop);
			// Keep host ID/row, but never forward unrelated outfits or callbacks to a custom actor.
			local type = { ID = source.ID, Row = source.Row, Strength = e.Price, Cost = e.Price,
				Script = def == null ? source.Script : ns.getExpandedEnemyScript(e.Key), Variant = 0 };
			if (def != null && e.Key in ns.BountyCampRows) type.Row = ns.BountyCampRows[e.Key];
			local champion = e.Tier == "champion";
			if (champion)
			{
				type = clone source;
				type.Variant = 1000;
				if ("DieRoll" in type) type.DieRoll = 100;
			}
			local added = ::Const.World.Common.addTroop(camp, { Type = type }, false, champion ? 100 : -1000);
			if (champion && added.Variant == 0) throw "[Battle Valkyries] Host failed to create guaranteed bounty champion";
			if (def != null) added.Name = def.Name;
			if (!champion) added.Variant = 0;
			// Native champions retain host strength/cost and miniboss scaling.
			// Their strength is not charged to the dedicated defender budget.
			if (!champion) added.Strength = e.Price;
		}
		camp.setResources(plan.Spent);
		camp.getFlags().set("BVBountyCampSpent", plan.Spent);
		camp.getFlags().set("BVEnemySpawnVersion", 1);
		camp.updateStrength();
		return plan;
	}
};
