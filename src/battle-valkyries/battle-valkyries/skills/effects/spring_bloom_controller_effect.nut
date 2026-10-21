this.spring_bloom_controller_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { LastRound = -1, NextPulse = 0 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.spring_bloom_controller";
		this.m.Name = "$bv{effect.spring.controller.name}"; this.m.Description = "$bv{effect.spring.controller.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/root_parasite.png";
	}
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
	function onTurnStart()
	{
		local owner = this.getContainer().getActor(), bv = ::$bvvar{namespace}, round = ::Time.getRound();
		if (bv.isActorDeadOrDying(owner) || !owner.isPlacedOnMap() || bv.springExtraTurn(owner) || this.m.LastRound == round) return;
		this.m.LastRound = round;
		if (round < this.m.NextPulse) return;
		this.m.NextPulse = round + 2;
		local count = 0;
		foreach (target in bv.getValkyrieEnemyTargetsOnTiles(owner, bv.getValkyrieRadiusTiles(owner.getTile(), 6, false)))
		{
			if (bv.isActorDeadOrDying(owner)) break;
			if (bv.isActorDeadOrDying(target) || !target.isPlayerControlled() || target.getSkills().hasSkill("$bvvar{modId}.effects.spring_root_parasite")) continue;
			local effect = this.new("$bvvar{privateFolder}/skills/effects/spring_root_parasite_effect");
			effect.m.Source = owner.weakref(); target.getSkills().add(effect);
			if (++count >= 2) break;
		}
		owner.getSkills().removeByID("$bvvar{modId}.effects.spring_root_embrace");
		local embrace = this.new("$bvvar{privateFolder}/skills/effects/spring_root_embrace_effect");
		embrace.m.AppliedRound = round; owner.getSkills().add(embrace);
	}
	function clearParasites()
	{
		local owner = this.getContainer().getActor();
		foreach (target in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (target == null) continue;
			local effect = target.getSkills().getSkillByID("$bvvar{modId}.effects.spring_root_parasite");
			if (effect != null && effect.getSource() == owner) { effect.removeSelf(); target.getSkills().update(); target.setDirty(true); }
		}
	}
	function onDeath(fatality) { this.clearParasites(); }
	function onCombatFinished() { this.clearParasites(); this.removeSelf(); }
});
