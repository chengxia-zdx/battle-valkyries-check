this.thirteenth_bell_controller <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { LastRound = -1, MarkedTiles = null, Marks = null },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.thirteenth_bell";
		this.m.Name = "$bv{chapter.thirteenth_bell.enemy.controller}"; this.m.Description = "$bv{chapter.thirteenth_bell.enemy.controller_description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/thirteenth_bell_clock.png"; this.m.IconMini = "status_effect_54_mini";
		this.m.MarkedTiles = []; this.m.Marks = [];
	},
	function alive(a) { return a != null && a.isAlive() && !a.isDying() && a.getHitpoints() > 0 && a.isPlacedOnMap(); },
	function allies(role, distance = -1)
	{
		local out = [], owner = this.getContainer().getActor();
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (a in group)
			if (this.alive(a) && a != owner && a.isAlliedWith(owner) && "ClockRole" in a.m && a.m.ClockRole == role
				&& (distance < 0 || owner.getTile().getDistanceTo(a.getTile()) <= distance)) out.push(a);
		return out;
	},
	function phase()
	{
		local a = this.getContainer().getActor();
		if (this.allies("clock").len() > 0) return 1;
		return a.getHitpoints() > a.getHitpointsMax() * 0.5 ? 2 : 3;
	},
	function onBeforeDamageReceived(attacker, skill, hit, p)
	{
		local role = this.getContainer().getActor().m.ClockRole;
		if (role == "keeper") p.DamageReceivedTotalMult *= 1.0 - 0.15 * ::Math.min(3, this.allies("clock").len());
		if (role == "observer" && this.allies("gatekeeper", 2).len() > 0) p.DamageReceivedTotalMult *= 0.65;
	},
	function getTooltip()
	{
		local a = this.getContainer().getActor();
		local out = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }];
		if (a.m.ClockRole == "keeper") out.push({ id = 3, type = "text", icon = "ui/icons/special.png", text = ::format("$bv{chapter.thirteenth_bell.enemy.phase}", this.phase(), this.allies("clock").len()) });
		return out;
	},
	function clearWarning()
	{
		foreach (mark in this.m.Marks) if (mark != null) { mark.Alpha = 0; mark.Visible = false; }
		this.m.Marks = []; this.m.MarkedTiles = [];
	},
	function onDeath(fatality) { this.clearWarning(); },
	function onRemoved() { this.clearWarning(); },
	function onCombatFinished() { this.clearWarning(); this.removeSelf(); },
	function mark(tile)
	{
		if (tile == null) return;
		foreach (old in this.m.MarkedTiles) if (old.ID == tile.ID) return;
		this.m.MarkedTiles.push(tile);
		local mark = tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.None, false, true);
		if (mark != null) this.m.Marks.push(mark);
	},
	function onTurnStart()
	{
		local owner = this.getContainer().getActor(), bv = ::$bvvar{namespace};
		if (!this.alive(owner)) { this.clearWarning(); return; }
		if (!bv.EightValkyries.normal(owner) || this.m.LastRound == ::Time.getRound()) return;
		this.m.LastRound = ::Time.getRound();
		local role = owner.m.ClockRole;
		foreach (target in bv.getValkyrieEnemyTargetsOnTiles(owner, this.m.MarkedTiles))
		{
			if (!this.alive(owner)) break;
			if (this.alive(target)) bv.applyValkyrieFixedHitpointDamage(owner, this, target, role == "keeper" ? 28 : 18);
		}
		this.clearWarning(); if (!this.alive(owner)) return;
		if (role == "lantern" || role == "gatekeeper") return;
		local chosen = null, farthest = role == "observer" || role == "clock";
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (a in group)
			if (this.alive(a) && !a.isAlliedWith(owner) && a.isAttackable()
				&& (chosen == null || (farthest ? owner.getTile().getDistanceTo(a.getTile()) > owner.getTile().getDistanceTo(chosen.getTile()) : owner.getTile().getDistanceTo(a.getTile()) < owner.getTile().getDistanceTo(chosen.getTile())))) chosen = a;
		if (chosen == null) return;
		local center = chosen.getTile(), dir = owner.getTile().getDirectionTo(center);
		this.mark(center);
		if (role == "officer") foreach (d in [dir, (dir + 3) % 6]) { if (center.hasNextTile(d)) this.mark(center.getNextTile(d)); }
		else if (role == "observer") foreach (tile in bv.getValkyrieRadiusTiles(center, 1, false)) this.mark(tile);
		else if (role == "keeper")
		{
			local phase = this.phase();
			if (phase == 2)
			{
				foreach (group in ::Tactical.Entities.getAllInstances()) foreach (a in group)
					if (this.alive(a) && !a.isAlliedWith(owner) && a.isPlayerControlled() && ["rachel_alucard", "es"].find(bv.getActorValkyrieID(a)) != null) this.mark(a.getTile());
			}
			if (phase == 3) foreach (tile in bv.getValkyrieRadiusTiles(center, 2, false))
			{
				local direction = center.getDirectionTo(tile);
				if (direction != dir && direction != (dir + 3) % 6) this.mark(tile);
			}
		}
		::Tactical.EventLog.logEx(owner.getName() + "$bv{chapter.thirteenth_bell.enemy.warning}");
	}
});
