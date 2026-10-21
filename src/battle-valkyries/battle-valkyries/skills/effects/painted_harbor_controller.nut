this.painted_harbor_controller <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Turns = 0, LastRound = -1, PendingCopies = [], MarkedTiles = [], Marks = [], Reinforced = false },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.painted_harbor_controller";
		this.m.Name = "$bv{enemy.painted_harbor.curator.name}"; this.m.Description = "$bv{enemy.painted_harbor.curator.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/painted_harbor_human_stroke.png"; this.m.IconMini = "status_effect_54_mini";
		this.m.PendingCopies = []; this.m.MarkedTiles = []; this.m.Marks = [];
	},
	function getTooltip()
	{
		local elite = this.getContainer().getActor().m.IsArchivist;
		return [{ id = 1, type = "title", text = elite ? "$bv{enemy.painted_harbor.archivist.name}" : this.getName() },
			{ id = 2, type = "description", text = elite ? "$bv{enemy.painted_harbor.archivist.description}" : this.getDescription() }];
	},
	function queueCopy(tile) { if (tile != null) this.m.PendingCopies.push(tile); },
	function spawnPuppet(origin, copy)
	{
		local owner = this.getContainer().getActor();
		foreach (tile in ::$bvvar{namespace}.getValkyrieRadiusTiles(origin, 2, true))
		{
			if (!tile.IsEmpty || ::Math.abs(tile.Level - origin.Level) > 1) continue;
			local a = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/battle_valkyries/painted_harbor_ink_puppet", tile.Coords.X, tile.Coords.Y);
			a.setFaction(owner.getFaction()); a.m.IsPaintedCopy = copy;
			if (copy) { a.setHitpoints(::Math.max(1, ::Math.floor(a.getHitpointsMax() * 0.5))); a.getSprite("body").Alpha = 170; }
			return true;
		}
		return false;
	},
	function clearWarning()
	{
		// Hide only this controller's decals; never clear another skill's tile overlays.
		foreach (mark in this.m.Marks) mark.Alpha = 0;
		this.m.Marks = []; this.m.MarkedTiles = [];
	},
	function onCombatFinished() { this.clearWarning(); this.m.PendingCopies = []; this.removeSelf(); },
	function onTurnStart()
	{
		local owner = this.getContainer().getActor(), bv = ::$bvvar{namespace};
		if (owner == null || !owner.isAlive() || owner.isDying() || !owner.isPlacedOnMap() || this.m.LastRound == ::Time.getRound()) return;
		this.m.LastRound = ::Time.getRound(); ++this.m.Turns;
		if (owner.m.IsArchivist)
		{
			if (!this.m.Reinforced && owner.getHitpoints() <= owner.getHitpointsMax() * 0.5)
			{
				this.m.Reinforced = true;
				for (local i = 0; i < 3; ++i) this.spawnPuppet(owner.getTile(), false);
			}
			return;
		}
		local pending = this.m.PendingCopies; this.m.PendingCopies = [];
		foreach (tile in pending) this.spawnPuppet(tile, true);
		foreach (target in bv.getValkyrieEnemyTargetsOnTiles(owner, this.m.MarkedTiles))
		{
			if (!owner.isAlive() || owner.isDying()) break;
			if (!target.isAlive() || target.isDying()) continue;
			bv.applyValkyrieFixedHitpointDamage(owner, this, target, 35);
			if (target.isAlive() && !target.isDying()) target.setFatigue(::Math.min(target.getFatigueMax(), target.getFatigue() + 15));
		}
		this.clearWarning();
		if (!owner.isAlive() || owner.isDying() || this.m.Turns % 2 != 0) return;
		local chosen = null;
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (a in group)
			if (a != null && a.isAlive() && !a.isDying() && a.isPlacedOnMap() && a.isAlliedWith(owner)
				&& "IsPaintedPuppet" in a.m && a.m.IsPaintedPuppet && !a.m.IsPaintedCopy && a.m.WetOwner == null
				&& (chosen == null || a.getID() < chosen.getID())) chosen = a;
		if (chosen != null)
		{
			chosen.m.WetOwner = owner.getID(); chosen.m.WetStarted = false;
			chosen.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/painted_harbor_wet_effect"));
			this.spawnIcon("status_effect_54", chosen.getTile());
		}
		if (owner.getHitpoints() > owner.getHitpointsMax() * 0.5) return;
		chosen = null;
		foreach (a in ::World.getPlayerRoster().getAll())
			if (bv.isEligibleValkyrieEnemyTarget(owner, a) && (chosen == null || owner.getTile().getDistanceTo(a.getTile()) < owner.getTile().getDistanceTo(chosen.getTile()))) chosen = a;
		if (chosen == null) return;
		// Snapshot three tiles through the target. Moving the target never moves this line.
		local center = chosen.getTile(), direction = owner.getTile().getDirectionTo(center);
		this.m.MarkedTiles = [center];
		foreach (dir in [direction, (direction + 3) % 6]) if (center.hasNextTile(dir)) this.m.MarkedTiles.push(center.getNextTile(dir));
		foreach (tile in this.m.MarkedTiles)
		{
			local mark = tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, true);
			this.m.Marks.push(mark);
		}
		::Tactical.EventLog.logEx("$bv{enemy.painted_harbor.warning}");
	}
});
