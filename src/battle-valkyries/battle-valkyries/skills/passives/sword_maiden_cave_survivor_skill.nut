this.sword_maiden_cave_survivor_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }

	function isControlled( _target )
	{
		if (_target == null) return false;
		try { if (_target.getCurrentProperties().IsRooted) return true; } catch (e) {}
		local skills = _target.getSkills();
		foreach (id in ["effects.net", "effects.web", "effects.rooted", "effects.stunned", "effects.dazed"])
		{
			if (skills.hasSkill(id)) return true;
		}
		return false;
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_properties != null && ::$bvvar{namespace}.isDirectAttack(_skill) && this.isControlled(_target)) _properties.DamageTotalMult *= 1.15;
	}

	function onTurnStart()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return;
		local skills = actor.getSkills();
		foreach (id in ["effects.net", "effects.web", "effects.rooted"])
		{
			local effect = skills.getSkillByID(id);
			if (effect == null) continue;
			skills.remove(effect);
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 2));
			actor.setDirty(true);
			break;
		}
	}

	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/action_points.png", text="$bv{skill.sword_maiden_cave_survivor.tooltip.escape}" },
			{ id=4, type="text", icon="ui/icons/regular_damage.png", text="$bv{skill.sword_maiden_cave_survivor.tooltip.damage}" }
		];
	}
});
