// World flags retain frozen per-item rewards and partial delivery across cycles and saves.
::$bvvar{namespace}.RyzaFieldwork <- {
	ID = "ryza_fieldwork", Busy = false,
	function api() { return ::$bvvar{namespace}; },
	function chapters() { return this.api().Chapters; },
	function definition() { return this.chapters().definition(this.ID); },
	function read(key, fallback = 0) { return this.chapters().read(this.ID, key, fallback); },
	function write(key, value) { this.chapters().write(this.ID, key, value); },
	function now() { return ::Time.getVirtualTimeF(); },
	function cycle() { return this.read("cycle"); },
	function hasRyza()
	{
		foreach (a in ::World.getPlayerRoster().getAll())
			if (a != null && a.isPlayerControlled() && !this.api().isActorDeadOrDying(a) && this.api().getActorValkyrieID(a) == "ryza") return true;
		return false;
	},
	function difficulty(id) { foreach (d in this.definition().Difficulties) if (d.ID == id) return d; return null; },
	function rewardRows(rewards)
	{
		local rows = []; foreach (r in rewards) rows.push({Key=r.Key,Name=this.api().RyzaFieldRewards[r.Key].Name,Count=r.Count}); return rows;
	},
	function remaining() { return ::Math.maxf(0.0, this.read("next_at", 0.0) - this.now()); },
	function canStart(id) { return !this.Busy && this.hasRyza() && this.read("active") != 1 && this.remaining() <= 0; },
	function start(id) { return this.begin("rescue", this.cycle()); },
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
		this.transaction([["schema", 1], ["started", 1], ["difficulty", level], ["entered", 0], ["node_id", -1], ["cycle", this.cycle() + 1], ["active", 1]]);
		this.ensureLocations(this.ID);
		return { Success = true, Chapter = this.dto(this.ID), Scene = this.chapters().scene(this.ID, first ? "opening" : (this.read("completed") == 1 ? "repeat" : "guard")) };
	},
	function findLocation(id, node)
	{
		if (node != "fieldsite" || this.read("active") != 1) return null;
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
		if (this.read("active") != 1 || this.findLocation(id, "fieldsite") != null) return;
		// Never rebuild an entered camp: survivors and casualties belong to its saved instance.
		if (this.read("entered") == 1) return;
		local tile = this.chapters().spawnTile(id); if (tile == null) return;
		local loc = null;
		try {
			loc = ::World.spawnLocation(this.definition().LocationScript, tile.Coords);
			if (loc == null) throw "No fieldwork location";
			loc.getFlags().set("BVChapterID", id); loc.getFlags().set("BVChapterNode", "fieldsite");
			loc.getFlags().set("BVChapterCycle", this.cycle()); loc.getFlags().set("BVRyzaFieldDifficulty", this.read("difficulty", "rescue"));
			this.write("node_id", loc.getID()); loc.configure(); loc.onSpawned(); this.chapters().reveal(loc);
		} catch (e) { if (loc != null && loc.isAlive()) loc.die(); this.write("node_id", -1); ::logWarning("[Battle Valkyries] Ryza fieldwork placement deferred: " + e); }
	},
	function enter(loc)
	{
		if (this.read("active") != 1 || loc.getID() != this.read("node_id", -1) || loc.getFlags().get("BVChapterCycle") != this.cycle()) return false;
		if (this.read("entered") != 1)
		{
			if (!this.hasRyza()) return false;
			local changes = [], rewards = this.difficulty(this.read("difficulty", "rescue")).Rewards;
			changes.push(["reward_count." + this.cycle(), rewards.len()]);
			foreach (index, r in rewards) {
				changes.push(["reward_key." + this.cycle() + "." + index, r.Key]);
				changes.push(["reward_amount." + this.cycle() + "." + index, r.Count]);
			}
			changes.push(["entered", 1]); this.transaction(changes);
		}
		loc.getFlags().set("BVRyzaFieldCombatID", ::World.Statistics.getFlags().getAsInt("LastCombatID"));
		return true;
	},
	function battleWon(id, node)
	{
		if (node != "fieldsite" || this.read("active") != 1 || this.read("entered") != 1) return;
		local loc = null;
		foreach (entry in ::World.EntityManager.getLocations()) if (entry != null && entry.getID() == this.read("node_id", -1)) loc = entry;
		if (loc == null || !loc.isAlive() || loc.getFlags().get("BVChapterCycle") != this.cycle() || loc.getTroops().len() != 0) return;
		local f = ::World.Statistics.getFlags(), before = loc.getFlags().get("BVRyzaFieldCombatID");
		if (typeof before != "integer" || f.getAsInt("LastCombatID") != before + 1 || f.get("LastCombatResult") != 1) return;
		if (this.read("reward_count." + this.cycle()) <= 0 || this.read("win." + this.cycle()) == 1) return;
		this.transaction([["win." + this.cycle(), 1], ["cleared." + this.read("difficulty", "rescue"), 1], ["next_at", this.now() + 3.0 * ::World.getTime().SecondsPerDay], ["completed", 1], ["active", 0]]);
	},
	function pendingRows()
	{
		local rows = [];
		for (local cycle = 1; cycle <= this.cycle(); ++cycle) {
			if (this.read("win." + cycle) != 1) continue;
			for (local index = 0; index < this.read("reward_count." + cycle); ++index) {
				local suffix = cycle + "." + index, key = this.read("reward_key." + suffix, "");
				local amount = this.read("reward_amount." + suffix) - this.read("delivered." + suffix);
				if (amount > 0 && key in this.api().RyzaFieldRewards) rows.push({Suffix=suffix,Key=key,Count=amount,Name=this.api().RyzaFieldRewards[key].Name});
			}
		}
		return rows;
	},
	function pending() { local total = 0; foreach (r in this.pendingRows()) total += r.Count; return total; },
	function rewardDefinition(key)
	{
		local reward = clone this.api().RyzaFieldRewards[key];
		// Legends/Accessory Companions initialize the supported wolf subclass.
		// Keep the saved reward key unchanged so existing pending cycles can claim it.
		if (key == "wolf" && "Legends" in getroottable())
		{
			reward.Script = "scripts/items/accessory/legend_wolf_item";
			reward.Item = "accessory.legend_warwolf";
		}
		return reward;
	},
	function isRewardItem(key, reward, item)
	{
		if (item == null) return false;
		local id = item.getID();
		// AC's setType -> updateCompanion normalizes the Legends wolf to the
		// native library ID. Both IDs identify the same ordinary wolf reward.
		return id == reward.Item || (key == "wolf" && id == this.api().RyzaFieldRewards.wolf.Item);
	},
	function claim()
	{
		if (this.Busy) return this.chapters().error("stale");
		local rows = this.pendingRows(); if (rows.len() == 0) return this.chapters().error("incomplete");
		this.Busy = true; local stash = ::World.Assets.getStash(), delivered = false, stop = false, wolf = false, failed = false;
		foreach (r in rows) {
			for (local n = 0; n < r.Count; ++n) {
				local item = null, added = false;
				try {
					if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) { stop = true; break; }
					local reward = this.rewardDefinition(r.Key); item = ::new(reward.Script);
					if (!this.isRewardItem(r.Key, reward, item))
						throw "Invalid fieldwork reward: " + reward.Script + ", expected " + reward.Item + ", got " + (item == null ? "null" : item.getID());
					if (stash.add(item) == null) { stop = true; break; }
					added = true; this.write("delivered." + r.Suffix, this.read("delivered." + r.Suffix) + 1);
					delivered = true; if (r.Key == "wolf") wolf = true;
				} catch (e) {
					if (added) stash.remove(item);
					::logWarning("[Battle Valkyries] Fieldwork reward delivery deferred: " + r.Key + " (" + r.Suffix + "): " + e); failed = true; stop = true; break;
				}
			}
			if (stop) break;
		}
		this.Busy = false;
		if (!delivered && failed) return { Success = false, Code = "reward", Message = "$bv{chapter.ryza_fieldwork.error.reward}" };
		if (!delivered) return this.chapters().error("stash");
		try { ::World.State.updateTopbarAssets(); } catch (e) {}
		local first = this.read("ending_seen") != 1; this.write("ending_seen", 1);
		local rescue = wolf && this.read("rescue_seen") != 1; if (rescue) this.write("rescue_seen", 1);
		return {Success=true,Chapter=this.dto(this.ID),Scene=this.chapters().scene(this.ID,rescue?"rescue_scene":first?"ending":"delivery")};
	},
	function syncRewards(id) {},
	function gallery(id)
	{
		local out = [], unlocked = this.read("completed") == 1;
		foreach (cg in this.definition().Gallery) { unlocked = cg.ID == "rescue" ? this.read("cleared.rescue") == 1 : this.read("completed") == 1; out.push({ID=cg.ID,Stage=1,Unlocked=unlocked,Title=unlocked?cg.Title:"$bv{chapter.cg.ui.locked}",Caption=unlocked?cg.Caption:"",Image=unlocked?cg.Image:""}); }
		return out;
	},
	function dto(id)
	{
		local d = this.definition(), owned = this.hasRyza(), active = this.read("active") == 1, entered = this.read("entered") == 1;
		local choices = [], pending = this.pending(), first = this.read("completed") == 1;
		foreach (route in d.Difficulties) choices.push({ID=route.ID,Name=route.Name,Brief=route.Brief,EnemyText=route.EnemyText,Rewards=this.rewardRows(route.Rewards),Cleared=this.read("cleared."+route.ID)==1});
		local selected = this.difficulty(this.read("difficulty", ""));
		return { ID=id,Name=d.Name,Description=d.Description,Poster=d.Poster,Repeatable=true,RepeatableKind="fieldwork",RepeatableLabel="$bv{chapter.ryza_fieldwork.repeatable}",CooldownLabel="$bv{chapter.ryza_fieldwork.cooldown}",Started=this.read("started")==1,Finished=false,
			Completed=first?1:0,Total=1,Stage=1,StageName=d.Stages[0].Name,Brief=d.Stages[0].Brief,Goals=[],Materials=[],Requirements=[{Name=this.api().Valkyries.ryza.Name,Met=owned}],
			CanStart=this.canStart(id),CanSubmit=false,Money=0,Tools=0,Medicine=0,PerksEach=0,Special="",PendingWeapon=false,PendingSkin=false,
			Opening=this.read("started")==1?this.chapters().scene(id,"opening"):null,GuardScene=this.read("started")==1?this.chapters().scene(id,"guard"):null,
			Gallery=this.gallery(id),Stages=[{Number=1,Name=d.Stages[0].Name,Complete=first,Current=active,Scene=first?this.chapters().scene(id,"ending"):null}],
			Cycle=this.cycle(),Active=active,Entered=entered,SelectedDifficulty=this.read("difficulty",""),SelectedName=selected==null?"":selected.Name,
			RemainingHours=this.remaining()/::World.getTime().SecondsPerDay*24.0,Difficulties=choices,PendingItems=this.pendingRows(),PendingCount=pending,
			CanClaim=pending>0&&( ::World.Assets.getStash().isResizable()||::World.Assets.getStash().getNumberOfEmptySlots()>0),
			CanChangeDifficulty=active&&!entered&&owned,CanCancel=active&&!this.Busy,CanFocus=this.findLocation(id,"fieldsite")!=null,MissingLocation=active&&entered&&this.findLocation(id,"fieldsite")==null };
	},
	function request(data)
	{
		if (::World == null || ::World.State == null || ::World.Assets == null || typeof data != "table" || !("Action" in data)) return this.chapters().error("invalid");
		if (this.Busy) return this.chapters().error("stale");
		if (data.Action == "refresh") { this.ensureLocations(this.ID); return {Success=true,Chapter=this.dto(this.ID)}; }
		if (!("Cycle" in data) || typeof data.Cycle != "integer" || data.Cycle != this.cycle()) return this.chapters().error("stale");
		if (data.Action == "begin" && "Difficulty" in data && typeof data.Difficulty == "string") return this.begin(data.Difficulty, data.Cycle);
		if (data.Action == "claim") return this.claim();
		if (data.Action == "focus") return this.chapters().focus(this.ID,"fieldsite");
		if (data.Action == "cancel" && this.read("active") == 1) {
			local changes = [["active", 0]];
			if (this.read("entered") == 1) changes.push(["next_at", this.now() + 3.0 * ::World.getTime().SecondsPerDay]);
			this.transaction(changes); this.cleanupLocations(this.ID); return {Success=true,Chapter=this.dto(this.ID)};
		}
		if (data.Action == "difficulty" && "Difficulty" in data && this.read("active") == 1 && this.read("entered") != 1 && this.hasRyza() && this.difficulty(data.Difficulty) != null)
		{
			this.transaction([["node_id",-1],["difficulty",data.Difficulty]]);this.cleanupLocations(this.ID);this.ensureLocations(this.ID);
			return {Success=true,Chapter=this.dto(this.ID)};
		}
		return this.chapters().error("invalid");
	}
};
::$bvvar{namespace}.ChapterLoops.ryza_fieldwork <- ::$bvvar{namespace}.RyzaFieldwork;
