// Each cycle keeps a victory amount and delivery ledger. Daily Shu rice is separate.
::$bvvar{namespace}.ShuGranary <- {
	ID = "shu_granary", Busy = false,
	function api() { return ::$bvvar{namespace}; },
	function chapters() { return this.api().Chapters; },
	function definition() { return this.chapters().definition(this.ID); },
	function read(key, fallback = 0) { return this.chapters().read(this.ID, key, fallback); },
	function write(key, value) { this.chapters().write(this.ID, key, value); },
	function now() { return ::Time.getVirtualTimeF(); },
	function cycle() { return this.read("cycle"); },
	function hasShu()
	{
		foreach (a in ::World.getPlayerRoster().getAll())
			if (a != null && a.isPlayerControlled() && !this.api().isActorDeadOrDying(a) && this.api().getActorValkyrieID(a) == "shu") return true;
		return false;
	},
	function difficulty(id) { foreach (d in this.definition().Difficulties) if (d.ID == id) return d; return null; },
	function budget()
	{
		local terrain = ::Const.World.TerrainFoodConsumption[::World.State.getPlayer().getTile().Type];
		local food = ::World.Assets.getDailyFoodCost(), mult = ::World.Assets.m.FoodConsumptionMult * ::Const.World.Assets.FoodConsumptionMult;
		return { Actual = food * mult * terrain, Budget = food * mult * ::Math.maxf(terrain, 1.5) };
	},
	function amount(d, budget) { return ::Math.max(d.Minimum, ::Math.ceil(budget * d.Days).tointeger()); },
	function remaining() { return ::Math.maxf(0.0, this.read("next_at", 0.0) - this.now()); },
	function canStart(id) { return !this.Busy && this.hasShu() && this.read("active") != 1 && this.remaining() <= 0; },
	function start(id) { return this.begin("easy", this.cycle()); },
	function stage(id) { return this.read("active") == 1 ? this.definition().Stages[0] : null; },
	function transaction(changes)
	{
		local before = [];
		try { foreach (change in changes) { before.push([change[0], this.read(change[0])]); this.write(change[0], change[1]); } }
		catch (e) { foreach (change in before) this.write(change[0], change[1]); throw e; }
	},
	function begin(level, expectedCycle)
	{
		if (expectedCycle != this.cycle()) return this.chapters().error("stale");
		if (!this.canStart(this.ID)) return this.chapters().error("locked");
		if (this.difficulty(level) == null) return this.chapters().error("invalid");
		local first = this.read("started") != 1;
		this.transaction([["schema", 1], ["started", 1], ["difficulty", level], ["entered", 0], ["locked_rice", 0], ["node_id", -1], ["cycle", this.cycle() + 1], ["active", 1]]);
		this.ensureLocations(this.ID);
		return { Success = true, Chapter = this.dto(this.ID), Scene = this.chapters().scene(this.ID, first ? "opening" : (this.read("completed") == 1 ? "repeat" : "guard")) };
	},
	function findLocation(id, node)
	{
		if (node != "granary" || this.read("active") != 1) return null;
		foreach (loc in ::World.EntityManager.getLocations())
			if (loc != null && loc.getID() == this.read("node_id", -1) && loc.getFlags().get("BVChapterCycle") == this.cycle()
				&& this.chapters().isUsableLocation(loc, id, node)) return loc;
		return null;
	},
	function cleanupLocations(id)
	{
		local remove = [];
		foreach (loc in ::World.EntityManager.getLocations())
			if (loc != null && loc.isAlive() && loc.getFlags().get("BVChapterID") == id
				&& (this.read("active") != 1 || loc.getID() != this.read("node_id", -1) || loc.getFlags().get("BVChapterCycle") != this.cycle())) remove.push(loc);
		foreach (loc in remove) loc.die();
	},
	function ensureLocations(id)
	{
		this.cleanupLocations(id);
		if (this.read("active") != 1 || this.findLocation(id, "granary") != null) return;
		// Never rebuild an entered camp: survivors and casualties belong to its saved instance.
		if (this.read("entered") == 1) return;
		local tile = this.chapters().spawnTile(id); if (tile == null) return;
		local loc = null;
		try {
			loc = ::World.spawnLocation(this.definition().LocationScript, tile.Coords);
			if (loc == null) throw "No granary location";
			loc.getFlags().set("BVChapterID", id); loc.getFlags().set("BVChapterNode", "granary");
			loc.getFlags().set("BVChapterCycle", this.cycle()); loc.getFlags().set("BVGranaryDifficulty", this.read("difficulty", "easy"));
			this.write("node_id", loc.getID()); loc.configure(); loc.onSpawned(); this.chapters().reveal(loc);
		} catch (e) { if (loc != null && loc.isAlive()) loc.die(); this.write("node_id", -1); ::logWarning("[Battle Valkyries] Granary placement deferred: " + e); }
	},
	function enter(loc)
	{
		if (this.read("active") != 1 || loc.getID() != this.read("node_id", -1) || loc.getFlags().get("BVChapterCycle") != this.cycle()) return false;
		if (this.read("entered") != 1)
		{
			if (!this.hasShu()) return false;
			this.transaction([["locked_rice", this.amount(this.difficulty(this.read("difficulty", "easy")), this.budget().Budget)], ["entered", 1]]);
		}
		loc.getFlags().set("BVGranaryCombatID", ::World.Statistics.getFlags().getAsInt("LastCombatID"));
		return true;
	},
	function battleWon(id, node)
	{
		if (node != "granary" || this.read("active") != 1 || this.read("entered") != 1) return;
		local loc = null;
		foreach (entry in ::World.EntityManager.getLocations()) if (entry != null && entry.getID() == this.read("node_id", -1)) loc = entry;
		if (loc == null || !loc.isAlive() || loc.getFlags().get("BVChapterCycle") != this.cycle() || loc.getTroops().len() != 0) return;
		local f = ::World.Statistics.getFlags(), before = loc.getFlags().get("BVGranaryCombatID");
		if (typeof before != "integer" || f.getAsInt("LastCombatID") != before + 1 || f.get("LastCombatResult") != 1) return;
		local rice = this.read("locked_rice"); if (rice <= 0 || this.read("win." + this.cycle()) > 0) return;
		this.transaction([["win." + this.cycle(), rice], ["next_at", this.now() + 3.0 * ::World.getTime().SecondsPerDay], ["completed", 1], ["active", 0]]);
	},
	function pending()
	{
		local total = 0; for (local i = 1; i <= this.cycle(); ++i) total += this.read("win." + i) - this.read("delivered." + i);
		return total;
	},
	function claim()
	{
		if (this.Busy) return this.chapters().error("stale");
		if (this.pending() <= 0) return this.chapters().error("incomplete");
		this.Busy = true; local stash = ::World.Assets.getStash(), delivered = false;
		for (local i = 1; i <= this.cycle(); ++i)
		{
			local amount = this.read("win." + i) - this.read("delivered." + i); if (amount <= 0) continue;
			if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) break;
			local item = null, added = false;
			try {
				item = ::new("scripts/items/supplies/battle_valkyries/shu_rice_item"); item.setAmount(amount);
				item.m.BestBefore = this.now() + 10.0 * ::World.getTime().SecondsPerDay;
				if (stash.add(item) == null) break;
				added = true; this.write("delivered." + i, this.read("win." + i)); delivered = true;
			} catch (e) { if (added) stash.remove(item); ::logWarning("[Battle Valkyries] Granary rice delivery deferred: " + e); break; }
		}
		this.Busy = false;
		if (!delivered) return this.chapters().error("stash");
		::World.Assets.updateFood(); try { ::World.State.updateTopbarAssets(); } catch (e) {}
		local first = this.read("ending_seen") != 1; this.write("ending_seen", 1);
		return { Success = true, Chapter = this.dto(this.ID), Scene = this.chapters().scene(this.ID, first ? "ending" : "delivery") };
	},
	function syncRewards(id) {},
	function gallery(id)
	{
		local out = [], unlocked = this.read("completed") == 1;
		foreach (cg in this.definition().Gallery) out.push({ID=cg.ID,Stage=1,Unlocked=unlocked,Title=unlocked?cg.Title:"$bv{chapter.cg.ui.locked}",Caption=unlocked?cg.Caption:"",Image=unlocked?cg.Image:""});
		return out;
	},
	function dto(id)
	{
		local d = this.definition(), budget = this.budget(), owned = this.hasShu(), active = this.read("active") == 1, entered = this.read("entered") == 1;
		local choices = [], pending = this.pending(), first = this.read("completed") == 1;
		foreach (level in d.Difficulties)
		{
			local enemies = 0; foreach (entry in level.Troops) enemies += entry[1];
			local rice = this.amount(level, budget.Budget);
			choices.push({ID=level.ID,Name=level.Name,Enemies=enemies,Rice=rice,FoodDays=budget.Actual>0?rice/budget.Actual:0.0});
		}
		return { ID=id,Name=d.Name,Description=d.Description,Poster=d.Poster,Repeatable=true,Started=this.read("started")==1,Finished=false,
			Completed=first?1:0,Total=1,Stage=1,StageName=d.Stages[0].Name,Brief=d.Stages[0].Brief,Goals=[],Materials=[],Requirements=[{Name=this.api().Valkyries.shu.Name,Met=owned}],
			CanStart=this.canStart(id),CanSubmit=false,Money=0,Tools=0,Medicine=0,PerksEach=0,Special="",PendingWeapon=false,PendingSkin=false,
			Opening=this.read("started")==1?this.chapters().scene(id,"opening"):null,GuardScene=this.read("started")==1?this.chapters().scene(id,"guard"):null,
			Gallery=this.gallery(id),Stages=[{Number=1,Name=d.Stages[0].Name,Complete=first,Current=active,Scene=first?this.chapters().scene(id,"ending"):null}],
			Cycle=this.cycle(),Active=active,Entered=entered,SelectedDifficulty=this.read("difficulty",""),LockedRice=entered&&active?this.read("locked_rice"):0,
			DailyFood=budget.Actual,BudgetFood=budget.Budget,RemainingHours=this.remaining()/::World.getTime().SecondsPerDay*24.0,
			Difficulties=choices,PendingRice=pending,CanClaim=pending>0&&( ::World.Assets.getStash().isResizable()||::World.Assets.getStash().getNumberOfEmptySlots()>0),
			CanChangeDifficulty=active&&!entered&&owned,CanCancel=active,CanFocus=this.findLocation(id,"granary")!=null,MissingLocation=active&&entered&&this.findLocation(id,"granary")==null };
	},
	function request(data)
	{
		if (::World == null || ::World.State == null || ::World.Assets == null || typeof data != "table" || !("Action" in data)) return this.chapters().error("invalid");
		if (data.Action == "refresh") { this.ensureLocations(this.ID); return {Success=true,Chapter=this.dto(this.ID)}; }
		if (!("Cycle" in data) || typeof data.Cycle != "integer" || data.Cycle != this.cycle()) return this.chapters().error("stale");
		if (data.Action == "begin" && "Difficulty" in data && typeof data.Difficulty == "string") return this.begin(data.Difficulty, data.Cycle);
		if (data.Action == "claim") return this.claim();
		if (data.Action == "focus") return this.chapters().focus(this.ID,"granary");
		if (data.Action == "cancel" && this.read("active") == 1) { this.write("active",0);this.cleanupLocations(this.ID);return {Success=true,Chapter=this.dto(this.ID)}; }
		if (data.Action == "difficulty" && "Difficulty" in data && this.read("active") == 1 && this.read("entered") != 1 && this.hasShu() && this.difficulty(data.Difficulty) != null)
		{
			this.transaction([["node_id",-1],["difficulty",data.Difficulty]]);this.cleanupLocations(this.ID);this.ensureLocations(this.ID);
			return {Success=true,Chapter=this.dto(this.ID)};
		}
		return this.chapters().error("invalid");
	}
};
::$bvvar{namespace}.ChapterLoops.shu_granary <- ::$bvvar{namespace}.ShuGranary;
