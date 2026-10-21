this.yunki_nightmare_controller <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Turns = 0, MarkTile = null, Split = false },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.yunki_nightmare";
		this.m.Name = "$bv{enemy.yunki_nightmare.name}"; this.m.Description = "$bv{enemy.yunki_nightmare.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/yunki_nightmare.png"; this.m.IconMini <- "status_effect_54_mini";
	}
	function lamps()
	{
		local n = 0, owner = this.getContainer().getActor();
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (actor in group)
			if (actor != null && actor.isAlive() && !actor.isDying() && actor.isAlliedWith(owner) && "IsYunkiLamp" in actor.m && actor.m.IsYunkiLamp) ++n;
		return ::Math.min(3, n);
	}
	function onBeforeDamageReceived(attacker, skill, hit, properties) { properties.DamageReceivedTotalMult *= 1.0 - 0.20 * this.lamps(); }
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{enemy.yunki_nightmare.lamps}" + this.lamps() + "/3" }]; }
	function clearWarning()
	{
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (actor in group) if (actor != null && actor.isAlive()) actor.getSkills().removeByID("$bvvar{modId}.effects.yunki_mist_warning");
		this.m.MarkTile = null;
	}
	function onTurnStart()
	{
		local owner = this.getContainer().getActor(); if (owner == null || !owner.isAlive() || owner.isDying()) return;
		++this.m.Turns;
		if (this.m.MarkTile != null)
		{
			foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner, ::$bvvar{namespace}.getValkyrieRadiusTiles(this.m.MarkTile, 1, true)))
			{
				if (!owner.isAlive() || owner.isDying()) break;
				if (!target.isAlive() || target.isDying()) continue;
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, target, 40);
				if (target.isAlive() && !target.isDying()) target.setFatigue(::Math.min(target.getFatigueMax(), target.getFatigue() + 20));
			}
			this.clearWarning();
		}
		if (!owner.isAlive() || owner.isDying()) return;
		if (!this.m.Split && owner.getHitpoints() <= owner.getHitpointsMax() * 0.5)
		{
			this.m.Split = true; local count = 0;
			foreach (tile in ::$bvvar{namespace}.getValkyrieRadiusTiles(owner.getTile(), 2, false))
			{
				if (count >= 3) break; if (!tile.IsEmpty) continue;
				local shade = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/battle_valkyries/yunki_nightmare_phantom", tile.Coords.X, tile.Coords.Y);
				shade.setFaction(owner.getFaction()); ++count;
			}
		}
		// Alternate front and rear pressure, always telegraphing a stationary tile.
		{
			local chosen = null, distance = 0, nearest = this.m.Turns % 2 == 1;
			foreach (target in ::World.getPlayerRoster().getAll())
			{
				if (!target.isAlive() || target.isDying() || !target.isPlacedOnMap()) continue;
				local d = owner.getTile().getDistanceTo(target.getTile());
				if (chosen == null || (nearest ? d < distance : d > distance)) { chosen = target; distance = d; }
			}
			if (chosen != null)
			{
				this.m.MarkTile = chosen.getTile();
				local warning = ::new("$bvvar{privateFolder}/skills/effects/yunki_mist_warning_effect");
				chosen.getSkills().add(warning);
				this.spawnIcon("status_effect_54", chosen.getTile());
				::Tactical.EventLog.logEx("$bv{enemy.yunki_nightmare.warning}" + chosen.getName());
			}
		}
	}
});
