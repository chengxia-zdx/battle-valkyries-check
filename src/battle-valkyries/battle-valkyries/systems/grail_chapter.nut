// The world ledger owns the wish. Item removal is replayable cleanup, never authority.
::$bvvar{namespace}.Grail <- {
	ID = "unclaimed_grail_four_oaths", Busy = false, Delivering = false,
	Actors = ["saber", "morgan", "jeanne", "jeanne_alter"],
	Gear = ["grail_gungnir", "grail_court_armor", "grail_court_helmet", "grail_oath_ring"],
	Paths = ["weapons", "armor", "helmets", "accessory"],
	read = function(key, fallback = 0) { return ::$bvvar{namespace}.Chapters.read(this.ID, "wish." + key, fallback); },
	write = function(key, value) { ::$bvvar{namespace}.Chapters.write(this.ID, "wish." + key, value); },
	safeWorld = function() {
		return ::World != null && ::World.Assets != null && ::World.State != null
			&& (!("Tactical" in getroottable()) || ::Tactical == null || !::Tactical.isActive());
	},
	cup = function() {
		foreach (item in ::World.Assets.getStash().getItems())
			if (item != null && item.getID() == "$bvvar{modId}.item.four_oaths_grail") return item;
		return null;
	},
	findActor = function(id, identity) {
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (actor.getID() == id && actor.isAlive() && !actor.isDying() && actor.getHitpoints() > 0
				&& ::$bvvar{namespace}.getActorValkyrieID(actor) == identity) return actor;
		return null;
	},
	deliverItem = function(key, path, expectedID = null) {
		if (this.read(key) == 1) return;
		local stash = ::World.Assets.getStash();
		if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) return;
		local item = ::new(path);
		if (expectedID != null && (item == null || item.getID() != expectedID)) {
			::logError("[Battle Valkyries] Grail item initialization failed: " + path);
			return;
		}
		try { if (stash.add(item) != null) this.write(key, 1); }
		catch (e) {
			// A mod may throw after accepting an item. Do not issue a second copy.
			foreach (stored in stash.getItems()) if (stored == item) { this.write(key, 1); return; }
			throw e;
		}
	},
	deliver = function() {
		if (!this.safeWorld() || ::$bvvar{namespace}.Chapters.completed(this.ID) < 8) return;
		local choice = this.read("choice", "");
		if (choice == "") {
			// The protected cup cannot be sold/discarded. Recover an unspent wish
			// whose old item failed to initialize, even if delivery was recorded.
			this.write("cup_delivered", this.cup() != null ? 1 : 0);
			this.deliverItem("cup_delivered", "scripts/items/misc/battle_valkyries/four_oaths_grail", "$bvvar{modId}.item.four_oaths_grail");
			return;
		}
		local cup = this.cup(); while (cup != null) { ::World.Assets.getStash().remove(cup); cup = this.cup(); }
		if (choice == "wealth") {
			local paid = this.read("money_paid"), assets = ::World.Assets;
			if (paid < 500000) {
				local before = assets.getMoney();
				try { assets.setMoney(before + 500000 - paid); }
				catch (e) { ::logWarning("[Battle Valkyries] Grail crown delivery deferred: " + e); }
				this.write("money_paid", paid + ::Math.max(0, ::Math.min(500000 - paid, assets.getMoney() - before)));
			}
		}
		else if (choice == "valor") {
			foreach (i, key in this.Gear) this.deliverItem("gear." + key, "scripts/items/" + this.Paths[i] + "/battle_valkyries/" + key);
		}
		else if (choice == "companionship") {
			foreach (identity in this.Actors) {
				local actor = this.findActor(this.read("actor." + identity, -1), identity);
				if (actor == null) continue;
				local flags = actor.getFlags(), key = "$bvvar{modId}.grail.blessed";
				flags.set(key, true);
				if (!flags.has(key + ".perks")) { actor.setPerkPoints(actor.getPerkPoints() + 2); flags.set(key + ".perks", true); }
				local skill = "grail_" + identity + "_blessing";
				if (!::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement(actor, skill))
					::$bvvar{namespace}.learnSkill(actor, skill, "chapter:" + this.ID);
				actor.getSkills().update();
				if (::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement(actor, skill)) this.write("blessing." + identity, 1);
			}
		}
	},
	choose = function(request) {
		local c = ::$bvvar{namespace}.Chapters;
		if (this.Busy || !this.safeWorld() || c.completed(this.ID) < 8 || this.read("choice", "") != ""
			|| this.cup() == null || !("Choice" in request) || !("Confirm" in request) || request.Confirm != true)
			return c.error("stale");
		local choice = request.Choice;
		if (["wealth", "valor", "companionship"].find(choice) == null) return c.error("invalid");
		if (choice == "companionship") {
			if (!("Actors" in request) || typeof request.Actors != "table") return c.error("invalid");
			foreach (identity in this.Actors)
				if (!(identity in request.Actors) || typeof request.Actors[identity] != "integer"
					|| this.findActor(request.Actors[identity], identity) == null) return c.error("incomplete");
		}
		this.Busy = true;
		try {
			// No callback or reward precedes this commit. A deferred delivery cannot reopen choices.
			if (choice == "companionship") foreach (identity in this.Actors) this.write("actor." + identity, request.Actors[identity]);
			this.write("choice", choice);
			this.deliver();
		} catch (e) { ::logError("[Battle Valkyries] Grail delivery pending: " + e); }
		this.Busy = false;
		::World.State.updateTopbarAssets();
		return { Success = true, Chapter = c.dto(this.ID) };
	},
	dto = function() {
		local choice = this.read("choice", ""), candidates = {}, candidateNames = {}, options = [
			{ ID = "wealth", Name = "$bv{chapter.grail.wish.wealth}", Description = "$bv{chapter.grail.wish.wealth.desc}", Image = "ui/chapters/unclaimed_grail_four_oaths/wish_wealth.jpg" },
			{ ID = "valor", Name = "$bv{chapter.grail.wish.valor}", Description = "$bv{chapter.grail.wish.valor.desc}", Image = "ui/chapters/unclaimed_grail_four_oaths/wish_valor.jpg" },
			{ ID = "companionship", Name = "$bv{chapter.grail.wish.companionship}", Description = "$bv{chapter.grail.wish.companionship.desc}", Image = "ui/chapters/unclaimed_grail_four_oaths/wish_companionship.jpg" }
		];
		foreach (identity in this.Actors) {
			candidates[identity] <- [];
			candidateNames[identity] <- ::$bvvar{namespace}.Valkyries[identity].Name;
			foreach (actor in ::World.getPlayerRoster().getAll()) if (this.findActor(actor.getID(), identity) != null)
				candidates[identity].push({ ID = actor.getID(), Name = actor.getName(), Portrait = ::$bvvar{namespace}.Valkyries[identity].Portrait });
		}
		local pending = choice == "" ? this.cup() == null : choice == "wealth" ? this.read("money_paid") < 500000 : false;
		if (choice == "valor") foreach (key in this.Gear) if (this.read("gear." + key) != 1) pending = true;
		if (choice == "companionship") foreach (identity in this.Actors) if (this.read("blessing." + identity) != 1) pending = true;
		return { Choice = choice, CanChoose = this.safeWorld() && this.cup() != null && choice == "", Options = options, Candidates = candidates, CandidateNames = candidateNames,
			Pending = pending, RemainingCrowns = choice == "wealth" ? 500000 - this.read("money_paid") : 0 };
	}
};
local deliver = ::$bvvar{namespace}.Grail.deliver;
::$bvvar{namespace}.Grail.deliver = function() {
	if (this.Delivering) return;
	this.Delivering = true;
	try { deliver.call(this); }
	catch (e) { this.Delivering = false; throw e; }
	this.Delivering = false;
};
::$bvvar{namespace}.hasGrailBlessing <- function(actor) {
	return actor != null && actor.getFlags().has("$bvvar{modId}.grail.blessed") && actor.getFlags().get("$bvvar{modId}.grail.blessed");
};
::$bvvar{namespace}.consumeGrailGrowth <- function(actor, identity) {
	if (actor == null || this.isActorDeadOrDying(actor) || this.getActorValkyrieID(actor) != identity
		|| !this.hasValkyrieLearnedSkillEntitlement(actor, "grail_" + identity + "_growth")) return;
	local key = "$bvvar{modId}.grail.growth_used";
	if (actor.getFlags().get(key) == true) return;
	actor.getFlags().set(key, true); actor.setFatigue(::Math.max(0, actor.getFatigue() - 5)); actor.setDirty(true);
};
local rewards = ::$bvvar{namespace}.Chapters.syncRewards;
::$bvvar{namespace}.Chapters.syncRewards = function(id) { rewards.call(this, id); if (id == ::$bvvar{namespace}.Grail.ID) ::$bvvar{namespace}.Grail.deliver(); };
local dto = ::$bvvar{namespace}.Chapters.dto;
::$bvvar{namespace}.Chapters.dto = function(id) { local d = dto.call(this, id); if (d != null && id == ::$bvvar{namespace}.Grail.ID && d.Finished) d.Wish <- ::$bvvar{namespace}.Grail.dto(); return d; };
local request = ::$bvvar{namespace}.Chapters.request;
::$bvvar{namespace}.Chapters.request = function(data) {
	if (typeof data == "table" && "ID" in data && data.ID == ::$bvvar{namespace}.Grail.ID && "Action" in data && data.Action == "wish")
		return ::$bvvar{namespace}.Grail.choose(data);
	return request.call(this, data);
};
