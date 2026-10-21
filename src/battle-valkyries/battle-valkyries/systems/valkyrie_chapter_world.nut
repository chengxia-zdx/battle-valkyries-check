local chapters = ::$bvvar{namespace}.Chapters;
chapters.near <- function(location)
{
	return location != null && ::World.State != null && ::World.State.getPlayer() != null && ::World.State.getPlayer().getTile().getDistanceTo(location.getTile()) <= 1;
};
chapters.hasLocationAtTile <- function(tile, except = null)
{
	// A dying camp clears IsOccupied in onFinish after its battlefield has spawned.
	// Query the entities too: the remaining battlefield can intercept map clicks.
	foreach (locations in [::World.EntityManager.getLocations(), ::World.EntityManager.getSettlements()])
		foreach (loc in locations)
			if (loc != null && (except == null || loc.getID() != except.getID()) && loc.getTile().getDistanceTo(tile) == 0) return true;
	return false;
};
chapters.isUsableLocation <- function(loc, id, node)
{
	if (loc == null || !loc.isAlive() || loc.getFlags().get("BVChapterID") != id || loc.getFlags().get("BVChapterNode") != node) return false;
	local d = this.definition(id);
	if (d == null || !(node in d.Nodes) || this.hasLocationAtTile(loc.getTile(), loc)) return false;
	// Repair saved ownership before cleanup can mistake a wounded camp for an invalid objective.
	if (d.Nodes[node].Battle && "repairChapterFaction" in loc) loc.repairChapterFaction();
	return !d.Nodes[node].Battle || (loc.isAttackable() && !loc.isAlliedWithPlayer() && loc.getTroops().len() > 0);
};
chapters.findLocation <- function(id, node)
{
	if (::World == null || ::World.EntityManager == null) return null;
	foreach (loc in ::World.EntityManager.getLocations())
		if (this.isUsableLocation(loc, id, node)) return loc;
	return null;
};
chapters.supplier <- function(id)
{
	if (::World == null || ::World.EntityManager == null || ::World.State.getPlayer() == null) return null;
	local closest = null, distance = 99999, saved = this.read(id, "supplier", -1), playerTile = ::World.State.getPlayer().getTile();
	foreach (town in ::World.EntityManager.getSettlements())
	{
		if (town.getID() == saved) return town;
		local d = playerTile.getDistanceTo(town.getTile()); if (d < distance) { closest = town; distance = d; }
	}
	return closest;
};
chapters.reveal <- function(location)
{
	if (location == null || !location.isAlive()) return;
	location.setVisibleInFogOfWar(true); location.setDiscovered(true);
	if (location.hasSprite("selection")) location.getSprite("selection").Visible = true;
	::World.uncoverFogOfWar(location.getTile().Pos, 500.0);
};
chapters.spawnTile <- function(id, maxDistance = 10)
{
	if (::World.State == null || ::World.State.getPlayer() == null) return null;
	local center = ::World.State.getPlayer().getTile(), gate = this.findLocation(id, "ward_home");
	if (gate != null) center = gate.getTile();
	for (local radius = 2; radius <= maxDistance; ++radius)
		for (local x = center.SquareCoords.X - radius; x <= center.SquareCoords.X + radius; ++x)
			for (local y = center.SquareCoords.Y - radius; y <= center.SquareCoords.Y + radius; ++y)
			{
				if (!::World.isValidTileSquare(x, y)) continue;
				local tile = ::World.getTileSquare(x, y);
				if (tile.IsOccupied || tile.Type == ::Const.World.TerrainType.Ocean || tile.Type == ::Const.World.TerrainType.Shore || tile.getDistanceTo(center) < 2) continue;
				if (this.hasLocationAtTile(tile)) continue;
				return tile;
			}
	return null;
};
chapters.ensureLocations <- function(id)
{
	local d = this.definition(id), s = this.stage(id); if (s == null || ::World.EntityManager == null) return;
	this.cleanupLocations(id);
	foreach (goal in s.Goals)
	{
		if (this.read(id, "goal." + goal.Key) == 1 || this.findLocation(id, goal.Node) != null) continue;
		local tile = this.spawnTile(id); if (tile == null) { ::logWarning("[Battle Valkyries] Chapter objective placement deferred: " + goal.Node); continue; }
		try
		{
			local def = this.definition(id);
			local loc = ::World.spawnLocation("LocationScript" in def ? def.LocationScript : "scripts/entity/world/locations/battle_valkyries/yunki_chapter_location", tile.Coords);
			loc.getFlags().set("BVChapterID", id); loc.getFlags().set("BVChapterNode", goal.Node);
			loc.configure(); loc.onSpawned(); this.reveal(loc);
		}
		catch (e) { ::logError("[Battle Valkyries] Chapter location failed: " + e); }
	}
};
chapters.cleanupLocations <- function(id)
{
	if (::World == null || ::World.EntityManager == null) return;
	local s = this.stage(id), keep = {}, retained = {};
	if (s != null) foreach (g in s.Goals) if (this.read(id, "goal." + g.Key) != 1) keep[g.Node] <- true;
	local remove = [];
	foreach (loc in ::World.EntityManager.getLocations())
	{
		if (loc == null || loc.getFlags().get("BVChapterID") != id) continue;
		local node = loc.getFlags().get("BVChapterNode");
		if (!(node in keep) || node in retained || !this.isUsableLocation(loc, id, node)) remove.push(loc);
		else retained[node] <- true;
	}
	foreach (loc in remove)
	{
		if (loc.hasSprite("selection")) loc.getSprite("selection").Visible = false;
		// Do not destroy a fading entity twice or invoke victory/loot callbacks.
		if (loc.isAlive()) loc.die();
	}
};
chapters.focus <- function(id, node)
{
	local s = this.stage(id), allowed = false;
	if (s != null) foreach (g in s.Goals) if (g.Node == node) allowed = true;
	if (!allowed) return this.error("invalid");
	this.ensureLocations(id);
	local loc = this.findLocation(id, node);
	if (loc == null) return this.error("unavailable");
	::World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
	::World.getCamera().setPos(loc.getPos());
	return { Success = true, Close = true };
};
chapters.battleWon <- function(id, node)
{
	local s = this.stage(id); if (s == null) return;
	local context = this.Battle;
	if (context == null || context.ID != id || context.Node != node) return;
	foreach (actorID in this.definition(id).Actors)
	{
		local actor = this.actor(actorID);
		if (!(actorID in context.Participants) || actor == null || actor.isDying() || actor.getHitpoints() <= 0 || actor.getID() != context.Participants[actorID]) return;
	}
	foreach (g in s.Goals) if (g.Node == node && "Battle" in g && g.Battle) this.write(id, "goal." + g.Key, 1);
};
chapters.Battle <- null;
chapters.request <- function(request)
{
	if (typeof request != "table" || !("ID" in request) || this.definition(request.ID) == null || !("Action" in request)) return this.error("invalid");
	if (::World == null || ::World.Assets == null || ::World.State == null) return this.error("unavailable");
	local id = request.ID;
	if (request.Action == "start") return this.start(id);
	if (request.Action == "refresh") { this.syncRewards(id); this.cleanupLocations(id); this.ensureLocations(id); return { Success = true, Chapter = this.dto(id) }; }
	if (request.Action == "focus" && "Node" in request) return this.focus(id, request.Node);
	if (!("Stage" in request) || typeof request.Stage != "integer") return this.error("invalid");
	if (request.Action == "submit") return this.submit(id, request.Stage);
	if (request.Action == "interact" && "Key" in request) return this.interact(id, request.Key, request.Stage);
	if (request.Action == "choose" && "Key" in request && "Choice" in request && typeof request.Choice == "string") return this.interact(id, request.Key, request.Stage, request.Choice);
	if (request.Action == "purchase" && "Key" in request) return this.purchase(id, request.Key, request.Stage);
	return this.error("invalid");
};
