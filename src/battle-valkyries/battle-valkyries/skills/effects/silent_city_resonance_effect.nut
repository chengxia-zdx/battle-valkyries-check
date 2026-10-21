this.silent_city_resonance_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Charging = false, Broken = false, Attackers = {}, LastRound = -1, NextCharge = 0, ReleaseRound = 0 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.silent_city_resonance";
		this.m.Name = "$bv{enemy.silent_city.resonance.name}"; this.m.Description = "$bv{enemy.silent_city.resonance.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/togawa_sakiko_crescent_echo.png"; this.m.IconMini = "status_effect_54_mini";
		this.m.Attackers = {};
	},
	function getTooltip()
	{
		return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = this.m.Charging ? "$bv{enemy.silent_city.resonance.progress}" + this.m.Attackers.len() + "/3" : (this.m.Broken ? "$bv{enemy.silent_city.resonance.broken}" : "$bv{enemy.silent_city.resonance.rest}") }];
	},
	function recordHit(attacker, skill, context, fixed, damage)
	{
		local owner = this.getContainer().getActor(), bv = ::$bvvar{namespace};
		if (!this.m.Charging || damage <= 0 || fixed || context == null || bv.isActorDeadOrDying(owner) || bv.isActorDeadOrDying(attacker)) return;
		if (!bv.isDirectAttack(skill) || bv.isCounterOrAOO(context) || bv.isValkyrieFollowup(context)) return;
		if (context.Source != "managed_active" && context.Source != "direct" && context.Source != "free") return;
		if (!attacker.isPlacedOnMap() || !attacker.isPlayerControlled() || owner.isAlliedWith(attacker)) return;
		local rosterMember = false; foreach (a in ::World.getPlayerRoster().getAll()) if (a == attacker) rosterMember = true;
		if (!rosterMember) return;
		this.m.Attackers[attacker.getID()] <- true;
		if (this.m.Attackers.len() < 3) return;
		this.m.Charging = false; this.m.Broken = true; owner.getSkills().update(); owner.setDirty(true);
		::Tactical.EventLog.logEx("$bv{enemy.silent_city.resonance.interrupted}");
	},
	function onUpdate(properties) { if (this.m.Broken) { properties.MeleeDefense -= 20; properties.RangedDefense -= 20; } },
	function onTurnStart()
	{
		local owner = this.getContainer().getActor(), round = ::Time.getRound(), bv = ::$bvvar{namespace};
		if (bv.isActorDeadOrDying(owner) || !owner.isPlacedOnMap() || round == this.m.LastRound) return;
		this.m.LastRound = round;
		// A full intervening round guarantees a response window regardless of initiative or waiting.
		if (round >= this.m.ReleaseRound)
		{
			if (this.m.Charging)
			{
				this.m.Charging = false;
				foreach (target in bv.getValkyrieEnemyTargetsOnTiles(owner, bv.getValkyrieRadiusTiles(owner.getTile(), 2, false)))
				{
					if (bv.isActorDeadOrDying(owner)) break;
					if (bv.isActorDeadOrDying(target)) continue;
					bv.applyValkyrieFixedHitpointDamage(owner, this, target, 25);
					if (!bv.isActorDeadOrDying(target)) target.setFatigue(::Math.min(target.getFatigueMax(), target.getFatigue() + 20));
				}
				::Tactical.EventLog.logEx("$bv{enemy.silent_city.resonance.release}");
			}
			this.m.Broken = false;
		}
		if (round >= this.m.NextCharge && !bv.isActorDeadOrDying(owner))
		{
			this.m.Attackers = {}; this.m.Charging = true; this.m.ReleaseRound = round + 2; this.m.NextCharge = round + 4;
			this.spawnIcon("status_effect_54", owner.getTile()); ::Tactical.EventLog.logEx("$bv{enemy.silent_city.resonance.warning}");
		}
		owner.getSkills().update(); owner.setDirty(true);
	},
	function onDeath(fatality) { this.m.Charging = false; this.m.Broken = false; this.m.Attackers = {}; },
	function onCombatFinished() { this.onDeath(0); this.removeSelf(); }
});
