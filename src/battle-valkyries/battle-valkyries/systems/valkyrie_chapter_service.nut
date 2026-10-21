// Authoritative chapter state. World flags serialize through the existing engine protocol.
::$bvvar{namespace}.Chapters <- {
	Busy = false,
	function definition(id) { return typeof id == "string" && id in ::$bvvar{namespace}.ChapterDefinitions ? ::$bvvar{namespace}.ChapterDefinitions[id] : null; },
	function key(id, suffix) { return "$bvvar{modId}.chapter." + id + "." + suffix; },
	function read(id, suffix, fallback = 0)
	{
		// Item Tables can instantiate chapter weapons before the world flags exist.
		if (!("World" in getroottable()) || ::World == null || !("Flags" in ::World) || ::World.Flags == null) return fallback;
		local key = this.key(id, suffix); return ::World.Flags.has(key) ? ::World.Flags.get(key) : fallback;
	},
	function write(id, suffix, value) { ::World.Flags.set(this.key(id, suffix), value); },
	function migrate(id)
	{
		if (id != "yunki_demon_chronicle" || this.read(id, "started") != 1 || this.read(id, "schema") >= 2) return;
		local old = this.read(id, "completed"), mapping = [0, 1, 1, 3, 3, 5, 7, 8];
		if (typeof old != "integer" || old < 0 || old > 7) return;
		// Retain paid rewards and earned weapon tiers. Never replay an old payout.
		this.write(id, "legacy_completed", old);
		this.write(id, "completed", mapping[old]);
		this.write(id, "schema", 2);
	},
	function migratePreparation(id)
	{
		local d = this.definition(id);
		if (d == null || !("PreparationVersion" in d) || this.read(id, "started") != 1 || this.read(id, "preparation_version") >= d.PreparationVersion) return;
		local n = this.read(id, "completed");
		if (typeof n != "integer" || n < 0 || n > d.Stages.len()) return;
		// Old investigations represented the whole site. Carry their result to
		// the new actions once; never advance a stage or replay its rewards.
		if (n < d.Stages.len()) foreach (g in d.Stages[n].Goals)
			if ("LegacyGoal" in g && this.read(id, "goal." + g.LegacyGoal) == 1) this.write(id, "goal." + g.Key, 1);
		this.write(id, "preparation_version", d.PreparationVersion);
	},
	function completed(id) { this.migrate(id); this.migratePreparation(id); local n = this.read(id, "completed"); return typeof n == "integer" ? n : 0; },
	function hasEvidence(id, key)
	{
		local d = this.definition(id), n = this.completed(id);
		if (d == null || !("Evidence" in d) || this.read(id, "started") != 1) return false;
		foreach (e in d.Evidence) if (e.Key == key)
			return n >= e.Stage || (n + 1 == e.Stage && "Goal" in e && this.read(id, "goal." + e.Goal) == 1);
		return false;
	},
	function goalMissing(id, goal)
	{
		local out = [], s = this.stage(id);
		if (s != null && "Requires" in goal) foreach (key in goal.Requires)
			if (this.read(id, "goal." + key) != 1) foreach (g in s.Goals) if (g.Key == key) out.push(g.Name);
		return out;
	},
	function reservedMaterial(id, material)
	{
		if (id == null || !("SourceGoal" in material)) return 0;
		local s = this.stage(id); if (s == null) return 0;
		foreach (g in s.Goals) if (g.Key == material.SourceGoal && this.read(id, "goal." + g.Key) == 1) return material.Count;
		return 0;
	},
	function weaponStage(id)
	{
		local n = this.completed(id), tiers = [0, 1, 2, 3, 4, 5, 5, 6, 7];
		return ::Math.max(this.read(id, "legacy_completed"), tiers[::Math.min(8, ::Math.max(0, n))]);
	},
	function scene(id, sceneKey)
	{
		local d = this.definition(id); if (d == null || !(sceneKey in d.Scenes)) return null;
		local entry = d.Scenes[sceneKey], video = entry.Video != "" ? d.Videos[entry.Video] : null;
		local lines = [];
		foreach (line in entry.Lines)
		{
			local text = line.Text;
			if ("SceneTokens" in d) foreach (token, spec in d.SceneTokens)
			{
				local value = this.read(id, spec.Flag, ""), marker = "{" + token + "}", pos = text.find(marker);
				if (pos != null) text = text.slice(0, pos) + (value in spec.Values ? spec.Values[value] : "") + text.slice(pos + marker.len());
			}
			lines.push({ Speaker = line.Speaker, Name = "Name" in line ? line.Name : (line.Speaker == "narrator" ? "$bv{chapter.ui.narrator}" : ::$bvvar{namespace}.Valkyries[line.Speaker].Name), Text = text });
		}
		return { ID = sceneKey, Title = entry.Title, Background = entry.Background, Actors = "PortraitOrder" in entry ? clone entry.PortraitOrder : ("PortraitOrder" in d ? clone d.PortraitOrder : ["ye_shunguang", "yixuan"]), Portraits = "Portraits" in entry ? clone entry.Portraits : clone d.Portraits, Lines = lines, Video = video != null && video.Enabled ? video.Path : "" };
	},
	function stage(id) { local d = this.definition(id), n = this.completed(id); return d != null && this.read(id, "started") == 1 && n < d.Stages.len() ? d.Stages[n] : null; },
	function actor(id)
	{
		if (::World == null) return null;
		foreach (a in ::World.getPlayerRoster().getAll())
			if (a != null && a.isAlive() && ::$bvvar{namespace}.getActorValkyrieID(a) == id) return a;
		return null;
	},
	function canStart(id)
	{
		local d = this.definition(id); if (d == null || this.read(id, "started") == 1) return false;
		foreach (a in d.Actors) if (this.actor(a) == null) return false;
		return true;
	},
	function inventoryCount(material)
	{
		if (material.Key == "medicine") return ::World.Assets.getMedicine();
		if (material.Key == "tools") return ::World.Assets.getArmorParts();
		local n = 0; foreach (item in ::World.Assets.getStash().getItems()) if (item != null && item.getID() == material.Item) ++n;
		return n;
	},
	function ready(id)
	{
		local s = this.stage(id); if (s == null) return false;
		foreach (g in s.Goals) if (!("Optional" in g && g.Optional) && this.read(id, "goal." + g.Key) != 1) return false;
		if ("RequiredEvidence" in s) foreach (key in s.RequiredEvidence) if (!this.hasEvidence(id, key)) return false;
		foreach (m in s.Materials) if (this.inventoryCount(m) + this.reservedMaterial(id, m) < m.Count) return false;
		return true;
	},
	function error(code)
	{
		local copy = { invalid = "$bv{chapter.error.invalid}", locked = "$bv{chapter.error.locked}", stale = "$bv{chapter.error.stale}", incomplete = "$bv{chapter.error.incomplete}", far = "$bv{chapter.error.far}", stash = "$bv{chapter.error.stash}", money = "$bv{chapter.error.money}", unavailable = "$bv{chapter.error.unavailable}" };
		return { Success = false, Code = code, Message = code in copy ? copy[code] : copy.unavailable };
	},
	function start(id)
	{
		if (!this.canStart(id)) return this.error("locked");
		this.write(id, "schema", 2); this.write(id, "started", 1); this.write(id, "completed", 0);
		local d = this.definition(id); if ("PreparationVersion" in d) this.write(id, "preparation_version", d.PreparationVersion);
		this.ensureLocations(id);
		return { Success = true, Scene = this.scene(id, "opening"), Chapter = this.dto(id) };
	},
	function submit(id, expectedStage)
	{
		if (this.Busy) return this.error("stale");
		if (this.definition(id) == null) return this.error("invalid");
		if (expectedStage != this.completed(id) + 1) return this.error("stale");
		if (!this.ready(id)) return this.error("incomplete");
		local s = this.stage(id), assets = ::World.Assets, stash = assets.getStash();
		local oldMoney = assets.getMoney(), oldMedicine = assets.getMedicine(), oldTools = assets.getArmorParts(), removed = [];
		// Preflight all item references before deducting anything. The stage counter commits last.
		foreach (m in s.Materials)
		{
			if (!("Item" in m)) continue;
			local left = m.Count - this.reservedMaterial(id, m);
			foreach (item in stash.getItems()) if (item != null && item.getID() == m.Item && left > 0) { removed.push(item); --left; }
			if (left > 0) return this.error("incomplete");
		}
		this.Busy = true;
		try
		{
			foreach (item in removed) stash.remove(item);
			foreach (m in s.Materials)
			{
				if (m.Key == "medicine") assets.setMedicine(assets.getMedicine() - m.Count);
				if (m.Key == "tools") assets.setArmorParts(assets.getArmorParts() - m.Count);
			}
			assets.setMoney(oldMoney + s.Money); assets.setMedicine(assets.getMedicine() + s.Medicine); assets.setArmorParts(assets.getArmorParts() + s.Tools);
			this.write(id, "completed", expectedStage);
		}
		catch (e)
		{
			assets.setMoney(oldMoney); assets.setMedicine(oldMedicine); assets.setArmorParts(oldTools);
			foreach (item in removed) { local found = false; foreach (current in stash.getItems()) if (current == item) found = true; if (!found) stash.add(item); }
			this.Busy = false; ::logError("[Battle Valkyries] Chapter submit rollback: " + e); return this.error("unavailable");
		}
		this.Busy = false;
		// Entitlements are derived from committed completion; failed/full-stash deliveries remain retryable.
		try { this.syncRewards(id); this.cleanupLocations(id); this.ensureLocations(id); }
		catch (e) { ::logError("[Battle Valkyries] Committed chapter reward repair deferred: " + e); }
		try { ::World.State.updateTopbarAssets(); } catch (e) {}
		return { Success = true, Scene = this.scene(id, s.Scene), Chapter = this.dto(id) };
	},
	function syncRewards(id)
	{
		local d = this.definition(id), n = this.completed(id); if (d == null || n == 0) return;
		foreach (actorID in d.Actors)
		{
			local a = this.actor(actorID); if (a == null) continue;
			local paid = this.read(id, "perks." + actorID);
			local earned = 0;
			for (local i = 0; i < n && i < d.Stages.len(); ++i) earned += "PerksEach" in d.Stages[i] ? d.Stages[i].PerksEach : 1;
			if (paid < earned) { a.setPerkPoints(a.getPerkPoints() + earned - paid); this.write(id, "perks." + actorID, earned); }
			if ("SkillRewards" in d) foreach (reward in d.SkillRewards)
				if (reward.Actor == actorID && n >= reward.Stage && !::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement(a, reward.Key))
				{
					local result = ::$bvvar{namespace}.learnSkill(a, reward.Key, "chapter:" + id);
					if (!result.Success) ::$bvvar{namespace}.logValkyrieSkillFailure(a, reward.Key, result.Code, "chapter.reward");
				}
			if ("SkinRewards" in d) foreach (reward in d.SkinRewards)
				if (reward.Actor == actorID && n >= reward.Stage) a.getFlags().set("$bvvar{modId}.skin.unlocked." + reward.Skin, true);
			if (id != "yunki_demon_chronicle") { a.getSkills().update(); continue; }
			if (actorID == "ye_shunguang") a.getFlags().set("$bvvar{modId}.yunki.weapon_stage", this.weaponStage(id));
			if (actorID == "yixuan" && n >= d.Stages.len())
			{
				a.getFlags().set("$bvvar{modId}.skin.unlocked.yixuan_ink_shadow_skin", true);
				foreach (key in ["yixuan_yunki_oath", "yixuan_sanctuary"])
				{
					if (!::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement(a, key))
					{
						local result = ::$bvvar{namespace}.learnSkill(a, key, "chapter:" + id);
						if (!result.Success) ::$bvvar{namespace}.logValkyrieSkillFailure(a, key, result.Code, "chapter.reward");
					}
				}
			}
			::$bvvar{namespace}.syncQingmingWeaponSkills(a);
			a.getSkills().update();
		}
		if ("SkinRewards" in d) foreach (reward in d.SkinRewards)
		{
			if (n < reward.Stage || this.read(id, "skin_delivered." + reward.Skin) == 1) continue;
			local stash = ::World.Assets.getStash();
			if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) continue;
			try
			{
				local item = ::$bvvar{namespace}.createValkyrieSkinItem(::$bvvar{namespace}.Valkyries[reward.Actor], null, reward.Skin);
				if (item != null && stash.add(item) != null) this.write(id, "skin_delivered." + reward.Skin, 1);
			}
			catch (e) { ::logError("[Battle Valkyries] Chapter skin delivery pending: " + e); }
		}
		if (id != "yunki_demon_chronicle") return;
		if (n >= d.Stages.len())
		{
			this.write(id, "skin_unlocked", 1);
			if (this.read(id, "skin_delivered") != 1)
			{
				local stash = ::World.Assets.getStash();
				if (stash.isResizable() || stash.getNumberOfEmptySlots() > 0)
				{
					try
					{
						local item = ::$bvvar{namespace}.createValkyrieSkinItem(::$bvvar{namespace}.Valkyries.yixuan, null, "yixuan_ink_shadow_skin");
						if (item != null && stash.add(item) != null) this.write(id, "skin_delivered", 1);
					}
					catch (e) { ::logError("[Battle Valkyries] Chapter skin delivery pending: " + e); }
				}
			}
		}
		if (this.read(id, "weapon_delivered") != 1)
		{
			local stash = ::World.Assets.getStash();
			if (stash.isResizable() || stash.getNumberOfEmptySlots() > 0)
			{
				try { local item = ::new("scripts/items/weapons/battle_valkyries/ye_shunguang_qingming_casket"); if (stash.add(item) != null) this.write(id, "weapon_delivered", 1); }
				catch (e) { ::logError("[Battle Valkyries] Chapter weapon delivery pending: " + e); }
			}
		}
		foreach (item in ::World.Assets.getStash().getItems())
			if (item != null && item.getID() == "$bvvar{modId}.weapon.qingming_casket") item.refreshForm();
	},
	function interact(id, goalKey, expectedStage, choice = null)
	{
		if (expectedStage != this.completed(id) + 1) return this.error("stale");
		local s = this.stage(id); if (s == null) return this.error("invalid");
		foreach (goal in s.Goals)
		{
			if (goal.Key != goalKey || ("Battle" in goal && goal.Battle)) continue;
			if (this.read(id, "goal." + goal.Key) == 1) return this.error("stale");
			if (this.goalMissing(id, goal).len() != 0) return this.error("incomplete");
			if ("Choices" in goal)
			{
				local valid = false; foreach (option in goal.Choices) if (option.ID == choice) valid = true;
				if (!valid) return this.error("invalid");
			}
			else if (choice != null) return this.error("invalid");
			local location = this.findLocation(id, goal.Node);
			if (location == null || !this.near(location)) return this.error("far");
			if ("Choices" in goal) this.write(id, "choice." + goal.Key, choice);
			this.write(id, "goal." + goal.Key, 1); this.cleanupLocations(id);
			return { Success = true, Scene = "Scene" in goal ? this.scene(id, goal.Scene) : null, Chapter = this.dto(id) };
		}
		return this.error("invalid");
	},
	function purchase(id, materialKey, expectedStage)
	{
		// Retain the old endpoint as a rejected compatibility route; gold cannot replace gathering.
		return this.error("invalid");
	},
	function gallery(id)
	{
		local d = this.definition(id), out = [];
		if (d == null || !("Gallery" in d)) return out;
		local n = this.completed(id), started = this.read(id, "started") == 1;
		foreach (cg in d.Gallery)
		{
			local unlocked = started && n >= cg.Stage;
			out.push({ ID = cg.ID, Stage = cg.Stage, Unlocked = unlocked, Title = unlocked ? cg.Title : "$bv{chapter.cg.ui.locked}", Caption = unlocked ? cg.Caption : "", Image = unlocked ? cg.Image : "" });
		}
		return out;
	},
	function hasPendingSkins(id)
	{
		local d = this.definition(id), n = this.completed(id); if (d == null) return false;
		if (id == "yunki_demon_chronicle") return n >= d.Stages.len() && this.read(id, "skin_delivered") != 1;
		if ("SkinRewards" in d) foreach (reward in d.SkinRewards)
			if (n >= reward.Stage && this.read(id, "skin_delivered." + reward.Skin) != 1) return true;
		return false;
	},
	function dto(id)
	{
		local d = this.definition(id); if (d == null) return null;
		local n = this.completed(id), s = this.stage(id), started = this.read(id, "started") == 1, requirements = [], stages = [], goals = [], materials = [], evidence = [];
		if (started && "Evidence" in d) foreach (e in d.Evidence)
		{
			local acquired = this.hasEvidence(id, e.Key), required = s != null && "RequiredEvidence" in s && s.RequiredEvidence.find(e.Key) != null;
			if (acquired || required) evidence.push({ Name = e.Name, Acquired = acquired, Source = e.Source });
		}
		foreach (actorID in d.Actors) requirements.push({ Name = ::$bvvar{namespace}.Valkyries[actorID].Name, Met = this.actor(actorID) != null });
		foreach (i, entry in d.Stages) stages.push({ Number = i + 1, Name = i <= n ? entry.Name : "$bv{chapter.ui.locked_stage}", Complete = i < n, Current = started && i == n, Scene = i < n ? this.scene(id, entry.Scene) : null });
		if (s != null)
		{
			foreach (g in s.Goals)
			{
				local loc = this.findLocation(id, g.Node), done = this.read(id, "goal." + g.Key) == 1, battle = "Battle" in g && g.Battle;
				local choices = []; if ("Choices" in g) foreach (option in g.Choices) choices.push({ ID = option.ID, Name = option.Name });
				local missing = this.goalMissing(id, g);
				goals.push({ Key = g.Key, Name = g.Name, Done = done, Battle = battle, CanInteract = !done && !battle && missing.len() == 0 && loc != null && this.near(loc), Node = g.Node, Available = loc != null, Choices = choices, Choice = done ? this.read(id, "choice." + g.Key, "") : "", Scene = done && "Scene" in g ? this.scene(id, g.Scene) : null, Action = "Action" in g ? g.Action : "$bv{chapter.ui.investigate}", Optional = "Optional" in g && g.Optional, Missing = missing });
			}
			foreach (m in s.Materials) {
				local reserved = this.reservedMaterial(id, m);
				materials.push({ Key = m.Key, Name = m.Name, Required = m.Count, Owned = this.inventoryCount(m) + reserved, Reserved = reserved, Consume = m.Count - reserved, Source = m.Source });
			}
		}
		return { ID = id, Name = d.Name, Description = d.Description, Poster = d.Poster, Gallery = this.gallery(id), Ending = "Ending" in d ? d.Ending : "", Started = started, Opening = started ? this.scene(id, "opening") : null, Completed = n, Total = d.Stages.len(), Finished = n >= d.Stages.len(), CanStart = this.canStart(id), CanSubmit = s != null && this.ready(id), Stage = n + 1, StageName = s == null ? "" : s.Name, Brief = s == null ? "" : s.Brief, Goals = goals, Materials = materials, Evidence = evidence, Requirements = requirements, Stages = stages, Money = s == null ? 0 : s.Money, Medicine = s == null ? 0 : s.Medicine, Tools = s == null ? 0 : s.Tools, PerksEach = s == null ? 0 : ("PerksEach" in s ? s.PerksEach : 1), Special = s == null ? "" : s.Special, PendingWeapon = id == "yunki_demon_chronicle" && n > 0 && this.read(id, "weapon_delivered") != 1, PendingSkin = this.hasPendingSkins(id) };
	},
	function cards() { local out = []; foreach (id, d in ::$bvvar{namespace}.ChapterDefinitions) out.push(this.dto(id)); return out; }
};
