// World flags retain frozen per-item rewards and partial delivery across cycles and saves.
::$bvvar{namespace}.SeptiumMine <- {
	ID = "septium_mine", Busy = false,
	function api() { return ::$bvvar{namespace}; },
	function chapters() { return this.api().Chapters; },
	function definition() { return this.chapters().definition(this.ID); },
	function read(key, fallback = 0) { return this.chapters().read(this.ID, key, fallback); },
	function write(key, value) { this.chapters().write(this.ID, key, value); },
	function now() { return ::Time.getVirtualTimeF(); },
	function cycle() { return this.read("cycle"); },
	function unlocked(){return this.chapters().completed("septium_workshop")>=8;},
	function difficulty(id) { foreach (d in this.definition().Difficulties) if (d.ID == id) return d; return null; },
	function rewardRows(rewards)
	{
		local rows = []; foreach (r in rewards) rows.push({Key=r.Key,Name=this.api().SeptiumMineRewards[r.Key].Name,Count=r.Count}); return rows;
	},
	function remaining() { return ::Math.maxf(0.0, this.read("next_at", 0.0) - this.now()); },
	function canStart(id) { return !this.Busy && this.unlocked() && this.read("active") != 1 && this.remaining() <= 0; },
	function start(id) { return this.begin("earth_1", this.cycle()); },
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
		this.transaction([["schema", 1], ["started", 1], ["difficulty", level], ["allocation.normal",this.difficulty(level).Normal],["allocation.rare",this.difficulty(level).Rare], ["entered", 0], ["node_id", -1], ["cycle", this.cycle() + 1], ["active", 1]]);
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
			loc.getFlags().set("BVChapterCycle", this.cycle()); loc.getFlags().set("BVSeptiumMineDifficulty", this.read("difficulty", "earth_1"));
			this.write("node_id", loc.getID()); loc.configure(); loc.onSpawned(); this.chapters().reveal(loc);
		} catch (e) { if (loc != null && loc.isAlive()) loc.die(); this.write("node_id", -1); ::logWarning("[Battle Valkyries] Septium mine placement deferred: " + e); }
	},
	function enter(loc)
	{
		if (this.read("active") != 1 || loc.getID() != this.read("node_id", -1) || loc.getFlags().get("BVChapterCycle") != this.cycle()) return false;
		if (this.read("entered") != 1)
		{
			if (!this.unlocked()) return false;
			local changes=[], route=this.difficulty(this.read("difficulty","earth_1")), rewards=[];
            local n=this.read("allocation.normal",route.Normal),r=this.read("allocation.rare",route.Rare);
            foreach(row in [[route.Pair[0]+"_1",n],[route.Pair[1]+"_1",route.Normal-n],[route.Pair[0]+"_2",r],[route.Pair[1]+"_2",route.Rare-r],["sand",route.Sand]])if(row[1]>0)rewards.push({Key=row[0],Count=row[1]});
			changes.push(["reward_count." + this.cycle(), rewards.len()]);
			foreach (index, r in rewards) {
				changes.push(["reward_key." + this.cycle() + "." + index, r.Key]);
				changes.push(["reward_amount." + this.cycle() + "." + index, r.Count]);
			}
			changes.push(["entered", 1]); this.transaction(changes);
		}
		loc.getFlags().set("BVSeptiumMineCombatID", ::World.Statistics.getFlags().getAsInt("LastCombatID"));
		return true;
	},
	function battleWon(id, node)
	{
		if (node != "fieldsite" || this.read("active") != 1 || this.read("entered") != 1) return;
		local loc = null;
		foreach (entry in ::World.EntityManager.getLocations()) if (entry != null && entry.getID() == this.read("node_id", -1)) loc = entry;
		if (loc == null || !loc.isAlive() || loc.getFlags().get("BVChapterCycle") != this.cycle() || loc.getTroops().len() != 0) return;
		local f = ::World.Statistics.getFlags(), before = loc.getFlags().get("BVSeptiumMineCombatID");
		if (typeof before != "integer" || f.getAsInt("LastCombatID") != before + 1 || f.get("LastCombatResult") != 1) return;
		if (this.read("reward_count." + this.cycle()) <= 0 || this.read("win." + this.cycle()) == 1) return;
		this.transaction([["win." + this.cycle(), 1], ["cleared." + this.read("difficulty", "earth_1"), 1], ["next_at", this.now() + 3.0 * ::World.getTime().SecondsPerDay], ["completed", 1], ["active", 0]]);
	},
	function pendingRows()
	{
		local rows = [];
		for (local cycle = 1; cycle <= this.cycle(); ++cycle) {
			if (this.read("win." + cycle) != 1) continue;
			for (local index = 0; index < this.read("reward_count." + cycle); ++index) {
				local suffix = cycle + "." + index, key = this.read("reward_key." + suffix, "");
				local amount = this.read("reward_amount." + suffix) - this.read("delivered." + suffix);
				if (amount > 0 && key in this.api().SeptiumMineRewards) rows.push({Suffix=suffix,Key=key,Count=amount,Name=this.api().SeptiumMineRewards[key].Name});
			}
		}
		return rows;
	},
	function pending() { local total = 0; foreach (r in this.pendingRows()) total += r.Count; return total; },
	function rewardDefinition(key){return this.api().SeptiumMineRewards[key];},
	function claim()
	{
		if (this.Busy) return this.chapters().error("stale");
		local rows = this.pendingRows(); if (rows.len() == 0) return this.chapters().error("incomplete");
		this.Busy = true; local stash = ::World.Assets.getStash(), delivered = false, stop = false, failed = false;
		foreach (r in rows) {
			for (local n = 0; n < r.Count; ++n) {
				local item = null, added = false;
				try {
					if (r.Key!="sand" && !stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) { stop = true; break; }
                    local reward=this.rewardDefinition(r.Key);
                    if(r.Key=="sand"){
                        local old=this.api().Orbments.balance();
                        try {this.api().Orbments.setBalance(old+1);this.write("delivered."+r.Suffix,this.read("delivered."+r.Suffix)+1);}
                        catch(e){this.api().Orbments.setBalance(old);throw e;}
                    } else {
                        item=this.api().Orbments.quartz(reward.Code);
                        if(stash.add(item)==null){stop=true;break;}
                        added=true;this.write("delivered."+r.Suffix,this.read("delivered."+r.Suffix)+1);
                    }
					delivered = true;
				} catch (e) {
					if (added) stash.remove(item);
					::logWarning("[Battle Valkyries] Fieldwork reward delivery deferred: " + r.Key + " (" + r.Suffix + "): " + e); failed = true; stop = true; break;
				}
			}
			if (stop) break;
		}
		this.Busy = false;
		if (!delivered && failed) return { Success = false, Code = "reward", Message = "$bv{chapter.septium_mine.error.reward}" };
		if (!delivered) return this.chapters().error("stash");
		try { ::World.State.updateTopbarAssets(); } catch (e) {}
		local first = this.read("ending_seen") != 1; this.write("ending_seen", 1);
		return {Success=true,Chapter=this.dto(this.ID),Scene=this.chapters().scene(this.ID,first?"ending":"delivery")};
	},
	function syncRewards(id) {},
	function gallery(id)
	{
		local out = [], unlocked = this.read("completed") == 1;
		foreach (cg in this.definition().Gallery) { unlocked=this.read("completed")==1; out.push({ID=cg.ID,Stage=1,Unlocked=unlocked,Title=unlocked?cg.Title:"$bv{chapter.cg.ui.locked}",Caption=unlocked?cg.Caption:"",Image=unlocked?cg.Image:""}); }
		return out;
	},
	function dto(id)
	{
		local d = this.definition(), owned = this.unlocked(), active = this.read("active") == 1, entered = this.read("entered") == 1;
		local choices = [], pending = this.pending(), first = this.read("completed") == 1;
		foreach (route in d.Difficulties) {
            local pair=this.api().OrbmentGems[route.Pair[0]].Name+" / "+this.api().OrbmentGems[route.Pair[1]].Name;
            local rewards=[{Name=pair+" I",Count=route.Normal}];
            if(route.Rare>0)rewards.push({Name=pair+" II",Count=route.Rare});
            rewards.push({Name=this.api().SeptiumMineRewards.sand.Name,Count=route.Sand});
            choices.push({ID=route.ID,Name=route.Name,Brief=route.Brief,EnemyText=route.EnemyText,Rewards=rewards,Cleared=this.read("cleared."+route.ID)==1});
        }
		local selected = this.difficulty(this.read("difficulty", ""));
		return { ID=id,Name=d.Name,Description=d.Description,Poster=d.Poster,Repeatable=true,RepeatableKind="septium",RepeatableLabel="$bv{chapter.septium_mine.repeatable}",CooldownLabel="$bv{chapter.septium_mine.cooldown}",Started=this.read("started")==1,Finished=false,
			Completed=first?1:0,Total=1,Stage=1,StageName=d.Stages[0].Name,Brief=d.Stages[0].Brief,Goals=[],Materials=[],Requirements=[{Name="$bv{chapter.septium.workshop.name}",Met=owned}],
			CanStart=this.canStart(id),AvailableLabel="$bv{chapter.septium_mine.available}",CanSubmit=false,Money=0,Tools=0,Medicine=0,PerksEach=0,Special="",PendingWeapon=false,PendingSkin=false,
			Opening=this.read("started")==1?this.chapters().scene(id,"opening"):null,GuardScene=this.read("started")==1?this.chapters().scene(id,"guard"):null,
			Gallery=this.gallery(id),Stages=[{Number=1,Name=d.Stages[0].Name,Complete=first,Current=active,Scene=first?this.chapters().scene(id,"ending"):null}],
			Cycle=this.cycle(),Active=active,Entered=entered,SelectedDifficulty=this.read("difficulty",""),SelectedName=selected==null?"":selected.Name,
			RemainingHours=this.remaining()/::World.getTime().SecondsPerDay*24.0,Difficulties=choices,Allocation=selected==null?null:{Pair=selected.Pair,Normal=selected.Normal,Rare=selected.Rare,FirstNormal=this.read("allocation.normal",selected.Normal),FirstRare=this.read("allocation.rare",selected.Rare),Names=[this.api().OrbmentGems[selected.Pair[0]].Name,this.api().OrbmentGems[selected.Pair[1]].Name]},PendingItems=this.pendingRows(),PendingCount=pending,
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
        if(data.Action=="allocate" && this.read("active")==1 && this.read("entered")!=1 && "Normal" in data && "Rare" in data){
            local route=this.difficulty(this.read("difficulty"));
            if(typeof data.Normal!="integer" || typeof data.Rare!="integer" || data.Normal<0 || data.Normal>route.Normal || data.Rare<0 || data.Rare>route.Rare)return this.chapters().error("invalid");
            this.transaction([["allocation.normal",data.Normal],["allocation.rare",data.Rare]]);return {Success=true,Chapter=this.dto(this.ID)};
        }
		if (data.Action == "claim") return this.claim();
		if (data.Action == "focus") return this.chapters().focus(this.ID,"fieldsite");
		if (data.Action == "cancel" && this.read("active") == 1) {
			local changes = [["active", 0]];
			this.transaction(changes); this.cleanupLocations(this.ID); return {Success=true,Chapter=this.dto(this.ID)};
		}
		if (data.Action == "difficulty" && "Difficulty" in data && this.read("active") == 1 && this.read("entered") != 1 && this.unlocked() && this.difficulty(data.Difficulty) != null)
		{
			this.transaction([["node_id",-1],["difficulty",data.Difficulty],["allocation.normal",this.difficulty(data.Difficulty).Normal],["allocation.rare",this.difficulty(data.Difficulty).Rare]]);this.cleanupLocations(this.ID);this.ensureLocations(this.ID);
			return {Success=true,Chapter=this.dto(this.ID)};
		}
		return this.chapters().error("invalid");
	}
};
::$bvvar{namespace}.ChapterLoops.septium_mine <- ::$bvvar{namespace}.SeptiumMine;
